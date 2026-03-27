Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A2F37F009;
	Fri, 27 Mar 2026 06:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592396; cv=none; b=TCXRb7nUSuINadXgBHs/9uJDwFWn51PmIyVNJJP08zMoEzAQHZD8dXr/WujO+gx8r6Rxl+7rySD6K7kr5A+emW0H8EVSIiCJaCOVxkZHUfiwE+gxwe6BLw10R/zqcS84/R5w3HPrWUsNucs2XTHxLsvFzF/C80GYIJ/+lJZRn9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592396; c=relaxed/simple;
	bh=DTJ32nJRuvLsoD7EPPRYriqNKPMsrwImpNIexHED7r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7RvyQ2N+nE2jUGsAX0FF1xniopwPcBdecoPSLSIN0fXNfT6gVQlUr0Lco5Hr5tDIE5MmvGJcJFgjDI7Q+d3rnjlZpmmCR9NoKTF9/Fz9wFxfk9bXi0U63wF2/JNyq6BAy1p4EatUUipJsS33nhLna5hoT5XibM74Ry8LRa7tdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yfEkCSHT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yfEkCSHT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zgZY5gyqgBp4tTU2Jxd3jfKktDHbBXxS4d4BaNz441Q=; b=yfEkCSHTfbfsn1TRlEEjIzQ671
	fmhW9TrRTbbNWW34B1vT8HHQwt0Mmf+h8UelpWfN14UEk/zNIZ/KYci0hy4yXbjJqBnnszm05OFE0
	Wu+BMvbSQhpya8AK/Wr4HTZjEH9bOEN9A2hNq3oeKH9S3bLUvqCy9yrtrdWEXdUkiju072eK58638
	8etpGdUZxepINIklmgyJJSubCenFljSmazSGOprSr3JdOYRQxBPBdpEJ6DZwrsjb8CC72D9NWar/O
	sfEtzCe+AtxFJ14atSNRYlUj9sv+OQsyqBc5ZKkmMYF0qNHMSiAoWQAQ4tStDGxzMsu1oX7wMSnIK
	GN62Az/Q==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60Xf-00000006lQY-1pyV;
	Fri, 27 Mar 2026 06:19:35 +0000
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
Subject: [PATCH 08/28] xor: split xor.h
Date: Fri, 27 Mar 2026 07:16:40 +0100
Message-ID: <20260327061704.3707577-9-hch@lst.de>
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

Keep xor.h for the public API, and split the struct xor_block_template
definition that is only needed by the xor.ko core and
architecture-specific optimizations into a separate xor_impl.h header.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/arm/lib/xor-neon.c       |  1 +
 arch/arm64/lib/xor-neon.c     |  1 +
 arch/s390/lib/xor.c           |  2 +-
 include/linux/raid/xor.h      | 22 +---------------------
 include/linux/raid/xor_impl.h | 25 +++++++++++++++++++++++++
 lib/raid/xor/xor-core.c       |  1 +
 6 files changed, 30 insertions(+), 22 deletions(-)
 create mode 100644 include/linux/raid/xor_impl.h

diff --git a/arch/arm/lib/xor-neon.c b/arch/arm/lib/xor-neon.c
index cf57fca97908..282980b9bf2a 100644
--- a/arch/arm/lib/xor-neon.c
+++ b/arch/arm/lib/xor-neon.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/raid/xor.h>
+#include <linux/raid/xor_impl.h>
 #include <linux/module.h>
 
 MODULE_DESCRIPTION("NEON accelerated XOR implementation");
diff --git a/arch/arm64/lib/xor-neon.c b/arch/arm64/lib/xor-neon.c
index 8fffebfa17b2..351aba92d932 100644
--- a/arch/arm64/lib/xor-neon.c
+++ b/arch/arm64/lib/xor-neon.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/raid/xor.h>
+#include <linux/raid/xor_impl.h>
 #include <linux/module.h>
 #include <asm/neon-intrinsics.h>
 
diff --git a/arch/s390/lib/xor.c b/arch/s390/lib/xor.c
index 5363e4c2462d..3bbe21b40e66 100644
--- a/arch/s390/lib/xor.c
+++ b/arch/s390/lib/xor.c
@@ -8,7 +8,7 @@
 
 #include <linux/types.h>
 #include <linux/export.h>
-#include <linux/raid/xor.h>
+#include <linux/raid/xor_impl.h>
 #include <asm/xor.h>
 
 static void xor_xc_2(unsigned long bytes, unsigned long * __restrict p1,
diff --git a/include/linux/raid/xor.h b/include/linux/raid/xor.h
index 51b811b62322..02bda8d99534 100644
--- a/include/linux/raid/xor.h
+++ b/include/linux/raid/xor.h
@@ -7,24 +7,4 @@
 extern void xor_blocks(unsigned int count, unsigned int bytes,
 	void *dest, void **srcs);
 
-struct xor_block_template {
-        struct xor_block_template *next;
-        const char *name;
-        int speed;
-	void (*do_2)(unsigned long, unsigned long * __restrict,
-		     const unsigned long * __restrict);
-	void (*do_3)(unsigned long, unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict);
-	void (*do_4)(unsigned long, unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict);
-	void (*do_5)(unsigned long, unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict);
-};
-
-#endif
+#endif /* _XOR_H */
diff --git a/include/linux/raid/xor_impl.h b/include/linux/raid/xor_impl.h
new file mode 100644
index 000000000000..a1890cd66812
--- /dev/null
+++ b/include/linux/raid/xor_impl.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _XOR_IMPL_H
+#define _XOR_IMPL_H
+
+struct xor_block_template {
+	struct xor_block_template *next;
+	const char *name;
+	int speed;
+	void (*do_2)(unsigned long, unsigned long * __restrict,
+		     const unsigned long * __restrict);
+	void (*do_3)(unsigned long, unsigned long * __restrict,
+		     const unsigned long * __restrict,
+		     const unsigned long * __restrict);
+	void (*do_4)(unsigned long, unsigned long * __restrict,
+		     const unsigned long * __restrict,
+		     const unsigned long * __restrict,
+		     const unsigned long * __restrict);
+	void (*do_5)(unsigned long, unsigned long * __restrict,
+		     const unsigned long * __restrict,
+		     const unsigned long * __restrict,
+		     const unsigned long * __restrict,
+		     const unsigned long * __restrict);
+};
+
+#endif /* _XOR_IMPL_H */
diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
index e6e593e404fb..db1824011a12 100644
--- a/lib/raid/xor/xor-core.c
+++ b/lib/raid/xor/xor-core.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/gfp.h>
 #include <linux/raid/xor.h>
+#include <linux/raid/xor_impl.h>
 #include <linux/jiffies.h>
 #include <linux/preempt.h>
 #include <asm/xor.h>
-- 
2.47.3

