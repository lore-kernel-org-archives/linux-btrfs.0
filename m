Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A0C3382DE;
	Tue, 12 May 2026 05:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778563408; cv=none; b=cQ/kXzEEHaFws6QXS5+Qcihy8IZH+BFutKTByYvZQuwLCHCTZ5z/eLlZmgAN2nOULo8gX2IMlg/rJr100qyg5kt5vrB3i/e9/pkG3gfql7W4E9ZqhQyujKYgWLB3zye70nmmRDFbgf8UpY9mT5N3AKgZ0KFnOU2uJWgdf6cQzEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778563408; c=relaxed/simple;
	bh=LDyVeNXWRSUHqz1m93i3uw6LvIWNCTBWGgRDZ3iTHxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgN3X0aKGsIUW2Ka0TyTxO2VyqahMhyrNt/zpixO57dm/raY+5mAkMHKjF+3N2Vfkw+r2botAKG6Doz/Wbh7JwTkYSiJSm3Z0k0kubRanG5JqIzdx+ioQks353cZ59RK4h58vDFVovyeIXMG2uQT5aNcPAGoqk5SUJeIWasJYR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=luOaa8oc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="luOaa8oc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZOzv16zlFjkjGc1LDUpuMoFbhN1+1mf/TktUpFx4uJc=; b=luOaa8ocKjzyIGykiDRCLkdM0H
	HJXCi06VyfMxFsE/MIFpQYsBfkle3TeU5+NFuCJZ6C8tt51GvAdQZtt6C/4r/LrA7TfT0/oGMnkDj
	Z1cZyBM0zHX613h/OSDOf5ivcUwVySH6c9lHWSFXjA/o0K5rH2yNKos15Vz8r8InEptw9rXROWln/
	ZPk8BFU37eaV+TlBlr6lazwNwNKB2F6vYE9E9ckX9xK5vyPsAE3ZM5nDEH5O2itXLs/eqOpWWa855
	KrJ6v0J9EV0qTq/TYGINEJ6nekHT6sc8TOiPyiJ8gwp0iAn1qXkg0st8iSicVg+4LFjDgPKAJoHWe
	u+haLJog==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfaJ-0000000FaeZ-39CZ;
	Tue, 12 May 2026 05:23:12 +0000
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
Subject: [PATCH 03/19] raid6: remove __KERNEL__ ifdefs
Date: Tue, 12 May 2026 07:20:43 +0200
Message-ID: <20260512052230.2947683-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512052230.2947683-1-hch@lst.de>
References: <20260512052230.2947683-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

With the test code ported to kernel space, none of this is required.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/raid/pq.h          | 90 --------------------------------
 lib/raid6/algos.c                | 12 -----
 lib/raid6/altivec.uc             | 10 +---
 lib/raid6/avx2.c                 |  2 +-
 lib/raid6/avx512.c               |  2 +-
 lib/raid6/loongarch.h            | 38 --------------
 lib/raid6/loongarch_simd.c       |  3 +-
 lib/raid6/mktables.c             | 14 -----
 lib/raid6/mmx.c                  |  2 +-
 lib/raid6/neon.c                 |  6 ---
 lib/raid6/recov_avx2.c           |  2 +-
 lib/raid6/recov_avx512.c         |  2 +-
 lib/raid6/recov_loongarch_simd.c |  3 +-
 lib/raid6/recov_neon.c           |  6 ---
 lib/raid6/recov_ssse3.c          |  2 +-
 lib/raid6/rvv.h                  | 11 +---
 lib/raid6/sse1.c                 |  2 +-
 lib/raid6/sse2.c                 |  2 +-
 lib/raid6/vpermxor.uc            |  7 ---
 lib/raid6/x86.h                  | 75 --------------------------
 20 files changed, 15 insertions(+), 276 deletions(-)
 delete mode 100644 lib/raid6/loongarch.h
 delete mode 100644 lib/raid6/x86.h

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 08c5995ea980..d26788fada58 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -8,8 +8,6 @@
 #ifndef LINUX_RAID_RAID6_H
 #define LINUX_RAID_RAID6_H
 
-#ifdef __KERNEL__
-
 #include <linux/blkdev.h>
 #include <linux/mm.h>
 
