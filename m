Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795137581;
	b=vlLIPSmBsel3WACKSsphlnEpPfjIeCubkFVy6CzMiDDS1v46h7swkcYAaB1earIXotfg
	 7wtUqDALOkFIXmCsYU3dVwpgX/mr/mNPeqE3+cXVP4RB49l0xlkRyr1/gRTqbbr4p7yuz
	 tbUztowa8UGleob5ORMY4yBnkxjRgtgkTE10bET6S+705l+7PoKwBV5i+1jzlfzb62res
	 RTpYx5mG8rU6ggL5y6qNI2qg7icVUkyFZUc7Z/RRYU5yQ6kYtztaiDc6YKSX9mhw4p3fL
	 PMr8XRkGSXxIWDrUs6czrYE4E0l0uXVJ2Wrv0A9Ao7VKdebfu2+TVdWOwF9n1VfOpOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795137581;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=4znkSWFj7XJpgs+AA2VxqOkatqvUE4zsG/cMIHG8qUM=;
	b=qVUruYo1HyGj0Tw2WgvdGJt1A3+rfS/0Mi1cGkV6sQQGjp/lT/K3Pkytn9U4BfdNzB2N
	 lKi981bzvHDTf3DhKGLC3/XiB/4goucSeGtlOW9QBKiat2/VMjgYdGQcuyDr4XaB4FNEy
	 I598XRtobQorleZoemChqNTJYn1D00hBL3KdatOEY71GLYJeIAg/HGSWuLrFNYq2N8ANS
	 RHqaYIFlIytijsgCRhfVWeB2EEDeitXhOK8lU0iOiXImSMbj5ElerLdBXHXBs/dxobovA
	 x1FM+scDdELRdmL41YFsJ9H8UEwo8o5v43kcMc+JoLP+jSeKKqJG8vQiWkz6rRZYy2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OWoGIsLm;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OWoGIsLm;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C9A606A325;
	Fri, 20 Nov 2026 01:19:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29C9A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OWoGIsLm;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OWoGIsLm
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4A3DA1FA8D;
	Fri, 20 Nov 2026 01:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795137578; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4znkSWFj7XJpgs+AA2VxqOkatqvUE4zsG/cMIHG8qUM=;
	b=OWoGIsLmpas+1axJbFwYHoOWALJfKakeS6WaI1ASkH8oaz+6oIdcqT85XhuPbIQlYgqTDz
	OiZ3nutwzOcRx8CGLChWOEOMioZk3AsrCvh1pZqM7TJFZxyutv2bjobamEG53VNGvGzwo3
	P2NGnTRKXXSLMxAfEZPZuFxgR1rrAa0=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=OWoGIsLm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795137578; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4znkSWFj7XJpgs+AA2VxqOkatqvUE4zsG/cMIHG8qUM=;
	b=OWoGIsLmpas+1axJbFwYHoOWALJfKakeS6WaI1ASkH8oaz+6oIdcqT85XhuPbIQlYgqTDz
	OiZ3nutwzOcRx8CGLChWOEOMioZk3AsrCvh1pZqM7TJFZxyutv2bjobamEG53VNGvGzwo3
	P2NGnTRKXXSLMxAfEZPZuFxgR1rrAa0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 13CEE1342D;
	Fri, 20 Nov 2026 01:19:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f6GRNh6g/2r1FAAAD6G6ig:T4
	(envelope-from <wqu@suse.com>); Fri, 20 Nov 2026 01:19:35 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org,
	ardb@kernel.org
Subject: [PATCH RFC v2 3/6] lib/crc: x86: Convert crc32_lsb_*() from assembly to C
Date: Fri, 20 Nov 2026 11:49:01 +1030
Message-ID: <f5577a87c45cd4b5ef4fa8ace3b0a05c3f9fddd3.1795137348.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795137348.git.wqu@suse.com>
References: <cover.1795137348.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 4A3DA1FA8D
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

