Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C1E397699;
	Mon, 18 May 2026 05:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779081622; cv=none; b=Guu3I3n+QihleC1IUsD3cjpKVGScBzYLSpd45k0uNEG/1a2RyJ7x8IOJbmpdtaAjWxg8qGLRVBe7RhVTN6k7Ncd4sTBwLH/3axrsaKq/dq83ukd7Ym/H9K63JUX4ty0Y9OVFSQHozI+Fvc0HNttyD3Frz/igl2p53sGTTl6+pMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779081622; c=relaxed/simple;
	bh=O28UkCkwNrQNQWo76dlS72VvZZO/v+ghYv3zD9bcSW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yuwne9NQgzgMWtV94a8ygu+9SjaDLk6aaKTDHbvHlXcMCWyYAUAs+dRMzOPh3As59vQOp2Z5pMx0+7TjqKUIjRIS0ICUSxM4QGlh+Wzp5oULSWdbNuWpPtQRW61tVIw97Uynp2KbgEEE0Qk3ELxIgOp1+bxQOhDsYAJGf2ZjsVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vkpDig9b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vkpDig9b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Yn+cJfB1VoAPXsRK9mXmJmFEOX3pXz4e2Yj0+MpMLMQ=; b=vkpDig9bU/TkrIJDIEzLEssgn9
	6zIF0Y9qnXGjWIm5dGW3OzN5/j6l4/1fXS+/90ex2RzMDdQrS+r+g/+rVy9oTHp+dUl8A2O/M7mfQ
	Op1E5jZrS8AQCaKKbPDikbPmJtIg0skw1D6AElRpwb9pFXNsReS8XNDdiTZieqkTsWiYXAxY6ChAx
	9YSOiFaTy1rSjJXfif5NYP51t5OtBuLxwEYlOB+Vnjd7lIHBLOozAMlKB4k4YzDYoM5I8e8CgFOUS
	2elhExRMPzCUSdRjIlvFSy3uuvGLxewNacDoF5M5IxkyoxtNbIlIbymwHtlzX40owOaoWw0zFn879
	G4XGxAmw==;
Received: from [2001:4bb8:2d1:6fdb:d67d:128c:34ba:85b8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOqOF-0000000EGFw-2tpd;
	Mon, 18 May 2026 05:19:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dan Williams <dan.j.williams@intel.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 06/18] raid6: use named initializers for struct raid6_calls
Date: Mon, 18 May 2026 07:17:49 +0200
Message-ID: <20260518051804.462141-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260518051804.462141-1-hch@lst.de>
References: <20260518051804.462141-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Ard Biesheuvel <ardb@kernel.org> # kunit only on arm64
---
 lib/raid/raid6/arm/neon.c                 |  9 +++----
 lib/raid/raid6/int.uc                     |  8 +++---
 lib/raid/raid6/loongarch/loongarch_simd.c | 18 ++++++-------
 lib/raid/raid6/powerpc/altivec.uc         |  8 +++---
 lib/raid/raid6/powerpc/vpermxor.uc        |  8 +++---
 lib/raid/raid6/riscv/rvv.h                |  9 +++----
 lib/raid/raid6/s390/s390vx.uc             | 10 +++----
 lib/raid/raid6/x86/avx2.c                 | 33 ++++++++++++-----------
 lib/raid/raid6/x86/avx512.c               | 33 ++++++++++++-----------
 lib/raid/raid6/x86/mmx.c                  | 16 +++++------
 lib/raid/raid6/x86/sse1.c                 | 18 ++++++-------
 lib/raid/raid6/x86/sse2.c                 | 30 ++++++++++-----------
 12 files changed, 95 insertions(+), 105 deletions(-)

diff --git a/lib/raid/raid6/arm/neon.c b/lib/raid/raid6/arm/neon.c
index 47b8bb0afc65..c21da59ab48f 100644
--- a/lib/raid/raid6/arm/neon.c
+++ b/lib/raid/raid6/arm/neon.c
@@ -40,11 +40,10 @@
 				start, stop, (unsigned long)bytes, ptrs);\
 	}								\
 	struct raid6_calls const raid6_neonx ## _n = {			\
