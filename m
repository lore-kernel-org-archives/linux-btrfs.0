Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC87D3DA5CB;
	Tue, 24 Mar 2026 06:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774334551; cv=none; b=QMUomHLpnAcbX5qm+ggXpDBnM1fZ1zzF8sP1Lez6gMyeS8cS1q5jb1a5QVIAZkANLRRepeApQg+yFtSlTV89Cd/xaNx1dPsAK1PM9baFZ/x/9GPRLd44xZa+TpXSKCHYWY4Cfj0v+CGQi/l4T3UemxAoBpEEb/H9QlHVfewlbA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774334551; c=relaxed/simple;
	bh=34f68w/wvTEuCyMShkH9cvbWkcA8DSyQT/oB32N55Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBjudg/enx9vgk3jhSxeQAhT/Re8Evhrmk6IN5hDsaARhR3UHOUVeVL74EhaeK9dN179XIzGpVKxdOVVg/GucYbig/TlpJHW56S59YyEtAGq9Zwf9gfDtm/voOHyQ014txPLkppFxmUyX40IOhjBSDAk36kgKB8T++5W2NVV3WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UJCx6L//; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UJCx6L//"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uEtZIVvss++sAB6t2odABm7bz1zj8pzH6//gKgQFGz8=; b=UJCx6L//c1n8OeP6dMdXrWfzRn
	0XYP7mbK3DKM21IK+KU+o4rvGPgZRR5HPnWGEo86v3m3TmZDKKdFj9BdrLQ1CDB9sOkqT+OAtbA/u
	kbHYojZf1y6fgNcA3R08zUP/jPSLQD3z8R9lgmNj/HckGYyaPq3Kvxf2yjpgHIYy2rm3a2p4zBvkK
	MoQ445jZwxE8YwDDv9t4OmZrADbMzfaeoumcIwwg7bIubZNt8ptoUlQ6q3iYHo00g7+7YffLSWJcb
	1VI2WToeMzd7LHXqlsj+BirPLL3LHg0oCTCouWLTZ+DH9kJvO3b3TGKiO4CFpDZR69msp+91jGr9p
	CACgHr4A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4vSp-00000000mCf-2Lsy;
	Tue, 24 Mar 2026 06:42:07 +0000
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
Subject: [PATCH 03/17] raid6: move to lib/raid/
Date: Tue, 24 Mar 2026 07:40:38 +0100
Message-ID: <20260324064115.3217136-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324064115.3217136-1-hch@lst.de>
References: <20260324064115.3217136-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the raid6 code to live in lib/raid/ with the XOR code, and change
the internal organization so that each architecture has a subdirectory
similar to the CRC, crypto and XOR libraries, and fix up the Makefile to
only build files actually needed.