@@ -19,59 +17,6 @@ static inline void *raid6_get_zero_page(void)
 	return page_address(ZERO_PAGE(0));
 }
 
-#else /* ! __KERNEL__ */
-/* Used for testing in user space */
-
-#include <errno.h>
-#include <inttypes.h>
-#include <stddef.h>
-#include <string.h>
-#include <sys/mman.h>
-#include <sys/time.h>
-#include <sys/types.h>
-
-/* Not standard, but glibc defines it */
-#define BITS_PER_LONG __WORDSIZE
-
-typedef uint8_t  u8;
-typedef uint16_t u16;
-typedef uint32_t u32;
-typedef uint64_t u64;
-
-#ifndef PAGE_SIZE
-# define PAGE_SIZE 4096
-#endif
-#ifndef PAGE_SHIFT
-# define PAGE_SHIFT 12
-#endif
-extern const char raid6_empty_zero_page[PAGE_SIZE];
-
-#define __init
-#define __exit
-#ifndef __attribute_const__
-# define __attribute_const__ __attribute__((const))
-#endif
-#define noinline __attribute__((noinline))
-
-#define preempt_enable()
-#define preempt_disable()
-#define cpu_has_feature(x) 1
-#define enable_kernel_altivec()
-#define disable_kernel_altivec()
-
-#undef	EXPORT_SYMBOL
-#define EXPORT_SYMBOL(sym)
-#undef	EXPORT_SYMBOL_GPL
-#define EXPORT_SYMBOL_GPL(sym)
-#define MODULE_LICENSE(licence)
-#define MODULE_DESCRIPTION(desc)
-#define subsys_initcall(x)
-#define module_exit(x)
-
-#define IS_ENABLED(x) (x)
-#define CONFIG_RAID6_PQ_BENCHMARK 1
-#endif /* __KERNEL__ */
-
 /* Routine choices */
 struct raid6_calls {
 	void (*gen_syndrome)(int, size_t, void **);
@@ -165,39 +110,4 @@ extern void (*raid6_2data_recov)(int disks, size_t bytes, int faila, int failb,
 extern void (*raid6_datap_recov)(int disks, size_t bytes, int faila,
 			void **ptrs);
 
-/* Some definitions to allow code to be compiled for testing in userspace */
-#ifndef __KERNEL__
-
-# define jiffies	raid6_jiffies()
-# define printk 	printf
-# define pr_err(format, ...) fprintf(stderr, format, ## __VA_ARGS__)
-# define pr_info(format, ...) fprintf(stdout, format, ## __VA_ARGS__)
-# define GFP_KERNEL	0
-# define __get_free_pages(x, y)	((unsigned long)mmap(NULL, PAGE_SIZE << (y), \
-						     PROT_READ|PROT_WRITE,   \
-						     MAP_PRIVATE|MAP_ANONYMOUS,\
-						     0, 0))
-# define free_pages(x, y)	munmap((void *)(x), PAGE_SIZE << (y))
-
-static inline void cpu_relax(void)
-{
-	/* Nothing */
-}
-
-#undef  HZ
-#define HZ 1000
-static inline uint32_t raid6_jiffies(void)
-{
-	struct timeval tv;
-	gettimeofday(&tv, NULL);
-	return tv.tv_sec*1000 + tv.tv_usec/1000;
-}
-
-static inline void *raid6_get_zero_page(void)
-{
-	return raid6_empty_zero_page;
-}
-
-#endif /* ! __KERNEL__ */
-
 #endif /* LINUX_RAID_RAID6_H */
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 5a9f4882e18d..985c60bb00a4 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -12,13 +12,8 @@
  */
 
 #include <linux/raid/pq.h>
-#ifndef __KERNEL__
-#include <sys/mman.h>
-#include <stdio.h>
-#else
 #include <linux/module.h>
 #include <linux/gfp.h>
-#endif
 #include <kunit/visibility.h>
 
 struct raid6_calls raid6_call;
@@ -123,14 +118,7 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
 };
 EXPORT_SYMBOL_IF_KUNIT(raid6_recov_algos);
 
-#ifdef __KERNEL__
 #define RAID6_TIME_JIFFIES_LG2	4
