; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare void @use(<2 x i1>)

define i32 @select_xor_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_xor_icmp2(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_icmp2(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp ne i32 %x, 0
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %y, i32 %B
  ret i32 %C
}

define i32 @select_xor_icmp_meta(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_icmp_meta(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]], !prof !0
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y, !prof !0
  ret i32 %C
}

define i32 @select_mul_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_mul_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 1
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 1
  %B = mul i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_add_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_add_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = add i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_or_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_or_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = or i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_and_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_and_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], -1
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, -1
  %B = and i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define <2 x i8> @select_xor_icmp_vec(<2 x i8> %x, <2 x i8> %y, <2 x i8> %z) {
; CHECK-LABEL: @select_xor_icmp_vec(
; CHECK-NEXT:    [[A:%.*]] = icmp eq <2 x i8> [[X:%.*]], zeroinitializer
; CHECK-NEXT:    [[C:%.*]] = select <2 x i1> [[A]], <2 x i8> [[Z:%.*]], <2 x i8> [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[C]]
;
  %A = icmp eq <2 x i8>  %x, <i8 0, i8 0>
  %B = xor <2 x i8>  %x, %z
  %C = select <2 x i1>  %A, <2 x i8>  %B, <2 x i8>  %y
  ret <2 x i8>  %C
}

define <2 x i8> @select_xor_icmp_vec_use(<2 x i8> %x, <2 x i8> %y, <2 x i8> %z) {
; CHECK-LABEL: @select_xor_icmp_vec_use(
; CHECK-NEXT:    [[A:%.*]] = icmp ne <2 x i8> [[X:%.*]], zeroinitializer
; CHECK-NEXT:    call void @use(<2 x i1> [[A]])
; CHECK-NEXT:    [[C:%.*]] = select <2 x i1> [[A]], <2 x i8> [[Y:%.*]], <2 x i8> [[Z:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[C]]
;
  %A = icmp ne <2 x i8>  %x, <i8 0, i8 0>
  call void @use(<2 x i1> %A)
  %B = xor <2 x i8>  %x, %z
  %C = select <2 x i1>  %A, <2 x i8>  %y, <2 x i8>  %B
  ret <2 x i8>  %C
}

define i32 @select_xor_inv_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_inv_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = xor i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_xor_inv_icmp2(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_inv_icmp2(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp ne i32 %x, 0
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %y, i32 %B
  ret i32 %C
}

; TODO: Support for FP opcodes
define float @select_fadd_icmp(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_icmp(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], -0.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, -0.0
  %B = fadd float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fadd_icmp2(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_icmp2(
; CHECK-NEXT:    [[A:%.*]] = fcmp ueq float [[X:%.*]], -0.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp ueq float %x, -0.0
  %B = fadd float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fmul_icmp(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fmul_icmp(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 1.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fmul float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 1.0
  %B = fmul float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

; TODO: Support for non-commutative opcodes
define i32 @select_sub_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_sub_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[B:%.*]] = sub i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = sub i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_shl_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_shl_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[B:%.*]] = shl i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = shl i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_lshr_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_lshr_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[B:%.*]] = lshr i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = lshr i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_ashr_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_ashr_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[B:%.*]] = ashr i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = ashr i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

; Negative tests
define i32 @select_xor_icmp_bad_1(i32 %x, i32 %y, i32 %z, i32 %k) {
; CHECK-LABEL: @select_xor_icmp_bad_1(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], [[K:%.*]]
; CHECK-NEXT:    [[B:%.*]] = xor i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, %k
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_xor_icmp_bad_2(i32 %x, i32 %y, i32 %z, i32 %k) {
; CHECK-LABEL: @select_xor_icmp_bad_2(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[B:%.*]] = xor i32 [[K:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = xor i32 %k, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_xor_icmp_bad_3(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_icmp_bad_3(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 3
; CHECK-NEXT:    [[B:%.*]] = xor i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 3
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_xor_icmp_bad_4(i32 %x, i32 %y, i32 %z, i32 %k) {
; CHECK-LABEL: @select_xor_icmp_bad_4(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], [[K:%.*]]
; CHECK-NEXT:    [[B:%.*]] = xor i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, %k
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_xor_icmp_bad_5(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_icmp_bad_5(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[B:%.*]] = xor i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Y:%.*]], i32 [[B]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp ne i32 %x, 0
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_xor_icmp_bad_6(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_icmp_bad_6(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = xor i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp ne i32 %x, 1
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %y, i32 %B
  ret i32 %C
}

define <2 x i8> @select_xor_icmp_vec_bad(<2 x i8> %x, <2 x i8> %y, <2 x i8> %z) {
; CHECK-LABEL: @select_xor_icmp_vec_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq <2 x i8> [[X:%.*]], <i8 5, i8 3>
; CHECK-NEXT:    [[B:%.*]] = xor <2 x i8> [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select <2 x i1> [[A]], <2 x i8> [[B]], <2 x i8> [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[C]]
;
  %A = icmp eq <2 x i8>  %x, <i8 5, i8 3>
  %B = xor <2 x i8>  %x, %z
  %C = select <2 x i1>  %A, <2 x i8>  %B, <2 x i8>  %y
  ret <2 x i8>  %C
}

; TODO: support for undefs, check for an identity constant does not handle them yet
define <2 x i8> @select_xor_icmp_vec_bad_2(<2 x i8> %x, <2 x i8> %y, <2 x i8> %z) {
; CHECK-LABEL: @select_xor_icmp_vec_bad_2(
; CHECK-NEXT:    [[A:%.*]] = icmp eq <2 x i8> [[X:%.*]], <i8 0, i8 undef>
; CHECK-NEXT:    [[B:%.*]] = xor <2 x i8> [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select <2 x i1> [[A]], <2 x i8> [[B]], <2 x i8> [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[C]]
;
  %A = icmp eq <2 x i8>  %x, <i8 0, i8 undef>
  %B = xor <2 x i8>  %x, %z
  %C = select <2 x i1>  %A, <2 x i8>  %B, <2 x i8>  %y
  ret <2 x i8>  %C
}

define i32 @select_mul_icmp_bad(i32 %x, i32 %y, i32 %z, i32 %k) {
; CHECK-LABEL: @select_mul_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 3
; CHECK-NEXT:    [[B:%.*]] = mul i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 3
  %B = mul i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_add_icmp_bad(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_add_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = add i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 1
  %B = add i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_and_icmp_bad(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_and_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[B:%.*]] = and i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = and i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_or_icmp_bad(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_or_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 3
; CHECK-NEXT:    [[B:%.*]] = or i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 3
  %B = or i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define float @select_fadd_icmp_bad(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], -1.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, -1.0
  %B = fadd float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fadd_icmp_bad_2(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_icmp_bad_2(
; CHECK-NEXT:    [[A:%.*]] = fcmp ueq float [[X:%.*]], -1.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp ueq float %x, -1.0
  %B = fadd float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fmul_icmp_bad(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fmul_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 3.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fmul float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 3.0
  %B = fmul float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fdiv_icmp_bad(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fdiv_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 3.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fdiv float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 3.0
  %B = fdiv float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fsub_icmp_bad(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fsub_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 1.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fsub float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 1.0
  %B = fsub float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define i32 @select_sub_icmp_bad(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_sub_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = sub i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 1
  %B = sub i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_sub_icmp_bad_sub_inv(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_sub_icmp_bad_sub_inv(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[B:%.*]] = sub i32 [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = sub i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_shl_icmp_bad(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_shl_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = shl i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 1
  %B = shl i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_lshr_icmp_bad(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_lshr_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = lshr i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 1
  %B = lshr i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_ashr_icmp_bad(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_ashr_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = ashr i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 1
  %B = ashr i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

!0 = !{!"branch_weights", i32 2, i32 10}