Also move the kunit test case from the history test/ subdirectory to
tests/ and use the normal naming scheme for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/Kconfig                                   |  22 ----
 lib/Makefile                                  |   1 -
 lib/raid/Kconfig                              |  22 ++++
 lib/raid/Makefile                             |   2 +-
 lib/{ => raid}/raid6/.gitignore               |   0
 lib/raid/raid6/Makefile                       | 118 ++++++++++++++++++
 lib/{ => raid}/raid6/algos.c                  |   0
 lib/{raid6 => raid/raid6/arm}/neon.c          |   0
 lib/{raid6 => raid/raid6/arm}/neon.h          |   0
 lib/{raid6 => raid/raid6/arm}/neon.uc         |   0
 lib/{raid6 => raid/raid6/arm}/recov_neon.c    |   0
 .../raid6/arm}/recov_neon_inner.c             |   0
 lib/{ => raid}/raid6/int.uc                   |   0
 .../raid6/loongarch}/loongarch_simd.c         |   0
 .../raid6/loongarch}/recov_loongarch_simd.c   |   0
 lib/{ => raid}/raid6/mktables.c               |   0
 lib/{raid6 => raid/raid6/powerpc}/altivec.uc  |   4 -
 lib/{raid6 => raid/raid6/powerpc}/vpermxor.uc |   3 -
 lib/{ => raid}/raid6/recov.c                  |   0
 lib/{raid6 => raid/raid6/riscv}/recov_rvv.c   |   0
 lib/{raid6 => raid/raid6/riscv}/rvv.c         |   0
 lib/{raid6 => raid/raid6/riscv}/rvv.h         |   0
 lib/{raid6 => raid/raid6/s390}/recov_s390xc.c |   0
 lib/{raid6 => raid/raid6/s390}/s390vx.uc      |   0
 lib/raid/raid6/tests/Makefile                 |   3 +
 .../test.c => raid/raid6/tests/raid6_kunit.c} |   0
 lib/{ => raid}/raid6/unroll.awk               |   0
 lib/{raid6 => raid/raid6/x86}/avx2.c          |   0
 lib/{raid6 => raid/raid6/x86}/avx512.c        |   0
 lib/{raid6 => raid/raid6/x86}/mmx.c           |   4 -
 lib/{raid6 => raid/raid6/x86}/recov_avx2.c    |   0
 lib/{raid6 => raid/raid6/x86}/recov_avx512.c  |   0
 lib/{raid6 => raid/raid6/x86}/recov_ssse3.c   |   0
 lib/{raid6 => raid/raid6/x86}/sse1.c          |   4 -
 lib/{raid6 => raid/raid6/x86}/sse2.c          |   0
 lib/raid6/Makefile                            |  83 ------------
 lib/raid6/test/.gitignore                     |   3 -
 lib/raid6/test/Makefile                       |   3 -
 38 files changed, 144 insertions(+), 128 deletions(-)
 rename lib/{ => raid}/raid6/.gitignore (100%)
 create mode 100644 lib/raid/raid6/Makefile
 rename lib/{ => raid}/raid6/algos.c (100%)
 rename lib/{raid6 => raid/raid6/arm}/neon.c (100%)
 rename lib/{raid6 => raid/raid6/arm}/neon.h (100%)
 rename lib/{raid6 => raid/raid6/arm}/neon.uc (100%)
 rename lib/{raid6 => raid/raid6/arm}/recov_neon.c (100%)
 rename lib/{raid6 => raid/raid6/arm}/recov_neon_inner.c (100%)
 rename lib/{ => raid}/raid6/int.uc (100%)
 rename lib/{raid6 => raid/raid6/loongarch}/loongarch_simd.c (100%)
 rename lib/{raid6 => raid/raid6/loongarch}/recov_loongarch_simd.c (100%)
 rename lib/{ => raid}/raid6/mktables.c (100%)
 rename lib/{raid6 => raid/raid6/powerpc}/altivec.uc (98%)
 rename lib/{raid6 => raid/raid6/powerpc}/vpermxor.uc (98%)
 rename lib/{ => raid}/raid6/recov.c (100%)
 rename lib/{raid6 => raid/raid6/riscv}/recov_rvv.c (100%)
 rename lib/{raid6 => raid/raid6/riscv}/rvv.c (100%)
 rename lib/{raid6 => raid/raid6/riscv}/rvv.h (100%)
 rename lib/{raid6 => raid/raid6/s390}/recov_s390xc.c (100%)
 rename lib/{raid6 => raid/raid6/s390}/s390vx.uc (100%)
 create mode 100644 lib/raid/raid6/tests/Makefile
 rename lib/{raid6/test/test.c => raid/raid6/tests/raid6_kunit.c} (100%)
 rename lib/{ => raid}/raid6/unroll.awk (100%)
 rename lib/{raid6 => raid/raid6/x86}/avx2.c (100%)
 rename lib/{raid6 => raid/raid6/x86}/avx512.c (100%)
 rename lib/{raid6 => raid/raid6/x86}/mmx.c (99%)
 rename lib/{raid6 => raid/raid6/x86}/recov_avx2.c (100%)
 rename lib/{raid6 => raid/raid6/x86}/recov_avx512.c (100%)
 rename lib/{raid6 => raid/raid6/x86}/recov_ssse3.c (100%)
 rename lib/{raid6 => raid/raid6/x86}/sse1.c (99%)
 rename lib/{raid6 => raid/raid6/x86}/sse2.c (100%)
 delete mode 100644 lib/raid6/Makefile
 delete mode 100644 lib/raid6/test/.gitignore
 delete mode 100644 lib/raid6/test/Makefile

