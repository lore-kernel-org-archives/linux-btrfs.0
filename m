Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29937 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbaEGK45 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 06:56:57 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s47AuuWW026894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 10:56:57 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s47AutfW003071
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 10:56:55 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s47Aui87027053
	for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 10:56:54 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Crypto: add xxhash algorithm
Date: Wed,  7 May 2014 18:56:30 +0800
Message-Id: <1399460193-1713-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1399460193-1713-1-git-send-email-bo.li.liu@oracle.com>
References: <1399460193-1713-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This will be used in btrfs, and maybe in others in the future.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 crypto/Kconfig          |   7 +
 crypto/Makefile         |   1 +
 crypto/xxhash.c         | 383 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/xxhash.h | 209 ++++++++++++++++++++++++++
 4 files changed, 600 insertions(+)
 create mode 100644 crypto/xxhash.c
 create mode 100644 include/crypto/xxhash.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ce4012a..2e56de0 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -622,6 +622,13 @@ config CRYPTO_GHASH_CLMUL_NI_INTEL
 	  GHASH is message digest algorithm for GCM (Galois/Counter Mode).
 	  The implementation is accelerated by CLMUL-NI of Intel.
 
+config CRYPTO_XXH32
+	tristate "XXHASH digest algorithm"
+	select CRYPTO_HASH
+	help
+	  xxHash - Fast Hash Algorithm
+	  source repository : http://code.google.com/p/xxhash/
+	  
 comment "Ciphers"
 
 config CRYPTO_AES
diff --git a/crypto/Makefile b/crypto/Makefile
index 38e64231..7c3f363 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -97,6 +97,7 @@ obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
+obj-$(CONFIG_CRYPTO_XXH32) += xxhash.o
 
 #
 # generic algorithms and the async_tx api
