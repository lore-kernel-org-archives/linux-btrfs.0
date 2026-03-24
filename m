Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C7E3B2FE1;
	Tue, 24 Mar 2026 06:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774333632; cv=none; b=NgstVzzMZH0OYaun+tqEkq591+OezAoOG27ea0Ik3Kf3i0g1ba+zuse8FTOF8bM/DPItZpkCMZEOmZABKytXfcCkUcDUMNwb0LwKx7RvJxC2lcW6u048sXglygWUZYZ6SChd77yjzxeBkWp4/jXTb2lV92rOAiIOX51aC/KzFx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774333632; c=relaxed/simple;
	bh=nJ2rxySeoh30TsknozdREkCKulH5cCRIYpRQkGkWMJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gl71+oQxQ6QL3kCiI2kqT1VIx5Zr/UyDhfkliiAzWYMGom+ovl14AXUqvr90KLkJmZYgdvOYkwBxv0Catso4/4ZouBl3laLE/9e2oyq9Xg2kq4RtiFHDMipf7BRuR/c3+QJokCH5ebt9kXRBpqLf567vubRV4jhp8xcVy0wpl3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1vdv1rhH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1vdv1rhH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LPpvndNjqPvjZburtt7bAObV12ltu7OwMomHBwz06KI=; b=1vdv1rhHmRWau5LknifdJXERn7
	zHCD2NU6WPQcRZ+3d3EvREWEZLBewIC/EnMQfpax/ypZjLMgIHbMA+ABokhQq7ToalZMREiC3/Gv4
	cMwMsG4FAZ2+31hSkGbrlHeCH0vnNM1ixkVxdxefBnvEJ7kx51GWulILkN+3eJ+oXRz3CMthGdOYE
	jKmFjK6CPXprcGKf4C5mkeRvn0r4HUFXRaO6CDnjZQ7oj1KBy89rtUwKkvZhXUa9usartoWG00Mwp
	hXIOXn6Xs8RIeaAs2xvFSX/gSbwcHVJ2Ozv2z2DapC57ZVSKkbSF69emQjEtygIJ6h+5KoR7/3Jp4
	uc8dWByA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4vE9-00000000jRm-3ojI;
	Tue, 24 Mar 2026 06:26:58 +0000
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
Subject: [PATCH 22/26] async_xor: use xor_gen
Date: Tue, 24 Mar 2026 07:21:58 +0100
Message-ID: <20260324062211.3216301-23-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324062211.3216301-1-hch@lst.de>
References: <20260324062211.3216301-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Replace use of the loop around xor_blocks with the easier to use xor_gen
API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 crypto/async_tx/async_xor.c | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 2c499654a36c..84458375b202 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -103,7 +103,6 @@ do_sync_xor_offs(struct page *dest, unsigned int offset,
 {
 	int i;
 	int xor_src_cnt = 0;
-	int src_off = 0;
 	void *dest_buf;
 	void **srcs;
 
@@ -117,23 +116,12 @@ do_sync_xor_offs(struct page *dest, unsigned int offset,
 		if (src_list[i])
 			srcs[xor_src_cnt++] = page_address(src_list[i]) +
 				(src_offs ? src_offs[i] : offset);
-	src_cnt = xor_src_cnt;
+
 	/* set destination address */
 	dest_buf = page_address(dest) + offset;
-
 	if (submit->flags & ASYNC_TX_XOR_ZERO_DST)
 		memset(dest_buf, 0, len);
-
-	while (src_cnt > 0) {
-		/* process up to 'MAX_XOR_BLOCKS' sources */
-		xor_src_cnt = min(src_cnt, MAX_XOR_BLOCKS);
-		xor_blocks(xor_src_cnt, len, dest_buf, &srcs[src_off]);
-
-		/* drop completed sources */
-		src_cnt -= xor_src_cnt;
-		src_off += xor_src_cnt;
-	}
-
+	xor_gen(dest_buf, srcs, xor_src_cnt, len);
 	async_tx_sync_epilog(submit);
 }
 
@@ -168,11 +156,10 @@ dma_xor_aligned_offsets(struct dma_device *device, unsigned int offset,
  *
  * honored flags: ASYNC_TX_ACK, ASYNC_TX_XOR_ZERO_DST, ASYNC_TX_XOR_DROP_DST
  *
- * xor_blocks always uses the dest as a source so the
- * ASYNC_TX_XOR_ZERO_DST flag must be set to not include dest data in
- * the calculation.  The assumption with dma engines is that they only
- * use the destination buffer as a source when it is explicitly specified
- * in the source list.
+ * xor_gen always uses the dest as a source so the ASYNC_TX_XOR_ZERO_DST flag
+ * must be set to not include dest data in the calculation.  The assumption with
+ * dma engines is that they only use the destination buffer as a source when it
+ * is explicitly specified in the source list.
  *
  * src_list note: if the dest is also a source it must be at index zero.
  * The contents of this array will be overwritten if a scribble region
@@ -259,11 +246,10 @@ EXPORT_SYMBOL_GPL(async_xor_offs);
  *
  * honored flags: ASYNC_TX_ACK, ASYNC_TX_XOR_ZERO_DST, ASYNC_TX_XOR_DROP_DST
  *
- * xor_blocks always uses the dest as a source so the
- * ASYNC_TX_XOR_ZERO_DST flag must be set to not include dest data in
- * the calculation.  The assumption with dma engines is that they only
- * use the destination buffer as a source when it is explicitly specified
- * in the source list.
+ * xor_gen always uses the dest as a source so the ASYNC_TX_XOR_ZERO_DST flag
+ * must be set to not include dest data in the calculation.  The assumption with
+ * dma engines is that they only use the destination buffer as a source when it
+ * is explicitly specified in the source list.
  *
  * src_list note: if the dest is also a source it must be at index zero.
  * The contents of this array will be overwritten if a scribble region
-- 
2.47.3