-		raid6_neon ## _n ## _gen_syndrome,			\
-		raid6_neon ## _n ## _xor_syndrome,			\
-		raid6_have_neon,					\
-		"neonx" #_n,						\
-		0							\
+		.gen_syndrome	= raid6_neon ## _n ## _gen_syndrome,	\
+		.xor_syndrome	= raid6_neon ## _n ## _xor_syndrome,	\
+		.valid		= raid6_have_neon,			\
+		.name		= "neonx" #_n,				\
 	}
 
 static int raid6_have_neon(void)
diff --git a/lib/raid/raid6/int.uc b/lib/raid/raid6/int.uc
index 1ba56c3fa482..4f5f2869e21e 100644
--- a/lib/raid/raid6/int.uc
+++ b/lib/raid/raid6/int.uc
@@ -139,9 +139,7 @@ static void raid6_int$#_xor_syndrome(int disks, int start, int stop,
 }
 
 const struct raid6_calls raid6_intx$# = {
-	raid6_int$#_gen_syndrome,
-	raid6_int$#_xor_syndrome,
-	NULL,			/* always valid */
-	"int" NSTRING "x$#",
-	0
+	.gen_syndrome	= raid6_int$#_gen_syndrome,
+	.xor_syndrome	= raid6_int$#_xor_syndrome,
+	.name		= "int" NSTRING "x$#",
 };
diff --git a/lib/raid/raid6/loongarch/loongarch_simd.c b/lib/raid/raid6/loongarch/loongarch_simd.c
index 72f4d92d4876..1b4cd1512d05 100644
--- a/lib/raid/raid6/loongarch/loongarch_simd.c
+++ b/lib/raid/raid6/loongarch/loongarch_simd.c
@@ -244,11 +244,10 @@ static void raid6_lsx_xor_syndrome(int disks, int start, int stop,
 }
 
 const struct raid6_calls raid6_lsx = {
-	raid6_lsx_gen_syndrome,
-	raid6_lsx_xor_syndrome,
-	raid6_has_lsx,
-	"lsx",
-	.priority = 0 /* see the comment near the top of the file for reason */
+	.gen_syndrome	= raid6_lsx_gen_syndrome,
+	.xor_syndrome	= raid6_lsx_xor_syndrome,
+	.valid		= raid6_has_lsx,
+	.name		= "lsx",
 };
 
 #undef NSIZE
@@ -413,11 +412,10 @@ static void raid6_lasx_xor_syndrome(int disks, int start, int stop,
 }
 
 const struct raid6_calls raid6_lasx = {
-	raid6_lasx_gen_syndrome,
-	raid6_lasx_xor_syndrome,
-	raid6_has_lasx,
-	"lasx",
-	.priority = 0 /* see the comment near the top of the file for reason */
+	.gen_syndrome	= raid6_lasx_gen_syndrome,
+	.xor_syndrome	= raid6_lasx_xor_syndrome,
+	.valid		= raid6_has_lasx,
+	.name		= "lasx",
 };
 #undef NSIZE
 #endif /* CONFIG_CPU_HAS_LASX */
diff --git a/lib/raid/raid6/powerpc/altivec.uc b/lib/raid/raid6/powerpc/altivec.uc
index 130d3d3dd42c..084ead768ddb 100644
--- a/lib/raid/raid6/powerpc/altivec.uc
+++ b/lib/raid/raid6/powerpc/altivec.uc
@@ -114,9 +114,7 @@ int raid6_have_altivec(void)
 #endif
 
 const struct raid6_calls raid6_altivec$# = {
-	raid6_altivec$#_gen_syndrome,
-	NULL,			/* XOR not yet implemented */
-	raid6_have_altivec,
-	"altivecx$#",
-	0
+	.gen_syndrome	= raid6_altivec$#_gen_syndrome,
+	.valid		= raid6_have_altivec,
+	.name		= "altivecx$#",
 };
diff --git a/lib/raid/raid6/powerpc/vpermxor.uc b/lib/raid/raid6/powerpc/vpermxor.uc
index 595f20aaf4cf..bb2c3a316ae8 100644
--- a/lib/raid/raid6/powerpc/vpermxor.uc
+++ b/lib/raid/raid6/powerpc/vpermxor.uc
@@ -87,9 +87,7 @@ int raid6_have_altivec_vpermxor(void)
 #endif
 
 const struct raid6_calls raid6_vpermxor$# = {
