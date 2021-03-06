; RUN: llc -march=amdgcn -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefix=GCN %s
; RUN: llc -march=amdgcn -mcpu=tonga -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefix=GCN %s

declare float @llvm.fabs.f32(float) #1
declare double @llvm.fabs.f64(double) #1

; GCN-LABEL: {{^}}test_isinf_pattern:
; GCN: v_mov_b32_e32 [[MASK:v[0-9]+]], 0x204{{$}}
; GCN: v_cmp_class_f32_e32 vcc, s{{[0-9]+}}, [[MASK]]
; GCN-NOT: v_cmp
; GCN: s_endpgm
define amdgpu_kernel void @test_isinf_pattern(i32 addrspace(1)* nocapture %out, float %x) #0 {
  %fabs = tail call float @llvm.fabs.f32(float %x) #1
  %cmp = fcmp oeq float %fabs, 0x7FF0000000000000
  %ext = zext i1 %cmp to i32
  store i32 %ext, i32 addrspace(1)* %out, align 4
  ret void
}

; GCN-LABEL: {{^}}test_not_isinf_pattern_0:
; GCN-NOT: v_cmp_class
; GCN: s_endpgm
define amdgpu_kernel void @test_not_isinf_pattern_0(i32 addrspace(1)* nocapture %out, float %x) #0 {
  %fabs = tail call float @llvm.fabs.f32(float %x) #1
  %cmp = fcmp ueq float %fabs, 0x7FF0000000000000
  %ext = zext i1 %cmp to i32
  store i32 %ext, i32 addrspace(1)* %out, align 4
  ret void
}

; GCN-LABEL: {{^}}test_not_isinf_pattern_1:
; GCN-NOT: v_cmp_class
; GCN: s_endpgm
define amdgpu_kernel void @test_not_isinf_pattern_1(i32 addrspace(1)* nocapture %out, float %x) #0 {
  %fabs = tail call float @llvm.fabs.f32(float %x) #1
  %cmp = fcmp oeq float %fabs, 0xFFF0000000000000
  %ext = zext i1 %cmp to i32
  store i32 %ext, i32 addrspace(1)* %out, align 4
  ret void
}

; GCN-LABEL: {{^}}test_isfinite_pattern_0:
; GCN-NOT: v_cmp
; GCN: v_mov_b32_e32 [[MASK:v[0-9]+]], 0x1f8{{$}}
; GCN: v_cmp_class_f32_e32 vcc, s{{[0-9]+}}, [[MASK]]
; GCN-NOT: v_cmp
; GCN: s_endpgm
define amdgpu_kernel void @test_isfinite_pattern_0(i32 addrspace(1)* nocapture %out, float %x) #0 {
  %ord = fcmp ord float %x, 0.000000e+00
  %x.fabs = tail call float @llvm.fabs.f32(float %x) #1
  %ninf = fcmp une float %x.fabs, 0x7FF0000000000000
  %and = and i1 %ord, %ninf
  %ext = zext i1 %and to i32
  store i32 %ext, i32 addrspace(1)* %out, align 4
  ret void
}

; Use negative infinity
; GCN-LABEL: {{^}}test_isfinite_not_pattern_0:
; GCN-NOT: v_cmp_class_f32
; GCN: s_endpgm
define amdgpu_kernel void @test_isfinite_not_pattern_0(i32 addrspace(1)* nocapture %out, float %x) #0 {
  %ord = fcmp ord float %x, 0.000000e+00
  %x.fabs = tail call float @llvm.fabs.f32(float %x) #1
  %ninf = fcmp une float %x.fabs, 0xFFF0000000000000
  %and = and i1 %ord, %ninf
  %ext = zext i1 %and to i32
  store i32 %ext, i32 addrspace(1)* %out, align 4
  ret void
}

; No fabs
; GCN-LABEL: {{^}}test_isfinite_not_pattern_1:
; GCN-NOT: v_cmp_class_f32
; GCN: s_endpgm
define amdgpu_kernel void @test_isfinite_not_pattern_1(i32 addrspace(1)* nocapture %out, float %x) #0 {
  %ord = fcmp ord float %x, 0.000000e+00
  %ninf = fcmp une float %x, 0x7FF0000000000000
  %and = and i1 %ord, %ninf
  %ext = zext i1 %and to i32
  store i32 %ext, i32 addrspace(1)* %out, align 4
  ret void
}

; fabs of different value
; GCN-LABEL: {{^}}test_isfinite_not_pattern_2:
; GCN-NOT: v_cmp_class_f32
; GCN: s_endpgm
define amdgpu_kernel void @test_isfinite_not_pattern_2(i32 addrspace(1)* nocapture %out, float %x, float %y) #0 {
  %ord = fcmp ord float %x, 0.000000e+00
  %x.fabs = tail call float @llvm.fabs.f32(float %y) #1
  %ninf = fcmp une float %x.fabs, 0x7FF0000000000000
  %and = and i1 %ord, %ninf
  %ext = zext i1 %and to i32
  store i32 %ext, i32 addrspace(1)* %out, align 4
  ret void
}

; Wrong ordered compare type
; GCN-LABEL: {{^}}test_isfinite_not_pattern_3:
; GCN-NOT: v_cmp_class_f32
; GCN: s_endpgm
define amdgpu_kernel void @test_isfinite_not_pattern_3(i32 addrspace(1)* nocapture %out, float %x) #0 {
  %ord = fcmp uno float %x, 0.000000e+00
  %x.fabs = tail call float @llvm.fabs.f32(float %x) #1
  %ninf = fcmp une float %x.fabs, 0x7FF0000000000000
  %and = and i1 %ord, %ninf
  %ext = zext i1 %and to i32
  store i32 %ext, i32 addrspace(1)* %out, align 4
  ret void
}

; Wrong unordered compare
; GCN-LABEL: {{^}}test_isfinite_not_pattern_4:
; GCN-NOT: v_cmp_class_f32
; GCN: s_endpgm
define amdgpu_kernel void @test_isfinite_not_pattern_4(i32 addrspace(1)* nocapture %out, float %x) #0 {
  %ord = fcmp ord float %x, 0.000000e+00
  %x.fabs = tail call float @llvm.fabs.f32(float %x) #1
  %ninf = fcmp one float %x.fabs, 0x7FF0000000000000
  %and = and i1 %ord, %ninf
  %ext = zext i1 %and to i32
  store i32 %ext, i32 addrspace(1)* %out, align 4
  ret void
}

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone }
