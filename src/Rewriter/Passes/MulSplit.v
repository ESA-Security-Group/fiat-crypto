Require Import Coq.ZArith.ZArith.
Require Import Rewriter.Language.Language.
Require Import Crypto.Language.API.
Require Import Rewriter.Language.Wf.
Require Import Crypto.Language.WfExtra.
Require Import Crypto.Rewriter.AllTacticsExtra.
Require Import Crypto.Rewriter.RulesProofs.

Module Compilers.
  Import Language.Compilers.
  Import Language.API.Compilers.
  Import Language.Wf.Compilers.
  Import Language.WfExtra.Compilers.
  Import Rewriter.AllTacticsExtra.Compilers.RewriteRules.GoalType.
  Import Rewriter.AllTactics.Compilers.RewriteRules.Tactic.
  Import Compilers.Classes.

  Module Import RewriteRules.
    Section __.
      Context (bitwidth : Z)
              (lgcarrymax : Z).

      Definition VerifiedRewriterMulSplit : VerifiedRewriter_with_args false (mul_split_rewrite_rules_proofs bitwidth lgcarrymax).
      Proof using All. make_rewriter. Defined.

      Definition RewriteMulSplit {t} := Eval hnf in @Rewrite VerifiedRewriterMulSplit t.

      Lemma Wf_RewriteMulSplit {t} e (Hwf : Wf e) : Wf (@RewriteMulSplit t e).
      Proof. now apply VerifiedRewriterMulSplit. Qed.

      Lemma Interp_RewriteMulSplit {t} e (Hwf : Wf e) : API.Interp (@RewriteMulSplit t e) == API.Interp e.
      Proof. now apply VerifiedRewriterMulSplit. Qed.
    End __.
  End RewriteRules.

  Module Export Hints.
    Hint Resolve Wf_RewriteMulSplit : wf wf_extra.
    Hint Rewrite @Interp_RewriteMulSplit : interp interp_extra.
  End Hints.
End Compilers.
