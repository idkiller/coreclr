// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.

.assembly extern legacy library mscorlib {}
.assembly extern System.Console
{
  .publickeytoken = (B0 3F 5F 7F 11 D5 0A 3A )
  .ver 4:0:0:0
}
.assembly ILGEN_0x144897ef {}
.class ILGEN_0x144897ef {
.field static	unsigned int8 field_0x4
.method static int32 Main() {
.entrypoint
.maxstack	20

 ldsfld unsigned int8 ILGEN_0x144897ef::field_0x4
 neg
 stsfld unsigned int8 ILGEN_0x144897ef::field_0x4

 ldc.i4 100
 ret
}
}
