Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795137583;
	b=YCnSxM3eJ48R9eA95EQh2/xzDBvlzP71hFHMHtx4bsMVQDbcFa/pAgddb5qNgv5JHdz0
	 2JR5AQpQN55jhWmXGEEV90vfJnfF6TkhHg7LmA10Ns4QpgZ077drlnokZWEzGTtSzzZda
	 HjBpsbeOb3wa0w9lln/8yI1EvOXEBg6SzTsjNSkIlHTwmQ4aLT0xXFI6LB9AcVu2fq1hN
	 /V37sEKOXM02nlTToUPfE2J76Tfe00YLCwLTy9kSl5s4rE1DTnUyYH8wnauCQOZU+UAB8
	 tn4qn9ShPlxkw/rwoxnAQlKOT0qJlDS5gZxBk+KDGB6P77yVNcT50ZfW8UFEMWs70Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795137583;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=nZWmOTgV2Zw25OtwETlzPIVsxeisuCAhy0ACe4BFLuk=;
	b=cjcbt9vPIL27/d6X9tWH/wTf9hrf7Cl8lG2Q32EKN7aCkbfS4KukRzMT5PBdxReGWRGx
	 OX/0MFNdn0gyJ92VVFzrkOroLE+tXUMNUu+lVSnVNfDBYIRiA1c0+VAqmse+eDqICn0+C
	 2xJoB8EZ0vMbwmmUF44s1chTKsJLISDHgF2khXA8/i3gMjUc69Udg+DjlqcYQ79IhxGaB
	 k2O/QBQzMgjzRCBcesxz3ggPZPgbCw4l191ONlONUmk/jF8uayMnZQo296mOUlrvwEIW0
	 lpRJRrshAR55/wCN5km7a7xj3kgmBy6SlnJDYHs0lA8M3yD92ExMrOGdKhJ6Fx/7NQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=PcLsCLmN;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=PcLsCLmN;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7466606A325;
	Fri, 20 Nov 2026 01:19:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7466606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=PcLsCLmN;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=PcLsCLmN
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 182AA2253F;
	Fri, 20 Nov 2026 01:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795137581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nZWmOTgV2Zw25OtwETlzPIVsxeisuCAhy0ACe4BFLuk=;
	b=PcLsCLmNGKlKwsPyI1+6y+1B0MXVaSPTEwwohyCXXg1lOXXPVpSStxmQKbwBFG7t0rfbcy
	ujmbg1AqbRjG/cZIUsgKNZ74EUZZx+sgJe2vPtYNAxxvRiNsRhoNOuPeBMDXn+UVmCucQ1
	2lYHiv9Pv5Y8upT8uFpONHDX+a6M1L4=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795137581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nZWmOTgV2Zw25OtwETlzPIVsxeisuCAhy0ACe4BFLuk=;
	b=PcLsCLmNGKlKwsPyI1+6y+1B0MXVaSPTEwwohyCXXg1lOXXPVpSStxmQKbwBFG7t0rfbcy
	ujmbg1AqbRjG/cZIUsgKNZ74EUZZx+sgJe2vPtYNAxxvRiNsRhoNOuPeBMDXn+UVmCucQ1
	2lYHiv9Pv5Y8upT8uFpONHDX+a6M1L4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D82C51342D;
	Fri, 20 Nov 2026 01:19:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f6GRNh6g/2r1FAAAD6G6ig:T5
	(envelope-from <wqu@suse.com>); Fri, 20 Nov 2026 01:19:38 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org,
	ardb@kernel.org