diff --git a/crypto/xxhash.c b/crypto/xxhash.c
new file mode 100644
index 0000000..b84c7cf
--- /dev/null
+++ b/crypto/xxhash.c
@@ -0,0 +1,383 @@
+/*
+ * xxHash - Fast Hash algorithm
+ * Copyright (C) 2012-2014, Yann Collet.
+ * BSD 2-Clause License (http://www.opensource.org/licenses/bsd-license.php)
+
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+
+ * Redistributions of source code must retain the above copyright notice,
+ * this list of conditions and the following disclaimer.
+ * Redistributions in binary form must reproduce the above
+ * copyright notice, this list of conditions and the following disclaimer
+ * in the documentation and/or other materials provided with the distribution.
+
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+
+ * You can contact the author at :
+ * xxHash source repository : http://code.google.com/p/xxhash/
+ */
+
+#include <crypto/internal/hash.h>
+#include <crypto/xxhash.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+
+static inline u32 XXH_readLE32_align(const u32 * ptr, XXH_endianess endian,
+				     XXH_alignment align)
+{
+	if (align == XXH_unaligned)
+		return endian ==
+		    XXH_littleEndian ? A32(ptr) : XXH_swap32(A32(ptr));
+	else
+		return endian == XXH_littleEndian ? *ptr : XXH_swap32(*ptr);
+}
+
+static inline u32 XXH_readLE32(const u32 * ptr, XXH_endianess endian)
+{
+	return XXH_readLE32_align(ptr, endian, XXH_unaligned);
+}
+
+/* Simple Hash Functions */
+static inline u32 XXH32_endian_align(const void *input, int len, u32 seed,
+				     XXH_endianess endian,
+				     XXH_alignment align)
+{
+	const u8 *p = (const u8 *)input;
+	const u8 *const bEnd = p + len;
+	u32 h32;
+
+#ifdef XXH_ACCEPT_NULL_INPUT_POINTER
+	if (p == NULL) {
+		len = 0;
+		p = (const u8 *)(size_t) 16;
+	}
+#endif
+	if (len >= 16) {
+		const u8 *const limit = bEnd - 16;
+		u32 v1 = seed + PRIME32_1 + PRIME32_2;
+		u32 v2 = seed + PRIME32_2;
+		u32 v3 = seed + 0;
+		u32 v4 = seed - PRIME32_1;
+		u32 tmp;
+
+		do {
+			tmp = XXH_readLE32_align((const u32 *)p, endian, align); 
+			v1 += tmp * PRIME32_2;
+			v1 = XXH_rotl32(v1, 13);
+			v1 *= PRIME32_1;
+			p += 4;
+
+			tmp = XXH_readLE32_align((const u32 *)p, endian, align); 
+			v2 += tmp * PRIME32_2;
+			v2 = XXH_rotl32(v2, 13);
+			v2 *= PRIME32_1;
+			p += 4;
+
+			tmp = XXH_readLE32_align((const u32 *)p, endian, align); 
+			v3 += tmp * PRIME32_2;
+			v3 = XXH_rotl32(v3, 13);
+			v3 *= PRIME32_1;
+			p += 4;
+
+			tmp = XXH_readLE32_align((const u32 *)p, endian, align); 
+			v4 += tmp * PRIME32_2;
+			v4 = XXH_rotl32(v4, 13);
+			v4 *= PRIME32_1;
+			p += 4;
+		} while (p <= limit);
+
+		h32 = XXH_rotl32(v1, 1) + XXH_rotl32(v2, 7) +
+		      XXH_rotl32(v3, 12) + XXH_rotl32(v4, 18);
+	} else {
+		h32 = seed + PRIME32_5;
+	}
+
+	h32 += (u32) len;
+
+	while (p <= bEnd - 4) {
+		h32 += XXH_readLE32_align((const u32 *)p, endian, align) *
+		       PRIME32_3;
+		h32 = XXH_rotl32(h32, 17) * PRIME32_4;
+		p += 4;
+	}
+
+	 while (p < bEnd) {
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
+static int XXH32_digest(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out)
+
+//const void *input, int len, u32 seed)
+
+{
+	u32 seed = 0;
+	u32 dst;
+
+	XXH_endianess endian_detected = (XXH_endianess) XXH_CPU_LITTLE_ENDIAN;
+
+#if !defined(XXH_USE_UNALIGNED_ACCESS)
+	/* Input is aligned, let's leverage the speed advantage */
+	if ((((size_t) data) & 3)) {
+		if ((endian_detected == XXH_littleEndian) ||
+		    XXH_FORCE_NATIVE_FORMAT)
+			dst = XXH32_endian_align(data, len, seed,
+						 XXH_littleEndian,
+						 XXH_aligned);
+		else
+			dst = XXH32_endian_align(data, len, seed,
+						 XXH_bigEndian, XXH_aligned);
+	}
+
+#endif
+	if ((endian_detected == XXH_littleEndian) || XXH_FORCE_NATIVE_FORMAT)
+		dst = XXH32_endian_align(data, len, seed, XXH_littleEndian,
+					 XXH_unaligned);
+	else
+		dst = XXH32_endian_align(data, len, seed, XXH_bigEndian,
+					 XXH_unaligned);
+
+	*(__le32 *)out = cpu_to_le32(dst);
+
+	return 0;
+}
+
+/* Advanced Hash Functions */
+static int XXH32_resetState(void *state_in, u32 seed)
+{
+	struct xxhash_state *state = (struct xxhash_state *)state_in;
+	state->seed = seed;
+	state->v1 = seed + PRIME32_1 + PRIME32_2;
+	state->v2 = seed + PRIME32_2;
+	state->v3 = seed + 0;
+	state->v4 = seed - PRIME32_1;
+	state->total_len = 0;
+	state->memsize = 0;
+	return 0;
+}
+
+static int XXH32_init(struct shash_desc *desc)
+{
+	struct xxhash_state *sctx = shash_desc_ctx(desc);
+	XXH32_resetState(sctx, 0);
+
+	return 0;
+}
+
+static inline int XXH32_update_endian(void *state_in, const void *input,
+				      int len, XXH_endianess endian)
+{
+	struct xxhash_state *state = (struct xxhash_state *)state_in;
+	const u8 *p = (const u8 *)input;
+	const u8 *const bEnd = p + len;
+
+#ifdef XXH_ACCEPT_NULL_INPUT_POINTER
+	if (input == NULL)
+		return -EINVAL;
+#endif
+	state->total_len += len;
+
+	if (state->memsize + len < 16) {	// fill in tmp buffer
+		memcpy(state->memory + state->memsize, input, len);
+		state->memsize += len;
+		return 0;
+	}
+
+	if (state->memsize) {	// some data left from previous update
+		memcpy(state->memory + state->memsize, input, 16 - state->memsize);
+
+		 {
+			const u32 *p32 = (const u32 *)state->memory;
+			state->v1 += XXH_readLE32(p32, endian) * PRIME32_2;
+			state->v1 = XXH_rotl32(state->v1, 13);
+			state->v1 *= PRIME32_1;
+			p32++;
+			state->v2 += XXH_readLE32(p32, endian) * PRIME32_2;
+			state->v2 = XXH_rotl32(state->v2, 13);
+			state->v2 *= PRIME32_1;
+			p32++;
+			state->v3 += XXH_readLE32(p32, endian) * PRIME32_2;
+			state->v3 = XXH_rotl32(state->v3, 13);
+			state->v3 *= PRIME32_1;
+			p32++;
+			state->v4 += XXH_readLE32(p32, endian) * PRIME32_2;
+			state->v4 = XXH_rotl32(state->v4, 13);
+			state->v4 *= PRIME32_1;
+			p32++;
+		}
+
+		p += 16 - state->memsize;
+		state->memsize = 0;
+	}
+	if (p <= bEnd - 16) {
+		const u8 *const limit = bEnd - 16;
+		u32 v1 = state->v1;
+		u32 v2 = state->v2;
+		u32 v3 = state->v3;
+		u32 v4 = state->v4;
+
+		do {
+			v1 += XXH_readLE32((const u32 *)p, endian) * PRIME32_2;
+			v1 = XXH_rotl32(v1, 13);
+			v1 *= PRIME32_1;
+			p += 4;
+
+			v2 += XXH_readLE32((const u32 *)p, endian) * PRIME32_2;
+			v2 = XXH_rotl32(v2, 13);
+			v2 *= PRIME32_1;
+			p += 4;
+
+			v3 += XXH_readLE32((const u32 *)p, endian) * PRIME32_2;
+			v3 = XXH_rotl32(v3, 13);
+			v3 *= PRIME32_1;
+			p += 4;
+
+			v4 += XXH_readLE32((const u32 *)p, endian) * PRIME32_2;
+			v4 = XXH_rotl32(v4, 13);
+			v4 *= PRIME32_1;
+			p += 4;
+		} while (p <= limit);
+
+		state->v1 = v1;
+		state->v2 = v2;
+		state->v3 = v3;
+		state->v4 = v4;
+	}
+
+	if (p < bEnd) {
+		memcpy(state->memory, p, bEnd - p);
+		state->memsize = (int)(bEnd - p);
+	}
+
+	return 0;
+}
+
+static int XXH32_update(struct shash_desc *desc, const u8 *data,
+			unsigned int len)
+{
+	struct xxhash_state *sctx = shash_desc_ctx(desc);
+
+	XXH_endianess endian_detected = (XXH_endianess) XXH_CPU_LITTLE_ENDIAN;
+
+	if ((endian_detected == XXH_littleEndian) || XXH_FORCE_NATIVE_FORMAT)
+		return XXH32_update_endian(sctx, data, len, XXH_littleEndian);
+	else
+		return XXH32_update_endian(sctx, data, len, XXH_bigEndian);
+}
+
+static inline u32 XXH32_intermediateDigest_endian(void *state_in,
+						  XXH_endianess endian)
+{
+	struct xxhash_state *state = (struct xxhash_state *)state_in;
+	const u8 *p = (const u8 *)state->memory;
+	u8 * bEnd = (u8 *) state->memory + state->memsize;
+	u32 h32;
+
+	if (state->total_len >= 16) {
+		h32 = XXH_rotl32(state->v1, 1) + XXH_rotl32(state->v2, 7) +
+		      XXH_rotl32(state->v3, 12) + XXH_rotl32(state->v4, 18);
+	} else {
+		h32 = state->seed + PRIME32_5;
+	}
+
+	h32 += (u32)state->total_len;
+
+	while (p <= bEnd - 4) {
+		h32 += XXH_readLE32((const u32 *)p, endian) * PRIME32_3;
+		h32 = XXH_rotl32(h32, 17) * PRIME32_4;
+		p += 4;
+	}
+
+	while (p < bEnd) {
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
+static u32 XXH32_intermediateDigest(void *state_in)
+{
+	XXH_endianess endian_detected = (XXH_endianess) XXH_CPU_LITTLE_ENDIAN;
+
+	if ((endian_detected == XXH_littleEndian) || XXH_FORCE_NATIVE_FORMAT)
+		return XXH32_intermediateDigest_endian(state_in,
+						       XXH_littleEndian);
+	else
+		return XXH32_intermediateDigest_endian(state_in, XXH_bigEndian);
+}
+
+static int XXH32_final(struct shash_desc *desc, u8 *out)
+{
+	struct xxhash_state *sctx = shash_desc_ctx(desc);
+	u32 dst = XXH32_intermediateDigest(sctx);
+
+	*(__le32 *)out = cpu_to_le32(dst);
+
+	return 0;
+}
+
+static struct shash_alg alg = {
+	.digestsize	= XXH32_DIGEST_SIZE,
+	.init		= XXH32_init,
+	.update		= XXH32_update,
+	.final		= XXH32_final,
+	.digest		= XXH32_digest,
+	.descsize	= sizeof(struct xxhash_state),
+	.statesize	= sizeof(struct xxhash_state),
+	.base		= {
+		.cra_name		= "xxh32",
+		.cra_blocksize		= XXH32_BLOCK_SIZE,
+		.cra_module		= THIS_MODULE,
+	 }
+};
+
+static int __init xxh32_mod_init(void)
+{
+	return crypto_register_shash(&alg);
+}
+
+static void __exit xxh32_mod_fini(void)
+{
+	crypto_unregister_shash(&alg);
+}
+
+module_init(xxh32_mod_init);
+module_exit(xxh32_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("XXHASH FAST Hash Algorithm");
+MODULE_ALIAS("xxhash");
diff --git a/include/crypto/xxhash.h b/include/crypto/xxhash.h
new file mode 100644
index 0000000..04e1b90
--- /dev/null
+++ b/include/crypto/xxhash.h
@@ -0,0 +1,209 @@
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
+#ifndef _CRPTO_XXHASH_H
+#define _CRPTO_XXHASH_H
+
+#include <linux/types.h>
+
+#define XXH32_DIGEST_SIZE 4
+#define XXH32_BLOCK_SIZE 16
+
+/*
+ * Unaligned memory access is automatically enabled for "common" CPU, such as x86.
+ * For others CPU, the compiler will be more cautious, and insert extra code to ensure aligned access is respected.
+ * If you know your target CPU supports unaligned memory access, you want to force this option manually to improve performance.
+ * You can also enable this parameter if you know your input data will always be aligned (boundaries of 4, for U32).
+ */
+#if defined(__ARM_FEATURE_UNALIGNED) || defined(__i386) || defined(_M_IX86) || defined(__x86_64__) || defined(_M_X64)
+	#define XXH_USE_UNALIGNED_ACCESS 1
+#endif
+
+/*
+ * XXH_ACCEPT_NULL_INPUT_POINTER :
+ * If the input pointer is a null pointer, xxHash default behavior is to trigger a memory access error, since it is a bad pointer.
+ * When this option is enabled, xxHash output for null input pointers will be the same as a null-length input.
+ * This option has a very small performance cost (only measurable on small inputs).
+ * By default, this option is disabled. To enable it, uncomment below define :
+ *
+ * #define XXH_ACCEPT_NULL_INPUT_POINTER 1
+ */
+
+/*
+ * XXH_FORCE_NATIVE_FORMAT :
+ * By default, xxHash library provides endian-independant Hash values, based on little-endian convention.
+ * Results are therefore identical for little-endian and big-endian CPU.
+ * This comes at a performance cost for big-endian CPU, since some swapping is required to emulate little-endian format.
+ * Should endian-independance be of no importance for your application, you may set the #define below to 1.
+ * It will improve speed for Big-endian CPU.
+ * This option has no impact on Little_Endian CPU.
+ */
+#define XXH_FORCE_NATIVE_FORMAT 0
+
+typedef struct _U32_S {
+	u32 v;
+} __attribute__ ((__packed__)) U32_S;
+
+#define A32(x) (((U32_S *)(x))->v)
+
+/* Compiler-specific Functions and Macros */
+#define XXH_rotl32(x,r) ((x << r) | (x >> (32 - r)))
+
+#if GCC_VERSION >= 40300
+	#define XXH_swap32 __builtin_bswap32
+#else
+	static inline u32 XXH_swap32(u32 x)
+	{
+		return ((x << 24) & 0xff000000) |
+			((x << 8) & 0x00ff0000) |
+			((x >> 8) & 0x0000ff00) |
+			((x >> 24) & 0x000000ff);
+	}
+#endif
+
+/* Constants */
+#define PRIME32_1   2654435761U
+#define PRIME32_2   2246822519U
+#define PRIME32_3   3266489917U
+#define PRIME32_4    668265263U
+#define PRIME32_5    374761393U
+
+/* Architecture Macros */
+typedef enum {
+	XXH_bigEndian=0,
+	XXH_littleEndian=1
+} XXH_endianess;
+
+#ifndef XXH_CPU_LITTLE_ENDIAN   // It is possible to define XXH_CPU_LITTLE_ENDIAN externally, for example using a compiler switch
+	static const int one = 1;
+	#define XXH_CPU_LITTLE_ENDIAN   (*(char*)(&one))
+#endif
+
+/* Macros */
+
+/* use only *after* variable declarations */
+#define XXH_STATIC_ASSERT(c)   { enum { XXH_static_assert = 1/(!!(c)) }; }
+
+/* Memory reads */
+typedef enum {
+	XXH_aligned,
+	XXH_unaligned
+} XXH_alignment;
+
+struct xxhash_state {
+	u64 total_len;
+	u32 seed;
+	u32 v1;
+	u32 v2;
+	u32 v3;
+	u32 v4;
+	int memsize;
+	char memory[16];
+};
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
+
+unsigned int XXH32 (const void* input, int len, unsigned int seed);
+*/
+
+
+
+//****************************
+// Advanced Hash Functions
+//****************************
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
+
+void*         XXH32_init   (unsigned int seed);
+XXH_errorcode XXH32_update (void* state, const void* input, int len);
+unsigned int  XXH32_final (void* state);
+*/
+
+#endif /* _CRYPTO_XXHASH_H */
-- 
1.8.1.4