Rewrite the three crc32_lsb functions (PCLMULQDQ with SSE4.1, and
VPCLMULQDQ with AVX2 or AVX512BW/VL) in C using the compiler's
intrinsics, through asm/x86-intrinsics.h.

crc-pclmul-impl.h is the C version of crc-pclmul-template.S: a template,
included once per function with the vector length, CRC width and bit order
defined by the includer.  Only what crc32_lsb needs is in it for now.

crc-pclmul-helpers.h has the small helpers: the loads and the fold step
for each vector length.

Each function and helper has a target attribute for the ISA extensions it
needs, so all the vector lengths are in one file.  The compiler can only
use those extensions inside the functions that run after the CPU feature
checks.

Build changes:
- crc32-pclmul.c replaces crc32-pclmul.S.  It only needs the compiler's
  include path, in x86-intrin-cflags.

Known issue: GCC 8.1 and 8.2, the oldest compilers the kernel supports, can
not build the AVX2 function.  Their <vpclmulqdqintrin.h> declares
_mm256_clmulepi64_epi128() with avx512vl in its target, which fold256() does
not have, so the call can not be inlined:

  error: inlining failed in call to always_inline
  '_mm256_clmulepi64_epi128': target specific option mismatch

GCC 8.3 and later only need avx there. Not sure if we still need to
support 8.1 and 8.2.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 lib/crc/Makefile                 |   1 +
 lib/crc/x86/crc-pclmul-helpers.h |  72 +++++++++
 lib/crc/x86/crc-pclmul-impl.h    | 258 +++++++++++++++++++++++++++++++
 lib/crc/x86/crc32-pclmul.S       |   6 -
 lib/crc/x86/crc32-pclmul.c       |  22 +++
 5 files changed, 353 insertions(+), 6 deletions(-)
 create mode 100644 lib/crc/x86/crc-pclmul-helpers.h
 create mode 100644 lib/crc/x86/crc-pclmul-impl.h
 delete mode 100644 lib/crc/x86/crc32-pclmul.S
 create mode 100644 lib/crc/x86/crc32-pclmul.c

diff --git a/lib/crc/Makefile b/lib/crc/Makefile
index cd7ff35193ad..baca818f76f7 100644
--- a/lib/crc/Makefile
+++ b/lib/crc/Makefile
@@ -37,6 +37,7 @@ crc32-$(CONFIG_SPARC) += sparc/crc32c_asm.o
 crc32-$(CONFIG_X86) += x86/crc32-pclmul.o
 crc32-$(CONFIG_X86_64) += x86/crc32c-3way.o
 CFLAGS_x86/crc32c-3way.o += $(x86-intrin-cflags)
+CFLAGS_x86/crc32-pclmul.o += $(x86-intrin-cflags)
 endif
 
 obj-$(CONFIG_CRC64) += crc64.o