-	raid6_vpermxor$#_gen_syndrome,
-	NULL,
-	raid6_have_altivec_vpermxor,
-	"vpermxor$#",
-	0
+	.gen_syndrome	= raid6_vpermxor$#_gen_syndrome,
+	.valid		= raid6_have_altivec_vpermxor,
+	.name		= "vpermxor$#",
 };
diff --git a/lib/raid/raid6/riscv/rvv.h b/lib/raid/raid6/riscv/rvv.h
index b0a71b375962..0d430a4c5f08 100644
--- a/lib/raid/raid6/riscv/rvv.h
+++ b/lib/raid/raid6/riscv/rvv.h
@@ -39,9 +39,8 @@ static int rvv_has_vector(void)
 		kernel_vector_end();					\
 	}								\
 	struct raid6_calls const raid6_rvvx ## _n = {			\
-		raid6_rvv ## _n ## _gen_syndrome,			\
-		raid6_rvv ## _n ## _xor_syndrome,			\
-		rvv_has_vector,						\
-		"rvvx" #_n,						\
-		0							\
+		.gen_syndrome	= raid6_rvv ## _n ## _gen_syndrome,	\
+		.xor_syndrome	= raid6_rvv ## _n ## _xor_syndrome,	\
+		.valid		= rvv_has_vector,			\
+		.name		= "rvvx" #_n,				\
 	}
diff --git a/lib/raid/raid6/s390/s390vx.uc b/lib/raid/raid6/s390/s390vx.uc
index 8aa53eb2f395..97c5d5d9dcf9 100644
--- a/lib/raid/raid6/s390/s390vx.uc
+++ b/lib/raid/raid6/s390/s390vx.uc
@@ -127,9 +127,9 @@ static int raid6_s390vx$#_valid(void)
 }
 
 const struct raid6_calls raid6_s390vx$# = {
-	raid6_s390vx$#_gen_syndrome,
-	raid6_s390vx$#_xor_syndrome,
-	raid6_s390vx$#_valid,
-	"vx128x$#",
-	1
+	.gen_syndrome	= raid6_s390vx$#_gen_syndrome,
+	.xor_syndrome	= raid6_s390vx$#_xor_syndrome,
+	.valid		= raid6_s390vx$#_valid,
+	.name		= "vx128x$#",
+	.priority	= 1,
 };
diff --git a/lib/raid/raid6/x86/avx2.c b/lib/raid/raid6/x86/avx2.c
index a1a5213918af..aab8b624c635 100644
--- a/lib/raid/raid6/x86/avx2.c
+++ b/lib/raid/raid6/x86/avx2.c
@@ -128,11 +128,12 @@ static void raid6_avx21_xor_syndrome(int disks, int start, int stop,
 }
 
 const struct raid6_calls raid6_avx2x1 = {
-	raid6_avx21_gen_syndrome,
-	raid6_avx21_xor_syndrome,
-	raid6_have_avx2,
-	"avx2x1",
-	.priority = 2		/* Prefer AVX2 over priority 1 (SSE2 and others) */
+	.gen_syndrome	= raid6_avx21_gen_syndrome,
+	.xor_syndrome	= raid6_avx21_xor_syndrome,
+	.valid		= raid6_have_avx2,
+	.name		= "avx2x1",
+	/* Prefer AVX2 over priority 1 (SSE2 and others) */
+	.priority	= 2,
 };
 
 /*
@@ -258,11 +259,12 @@ static void raid6_avx22_xor_syndrome(int disks, int start, int stop,
 }
 
 const struct raid6_calls raid6_avx2x2 = {
-	raid6_avx22_gen_syndrome,
-	raid6_avx22_xor_syndrome,
-	raid6_have_avx2,
-	"avx2x2",
-	.priority = 2		/* Prefer AVX2 over priority 1 (SSE2 and others) */
+	.gen_syndrome	= raid6_avx22_gen_syndrome,
+	.xor_syndrome	= raid6_avx22_xor_syndrome,
+	.valid		= raid6_have_avx2,
+	.name		= "avx2x2",
+	/* Prefer AVX2 over priority 1 (SSE2 and others) */
+	.priority	= 2,
 };
 
 #ifdef CONFIG_X86_64