-#else
-/* Need more time to be stable in userspace */
-#define RAID6_TIME_JIFFIES_LG2	9
-#define time_before(x, y) ((x) < (y))
-#endif
-
 #define RAID6_TEST_DISKS	8
 #define RAID6_TEST_DISKS_ORDER	3
 
diff --git a/lib/raid6/altivec.uc b/lib/raid6/altivec.uc
index d20ed0d11411..2c59963e58f9 100644
--- a/lib/raid6/altivec.uc
+++ b/lib/raid6/altivec.uc
@@ -27,10 +27,8 @@
 #ifdef CONFIG_ALTIVEC
 
 #include <altivec.h>
-#ifdef __KERNEL__
-# include <asm/cputable.h>
-# include <asm/switch_to.h>
-#endif /* __KERNEL__ */
+#include <asm/cputable.h>
+#include <asm/switch_to.h>
 
 /*
  * This is the C data type to use.  We use a vector of
@@ -113,11 +111,7 @@ int raid6_have_altivec(void);
 int raid6_have_altivec(void)
 {
 	/* This assumes either all CPUs have Altivec or none does */
-# ifdef __KERNEL__
 	return cpu_has_feature(CPU_FTR_ALTIVEC);
-# else
-	return 1;
-# endif
 }
 #endif
 
diff --git a/lib/raid6/avx2.c b/lib/raid6/avx2.c
index 059024234dce..a1a5213918af 100644
--- a/lib/raid6/avx2.c
+++ b/lib/raid6/avx2.c
@@ -14,7 +14,7 @@
  */
 
 #include <linux/raid/pq.h>
-#include "x86.h"
+#include <asm/fpu/api.h>
 
 static const struct raid6_avx2_constants {
 	u64 x1d[4];
diff --git a/lib/raid6/avx512.c b/lib/raid6/avx512.c
index 009bd0adeebf..874998bcd7d7 100644
--- a/lib/raid6/avx512.c
+++ b/lib/raid6/avx512.c
@@ -18,7 +18,7 @@
  */
 
 #include <linux/raid/pq.h>
-#include "x86.h"
+#include <asm/fpu/api.h>
 
 static const struct raid6_avx512_constants {
 	u64 x1d[8];
diff --git a/lib/raid6/loongarch.h b/lib/raid6/loongarch.h
deleted file mode 100644
index acfc33ce7056..000000000000
--- a/lib/raid6/loongarch.h
+++ /dev/null
@@ -1,38 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * Copyright (C) 2023 WANG Xuerui <git@xen0n.name>
- *
- * raid6/loongarch.h
- *
- * Definitions common to LoongArch RAID-6 code only
- */
-
-#ifndef _LIB_RAID6_LOONGARCH_H
-#define _LIB_RAID6_LOONGARCH_H
-
-#ifdef __KERNEL__
-
-#include <asm/cpu-features.h>
-#include <asm/fpu.h>
-
-#else /* for user-space testing */
-
-#include <sys/auxv.h>
-
-/* have to supply these defines for glibc 2.37- and musl */
-#ifndef HWCAP_LOONGARCH_LSX
-#define HWCAP_LOONGARCH_LSX	(1 << 4)
-#endif
-#ifndef HWCAP_LOONGARCH_LASX
-#define HWCAP_LOONGARCH_LASX	(1 << 5)
-#endif
-
-#define kernel_fpu_begin()
-#define kernel_fpu_end()
-
-#define cpu_has_lsx	(getauxval(AT_HWCAP) & HWCAP_LOONGARCH_LSX)
-#define cpu_has_lasx	(getauxval(AT_HWCAP) & HWCAP_LOONGARCH_LASX)
-
-#endif /* __KERNEL__ */
-
-#endif /* _LIB_RAID6_LOONGARCH_H */
diff --git a/lib/raid6/loongarch_simd.c b/lib/raid6/loongarch_simd.c
index aa5d9f924ca3..72f4d92d4876 100644
--- a/lib/raid6/loongarch_simd.c
+++ b/lib/raid6/loongarch_simd.c
@@ -10,7 +10,8 @@
  */
 
 #include <linux/raid/pq.h>
-#include "loongarch.h"
+#include <asm/cpu-features.h>
+#include <asm/fpu.h>
 
 /*
  * The vector algorithms are currently priority 0, which means the generic
diff --git a/lib/raid6/mktables.c b/lib/raid6/mktables.c
index 3be03793237c..3de1dbf6846c 100644
--- a/lib/raid6/mktables.c
+++ b/lib/raid6/mktables.c
@@ -56,9 +56,7 @@ int main(int argc, char *argv[])
 	uint8_t v;
 	uint8_t exptbl[256], invtbl[256];
 
-	printf("#ifdef __KERNEL__\n");
 	printf("#include <linux/export.h>\n");
-	printf("#endif\n");
 	printf("#include <linux/raid/pq.h>\n");
 
 	/* Compute multiplication table */
@@ -76,9 +74,7 @@ int main(int argc, char *argv[])
 		printf("\t},\n");
 	}
 	printf("};\n");
-	printf("#ifdef __KERNEL__\n");
 	printf("EXPORT_SYMBOL(raid6_gfmul);\n");
-	printf("#endif\n");
 
 	/* Compute vector multiplication table */
 	printf("\nconst u8  __attribute__((aligned(256)))\n"
@@ -101,9 +97,7 @@ int main(int argc, char *argv[])
 		printf("\t},\n");
 	}
 	printf("};\n");
-	printf("#ifdef __KERNEL__\n");
 	printf("EXPORT_SYMBOL(raid6_vgfmul);\n");
-	printf("#endif\n");
 
 	/* Compute power-of-2 table (exponent) */
 	v = 1;
@@ -120,9 +114,7 @@ int main(int argc, char *argv[])
 		}
 	}
 	printf("};\n");
