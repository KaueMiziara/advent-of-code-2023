const fs = require('fs');

function main() {
  fs.readFile('input.txt', (err, data) => {
    if (err) throw new Error("data :(");

    const [rawPipelines] = data.toString().trim().split(/\n\n/gm);
    const pipelines = parsePipelines(rawPipelines);

    const buckets = initializeBuckets(pipelines);

    buckets.get('in').items.add([]);

    let moved = true;

    while (moved) {
      moved = false;

      for (const [name, { pipeline, items }] of buckets) {
        if (name === 'R' || name === 'A') continue;

        for (const item of items) {
          moved = true;
          items.delete(item);
          let pastRules = [...item];

          for (const rule of pipeline.rules) {
            const newItem = createNewItem(pastRules, rule);
            buckets.get(rule.target).items.add(newItem);
            pastRules.push({ prop: rule.prop, passes: (x) => !rule.passes(x) });
          }
        }
      }
    }

    const props = ['x', 'm', 'a', 's'];

    const allPassing = calculateAllPassing(buckets.get('A').items, props);

    console.log(allPassing.reduce((a, b) => a + b, 0));
  });
}

function parsePipelines(rawPipelines) {
  return rawPipelines.trim().split('\n').map(rawPipeline => {
    const [name, rawRules] = rawPipeline.replace('}', '').split('{');
    const rules = rawRules.split(',').map(rawRule => parseRule(rawRule));
    return { name, rules };
  });
}

function parseRule(rawRule) {
  if (!rawRule.includes(':')) {
    return { passes: () => true, target: rawRule, empty: true };
  }

  const [rawCondition, target] = rawRule.split(':');
  let condition = rawCondition.includes('>') ? isBigger : isSmaller;
  const [prop, rawLimit] = rawCondition.split(/\>|\</);
  const limit = Number(rawLimit);

  return { passes: (item) => condition(item[prop], limit), target, prop, empty: false };
}

function initializeBuckets(pipelines) {
  const buckets = new Map([['A', { items: new Set() }], ['R', { items: new Set() }]]);

  for (const pipeline of pipelines) {
    buckets.set(pipeline.name, { pipeline, items: new Set() });
  }

  return buckets;
}

function createNewItem(pastRules, rule) {
  const newItem = [...pastRules];

  if (!rule.empty) {
    newItem.push({ prop: rule.prop, passes: rule.passes });
  }

  return newItem;
}

function calculateAllPassing(items, props) {
  return [...items].map(rules => {
    let totalPassing = 1;

    for (const prop of props) {
      const relevantRules = rules.filter(x => x.prop === prop);
      let passing = 0;

      for (let i = 1; i <= 4000; i++) {
        if (relevantRules.every(x => x.passes({ [prop]: i }))) {
          passing++;
        }
      }

      totalPassing *= passing;
    }

    return totalPassing;
  });
}

function isBigger(a, b) {
  return a > b;
}

function isSmaller(a, b) {
  return a < b;
}

main();