@@ -461,10 +463,11 @@ static void raid6_avx24_xor_syndrome(int disks, int start, int stop,
 }
 
 const struct raid6_calls raid6_avx2x4 = {
-	raid6_avx24_gen_syndrome,
-	raid6_avx24_xor_syndrome,
-	raid6_have_avx2,
-	"avx2x4",
-	.priority = 2		/* Prefer AVX2 over priority 1 (SSE2 and others) */
+	.gen_syndrome	= raid6_avx24_gen_syndrome,
+	.xor_syndrome	= raid6_avx24_xor_syndrome,
+	.valid		= raid6_have_avx2,
+	.name		= "avx2x4",
+	/* Prefer AVX2 over priority 1 (SSE2 and others) */
+	.priority	= 2,
 };
 #endif /* CONFIG_X86_64 */
diff --git a/lib/raid/raid6/x86/avx512.c b/lib/raid/raid6/x86/avx512.c
index 874998bcd7d7..47636b16632f 100644
--- a/lib/raid/raid6/x86/avx512.c
+++ b/lib/raid/raid6/x86/avx512.c
@@ -156,11 +156,12 @@ static void raid6_avx5121_xor_syndrome(int disks, int start, int stop,
 }
 
 const struct raid6_calls raid6_avx512x1 = {
-	raid6_avx5121_gen_syndrome,
-	raid6_avx5121_xor_syndrome,
-	raid6_have_avx512,
-	"avx512x1",
-	.priority = 2		/* Prefer AVX512 over priority 1 (SSE2 and others) */
+	.gen_syndrome	= raid6_avx5121_gen_syndrome,
+	.xor_syndrome	= raid6_avx5121_xor_syndrome,
+	.valid		= raid6_have_avx512,
+	.name		= "avx512x1",
+	/* Prefer AVX512 over priority 1 (SSE2 and others) */
+	.priority	= 2,
 };
 
 /*
@@ -313,11 +314,12 @@ static void raid6_avx5122_xor_syndrome(int disks, int start, int stop,
 }
 
 const struct raid6_calls raid6_avx512x2 = {
-	raid6_avx5122_gen_syndrome,
-	raid6_avx5122_xor_syndrome,
-	raid6_have_avx512,
-	"avx512x2",
-	.priority = 2		/* Prefer AVX512 over priority 1 (SSE2 and others) */
+	.gen_syndrome	= raid6_avx5122_gen_syndrome,
+	.xor_syndrome	= raid6_avx5122_xor_syndrome,
+	.valid		= raid6_have_avx512,
+	.name		= "avx512x2",
+	/* Prefer AVX512 over priority 1 (SSE2 and others) */
+	.priority	= 2,
 };
 
 #ifdef CONFIG_X86_64
@@ -551,10 +553,11 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 	kernel_fpu_end();
 }
 const struct raid6_calls raid6_avx512x4 = {
-	raid6_avx5124_gen_syndrome,
-	raid6_avx5124_xor_syndrome,
-	raid6_have_avx512,
-	"avx512x4",
-	.priority = 2		/* Prefer AVX512 over priority 1 (SSE2 and others) */
+	.gen_syndrome	= raid6_avx5124_gen_syndrome,
+	.xor_syndrome	= raid6_avx5124_xor_syndrome,
+	.valid		= raid6_have_avx512,
+	.name		= "avx512x4",
+	/* Prefer AVX512 over priority 1 (SSE2 and others) */
+	.priority	= 2,
 };
 #endif
diff --git a/lib/raid/raid6/x86/mmx.c b/lib/raid/raid6/x86/mmx.c
index 7e9810669347..22b9fdaa705f 100644
--- a/lib/raid/raid6/x86/mmx.c
+++ b/lib/raid/raid6/x86/mmx.c
@@ -68,11 +68,9 @@ static void raid6_mmx1_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_mmxx1 = {
-	raid6_mmx1_gen_syndrome,
-	NULL,			/* XOR not yet implemented */
-	raid6_have_mmx,
-	"mmxx1",
-	0
+	.gen_syndrome	= raid6_mmx1_gen_syndrome,
+	.valid		= raid6_have_mmx,
+	.name		= "mmxx1",
 };
 
 /*
@@ -127,9 +125,7 @@ static void raid6_mmx2_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_mmxx2 = {
-	raid6_mmx2_gen_syndrome,
-	NULL,			/* XOR not yet implemented */
-	raid6_have_mmx,
-	"mmxx2",
-	0
+	.gen_syndrome	= raid6_mmx2_gen_syndrome,
+	.valid		= raid6_have_mmx,
+	.name		= "mmxx2",
 };
