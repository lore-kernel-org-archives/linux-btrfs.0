Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C276377024;
	Wed, 11 Mar 2026 07:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773212812; cv=none; b=QMUJmOZ9PhytBbUd6uZUYaeWxkWL1BAbkBNga4D+YwX/x/oOpdu2izJZLXncyeGSvmLFrwu1BiuhyL4LijlbcvyPoLMxxS/zPi6Tofgipj3p67gheMM4sQKp+/Pk2A96n3p2B7BSXv/suGcB4v+yNbOZml0y/Rx54uIJVHTVe+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773212812; c=relaxed/simple;
	bh=7tm/I+ToBtGzhPxAelbzye3gAUwCUmdECLbEfmikNmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQwY4uy/78OZbzkgJZZq6KJXGXqulh/DY4lvaS2h4TzGuYt2hk+Ez33bLmMkNvSzjeemWVQV6xA5K/1US07WaJ1EdsSgr5tE5NaTxQcUlLgqysnNvwFPO2hiX8dqbM15VYVWclyy5DeW3N92Ikxp8cwjGdZs6vo606g0lKKAl+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iRrIOpqs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iRrIOpqs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AuswcUODFcjfkuCW6IvHw2LNaByAD11L1gbTzdzZTFM=; b=iRrIOpqs1le0pEADlyBBURoLa1
	1QJFtOteEKyxwVjMTbUReXl5Sd9GYD9jcforc+PrXWwhc5g7OlvWLE3BLnK9j6LkKyeBq8HQk12Ab
	rjF5aUutAZ1Sm5MLz/5hcsZ5YGtjrLzdA1YX/SanDgWv7ECixA8ECZJvmbxlfnO2vEskP8jQQIbdV
	Ff/CVmJtLcFi+vXA62Wk6bDdBvYRqj5R2wcV8HsvyCH8BtQCI4itNkvCQwLJjh+jSB/1edNopqsDg
	jYELZDP6PQhEfcU1ODFDRRG80z8XlqzUXFUBVXyX1wpAexHPFhHtIBFlD7QX+YY4NH2ccBfsFWMSo
	IdAJaJUg==;
Received: from [212.243.42.10] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0DeL-0000000Az5S-0vl2;
	Wed, 11 Mar 2026 07:06:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
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
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
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
	"Theodore Ts'o" <tytso@mit.edu>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 09/27] xor: move generic implementations out of asm-generic/xor.h
Date: Wed, 11 Mar 2026 08:03:41 +0100
Message-ID: <20260311070416.972667-10-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260311070416.972667-1-hch@lst.de>
References: <20260311070416.972667-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the generic implementations from asm-generic/xor.h to
per-implementaion .c files in lib/raid.  This will build them
unconditionally even when an architecture forces a specific
implementation, but as we'll need at least one generic version
for the static_call optimization later on we'll pay that price.

Note that this would cause the second xor_block_8regs instance created by
arch/arm/lib/xor-neon.c to be generated instead of discarded as dead
code, so add a NO_TEMPLATE symbol to disable it for this case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/arm/lib/xor-neon.c            |   4 +-
 include/asm-generic/xor.h          | 727 +----------------------------
 lib/raid/xor/Makefile              |   4 +
 lib/raid/xor/xor-32regs-prefetch.c | 268 +++++++++++
 lib/raid/xor/xor-32regs.c          | 219 +++++++++
 lib/raid/xor/xor-8regs-prefetch.c  | 146 ++++++
 lib/raid/xor/xor-8regs.c           | 105 +++++
 7 files changed, 748 insertions(+), 725 deletions(-)
 create mode 100644 lib/raid/xor/xor-32regs-prefetch.c
 create mode 100644 lib/raid/xor/xor-32regs.c
 create mode 100644 lib/raid/xor/xor-8regs-prefetch.c
 create mode 100644 lib/raid/xor/xor-8regs.c

diff --git a/arch/arm/lib/xor-neon.c b/arch/arm/lib/xor-neon.c
index 282980b9bf2a..b5be50567991 100644
--- a/arch/arm/lib/xor-neon.c
+++ b/arch/arm/lib/xor-neon.c
@@ -26,8 +26,8 @@ MODULE_LICENSE("GPL");
 #pragma GCC optimize "tree-vectorize"
 #endif
 