diff --git a/lib/Kconfig b/lib/Kconfig
index 716247fedaf0..67cc485484aa 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -8,28 +8,6 @@ config BINARY_PRINTF
 
 menu "Library routines"
 
-config RAID6_PQ
-	tristate
-
-config RAID6_PQ_KUNIT_TEST
-	tristate "KUnit tests for raid6 PQ functions" if !KUNIT_ALL_TESTS
-	depends on KUNIT
-	depends on RAID6_PQ
-	default KUNIT_ALL_TESTS
-	help
-	  Unit tests for the RAID6 PQ library functions.
-
-	  This is intended to help people writing architecture-specific
-	  optimized versions.  If unsure, say N.
-
-config RAID6_PQ_BENCHMARK
-	bool "Automatically choose fastest RAID6 PQ functions"
-	depends on RAID6_PQ
-	default y
-	help
-	  Benchmark all available RAID6 PQ functions on init and choose the
-	  fastest one.
-
 config LINEAR_RANGES
 	tristate
 
diff --git a/lib/Makefile b/lib/Makefile
index 84da412a044f..b5275d922662 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -166,7 +166,6 @@ obj-$(CONFIG_LZ4_DECOMPRESS) += lz4/
 obj-$(CONFIG_ZSTD_COMPRESS) += zstd/
 obj-$(CONFIG_ZSTD_DECOMPRESS) += zstd/
 obj-$(CONFIG_XZ_DEC) += xz/
-obj-$(CONFIG_RAID6_PQ) += raid6/
 
 lib-$(CONFIG_DECOMPRESS_GZIP) += decompress_inflate.o
 lib-$(CONFIG_DECOMPRESS_BZIP2) += decompress_bunzip2.o
diff --git a/lib/raid/Kconfig b/lib/raid/Kconfig
index 1fc4b00e0d71..9bea599d66da 100644
--- a/lib/raid/Kconfig
+++ b/lib/raid/Kconfig
@@ -28,3 +28,25 @@ config XOR_KUNIT_TEST
 
 	  This is intended to help people writing architecture-specific
 	  optimized versions.  If unsure, say N.