-	printf("#ifdef __KERNEL__\n");
 	printf("EXPORT_SYMBOL(raid6_gfexp);\n");
-	printf("#endif\n");
 
 	/* Compute log-of-2 table */
 	printf("\nconst u8 __attribute__((aligned(256)))\n"
@@ -140,9 +132,7 @@ int main(int argc, char *argv[])
 		}
 	}
 	printf("};\n");
-	printf("#ifdef __KERNEL__\n");
 	printf("EXPORT_SYMBOL(raid6_gflog);\n");
-	printf("#endif\n");
 
 	/* Compute inverse table x^-1 == x^254 */
 	printf("\nconst u8 __attribute__((aligned(256)))\n"
@@ -155,9 +145,7 @@ int main(int argc, char *argv[])
 		}
 	}
 	printf("};\n");
-	printf("#ifdef __KERNEL__\n");
 	printf("EXPORT_SYMBOL(raid6_gfinv);\n");
-	printf("#endif\n");
 
 	/* Compute inv(2^x + 1) (exponent-xor-inverse) table */
 	printf("\nconst u8 __attribute__((aligned(256)))\n"
@@ -169,9 +157,7 @@ int main(int argc, char *argv[])
 			       (j == 7) ? '\n' : ' ');
 	}
 	printf("};\n");
-	printf("#ifdef __KERNEL__\n");
 	printf("EXPORT_SYMBOL(raid6_gfexi);\n");
-	printf("#endif\n");
 
 	return 0;
 }
diff --git a/lib/raid6/mmx.c b/lib/raid6/mmx.c
index 3a5bf53a297b..e411f0cfbd95 100644
--- a/lib/raid6/mmx.c
+++ b/lib/raid6/mmx.c
@@ -14,7 +14,7 @@
 #ifdef CONFIG_X86_32
 
 #include <linux/raid/pq.h>