diff --git a/lib/crc/x86/crc-pclmul-helpers.h b/lib/crc/x86/crc-pclmul-helpers.h
new file mode 100644
index 000000000000..c4bac60220f3
--- /dev/null
+++ b/lib/crc/x86/crc-pclmul-helpers.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Small helpers shared by the C-intrinsics versions of the [V]PCLMULQDQ-based
+ * CRC functions.  Each helper has the target attribute for the ISA extensions
+ * it needs, so that they can be used by the functions with the same or a
+ * wider target.
+ *
+ * Copyright 2025 Google LLC
+ *
+ * Author: Eric Biggers <ebiggers@google.com>
+ */
+#ifndef _CRC_PCLMUL_HELPERS_H
+#define _CRC_PCLMUL_HELPERS_H
+
+#include <linux/types.h>
+#include <asm/x86-intrinsics.h>
+
+/* The ISA extensions needed for each vector length */
+#define CRC_TARGET_128	"sse4.1,pclmul"
+#define CRC_TARGET_256	"sse4.1,pclmul,avx2,vpclmulqdq"
+#define CRC_TARGET_512	"sse4.1,pclmul,avx2,vpclmulqdq,avx512f,avx512bw,avx512vl"
+
+/* The target attributes of the helpers, to keep their signatures short */
+#define __crc128	__attribute__((target(CRC_TARGET_128)))
+#define __crc256	__attribute__((target(CRC_TARGET_256)))
+#define __crc512	__attribute__((target(CRC_TARGET_512)))
+
+static __always_inline __crc128 __m128i loadu128(const u8 *p)
+{
+	return _mm_loadu_si128((const __m128i *)p);
+}
+
+/*
+ * Fold acc into data, across the distance that k was generated for: the qwords
+ * of k and acc with the same index are multiplied.  The compilers turn the
+ * three-way XOR into a single ternary logic instruction if the target has it.
+ */
+static __always_inline __crc128 __m128i fold128(__m128i acc, __m128i data, __m128i k)
+{
+	__m128i lo = _mm_clmulepi64_si128(acc, k, 0x00);
+	__m128i hi = _mm_clmulepi64_si128(acc, k, 0x11);
+
+	return _mm_xor_si128(_mm_xor_si128(hi, data), lo);
+}
+
+static __always_inline __crc256 __m256i loadu256(const u8 *p)
+{
+	return _mm256_loadu_si256((const __m256i *)p);
+}
+
+static __always_inline __crc256 __m256i fold256(__m256i acc, __m256i data, __m256i k)
+{
+	__m256i lo = _mm256_clmulepi64_epi128(acc, k, 0x00);
+	__m256i hi = _mm256_clmulepi64_epi128(acc, k, 0x11);
+
+	return _mm256_xor_si256(_mm256_xor_si256(hi, data), lo);
+}
+
+static __always_inline __crc512 __m512i loadu512(const u8 *p)
+{
+	return _mm512_loadu_si512(p);
+}
+
+static __always_inline __crc512 __m512i fold512(__m512i acc, __m512i data, __m512i k)
+{
+	__m512i lo = _mm512_clmulepi64_epi128(acc, k, 0x00);
+	__m512i hi = _mm512_clmulepi64_epi128(acc, k, 0x11);
+
+	return _mm512_ternarylogic_epi64(hi, data, lo, 0x96);
+}
+
+#endif /* _CRC_PCLMUL_HELPERS_H */
diff --git a/lib/crc/x86/crc-pclmul-impl.h b/lib/crc/x86/crc-pclmul-impl.h
new file mode 100644
index 000000000000..50fdbadd4b9a
--- /dev/null
+++ b/lib/crc/x86/crc-pclmul-impl.h
@@ -0,0 +1,258 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Template for the [V]PCLMULQDQ-based CRC functions, using C intrinsics
+ *
+ * This is the C version of the crc-pclmul-template.S that these functions were
+ * generated from.  It is a template, not a normal header: each inclusion
+ * generates one function, so a file includes it once for each function, after
+ * the includer has defined:
+ *
+ * VL		The vector length in bytes: 16 (PCLMULQDQ with SSE4.1), 32
+ *		(VPCLMULQDQ with AVX2) or 64 (VPCLMULQDQ with AVX512BW/VL).  The
+ *		function gets the matching target attribute.
+ * CRC_BITS	The number of bits in the CRC.  Currently only 32 is supported.
+ * CRC_FUNC	The name of the function to generate.  Its prototype is
+ *
+ *	crc_t CRC_FUNC(crc_t crc, const u8 *p, size_t len, const void *consts);
+ *
+ * |crc| is the initial CRC, |len| is the data length in bytes, which must be at
+ * least 16, and |consts| points to the fold_across_128_bits_consts field of the
+ * constants generated by scripts/gen-crc-consts.py for the chosen CRC.
+ *
+ * Only least-significant-bit-first CRCs are supported so far.
+ *
+ * VL and CRC_FUNC are undefined at the end of the template, so they have to be
+ * defined again before each inclusion.  CRC_BITS is kept, so it can be defined
+ * once for all the inclusions in a file.
+ *
+ * Copyright 2025 Google LLC
+ *
+ * Author: Eric Biggers <ebiggers@google.com>
+ */
+
+#include "crc-pclmul-helpers.h"
+
+#define crc_t		u32
+#define CRC_TO_VEC(crc)	_mm_cvtsi32_si128(crc)
+
+#if VL == 16
+#define CRC_TARGET	CRC_TARGET_128
+#define VEC		__m128i
+#define LOG2_VL		4
+#define VLOAD(p)	loadu128(p)
+#define VXOR(a, b)	_mm_xor_si128(a, b)
+#define VZEXT(x)	(x)
+#define VBCAST(x)	(x)
+#define VFOLD(a, d, k)	fold128(a, d, k)
+#elif VL == 32
+#define CRC_TARGET	CRC_TARGET_256
+#define VEC		__m256i
+#define LOG2_VL		5
+#define VLOAD(p)	loadu256(p)
+#define VXOR(a, b)	_mm256_xor_si256(a, b)
+#define VZEXT(x)	_mm256_inserti128_si256(_mm256_setzero_si256(), x, 0)
+#define VBCAST(x)	_mm256_broadcastsi128_si256(x)
+#define VFOLD(a, d, k)	fold256(a, d, k)
+#else
+#define CRC_TARGET	CRC_TARGET_512
+#define VEC		__m512i
+#define LOG2_VL		6
+#define VLOAD(p)	loadu512(p)
+#define VXOR(a, b)	_mm512_xor_si512(a, b)
+#define VZEXT(x)	_mm512_inserti32x4(_mm512_setzero_si512(), x, 0)
+#define VBCAST(x)	_mm512_broadcast_i32x4(x)
+#define VFOLD(a, d, k)	fold512(a, d, k)
+#endif /* VL == 16 */
+
+#define LOAD128(p)	loadu128(p)
+#define LOAD256(p)	loadu256(p)
+/* The constants for folding across 2^i vectors of length VL */
+#define FOLD_CONSTS(i)	VBCAST(consts[4 - LOG2_VL - (i)])
+
+__attribute__((target(CRC_TARGET)))
+crc_t CRC_FUNC(crc_t crc, const u8 *p, size_t len, const void *consts_ptr);
+
+/*
+ * |consts_ptr| points to fold_across_128_bits_consts.  The fold constants for
+ * 256, 512, 1024 and 2048 bits are right before it.  The shuffle table and the
+ * Barrett reduction constants follow it.
+ *
+ * The first vector of data, with the initial CRC XORed into it, is folded into
+ * the next ones, 4 vectors at a time, then 2 and 1 at a time for the data that
+ * remains.  Then the accumulator is narrowed down to 128 bits, by folding the
+ * upper half into the lower one, and what remains after that is reduced to the
+ * CRC.  The remaining length is tracked by the low bits of |len|, which the
+ * loops do not change: len & VL means one more vector is left after the 4- and
+ * 2-vector steps, and so on.
+ */
+__attribute__((target(CRC_TARGET)))
+crc_t CRC_FUNC(crc_t crc, const u8 *p, size_t len, const void *consts_ptr)
+{
+	const __m128i *consts = consts_ptr;
+	const u8 *shuf_table = (const u8 *)consts + 16;
+	__m128i x0, x1, k128 = consts[0];
+	VEC v0, v1, v2, v3, k;
+#if VL >= 32
+	__m256i y0;
+#endif /* VL >= 32 */
+#if VL == 64
+	__m256i k256;
+#endif /* VL == 64 */
+	size_t rem;
+
+	/* The initial CRC goes in the end holding the high-order coefficients. */
+	x0 = CRC_TO_VEC(crc);
+
+	/* len >= 16 is guaranteed, but not len >= VL. */
+#if VL >= 32
+	if (len < 32) {
+		x0 = _mm_xor_si128(x0, LOAD128(p));
+		p += 16;
+		goto fold_done;
+	}
+#endif /* VL >= 32 */
+#if VL == 64
+	if (len < 64) {
+		y0 = _mm256_xor_si256(
+			_mm256_inserti128_si256(_mm256_setzero_si256(), x0, 0),
+			LOAD256(p));
+		p += 32;
+		goto fold_256_to_128;
+	}
+#endif /* VL == 64 */
+
+	v0 = VXOR(VZEXT(x0), VLOAD(p));
+	if (len < 2 * VL) {
+		p += VL;
+		goto fold_narrow;
+	}
+	if (len < 4 * VL) {
+		v1 = VLOAD(p + VL);
+		p += 2 * VL;
+		goto fold_2_to_1;
+	}
+
+	v1 = VLOAD(p + 1 * VL);
+	v2 = VLOAD(p + 2 * VL);
+	v3 = VLOAD(p + 3 * VL);
+	p += 4 * VL;
+	len -= 4 * VL;
+
+	/* Fold v0-v3 into the next 4 vectors of data. */
+	if (len >= 4 * VL) {
+		k = FOLD_CONSTS(2);
+		do {
+			v0 = VFOLD(v0, VLOAD(p + 0 * VL), k);
+			v1 = VFOLD(v1, VLOAD(p + 1 * VL), k);
+			v2 = VFOLD(v2, VLOAD(p + 2 * VL), k);
+			v3 = VFOLD(v3, VLOAD(p + 3 * VL), k);
+			p += 4 * VL;
+			len -= 4 * VL;
+		} while (len >= 4 * VL);
+	}
+
+	/* Fold v0,v1 into v2,v3, then 2 more vectors if any. */
+	k = FOLD_CONSTS(1);
+	v0 = VFOLD(v0, v2, k);
+	v1 = VFOLD(v1, v3, k);
+	if (len & (2 * VL)) {
+		v0 = VFOLD(v0, VLOAD(p + 0 * VL), k);
+		v1 = VFOLD(v1, VLOAD(p + 1 * VL), k);
+		p += 2 * VL;
+	}
+
+fold_2_to_1:
+	/* Fold v0 into v1, then 1 more vector if any. */
+	k = FOLD_CONSTS(0);
+	v0 = VFOLD(v0, v1, k);
+	if (len & VL) {
+		v0 = VFOLD(v0, VLOAD(p), k);
+		p += VL;
+	}
+
+fold_narrow:
+#if VL == 64
+	/* Fold v0 into 256 bits, then 1 more 256-bit vector if any. */
+	k256 = _mm256_broadcastsi128_si256(consts[-1]);
+	y0 = fold256(_mm512_castsi512_si256(v0),
+		     _mm512_extracti64x4_epi64(v0, 1), k256);
+	if (len & 32) {
+		y0 = fold256(y0, LOAD256(p), k256);
+		p += 32;
+	}
+
+fold_256_to_128:
+#endif /* VL == 64 */
+#if VL >= 32
+#if VL == 32
+	y0 = v0;
+#endif /* VL == 32 */
+	/* Fold y0 into 128 bits, then 1 more 128-bit vector if any. */
+	x0 = fold128(_mm256_castsi256_si128(y0),
+		     _mm256_extracti128_si256(y0, 1), k128);
+	if (len & 16) {
+		x0 = fold128(x0, LOAD128(p), k128);
+		p += 16;
+	}
+
+fold_done:
+#else
+	x0 = v0;
+#endif /* VL >= 32 */
+	rem = len & 15;
+	if (rem) {
+		/*
+		 * 1 <= rem <= 15 data bytes remain.  The polynomial is now
+		 * A*(x^(8*rem)) + B, where A is the 128-bit polynomial in x0 and
+		 * B is the polynomial of the remaining bytes.  To avoid needing
+		 * fold constants for every rem, rearrange it into
+		 * C1*(x^128) + C2, where C1 = floor(A / x^(128 - 8*rem)) and
+		 * C2 = A*x^(8*rem) + B mod x^128, then fold C1 into C2.  The
+		 * shuffle table does the shifts of A: by rem bytes one way for
+		 * C2, and by 16 - rem the other way for C1.  The last 16 bytes
+		 * of the data are B, with A*x^(8*rem) blended in.
+		 */
+		const u8 *mask_c2 = shuf_table + 16 + rem;
+		const u8 *mask_c1 = shuf_table + rem;
+		__m128i last16 = LOAD128(p + rem - 16);
+		__m128i mask = loadu128(mask_c2);
+		__m128i c1 = _mm_shuffle_epi8(x0, loadu128(mask_c1));
+		__m128i c2 = _mm_blendv_epi8(_mm_shuffle_epi8(x0, mask),
+					     last16, mask);
+
+		x0 = fold128(c1, c2, k128);
+	}
+
+	/*
+	 * Compute the CRC as x0 * x^n mod G, where x0 is the 128-bit polynomial
+	 * and G is the generator polynomial of the CRC.  First multiply by x^n
+	 * and reduce to 64 + n bits, using the constant that is also used for
+	 * folding across 128 bits.  Then do a Barrett reduction in two steps:
+	 * multiply by floor(x^(63+n) / G) to get the multiple of G to subtract,
+	 * then subtract it.  The constants are pre-scaled by x^(64-n) so that
+	 * each result lands in a qword that the next pclmulqdq can select.
+	 */
+	x1 = _mm_clmulepi64_si128(x0, k128, 0x10);
+	x0 = _mm_xor_si128(_mm_srli_si128(x0, 8), x1);
+	k128 = consts[4];
+	x1 = _mm_clmulepi64_si128(x0, k128, 0x00);
+	x1 = _mm_clmulepi64_si128(x1, k128, 0x10);
+	x0 = _mm_xor_si128(x0, x1);
+	return _mm_extract_epi32(x0, 2);
+}
+
+#undef crc_t
+#undef CRC_TARGET
+#undef VL
+#undef CRC_TO_VEC
+#undef VEC
+#undef LOG2_VL
+#undef VLOAD
+#undef VXOR
+#undef VZEXT
+#undef VBCAST
+#undef VFOLD
+#undef LOAD128
+#undef LOAD256
+#undef FOLD_CONSTS
+#undef CRC_FUNC
diff --git a/lib/crc/x86/crc32-pclmul.S b/lib/crc/x86/crc32-pclmul.S
deleted file mode 100644
index f20f40fb0172..000000000000
--- a/lib/crc/x86/crc32-pclmul.S
+++ /dev/null
@@ -1,6 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-// Copyright 2025 Google LLC
-
-#include "crc-pclmul-template.S"
-
-DEFINE_CRC_PCLMUL_FUNCS(crc32_lsb, /* bits= */ 32, /* lsb= */ 1)
diff --git a/lib/crc/x86/crc32-pclmul.c b/lib/crc/x86/crc32-pclmul.c
new file mode 100644
index 000000000000..bb37b0a6d418
--- /dev/null
+++ b/lib/crc/x86/crc32-pclmul.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * CRC-32 using [V]PCLMULQDQ, via C intrinsics
+ *
+ * Copyright 2025 Google LLC
+ */
+
+#include <linux/types.h>
+
+#define CRC_BITS 32
+
+#define VL 16
+#define CRC_FUNC crc32_lsb_pclmul_sse
+#include "crc-pclmul-impl.h"
+
+#define VL 32
+#define CRC_FUNC crc32_lsb_vpclmul_avx2
+#include "crc-pclmul-impl.h"
+
+#define VL 64
+#define CRC_FUNC crc32_lsb_vpclmul_avx512
+#include "crc-pclmul-impl.h"
-- 
2.56.0

