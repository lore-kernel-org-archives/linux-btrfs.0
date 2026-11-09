Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794197426;
	b=nmJOIjmt97h+5QvW0ik2XMFAazxXCFvaqIg7PcFl2cxHGWN4t3SuMDKSJRvgGx+SSn6z
	 VY+rXZtN2IkQXwBAlKtf0/88A4uYqCZ0yTNZ6tPMXRd7A1hNCTtKYuahJXwzbmgYRqR4z
	 vxactwVFK4ZU5CsJ1ayxpq+BT6E0GiBBx0rEw+qZ5/DokhwZaYyu1Edm5WtsL4s0DQF/4
	 fqpkcpFUBZfHPVpCdsUGPGWTnuOQay7RSpUaWmWY/1wtsQO0y5QGbReunzRrECQmaleBR
	 d3lA+Nk6BRyjjB5pdZIGpUpWehdg3sDTZFRuo1MgP9Vuuj0bxsHzJSEXx6dPSA6KTaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794197426;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=+wtudTUEdJcq8gxrIwsv1CiNXvcHUyHp9M8H7fT0q3E=;
	b=puVUmHgi+MRhNleKhVgUrbGtvaljJrkibivoDX8SnX/Yd+vwQ4b19T8k+jIeF2RNxqZ7
	 HIRWtS6NyqF9PJLKo3lLfiPzIYDymlrQIAXsvYJEEJU5bl8ooFT2y8E0rxJiQZBhDXe7x
	 HuS15WYJxmSq7mBrqsuZeD/jCWgQi6LD4f4VeogfCL28eJqI9L/DF8MlUMDo2UlR42EFE
	 ehLYs1cL3/IDgeB51mUXAHdqjZL4omcNzeTufgXtWhoJwfPi4xr5lv+e4bO2kwu36M+t0
	 WD0PY4K4Fw6LpEMc9Q+qunM/nR0eCixsVwl+vvqdZ7lN+552Jhefs/OZy751pQuPJPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="o+JwrGZ/";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="o+JwrGZ/";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4591D606A31C
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4591D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=o+JwrGZ/;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=o+JwrGZ/
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5936922155
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+wtudTUEdJcq8gxrIwsv1CiNXvcHUyHp9M8H7fT0q3E=;
	b=o+JwrGZ/9nKKrjSNX5XuVdFvEOXsCvsi4RQ1frLV8UqtQTReGbcbewyhWQIgOlrlZwGwl5
	F9HOXQqcWdk5V3UAMUclqAuYcqE9YCaSUGcOmoRRfy8Mi85t8jXrDOb+s6RotKuMiuHl6n
	XbWa1D2HfFAFCUr6RN1iGOET67uzo7Y=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+wtudTUEdJcq8gxrIwsv1CiNXvcHUyHp9M8H7fT0q3E=;
	b=o+JwrGZ/9nKKrjSNX5XuVdFvEOXsCvsi4RQ1frLV8UqtQTReGbcbewyhWQIgOlrlZwGwl5
	F9HOXQqcWdk5V3UAMUclqAuYcqE9YCaSUGcOmoRRfy8Mi85t8jXrDOb+s6RotKuMiuHl6n
	XbWa1D2HfFAFCUr6RN1iGOET67uzo7Y=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3EA9113479
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AKhEN6tH8WrIZAAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 04:10:21 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/7] btrfs-progs: cleanup inline asm usage
Date: Mon,  9 Nov 2026 14:39:55 +1030
Message-ID: <7b5c87adfcec07020bfe171d950f1a3e85f9a56e.1794196688.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794196688.git.wqu@suse.com>
References: <cover.1794196688.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,wikipedia.org:url,intel.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

Both clang and gcc have lowlevel instruction wrappers already, there is
no need to use inline asm just for several small operations like cpuid.

The cleanup includes:

- Use compiler wrappers to replace inlined asm

- Add dedicated target attributes for involved hardware acceleration

Asssited-by: LLM (locating the wrappers)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/cpu-utils.c      | 31 ++++-------------------------
 crypto/crc32c.c         | 20 ++++++++-----------
 crypto/hash-speedtest.c | 14 +++-----------
 libbtrfs/crc32c.c       | 43 +++++++++++------------------------------
 4 files changed, 26 insertions(+), 82 deletions(-)

diff --git a/common/cpu-utils.c b/common/cpu-utils.c
index 32914d360e63..a99efb932ff2 100644
--- a/common/cpu-utils.c
+++ b/common/cpu-utils.c
@@ -15,37 +15,14 @@
  */
 
 #include <stdio.h>
+#ifdef __x86_64__
+#include <cpuid.h>
+#endif
 #include "common/cpu-utils.h"
 
 unsigned long __cpu_flags = CPU_FLAG_NONE;
 unsigned long __cpu_flags_orig = CPU_FLAG_NONE;
 
