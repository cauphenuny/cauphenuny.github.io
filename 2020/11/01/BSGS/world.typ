#import "@local/typst-sympy-calculator-preset:0.1.0": *
#import "@local/theme-default:0.1.0": conf
#show: doc => conf(
  header: "",
  title: "",
  author: "",
  doc
)

#import "@preview/ctheorems:1.1.2": *
#show: thmrules.with(qed-symbol: $square$)
#let example = thmplain("example", "例").with(numbering: none)
#let solution = thmplain("solution", "解").with(numbering: none)
#let answer = thmplain("solution", "答案").with(numbering: none)
#let proof = thmproof("proof", "证明")
#let definition = thmbox("definition", "定义", inset: (x: 1.2em, top: 1em))
#let _inset = (y: 0.6em, x:1.2em)
#let theorem = thmbox("theorem", "定理", fill: rgb("dff3f9"))
#let trick = thmbox("trick", "技巧", fill: rgb("f8e8e8"), inset: _inset).with(numbering: none)
#let corollary = thmbox("corollary", "推论", base: "theorem", fill: rgb("#e8f8e8"), inset: _inset).with(numbering: none)
#let lemma = thmbox("corollary", "引理", base: "theorem", fill: rgb("#e8f8e8"), inset: _inset).with(numbering: none)
#let conclusion = thmbox("conclusion", "结论",fill: rgb("#dff3f9")).with(numbering: none)
#let problem = thmbox("problem", "例", fill: rgb("#f4f4f4"))
#let exercise = thmbox("exercise", "", base_level: 0,titlefmt: strong, fill: rgb("#f4f4f4"))

#set enum(numbering: "1.a.i)")
#show math.equation: eq => math.display[ #eq ]
#let numbered_eq(content) = math.equation(
  block: true,
  numbering: "(1.1.1)",
  content,
)
#let Re=math.op("Re"); #let Im=math.op("Im"); #let Ln=math.op("Ln")
#let pm=math.plus.minus
#let ii=math.upright("i"); #let ramuno=ii
#let ee=math.upright("e"); #let euler=ee; #let eu=euler

= Hello World!