Subject: [PATCH RFC v2 4/6] lib/crc: x86: Convert crc64_msb_*() from assembly to C
Date: Fri, 20 Nov 2026 11:49:02 +1030
Message-ID: <aed2a4d0f3ae3a5e53d0e5fd542343ef086d9fbd.1795137348.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	TO_DN_NONE(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

Rewrite the three crc64_msb functions in C using the template, which now
supports MSB-first CRCs, 64 bits wide.

MSB-first CRCs load the data byte-reflected, with the new load_bswap*()
helpers, put the initial CRC at the other end of the vector, and index the
shuffle table from the other end.

crc64-pclmul.S now only has the crc64_lsb functions.

Build changes:
- Add crc64-msb-pclmul.o, built with x86-intrin-cflags.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 lib/crc/Makefile                 |  3 +-
 lib/crc/x86/crc-pclmul-helpers.h | 18 +++++++++++
 lib/crc/x86/crc-pclmul-impl.h    | 52 ++++++++++++++++++++++++--------
 lib/crc/x86/crc32-pclmul.c       |  1 +
 lib/crc/x86/crc64-msb-pclmul.c   | 23 ++++++++++++++
 lib/crc/x86/crc64-pclmul.S       |  1 -
 6 files changed, 83 insertions(+), 15 deletions(-)
 create mode 100644 lib/crc/x86/crc64-msb-pclmul.c

diff --git a/lib/crc/Makefile b/lib/crc/Makefile
index baca818f76f7..302183401543 100644
--- a/lib/crc/Makefile
+++ b/lib/crc/Makefile
@@ -53,7 +53,8 @@ crc64-$(CONFIG_ARM) += crc64-neon.o
 crc64-$(CONFIG_ARM64) += crc64-neon.o
 
 crc64-$(CONFIG_RISCV) += riscv/crc64_lsb.o riscv/crc64_msb.o
-crc64-$(CONFIG_X86) += x86/crc64-pclmul.o
+crc64-$(CONFIG_X86) += x86/crc64-pclmul.o x86/crc64-msb-pclmul.o
+CFLAGS_x86/crc64-msb-pclmul.o += $(x86-intrin-cflags)
 endif # CONFIG_CRC64_ARCH
 
 obj-y += tests/
diff --git a/lib/crc/x86/crc-pclmul-helpers.h b/lib/crc/x86/crc-pclmul-helpers.h
index c4bac60220f3..f85deb847cd3 100644
--- a/lib/crc/x86/crc-pclmul-helpers.h
+++ b/lib/crc/x86/crc-pclmul-helpers.h
@@ -30,6 +30,12 @@ static __always_inline __crc128 __m128i loadu128(const u8 *p)
 	return _mm_loadu_si128((const __m128i *)p);
 }
 
+/* Load 16 bytes, and reflect the bytes within each 128-bit lane. */
+static __always_inline __crc128 __m128i load_bswap128(const u8 *p, __m128i bswap)
+{
+	return _mm_shuffle_epi8(loadu128(p), bswap);
+}
+
 /*
  * Fold acc into data, across the distance that k was generated for: the qwords
  * of k and acc with the same index are multiplied.  The compilers turn the
@@ -48,6 +54,12 @@ static __always_inline __crc256 __m256i loadu256(const u8 *p)
 	return _mm256_loadu_si256((const __m256i *)p);
 }
 
+/* Load 32 bytes, and reflect the bytes within each 128-bit lane. */
+static __always_inline __crc256 __m256i load_bswap256(const u8 *p, __m256i bswap)
+{
+	return _mm256_shuffle_epi8(loadu256(p), bswap);
+}
+
 static __always_inline __crc256 __m256i fold256(__m256i acc, __m256i data, __m256i k)
 {
 	__m256i lo = _mm256_clmulepi64_epi128(acc, k, 0x00);
@@ -61,6 +73,12 @@ static __always_inline __crc512 __m512i loadu512(const u8 *p)
 	return _mm512_loadu_si512(p);
 }
 