-#ifdef __x86_64__
-/*
- * Do manual cpuid as cpuid.h is not available for all versions.
- *
- * Plain cpuid(level) is __cpuidex(level, 0), otherwise look for the leaf/subleaf
- * modes at https://en.wikipedia.org/wiki/CPUID or compilers' cpuid.h.
- */
-
-#ifndef __cpuidex
-#define __cpuidex(leaf, subleaf, a, b, c, d)				\
-	__asm__ __volatile__ ("cpuid\n\t"				\
-			: "=a" (a), "=b" (b), "=c" (c), "=d" (d)	\
-			: "0" (leaf), "2" (subleaf))
-#endif
-
-#else
-
-#define __cpuidex(leaf, subleaf, a, b, c, d)				\
-	do {								\
-		a = 0;							\
-		b = 0;							\
-		c = 0;							\
-		d = 0;							\
-	} while(0)
-#endif
-
 #define FLAG(name)	if (__cpu_flags & CPU_FLAG_ ## name) printf(" " #name)
 void cpu_print_flags(void) {
 	printf("CPU flags: 0x%lx\n", __cpu_flags);
@@ -88,7 +65,7 @@ void cpu_detect_flags(void)
 		__cpu_flags |= CPU_FLAG_AVX2;
 
 	/* Flags unsupported by builtins */
-	__cpuidex(7, 0, a, b, c, d);
+	__cpuid_count(7, 0, a, b, c, d);
 	if (b & (1UL << 29))
 		__cpu_flags |= CPU_FLAG_SHA;
 
diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index f0a23f836741..9a3c9fc14eab 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -18,6 +18,8 @@ static uint32_t (*crc32c_impl)(uint32_t crc, unsigned char const *data, uint32_t
 
 #ifdef __x86_64__
 
+#include <nmmintrin.h>
+
 /* asmlinkage */ unsigned int crc_pcl(const unsigned char *buffer, unsigned int len, unsigned int crc_init);
 static unsigned int crc32c_pcl(uint32_t crc, unsigned char const *data, uint32_t len) {
 	return crc_pcl(data, len, crc);
@@ -34,22 +36,19 @@ static unsigned int crc32c_pcl(uint32_t crc, unsigned char const *data, uint32_t
  * Volume 2A: Instruction Set Reference, A-M
  */
 #if  __SIZEOF_LONG__ == 8
-#define REX_PRE "0x48, "
 #define SCALE_F 8
+#define crc32c_hw_long(crc, v)	_mm_crc32_u64((crc), (v))
 #else
-#define REX_PRE
 #define SCALE_F 4
+#define crc32c_hw_long(crc, v)	_mm_crc32_u32((crc), (v))
 #endif
 
+__attribute__((target("sse4.2")))
 static uint32_t crc32c_intel_le_hw_byte(uint32_t crc, unsigned char const *data,
 					uint32_t length)
 {
 	while (length--) {
-		__asm__ __volatile__(
-			".byte 0xf2, 0xf, 0x38, 0xf0, 0xf1"
-			:"=S"(crc)
-			:"0"(crc), "c"(*data)
-		);
+		crc = _mm_crc32_u8(crc, *data);
 		data++;
 	}
 
@@ -61,6 +60,7 @@ static uint32_t crc32c_intel_le_hw_byte(uint32_t crc, unsigned char const *data,
  * Steps through buffer one byte at at time, calculates reflected crc using
  * table.
  */
+__attribute__((target("sse4.2")))
 static uint32_t crc32c_sse42(uint32_t crc, unsigned char const *data, uint32_t length)
 {
 	unsigned int iquotient = length / SCALE_F;
@@ -68,11 +68,7 @@ static uint32_t crc32c_sse42(uint32_t crc, unsigned char const *data, uint32_t l
 	unsigned long *ptmp = (unsigned long *)data;
 
 	while (iquotient--) {
-		__asm__ __volatile__(
-			".byte 0xf2, " REX_PRE "0xf, 0x38, 0xf1, 0xf1;"
-			:"=S"(crc)
-			:"0"(crc), "c"(*ptmp)
-		);
+		crc = crc32c_hw_long(crc, *ptmp);
 		ptmp++;
 	}
 
diff --git a/crypto/hash-speedtest.c b/crypto/hash-speedtest.c
index 6caa89f7d6f8..95ba63ee6025 100644
--- a/crypto/hash-speedtest.c
+++ b/crypto/hash-speedtest.c
@@ -30,6 +30,7 @@
 #include "common/cpu-utils.h"
 
 #ifdef __x86_64__
+#include <x86intrin.h>
 static const int cycles_supported = 1;
 #else
 static const int cycles_supported = 0;
@@ -45,19 +46,10 @@ const int blocksize = 4096;
 int iterations = 100000;
 
 #ifdef __x86_64__
-static __always_inline unsigned long long rdtsc(void)
-{
-	unsigned low, high;
-
-        asm volatile("rdtsc" : "=a" (low), "=d" (high));
-
-        return (low | ((u64)(high) << 32));
-}
-
 static inline u64 read_tsc(void)
 {
-       asm volatile("mfence");
-       return rdtsc();
+	_mm_mfence();
+	return __rdtsc();
 }
 
 #define cpu_cycles()		read_tsc()
diff --git a/libbtrfs/crc32c.c b/libbtrfs/crc32c.c
index 4391e46f16ee..14c1694a2823 100644
--- a/libbtrfs/crc32c.c
+++ b/libbtrfs/crc32c.c
@@ -16,6 +16,9 @@ static uint32_t (*crc_function)(uint32_t crc, unsigned char const *data, uint32_
 
 #ifdef __x86_64__
 
+#include <cpuid.h>
+#include <nmmintrin.h>
+
 /*
  * Based on a posting to lkml by Austin Zhang <austin.zhang@intel.com>
  *
@@ -27,25 +30,22 @@ static uint32_t (*crc_function)(uint32_t crc, unsigned char const *data, uint32_
  * Volume 2A: Instruction Set Reference, A-M
  */
 #if  __SIZEOF_LONG__ == 8
-#define REX_PRE "0x48, "
 #define SCALE_F 8
+#define crc32c_hw_long(crc, v)	_mm_crc32_u64((crc), (v))
 #else
-#define REX_PRE
 #define SCALE_F 4
+#define crc32c_hw_long(crc, v)	_mm_crc32_u32((crc), (v))
 #endif
 
 static int crc32c_probed = 0;
 static int crc32c_intel_available = 0;
 
+__attribute__((target("sse4.2")))
 static uint32_t crc32c_intel_le_hw_byte(uint32_t crc, unsigned char const *data,
 					uint32_t length)
 {
 	while (length--) {
-		__asm__ __volatile__(
-			".byte 0xf2, 0xf, 0x38, 0xf0, 0xf1"
-			:"=S"(crc)
-			:"0"(crc), "c"(*data)
-		);
+		crc = _mm_crc32_u8(crc, *data);
 		data++;
 	}
 
@@ -56,6 +56,7 @@ static uint32_t crc32c_intel_le_hw_byte(uint32_t crc, unsigned char const *data,
  * Steps through buffer one byte at at time, calculates reflected 
  * crc using table.
  */
+__attribute__((target("sse4.2")))
 static uint32_t crc32c_intel(uint32_t crc, unsigned char const *data, uint32_t length)
 {
 	unsigned int iquotient = length / SCALE_F;
@@ -63,11 +64,7 @@ static uint32_t crc32c_intel(uint32_t crc, unsigned char const *data, uint32_t l
 	unsigned long *ptmp = (unsigned long *)data;
 
 	while (iquotient--) {
-		__asm__ __volatile__(
-			".byte 0xf2, " REX_PRE "0xf, 0x38, 0xf1, 0xf1;"
-			:"=S"(crc)
-			:"0"(crc), "c"(*ptmp)
-		);
+		crc = crc32c_hw_long(crc, *ptmp);
 		ptmp++;
 	}
 
@@ -78,31 +75,13 @@ static uint32_t crc32c_intel(uint32_t crc, unsigned char const *data, uint32_t l
 	return crc;
 }
 
-static void do_cpuid(unsigned int *eax, unsigned int *ebx, unsigned int *ecx,
-		     unsigned int *edx)
-{
-	int id = *eax;
-
-	asm("movl %4, %%eax;"
-	    "cpuid;"
-	    "movl %%eax, %0;"
-	    "movl %%ebx, %1;"
-	    "movl %%ecx, %2;"
-	    "movl %%edx, %3;"
-		: "=r" (*eax), "=r" (*ebx), "=r" (*ecx), "=r" (*edx)
-		: "r" (id)
-		: "eax", "ebx", "ecx", "edx");
-}
-
 static void crc32c_intel_probe(void)
 {
 	if (!crc32c_probed) {
 		unsigned int eax, ebx, ecx, edx;
 
-		eax = 1;
-
-		do_cpuid(&eax, &ebx, &ecx, &edx);
-		crc32c_intel_available = (ecx & (1U << 20)) != 0;
+		__cpuid(1, eax, ebx, ecx, edx);
+		crc32c_intel_available = (ecx & bit_SSE4_2) != 0;
 		crc32c_probed = 1;
 	}
 }
-- 
2.56.0

