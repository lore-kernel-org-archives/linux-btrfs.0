Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794004900;
	b=jdGdWmCvFuPrEvGu96jhBS9Tp2AO3gKdJ7cVPVkJUbYEuFlISzeQx1XR3VgpuNEtEvjS
	 Ua8fR9LEDw8sQHdvvksndvBtUFkGEdj4C1BIjScq9C3VPj6aqbxl+c6XvPa3WeL8IQgPB
	 RYO4w9YEpwZcEtMWTbs/0brvUgT0LhT08b/QYvJVjuDm0y2/hTECAr257wR8LbXica/vj
	 DnAH5+8suHcV7/gQdbO9SgKwWJOX2FaixyeLbetanuSgSR/Qg2cvHFTim3q2sLpJcTXUP
	 H//0KHf8L9ufLrsqbYsC9Tx3iSFVsUkSug6S1EY/nuoWq7vSeF7s9hfawUCSBvEa+XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794004900;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=+wtudTUEdJcq8gxrIwsv1CiNXvcHUyHp9M8H7fT0q3E=;
	b=Hr9xARj/RbFVNOHEJ7fCWXZlsYudBRepma2akqp7/21iLdnXHcQSB71ZpnXWj577HE5J
	 4G7y49ewY64P1ohbrPW3THhlbyTheSGmpcAT/Fi+kjkWrshd0z4Z0lSvuueqrBek2qbNw
	 SfIPa/sRlvMHGdDAkvcI+HbN512EQlPj66wH87C1blulcBPmu1HGKVnX6NcKjs6/r7uKV
	 kqtWYZLI/NlpdnCjpFUBg2NhlF/dilbZ5uIg9aatJDqd9/YDdypPzGtvbV5w+fbGXSvdP
	 sW2+8A4sfSvEF9z+1paNEjYZWxWm3dmMBUOdAgAB40r2VcoONyz3sr4P9CKOD0xz8RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HSvnhEtJ;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=rEDQTGph;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B433606A332
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 22:41:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B433606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HSvnhEtJ;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=rEDQTGph
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5241E1F443
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 22:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794004897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+wtudTUEdJcq8gxrIwsv1CiNXvcHUyHp9M8H7fT0q3E=;
	b=HSvnhEtJZDkIwn4JUwLbOQRqjQgbvlezMjb2NukexYf2SklKmTm3Rl1XYPfbJ4H5sa5oWY
	EfALVZS81cctkbuIK0VizgR/lrv9oeUvSDSsgU6jvPUM7zO56HOd0ccljrrgLoZfHvU7vO
	+ud+ZJCaAD4ijXxArB7up6kOT4s0rBU=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794004896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+wtudTUEdJcq8gxrIwsv1CiNXvcHUyHp9M8H7fT0q3E=;
	b=rEDQTGph8C4j5aK53gkUMhQ4cXxjQOyK1WKFjqRl/jLv8bn0u3HhOmFHAzDWKpxGvdjNHz
	fypVbpTNP99rGgm5Jhjy4W8AZDJTQf4PA1d9mo1MMVbI9x2bUKs6P5T7d+LLxqajLy2/hN
	nTp14i7Vzn0UJGEwiiGqGiWG9KUkEns=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 20814134F4
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 22:41:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NBMWKpxX7moVbQAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2026 22:41:34 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: cleanup inline asm usage
Date: Sat,  7 Nov 2026 09:11:13 +1030
Message-ID: <e785277ae0493c2e0f9c07c7720cff84ba4c0fb2.1794003341.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794003341.git.wqu@suse.com>
References: <cover.1794003341.git.wqu@suse.com>
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[wikipedia.org:url,imap1.dmz-prg2.suse.org:helo,suse.com:email,intel.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,suse.com:email];
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

