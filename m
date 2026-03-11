Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66622395D90;
	Wed, 11 Mar 2026 07:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773213029; cv=none; b=FMYlTU0YE/CfdSuqPVg9sLGlmAYyQ/N1BhBAANg0rovkrml+keL2F3Oz+QYHSIWlMMPH7hBK6kzlA/oY7Wx6eoquwz2sO4GcDJ3mxmyWvcz60sRRZVKliywSDssoW4WUoEe2i2yb8dHelGau4i5/+NCOlnkUXmWq4FNj3NMS1CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773213029; c=relaxed/simple;
	bh=ENOfXqT+pnw+axRrQtZTY2GHoFNBZGAz5ziro2EyVt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogaCCMbVnt516BVFzSMr+VsHH5cYO6ryZWlr/dhrifft4PjTjvZ453A0VSbCvqLgVDnTHlv1FuqnFPKVd5SxC5y9tQkdCwnPBagGyRhn4G9hc19VLYXETbsqfxeyZ+vDzIAXiTYOsOVGSFm6PXAQllDkHbcIt7O8RdIIb0esKcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GlYZhzEb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GlYZhzEb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1VXN+qrgKMOjOg8SbRK828N8SoZ2yyHUM4r1hhkUxmw=; b=GlYZhzEbh6LhHJVnrDhH96xjAy
	4ZbURJQV5gyiDjoJ833W9n71QkN3q82nKNZlhhX+fwEQFTlqR/YFNmdgtN1Cqu2qllrl5OVdNWnaE
	wcxJr7OSjntuAaZKF1dYihjmO0HQ84iylqfO02VW90TfNC5Pj7zLmGAhaucVGZmAP1srCkYZZ16Nr
	idp2vnmNstxr9XsmjCbTmUpd9CB5wiE3UnQ2ZroAFAwBE9wrhwEFd1tCeK8e9HztqVb2oEjNLal/Y
	RO3QXr+3uISlAnzcs6+hXrtrsr6TGmHhe3DiEYlkLCrqHKl+bxuNSbAzRoSvRlDcPGrGQ3UhTN/xF
	bvTygKDA==;
Received: from [212.243.42.10] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0Dht-0000000B1RQ-2myS;
	Wed, 11 Mar 2026 07:10:14 +0000
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
Subject: [PATCH 25/27] xor: use static_call for xor_gen
Date: Wed, 11 Mar 2026 08:03:57 +0100
Message-ID: <20260311070416.972667-26-hch@lst.de>
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

Avoid the indirect call for xor_generation by using a static_call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/xor/xor-32regs.c |  2 +-
 lib/raid/xor/xor-core.c   | 29 ++++++++++++++---------------
 lib/raid/xor/xor_impl.h   |  4 ++++
 3 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/lib/raid/xor/xor-32regs.c b/lib/raid/xor/xor-32regs.c
index acb4a10d1e95..759a31f76414 100644
--- a/lib/raid/xor/xor-32regs.c
+++ b/lib/raid/xor/xor-32regs.c
@@ -209,7 +209,7 @@ xor_32regs_5(unsigned long bytes, unsigned long * __restrict p1,
 	} while (--lines > 0);
 }
 
-DO_XOR_BLOCKS(32regs, xor_32regs_2, xor_32regs_3, xor_32regs_4, xor_32regs_5);
+__DO_XOR_BLOCKS(32regs, xor_32regs_2, xor_32regs_3, xor_32regs_4, xor_32regs_5);
 
 struct xor_block_template xor_block_32regs = {
 	.name		= "32regs",
diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
index c3523f92ab83..331da1afc0e4 100644
--- a/lib/raid/xor/xor-core.c
+++ b/lib/raid/xor/xor-core.c
@@ -11,10 +11,14 @@
 #include <linux/raid/xor.h>
 #include <linux/jiffies.h>
 #include <linux/preempt.h>
+#include <linux/static_call.h>
 #include "xor_impl.h"
 
-/* The xor routine to use.  */
-static struct xor_block_template *active_template;
+/*
+ * Provide a temporary default until the fastest or forced implementation is
+ * picked.
+ */
+DEFINE_STATIC_CALL(xor_gen_impl, xor_gen_32regs);
 
 /**
  * xor_gen - generate RAID-style XOR information
@@ -36,13 +40,13 @@ void xor_gen(void *dest, void **srcs, unsigned int src_cnt, unsigned int bytes)
 	lockdep_assert_preemption_enabled();
 	WARN_ON_ONCE(bytes & 511);
 
-	active_template->xor_gen(dest, srcs, src_cnt, bytes);
+	static_call(xor_gen_impl)(dest, srcs, src_cnt, bytes);
 }
 EXPORT_SYMBOL(xor_gen);
 
 /* Set of all registered templates.  */
 static struct xor_block_template *__initdata template_list;
-static bool __initdata xor_forced = false;
+static struct xor_block_template *forced_template;
 
 /**
  * xor_register - register a XOR template
@@ -68,7 +72,7 @@ void __init xor_register(struct xor_block_template *tmpl)
  */
 void __init xor_force(struct xor_block_template *tmpl)
 {
-	active_template = tmpl;
+	forced_template = tmpl;
 }
 
 #define BENCH_SIZE	4096
@@ -110,7 +114,7 @@ static int __init calibrate_xor_blocks(void)
 	void *b1, *b2;
 	struct xor_block_template *f, *fastest;
 
-	if (xor_forced)
+	if (forced_template)
 		return 0;
 
 	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
@@ -127,7 +131,7 @@ static int __init calibrate_xor_blocks(void)
 		if (f->speed > fastest->speed)
 			fastest = f;
 	}
-	active_template = fastest;
+	static_call_update(xor_gen_impl, fastest->xor_gen);
 	pr_info("xor: using function: %s (%d MB/sec)\n",
 	       fastest->name, fastest->speed);
 
@@ -155,21 +159,16 @@ static int __init xor_init(void)
 	 * If this arch/cpu has a short-circuited selection, don't loop through
 	 * all the possible functions, just use the best one.
 	 */
-	if (active_template) {
+	if (forced_template) {
 		pr_info("xor: automatically using best checksumming function   %-10s\n",
-			active_template->name);
-		xor_forced = true;
+			forced_template->name);
+		static_call_update(xor_gen_impl, forced_template->xor_gen);
 		return 0;
 	}
 
 #ifdef MODULE
 	return calibrate_xor_blocks();
 #else
-	/*
-	 * Pick the first template as the temporary default until calibration
-	 * happens.
-	 */
-	active_template = template_list;
 	return 0;
 #endif
 }
diff --git a/lib/raid/xor/xor_impl.h b/lib/raid/xor/xor_impl.h
index 09ae2916f71e..59c801777219 100644
--- a/lib/raid/xor/xor_impl.h
+++ b/lib/raid/xor/xor_impl.h
@@ -50,6 +50,10 @@ extern struct xor_block_template xor_block_32regs;
 extern struct xor_block_template xor_block_8regs_p;
 extern struct xor_block_template xor_block_32regs_p;
 
+/* default call until updated */
+void xor_gen_32regs(void *dest, void **srcs, unsigned int src_cnt,
+		unsigned int bytes);
+
 void __init xor_register(struct xor_block_template *tmpl);
 void __init xor_force(struct xor_block_template *tmpl);
 
-- 
2.47.3

