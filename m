Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1153A7F6C;
	Fri, 27 Mar 2026 06:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592630; cv=none; b=sIiI9jYAK43zVEci/nzqnmZbFz66W8bqrHqY58OeEAQckoeiWtROwSDz0l9f8I/evPU9knsU4lmEidUdWUvHo+gN43ONh+Ie+2Q8Zxs4+b6UvYOBcqst/+6UIgxut2xNHIPqgop6Pg28AveqwmnGupWuz6CHjYOeeN+E+lYKjWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592630; c=relaxed/simple;
	bh=T78+0GNbmPLnTNrMBAs1W2fFBF5QBqGty/2MKyQM950=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlUrPAeIZb2FOaz78JPJBauvg1w2U1AUpByM7bUBeHnaJ3V+ATuZCuDIBomZPDrZxRseyVKrEPzq9YuVCF3gZcG2C4RpvsbV4j030+gjuO4CrHxweI+s/KSpTaIhKQ1W+FkZ/9NIj8lncp3lfdnCz1jK71bUynnkLvVAvGvfWWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B79nu8vZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B79nu8vZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/eIr9wIIm6iGlYV1kRtLFx5UsBKOxZ4VNuwt7IPsmcE=; b=B79nu8vZV/CSonC7sqH0z/OKAl
	/edR6ukNRR9e2OXsqxy0hAnd5awCq7NvJwVK47ZKrEiivroyi32XYu/5O7DE3UVV+WHCNSS21upsn
	EIXvxSssYk7zka1I4NceFAoBnl09Knq/JdUYOBMvS5imNReaFZVqF+mv5nV5Ire0iaK4aU/FoGjBS
	gQSw3TnFArvcWd/YcTPub9h8vqlqP3T9T9lLgNPj6HzbaS4/yGeqaATp/M0uxw1Lj/MkY8Am7Xwcf
	xRlX2Ud6W+b75r2z7YD9t8zysNMUf9FFMQRTNUgMpGapVKo9FFHAg0we3BXkJFwBw2HyU89gxIW3g
	n4l5zDjg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60bS-00000006oEd-09fn;
	Fri, 27 Mar 2026 06:23:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
Subject: [PATCH 27/28] xor: use static_call for xor_gen
Date: Fri, 27 Mar 2026 07:16:59 +0100
Message-ID: <20260327061704.3707577-28-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327061704.3707577-1-hch@lst.de>
References: <20260327061704.3707577-1-hch@lst.de>
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
 lib/raid/xor/xor-core.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
index 9e043d8c3a7a..bd4e6e434418 100644
--- a/lib/raid/xor/xor-core.c
+++ b/lib/raid/xor/xor-core.c
@@ -11,10 +11,10 @@
 #include <linux/raid/xor.h>
 #include <linux/jiffies.h>
 #include <linux/preempt.h>
+#include <linux/static_call.h>
 #include "xor_impl.h"
 
-/* The xor routine to use.  */
-static struct xor_block_template *active_template;
+DEFINE_STATIC_CALL_NULL(xor_gen_impl, *xor_block_8regs.xor_gen);
 
 /**
  * xor_gen - generate RAID-style XOR information
@@ -37,13 +37,13 @@ void xor_gen(void *dest, void **srcs, unsigned int src_cnt, unsigned int bytes)
 	WARN_ON_ONCE(bytes == 0);
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
@@ -69,7 +69,7 @@ void __init xor_register(struct xor_block_template *tmpl)
  */
 void __init xor_force(struct xor_block_template *tmpl)
 {
-	active_template = tmpl;
+	forced_template = tmpl;
 }
 
 #define BENCH_SIZE	4096
@@ -111,7 +111,7 @@ static int __init calibrate_xor_blocks(void)
 	void *b1, *b2;
 	struct xor_block_template *f, *fastest;
 
-	if (xor_forced)
+	if (forced_template)
 		return 0;
 
 	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
@@ -128,7 +128,7 @@ static int __init calibrate_xor_blocks(void)
 		if (f->speed > fastest->speed)
 			fastest = f;
 	}
-	active_template = fastest;
+	static_call_update(xor_gen_impl, fastest->xor_gen);
 	pr_info("xor: using function: %s (%d MB/sec)\n",
 	       fastest->name, fastest->speed);
 
@@ -156,10 +156,10 @@ static int __init xor_init(void)
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
 
@@ -170,7 +170,7 @@ static int __init xor_init(void)
 	 * Pick the first template as the temporary default until calibration
 	 * happens.
 	 */
-	active_template = template_list;
+	static_call_update(xor_gen_impl, template_list->xor_gen);
 	return 0;
 #endif
 }
-- 
2.47.3

