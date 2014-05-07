Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29970 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaEGK5A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 06:57:00 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s47Auxaq026948
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 10:57:00 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s47AuxxU027672
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 10:56:59 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s47Aumev027233
	for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 10:56:58 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: add xxhash
Date: Wed,  7 May 2014 18:56:33 +0800
Message-Id: <1399460193-1713-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1399460193-1713-1-git-send-email-bo.li.liu@oracle.com>
References: <1399460193-1713-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: root <root@localhost.localdomain>

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 Makefile  |    4 +-
 crc32c.h  |    4 +-
 disk-io.c |    2 +-
 hash.h    |    2 +-
 xxhash.c  |  448 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 xxhash.h  |  171 +++++++++++++++++++++++
 6 files changed, 626 insertions(+), 5 deletions(-)
 create mode 100644 xxhash.c
 create mode 100644 xxhash.h

diff --git a/Makefile b/Makefile
index 369df6c..1d70bc9 100644
--- a/Makefile
+++ b/Makefile
@@ -16,10 +16,10 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
 	       cmds-property.o cmds-dedup.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
-		   uuid-tree.o
+		   uuid-tree.o xxhash.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
-	       extent_io.h ioctl.h ctree.h btrfsck.h
+	       extent_io.h ioctl.h ctree.h btrfsck.h xxhash.h
 TESTS = fsck-tests.sh
 
 INSTALL = install
diff --git a/crc32c.h b/crc32c.h
index c552ef6..6dd0ce2 100644
--- a/crc32c.h
+++ b/crc32c.h
@@ -25,9 +25,11 @@
 #include <btrfs/kerncompat.h>
 #endif /* BTRFS_FLAT_INCLUDES */
 
+#include "xxhash.h"
+
 u32 crc32c_le(u32 seed, unsigned char const *data, size_t length);
 void crc32c_optimization_init(void);
 
-#define crc32c(seed, data, length) crc32c_le(seed, (unsigned char const *)data, length)
+#define crc32c(seed, data, length) XXH32(data, length, 0)
 #define btrfs_crc32c crc32c
 #endif