+
+config RAID6_PQ
+	tristate
+
+config RAID6_PQ_KUNIT_TEST
+	tristate "KUnit tests for raid6 PQ functions" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	depends on RAID6_PQ
+	default KUNIT_ALL_TESTS
+	help
+	  Unit tests for the RAID6 PQ library functions.
+
+	  This is intended to help people writing architecture-specific
+	  optimized versions.  If unsure, say N.
+
+config RAID6_PQ_BENCHMARK
+	bool "Automatically choose fastest RAID6 PQ functions"
+	depends on RAID6_PQ
+	default y
+	help
+	  Benchmark all available RAID6 PQ functions on init and choose the
+	  fastest one.
diff --git a/lib/raid/Makefile b/lib/raid/Makefile
index 3540fe846dc4..6fc5eeb53df0 100644
--- a/lib/raid/Makefile
+++ b/lib/raid/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-y				+= xor/
+obj-y				+= xor/ raid6/
diff --git a/lib/raid6/.gitignore b/lib/raid/raid6/.gitignore
similarity index 100%
rename from lib/raid6/.gitignore
rename to lib/raid/raid6/.gitignore
diff --git a/lib/raid/raid6/Makefile b/lib/raid/raid6/Makefile
new file mode 100644
index 000000000000..f155eba06fe3
--- /dev/null
+++ b/lib/raid/raid6/Makefile
@@ -0,0 +1,118 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_RAID6_PQ)		+= raid6_pq.o tests/
+
+raid6_pq-y			+= algos.o tables.o
+
+# generic integer generation and recovery implementation
+raid6_pq-y			+= int1.o int2.o int4.o int8.o
+raid6_pq-y			+= recov.o
+
+# architecture-specific generation and recovery implementations:
+raid6_pq-$(CONFIG_KERNEL_MODE_NEON) += arm/neon.o \
+				   arm/neon1.o \
+				   arm/neon2.o \
+				   arm/neon4.o \
+				   arm/neon8.o \
+				   arm/recov_neon.o \
+				   arm/recov_neon_inner.o
+raid6_pq-$(CONFIG_LOONGARCH)	+= loongarch/loongarch_simd.o \
+				   loongarch/recov_loongarch_simd.o
+raid6_pq-$(CONFIG_ALTIVEC)	+= powerpc/altivec1.o \
+				   powerpc/altivec2.o \
+				   powerpc/altivec4.o \
+				   powerpc/altivec8.o \
+				   powerpc/vpermxor1.o \
+				   powerpc/vpermxor2.o \
+				   powerpc/vpermxor4.o \
+				   powerpc/vpermxor8.o
+raid6_pq-$(CONFIG_RISCV_ISA_V)	+= riscv/rvv.o \
+				   riscv/recov_rvv.o
+raid6_pq-$(CONFIG_S390)		+= s390/s390vx8.o \
+				   s390/recov_s390xc.o
+ifeq ($(CONFIG_X86),y)
+raid6_pq-$(CONFIG_X86_32)	+= x86/mmx.o \
+				   x86/sse1.o
+endif
+raid6_pq-$(CONFIG_X86)		+= x86/sse2.o \
+				   x86/avx2.o \
+				   x86/avx512.o \
+				   x86/recov_ssse3.o \
+				   x86/recov_avx2.o \
+				   x86/recov_avx512.o
+
+hostprogs	+= mktables
+
+ifeq ($(CONFIG_ALTIVEC),y)
+altivec_flags := -maltivec $(call cc-option,-mabi=altivec)
+# Enable <altivec.h>
+altivec_flags += -isystem $(shell $(CC) -print-file-name=include)
+
+ifdef CONFIG_CC_IS_CLANG
+# clang ppc port does not yet support -maltivec when -msoft-float is
+# enabled. A future release of clang will resolve this
+# https://llvm.org/pr31177
+CFLAGS_REMOVE_powerpc/altivec1.o  += -msoft-float
+CFLAGS_REMOVE_powerpc/altivec2.o  += -msoft-float
+CFLAGS_REMOVE_powerpc/altivec4.o  += -msoft-float
+CFLAGS_REMOVE_powerpc/altivec8.o  += -msoft-float
+CFLAGS_REMOVE_vpermxor1.o += -msoft-float
+CFLAGS_REMOVE_vpermxor2.o += -msoft-float
+CFLAGS_REMOVE_vpermxor4.o += -msoft-float
+CFLAGS_REMOVE_vpermxor8.o += -msoft-float
+endif
+endif
+
+quiet_cmd_unroll = UNROLL  $@
+      cmd_unroll = $(AWK) -v N=$* -f $(src)/unroll.awk < $< > $@
+
+targets += int1.c int2.c int4.c int8.c
+$(obj)/int%.c: $(src)/int.uc $(src)/unroll.awk FORCE
+	$(call if_changed,unroll)
+
+CFLAGS_arm/neon1.o += $(CC_FLAGS_FPU)
+CFLAGS_arm/neon2.o += $(CC_FLAGS_FPU)
+CFLAGS_arm/neon4.o += $(CC_FLAGS_FPU)
+CFLAGS_arm/neon8.o += $(CC_FLAGS_FPU)
+CFLAGS_arm/recov_neon_inner.o += $(CC_FLAGS_FPU)
+CFLAGS_REMOVE_arm/neon1.o += $(CC_FLAGS_NO_FPU)
+CFLAGS_REMOVE_arm/neon2.o += $(CC_FLAGS_NO_FPU)
+CFLAGS_REMOVE_arm/neon4.o += $(CC_FLAGS_NO_FPU)
+CFLAGS_REMOVE_arm/neon8.o += $(CC_FLAGS_NO_FPU)
+CFLAGS_REMOVE_arm/recov_neon_inner.o += $(CC_FLAGS_NO_FPU)
+targets += arm/neon1.c arm/neon2.c arm/neon4.c arm/neon8.c
+$(obj)/arm/neon%.c: $(src)/arm/neon.uc $(src)/unroll.awk FORCE
+	$(call if_changed,unroll)
+
+CFLAGS_powerpc/altivec1.o += $(altivec_flags)
+CFLAGS_powerpc/altivec2.o += $(altivec_flags)
+CFLAGS_powerpc/altivec4.o += $(altivec_flags)
+CFLAGS_powerpc/altivec8.o += $(altivec_flags)
+targets += powerpc/altivec1.c \
+	   powerpc/altivec2.c \
+	   powerpc/altivec4.c \
+	   powerpc/altivec8.c
+$(obj)/powerpc/altivec%.c: $(src)/powerpc/altivec.uc $(src)/unroll.awk FORCE
+	$(call if_changed,unroll)
+
+CFLAGS_powerpc/vpermxor1.o += $(altivec_flags)
+CFLAGS_powerpc/vpermxor2.o += $(altivec_flags)
+CFLAGS_powerpc/vpermxor4.o += $(altivec_flags)
+CFLAGS_powerpc/vpermxor8.o += $(altivec_flags)
+targets += powerpc/vpermxor1.c \
+	   powerpc/vpermxor2.c \
+	   powerpc/vpermxor4.c \
+	   powerpc/vpermxor8.c
+$(obj)/powerpc/vpermxor%.c: $(src)/powerpc/vpermxor.uc $(src)/unroll.awk FORCE
+	$(call if_changed,unroll)
+
+targets += s390/s390vx8.c
+$(obj)/s390/s390vx%.c: $(src)/s390/s390vx.uc $(src)/unroll.awk FORCE
+	$(call if_changed,unroll)
+
+quiet_cmd_mktable = TABLE   $@
+      cmd_mktable = $(obj)/mktables > $@
+
+targets += tables.c
+$(obj)/tables.c: $(obj)/mktables FORCE
+	$(call if_changed,mktable)
diff --git a/lib/raid6/algos.c b/lib/raid/raid6/algos.c
similarity index 100%
rename from lib/raid6/algos.c
rename to lib/raid/raid6/algos.c
diff --git a/lib/raid6/neon.c b/lib/raid/raid6/arm/neon.c
similarity index 100%
rename from lib/raid6/neon.c
rename to lib/raid/raid6/arm/neon.c
diff --git a/lib/raid6/neon.h b/lib/raid/raid6/arm/neon.h
similarity index 100%
rename from lib/raid6/neon.h
rename to lib/raid/raid6/arm/neon.h
diff --git a/lib/raid6/neon.uc b/lib/raid/raid6/arm/neon.uc
similarity index 100%
rename from lib/raid6/neon.uc
rename to lib/raid/raid6/arm/neon.uc
diff --git a/lib/raid6/recov_neon.c b/lib/raid/raid6/arm/recov_neon.c
similarity index 100%
rename from lib/raid6/recov_neon.c
rename to lib/raid/raid6/arm/recov_neon.c
diff --git a/lib/raid6/recov_neon_inner.c b/lib/raid/raid6/arm/recov_neon_inner.c
similarity index 100%
rename from lib/raid6/recov_neon_inner.c
rename to lib/raid/raid6/arm/recov_neon_inner.c
diff --git a/lib/raid6/int.uc b/lib/raid/raid6/int.uc
similarity index 100%
rename from lib/raid6/int.uc
rename to lib/raid/raid6/int.uc
diff --git a/lib/raid6/loongarch_simd.c b/lib/raid/raid6/loongarch/loongarch_simd.c
similarity index 100%
rename from lib/raid6/loongarch_simd.c
rename to lib/raid/raid6/loongarch/loongarch_simd.c
diff --git a/lib/raid6/recov_loongarch_simd.c b/lib/raid/raid6/loongarch/recov_loongarch_simd.c
similarity index 100%
rename from lib/raid6/recov_loongarch_simd.c
rename to lib/raid/raid6/loongarch/recov_loongarch_simd.c
diff --git a/lib/raid6/mktables.c b/lib/raid/raid6/mktables.c
similarity index 100%
rename from lib/raid6/mktables.c
rename to lib/raid/raid6/mktables.c
diff --git a/lib/raid6/altivec.uc b/lib/raid/raid6/powerpc/altivec.uc
similarity index 98%
rename from lib/raid6/altivec.uc
rename to lib/raid/raid6/powerpc/altivec.uc
index 2c59963e58f9..130d3d3dd42c 100644
--- a/lib/raid6/altivec.uc
+++ b/lib/raid/raid6/powerpc/altivec.uc
@@ -24,8 +24,6 @@
 
 #include <linux/raid/pq.h>
 