-#pragma GCC diagnostic ignored "-Wunused-variable"
-#include <asm-generic/xor.h>
+#define NO_TEMPLATE
+#include "../../../lib/raid/xor/xor-8regs.c"
 
 struct xor_block_template const xor_block_neon_inner = {
 	.name	= "__inner_neon__",
diff --git a/include/asm-generic/xor.h b/include/asm-generic/xor.h
index 79c0096aa9d9..fc151fdc45ab 100644
--- a/include/asm-generic/xor.h
+++ b/include/asm-generic/xor.h
@@ -5,726 +5,7 @@
  * Generic optimized RAID-5 checksumming functions.
  */
 
-#include <linux/prefetch.h>
-
-static void
-xor_8regs_2(unsigned long bytes, unsigned long * __restrict p1,
-	    const unsigned long * __restrict p2)
-{
-	long lines = bytes / (sizeof (long)) / 8;
-
-	do {
-		p1[0] ^= p2[0];
-		p1[1] ^= p2[1];
-		p1[2] ^= p2[2];
-		p1[3] ^= p2[3];
-		p1[4] ^= p2[4];
-		p1[5] ^= p2[5];
-		p1[6] ^= p2[6];
-		p1[7] ^= p2[7];
-		p1 += 8;
-		p2 += 8;
-	} while (--lines > 0);
-}
-
-static void
-xor_8regs_3(unsigned long bytes, unsigned long * __restrict p1,
-	    const unsigned long * __restrict p2,
-	    const unsigned long * __restrict p3)
-{
-	long lines = bytes / (sizeof (long)) / 8;
-
-	do {
-		p1[0] ^= p2[0] ^ p3[0];
-		p1[1] ^= p2[1] ^ p3[1];
-		p1[2] ^= p2[2] ^ p3[2];
-		p1[3] ^= p2[3] ^ p3[3];
-		p1[4] ^= p2[4] ^ p3[4];
-		p1[5] ^= p2[5] ^ p3[5];
-		p1[6] ^= p2[6] ^ p3[6];
-		p1[7] ^= p2[7] ^ p3[7];
-		p1 += 8;
-		p2 += 8;
-		p3 += 8;
-	} while (--lines > 0);
-}
-
-static void
-xor_8regs_4(unsigned long bytes, unsigned long * __restrict p1,
-	    const unsigned long * __restrict p2,
-	    const unsigned long * __restrict p3,
-	    const unsigned long * __restrict p4)
-{
-	long lines = bytes / (sizeof (long)) / 8;
-
-	do {
-		p1[0] ^= p2[0] ^ p3[0] ^ p4[0];
-		p1[1] ^= p2[1] ^ p3[1] ^ p4[1];
-		p1[2] ^= p2[2] ^ p3[2] ^ p4[2];
-		p1[3] ^= p2[3] ^ p3[3] ^ p4[3];
-		p1[4] ^= p2[4] ^ p3[4] ^ p4[4];
-		p1[5] ^= p2[5] ^ p3[5] ^ p4[5];
-		p1[6] ^= p2[6] ^ p3[6] ^ p4[6];
-		p1[7] ^= p2[7] ^ p3[7] ^ p4[7];
-		p1 += 8;
-		p2 += 8;
-		p3 += 8;
-		p4 += 8;
-	} while (--lines > 0);
-}
-
-static void
-xor_8regs_5(unsigned long bytes, unsigned long * __restrict p1,
-	    const unsigned long * __restrict p2,
-	    const unsigned long * __restrict p3,
-	    const unsigned long * __restrict p4,
-	    const unsigned long * __restrict p5)
-{
-	long lines = bytes / (sizeof (long)) / 8;
-
-	do {
-		p1[0] ^= p2[0] ^ p3[0] ^ p4[0] ^ p5[0];
-		p1[1] ^= p2[1] ^ p3[1] ^ p4[1] ^ p5[1];
-		p1[2] ^= p2[2] ^ p3[2] ^ p4[2] ^ p5[2];
-		p1[3] ^= p2[3] ^ p3[3] ^ p4[3] ^ p5[3];
-		p1[4] ^= p2[4] ^ p3[4] ^ p4[4] ^ p5[4];
-		p1[5] ^= p2[5] ^ p3[5] ^ p4[5] ^ p5[5];
-		p1[6] ^= p2[6] ^ p3[6] ^ p4[6] ^ p5[6];
-		p1[7] ^= p2[7] ^ p3[7] ^ p4[7] ^ p5[7];
-		p1 += 8;
-		p2 += 8;
-		p3 += 8;
-		p4 += 8;
-		p5 += 8;
-	} while (--lines > 0);
-}
-
-static void
-xor_32regs_2(unsigned long bytes, unsigned long * __restrict p1,
-	     const unsigned long * __restrict p2)
-{
-	long lines = bytes / (sizeof (long)) / 8;
-
-	do {
-		register long d0, d1, d2, d3, d4, d5, d6, d7;
-		d0 = p1[0];	/* Pull the stuff into registers	*/
-		d1 = p1[1];	/*  ... in bursts, if possible.		*/
-		d2 = p1[2];
-		d3 = p1[3];
-		d4 = p1[4];
-		d5 = p1[5];
-		d6 = p1[6];
-		d7 = p1[7];
-		d0 ^= p2[0];
-		d1 ^= p2[1];
-		d2 ^= p2[2];
-		d3 ^= p2[3];
-		d4 ^= p2[4];
-		d5 ^= p2[5];
-		d6 ^= p2[6];
-		d7 ^= p2[7];
-		p1[0] = d0;	/* Store the result (in bursts)		*/
-		p1[1] = d1;
-		p1[2] = d2;
-		p1[3] = d3;
-		p1[4] = d4;
-		p1[5] = d5;
-		p1[6] = d6;
-		p1[7] = d7;
-		p1 += 8;
-		p2 += 8;
-	} while (--lines > 0);
-}
-
-static void
-xor_32regs_3(unsigned long bytes, unsigned long * __restrict p1,
-	     const unsigned long * __restrict p2,
-	     const unsigned long * __restrict p3)
-{
-	long lines = bytes / (sizeof (long)) / 8;
-
-	do {
-		register long d0, d1, d2, d3, d4, d5, d6, d7;
-		d0 = p1[0];	/* Pull the stuff into registers	*/
-		d1 = p1[1];	/*  ... in bursts, if possible.		*/
-		d2 = p1[2];
-		d3 = p1[3];
-		d4 = p1[4];
-		d5 = p1[5];
-		d6 = p1[6];
-		d7 = p1[7];
-		d0 ^= p2[0];
-		d1 ^= p2[1];
-		d2 ^= p2[2];
-		d3 ^= p2[3];
-		d4 ^= p2[4];
-		d5 ^= p2[5];
-		d6 ^= p2[6];
-		d7 ^= p2[7];
-		d0 ^= p3[0];
-		d1 ^= p3[1];
-		d2 ^= p3[2];
-		d3 ^= p3[3];
-		d4 ^= p3[4];
-		d5 ^= p3[5];
-		d6 ^= p3[6];
-		d7 ^= p3[7];
-		p1[0] = d0;	/* Store the result (in bursts)		*/
-		p1[1] = d1;
-		p1[2] = d2;
-		p1[3] = d3;
-		p1[4] = d4;
-		p1[5] = d5;
-		p1[6] = d6;
-		p1[7] = d7;
-		p1 += 8;
-		p2 += 8;
-		p3 += 8;
-	} while (--lines > 0);
-}
-
-static void
-xor_32regs_4(unsigned long bytes, unsigned long * __restrict p1,
-	     const unsigned long * __restrict p2,
-	     const unsigned long * __restrict p3,
-	     const unsigned long * __restrict p4)
-{
-	long lines = bytes / (sizeof (long)) / 8;
-
-	do {
-		register long d0, d1, d2, d3, d4, d5, d6, d7;
-		d0 = p1[0];	/* Pull the stuff into registers	*/
-		d1 = p1[1];	/*  ... in bursts, if possible.		*/
-		d2 = p1[2];
-		d3 = p1[3];
-		d4 = p1[4];
-		d5 = p1[5];
-		d6 = p1[6];
-		d7 = p1[7];
-		d0 ^= p2[0];
-		d1 ^= p2[1];
-		d2 ^= p2[2];
-		d3 ^= p2[3];
-		d4 ^= p2[4];
-		d5 ^= p2[5];
-		d6 ^= p2[6];
-		d7 ^= p2[7];
-		d0 ^= p3[0];
-		d1 ^= p3[1];
-		d2 ^= p3[2];
-		d3 ^= p3[3];
-		d4 ^= p3[4];
-		d5 ^= p3[5];
-		d6 ^= p3[6];
-		d7 ^= p3[7];
-		d0 ^= p4[0];
-		d1 ^= p4[1];
-		d2 ^= p4[2];
-		d3 ^= p4[3];
-		d4 ^= p4[4];
-		d5 ^= p4[5];
-		d6 ^= p4[6];
-		d7 ^= p4[7];
-		p1[0] = d0;	/* Store the result (in bursts)		*/
-		p1[1] = d1;
-		p1[2] = d2;
-		p1[3] = d3;
-		p1[4] = d4;
-		p1[5] = d5;
-		p1[6] = d6;
-		p1[7] = d7;
-		p1 += 8;
-		p2 += 8;
-		p3 += 8;
-		p4 += 8;
-	} while (--lines > 0);
-}
-
-static void
-xor_32regs_5(unsigned long bytes, unsigned long * __restrict p1,
-	     const unsigned long * __restrict p2,
-	     const unsigned long * __restrict p3,
-	     const unsigned long * __restrict p4,
-	     const unsigned long * __restrict p5)
-{
-	long lines = bytes / (sizeof (long)) / 8;
-
-	do {
-		register long d0, d1, d2, d3, d4, d5, d6, d7;
-		d0 = p1[0];	/* Pull the stuff into registers	*/
-		d1 = p1[1];	/*  ... in bursts, if possible.		*/
-		d2 = p1[2];
-		d3 = p1[3];
-		d4 = p1[4];
-		d5 = p1[5];
-		d6 = p1[6];
-		d7 = p1[7];
-		d0 ^= p2[0];
-		d1 ^= p2[1];
-		d2 ^= p2[2];
-		d3 ^= p2[3];
-		d4 ^= p2[4];
-		d5 ^= p2[5];
-		d6 ^= p2[6];
-		d7 ^= p2[7];
-		d0 ^= p3[0];
-		d1 ^= p3[1];
-		d2 ^= p3[2];
-		d3 ^= p3[3];
-		d4 ^= p3[4];
-		d5 ^= p3[5];
-		d6 ^= p3[6];
-		d7 ^= p3[7];
-		d0 ^= p4[0];
-		d1 ^= p4[1];
-		d2 ^= p4[2];
-		d3 ^= p4[3];
-		d4 ^= p4[4];
-		d5 ^= p4[5];
-		d6 ^= p4[6];
-		d7 ^= p4[7];
-		d0 ^= p5[0];
-		d1 ^= p5[1];
-		d2 ^= p5[2];
-		d3 ^= p5[3];
-		d4 ^= p5[4];
-		d5 ^= p5[5];
-		d6 ^= p5[6];
-		d7 ^= p5[7];
-		p1[0] = d0;	/* Store the result (in bursts)		*/
-		p1[1] = d1;
-		p1[2] = d2;
-		p1[3] = d3;
-		p1[4] = d4;
-		p1[5] = d5;
-		p1[6] = d6;
-		p1[7] = d7;
-		p1 += 8;
-		p2 += 8;
-		p3 += 8;
-		p4 += 8;
-		p5 += 8;
-	} while (--lines > 0);
-}
-
-static void
-xor_8regs_p_2(unsigned long bytes, unsigned long * __restrict p1,
-	      const unsigned long * __restrict p2)
-{
-	long lines = bytes / (sizeof (long)) / 8 - 1;
-	prefetchw(p1);
-	prefetch(p2);
-
-	do {
-		prefetchw(p1+8);
-		prefetch(p2+8);
- once_more:
-		p1[0] ^= p2[0];
-		p1[1] ^= p2[1];
-		p1[2] ^= p2[2];
-		p1[3] ^= p2[3];
-		p1[4] ^= p2[4];
-		p1[5] ^= p2[5];
-		p1[6] ^= p2[6];
-		p1[7] ^= p2[7];
-		p1 += 8;
-		p2 += 8;
-	} while (--lines > 0);
-	if (lines == 0)
-		goto once_more;
-}
-
-static void
-xor_8regs_p_3(unsigned long bytes, unsigned long * __restrict p1,
-	      const unsigned long * __restrict p2,
-	      const unsigned long * __restrict p3)
-{
-	long lines = bytes / (sizeof (long)) / 8 - 1;
-	prefetchw(p1);
-	prefetch(p2);
-	prefetch(p3);
-
-	do {
-		prefetchw(p1+8);
-		prefetch(p2+8);
-		prefetch(p3+8);
- once_more:
-		p1[0] ^= p2[0] ^ p3[0];
-		p1[1] ^= p2[1] ^ p3[1];
-		p1[2] ^= p2[2] ^ p3[2];
-		p1[3] ^= p2[3] ^ p3[3];
-		p1[4] ^= p2[4] ^ p3[4];
-		p1[5] ^= p2[5] ^ p3[5];
-		p1[6] ^= p2[6] ^ p3[6];
-		p1[7] ^= p2[7] ^ p3[7];
-		p1 += 8;
-		p2 += 8;
-		p3 += 8;
-	} while (--lines > 0);
-	if (lines == 0)
-		goto once_more;
-}
-
-static void
-xor_8regs_p_4(unsigned long bytes, unsigned long * __restrict p1,
-	      const unsigned long * __restrict p2,
-	      const unsigned long * __restrict p3,
-	      const unsigned long * __restrict p4)
-{
-	long lines = bytes / (sizeof (long)) / 8 - 1;
-
-	prefetchw(p1);
-	prefetch(p2);
-	prefetch(p3);
-	prefetch(p4);
-
-	do {
-		prefetchw(p1+8);
-		prefetch(p2+8);
-		prefetch(p3+8);
-		prefetch(p4+8);
- once_more:
-		p1[0] ^= p2[0] ^ p3[0] ^ p4[0];
-		p1[1] ^= p2[1] ^ p3[1] ^ p4[1];
-		p1[2] ^= p2[2] ^ p3[2] ^ p4[2];
-		p1[3] ^= p2[3] ^ p3[3] ^ p4[3];
-		p1[4] ^= p2[4] ^ p3[4] ^ p4[4];
-		p1[5] ^= p2[5] ^ p3[5] ^ p4[5];
-		p1[6] ^= p2[6] ^ p3[6] ^ p4[6];
-		p1[7] ^= p2[7] ^ p3[7] ^ p4[7];
-		p1 += 8;
-		p2 += 8;
-		p3 += 8;
-		p4 += 8;
-	} while (--lines > 0);
-	if (lines == 0)
-		goto once_more;
-}
-
-static void
-xor_8regs_p_5(unsigned long bytes, unsigned long * __restrict p1,
-	      const unsigned long * __restrict p2,
-	      const unsigned long * __restrict p3,
-	      const unsigned long * __restrict p4,
-	      const unsigned long * __restrict p5)
-{
-	long lines = bytes / (sizeof (long)) / 8 - 1;
-
-	prefetchw(p1);
-	prefetch(p2);
-	prefetch(p3);
-	prefetch(p4);
-	prefetch(p5);
-
-	do {
-		prefetchw(p1+8);
-		prefetch(p2+8);
-		prefetch(p3+8);
-		prefetch(p4+8);
-		prefetch(p5+8);
- once_more:
-		p1[0] ^= p2[0] ^ p3[0] ^ p4[0] ^ p5[0];
-		p1[1] ^= p2[1] ^ p3[1] ^ p4[1] ^ p5[1];
-		p1[2] ^= p2[2] ^ p3[2] ^ p4[2] ^ p5[2];
-		p1[3] ^= p2[3] ^ p3[3] ^ p4[3] ^ p5[3];
-		p1[4] ^= p2[4] ^ p3[4] ^ p4[4] ^ p5[4];
-		p1[5] ^= p2[5] ^ p3[5] ^ p4[5] ^ p5[5];
-		p1[6] ^= p2[6] ^ p3[6] ^ p4[6] ^ p5[6];
-		p1[7] ^= p2[7] ^ p3[7] ^ p4[7] ^ p5[7];
-		p1 += 8;
-		p2 += 8;
-		p3 += 8;
-		p4 += 8;
-		p5 += 8;
-	} while (--lines > 0);
-	if (lines == 0)
-		goto once_more;
-}
-
-static void
-xor_32regs_p_2(unsigned long bytes, unsigned long * __restrict p1,
-	       const unsigned long * __restrict p2)
-{
-	long lines = bytes / (sizeof (long)) / 8 - 1;
-
-	prefetchw(p1);
-	prefetch(p2);
-
-	do {
-		register long d0, d1, d2, d3, d4, d5, d6, d7;
-
-		prefetchw(p1+8);
-		prefetch(p2+8);
- once_more:
-		d0 = p1[0];	/* Pull the stuff into registers	*/
-		d1 = p1[1];	/*  ... in bursts, if possible.		*/
-		d2 = p1[2];
-		d3 = p1[3];
-		d4 = p1[4];
-		d5 = p1[5];
-		d6 = p1[6];
-		d7 = p1[7];
-		d0 ^= p2[0];
-		d1 ^= p2[1];
-		d2 ^= p2[2];
-		d3 ^= p2[3];
-		d4 ^= p2[4];
-		d5 ^= p2[5];
-		d6 ^= p2[6];
-		d7 ^= p2[7];
-		p1[0] = d0;	/* Store the result (in bursts)		*/
-		p1[1] = d1;
-		p1[2] = d2;
-		p1[3] = d3;
-		p1[4] = d4;
-		p1[5] = d5;
-		p1[6] = d6;
-		p1[7] = d7;
-		p1 += 8;
-		p2 += 8;
-	} while (--lines > 0);
-	if (lines == 0)
-		goto once_more;
-}
-
-static void
-xor_32regs_p_3(unsigned long bytes, unsigned long * __restrict p1,
-	       const unsigned long * __restrict p2,
-	       const unsigned long * __restrict p3)
-{
-	long lines = bytes / (sizeof (long)) / 8 - 1;
-
-	prefetchw(p1);
-	prefetch(p2);
-	prefetch(p3);
-
-	do {
-		register long d0, d1, d2, d3, d4, d5, d6, d7;
-
-		prefetchw(p1+8);
-		prefetch(p2+8);
-		prefetch(p3+8);
- once_more:
-		d0 = p1[0];	/* Pull the stuff into registers	*/
-		d1 = p1[1];	/*  ... in bursts, if possible.		*/
-		d2 = p1[2];
-		d3 = p1[3];
-		d4 = p1[4];
-		d5 = p1[5];
-		d6 = p1[6];
-		d7 = p1[7];
-		d0 ^= p2[0];
-		d1 ^= p2[1];
-		d2 ^= p2[2];
-		d3 ^= p2[3];
-		d4 ^= p2[4];
-		d5 ^= p2[5];
-		d6 ^= p2[6];
-		d7 ^= p2[7];
-		d0 ^= p3[0];
-		d1 ^= p3[1];
-		d2 ^= p3[2];
-		d3 ^= p3[3];
-		d4 ^= p3[4];
-		d5 ^= p3[5];
-		d6 ^= p3[6];
-		d7 ^= p3[7];
-		p1[0] = d0;	/* Store the result (in bursts)		*/
-		p1[1] = d1;
-		p1[2] = d2;
-		p1[3] = d3;
-		p1[4] = d4;
-		p1[5] = d5;
-		p1[6] = d6;
-		p1[7] = d7;
-		p1 += 8;
-		p2 += 8;
-		p3 += 8;
-	} while (--lines > 0);
-	if (lines == 0)
-		goto once_more;
-}
-
-static void
-xor_32regs_p_4(unsigned long bytes, unsigned long * __restrict p1,
-	       const unsigned long * __restrict p2,
-	       const unsigned long * __restrict p3,
-	       const unsigned long * __restrict p4)
-{
-	long lines = bytes / (sizeof (long)) / 8 - 1;
-
-	prefetchw(p1);
-	prefetch(p2);
-	prefetch(p3);
-	prefetch(p4);
-
-	do {
-		register long d0, d1, d2, d3, d4, d5, d6, d7;
-
-		prefetchw(p1+8);
-		prefetch(p2+8);
-		prefetch(p3+8);
-		prefetch(p4+8);
- once_more:
-		d0 = p1[0];	/* Pull the stuff into registers	*/
-		d1 = p1[1];	/*  ... in bursts, if possible.		*/
-		d2 = p1[2];
-		d3 = p1[3];
-		d4 = p1[4];
-		d5 = p1[5];
-		d6 = p1[6];
-		d7 = p1[7];
-		d0 ^= p2[0];
-		d1 ^= p2[1];
-		d2 ^= p2[2];
-		d3 ^= p2[3];
-		d4 ^= p2[4];
-		d5 ^= p2[5];
-		d6 ^= p2[6];
-		d7 ^= p2[7];
-		d0 ^= p3[0];
-		d1 ^= p3[1];
-		d2 ^= p3[2];
-		d3 ^= p3[3];
-		d4 ^= p3[4];
-		d5 ^= p3[5];
-		d6 ^= p3[6];
-		d7 ^= p3[7];
-		d0 ^= p4[0];
-		d1 ^= p4[1];
-		d2 ^= p4[2];
-		d3 ^= p4[3];
-		d4 ^= p4[4];
-		d5 ^= p4[5];
-		d6 ^= p4[6];
-		d7 ^= p4[7];
-		p1[0] = d0;	/* Store the result (in bursts)		*/
-		p1[1] = d1;
-		p1[2] = d2;
-		p1[3] = d3;
-		p1[4] = d4;
-		p1[5] = d5;
-		p1[6] = d6;
-		p1[7] = d7;
-		p1 += 8;
-		p2 += 8;
-		p3 += 8;
-		p4 += 8;
-	} while (--lines > 0);
-	if (lines == 0)
-		goto once_more;
-}
-
-static void
-xor_32regs_p_5(unsigned long bytes, unsigned long * __restrict p1,
-	       const unsigned long * __restrict p2,
-	       const unsigned long * __restrict p3,
-	       const unsigned long * __restrict p4,
-	       const unsigned long * __restrict p5)
-{
-	long lines = bytes / (sizeof (long)) / 8 - 1;
-
-	prefetchw(p1);
-	prefetch(p2);
-	prefetch(p3);
-	prefetch(p4);
-	prefetch(p5);
-
-	do {
-		register long d0, d1, d2, d3, d4, d5, d6, d7;
-
-		prefetchw(p1+8);
-		prefetch(p2+8);
-		prefetch(p3+8);
-		prefetch(p4+8);
-		prefetch(p5+8);
- once_more:
-		d0 = p1[0];	/* Pull the stuff into registers	*/
-		d1 = p1[1];	/*  ... in bursts, if possible.		*/
-		d2 = p1[2];
-		d3 = p1[3];
-		d4 = p1[4];
-		d5 = p1[5];
-		d6 = p1[6];
-		d7 = p1[7];
-		d0 ^= p2[0];
-		d1 ^= p2[1];
-		d2 ^= p2[2];
-		d3 ^= p2[3];
-		d4 ^= p2[4];
-		d5 ^= p2[5];
-		d6 ^= p2[6];
-		d7 ^= p2[7];
-		d0 ^= p3[0];
-		d1 ^= p3[1];
-		d2 ^= p3[2];
-		d3 ^= p3[3];
-		d4 ^= p3[4];
-		d5 ^= p3[5];
-		d6 ^= p3[6];
-		d7 ^= p3[7];
-		d0 ^= p4[0];
-		d1 ^= p4[1];
-		d2 ^= p4[2];
-		d3 ^= p4[3];
-		d4 ^= p4[4];
-		d5 ^= p4[5];
-		d6 ^= p4[6];
-		d7 ^= p4[7];
-		d0 ^= p5[0];
-		d1 ^= p5[1];
-		d2 ^= p5[2];
-		d3 ^= p5[3];
-		d4 ^= p5[4];
-		d5 ^= p5[5];
-		d6 ^= p5[6];
-		d7 ^= p5[7];
-		p1[0] = d0;	/* Store the result (in bursts)		*/
-		p1[1] = d1;
-		p1[2] = d2;
-		p1[3] = d3;
-		p1[4] = d4;
-		p1[5] = d5;
-		p1[6] = d6;
-		p1[7] = d7;
-		p1 += 8;
-		p2 += 8;
-		p3 += 8;
-		p4 += 8;
-		p5 += 8;
-	} while (--lines > 0);
-	if (lines == 0)
-		goto once_more;
-}
-
-static struct xor_block_template xor_block_8regs = {
-	.name = "8regs",
-	.do_2 = xor_8regs_2,
-	.do_3 = xor_8regs_3,
-	.do_4 = xor_8regs_4,
-	.do_5 = xor_8regs_5,
-};
-
-static struct xor_block_template xor_block_32regs = {
-	.name = "32regs",
-	.do_2 = xor_32regs_2,
-	.do_3 = xor_32regs_3,
-	.do_4 = xor_32regs_4,
-	.do_5 = xor_32regs_5,
-};
-
-static struct xor_block_template xor_block_8regs_p __maybe_unused = {
-	.name = "8regs_prefetch",
-	.do_2 = xor_8regs_p_2,
-	.do_3 = xor_8regs_p_3,
-	.do_4 = xor_8regs_p_4,
-	.do_5 = xor_8regs_p_5,
-};
-
-static struct xor_block_template xor_block_32regs_p __maybe_unused = {
-	.name = "32regs_prefetch",
-	.do_2 = xor_32regs_p_2,
-	.do_3 = xor_32regs_p_3,
-	.do_4 = xor_32regs_p_4,
-	.do_5 = xor_32regs_p_5,
-};
+extern struct xor_block_template xor_block_8regs;
+extern struct xor_block_template xor_block_32regs;
+extern struct xor_block_template xor_block_8regs_p;
+extern struct xor_block_template xor_block_32regs_p;
diff --git a/lib/raid/xor/Makefile b/lib/raid/xor/Makefile
index 7bca0ce8e90a..89a944c9f990 100644
--- a/lib/raid/xor/Makefile
+++ b/lib/raid/xor/Makefile
@@ -3,3 +3,7 @@
 obj-$(CONFIG_XOR_BLOCKS)	+= xor.o
 
 xor-y				+= xor-core.o
+xor-y				+= xor-8regs.o
+xor-y				+= xor-32regs.o
+xor-y				+= xor-8regs-prefetch.o
+xor-y				+= xor-32regs-prefetch.o
diff --git a/lib/raid/xor/xor-32regs-prefetch.c b/lib/raid/xor/xor-32regs-prefetch.c
new file mode 100644
index 000000000000..8666c287f777
--- /dev/null
+++ b/lib/raid/xor/xor-32regs-prefetch.c
@@ -0,0 +1,268 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/prefetch.h>
+#include <linux/raid/xor_impl.h>
+#include <asm-generic/xor.h>
+
+static void
+xor_32regs_p_2(unsigned long bytes, unsigned long * __restrict p1,
+	       const unsigned long * __restrict p2)
+{
+	long lines = bytes / (sizeof (long)) / 8 - 1;
+
+	prefetchw(p1);
+	prefetch(p2);
+
+	do {
+		register long d0, d1, d2, d3, d4, d5, d6, d7;
+
+		prefetchw(p1+8);
+		prefetch(p2+8);
+ once_more:
+		d0 = p1[0];	/* Pull the stuff into registers	*/
+		d1 = p1[1];	/*  ... in bursts, if possible.		*/
+		d2 = p1[2];
+		d3 = p1[3];
+		d4 = p1[4];
+		d5 = p1[5];
+		d6 = p1[6];
+		d7 = p1[7];
+		d0 ^= p2[0];
+		d1 ^= p2[1];
+		d2 ^= p2[2];
+		d3 ^= p2[3];
+		d4 ^= p2[4];
+		d5 ^= p2[5];
+		d6 ^= p2[6];
+		d7 ^= p2[7];
+		p1[0] = d0;	/* Store the result (in bursts)		*/
+		p1[1] = d1;
+		p1[2] = d2;
+		p1[3] = d3;
+		p1[4] = d4;
+		p1[5] = d5;
+		p1[6] = d6;
+		p1[7] = d7;
+		p1 += 8;
+		p2 += 8;
+	} while (--lines > 0);
+	if (lines == 0)
+		goto once_more;
+}
+
+static void
+xor_32regs_p_3(unsigned long bytes, unsigned long * __restrict p1,
+	       const unsigned long * __restrict p2,
+	       const unsigned long * __restrict p3)
+{
+	long lines = bytes / (sizeof (long)) / 8 - 1;
+
+	prefetchw(p1);
+	prefetch(p2);
+	prefetch(p3);
+
+	do {
+		register long d0, d1, d2, d3, d4, d5, d6, d7;
+
+		prefetchw(p1+8);
+		prefetch(p2+8);
+		prefetch(p3+8);
+ once_more:
+		d0 = p1[0];	/* Pull the stuff into registers	*/
+		d1 = p1[1];	/*  ... in bursts, if possible.		*/
+		d2 = p1[2];
+		d3 = p1[3];
+		d4 = p1[4];
+		d5 = p1[5];
+		d6 = p1[6];
+		d7 = p1[7];
+		d0 ^= p2[0];
+		d1 ^= p2[1];
+		d2 ^= p2[2];
+		d3 ^= p2[3];
+		d4 ^= p2[4];
+		d5 ^= p2[5];
+		d6 ^= p2[6];
+		d7 ^= p2[7];
+		d0 ^= p3[0];
+		d1 ^= p3[1];
+		d2 ^= p3[2];
+		d3 ^= p3[3];
+		d4 ^= p3[4];
+		d5 ^= p3[5];
+		d6 ^= p3[6];
+		d7 ^= p3[7];
+		p1[0] = d0;	/* Store the result (in bursts)		*/
+		p1[1] = d1;
+		p1[2] = d2;
+		p1[3] = d3;
+		p1[4] = d4;
+		p1[5] = d5;
+		p1[6] = d6;
+		p1[7] = d7;
+		p1 += 8;
+		p2 += 8;
+		p3 += 8;
+	} while (--lines > 0);
+	if (lines == 0)
+		goto once_more;
+}
+
+static void
+xor_32regs_p_4(unsigned long bytes, unsigned long * __restrict p1,
+	       const unsigned long * __restrict p2,
+	       const unsigned long * __restrict p3,
+	       const unsigned long * __restrict p4)
+{
+	long lines = bytes / (sizeof (long)) / 8 - 1;
+
+	prefetchw(p1);
+	prefetch(p2);
+	prefetch(p3);
+	prefetch(p4);
+
+	do {
+		register long d0, d1, d2, d3, d4, d5, d6, d7;
+
+		prefetchw(p1+8);
+		prefetch(p2+8);
+		prefetch(p3+8);
+		prefetch(p4+8);
+ once_more:
+		d0 = p1[0];	/* Pull the stuff into registers	*/
+		d1 = p1[1];	/*  ... in bursts, if possible.		*/
+		d2 = p1[2];
+		d3 = p1[3];
+		d4 = p1[4];
+		d5 = p1[5];
+		d6 = p1[6];
+		d7 = p1[7];
+		d0 ^= p2[0];
+		d1 ^= p2[1];
+		d2 ^= p2[2];
+		d3 ^= p2[3];
+		d4 ^= p2[4];
+		d5 ^= p2[5];
+		d6 ^= p2[6];
+		d7 ^= p2[7];
+		d0 ^= p3[0];
+		d1 ^= p3[1];
+		d2 ^= p3[2];
+		d3 ^= p3[3];
+		d4 ^= p3[4];
+		d5 ^= p3[5];
+		d6 ^= p3[6];
+		d7 ^= p3[7];
+		d0 ^= p4[0];
+		d1 ^= p4[1];
+		d2 ^= p4[2];
+		d3 ^= p4[3];
+		d4 ^= p4[4];
+		d5 ^= p4[5];
+		d6 ^= p4[6];
+		d7 ^= p4[7];
+		p1[0] = d0;	/* Store the result (in bursts)		*/
+		p1[1] = d1;
+		p1[2] = d2;
+		p1[3] = d3;
+		p1[4] = d4;
+		p1[5] = d5;
+		p1[6] = d6;
+		p1[7] = d7;
+		p1 += 8;
+		p2 += 8;
+		p3 += 8;
+		p4 += 8;
+	} while (--lines > 0);
+	if (lines == 0)
+		goto once_more;
+}
+
+static void
+xor_32regs_p_5(unsigned long bytes, unsigned long * __restrict p1,
+	       const unsigned long * __restrict p2,
+	       const unsigned long * __restrict p3,
+	       const unsigned long * __restrict p4,
+	       const unsigned long * __restrict p5)
+{
+	long lines = bytes / (sizeof (long)) / 8 - 1;
+
+	prefetchw(p1);
+	prefetch(p2);
+	prefetch(p3);
+	prefetch(p4);
+	prefetch(p5);
+
+	do {
+		register long d0, d1, d2, d3, d4, d5, d6, d7;
+
+		prefetchw(p1+8);
+		prefetch(p2+8);
+		prefetch(p3+8);
+		prefetch(p4+8);
+		prefetch(p5+8);
+ once_more:
+		d0 = p1[0];	/* Pull the stuff into registers	*/
+		d1 = p1[1];	/*  ... in bursts, if possible.		*/
+		d2 = p1[2];
+		d3 = p1[3];
+		d4 = p1[4];
+		d5 = p1[5];
+		d6 = p1[6];
+		d7 = p1[7];
+		d0 ^= p2[0];
+		d1 ^= p2[1];
+		d2 ^= p2[2];
+		d3 ^= p2[3];
+		d4 ^= p2[4];
+		d5 ^= p2[5];
+		d6 ^= p2[6];
+		d7 ^= p2[7];
+		d0 ^= p3[0];
+		d1 ^= p3[1];
+		d2 ^= p3[2];
+		d3 ^= p3[3];
+		d4 ^= p3[4];
+		d5 ^= p3[5];
+		d6 ^= p3[6];
+		d7 ^= p3[7];
+		d0 ^= p4[0];
+		d1 ^= p4[1];
+		d2 ^= p4[2];
+		d3 ^= p4[3];
+		d4 ^= p4[4];
+		d5 ^= p4[5];
+		d6 ^= p4[6];
+		d7 ^= p4[7];
+		d0 ^= p5[0];
+		d1 ^= p5[1];
+		d2 ^= p5[2];
+		d3 ^= p5[3];
+		d4 ^= p5[4];
+		d5 ^= p5[5];
+		d6 ^= p5[6];
+		d7 ^= p5[7];
+		p1[0] = d0;	/* Store the result (in bursts)		*/
+		p1[1] = d1;
+		p1[2] = d2;
+		p1[3] = d3;
+		p1[4] = d4;
+		p1[5] = d5;
+		p1[6] = d6;
+		p1[7] = d7;
+		p1 += 8;
+		p2 += 8;
+		p3 += 8;
+		p4 += 8;
+		p5 += 8;
+	} while (--lines > 0);
+	if (lines == 0)
+		goto once_more;
+}
+
+struct xor_block_template xor_block_32regs_p = {
+	.name = "32regs_prefetch",
+	.do_2 = xor_32regs_p_2,
+	.do_3 = xor_32regs_p_3,
+	.do_4 = xor_32regs_p_4,
+	.do_5 = xor_32regs_p_5,
+};
diff --git a/lib/raid/xor/xor-32regs.c b/lib/raid/xor/xor-32regs.c
new file mode 100644
index 000000000000..58d4fac43eb4
--- /dev/null
+++ b/lib/raid/xor/xor-32regs.c
@@ -0,0 +1,219 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/raid/xor_impl.h>
+#include <asm-generic/xor.h>
+
+static void
+xor_32regs_2(unsigned long bytes, unsigned long * __restrict p1,
+	     const unsigned long * __restrict p2)
+{
+	long lines = bytes / (sizeof (long)) / 8;
+
+	do {
+		register long d0, d1, d2, d3, d4, d5, d6, d7;
+		d0 = p1[0];	/* Pull the stuff into registers	*/
+		d1 = p1[1];	/*  ... in bursts, if possible.		*/
+		d2 = p1[2];
+		d3 = p1[3];
+		d4 = p1[4];
+		d5 = p1[5];
+		d6 = p1[6];
+		d7 = p1[7];
+		d0 ^= p2[0];
+		d1 ^= p2[1];
+		d2 ^= p2[2];
+		d3 ^= p2[3];
+		d4 ^= p2[4];
+		d5 ^= p2[5];
+		d6 ^= p2[6];
+		d7 ^= p2[7];
+		p1[0] = d0;	/* Store the result (in bursts)		*/
+		p1[1] = d1;
+		p1[2] = d2;
+		p1[3] = d3;
+		p1[4] = d4;
+		p1[5] = d5;
+		p1[6] = d6;
+		p1[7] = d7;
+		p1 += 8;
+		p2 += 8;
+	} while (--lines > 0);
+}
+
+static void
+xor_32regs_3(unsigned long bytes, unsigned long * __restrict p1,
+	     const unsigned long * __restrict p2,
+	     const unsigned long * __restrict p3)
+{
+	long lines = bytes / (sizeof (long)) / 8;
+
+	do {
+		register long d0, d1, d2, d3, d4, d5, d6, d7;
+		d0 = p1[0];	/* Pull the stuff into registers	*/
+		d1 = p1[1];	/*  ... in bursts, if possible.		*/
+		d2 = p1[2];
+		d3 = p1[3];
+		d4 = p1[4];
+		d5 = p1[5];
+		d6 = p1[6];
+		d7 = p1[7];
+		d0 ^= p2[0];
+		d1 ^= p2[1];
+		d2 ^= p2[2];
+		d3 ^= p2[3];
+		d4 ^= p2[4];
+		d5 ^= p2[5];
+		d6 ^= p2[6];
+		d7 ^= p2[7];
+		d0 ^= p3[0];
+		d1 ^= p3[1];
+		d2 ^= p3[2];
+		d3 ^= p3[3];
+		d4 ^= p3[4];
+		d5 ^= p3[5];
+		d6 ^= p3[6];
+		d7 ^= p3[7];
+		p1[0] = d0;	/* Store the result (in bursts)		*/
+		p1[1] = d1;
+		p1[2] = d2;
+		p1[3] = d3;
+		p1[4] = d4;
+		p1[5] = d5;
+		p1[6] = d6;
+		p1[7] = d7;
+		p1 += 8;
+		p2 += 8;
+		p3 += 8;
+	} while (--lines > 0);
+}
+
+static void
+xor_32regs_4(unsigned long bytes, unsigned long * __restrict p1,
+	     const unsigned long * __restrict p2,
+	     const unsigned long * __restrict p3,
+	     const unsigned long * __restrict p4)
+{
+	long lines = bytes / (sizeof (long)) / 8;
+
+	do {
+		register long d0, d1, d2, d3, d4, d5, d6, d7;
+		d0 = p1[0];	/* Pull the stuff into registers	*/
+		d1 = p1[1];	/*  ... in bursts, if possible.		*/
+		d2 = p1[2];
+		d3 = p1[3];
+		d4 = p1[4];
+		d5 = p1[5];
+		d6 = p1[6];
+		d7 = p1[7];
+		d0 ^= p2[0];
+		d1 ^= p2[1];
+		d2 ^= p2[2];
+		d3 ^= p2[3];
+		d4 ^= p2[4];
+		d5 ^= p2[5];
+		d6 ^= p2[6];
+		d7 ^= p2[7];
+		d0 ^= p3[0];
+		d1 ^= p3[1];
+		d2 ^= p3[2];
+		d3 ^= p3[3];
+		d4 ^= p3[4];
+		d5 ^= p3[5];
+		d6 ^= p3[6];
+		d7 ^= p3[7];
+		d0 ^= p4[0];
+		d1 ^= p4[1];
+		d2 ^= p4[2];
+		d3 ^= p4[3];
+		d4 ^= p4[4];
+		d5 ^= p4[5];
+		d6 ^= p4[6];
+		d7 ^= p4[7];
+		p1[0] = d0;	/* Store the result (in bursts)		*/
+		p1[1] = d1;
+		p1[2] = d2;
+		p1[3] = d3;
+		p1[4] = d4;
+		p1[5] = d5;
+		p1[6] = d6;
+		p1[7] = d7;
+		p1 += 8;
+		p2 += 8;
+		p3 += 8;
+		p4 += 8;
+	} while (--lines > 0);
+}
+
+static void
+xor_32regs_5(unsigned long bytes, unsigned long * __restrict p1,
+	     const unsigned long * __restrict p2,
+	     const unsigned long * __restrict p3,
+	     const unsigned long * __restrict p4,
+	     const unsigned long * __restrict p5)
+{
+	long lines = bytes / (sizeof (long)) / 8;
+
+	do {
+		register long d0, d1, d2, d3, d4, d5, d6, d7;
+		d0 = p1[0];	/* Pull the stuff into registers	*/
+		d1 = p1[1];	/*  ... in bursts, if possible.		*/
+		d2 = p1[2];
+		d3 = p1[3];
+		d4 = p1[4];
+		d5 = p1[5];
+		d6 = p1[6];
+		d7 = p1[7];
+		d0 ^= p2[0];
+		d1 ^= p2[1];
+		d2 ^= p2[2];
+		d3 ^= p2[3];
+		d4 ^= p2[4];
+		d5 ^= p2[5];
+		d6 ^= p2[6];
+		d7 ^= p2[7];
+		d0 ^= p3[0];
+		d1 ^= p3[1];
+		d2 ^= p3[2];
+		d3 ^= p3[3];
+		d4 ^= p3[4];
+		d5 ^= p3[5];
+		d6 ^= p3[6];
+		d7 ^= p3[7];
+		d0 ^= p4[0];
+		d1 ^= p4[1];
+		d2 ^= p4[2];
+		d3 ^= p4[3];
+		d4 ^= p4[4];
+		d5 ^= p4[5];
+		d6 ^= p4[6];
+		d7 ^= p4[7];
+		d0 ^= p5[0];
+		d1 ^= p5[1];
+		d2 ^= p5[2];
+		d3 ^= p5[3];
+		d4 ^= p5[4];
+		d5 ^= p5[5];
+		d6 ^= p5[6];
+		d7 ^= p5[7];
+		p1[0] = d0;	/* Store the result (in bursts)		*/
+		p1[1] = d1;
+		p1[2] = d2;
+		p1[3] = d3;
+		p1[4] = d4;
+		p1[5] = d5;
+		p1[6] = d6;
+		p1[7] = d7;
+		p1 += 8;
+		p2 += 8;
+		p3 += 8;
+		p4 += 8;
+		p5 += 8;
+	} while (--lines > 0);
+}
+
+struct xor_block_template xor_block_32regs = {
+	.name = "32regs",
+	.do_2 = xor_32regs_2,
+	.do_3 = xor_32regs_3,
+	.do_4 = xor_32regs_4,
+	.do_5 = xor_32regs_5,
+};
diff --git a/lib/raid/xor/xor-8regs-prefetch.c b/lib/raid/xor/xor-8regs-prefetch.c
new file mode 100644
index 000000000000..67061e35a0a6
--- /dev/null
+++ b/lib/raid/xor/xor-8regs-prefetch.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/prefetch.h>
+#include <linux/raid/xor_impl.h>
+#include <asm-generic/xor.h>
+
+static void
+xor_8regs_p_2(unsigned long bytes, unsigned long * __restrict p1,
+	      const unsigned long * __restrict p2)
+{
+	long lines = bytes / (sizeof (long)) / 8 - 1;
+	prefetchw(p1);
+	prefetch(p2);
+
+	do {
+		prefetchw(p1+8);
+		prefetch(p2+8);
+ once_more:
+		p1[0] ^= p2[0];
+		p1[1] ^= p2[1];
+		p1[2] ^= p2[2];
+		p1[3] ^= p2[3];
+		p1[4] ^= p2[4];
+		p1[5] ^= p2[5];
+		p1[6] ^= p2[6];
+		p1[7] ^= p2[7];
+		p1 += 8;
+		p2 += 8;
+	} while (--lines > 0);
+	if (lines == 0)
+		goto once_more;
+}
+
+static void
+xor_8regs_p_3(unsigned long bytes, unsigned long * __restrict p1,
+	      const unsigned long * __restrict p2,
+	      const unsigned long * __restrict p3)
+{
+	long lines = bytes / (sizeof (long)) / 8 - 1;
+	prefetchw(p1);
+	prefetch(p2);
+	prefetch(p3);
+
+	do {
+		prefetchw(p1+8);
+		prefetch(p2+8);
+		prefetch(p3+8);
+ once_more:
+		p1[0] ^= p2[0] ^ p3[0];
+		p1[1] ^= p2[1] ^ p3[1];
+		p1[2] ^= p2[2] ^ p3[2];
+		p1[3] ^= p2[3] ^ p3[3];
+		p1[4] ^= p2[4] ^ p3[4];
+		p1[5] ^= p2[5] ^ p3[5];
+		p1[6] ^= p2[6] ^ p3[6];
+		p1[7] ^= p2[7] ^ p3[7];
+		p1 += 8;
+		p2 += 8;
+		p3 += 8;
+	} while (--lines > 0);
+	if (lines == 0)
+		goto once_more;
+}
+
+static void
+xor_8regs_p_4(unsigned long bytes, unsigned long * __restrict p1,
+	      const unsigned long * __restrict p2,
+	      const unsigned long * __restrict p3,
+	      const unsigned long * __restrict p4)
+{
+	long lines = bytes / (sizeof (long)) / 8 - 1;
+
+	prefetchw(p1);
+	prefetch(p2);
+	prefetch(p3);
+	prefetch(p4);
+
+	do {
+		prefetchw(p1+8);
+		prefetch(p2+8);
+		prefetch(p3+8);
+		prefetch(p4+8);
+ once_more:
+		p1[0] ^= p2[0] ^ p3[0] ^ p4[0];
+		p1[1] ^= p2[1] ^ p3[1] ^ p4[1];
+		p1[2] ^= p2[2] ^ p3[2] ^ p4[2];
+		p1[3] ^= p2[3] ^ p3[3] ^ p4[3];
+		p1[4] ^= p2[4] ^ p3[4] ^ p4[4];
+		p1[5] ^= p2[5] ^ p3[5] ^ p4[5];
+		p1[6] ^= p2[6] ^ p3[6] ^ p4[6];
+		p1[7] ^= p2[7] ^ p3[7] ^ p4[7];
+		p1 += 8;
+		p2 += 8;
+		p3 += 8;
+		p4 += 8;
+	} while (--lines > 0);
+	if (lines == 0)
+		goto once_more;
+}
+
+static void
+xor_8regs_p_5(unsigned long bytes, unsigned long * __restrict p1,
+	      const unsigned long * __restrict p2,
+	      const unsigned long * __restrict p3,
+	      const unsigned long * __restrict p4,
+	      const unsigned long * __restrict p5)
+{
+	long lines = bytes / (sizeof (long)) / 8 - 1;
+
+	prefetchw(p1);
+	prefetch(p2);
+	prefetch(p3);
+	prefetch(p4);
+	prefetch(p5);
+
+	do {
+		prefetchw(p1+8);
+		prefetch(p2+8);
+		prefetch(p3+8);
+		prefetch(p4+8);
+		prefetch(p5+8);
+ once_more:
+		p1[0] ^= p2[0] ^ p3[0] ^ p4[0] ^ p5[0];
+		p1[1] ^= p2[1] ^ p3[1] ^ p4[1] ^ p5[1];
+		p1[2] ^= p2[2] ^ p3[2] ^ p4[2] ^ p5[2];
+		p1[3] ^= p2[3] ^ p3[3] ^ p4[3] ^ p5[3];
+		p1[4] ^= p2[4] ^ p3[4] ^ p4[4] ^ p5[4];
+		p1[5] ^= p2[5] ^ p3[5] ^ p4[5] ^ p5[5];
+		p1[6] ^= p2[6] ^ p3[6] ^ p4[6] ^ p5[6];
+		p1[7] ^= p2[7] ^ p3[7] ^ p4[7] ^ p5[7];
+		p1 += 8;
+		p2 += 8;
+		p3 += 8;
+		p4 += 8;
+		p5 += 8;
+	} while (--lines > 0);
+	if (lines == 0)
+		goto once_more;
+}
+
+struct xor_block_template xor_block_8regs_p = {
+	.name = "8regs_prefetch",
+	.do_2 = xor_8regs_p_2,
+	.do_3 = xor_8regs_p_3,
+	.do_4 = xor_8regs_p_4,
+	.do_5 = xor_8regs_p_5,
+};
diff --git a/lib/raid/xor/xor-8regs.c b/lib/raid/xor/xor-8regs.c
new file mode 100644
index 000000000000..769f796ab2cf
--- /dev/null
+++ b/lib/raid/xor/xor-8regs.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/raid/xor_impl.h>
+#include <asm-generic/xor.h>
+
+static void
+xor_8regs_2(unsigned long bytes, unsigned long * __restrict p1,
+	    const unsigned long * __restrict p2)
+{
+	long lines = bytes / (sizeof (long)) / 8;
+
+	do {
+		p1[0] ^= p2[0];
+		p1[1] ^= p2[1];
+		p1[2] ^= p2[2];
+		p1[3] ^= p2[3];
+		p1[4] ^= p2[4];
+		p1[5] ^= p2[5];
+		p1[6] ^= p2[6];
+		p1[7] ^= p2[7];
+		p1 += 8;
+		p2 += 8;
+	} while (--lines > 0);
+}
+
+static void
+xor_8regs_3(unsigned long bytes, unsigned long * __restrict p1,
+	    const unsigned long * __restrict p2,
+	    const unsigned long * __restrict p3)
+{
+	long lines = bytes / (sizeof (long)) / 8;
+
+	do {
+		p1[0] ^= p2[0] ^ p3[0];
+		p1[1] ^= p2[1] ^ p3[1];
+		p1[2] ^= p2[2] ^ p3[2];
+		p1[3] ^= p2[3] ^ p3[3];
+		p1[4] ^= p2[4] ^ p3[4];
+		p1[5] ^= p2[5] ^ p3[5];
+		p1[6] ^= p2[6] ^ p3[6];
+		p1[7] ^= p2[7] ^ p3[7];
+		p1 += 8;
+		p2 += 8;
+		p3 += 8;
+	} while (--lines > 0);
+}
+
+static void
+xor_8regs_4(unsigned long bytes, unsigned long * __restrict p1,
+	    const unsigned long * __restrict p2,
+	    const unsigned long * __restrict p3,
+	    const unsigned long * __restrict p4)
+{
+	long lines = bytes / (sizeof (long)) / 8;
+
+	do {
+		p1[0] ^= p2[0] ^ p3[0] ^ p4[0];
+		p1[1] ^= p2[1] ^ p3[1] ^ p4[1];
+		p1[2] ^= p2[2] ^ p3[2] ^ p4[2];
+		p1[3] ^= p2[3] ^ p3[3] ^ p4[3];
+		p1[4] ^= p2[4] ^ p3[4] ^ p4[4];
+		p1[5] ^= p2[5] ^ p3[5] ^ p4[5];
+		p1[6] ^= p2[6] ^ p3[6] ^ p4[6];
+		p1[7] ^= p2[7] ^ p3[7] ^ p4[7];
+		p1 += 8;
+		p2 += 8;
+		p3 += 8;
+		p4 += 8;
+	} while (--lines > 0);
+}
+
+static void
+xor_8regs_5(unsigned long bytes, unsigned long * __restrict p1,
+	    const unsigned long * __restrict p2,
+	    const unsigned long * __restrict p3,
+	    const unsigned long * __restrict p4,
+	    const unsigned long * __restrict p5)
+{
+	long lines = bytes / (sizeof (long)) / 8;
+
+	do {
+		p1[0] ^= p2[0] ^ p3[0] ^ p4[0] ^ p5[0];
+		p1[1] ^= p2[1] ^ p3[1] ^ p4[1] ^ p5[1];
+		p1[2] ^= p2[2] ^ p3[2] ^ p4[2] ^ p5[2];
+		p1[3] ^= p2[3] ^ p3[3] ^ p4[3] ^ p5[3];
+		p1[4] ^= p2[4] ^ p3[4] ^ p4[4] ^ p5[4];
+		p1[5] ^= p2[5] ^ p3[5] ^ p4[5] ^ p5[5];
+		p1[6] ^= p2[6] ^ p3[6] ^ p4[6] ^ p5[6];
+		p1[7] ^= p2[7] ^ p3[7] ^ p4[7] ^ p5[7];
+		p1 += 8;
+		p2 += 8;
+		p3 += 8;
+		p4 += 8;
+		p5 += 8;
+	} while (--lines > 0);
+}
+
+#ifndef NO_TEMPLATE
+struct xor_block_template xor_block_8regs = {
+	.name = "8regs",
+	.do_2 = xor_8regs_2,
+	.do_3 = xor_8regs_3,
+	.do_4 = xor_8regs_4,
+	.do_5 = xor_8regs_5,
+};
+#endif /* NO_TEMPLATE */
-- 
2.47.3