diff --git a/lib/raid/raid6/x86/sse1.c b/lib/raid/raid6/x86/sse1.c
index deecdd72ceec..fad214a430d8 100644
--- a/lib/raid/raid6/x86/sse1.c
+++ b/lib/raid/raid6/x86/sse1.c
@@ -84,11 +84,10 @@ static void raid6_sse11_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_sse1x1 = {
-	raid6_sse11_gen_syndrome,
-	NULL,			/* XOR not yet implemented */
-	raid6_have_sse1_or_mmxext,
-	"sse1x1",
-	1			/* Has cache hints */
+	.gen_syndrome	= raid6_sse11_gen_syndrome,
+	.valid		= raid6_have_sse1_or_mmxext,
+	.name		= "sse1x1",
+	.priority	= 1,	/* Has cache hints */
 };
 
 /*
@@ -147,9 +146,8 @@ static void raid6_sse12_gen_syndrome(int disks, size_t bytes, void **ptrs)
 }
 
 const struct raid6_calls raid6_sse1x2 = {
-	raid6_sse12_gen_syndrome,
-	NULL,			/* XOR not yet implemented */
-	raid6_have_sse1_or_mmxext,
-	"sse1x2",
-	1			/* Has cache hints */
+	.gen_syndrome	= raid6_sse12_gen_syndrome,
+	.valid		= raid6_have_sse1_or_mmxext,
+	.name		= "sse1x2",
+	.priority	= 1,	/* Has cache hints */
 };
diff --git a/lib/raid/raid6/x86/sse2.c b/lib/raid/raid6/x86/sse2.c
index f9edf8a8d1c4..1b28e858a1d4 100644
--- a/lib/raid/raid6/x86/sse2.c
+++ b/lib/raid/raid6/x86/sse2.c
@@ -133,11 +133,11 @@ static void raid6_sse21_xor_syndrome(int disks, int start, int stop,
 }
 
 const struct raid6_calls raid6_sse2x1 = {
-	raid6_sse21_gen_syndrome,
-	raid6_sse21_xor_syndrome,
-	raid6_have_sse2,
-	"sse2x1",
-	1			/* Has cache hints */
+	.gen_syndrome	= raid6_sse21_gen_syndrome,
+	.xor_syndrome	= raid6_sse21_xor_syndrome,
+	.valid		= raid6_have_sse2,
+	.name		= "sse2x1",
+	.priority	= 1,	/* Has cache hints */
 };
 
 /*
@@ -263,11 +263,11 @@ static void raid6_sse22_xor_syndrome(int disks, int start, int stop,
 }
 
 const struct raid6_calls raid6_sse2x2 = {
-	raid6_sse22_gen_syndrome,
-	raid6_sse22_xor_syndrome,
-	raid6_have_sse2,
-	"sse2x2",
-	1			/* Has cache hints */
+	.gen_syndrome	= raid6_sse22_gen_syndrome,
+	.xor_syndrome	= raid6_sse22_xor_syndrome,
+	.valid		= raid6_have_sse2,
+	.name		= "sse2x2",
+	.priority	= 1,	/* Has cache hints */
 };
 
 #ifdef CONFIG_X86_64
@@ -470,11 +470,11 @@ static void raid6_sse24_xor_syndrome(int disks, int start, int stop,
 
 
 const struct raid6_calls raid6_sse2x4 = {
-	raid6_sse24_gen_syndrome,
-	raid6_sse24_xor_syndrome,
-	raid6_have_sse2,
-	"sse2x4",
-	1			/* Has cache hints */
+	.gen_syndrome	= raid6_sse24_gen_syndrome,
+	.xor_syndrome	= raid6_sse24_xor_syndrome,
+	.valid		= raid6_have_sse2,
+	.name		= "sse2x4",
+	.priority	= 1,	/* Has cache hints */
 };
 
 #endif /* CONFIG_X86_64 */
-- 
2.53.0