-#ifdef CONFIG_ALTIVEC
-
 #include <altivec.h>
 #include <asm/cputable.h>
 #include <asm/switch_to.h>
@@ -122,5 +120,3 @@ const struct raid6_calls raid6_altivec$# = {
 	"altivecx$#",
 	0
 };
-
-#endif /* CONFIG_ALTIVEC */
diff --git a/lib/raid6/vpermxor.uc b/lib/raid/raid6/powerpc/vpermxor.uc
similarity index 98%
rename from lib/raid6/vpermxor.uc
rename to lib/raid/raid6/powerpc/vpermxor.uc
index a8e76b1c956e..595f20aaf4cf 100644
--- a/lib/raid6/vpermxor.uc
+++ b/lib/raid/raid6/powerpc/vpermxor.uc
@@ -21,8 +21,6 @@
  */
 
 #include <linux/raid/pq.h>
-#ifdef CONFIG_ALTIVEC
-
 #include <altivec.h>
 #include <asm/ppc-opcode.h>
 #include <asm/cputable.h>
@@ -95,4 +93,3 @@ const struct raid6_calls raid6_vpermxor$# = {
 	"vpermxor$#",
 	0
 };
-#endif
diff --git a/lib/raid6/recov.c b/lib/raid/raid6/recov.c
similarity index 100%
rename from lib/raid6/recov.c
rename to lib/raid/raid6/recov.c
diff --git a/lib/raid6/recov_rvv.c b/lib/raid/raid6/riscv/recov_rvv.c
similarity index 100%
rename from lib/raid6/recov_rvv.c
rename to lib/raid/raid6/riscv/recov_rvv.c
diff --git a/lib/raid6/rvv.c b/lib/raid/raid6/riscv/rvv.c
similarity index 100%
rename from lib/raid6/rvv.c
rename to lib/raid/raid6/riscv/rvv.c
diff --git a/lib/raid6/rvv.h b/lib/raid/raid6/riscv/rvv.h
similarity index 100%
rename from lib/raid6/rvv.h
rename to lib/raid/raid6/riscv/rvv.h
diff --git a/lib/raid6/recov_s390xc.c b/lib/raid/raid6/s390/recov_s390xc.c
similarity index 100%
rename from lib/raid6/recov_s390xc.c
rename to lib/raid/raid6/s390/recov_s390xc.c
diff --git a/lib/raid6/s390vx.uc b/lib/raid/raid6/s390/s390vx.uc
similarity index 100%
rename from lib/raid6/s390vx.uc
rename to lib/raid/raid6/s390/s390vx.uc
diff --git a/lib/raid/raid6/tests/Makefile b/lib/raid/raid6/tests/Makefile
new file mode 100644
index 000000000000..87a001b22847
--- /dev/null
+++ b/lib/raid/raid6/tests/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_RAID6_PQ_KUNIT_TEST)	+= raid6_kunit.o
diff --git a/lib/raid6/test/test.c b/lib/raid/raid6/tests/raid6_kunit.c
similarity index 100%
rename from lib/raid6/test/test.c
rename to lib/raid/raid6/tests/raid6_kunit.c
diff --git a/lib/raid6/unroll.awk b/lib/raid/raid6/unroll.awk
similarity index 100%
rename from lib/raid6/unroll.awk
rename to lib/raid/raid6/unroll.awk
diff --git a/lib/raid6/avx2.c b/lib/raid/raid6/x86/avx2.c
similarity index 100%
rename from lib/raid6/avx2.c
rename to lib/raid/raid6/x86/avx2.c
diff --git a/lib/raid6/avx512.c b/lib/raid/raid6/x86/avx512.c
similarity index 100%
rename from lib/raid6/avx512.c
rename to lib/raid/raid6/x86/avx512.c
diff --git a/lib/raid6/mmx.c b/lib/raid/raid6/x86/mmx.c
similarity index 99%
rename from lib/raid6/mmx.c
rename to lib/raid/raid6/x86/mmx.c
index e411f0cfbd95..7e9810669347 100644
--- a/lib/raid6/mmx.c
+++ b/lib/raid/raid6/x86/mmx.c
@@ -11,8 +11,6 @@
  * MMX implementation of RAID-6 syndrome functions
  */
 