-#include "x86.h"
+#include <asm/fpu/api.h>
 
 /* Shared with raid6/sse1.c */
 const struct raid6_mmx_constants {
diff --git a/lib/raid6/neon.c b/lib/raid6/neon.c
index 6d9474ce6da9..47b8bb0afc65 100644
--- a/lib/raid6/neon.c
+++ b/lib/raid6/neon.c
@@ -6,13 +6,7 @@
  */
 
 #include <linux/raid/pq.h>
-
-#ifdef __KERNEL__
 #include <asm/simd.h>
-#else
-#define scoped_ksimd()
-#define cpu_has_neon()		(1)
-#endif
 
 /*
  * There are 2 reasons these wrappers are kept in a separate compilation unit
diff --git a/lib/raid6/recov_avx2.c b/lib/raid6/recov_avx2.c
index 97d598d2535c..19fbd9c4dce6 100644
--- a/lib/raid6/recov_avx2.c
+++ b/lib/raid6/recov_avx2.c
@@ -5,7 +5,7 @@
  */
 
 #include <linux/raid/pq.h>
-#include "x86.h"
+#include <asm/fpu/api.h>
 
 static int raid6_has_avx2(void)
 {
diff --git a/lib/raid6/recov_avx512.c b/lib/raid6/recov_avx512.c
index 7986120ca444..143f4976b2ad 100644
--- a/lib/raid6/recov_avx512.c
+++ b/lib/raid6/recov_avx512.c
@@ -7,7 +7,7 @@
  */
 
 #include <linux/raid/pq.h>
-#include "x86.h"
+#include <asm/fpu/api.h>
 
 static int raid6_has_avx512(void)
 {
diff --git a/lib/raid6/recov_loongarch_simd.c b/lib/raid6/recov_loongarch_simd.c
index 93dc515997a1..eb3a1e79f01f 100644
--- a/lib/raid6/recov_loongarch_simd.c
+++ b/lib/raid6/recov_loongarch_simd.c
@@ -11,7 +11,8 @@
  */
 
 #include <linux/raid/pq.h>
-#include "loongarch.h"
+#include <asm/cpu-features.h>
+#include <asm/fpu.h>
 
 /*
  * Unlike with the syndrome calculation algorithms, there's no boot-time
diff --git a/lib/raid6/recov_neon.c b/lib/raid6/recov_neon.c
index 9d99aeabd31a..13d5df718c15 100644
--- a/lib/raid6/recov_neon.c
+++ b/lib/raid6/recov_neon.c
@@ -5,14 +5,8 @@
  */
 
 #include <linux/raid/pq.h>
-
-#ifdef __KERNEL__
 #include <asm/simd.h>
 #include "neon.h"
-#else
-#define scoped_ksimd()
-#define cpu_has_neon()		(1)
-#endif
 
 static int raid6_has_neon(void)
 {
diff --git a/lib/raid6/recov_ssse3.c b/lib/raid6/recov_ssse3.c
index 2e849185c32b..146cdbf465bd 100644
--- a/lib/raid6/recov_ssse3.c
+++ b/lib/raid6/recov_ssse3.c
@@ -4,7 +4,7 @@
  */
 
 #include <linux/raid/pq.h>
-#include "x86.h"
+#include <asm/fpu/api.h>
 
 static int raid6_has_ssse3(void)
 {
diff --git a/lib/raid6/rvv.h b/lib/raid6/rvv.h
index 6d0708a2c8a4..b0a71b375962 100644
--- a/lib/raid6/rvv.h
+++ b/lib/raid6/rvv.h
@@ -7,17 +7,8 @@
  * Definitions for RISC-V RAID-6 code
  */
 
-#ifdef __KERNEL__
-#include <asm/vector.h>
-#else
-#define kernel_vector_begin()
-#define kernel_vector_end()
-#include <sys/auxv.h>
-#include <asm/hwcap.h>
-#define has_vector() (getauxval(AT_HWCAP) & COMPAT_HWCAP_ISA_V)
-#endif
-
 #include <linux/raid/pq.h>
+#include <asm/vector.h>
 
 static int rvv_has_vector(void)
 {
diff --git a/lib/raid6/sse1.c b/lib/raid6/sse1.c
index 692fa3a93bf0..794d5cfa0306 100644
--- a/lib/raid6/sse1.c
+++ b/lib/raid6/sse1.c
@@ -19,7 +19,7 @@
 #ifdef CONFIG_X86_32
 
 #include <linux/raid/pq.h>
-#include "x86.h"
+#include <asm/fpu/api.h>
 
 /* Defined in raid6/mmx.c */
 extern const struct raid6_mmx_constants {
diff --git a/lib/raid6/sse2.c b/lib/raid6/sse2.c
index 2930220249c9..f9edf8a8d1c4 100644
--- a/lib/raid6/sse2.c
+++ b/lib/raid6/sse2.c
@@ -13,7 +13,7 @@
  */
 
 #include <linux/raid/pq.h>
-#include "x86.h"
+#include <asm/fpu/api.h>
 
 static const struct raid6_sse_constants {
 	u64 x1d[2];
diff --git a/lib/raid6/vpermxor.uc b/lib/raid6/vpermxor.uc
index 1bfb127fbfe8..a8e76b1c956e 100644
--- a/lib/raid6/vpermxor.uc
+++ b/lib/raid6/vpermxor.uc
@@ -25,10 +25,8 @@
 
 #include <altivec.h>
 #include <asm/ppc-opcode.h>
-#ifdef __KERNEL__
 #include <asm/cputable.h>
 #include <asm/switch_to.h>
-#endif
 
 typedef vector unsigned char unative_t;
 #define NSIZE sizeof(unative_t)
@@ -85,13 +83,8 @@ int raid6_have_altivec_vpermxor(void);
 int raid6_have_altivec_vpermxor(void)
 {
 	/* Check if arch has both altivec and the vpermxor instructions */
-# ifdef __KERNEL__
 	return (cpu_has_feature(CPU_FTR_ALTIVEC_COMP) &&
 		cpu_has_feature(CPU_FTR_ARCH_207S));
-# else
-	return 1;
-#endif
-
 }
 #endif
 
diff --git a/lib/raid6/x86.h b/lib/raid6/x86.h
deleted file mode 100644
index 9a6ff37115e7..000000000000
--- a/lib/raid6/x86.h
+++ /dev/null
@@ -1,75 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/* ----------------------------------------------------------------------- *
- *
- *   Copyright 2002-2004 H. Peter Anvin - All Rights Reserved
- *
- * ----------------------------------------------------------------------- */
-
-/*
- * raid6/x86.h
- *
- * Definitions common to x86 and x86-64 RAID-6 code only
- */
-
-#ifndef LINUX_RAID_RAID6X86_H
-#define LINUX_RAID_RAID6X86_H
-
-#if (defined(__i386__) || defined(__x86_64__)) && !defined(__arch_um__)
-
-#ifdef __KERNEL__ /* Real code */
-
-#include <asm/fpu/api.h>
-
-#else /* Dummy code for user space testing */
-
-static inline void kernel_fpu_begin(void)
-{
-}
-
-static inline void kernel_fpu_end(void)
-{
-}
-
-#define __aligned(x) __attribute__((aligned(x)))
-
-#define X86_FEATURE_MMX		(0*32+23) /* Multimedia Extensions */
-#define X86_FEATURE_FXSR	(0*32+24) /* FXSAVE and FXRSTOR instructions
-					   * (fast save and restore) */
-#define X86_FEATURE_XMM		(0*32+25) /* Streaming SIMD Extensions */
-#define X86_FEATURE_XMM2	(0*32+26) /* Streaming SIMD Extensions-2 */
-#define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
-#define X86_FEATURE_SSSE3	(4*32+ 9) /* Supplemental SSE-3 */
-#define X86_FEATURE_AVX	(4*32+28) /* Advanced Vector Extensions */
-#define X86_FEATURE_AVX2        (9*32+ 5) /* AVX2 instructions */
-#define X86_FEATURE_AVX512F     (9*32+16) /* AVX-512 Foundation */
-#define X86_FEATURE_AVX512DQ    (9*32+17) /* AVX-512 DQ (Double/Quad granular)
-					   * Instructions
-					   */
-#define X86_FEATURE_AVX512BW    (9*32+30) /* AVX-512 BW (Byte/Word granular)
-					   * Instructions
-					   */
-#define X86_FEATURE_AVX512VL    (9*32+31) /* AVX-512 VL (128/256 Vector Length)
-					   * Extensions
-					   */
-#define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
-
-/* Should work well enough on modern CPUs for testing */
-static inline int boot_cpu_has(int flag)
-{
-	u32 eax, ebx, ecx, edx;
-
-	eax = (flag & 0x100) ? 7 :
-		(flag & 0x20) ? 0x80000001 : 1;
-	ecx = 0;
-
-	asm volatile("cpuid"
-		     : "+a" (eax), "=b" (ebx), "=d" (edx), "+c" (ecx));
-
-	return ((flag & 0x100 ? ebx :
-		(flag & 0x80) ? ecx : edx) >> (flag & 31)) & 1;
-}
-
-#endif /* ndef __KERNEL__ */
-
-#endif
-#endif
-- 
2.53.0