+/* Load 64 bytes, and reflect the bytes within each 128-bit lane. */
+static __always_inline __crc512 __m512i load_bswap512(const u8 *p, __m512i bswap)
+{
+	return _mm512_shuffle_epi8(loadu512(p), bswap);
+}
+
 static __always_inline __crc512 __m512i fold512(__m512i acc, __m512i data, __m512i k)
 {
 	__m512i lo = _mm512_clmulepi64_epi128(acc, k, 0x00);
diff --git a/lib/crc/x86/crc-pclmul-impl.h b/lib/crc/x86/crc-pclmul-impl.h
index 50fdbadd4b9a..db3d4dcef8ee 100644
--- a/lib/crc/x86/crc-pclmul-impl.h
+++ b/lib/crc/x86/crc-pclmul-impl.h
@@ -11,6 +11,10 @@
  *		(VPCLMULQDQ with AVX2) or 64 (VPCLMULQDQ with AVX512BW/VL).  The
  *		function gets the matching target attribute.
  * CRC_BITS	The number of bits in the CRC.  Currently only 32 is supported.
+ * CRC_MSB	1 if the CRC processes the most significant bit of each byte
+ *		first, i.e. maps bit0 to x^0, ..., bit7 to x^7.  0 if it
+ *		processes the least significant bit first, i.e. maps bit0 to x^7,
+ *		..., bit7 to x^0.
  * CRC_FUNC	The name of the function to generate.  Its prototype is
  *
  *	crc_t CRC_FUNC(crc_t crc, const u8 *p, size_t len, const void *consts);
@@ -19,11 +23,9 @@
  * least 16, and |consts| points to the fold_across_128_bits_consts field of the
  * constants generated by scripts/gen-crc-consts.py for the chosen CRC.
  *
- * Only least-significant-bit-first CRCs are supported so far.
- *
  * VL and CRC_FUNC are undefined at the end of the template, so they have to be
- * defined again before each inclusion.  CRC_BITS is kept, so it can be defined
- * once for all the inclusions in a file.
+ * defined again before each inclusion.  CRC_BITS and CRC_MSB are kept, so they
+ * can be defined once for all the inclusions in a file.
  *
  * Copyright 2025 Google LLC
  *
@@ -32,14 +34,19 @@
 
 #include "crc-pclmul-helpers.h"
 
+#if CRC_BITS == 64
+#define crc_t		u64
+#define CRC_TO_VEC(crc)	_mm_cvtsi64_si128(crc)
+#else
 #define crc_t		u32
 #define CRC_TO_VEC(crc)	_mm_cvtsi32_si128(crc)
+#endif /* CRC_BITS == 64 */
 
 #if VL == 16
 #define CRC_TARGET	CRC_TARGET_128
 #define VEC		__m128i
 #define LOG2_VL		4
-#define VLOAD(p)	loadu128(p)
+#define VLOAD(p)	(CRC_MSB ? load_bswap128(p, bswap128) : loadu128(p))
 #define VXOR(a, b)	_mm_xor_si128(a, b)
 #define VZEXT(x)	(x)
 #define VBCAST(x)	(x)
@@ -48,7 +55,7 @@
 #define CRC_TARGET	CRC_TARGET_256
 #define VEC		__m256i
 #define LOG2_VL		5
-#define VLOAD(p)	loadu256(p)
+#define VLOAD(p)	(CRC_MSB ? load_bswap256(p, bswap256) : loadu256(p))
 #define VXOR(a, b)	_mm256_xor_si256(a, b)
 #define VZEXT(x)	_mm256_inserti128_si256(_mm256_setzero_si256(), x, 0)
 #define VBCAST(x)	_mm256_broadcastsi128_si256(x)
@@ -57,15 +64,15 @@
 #define CRC_TARGET	CRC_TARGET_512
 #define VEC		__m512i
 #define LOG2_VL		6
-#define VLOAD(p)	loadu512(p)
+#define VLOAD(p)	(CRC_MSB ? load_bswap512(p, bswap512) : loadu512(p))
 #define VXOR(a, b)	_mm512_xor_si512(a, b)
 #define VZEXT(x)	_mm512_inserti32x4(_mm512_setzero_si512(), x, 0)
 #define VBCAST(x)	_mm512_broadcast_i32x4(x)
 #define VFOLD(a, d, k)	fold512(a, d, k)
 #endif /* VL == 16 */
 
-#define LOAD128(p)	loadu128(p)
-#define LOAD256(p)	loadu256(p)
+#define LOAD128(p)	(CRC_MSB ? load_bswap128(p, bswap128) : loadu128(p))
+#define LOAD256(p)	(CRC_MSB ? load_bswap256(p, bswap256) : loadu256(p))
 /* The constants for folding across 2^i vectors of length VL */
 #define FOLD_CONSTS(i)	VBCAST(consts[4 - LOG2_VL - (i)])
 
@@ -74,8 +81,9 @@ crc_t CRC_FUNC(crc_t crc, const u8 *p, size_t len, const void *consts_ptr);
 
 /*
  * |consts_ptr| points to fold_across_128_bits_consts.  The fold constants for
- * 256, 512, 1024 and 2048 bits are right before it.  The shuffle table and the
- * Barrett reduction constants follow it.
+ * 256, 512, 1024 and 2048 bits are right before it, preceded by the byte
+ * reflection mask (MSB-first CRCs only).  The shuffle table and the Barrett
+ * reduction constants follow it.
  *
  * The first vector of data, with the initial CRC XORed into it, is folded into
  * the next ones, 4 vectors at a time, then 2 and 1 at a time for the data that
@@ -90,18 +98,23 @@ crc_t CRC_FUNC(crc_t crc, const u8 *p, size_t len, const void *consts_ptr)
 {
 	const __m128i *consts = consts_ptr;
 	const u8 *shuf_table = (const u8 *)consts + 16;
+	const __m128i bswap128 = CRC_MSB ? consts[-5] : _mm_setzero_si128();
 	__m128i x0, x1, k128 = consts[0];
 	VEC v0, v1, v2, v3, k;
 #if VL >= 32
+	const __m256i bswap256 = _mm256_broadcastsi128_si256(bswap128);
 	__m256i y0;
 #endif /* VL >= 32 */
 #if VL == 64
+	const __m512i bswap512 = _mm512_broadcast_i32x4(bswap128);
 	__m256i k256;
 #endif /* VL == 64 */
 	size_t rem;
 
 	/* The initial CRC goes in the end holding the high-order coefficients. */
 	x0 = CRC_TO_VEC(crc);
+	if (CRC_MSB)
+		x0 = _mm_slli_si128(x0, (128 - CRC_BITS) / 8);
 
 	/* len >= 16 is guaranteed, but not len >= VL. */
 #if VL >= 32
@@ -212,8 +225,8 @@ crc_t CRC_FUNC(crc_t crc, const u8 *p, size_t len, const void *consts_ptr)
 		 * C2, and by 16 - rem the other way for C1.  The last 16 bytes
 		 * of the data are B, with A*x^(8*rem) blended in.
 		 */
-		const u8 *mask_c2 = shuf_table + 16 + rem;
-		const u8 *mask_c1 = shuf_table + rem;
+		const u8 *mask_c2 = shuf_table + (CRC_MSB ? 16 - rem : 16 + rem);
+		const u8 *mask_c1 = shuf_table + (CRC_MSB ? 32 - rem : rem);
 		__m128i last16 = LOAD128(p + rem - 16);
 		__m128i mask = loadu128(mask_c2);
 		__m128i c1 = _mm_shuffle_epi8(x0, loadu128(mask_c1));
@@ -232,6 +245,18 @@ crc_t CRC_FUNC(crc_t crc, const u8 *p, size_t len, const void *consts_ptr)
 	 * then subtract it.  The constants are pre-scaled by x^(64-n) so that
 	 * each result lands in a qword that the next pclmulqdq can select.
 	 */
+#if CRC_MSB
+	x1 = _mm_clmulepi64_si128(x0, k128, 0x01);
+	x0 = _mm_xor_si128(_mm_slli_si128(x0, 8), x1);
+	k128 = consts[4];
+	x1 = _mm_clmulepi64_si128(x0, k128, 0x11);
+	x1 = _mm_xor_si128(x1, x0);
+	x1 = _mm_clmulepi64_si128(x1, k128, 0x01);
+	x0 = _mm_xor_si128(x0, x1);
+#if CRC_BITS == 64
+	return _mm_cvtsi128_si64(x0);
+#endif /* CRC_BITS == 64 */
+#elif CRC_BITS == 32
 	x1 = _mm_clmulepi64_si128(x0, k128, 0x10);
 	x0 = _mm_xor_si128(_mm_srli_si128(x0, 8), x1);
 	k128 = consts[4];
@@ -239,6 +264,7 @@ crc_t CRC_FUNC(crc_t crc, const u8 *p, size_t len, const void *consts_ptr)
 	x1 = _mm_clmulepi64_si128(x1, k128, 0x10);
 	x0 = _mm_xor_si128(x0, x1);
 	return _mm_extract_epi32(x0, 2);
+#endif /* CRC_MSB */
 }
 
 #undef crc_t