-#ifdef CONFIG_X86_32
-
 #include <linux/raid/pq.h>
 #include <asm/fpu/api.h>
 
@@ -135,5 +133,3 @@ const struct raid6_calls raid6_mmxx2 = {
 	"mmxx2",
 	0
 };
-
-#endif
diff --git a/lib/raid6/recov_avx2.c b/lib/raid/raid6/x86/recov_avx2.c
similarity index 100%
rename from lib/raid6/recov_avx2.c
rename to lib/raid/raid6/x86/recov_avx2.c
diff --git a/lib/raid6/recov_avx512.c b/lib/raid/raid6/x86/recov_avx512.c
similarity index 100%
rename from lib/raid6/recov_avx512.c
rename to lib/raid/raid6/x86/recov_avx512.c
diff --git a/lib/raid6/recov_ssse3.c b/lib/raid/raid6/x86/recov_ssse3.c
similarity index 100%
rename from lib/raid6/recov_ssse3.c
rename to lib/raid/raid6/x86/recov_ssse3.c
diff --git a/lib/raid6/sse1.c b/lib/raid/raid6/x86/sse1.c
similarity index 99%
rename from lib/raid6/sse1.c
rename to lib/raid/raid6/x86/sse1.c
index 794d5cfa0306..deecdd72ceec 100644
--- a/lib/raid6/sse1.c
+++ b/lib/raid/raid6/x86/sse1.c
@@ -16,8 +16,6 @@
  * worthwhile as a separate implementation.
  */
 
