/***************************************************************************
# Copyright (c) 2017, NVIDIA CORPORATION. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#  * Neither the name of NVIDIA CORPORATION nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
***************************************************************************/
__import ShaderCommon;
__import DefaultVS;

shared cbuffer PerFrameCB
{
	float3 gRightEyePosW;
};

struct GeometryOut
{
    VertexOut vsOut;
    uint rtIndex : SV_RenderTargetArrayIndex;
};

[maxvertexcount(6)]
void main(triangle VertexOut input[3], inout TriangleStream<GeometryOut> outStream)
{
    GeometryOut gsOut;

    // Left Eye
    for (int i = 0; i < 3; i++)
    {
        gsOut.rtIndex = 0;
        gsOut.vsOut = input[i];

        float4 posW = float4(input[i].posW, 1.0f);
        gsOut.vsOut.posH = mul(posW, gCamera.viewProjMat);
        gsOut.vsOut.prevPosH = mul(posW, gCamera.prevViewProjMat);
		//gsOut.vsOut.prevPosH = float4(normalize(posW.xyz - gCamera.posW),1);

        outStream.Append(gsOut);
    }
    outStream.RestartStrip();

    // Right Eye
    for (int i = 0; i < 3; i++) 
    {
        gsOut.rtIndex = 1;
        gsOut.vsOut = input[i];

        float4 posW = float4(input[i].posW, 1.0f);
        gsOut.vsOut.posH = mul(posW, gCamera.rightEyeViewProjMat);
        gsOut.vsOut.prevPosH = mul(posW, gCamera.rightEyePrevViewProjMat);
		//gsOut.vsOut.prevPosH = float4(normalize(posW.xyz - gRightEyePosW),1);

        outStream.Append(gsOut);
    }
    outStream.RestartStrip();
}