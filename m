Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8821230B525;
	Wed, 11 Mar 2026 07:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773212716; cv=none; b=dxEARdW3ycaizUnA81TC/Wpou4iAQs0sCyfMNFDMZAVVtIZCKSxjqZChFGnwp1oBLq6ASYGSSpMqBkM8hBiuMLWX5+gCthe0w+rZMKAonwoDrPwJQLEvQ4LBqYqQrYUyURxNHFDyY1+bOhNq9r3DM9XQ70Csta5UFS99dWXkihE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773212716; c=relaxed/simple;
	bh=EJHbkVk02Zxov++6Dbrdb9PCSkVIIYHMlYnGkZk91dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpVWQYdWtS4yG4mSS6PLDyVaQ/131ZxcaGwGyGEuPLy428ZC+7qxylSVrnnpNwuWibdiULMoGwIPqGlTDsOgGYh8JZdg+FadGpavcyhxosIzGAwNlr/rlaXTLMEVLNjiNFa7BC7umo0bIFRiUWTL3Th6YbR4tJ9erOdQ9I330b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3NWptu+0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3NWptu+0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5Q4WO2fmqU3XVJCOHArp4PLeLItyndyIBgJVZQfhExI=; b=3NWptu+0INfjN+SogdzPM3UFBP
	5DdlJB4X5/GBdbRZdyRmqgQlGSWSm8g/JV9zX+PCHogr0tZRN8EfqYzBDNhmMVyyGbtAzfdRlSwvW
	L8tVZZ3ViJmRecg4hZX6cJFrnsExhb1VgZklwyCd8Hj0VAWQGMkNAuXqhjIT262n6fU/74AtbtGml
	2NeDewfBK4hjddNiDh4Q6Q3aG9q6tJDm6cerU9HIC2HXvF6Af787VRfI8gvEP2yR5nqVf2vSgWhn+
	ikFmX0ppbkUUsjrcpR+AOZ7OUV7Mra33j1vAZKYRMDAEcA+N0YsmKP/dQuw5+Up1W+Ihs+JcSgBce
	8bPqrQ5g==;
Received: from [212.243.42.10] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0Dck-0000000AyAL-1e59;
	Wed, 11 Mar 2026 07:04:54 +0000
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
Subject: [PATCH 02/27] arm/xor: remove in_interrupt() handling
Date: Wed, 11 Mar 2026 08:03:34 +0100
Message-ID: <20260311070416.972667-3-hch@lst.de>
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

xor_blocks can't be called from interrupt context, so remove the
handling for that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/arm/include/asm/xor.h | 41 +++++++++++---------------------------
 1 file changed, 12 insertions(+), 29 deletions(-)

diff --git a/arch/arm/include/asm/xor.h b/arch/arm/include/asm/xor.h
index 934b549905f5..bca2a6514746 100644
--- a/arch/arm/include/asm/xor.h
+++ b/arch/arm/include/asm/xor.h
@@ -4,7 +4,6 @@
  *
  *  Copyright (C) 2001 Russell King
  */
-#include <linux/hardirq.h>
 #include <asm-generic/xor.h>
 #include <asm/hwcap.h>
 #include <asm/neon.h>
@@ -156,13 +155,9 @@ static void
 xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
 	   const unsigned long * __restrict p2)
 {
-	if (in_interrupt()) {
-		xor_arm4regs_2(bytes, p1, p2);
-	} else {
-		kernel_neon_begin();
-		xor_block_neon_inner.do_2(bytes, p1, p2);
-		kernel_neon_end();
-	}
+	kernel_neon_begin();
+	xor_block_neon_inner.do_2(bytes, p1, p2);
+	kernel_neon_end();
 }
 
 static void
@@ -170,13 +165,9 @@ xor_neon_3(unsigned long bytes, unsigned long * __restrict p1,
 	   const unsigned long * __restrict p2,
 	   const unsigned long * __restrict p3)
 {
-	if (in_interrupt()) {
-		xor_arm4regs_3(bytes, p1, p2, p3);
-	} else {
-		kernel_neon_begin();
-		xor_block_neon_inner.do_3(bytes, p1, p2, p3);
-		kernel_neon_end();
-	}
+	kernel_neon_begin();
+	xor_block_neon_inner.do_3(bytes, p1, p2, p3);
+	kernel_neon_end();
 }
 
 static void
@@ -185,13 +176,9 @@ xor_neon_4(unsigned long bytes, unsigned long * __restrict p1,
 	   const unsigned long * __restrict p3,
 	   const unsigned long * __restrict p4)
 {
-	if (in_interrupt()) {
-		xor_arm4regs_4(bytes, p1, p2, p3, p4);
-	} else {
-		kernel_neon_begin();
-		xor_block_neon_inner.do_4(bytes, p1, p2, p3, p4);
-		kernel_neon_end();
-	}
+	kernel_neon_begin();
+	xor_block_neon_inner.do_4(bytes, p1, p2, p3, p4);
+	kernel_neon_end();
 }
 
 static void
@@ -201,13 +188,9 @@ xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
 	   const unsigned long * __restrict p4,
 	   const unsigned long * __restrict p5)
 {
-	if (in_interrupt()) {
-		xor_arm4regs_5(bytes, p1, p2, p3, p4, p5);
-	} else {
-		kernel_neon_begin();
-		xor_block_neon_inner.do_5(bytes, p1, p2, p3, p4, p5);
-		kernel_neon_end();
-	}
+	kernel_neon_begin();
+	xor_block_neon_inner.do_5(bytes, p1, p2, p3, p4, p5);
+	kernel_neon_end();
 }
 
 static struct xor_block_template xor_block_neon = {
-- 
2.47.3