-#ifdef CONFIG_X86_32
-
 #include <linux/raid/pq.h>
 #include <asm/fpu/api.h>
 
@@ -155,5 +153,3 @@ const struct raid6_calls raid6_sse1x2 = {
 	"sse1x2",
 	1			/* Has cache hints */
 };
-
-#endif
diff --git a/lib/raid6/sse2.c b/lib/raid/raid6/x86/sse2.c
similarity index 100%
rename from lib/raid6/sse2.c
rename to lib/raid/raid6/x86/sse2.c
diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
deleted file mode 100644
index 6fd048c127b6..000000000000
--- a/lib/raid6/Makefile
+++ /dev/null
@@ -1,83 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_RAID6_PQ)	+= raid6_pq.o test/
-
-raid6_pq-y	+= algos.o recov.o tables.o int1.o int2.o int4.o \
-		   int8.o
-
-raid6_pq-$(CONFIG_X86) += recov_ssse3.o recov_avx2.o mmx.o sse1.o sse2.o avx2.o avx512.o recov_avx512.o
-raid6_pq-$(CONFIG_ALTIVEC) += altivec1.o altivec2.o altivec4.o altivec8.o \
-                              vpermxor1.o vpermxor2.o vpermxor4.o vpermxor8.o
-raid6_pq-$(CONFIG_KERNEL_MODE_NEON) += neon.o neon1.o neon2.o neon4.o neon8.o recov_neon.o recov_neon_inner.o
-raid6_pq-$(CONFIG_S390) += s390vx8.o recov_s390xc.o
-raid6_pq-$(CONFIG_LOONGARCH) += loongarch_simd.o recov_loongarch_simd.o
-raid6_pq-$(CONFIG_RISCV_ISA_V) += rvv.o recov_rvv.o
-
-hostprogs	+= mktables
-
-ifeq ($(CONFIG_ALTIVEC),y)
-altivec_flags := -maltivec $(call cc-option,-mabi=altivec)
-# Enable <altivec.h>
-altivec_flags += -isystem $(shell $(CC) -print-file-name=include)
-
-ifdef CONFIG_CC_IS_CLANG
-# clang ppc port does not yet support -maltivec when -msoft-float is
-# enabled. A future release of clang will resolve this
-# https://llvm.org/pr31177
-CFLAGS_REMOVE_altivec1.o  += -msoft-float
-CFLAGS_REMOVE_altivec2.o  += -msoft-float
-CFLAGS_REMOVE_altivec4.o  += -msoft-float
-CFLAGS_REMOVE_altivec8.o  += -msoft-float
-CFLAGS_REMOVE_vpermxor1.o += -msoft-float
-CFLAGS_REMOVE_vpermxor2.o += -msoft-float
-CFLAGS_REMOVE_vpermxor4.o += -msoft-float
-CFLAGS_REMOVE_vpermxor8.o += -msoft-float
-endif
-endif
-
-quiet_cmd_unroll = UNROLL  $@
-      cmd_unroll = $(AWK) -v N=$* -f $(src)/unroll.awk < $< > $@
-
-targets += int1.c int2.c int4.c int8.c
-$(obj)/int%.c: $(src)/int.uc $(src)/unroll.awk FORCE
-	$(call if_changed,unroll)
-
-CFLAGS_altivec1.o += $(altivec_flags)
-CFLAGS_altivec2.o += $(altivec_flags)
-CFLAGS_altivec4.o += $(altivec_flags)
-CFLAGS_altivec8.o += $(altivec_flags)
-targets += altivec1.c altivec2.c altivec4.c altivec8.c
-$(obj)/altivec%.c: $(src)/altivec.uc $(src)/unroll.awk FORCE
-	$(call if_changed,unroll)
-
-CFLAGS_vpermxor1.o += $(altivec_flags)
-CFLAGS_vpermxor2.o += $(altivec_flags)
-CFLAGS_vpermxor4.o += $(altivec_flags)
-CFLAGS_vpermxor8.o += $(altivec_flags)
-targets += vpermxor1.c vpermxor2.c vpermxor4.c vpermxor8.c
-$(obj)/vpermxor%.c: $(src)/vpermxor.uc $(src)/unroll.awk FORCE
-	$(call if_changed,unroll)
-
-CFLAGS_neon1.o += $(CC_FLAGS_FPU)
-CFLAGS_neon2.o += $(CC_FLAGS_FPU)
-CFLAGS_neon4.o += $(CC_FLAGS_FPU)
-CFLAGS_neon8.o += $(CC_FLAGS_FPU)
-CFLAGS_recov_neon_inner.o += $(CC_FLAGS_FPU)
-CFLAGS_REMOVE_neon1.o += $(CC_FLAGS_NO_FPU)
-CFLAGS_REMOVE_neon2.o += $(CC_FLAGS_NO_FPU)
-CFLAGS_REMOVE_neon4.o += $(CC_FLAGS_NO_FPU)
-CFLAGS_REMOVE_neon8.o += $(CC_FLAGS_NO_FPU)
-CFLAGS_REMOVE_recov_neon_inner.o += $(CC_FLAGS_NO_FPU)
-targets += neon1.c neon2.c neon4.c neon8.c
-$(obj)/neon%.c: $(src)/neon.uc $(src)/unroll.awk FORCE
-	$(call if_changed,unroll)
-
-targets += s390vx8.c
-$(obj)/s390vx%.c: $(src)/s390vx.uc $(src)/unroll.awk FORCE
-	$(call if_changed,unroll)
-
-quiet_cmd_mktable = TABLE   $@
-      cmd_mktable = $(obj)/mktables > $@
-
-targets += tables.c
-$(obj)/tables.c: $(obj)/mktables FORCE
-	$(call if_changed,mktable)
diff --git a/lib/raid6/test/.gitignore b/lib/raid6/test/.gitignore
deleted file mode 100644
index 1b68a77f348f..000000000000
--- a/lib/raid6/test/.gitignore
+++ /dev/null
@@ -1,3 +0,0 @@
-/int.uc
-/neon.uc
-/raid6test
diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
deleted file mode 100644
index 268b085af4d3..000000000000
--- a/lib/raid6/test/Makefile
+++ /dev/null
@@ -1,3 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-
-obj-$(CONFIG_RAID6_PQ_KUNIT_TEST)	+= test.o
-- 
2.47.3