diff --git a/lib/crc/x86/crc32-pclmul.c b/lib/crc/x86/crc32-pclmul.c
index bb37b0a6d418..3c21db7b0fe1 100644
--- a/lib/crc/x86/crc32-pclmul.c
+++ b/lib/crc/x86/crc32-pclmul.c
@@ -8,6 +8,7 @@
 #include <linux/types.h>
 
 #define CRC_BITS 32
+#define CRC_MSB 0
 
 #define VL 16
 #define CRC_FUNC crc32_lsb_pclmul_sse
diff --git a/lib/crc/x86/crc64-msb-pclmul.c b/lib/crc/x86/crc64-msb-pclmul.c
new file mode 100644
index 000000000000..2ce4a852b241
--- /dev/null
+++ b/lib/crc/x86/crc64-msb-pclmul.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * CRC-64 (MSB-first) using [V]PCLMULQDQ, via C intrinsics
+ *
+ * Copyright 2025 Google LLC
+ */
+
+#include <linux/types.h>
+
+#define CRC_BITS 64
+#define CRC_MSB 1
+
+#define VL 16
+#define CRC_FUNC crc64_msb_pclmul_sse
+#include "crc-pclmul-impl.h"
+
+#define VL 32
+#define CRC_FUNC crc64_msb_vpclmul_avx2
+#include "crc-pclmul-impl.h"
+
+#define VL 64
+#define CRC_FUNC crc64_msb_vpclmul_avx512
+#include "crc-pclmul-impl.h"
diff --git a/lib/crc/x86/crc64-pclmul.S b/lib/crc/x86/crc64-pclmul.S
index 4173051b5197..9e1230ce5c8f 100644
--- a/lib/crc/x86/crc64-pclmul.S
+++ b/lib/crc/x86/crc64-pclmul.S
@@ -3,5 +3,4 @@
 
 #include "crc-pclmul-template.S"
 
-DEFINE_CRC_PCLMUL_FUNCS(crc64_msb, /* bits= */ 64, /* lsb= */ 0)
 DEFINE_CRC_PCLMUL_FUNCS(crc64_lsb, /* bits= */ 64, /* lsb= */ 1)
-- 
2.56.0

