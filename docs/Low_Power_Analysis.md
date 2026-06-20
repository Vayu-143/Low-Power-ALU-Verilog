Low-Power Design Analysis

Objective:
Reduce unnecessary switching activity inside the ALU.

Technique Used:
Operand Isolation

Implementation:

A_iso = enable ? A : 0;
B_iso = enable ? B : 0;

Benefits:
- Reduced dynamic power
- Reduced switching activity
- Lower heat generation

Limitation:
This is RTL-level power optimization and does not include
power gating, multi-Vt cells, DVFS, or clock gating.