diff --git a/disk-io.c b/disk-io.c
index 19b95a7..2c72f7f 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -67,7 +67,7 @@ u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len)
 
 void btrfs_csum_final(u32 crc, char *result)
 {
-	*(__le32 *)result = ~cpu_to_le32(crc);
+	*(__le32 *)result = cpu_to_le32(crc);
 }
 
 static int __csum_tree_block_size(struct extent_buffer *buf, u16 csum_size,
diff --git a/hash.h b/hash.h
index c0b88a1..2d1a71d 100644
--- a/hash.h
+++ b/hash.h
@@ -22,6 +22,6 @@
 
 static inline u64 btrfs_name_hash(const char *name, int len)
 {
-	return ~(crc32c((u32)(~0), name, len));
+	return crc32c((u32)(~0), name, len);
 }
 #endif
diff --git a/xxhash.c b/xxhash.c
new file mode 100644
index 0000000..f855a58
--- /dev/null
+++ b/xxhash.c
@@ -0,0 +1,448 @@
+/*
+xxHash - Fast Hash algorithm
+Copyright (C) 2012-2014, Yann Collet.
+BSD 2-Clause License (http://www.opensource.org/licenses/bsd-license.php)
+
+Redistribution and use in source and binary forms, with or without
+modification, are permitted provided that the following conditions are
+met:
+
+* Redistributions of source code must retain the above copyright
+notice, this list of conditions and the following disclaimer.
+* Redistributions in binary form must reproduce the above
+copyright notice, this list of conditions and the following disclaimer
+in the documentation and/or other materials provided with the
+distribution.
+
+THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+
+You can contact the author at :
+- xxHash source repository : http://code.google.com/p/xxhash/
+*/
+
+
+//**************************************
+// Tuning parameters
+//**************************************
+// Unaligned memory access is automatically enabled for "common" CPU, such as x86.
+// For others CPU, the compiler will be more cautious, and insert extra code to ensure aligned access is respected.
+// If you know your target CPU supports unaligned memory access, you want to force this option manually to improve performance.
+// You can also enable this parameter if you know your input data will always be aligned (boundaries of 4, for U32).
+#if defined(__ARM_FEATURE_UNALIGNED) || defined(__i386) || defined(_M_IX86) || defined(__x86_64__) || defined(_M_X64)
+#  define XXH_USE_UNALIGNED_ACCESS 1
+#endif
+
+// XXH_ACCEPT_NULL_INPUT_POINTER :
+// If the input pointer is a null pointer, xxHash default behavior is to trigger a memory access error, since it is a bad pointer.
+// When this option is enabled, xxHash output for null input pointers will be the same as a null-length input.
+// This option has a very small performance cost (only measurable on small inputs).
+// By default, this option is disabled. To enable it, uncomment below define :
+//#define XXH_ACCEPT_NULL_INPUT_POINTER 1
+
+// XXH_FORCE_NATIVE_FORMAT :
+// By default, xxHash library provides endian-independant Hash values, based on little-endian convention.
+// Results are therefore identical for little-endian and big-endian CPU.
+// This comes at a performance cost for big-endian CPU, since some swapping is required to emulate little-endian format.
+// Should endian-independance be of no importance for your application, you may set the #define below to 1.
+// It will improve speed for Big-endian CPU.
+// This option has no impact on Little_Endian CPU.
+#define XXH_FORCE_NATIVE_FORMAT 0
+
+
+//**************************************
+// Compiler Specific Options
+//**************************************
+#define FORCE_INLINE static inline __attribute__((always_inline))
+
+
+//**************************************
+// Includes & Memory related functions
+
+#include "xxhash.h"
+#include "kerncompat.h"
+#include <inttypes.h>
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+
+
+
+//**************************************
+// Modify the local functions below should you wish to use some other memory related routines
+
+FORCE_INLINE void* XXH_malloc(size_t s)
+{
+	return kmalloc(s, GFP_KERNEL);
+}
+
+FORCE_INLINE void XXH_free(void* p)
+{
+	kfree(p);
+}
+
+FORCE_INLINE void* XXH_memcpy(void* dest, const void* src, size_t size)
+{
+	return memcpy(dest, src, size);
+}
+
+
+//**************************************
+// Basic Types
+//**************************************
+typedef unsigned char		BYTE;
+typedef unsigned short		U16;
+typedef unsigned int		U32;
+typedef signed int		S32;
+typedef unsigned long long	U64;
+
+typedef struct _U32_S {
+	U32 v;
+} __attribute__ ((__packed__)) U32_S;
+
+#define A32(x) (((U32_S *)(x))->v)
+
+
+//***************************************
+// Compiler-specific Functions and Macros
+//***************************************
+
+// Note : although _rotl exists for minGW (GCC under windows), performance seems poor
+#define XXH_rotl32(x,r) ((x << r) | (x >> (32 - r)))
+
+#define GCC_VERSION (__GNUC__ * 100 + __GNUC_MINOR__)
+
+#if GCC_VERSION >= 403
+	#define XXH_swap32 __builtin_bswap32
+#else
+	static inline U32 XXH_swap32 (U32 x)
+	{
+	    return  ((x << 24) & 0xff000000 ) |
+		    ((x <<  8) & 0x00ff0000 ) |
+		    ((x >>  8) & 0x0000ff00 ) |
+		    ((x >> 24) & 0x000000ff );
+	}
+#endif
+
+
+//**************************************
+// Constants
+//**************************************
+#define PRIME32_1   2654435761U
+#define PRIME32_2   2246822519U
+#define PRIME32_3   3266489917U
+#define PRIME32_4    668265263U
+#define PRIME32_5    374761393U
+
+
+//**************************************
+// Architecture Macros
+//**************************************
+typedef enum {
+	XXH_bigEndian=0,
+	XXH_littleEndian=1
+} XXH_endianess;
+
+#ifndef XXH_CPU_LITTLE_ENDIAN   // It is possible to define XXH_CPU_LITTLE_ENDIAN externally, for example using a compiler switch
+    static const int one = 1;
+#   define XXH_CPU_LITTLE_ENDIAN   (*(char*)(&one))
+#endif
+
+
+//**************************************
+// Macros
+//**************************************
+#define XXH_STATIC_ASSERT(c)   { enum { XXH_static_assert = 1/(!!(c)) }; }    // use only *after* variable declarations
+
+
+//****************************
+// Memory reads
+//****************************
+typedef enum {
+	XXH_aligned,
+	XXH_unaligned
+} XXH_alignment;
+
+FORCE_INLINE U32 XXH_readLE32_align(const U32* ptr, XXH_endianess endian, XXH_alignment align)
+{
+    if (align == XXH_unaligned)
+        return endian == XXH_littleEndian ? A32(ptr) : XXH_swap32(A32(ptr));
+    else
+        return endian == XXH_littleEndian ? *ptr : XXH_swap32(*ptr);
+}
+
+FORCE_INLINE U32 XXH_readLE32(const U32* ptr, XXH_endianess endian) {
+	return XXH_readLE32_align(ptr, endian, XXH_unaligned);
+}
+
+
+//****************************
+// Simple Hash Functions
+//****************************
+FORCE_INLINE U32 XXH32_endian_align(const void* input, int len, U32 seed, XXH_endianess endian, XXH_alignment align)
+{
+	const BYTE* p = (const BYTE*)input;
+	const BYTE* const bEnd = p + len;
+	U32 h32;
+
+#ifdef XXH_ACCEPT_NULL_INPUT_POINTER
+	if (p==NULL) { len=0; p=(const BYTE*)(size_t)16; }
+#endif
+
+	if (len>=16) {
+		const BYTE* const limit = bEnd - 16;
+		U32 v1 = seed + PRIME32_1 + PRIME32_2;
+		U32 v2 = seed + PRIME32_2;
+		U32 v3 = seed + 0;
+		U32 v4 = seed - PRIME32_1;
+
+		do {
+		    v1 += XXH_readLE32_align((const U32*)p, endian, align) * PRIME32_2; v1 = XXH_rotl32(v1, 13); v1 *= PRIME32_1; p+=4;
+		    v2 += XXH_readLE32_align((const U32*)p, endian, align) * PRIME32_2; v2 = XXH_rotl32(v2, 13); v2 *= PRIME32_1; p+=4;
+		    v3 += XXH_readLE32_align((const U32*)p, endian, align) * PRIME32_2; v3 = XXH_rotl32(v3, 13); v3 *= PRIME32_1; p+=4;
+		    v4 += XXH_readLE32_align((const U32*)p, endian, align) * PRIME32_2; v4 = XXH_rotl32(v4, 13); v4 *= PRIME32_1; p+=4;
+		} while (p<=limit);
+
+		h32 = XXH_rotl32(v1, 1) + XXH_rotl32(v2, 7) + XXH_rotl32(v3, 12) + XXH_rotl32(v4, 18);
+	} else {
+		h32  = seed + PRIME32_5;
+	}
+
+	h32 += (U32)len;
+
+	while (p <= bEnd - 4) {
+		h32 += XXH_readLE32_align((const U32*)p, endian, align) * PRIME32_3;
+		h32  = XXH_rotl32(h32, 17) * PRIME32_4 ;
+		p += 4;
+	}
+
+	while (p < bEnd) {
+		h32 += (*p) * PRIME32_5;
+		h32 = XXH_rotl32(h32, 11) * PRIME32_1 ;
+		p++;
+	}
+
+	h32 ^= h32 >> 15;
+	h32 *= PRIME32_2;
+	h32 ^= h32 >> 13;
+	h32 *= PRIME32_3;
+	h32 ^= h32 >> 16;
+
+	return h32;
+}
+
+
+U32 XXH32(const void* input, int len, U32 seed)
+{
+#if 0
+	// Simple version, good for code maintenance, but unfortunately slow for small inputs
+	void* state = XXH32_init(seed);
+	XXH32_update(state, input, len);
+	return XXH32_digest(state);
+#else
+
+	XXH_endianess endian_detected = (XXH_endianess)XXH_CPU_LITTLE_ENDIAN;
+
+	#if !defined(XXH_USE_UNALIGNED_ACCESS)
+	if ((((size_t)input) & 3)) { // Input is aligned, let's leverage the speed advantage
+		if ((endian_detected == XXH_littleEndian) || XXH_FORCE_NATIVE_FORMAT)
+			return XXH32_endian_align(input, len, seed, XXH_littleEndian, XXH_aligned);
+		else
+			return XXH32_endian_align(input, len, seed, XXH_bigEndian, XXH_aligned);
+	}
+	#endif
+
+	if ((endian_detected == XXH_littleEndian) || XXH_FORCE_NATIVE_FORMAT)
+		return XXH32_endian_align(input, len, seed, XXH_littleEndian, XXH_unaligned);
+	else
+		return XXH32_endian_align(input, len, seed, XXH_bigEndian, XXH_unaligned);
+#endif
+}
+
+//****************************
+// Advanced Hash Functions
+//****************************
+
+struct XXH_state32_t {
+	U64 total_len;
+	U32 seed;
+	U32 v1;
+	U32 v2;
+	U32 v3;
+	U32 v4;
+	int memsize;
+	char memory[16];
+};
+
+
+int XXH32_sizeofState()
+{
+	XXH_STATIC_ASSERT(XXH32_SIZEOFSTATE >= sizeof(struct XXH_state32_t));   // A compilation error here means XXH32_SIZEOFSTATE is not large enough
+	return sizeof(struct XXH_state32_t);
+}
+
+
+XXH_errorcode XXH32_resetState(void* state_in, U32 seed)
+{
+	struct XXH_state32_t * state = (struct XXH_state32_t *) state_in;
+	state->seed = seed;
+	state->v1 = seed + PRIME32_1 + PRIME32_2;
+	state->v2 = seed + PRIME32_2;
+	state->v3 = seed + 0;
+	state->v4 = seed - PRIME32_1;
+	state->total_len = 0;
+	state->memsize = 0;
+	return XXH_OK;
+}
+
+
+void* XXH32_init (U32 seed)
+{
+	void* state = XXH_malloc(sizeof(struct XXH_state32_t));
+	XXH32_resetState(state, seed);
+	return state;
+}
+
+
+FORCE_INLINE XXH_errorcode XXH32_update_endian (void* state_in, const void* input, int len, XXH_endianess endian)
+{
+	struct XXH_state32_t * state = (struct XXH_state32_t *) state_in;
+	const BYTE* p = (const BYTE*)input;
+	const BYTE* const bEnd = p + len;
+
+#ifdef XXH_ACCEPT_NULL_INPUT_POINTER
+	if (input == NULL)
+		return XXH_ERROR;
+#endif
+
+	state->total_len += len;
+
+	if (state->memsize + len < 16) { // fill in tmp buffer
+		XXH_memcpy(state->memory + state->memsize, input, len);
+		state->memsize +=  len;
+		return XXH_OK;
+	}
+
+	if (state->memsize)   // some data left from previous update
+	{
+		XXH_memcpy(state->memory + state->memsize, input, 16-state->memsize);
+		{
+			const U32* p32 = (const U32*)state->memory;
+			state->v1 += XXH_readLE32(p32, endian) * PRIME32_2; state->v1 = XXH_rotl32(state->v1, 13); state->v1 *= PRIME32_1; p32++;
+			state->v2 += XXH_readLE32(p32, endian) * PRIME32_2; state->v2 = XXH_rotl32(state->v2, 13); state->v2 *= PRIME32_1; p32++;
+			state->v3 += XXH_readLE32(p32, endian) * PRIME32_2; state->v3 = XXH_rotl32(state->v3, 13); state->v3 *= PRIME32_1; p32++;
+			state->v4 += XXH_readLE32(p32, endian) * PRIME32_2; state->v4 = XXH_rotl32(state->v4, 13); state->v4 *= PRIME32_1; p32++;
+		}
+		p += 16-state->memsize;
+		state->memsize = 0;
+	}
+
+	if (p <= bEnd-16) {
+		const BYTE* const limit = bEnd - 16;
+		U32 v1 = state->v1;
+		U32 v2 = state->v2;
+		U32 v3 = state->v3;
+		U32 v4 = state->v4;
+
+		do {
+		    v1 += XXH_readLE32((const U32*)p, endian) * PRIME32_2; v1 = XXH_rotl32(v1, 13); v1 *= PRIME32_1; p+=4;
+		    v2 += XXH_readLE32((const U32*)p, endian) * PRIME32_2; v2 = XXH_rotl32(v2, 13); v2 *= PRIME32_1; p+=4;
+		    v3 += XXH_readLE32((const U32*)p, endian) * PRIME32_2; v3 = XXH_rotl32(v3, 13); v3 *= PRIME32_1; p+=4;
+		    v4 += XXH_readLE32((const U32*)p, endian) * PRIME32_2; v4 = XXH_rotl32(v4, 13); v4 *= PRIME32_1; p+=4;
+		} while (p<=limit);
+
+		state->v1 = v1;
+		state->v2 = v2;
+		state->v3 = v3;
+		state->v4 = v4;
+	}
+
+	if (p < bEnd) {
+		XXH_memcpy(state->memory, p, bEnd-p);
+		state->memsize = (int)(bEnd-p);
+	}
+
+	return XXH_OK;
+}
+
+XXH_errorcode XXH32_update(void* state_in, const void* input, int len)
+{
+	XXH_endianess endian_detected = (XXH_endianess)XXH_CPU_LITTLE_ENDIAN;
+
+	if ((endian_detected==XXH_littleEndian) || XXH_FORCE_NATIVE_FORMAT)
+		return XXH32_update_endian(state_in, input, len, XXH_littleEndian);
+	else
+		return XXH32_update_endian(state_in, input, len, XXH_bigEndian);
+}
+
+
+
+FORCE_INLINE U32 XXH32_intermediateDigest_endian (void* state_in, XXH_endianess endian)
+{
+	struct XXH_state32_t * state = (struct XXH_state32_t *) state_in;
+	const BYTE * p = (const BYTE*)state->memory;
+	BYTE* bEnd = (BYTE*)state->memory + state->memsize;
+	U32 h32;
+
+	if (state->total_len >= 16) {
+		h32 = XXH_rotl32(state->v1, 1) + XXH_rotl32(state->v2, 7) + XXH_rotl32(state->v3, 12) + XXH_rotl32(state->v4, 18);
+	} else {
+		h32 = state->seed + PRIME32_5;
+	}
+
+	h32 += (U32)state->total_len;
+
+	while (p <= bEnd - 4) {
+		h32 += XXH_readLE32((const U32*)p, endian) * PRIME32_3;
+		h32  = XXH_rotl32(h32, 17) * PRIME32_4;
+		p+=4;
+	}
+
+	while (p<bEnd) {
+		h32 += (*p) * PRIME32_5;
+		h32 = XXH_rotl32(h32, 11) * PRIME32_1;
+		p++;
+	}
+
+	h32 ^= h32 >> 15;
+	h32 *= PRIME32_2;
+	h32 ^= h32 >> 13;
+	h32 *= PRIME32_3;
+	h32 ^= h32 >> 16;
+
+	return h32;
+}
+
+
+U32 XXH32_intermediateDigest (void* state_in)
+{
+	XXH_endianess endian_detected = (XXH_endianess)XXH_CPU_LITTLE_ENDIAN;
+
+	if ((endian_detected == XXH_littleEndian) || XXH_FORCE_NATIVE_FORMAT)
+		return XXH32_intermediateDigest_endian(state_in, XXH_littleEndian);
+	else
+		return XXH32_intermediateDigest_endian(state_in, XXH_bigEndian);
+}
+
+
+U32 XXH32_digest (void* state_in)
+{
+	U32 h32 = XXH32_intermediateDigest(state_in);
+
+	XXH_free(state_in);
+
+	return h32;
+}
diff --git a/xxhash.h b/xxhash.h
new file mode 100644
index 0000000..97a1bb2
--- /dev/null
+++ b/xxhash.h
@@ -0,0 +1,171 @@
+/*
+   xxHash - Fast Hash algorithm
+   Header File
+   Copyright (C) 2012-2014, Yann Collet.
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
+
+   You can contact the author at :
+   - xxHash source repository : http://code.google.com/p/xxhash/
+*/
+
+/* Notice extracted from xxHash homepage :
+
+xxHash is an extremely fast Hash algorithm, running at RAM speed limits.
+It also successfully passes all tests from the SMHasher suite.
+
+Comparison (single thread, Windows Seven 32 bits, using SMHasher on a Core 2 Duo @3GHz)
+
+Name            Speed       Q.Score   Author
+xxHash          5.4 GB/s     10
+CrapWow         3.2 GB/s      2       Andrew
+MumurHash 3a    2.7 GB/s     10       Austin Appleby
+SpookyHash      2.0 GB/s     10       Bob Jenkins
+SBox            1.4 GB/s      9       Bret Mulvey
+Lookup3         1.2 GB/s      9       Bob Jenkins
+SuperFastHash   1.2 GB/s      1       Paul Hsieh
+CityHash64      1.05 GB/s    10       Pike & Alakuijala
+FNV             0.55 GB/s     5       Fowler, Noll, Vo
+CRC32           0.43 GB/s     9
+MD5-32          0.33 GB/s    10       Ronald L. Rivest
+SHA1-32         0.28 GB/s    10
+
+Q.Score is a measure of quality of the hash function. 
+It depends on successfully passing SMHasher test set. 
+10 is a perfect score.
+*/
+
+#pragma once
+
+#ifndef __XXHASH__
+#define __XXHASH__
+
+#if defined (__cplusplus)
+extern "C" {
+#endif
+
+
+//****************************
+// Type
+//****************************
+typedef enum {
+	XXH_OK=0,
+	XXH_ERROR
+} XXH_errorcode;
+
+
+
+//****************************
+// Simple Hash Functions
+//****************************
+
+/*
+XXH32() :
+    Calculate the 32-bits hash of sequence of length "len" stored at memory address "input".
+    The memory between input & input+len must be valid (allocated and read-accessible).
+    "seed" can be used to alter the result predictably.
+    This function successfully passes all SMHasher tests.
+    Speed on Core 2 Duo @ 3 GHz (single thread, SMHasher benchmark) : 5.4 GB/s
+    Note that "len" is type "int", which means it is limited to 2^31-1.
+    If your data is larger, use the advanced functions below.
+*/
+unsigned int XXH32 (const void* input, int len, unsigned int seed);
+
+
+
+//****************************
+// Advanced Hash Functions
+//****************************
+
+void*         XXH32_init   (unsigned int seed);
+XXH_errorcode XXH32_update (void* state, const void* input, int len);
+unsigned int  XXH32_digest (void* state);
+
+/*
+These functions calculate the xxhash of an input provided in several small packets,
+as opposed to an input provided as a single block.
+
+It must be started with :
+void* XXH32_init()
+The function returns a pointer which holds the state of calculation.
+
+This pointer must be provided as "void* state" parameter for XXH32_update().
+XXH32_update() can be called as many times as necessary.
+The user must provide a valid (allocated) input.
+The function returns an error code, with 0 meaning OK, and any other value meaning there is an error.
+Note that "len" is type "int", which means it is limited to 2^31-1. 
+If your data is larger, it is recommended to chunk your data into blocks 
+of size for example 2^30 (1GB) to avoid any "int" overflow issue.
+
+Finally, you can end the calculation anytime, by using XXH32_digest().
+This function returns the final 32-bits hash.
+You must provide the same "void* state" parameter created by XXH32_init().
+Memory will be freed by XXH32_digest().
+*/
+
+
+int           XXH32_sizeofState(void);
+XXH_errorcode XXH32_resetState(void* state, unsigned int seed);
+
+#define       XXH32_SIZEOFSTATE 48
+typedef struct { long long ll[(XXH32_SIZEOFSTATE+(sizeof(long long)-1))/sizeof(long long)]; } XXH32_stateSpace_t;
+/*
+These functions allow user application to make its own allocation for state.
+
+XXH32_sizeofState() is used to know how much space must be allocated for the xxHash 32-bits state.
+Note that the state must be aligned to access 'long long' fields. Memory must be allocated and referenced by a pointer.
+This pointer must then be provided as 'state' into XXH32_resetState(), which initializes the state.
+
+For static allocation purposes (such as allocation on stack, or freestanding systems without malloc()),
+use the structure XXH32_stateSpace_t, which will ensure that memory space is large enough and correctly aligned to access 'long long' fields.
+*/
+
+
+unsigned int XXH32_intermediateDigest (void* state);
+/*
+This function does the same as XXH32_digest(), generating a 32-bit hash,
+but preserve memory context.
+This way, it becomes possible to generate intermediate hashes, and then continue feeding data with XXH32_update().
+To free memory context, use XXH32_digest(), or free().
+*/
+
+
+
+//****************************
+// Deprecated function names
+//****************************
+// The following translations are provided to ease code transition
+// You are encouraged to no longer this function names
+#define XXH32_feed   XXH32_update
+#define XXH32_result XXH32_digest
+#define XXH32_getIntermediateResult XXH32_intermediateDigest
+
+
+
+#if defined (__cplusplus)
+}
+#endif
+
+#endif
-- 
1.7.7

