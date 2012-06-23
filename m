Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52728 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2FWIHh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jun 2012 04:07:37 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so3165053obb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jun 2012 01:07:37 -0700 (PDT)
From: Andrew Mahone <andrew.mahone@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Andrew Mahone <andrew.mahone@gmail.com>
Subject: [PATCH 1/5] btrfs: lz4: import lz4/lz4hc C and header files
Date: Sat, 23 Jun 2012 04:05:44 -0400
Message-Id: <1340438748-348-2-git-send-email-andrew.mahone@gmail.com>
In-Reply-To: <1340438748-348-1-git-send-email-andrew.mahone@gmail.com>
References: <1340438748-348-1-git-send-email-andrew.mahone@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Andrew Mahone <andrew.mahone@gmail.com>
---
 fs/btrfs/lz4.c   | 843 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/lz4.h   | 128 +++++++++
 fs/btrfs/lz4hc.c | 685 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/lz4hc.h |  58 ++++
 4 files changed, 1714 insertions(+)
 create mode 100644 fs/btrfs/lz4.c
 create mode 100644 fs/btrfs/lz4.h
 create mode 100644 fs/btrfs/lz4hc.c
 create mode 100644 fs/btrfs/lz4hc.h

diff --git a/fs/btrfs/lz4.c b/fs/btrfs/lz4.c
new file mode 100644
index 0000000..87d18fe
--- /dev/null
+++ b/fs/btrfs/lz4.c
@@ -0,0 +1,843 @@
+/*
+   LZ4 - Fast LZ compression algorithm
+   Copyright (C) 2011-2012, Yann Collet.
+   BSD 2-Clause License (http://www.opensource.org/licenses/bsd-license.php)
+
+   Redistribution and use in source and binary forms, with or without
+   modification, are permitted provided that the following conditions are
+   met:
+
+       * Redistributions of source code must retain the above copyright
+   notice, this list of conditions and the following disclaimer.
+       * Redistributions in binary form must reproduce the above
+   copyright notice, this list of conditions and the following disclaimer
+   in the documentation and/or other materials provided with the
+   distribution.
+
+   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+/*
+ * With authors permission dual licensed as BSD/GPL for linux kernel
+ *
+ * Origin: http://lz4.googlecode.com/svn/trunk
+ * Revision: 62
+ */
+
+//**************************************
+// Tuning parameters
+//**************************************
+// COMPRESSIONLEVEL :
+// Increasing this value improves compression ratio
+// Lowering this value reduces memory usage
+// Reduced memory usage typically improves speed, due to cache effect (ex : L1 32KB for Intel, L1 64KB for AMD)
+// Memory usage formula : N->2^(N+2) Bytes (examples : 12 -> 16KB ; 17 -> 512KB)
+#define COMPRESSIONLEVEL 12
+
+// NOTCOMPRESSIBLE_CONFIRMATION :
+// Decreasing this value will make the algorithm skip faster data segments considered "incompressible"
+// This may decrease compression ratio dramatically, but will be faster on incompressible data
+// Increasing this value will make the algorithm search more before declaring a segment "incompressible"
+// This could improve compression a bit, but will be slower on incompressible data
+// The default value (6) is recommended
+#define NOTCOMPRESSIBLE_CONFIRMATION 6
+
+// LZ4_COMPRESSMIN :
+// Compression function will *fail* if it is not successful at compressing input by at least LZ4_COMPRESSMIN bytes
+// Since the compression function stops working prematurely, it results in a speed gain
+// The output however is unusable. Compression function result will be zero.
+// Default : 0 = disabled
+#define LZ4_COMPRESSMIN 0
+
+// BIG_ENDIAN_NATIVE_BUT_INCOMPATIBLE :
+// This will provide a boost to performance for big endian cpu, but the resulting compressed stream will be incompatible with little-endian CPU.
+// You can set this option to 1 in situations where data will stay within closed environment
+// This option is useless on Little_Endian CPU (such as x86)
+//#define BIG_ENDIAN_NATIVE_BUT_INCOMPATIBLE 1
+
+
+
+//**************************************
+// CPU Feature Detection
+//**************************************
+// 32 or 64 bits ?
+#if (defined(__x86_64__) || defined(__x86_64) || defined(__amd64__) || defined(__amd64) || defined(__ppc64__) || defined(_WIN64) || defined(__LP64__) || defined(_LP64) )   // Detects 64 bits mode
+#define LZ4_ARCH64 1
+#else
+#define LZ4_ARCH64 0
+#endif
+
+// Little Endian or Big Endian ?
+#if (defined(__BIG_ENDIAN__) || defined(__BIG_ENDIAN) || defined(_BIG_ENDIAN) || defined(_ARCH_PPC) || defined(__PPC__) || defined(__PPC) || defined(PPC) || defined(__powerpc__) || defined(__powerpc) || defined(powerpc) || ((defined(__BYTE_ORDER__)&&(__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__))) )
+#define LZ4_BIG_ENDIAN 1
+#else
+// Little Endian assumed. PDP Endian and other very rare endian format are unsupported.
+#endif
+
+// Unaligned memory access is automatically enabled for "common" CPU, such as x86.
+// For others CPU, the compiler will be more cautious, and insert extra code to ensure aligned access is respected
+// If you know your target CPU supports unaligned memory access, you may want to force this option manually to improve performance
+#if defined(__ARM_FEATURE_UNALIGNED)
+#define LZ4_FORCE_UNALIGNED_ACCESS 1
+#endif
+
+// Uncomment this parameter if your target system or compiler does not support hardware bit count
+//#define LZ4_FORCE_SW_BITCOUNT
+
+
+
+//**************************************
+// Compiler Options
+//**************************************
+#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L // C99
+/* "restrict" is a known keyword */
+#else
+#define restrict // Disable restrict
+#endif
+
+#define GCC_VERSION (__GNUC__ * 100 + __GNUC_MINOR__)
+
+#ifdef _MSC_VER  // Visual Studio
+#define inline __forceinline // Visual is not C99, but supports some kind of inline
+#include <intrin.h>          // _BitScanForward
+#endif
+
+#ifdef _MSC_VER
+#define lz4_bswap16(x) _byteswap_ushort(x)
+#else
+#define lz4_bswap16(x) ((unsigned short int) ((((x) >> 8) & 0xffu) | (((x) & 0xffu) << 8)))
+#endif
+
+#if (GCC_VERSION >= 302) || (__INTEL_COMPILER >= 800) || defined(__clang__)
+# define expect(expr,value)    (__builtin_expect ((expr),(value)) )
+#else
+# define expect(expr,value)    (expr)
+#endif
+
+
+//**************************************
+// Includes
+//**************************************
+#ifdef __KERNEL__
+#include <linux/string.h>
+#include <linux/bug.h>
+#define malloc(size)	({ BUG(); (void*)0; })
+#define free(ptr)	({ BUG(); (void*)0; })
+#else
+#include <stdlib.h>   // for malloc
+#include <string.h>   // for memset
+#include "lz4.h"
+#endif
+
+
+//**************************************
+// Basic Types
+//**************************************
+#if defined(_MSC_VER)    // Visual Studio does not support 'stdint' natively
+#define BYTE	unsigned __int8
+#define U16		unsigned __int16
+#define U32		unsigned __int32
+#define S32		__int32
+#define U64		unsigned __int64
+#else
+#ifdef __KERNEL__
+#include <asm/byteorder.h>
+#include <linux/types.h>
+#define BYTE	u8
+#define U16	u16
+#define U32	u32
+#define S32	s32
+#define U64	u64
+
+#else
+#include <stdint.h>
+#define BYTE	uint8_t
+#define U16		uint16_t
+#define U32		uint32_t
+#define S32		int32_t
+#define U64		uint64_t
+#endif // __KERNEL__
+#endif
+
+#ifndef LZ4_FORCE_UNALIGNED_ACCESS
+#pragma pack(push, 1)
+#endif
+
+typedef struct _U16_S { U16 v; } U16_S;
+typedef struct _U32_S { U32 v; } U32_S;
+typedef struct _U64_S { U64 v; } U64_S;
+
+#ifndef LZ4_FORCE_UNALIGNED_ACCESS
+#pragma pack(pop)
+#endif
+
+#define A64(x) (((U64_S *)(x))->v)
+#define A32(x) (((U32_S *)(x))->v)
+#define A16(x) (((U16_S *)(x))->v)
+
+
+//**************************************
+// Constants
+//**************************************
+#define MINMATCH 4
+
+#define HASH_LOG COMPRESSIONLEVEL
+#define HASHTABLESIZE (1 << HASH_LOG)
+#define HASH_MASK (HASHTABLESIZE - 1)
+
+#define SKIPSTRENGTH (NOTCOMPRESSIBLE_CONFIRMATION>2?NOTCOMPRESSIBLE_CONFIRMATION:2)
+#define STACKLIMIT 13
+#define HEAPMODE (HASH_LOG>STACKLIMIT)  // Defines if memory is allocated into the stack (local variable), or into the heap (malloc()).
+#define COPYLENGTH 8
+#define LASTLITERALS 5
+#define MFLIMIT (COPYLENGTH+MINMATCH)
+#define MINLENGTH (MFLIMIT+1)
+
+#define MAXD_LOG 16
+#define MAX_DISTANCE ((1 << MAXD_LOG) - 1)
+
+#define ML_BITS 4
+#define ML_MASK ((1U<<ML_BITS)-1)
+#define RUN_BITS (8-ML_BITS)
+#define RUN_MASK ((1U<<RUN_BITS)-1)
+
+/*
+ * Disable on-stack context allocation for linux kernel
+ */
+#undef STACKLIMIT
+#define STACKLIMIT 0
+
+
+//**************************************
+// Architecture-specific macros
+//**************************************
+#if LZ4_ARCH64	// 64-bit
+#define STEPSIZE 8
+#define UARCH U64
+#define AARCH A64
+#define LZ4_COPYSTEP(s,d)		A64(d) = A64(s); d+=8; s+=8;
+#define LZ4_COPYPACKET(s,d)		LZ4_COPYSTEP(s,d)
+#define LZ4_SECURECOPY(s,d,e)	if (d<e) LZ4_WILDCOPY(s,d,e)
+#define HTYPE U32
+#define INITBASE(base)			const BYTE* const base = ip
+#else		// 32-bit
+#define STEPSIZE 4
+#define UARCH U32
+#define AARCH A32
+#define LZ4_COPYSTEP(s,d)		A32(d) = A32(s); d+=4; s+=4;
+#define LZ4_COPYPACKET(s,d)		LZ4_COPYSTEP(s,d); LZ4_COPYSTEP(s,d);
+#define LZ4_SECURECOPY			LZ4_WILDCOPY
+#define HTYPE const BYTE*
+#define INITBASE(base)			const int base = 0
+#endif
+
+#if (defined(LZ4_BIG_ENDIAN) && !defined(BIG_ENDIAN_NATIVE_BUT_INCOMPATIBLE))
+#define LZ4_READ_LITTLEENDIAN_16(d,s,p) { U16 v = A16(p); v = lz4_bswap16(v); d = (s) - v; }
+#define LZ4_WRITE_LITTLEENDIAN_16(p,i)  { U16 v = (U16)(i); v = lz4_bswap16(v); A16(p) = v; p+=2; }
+#else		// Little Endian
+#define LZ4_READ_LITTLEENDIAN_16(d,s,p) { d = (s) - A16(p); }
+#define LZ4_WRITE_LITTLEENDIAN_16(p,v)  { A16(p) = v; p+=2; }
+#endif
+
+
+//**************************************
+// Local structures
+//**************************************
+struct refTables
+{
+	HTYPE hashTable[HASHTABLESIZE];
+};
+
+
+//**************************************
+// Macros
+//**************************************
+#define LZ4_HASH_FUNCTION(i)	(((i) * 2654435761U) >> ((MINMATCH*8)-HASH_LOG))
+#define LZ4_HASH_VALUE(p)		LZ4_HASH_FUNCTION(A32(p))
+#define LZ4_WILDCOPY(s,d,e)		do { LZ4_COPYPACKET(s,d) } while (d<e);
+#define LZ4_BLINDCOPY(s,d,l)	{ BYTE* e=(d)+l; LZ4_WILDCOPY(s,d,e); d=e; }
+
+
+//****************************
+// Private functions
+//****************************
+#if LZ4_ARCH64
+
+inline static int LZ4_NbCommonBytes (register U64 val)
+{
+#if defined(LZ4_BIG_ENDIAN)
+    #if defined(_MSC_VER) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    unsigned long r = 0;
+    _BitScanReverse64( &r, val );
+    return (int)(r>>3);
+    #elif defined(__GNUC__) && (GCC_VERSION >= 304) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    return (__builtin_clzll(val) >> 3);
+    #else
+	int r;
+	if (!(val>>32)) { r=4; } else { r=0; val>>=32; }
+	if (!(val>>16)) { r+=2; val>>=8; } else { val>>=24; }
+	r += (!val);
+	return r;
+    #endif
+#else
+    #if defined(_MSC_VER) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    unsigned long r = 0;
+    _BitScanForward64( &r, val );
+    return (int)(r>>3);
+    #elif defined(__GNUC__) && (GCC_VERSION >= 304) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    return (__builtin_ctzll(val) >> 3);
+    #else
+	static const int DeBruijnBytePos[64] = { 0, 0, 0, 0, 0, 1, 1, 2, 0, 3, 1, 3, 1, 4, 2, 7, 0, 2, 3, 6, 1, 5, 3, 5, 1, 3, 4, 4, 2, 5, 6, 7, 7, 0, 1, 2, 3, 3, 4, 6, 2, 6, 5, 5, 3, 4, 5, 6, 7, 1, 2, 4, 6, 4, 4, 5, 7, 2, 6, 5, 7, 6, 7, 7 };
+	return DeBruijnBytePos[((U64)((val & -val) * 0x0218A392CDABBD3F)) >> 58];
+    #endif
+#endif
+}
+
+#else
+
+inline static int LZ4_NbCommonBytes (register U32 val)
+{
+#if defined(LZ4_BIG_ENDIAN)
+    #if defined(_MSC_VER) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    unsigned long r = 0;
+    _BitScanReverse( &r, val );
+    return (int)(r>>3);
+    #elif defined(__GNUC__) && (GCC_VERSION >= 304) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    return (__builtin_clz(val) >> 3);
+    #else
+	int r;
+	if (!(val>>16)) { r=2; val>>=8; } else { r=0; val>>=24; }
+	r += (!val);
+	return r;
+    #endif
+#else
+    #if defined(_MSC_VER) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    unsigned long r = 0;
+    _BitScanForward( &r, val );
+    return (int)(r>>3);
+    #elif defined(__GNUC__) && (GCC_VERSION >= 304) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    return (__builtin_ctz(val) >> 3);
+    #else
+	static const int DeBruijnBytePos[32] = { 0, 0, 3, 0, 3, 1, 3, 0, 3, 2, 2, 1, 3, 2, 0, 1, 3, 3, 1, 2, 2, 2, 2, 0, 3, 1, 2, 0, 1, 0, 1, 1 };
+	return DeBruijnBytePos[((U32)((val & -(S32)val) * 0x077CB531U)) >> 27];
+    #endif
+#endif
+}
+
+#endif
+
+
+//****************************
+// Public functions
+//****************************
+
+int LZ4_compressBound(int isize)
+{
+	return (isize + (isize/255) + 16);
+}
+
+
+
+//******************************
+// Compression functions
+//******************************
+
+int LZ4_compressCtx(void** ctx,
+				 const char* source,
+				 char* dest,
+				 int isize)
+{
+#if HEAPMODE
+	struct refTables *srt = (struct refTables *) (*ctx);
+	HTYPE* HashTable;
+#else
+	HTYPE HashTable[HASHTABLESIZE] = {0};
+#endif
+
+	const BYTE* ip = (BYTE*) source;
+	INITBASE(base);
+	const BYTE* anchor = ip;
+	const BYTE* const iend = ip + isize;
+	const BYTE* const mflimit = iend - MFLIMIT;
+#define matchlimit (iend - LASTLITERALS)
+
+	BYTE* op = (BYTE*) dest;
+
+	int len, length;
+	const int skipStrength = SKIPSTRENGTH;
+	U32 forwardH;
+
+
+	// Init
+	if (isize<MINLENGTH) goto _last_literals;
+#if HEAPMODE
+	if (*ctx == NULL)
+	{
+		srt = (struct refTables *) malloc ( sizeof(struct refTables) );
+		*ctx = (void*) srt;
+	}
+	HashTable = (HTYPE*)(srt->hashTable);
+	memset((void*)HashTable, 0, sizeof(srt->hashTable));
+#else
+	(void) ctx;
+#endif
+
+
+	// First Byte
+	HashTable[LZ4_HASH_VALUE(ip)] = ip - base;
+	ip++; forwardH = LZ4_HASH_VALUE(ip);
+
+	// Main Loop
+    for ( ; ; )
+	{
+		int findMatchAttempts = (1U << skipStrength) + 3;
+		const BYTE* forwardIp = ip;
+		const BYTE* ref;
+		BYTE* token;
+
+		// Find a match
+		do {
+			U32 h = forwardH;
+			int step = findMatchAttempts++ >> skipStrength;
+			ip = forwardIp;
+			forwardIp = ip + step;
+
+			if (unlikely(forwardIp > mflimit)) { goto _last_literals; }
+
+			forwardH = LZ4_HASH_VALUE(forwardIp);
+			ref = base + HashTable[h];
+			HashTable[h] = ip - base;
+
+		} while ((ref < ip - MAX_DISTANCE) || (A32(ref) != A32(ip)));
+
+		// Catch up
+		while ((ip>anchor) && (ref>(BYTE*)source) && unlikely(ip[-1]==ref[-1])) { ip--; ref--; }
+
+		// Encode Literal length
+		length = ip - anchor;
+		token = op++;
+		if (length>=(int)RUN_MASK) { *token=(RUN_MASK<<ML_BITS); len = length-RUN_MASK; for(; len > 254 ; len-=255) *op++ = 255; *op++ = (BYTE)len; }
+		else *token = (length<<ML_BITS);
+
+		// Copy Literals
+		LZ4_BLINDCOPY(anchor, op, length);
+
+_next_match:
+		// Encode Offset
+		LZ4_WRITE_LITTLEENDIAN_16(op,ip-ref);
+
+		// Start Counting
+		ip+=MINMATCH; ref+=MINMATCH;   // MinMatch verified
+		anchor = ip;
+		while (likely(ip<matchlimit-(STEPSIZE-1)))
+		{
+			UARCH diff = AARCH(ref) ^ AARCH(ip);
+			if (!diff) { ip+=STEPSIZE; ref+=STEPSIZE; continue; }
+			ip += LZ4_NbCommonBytes(diff);
+			goto _endCount;
+		}
+		if (LZ4_ARCH64) if ((ip<(matchlimit-3)) && (A32(ref) == A32(ip))) { ip+=4; ref+=4; }
+		if ((ip<(matchlimit-1)) && (A16(ref) == A16(ip))) { ip+=2; ref+=2; }
+		if ((ip<matchlimit) && (*ref == *ip)) ip++;
+_endCount:
+
+		// Encode MatchLength
+		len = (ip - anchor);
+		if (len>=(int)ML_MASK) { *token+=ML_MASK; len-=ML_MASK; for(; len > 509 ; len-=510) { *op++ = 255; *op++ = 255; } if (len > 254) { len-=255; *op++ = 255; } *op++ = (BYTE)len; }
+		else *token += len;
+
+		// Test end of chunk
+		if (ip > mflimit) { anchor = ip;  break; }
+
+		// Fill table
+		HashTable[LZ4_HASH_VALUE(ip-2)] = ip - 2 - base;
+
+		// Test next position
+		ref = base + HashTable[LZ4_HASH_VALUE(ip)];
+		HashTable[LZ4_HASH_VALUE(ip)] = ip - base;
+		if ((ref > ip - (MAX_DISTANCE + 1)) && (A32(ref) == A32(ip))) { token = op++; *token=0; goto _next_match; }
+
+		// Prepare next loop
+		anchor = ip++;
+		forwardH = LZ4_HASH_VALUE(ip);
+	}
+
+_last_literals:
+	// Encode Last Literals
+	{
+		int lastRun = iend - anchor;
+		if ((LZ4_COMPRESSMIN>0) && (((op - (BYTE*)dest) + lastRun + 1 + ((lastRun-15)/255)) > isize - LZ4_COMPRESSMIN)) return 0;
+		if (lastRun>=(int)RUN_MASK) { *op++=(RUN_MASK<<ML_BITS); lastRun-=RUN_MASK; for(; lastRun > 254 ; lastRun-=255) *op++ = 255; *op++ = (BYTE) lastRun; }
+		else *op++ = (lastRun<<ML_BITS);
+		memcpy(op, anchor, iend - anchor);
+		op += iend-anchor;
+	}
+
+	// End
+	return (int) (((char*)op)-dest);
+}
+
+
+
+// Note : this function is valid only if isize < LZ4_64KLIMIT
+#define LZ4_64KLIMIT ((1<<16) + (MFLIMIT-1))
+#define HASHLOG64K (HASH_LOG+1)
+#define HASH64KTABLESIZE (1U<<HASHLOG64K)
+#define LZ4_HASH64K_FUNCTION(i)	(((i) * 2654435761U) >> ((MINMATCH*8)-HASHLOG64K))
+#define LZ4_HASH64K_VALUE(p)	LZ4_HASH64K_FUNCTION(A32(p))
+int LZ4_compress64kCtx(void** ctx,
+				 const char* source,
+				 char* dest,
+				 int isize)
+{
+#if HEAPMODE
+	struct refTables *srt = (struct refTables *) (*ctx);
+	U16* HashTable;
+#else
+	U16 HashTable[HASH64KTABLESIZE] = {0};
+#endif
+
+	const BYTE* ip = (BYTE*) source;
+	const BYTE* anchor = ip;
+	const BYTE* const base = ip;
+	const BYTE* const iend = ip + isize;
+	const BYTE* const mflimit = iend - MFLIMIT;
+#define matchlimit (iend - LASTLITERALS)
+
+	BYTE* op = (BYTE*) dest;
+
+	int len, length;
+	const int skipStrength = SKIPSTRENGTH;
+	U32 forwardH;
+
+
+	// Init
+	if (isize<MINLENGTH) goto _last_literals;
+#if HEAPMODE
+	if (*ctx == NULL)
+	{
+		srt = (struct refTables *) malloc ( sizeof(struct refTables) );
+		*ctx = (void*) srt;
+	}
+	HashTable = (U16*)(srt->hashTable);
+	memset((void*)HashTable, 0, sizeof(srt->hashTable));
+#else
+	(void) ctx;
+#endif
+
+
+	// First Byte
+	ip++; forwardH = LZ4_HASH64K_VALUE(ip);
+
+	// Main Loop
+    for ( ; ; )
+	{
+		int findMatchAttempts = (1U << skipStrength) + 3;
+		const BYTE* forwardIp = ip;
+		const BYTE* ref;
+		BYTE* token;
+
+		// Find a match
+		do {
+			U32 h = forwardH;
+			int step = findMatchAttempts++ >> skipStrength;
+			ip = forwardIp;
+			forwardIp = ip + step;
+
+			if (forwardIp > mflimit) { goto _last_literals; }
+
+			forwardH = LZ4_HASH64K_VALUE(forwardIp);
+			ref = base + HashTable[h];
+			HashTable[h] = ip - base;
+
+		} while (A32(ref) != A32(ip));
+
+		// Catch up
+		while ((ip>anchor) && (ref>(BYTE*)source) && (ip[-1]==ref[-1])) { ip--; ref--; }
+
+		// Encode Literal length
+		length = ip - anchor;
+		token = op++;
+		if (length>=(int)RUN_MASK) { *token=(RUN_MASK<<ML_BITS); len = length-RUN_MASK; for(; len > 254 ; len-=255) *op++ = 255; *op++ = (BYTE)len; }
+		else *token = (length<<ML_BITS);
+
+		// Copy Literals
+		LZ4_BLINDCOPY(anchor, op, length);
+
+_next_match:
+		// Encode Offset
+		LZ4_WRITE_LITTLEENDIAN_16(op,ip-ref);
+
+		// Start Counting
+		ip+=MINMATCH; ref+=MINMATCH;   // MinMatch verified
+		anchor = ip;
+		while (ip<matchlimit-(STEPSIZE-1))
+		{
+			UARCH diff = AARCH(ref) ^ AARCH(ip);
+			if (!diff) { ip+=STEPSIZE; ref+=STEPSIZE; continue; }
+			ip += LZ4_NbCommonBytes(diff);
+			goto _endCount;
+		}
+		if (LZ4_ARCH64) if ((ip<(matchlimit-3)) && (A32(ref) == A32(ip))) { ip+=4; ref+=4; }
+		if ((ip<(matchlimit-1)) && (A16(ref) == A16(ip))) { ip+=2; ref+=2; }
+		if ((ip<matchlimit) && (*ref == *ip)) ip++;
+_endCount:
+
+		// Encode MatchLength
+		len = (ip - anchor);
+		if (len>=(int)ML_MASK) { *token+=ML_MASK; len-=ML_MASK; for(; len > 509 ; len-=510) { *op++ = 255; *op++ = 255; } if (len > 254) { len-=255; *op++ = 255; } *op++ = (BYTE)len; }
+		else *token += len;
+
+		// Test end of chunk
+		if (ip > mflimit) { anchor = ip;  break; }
+
+		// Fill table
+		HashTable[LZ4_HASH64K_VALUE(ip-2)] = ip - 2 - base;
+
+		// Test next position
+		ref = base + HashTable[LZ4_HASH64K_VALUE(ip)];
+		HashTable[LZ4_HASH64K_VALUE(ip)] = ip - base;
+		if (A32(ref) == A32(ip)) { token = op++; *token=0; goto _next_match; }
+
+		// Prepare next loop
+		anchor = ip++;
+		forwardH = LZ4_HASH64K_VALUE(ip);
+	}
+
+_last_literals:
+	// Encode Last Literals
+	{
+		int lastRun = iend - anchor;
+		if ((LZ4_COMPRESSMIN>0) && (((op - (BYTE*)dest) + lastRun + 1 + ((lastRun-15)/255)) > isize - LZ4_COMPRESSMIN)) return 0;
+		if (lastRun>=(int)RUN_MASK) { *op++=(RUN_MASK<<ML_BITS); lastRun-=RUN_MASK; for(; lastRun > 254 ; lastRun-=255) *op++ = 255; *op++ = (BYTE) lastRun; }
+		else *op++ = (lastRun<<ML_BITS);
+		memcpy(op, anchor, iend - anchor);
+		op += iend-anchor;
+	}
+
+	// End
+	return (int) (((char*)op)-dest);
+}
+
+
+
+int LZ4_compress(const char* source,
+				 char* dest,
+				 int isize)
+{
+#if HEAPMODE
+	void* ctx = malloc(sizeof(struct refTables));
+	int result;
+	if (isize < LZ4_64KLIMIT)
+		result = LZ4_compress64kCtx(&ctx, source, dest, isize);
+	else result = LZ4_compressCtx(&ctx, source, dest, isize);
+	free(ctx);
+	return result;
+#else
+	if (isize < (int)LZ4_64KLIMIT) return LZ4_compress64kCtx(NULL, source, dest, isize);
+	return LZ4_compressCtx(NULL, source, dest, isize);
+#endif
+}
+
+
+
+
+//****************************
+// Decompression functions
+//****************************
+
+// Note : The decoding functions LZ4_uncompress() and LZ4_uncompress_unknownOutputSize()
+//		are safe against "buffer overflow" attack type.
+//		They will never write nor read outside of the provided output buffers.
+//      LZ4_uncompress_unknownOutputSize() also insures that it will never read outside of the input buffer.
+//		A corrupted input will produce an error result, a negative int, indicating the position of the error within input stream.
+
+int LZ4_uncompress(const char* source,
+				 char* dest,
+				 int osize)
+{
+	// Local Variables
+	const BYTE* restrict ip = (const BYTE*) source;
+	const BYTE* restrict ref;
+
+	BYTE* restrict op = (BYTE*) dest;
+	BYTE* const oend = op + osize;
+	BYTE* cpy;
+
+	BYTE token;
+
+	int	len, length;
+	size_t dec[] ={0, 3, 2, 3, 0, 0, 0, 0};
+
+
+	// Main Loop
+	while (1)
+	{
+		// get runlength
+		token = *ip++;
+		if ((length=(token>>ML_BITS)) == RUN_MASK)  { for (;(len=*ip++)==255;length+=255){} length += len; }
+
+		// copy literals
+		cpy = op+length;
+		if (unlikely(cpy>oend-COPYLENGTH))
+		{
+			if (cpy > oend) goto _output_error;
+			memcpy(op, ip, length);
+			ip += length;
+			break;    // Necessarily EOF
+		}
+		LZ4_WILDCOPY(ip, op, cpy); ip -= (op-cpy); op = cpy;
+
+		// get offset
+		LZ4_READ_LITTLEENDIAN_16(ref,cpy,ip); ip+=2;
+		if (ref < (BYTE* const)dest) goto _output_error;
+
+		// get matchlength
+		if ((length=(token&ML_MASK)) == ML_MASK) { for (;*ip==255;length+=255) {ip++;} length += *ip++; }
+
+		// copy repeated sequence
+		if (unlikely(op-ref<STEPSIZE))
+		{
+#if LZ4_ARCH64
+			size_t dec2table[]={0, 0, 0, -1, 0, 1, 2, 3};
+			size_t dec2 = dec2table[op-ref];
+#else
+			const int dec2 = 0;
+#endif
+			*op++ = *ref++;
+			*op++ = *ref++;
+			*op++ = *ref++;
+			*op++ = *ref++;
+			ref -= dec[op-ref];
+			A32(op)=A32(ref); op += STEPSIZE-4;
+			ref -= dec2;
+		} else { LZ4_COPYSTEP(ref,op); }
+		cpy = op + length - (STEPSIZE-4);
+		if (cpy>oend-COPYLENGTH)
+		{
+			if (cpy > oend) goto _output_error;
+			LZ4_SECURECOPY(ref, op, (oend-COPYLENGTH));
+			while(op<cpy) *op++=*ref++;
+			op=cpy;
+			if (op == oend) break;    // Check EOF (should never happen, since last 5 bytes are supposed to be literals)
+			continue;
+		}
+		LZ4_SECURECOPY(ref, op, cpy);
+		op=cpy;		// correction
+	}
+
+	// end of decoding
+	return (int) (((char*)ip)-source);
+
+	// write overflow error detected
+_output_error:
+	return (int) (-(((char*)ip)-source));
+}
+
+
+int LZ4_uncompress_unknownOutputSize(
+				const char* source,
+				char* dest,
+				int isize,
+				int maxOutputSize)
+{
+	// Local Variables
+	const BYTE* restrict ip = (const BYTE*) source;
+	const BYTE* const iend = ip + isize;
+	const BYTE* restrict ref;
+
+	BYTE* restrict op = (BYTE*) dest;
+	BYTE* const oend = op + maxOutputSize;
+	BYTE* cpy;
+
+	size_t dec[] ={0, 3, 2, 3, 0, 0, 0, 0};
+
+
+	// Main Loop
+	while (ip<iend)
+	{
+		BYTE token;
+		int length;
+
+		// get runlength
+		token = *ip++;
+		if ((length=(token>>ML_BITS)) == RUN_MASK) { int s=255; while ((ip<iend) && (s==255)) { s=*ip++; length += s; } }
+
+		// copy literals
+		cpy = op+length;
+		if ((cpy>oend-COPYLENGTH) || (ip+length>iend-COPYLENGTH))
+		{
+			if (cpy > oend) goto _output_error;
+			if (ip+length > iend) goto _output_error;
+			memcpy(op, ip, length);
+			op += length;
+			ip += length;
+			if (ip<iend) goto _output_error;
+			break;    // Necessarily EOF, due to parsing restrictions
+		}
+		LZ4_WILDCOPY(ip, op, cpy); ip -= (op-cpy); op = cpy;
+
+		// get offset
+		LZ4_READ_LITTLEENDIAN_16(ref,cpy,ip); ip+=2;
+		if (ref < (BYTE* const)dest) goto _output_error;
+
+		// get matchlength
+		if ((length=(token&ML_MASK)) == ML_MASK) { while (ip<iend) { int s = *ip++; length +=s; if (s==255) continue; break; } }
+
+		// copy repeated sequence
+		if (unlikely(op-ref<STEPSIZE))
+		{
+#if LZ4_ARCH64
+			size_t dec2table[]={0, 0, 0, -1, 0, 1, 2, 3};
+			size_t dec2 = dec2table[op-ref];
+#else
+			const int dec2 = 0;
+#endif
+			*op++ = *ref++;
+			*op++ = *ref++;
+			*op++ = *ref++;
+			*op++ = *ref++;
+			ref -= dec[op-ref];
+			A32(op)=A32(ref); op += STEPSIZE-4;
+			ref -= dec2;
+		} else { LZ4_COPYSTEP(ref,op); }
+		cpy = op + length - (STEPSIZE-4);
+		if (cpy>oend-COPYLENGTH)
+		{
+			if (cpy > oend) goto _output_error;
+			LZ4_SECURECOPY(ref, op, (oend-COPYLENGTH));
+			while(op<cpy) *op++=*ref++;
+			op=cpy;
+			if (op == oend) break;    // Check EOF (should never happen, since last 5 bytes are supposed to be literals)
+			continue;
+		}
+		LZ4_SECURECOPY(ref, op, cpy);
+		op=cpy;		// correction
+	}
+
+	// end of decoding
+	return (int) (((char*)op)-dest);
+
+	// write overflow error detected
+_output_error:
+	return (int) (-(((char*)ip)-source));
+}
+
+int LZ4_context_size(void)
+{
+	return sizeof(struct refTables);
+}
+int LZ4_context64k_size(void)
+{
+	return sizeof(struct refTables);
+}
+
diff --git a/fs/btrfs/lz4.h b/fs/btrfs/lz4.h
new file mode 100644
index 0000000..dcd8f44
--- /dev/null
+++ b/fs/btrfs/lz4.h
@@ -0,0 +1,128 @@
+/*
+   LZ4 - Fast LZ compression algorithm
+   Header File
+   Copyright (C) 2011, Yann Collet.
+   BSD License
+
+   Redistribution and use in source and binary forms, with or without
+   modification, are permitted provided that the following conditions are
+   met:
+
+       * Redistributions of source code must retain the above copyright
+   notice, this list of conditions and the following disclaimer.
+       * Redistributions in binary form must reproduce the above
+   copyright notice, this list of conditions and the following disclaimer
+   in the documentation and/or other materials provided with the
+   distribution.
+
+   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+
+/*
+ * With authors permission dual licensed as BSD/GPL for linux kernel
+ *
+ * Origin: http://lz4.googlecode.com/svn/trunk
+ * Revision: 62
+ */
+#pragma once
+
+#if defined (__cplusplus)
+extern "C" {
+#endif
+
+
+//****************************
+// Simple Functions
+//****************************
+
+int LZ4_compress   (const char* source, char* dest, int isize);
+int LZ4_uncompress (const char* source, char* dest, int osize);
+
+/*
+LZ4_compress() :
+	isize  : is the input size. Max supported value is ~1.9GB
+	return : the number of bytes written in buffer dest
+			 or 0 if the compression fails (if LZ4_COMPRESSMIN is set)
+	note : destination buffer must be already allocated.
+		destination buffer must be sized to handle worst cases situations (input data not compressible)
+		worst case size evaluation is provided by function LZ4_compressBound()
+
+LZ4_uncompress() :
+	osize  : is the output size, therefore the original size
+	return : the number of bytes read in the source buffer
+			 If the source stream is malformed, the function will stop decoding and return a negative result, indicating the byte position of the faulty instruction
+			 This function never writes beyond dest + osize, and is therefore protected against malicious data packets
+	note : destination buffer must be already allocated
+*/
+
+
+//****************************
+// Advanced Functions
+//****************************
+
+int LZ4_compressBound(int isize);
+
+/*
+LZ4_compressBound() :
+	Provides the maximum size that LZ4 may output in a "worst case" scenario (input data not compressible)
+	primarily useful for memory allocation of output buffer.
+
+	isize  : is the input size. Max supported value is ~1.9GB
+	return : maximum output size in a "worst case" scenario
+	note : this function is limited by "int" range (2^31-1)
+*/
+
+
+int LZ4_uncompress_unknownOutputSize (const char* source, char* dest, int isize, int maxOutputSize);
+
+/*
+LZ4_uncompress_unknownOutputSize() :
+	isize  : is the input size, therefore the compressed size
+	maxOutputSize : is the size of the destination buffer (which must be already allocated)
+	return : the number of bytes decoded in the destination buffer (necessarily <= maxOutputSize)
+			 If the source stream is malformed, the function will stop decoding and return a negative result, indicating the byte position of the faulty instruction
+			 This function never writes beyond dest + maxOutputSize, and is therefore protected against malicious data packets
+	note   : This version is slightly slower than LZ4_uncompress()
+*/
+
+
+int LZ4_compressCtx(void** ctx, const char* source,  char* dest, int isize);
+
+/*
+LZ4_compressCtx() :
+	This function explicitly handles the CTX memory structure.
+	It avoids allocating/deallocating memory between each call, improving performance when malloc is heavily invoked.
+	This function is only useful when memory is allocated into the heap (HASH_LOG value beyond STACK_LIMIT)
+	Performance difference will be noticeable only when repetitively calling the compression function over many small segments.
+	Note : by default, memory is allocated into the stack, therefore "malloc" is not invoked.
+LZ4_compress64kCtx() :
+	Same as LZ4_compressCtx(), but specific to small inputs (<64KB).
+	isize *Must* be <64KB, otherwise the output will be corrupted.
+
+	On first call : provide a *ctx=NULL; It will be automatically allocated.
+	On next calls : reuse the same ctx pointer.
+	Use different pointers for different threads when doing multi-threading.
+
+*/
+
+int LZ4_compress64kCtx(void** ctx,
+				 const char* source,
+				 char* dest,
+				 int isize);
+
+int LZ4_context_size(void);
+int LZ4_context64k_size(void);
+
+#if defined (__cplusplus)
+}
+#endif
diff --git a/fs/btrfs/lz4hc.c b/fs/btrfs/lz4hc.c
new file mode 100644
index 0000000..f69c77a
--- /dev/null
+++ b/fs/btrfs/lz4hc.c
@@ -0,0 +1,685 @@
+/*
+    LZ4 HC - High Compression Mode of LZ4
+    Copyright (C) 2011-2012, Yann Collet.
+    L-GPL v3 License
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU Lesser General Public License as published by
+    the Free Software Foundation; either version 3 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU Lesser General Public License for more details.
+
+    You should have received a copy of the GNU Lesser General Public License along
+    with this program; if not, see <http://www.gnu.org/licenses/>,
+	or write to the Free Software Foundation, Inc.,
+    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+
+	You can contact the author at :
+	- LZ4 homepage : http://fastcompression.blogspot.com/p/lz4.html
+	- LZ4-HC source repository : http://code.google.com/p/lz4hc/
+*/
+
+
+
+//**************************************
+// CPU Feature Detection
+//**************************************
+// 32 or 64 bits ?
+#if (defined(__x86_64__) || defined(__x86_64) || defined(__amd64__) || defined(__amd64) || defined(__ppc64__) || defined(_WIN64) || defined(__LP64__) || defined(_LP64) )   // Detects 64 bits mode
+#define LZ4_ARCH64 1
+#else
+#define LZ4_ARCH64 0
+#endif
+
+// Little Endian or Big Endian ? 
+#if (defined(__BIG_ENDIAN__) || defined(__BIG_ENDIAN) || defined(_BIG_ENDIAN) || defined(_ARCH_PPC) || defined(__PPC__) || defined(__PPC) || defined(PPC) || defined(__powerpc__) || defined(__powerpc) || defined(powerpc) || ((defined(__BYTE_ORDER__)&&(__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__))) )
+#define LZ4_BIG_ENDIAN 1
+#else
+// Little Endian assumed. PDP Endian and other very rare endian format are unsupported.
+#endif
+
+// Unaligned memory access is automatically enabled for "common" CPU, such as x86.
+// For others CPU, the compiler will be more cautious, and insert extra code to ensure aligned access is respected
+// If you know your target CPU supports unaligned memory access, you may want to force this option manually to improve performance
+#if defined(__ARM_FEATURE_UNALIGNED)
+#define LZ4_FORCE_UNALIGNED_ACCESS 1
+#endif
+
+
+//**************************************
+// Compiler Options
+//**************************************
+#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L    // C99
+  /* "restrict" is a known keyword */
+#else
+#define restrict  // Disable restrict
+#endif
+
+#ifdef _MSC_VER
+#define inline __forceinline    // Visual is not C99, but supports some kind of inline
+#endif
+
+#ifdef _MSC_VER  // Visual Studio
+#define bswap16(x) _byteswap_ushort(x)
+#else
+#define bswap16(x)  ((unsigned short int) ((((x) >> 8) & 0xffu) | (((x) & 0xffu) << 8)))
+#endif
+
+
+//**************************************
+// Includes
+//**************************************
+#ifdef __KERNEL__
+#include <linux/string.h>
+#include <linux/bug.h>
+#define calloc(x,size)	({ BUG(); (void*)0; })
+#define malloc(size)	({ BUG(); (void*)0; })
+#define free(ptr)	({ BUG(); (void*)0; })
+#else
+#include <stdlib.h>   // calloc, free
+#include <string.h>   // memset, memcpy
+#include "lz4hc.h"
+#endif
+
+#define ALLOCATOR(s) calloc(1,s)
+#define FREEMEM free
+#define MEM_INIT memset
+
+
+//**************************************
+// Basic Types
+//**************************************
+#if defined(_MSC_VER)    // Visual Studio does not support 'stdint' natively
+#define BYTE	unsigned __int8
+#define U16		unsigned __int16
+#define U32		unsigned __int32
+#define S32		__int32
+#define U64		unsigned __int64
+#else
+#ifdef __KERNEL__
+#include <asm/byteorder.h>
+#include <linux/types.h>
+#define BYTE	u8
+#define U16	u16
+#define U32	u32
+#define S32	s32
+#define U64	u64
+
+#else
+#include <stdint.h>
+#define BYTE	uint8_t
+#define U16		uint16_t
+#define U32		uint32_t
+#define S32		int32_t
+#define U64		uint64_t
+#endif // __KERNEL__
+#endif
+
+#ifndef LZ4_FORCE_UNALIGNED_ACCESS
+#pragma pack(push, 1) 
+#endif
+
+typedef struct _U16_S { U16 v; } U16_S;
+typedef struct _U32_S { U32 v; } U32_S;
+typedef struct _U64_S { U64 v; } U64_S;
+
+#ifndef LZ4_FORCE_UNALIGNED_ACCESS
+#pragma pack(pop) 
+#endif
+
+#define A64(x) (((U64_S *)(x))->v)
+#define A32(x) (((U32_S *)(x))->v)
+#define A16(x) (((U16_S *)(x))->v)
+
+
+//**************************************
+// Constants
+//**************************************
+#define MINMATCH 4
+
+#define DICTIONARY_LOGSIZE 16
+#define MAXD (1<<DICTIONARY_LOGSIZE)
+#define MAXD_MASK ((U32)(MAXD - 1))
+#define MAX_DISTANCE (MAXD - 1)
+
+#define HASH_LOG (DICTIONARY_LOGSIZE-1)
+#define HASHTABLESIZE (1 << HASH_LOG)
+#define HASH_MASK (HASHTABLESIZE - 1)
+
+#define MAX_NB_ATTEMPTS 256
+
+#define ML_BITS  4
+#define ML_MASK  (size_t)((1U<<ML_BITS)-1)
+#define RUN_BITS (8-ML_BITS)
+#define RUN_MASK ((1U<<RUN_BITS)-1)
+
+#define COPYLENGTH 8
+#define LASTLITERALS 5
+#define MFLIMIT (COPYLENGTH+MINMATCH)
+#define MINLENGTH (MFLIMIT+1)
+#define OPTIMAL_ML (int)((ML_MASK-1)+MINMATCH)
+
+
+//**************************************
+// Architecture-specific macros
+//**************************************
+#if LZ4_ARCH64	// 64-bit
+#define STEPSIZE 8
+#define LZ4_COPYSTEP(s,d)		A64(d) = A64(s); d+=8; s+=8;
+#define LZ4_COPYPACKET(s,d)		LZ4_COPYSTEP(s,d)
+#define UARCH U64
+#define AARCH A64
+#define HTYPE					U32
+#define INITBASE(b,s)			const BYTE* const b = s
+#else		// 32-bit
+#define STEPSIZE 4
+#define LZ4_COPYSTEP(s,d)		A32(d) = A32(s); d+=4; s+=4;
+#define LZ4_COPYPACKET(s,d)		LZ4_COPYSTEP(s,d); LZ4_COPYSTEP(s,d);
+#define UARCH U32
+#define AARCH A32
+#define HTYPE					const BYTE*
+#define INITBASE(b,s)		    const int b = 0
+#endif
+
+#if defined(LZ4_BIG_ENDIAN)
+#define LZ4_READ_LITTLEENDIAN_16(d,s,p) { U16 v = A16(p); v = bswap16(v); d = (s) - v; }
+#define LZ4_WRITE_LITTLEENDIAN_16(p,i)  { U16 v = (U16)(i); v = bswap16(v); A16(p) = v; p+=2; }
+#else		// Little Endian
+#define LZ4_READ_LITTLEENDIAN_16(d,s,p) { d = (s) - A16(p); }
+#define LZ4_WRITE_LITTLEENDIAN_16(p,v)  { A16(p) = v; p+=2; }
+#endif
+
+
+//************************************************************
+// Local Types
+//************************************************************
+typedef struct 
+{
+	const BYTE* base;
+	HTYPE hashTable[HASHTABLESIZE];
+	U16 chainTable[MAXD];
+	const BYTE* nextToUpdate;
+} LZ4HC_Data_Structure;
+
+
+//**************************************
+// Macros
+//**************************************
+#define LZ4_WILDCOPY(s,d,e)		do { LZ4_COPYPACKET(s,d) } while (d<e);
+#define LZ4_BLINDCOPY(s,d,l)	{ BYTE* e=d+l; LZ4_WILDCOPY(s,d,e); d=e; }
+#define HASH_FUNCTION(i)	(((i) * 2654435761U) >> ((MINMATCH*8)-HASH_LOG))
+#define HASH_VALUE(p)		HASH_FUNCTION(*(U32*)(p))
+#define HASH_POINTER(p)		(HashTable[HASH_VALUE(p)] + base)
+#define DELTANEXT(p)		chainTable[(size_t)(p) & MAXD_MASK] 
+#define GETNEXT(p)			((p) - (size_t)DELTANEXT(p))
+#define ADD_HASH(p)			{ size_t delta = (p) - HASH_POINTER(p); if (delta>MAX_DISTANCE) delta = MAX_DISTANCE; DELTANEXT(p) = (U16)delta; HashTable[HASH_VALUE(p)] = (p) - base; }
+
+
+//**************************************
+// Private functions
+//**************************************
+#if LZ4_ARCH64
+
+inline static int LZ4_NbCommonBytes (register U64 val)
+{
+#if defined(LZ4_BIG_ENDIAN)
+    #if defined(_MSC_VER) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    unsigned long r = 0;
+    _BitScanReverse64( &r, val );
+    return (int)(r>>3);
+    #elif defined(__GNUC__) && ((__GNUC__ * 100 + __GNUC_MINOR__) >= 304) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    return (__builtin_clzll(val) >> 3); 
+    #else
+	int r;
+	if (!(val>>32)) { r=4; } else { r=0; val>>=32; }
+	if (!(val>>16)) { r+=2; val>>=8; } else { val>>=24; }
+	r += (!val);
+	return r;
+    #endif
+#else
+    #if defined(_MSC_VER) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    unsigned long r = 0;
+    _BitScanForward64( &r, val );
+    return (int)(r>>3);
+    #elif defined(__GNUC__) && ((__GNUC__ * 100 + __GNUC_MINOR__) >= 304) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    return (__builtin_ctzll(val) >> 3); 
+    #else
+	static const int DeBruijnBytePos[64] = { 0, 0, 0, 0, 0, 1, 1, 2, 0, 3, 1, 3, 1, 4, 2, 7, 0, 2, 3, 6, 1, 5, 3, 5, 1, 3, 4, 4, 2, 5, 6, 7, 7, 0, 1, 2, 3, 3, 4, 6, 2, 6, 5, 5, 3, 4, 5, 6, 7, 1, 2, 4, 6, 4, 4, 5, 7, 2, 6, 5, 7, 6, 7, 7 };
+	return DeBruijnBytePos[((U64)((val & -val) * 0x0218A392CDABBD3F)) >> 58];
+    #endif
+#endif
+}
+
+#else
+
+inline static int LZ4_NbCommonBytes (register U32 val)
+{
+#if defined(LZ4_BIG_ENDIAN)
+    #if defined(_MSC_VER) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    unsigned long r = 0;
+    _BitScanReverse( &r, val );
+    return (int)(r>>3);
+    #elif defined(__GNUC__) && ((__GNUC__ * 100 + __GNUC_MINOR__) >= 304) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    return (__builtin_clz(val) >> 3); 
+    #else
+	int r;
+	if (!(val>>16)) { r=2; val>>=8; } else { r=0; val>>=24; }
+	r += (!val);
+	return r;
+    #endif
+#else
+    #if defined(_MSC_VER) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    unsigned long r = 0;
+    _BitScanForward( &r, val );
+    return (int)(r>>3);
+    #elif defined(__GNUC__) && ((__GNUC__ * 100 + __GNUC_MINOR__) >= 304) && !defined(LZ4_FORCE_SW_BITCOUNT)
+    return (__builtin_ctz(val) >> 3); 
+    #else
+	static const int DeBruijnBytePos[32] = { 0, 0, 3, 0, 3, 1, 3, 0, 3, 2, 2, 1, 3, 2, 0, 1, 3, 3, 1, 2, 2, 2, 2, 0, 3, 1, 2, 0, 1, 0, 1, 1 };
+	return DeBruijnBytePos[((U32)((val & -(S32)val) * 0x077CB531U)) >> 27];
+    #endif
+#endif
+}
+
+#endif
+
+
+inline static int LZ4HC_Init (LZ4HC_Data_Structure* hc4, const BYTE* base)
+{
+	MEM_INIT((void*)hc4->hashTable, 0, sizeof(hc4->hashTable));
+	MEM_INIT(hc4->chainTable, 0xFF, sizeof(hc4->chainTable));
+	hc4->nextToUpdate = base + LZ4_ARCH64;
+	hc4->base = base;
+	return 1;
+}
+
+
+inline static void* LZ4HC_Create (const BYTE* base)
+{
+	void* hc4 = ALLOCATOR(sizeof(LZ4HC_Data_Structure));
+
+	LZ4HC_Init (hc4, base);
+	return hc4;
+}
+
+
+inline static int LZ4HC_Free (void** LZ4HC_Data)
+{
+	FREEMEM(*LZ4HC_Data);
+	*LZ4HC_Data = NULL;
+	return (1);
+}
+
+
+inline static void LZ4HC_Insert (LZ4HC_Data_Structure* hc4, const BYTE* ip)
+{
+	U16*   chainTable = hc4->chainTable;
+	HTYPE* HashTable  = hc4->hashTable;
+	INITBASE(base,hc4->base);
+
+	while(hc4->nextToUpdate < ip)
+	{
+		ADD_HASH(hc4->nextToUpdate);
+		hc4->nextToUpdate++;
+	}
+}
+
+
+inline static int LZ4HC_InsertAndFindBestMatch (LZ4HC_Data_Structure* hc4, const BYTE* ip, const BYTE* const matchlimit, const BYTE** matchpos)
+{
+	U16* const chainTable = hc4->chainTable;
+	HTYPE* const HashTable = hc4->hashTable;
+	const BYTE* ref;
+	INITBASE(base,hc4->base);
+	int nbAttempts=MAX_NB_ATTEMPTS;
+	int ml=0;
+
+	// HC4 match finder
+	LZ4HC_Insert(hc4, ip);
+	ref = HASH_POINTER(ip);
+	while ((ref > (ip-MAX_DISTANCE)) && (nbAttempts))
+	{
+		nbAttempts--;
+		if (*(ref+ml) == *(ip+ml))
+		if (*(U32*)ref == *(U32*)ip)
+		{
+			const BYTE* reft = ref+MINMATCH;
+			const BYTE* ipt = ip+MINMATCH;
+
+			while (ipt<matchlimit-(STEPSIZE-1))
+			{
+				UARCH diff = AARCH(reft) ^ AARCH(ipt);
+				if (!diff) { ipt+=STEPSIZE; reft+=STEPSIZE; continue; }
+				ipt += LZ4_NbCommonBytes(diff);
+				goto _endCount;
+			}
+			if (LZ4_ARCH64) if ((ipt<(matchlimit-3)) && (A32(reft) == A32(ipt))) { ipt+=4; reft+=4; }
+			if ((ipt<(matchlimit-1)) && (A16(reft) == A16(ipt))) { ipt+=2; reft+=2; }
+			if ((ipt<matchlimit) && (*reft == *ipt)) ipt++;
+_endCount:
+
+			if (ipt-ip > ml) { ml = ipt-ip; *matchpos = ref; }
+		}
+		ref = GETNEXT(ref);
+	}
+
+	return ml;
+}
+
+
+inline static int LZ4HC_InsertAndGetWiderMatch (LZ4HC_Data_Structure* hc4, const BYTE* ip, const BYTE* startLimit, const BYTE* matchlimit, int longest, const BYTE** matchpos, const BYTE** startpos)
+{
+	U16* const  chainTable = hc4->chainTable;
+	HTYPE* const HashTable = hc4->hashTable;
+	INITBASE(base,hc4->base);
+	const BYTE*  ref;
+	int nbAttempts = MAX_NB_ATTEMPTS;
+	int delta = ip-startLimit;
+
+	// First Match
+	LZ4HC_Insert(hc4, ip);
+	ref = HASH_POINTER(ip);
+
+	while ((ref > ip-MAX_DISTANCE) && (ref >= hc4->base) && (nbAttempts))
+	{
+		nbAttempts--;
+		if (*(startLimit + longest) == *(ref - delta + longest))
+		if (*(U32*)ref == *(U32*)ip)
+		{
+			const BYTE* reft = ref+MINMATCH;
+			const BYTE* ipt = ip+MINMATCH;
+			const BYTE* startt = ip;
+
+			while (ipt<matchlimit-(STEPSIZE-1))
+			{
+				UARCH diff = AARCH(reft) ^ AARCH(ipt);
+				if (!diff) { ipt+=STEPSIZE; reft+=STEPSIZE; continue; }
+				ipt += LZ4_NbCommonBytes(diff);
+				goto _endCount;
+			}
+			if (LZ4_ARCH64) if ((ipt<(matchlimit-3)) && (A32(reft) == A32(ipt))) { ipt+=4; reft+=4; }
+			if ((ipt<(matchlimit-1)) && (A16(reft) == A16(ipt))) { ipt+=2; reft+=2; }
+			if ((ipt<matchlimit) && (*reft == *ipt)) ipt++;
+_endCount:
+
+			reft = ref;
+			while ((startt>startLimit) && (reft > hc4->base) && (startt[-1] == reft[-1])) {startt--; reft--;}
+
+			if ((ipt-startt) > longest)
+			{
+				longest = ipt-startt;
+				*matchpos = reft;
+				*startpos = startt;
+			}
+		}
+		ref = GETNEXT(ref);
+	}
+
+	return longest;
+}
+
+
+inline static int LZ4_encodeSequence(const BYTE** ip, BYTE** op, const BYTE** anchor, int ml, const BYTE* ref)
+{
+	int length, len; 
+	BYTE* token;
+
+	// Encode Literal length
+	length = *ip - *anchor;
+	token = (*op)++;
+	if (length>=(int)RUN_MASK) { *token=(RUN_MASK<<ML_BITS); len = length-RUN_MASK; for(; len > 254 ; len-=255) *(*op)++ = 255;  *(*op)++ = (BYTE)len; } 
+	else *token = (length<<ML_BITS);
+
+	// Copy Literals
+	LZ4_BLINDCOPY(*anchor, *op, length);
+
+	// Encode Offset
+	LZ4_WRITE_LITTLEENDIAN_16(*op,*ip-ref);
+
+	// Encode MatchLength
+	len = (int)(ml-MINMATCH);
+	if (len>=(int)ML_MASK) { *token+=ML_MASK; len-=ML_MASK; for(; len > 509 ; len-=510) { *(*op)++ = 255; *(*op)++ = 255; } if (len > 254) { len-=255; *(*op)++ = 255; } *(*op)++ = (BYTE)len; } 
+	else *token += len;	
+
+	// Prepare next loop
+	*ip += ml;
+	*anchor = *ip; 
+
+	return 0;
+}
+
+
+//****************************
+// Compression CODE
+//****************************
+
+int LZ4_compressHCCtx(LZ4HC_Data_Structure* ctx,
+				 const char* source, 
+				 char* dest,
+				 int isize)
+{	
+	const BYTE* ip = (const BYTE*) source;
+	const BYTE* anchor = ip;
+	const BYTE* const iend = ip + isize;
+	const BYTE* const mflimit = iend - MFLIMIT;
+	const BYTE* const matchlimit = (iend - LASTLITERALS);
+
+	BYTE* op = (BYTE*) dest;
+
+	int	ml, ml2, ml3, ml0;
+	const BYTE* ref=NULL;
+	const BYTE* start2=NULL;
+	const BYTE* ref2=NULL;
+	const BYTE* start3=NULL;
+	const BYTE* ref3=NULL;
+	const BYTE* start0;
+	const BYTE* ref0;
+
+	ip++;
+
+	// Main Loop
+	while (ip < mflimit)
+	{
+		ml = LZ4HC_InsertAndFindBestMatch (ctx, ip, matchlimit, (&ref));
+		if (!ml) { ip++; continue; }
+
+		// saved, in case we would skip too much
+		start0 = ip;
+		ref0 = ref;
+		ml0 = ml;
+
+_Search2:
+		if (ip+ml < mflimit)
+			ml2 = LZ4HC_InsertAndGetWiderMatch(ctx, ip + ml - 2, ip + 1, matchlimit, ml, &ref2, &start2);
+		else ml2=ml;
+
+		if (ml2 == ml)  // No better match
+		{
+			LZ4_encodeSequence(&ip, &op, &anchor, ml, ref);
+			continue;
+		}
+
+		if (start0 < ip)
+		{
+			if (start2 < ip + ml0)   // empirical
+			{
+				ip = start0;
+				ref = ref0;
+				ml = ml0;
+			}
+		}
+
+		// Here, start0==ip
+		if ((start2 - ip) < 3)   // First Match too small : removed
+		{
+			ml = ml2;
+			ip = start2;
+			ref =ref2;
+			goto _Search2;
+		}
+
+_Search3:
+		// Currently we have :
+		// ml2 > ml1, and
+		// ip1+3 <= ip2 (usually < ip1+ml1)
+		if ((start2 - ip) < OPTIMAL_ML)
+		{
+			int correction;
+			int new_ml = ml;
+			if (new_ml > OPTIMAL_ML) new_ml = OPTIMAL_ML;
+			if (ip+new_ml > start2 + ml2 - MINMATCH) new_ml = start2 - ip + ml2 - MINMATCH;
+			correction = new_ml - (start2 - ip);
+			if (correction > 0)
+			{
+				start2 += correction;
+				ref2 += correction;
+				ml2 -= correction;
+			}
+		}
+		// Now, we have start2 = ip+new_ml, with new_ml=min(ml, OPTIMAL_ML=18)
+
+		if (start2 + ml2 < mflimit)
+			ml3 = LZ4HC_InsertAndGetWiderMatch(ctx, start2 + ml2 - 3, start2, matchlimit, ml2, &ref3, &start3);
+		else ml3=ml2;
+
+		if (ml3 == ml2) // No better match : 2 sequences to encode
+		{
+			// ip & ref are known; Now for ml
+			if (start2 < ip+ml)
+			{
+				if ((start2 - ip) < OPTIMAL_ML)
+				{
+					int correction;
+					if (ml > OPTIMAL_ML) ml = OPTIMAL_ML;
+					if (ip+ml > start2 + ml2 - MINMATCH) ml = start2 - ip + ml2 - MINMATCH;
+					correction = ml - (start2 - ip);
+					if (correction > 0)
+					{
+						start2 += correction;
+						ref2 += correction;
+						ml2 -= correction;
+					}
+				}
+				else
+				{
+					ml = start2 - ip;
+				}
+			}
+			// Now, encode 2 sequences
+			LZ4_encodeSequence(&ip, &op, &anchor, ml, ref);
+			ip = start2;
+			LZ4_encodeSequence(&ip, &op, &anchor, ml2, ref2);
+			continue;
+		}
+
+		if (start3 < ip+ml+3) // Not enough space for match 2 : remove it
+		{
+			if (start3 >= (ip+ml)) // can write Seq1 immediately ==> Seq2 is removed, so Seq3 becomes Seq1
+			{
+				if (start2 < ip+ml)
+				{
+					int correction = (ip+ml) - start2;
+					start2 += correction;
+					ref2 += correction;
+					ml2 -= correction;
+					if (ml2 < MINMATCH)
+					{
+						start2 = start3;
+						ref2 = ref3;
+						ml2 = ml3;
+					}
+				}
+
+				LZ4_encodeSequence(&ip, &op, &anchor, ml, ref);
+				ip  = start3;
+				ref = ref3;
+				ml  = ml3;
+
+				start0 = start2;
+				ref0 = ref2;
+				ml0 = ml2;
+				goto _Search2;
+			}
+
+			start2 = start3;
+			ref2 = ref3;
+			ml2 = ml3;
+			goto _Search3;
+		}
+
+		// OK, now we have 3 ascending matches; let's write at least the first one
+		// ip & ref are known; Now for ml
+		if (start2 < ip+ml)
+		{
+			if ((start2 - ip) < (int)ML_MASK)
+			{
+				int correction;
+				if (ml > OPTIMAL_ML) ml = OPTIMAL_ML;
+				if (ip + ml > start2 + ml2 - MINMATCH) ml = start2 - ip + ml2 - MINMATCH;
+				correction = ml - (start2 - ip);
+				if (correction > 0)
+				{
+					start2 += correction;
+					ref2 += correction;
+					ml2 -= correction;
+				}
+			}
+			else
+			{
+				ml = start2 - ip;
+			}
+		}
+		LZ4_encodeSequence(&ip, &op, &anchor, ml, ref);
+
+		ip = start2;
+		ref = ref2;
+		ml = ml2;
+
+		start2 = start3;
+		ref2 = ref3;
+		ml2 = ml3;
+
+		goto _Search3;
+
+	}
+
+	// Encode Last Literals
+	{
+		int lastRun = iend - anchor;
+		if (lastRun>=(int)RUN_MASK) { *op++=(RUN_MASK<<ML_BITS); lastRun-=RUN_MASK; for(; lastRun > 254 ; lastRun-=255) *op++ = 255; *op++ = (BYTE) lastRun; } 
+		else *op++ = (lastRun<<ML_BITS);
+		memcpy(op, anchor, iend - anchor);
+		op += iend-anchor;
+	} 
+
+	// End
+	return (int) (((char*)op)-dest);
+}
+
+
+int LZ4_compressHC(const char* source, 
+				 char* dest,
+				 int isize)
+{
+	void* ctx = LZ4HC_Create((const BYTE*)source);
+	int result = LZ4_compressHCCtx(ctx, source, dest, isize);
+	LZ4HC_Free (&ctx);
+
+	return result;
+}
+
+int LZ4_contextHC_size(void)
+{
+	return sizeof(LZ4HC_Data_Structure);
+}
+
+void LZ4_contextHC_init(void *ctx, const void *base)
+{
+	LZ4HC_Init(ctx, base);
+}
+
+
diff --git a/fs/btrfs/lz4hc.h b/fs/btrfs/lz4hc.h
new file mode 100644
index 0000000..23ab176
--- /dev/null
+++ b/fs/btrfs/lz4hc.h
@@ -0,0 +1,58 @@
+/*
+    LZ4 HC - High Compression Mode of LZ4
+    Copyright (C) 2011-2012, Yann Collet.
+    L-GPL v3 License
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU Lesser General Public License as published by
+    the Free Software Foundation; either version 3 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU Lesser General Public License for more details.
+
+    You should have received a copy of the GNU Lesser General Public License along
+    with this program; if not, see <http://www.gnu.org/licenses/>,
+	or write to the Free Software Foundation, Inc.,
+    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+
+	You can contact the author at :
+	- LZ4 homepage : http://fastcompression.blogspot.com/p/lz4.html
+	- LZ4-HC source repository : http://code.google.com/p/lz4hc/
+*/
+#pragma once
+
+
+#if defined (__cplusplus)
+extern "C" {
+#endif
+
+
+int LZ4_compressHC (const char* source, char* dest, int isize);
+
+/*
+LZ4_compressHC :
+	return : the number of bytes in compressed buffer dest
+	note : destination buffer must be already allocated. 
+		To avoid any problem, size it to handle worst cases situations (input data not compressible)
+		Worst case size evaluation is provided by function LZ4_compressBound() (see "lz4.h")
+*/
+
+
+/* Note :
+Decompression functions are provided within regular LZ4 source code (see "lz4.h") (BSD license)
+*/
+
+int LZ4_compressHCCtx(void* ctx,
+				 const char* source, 
+				 char* dest,
+				 int isize);
+
+int LZ4_contextHC_size(void);
+void LZ4_contextHC_init(void *ctx, const void *base);
+
+#if defined (__cplusplus)
+}
+#endif
-- 
1.7.11

