//
// Copyright Contributors to the MaterialX Project
// SPDX-License-Identifier: Apache-2.0
//

#include "CompileMSL.h"

#include <string>
#include <streambuf>

#include <MaterialXGenShader/ShaderGenerator.h>

#import <Metal/Metal.h>
id<MTLDevice> device = nil;

void CompileMSLShader(const char* pShaderFilePath, const char* pEntryFuncName)
{
    NSError* _Nullable error = nil;
    if(device == nil)
        device = MTLCreateSystemDefaultDevice();
    
    NSString* filepath = [NSString stringWithUTF8String:pShaderFilePath];
    NSString* shadersource = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    if(error != nil)
    {
       throw MaterialX::ExceptionShaderGenError("Cannot load file '" + std::string(pShaderFilePath) + "'.");
        return;
    }
    
    MTLCompileOptions* options = [MTLCompileOptions new];
#if MAC_OS_VERSION_11_0
    if (@available(macOS 11.0, ios 14.0, *))
        options.languageVersion = MTLLanguageVersion2_3;
    else
#endif
        options.languageVersion = MTLLanguageVersion2_0;
    options.fastMathEnabled = true;
    
    [device newLibraryWithSource:shadersource options:options error:&error];
    if(error != nil)
    {
        throw MaterialX::ExceptionShaderGenError("Failed to create library out of '" + std::string(pShaderFilePath) + "'.");
        return;
    }
}