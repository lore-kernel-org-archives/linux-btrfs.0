Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A3D22A7F0
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 18:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779473663; cv=none; b=hned4OY257fVfNIaGS0JnNaDQVd6Kkp29iq7i4/YS8W8bSxSEf6ON2ZxeMqUi169DtCpVLfy7Ss39zZheDgK3pJNtYzEEuXAec1S6Bg9DvA4phBPlwPoHyjQWqydznrfKNZav7A5duPWDJXzSTMDfvaWBuRlegbm0IBCztH8Uh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779473663; c=relaxed/simple;
	bh=l2d/VJ2+nQmIxkAkDjRCSkGLsjOb6i/FIiQPA19hB3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIvMzMFY56vtmwyEGsYTsa91pPSA15sOMq3gRoNsTWEVg+ziPt71ikKU+claMH/DNwDVnngztwOHJ35stC+a2MQDl7LWW3DgS2NnCA83T09U/ymZiBFdHbrqdgfZxJytTvjmIomxIoLNry1BIYvwtlxrvp6TRqOKq/HaOvfU8KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NuAZgbn0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NuAZgbn0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=j/LuuRCTSj0S3AGAuDLbx/yyPJZYpR8nOZq7Y0CW2L0=; b=NuAZgbn0Lh6Dq6tyn/m3KMkCNQ
	tq4MHLVzz4W9ggbNE1vrGKPJwIwZdlYg0bXuoTIsG4CDQmxZK+IL01AFFI8uhxQoCeYVi8xPxS5R2
	TyZuw6eBor76kEkpHrtpoDdQ/yk2gvbj8KS75rLuMKyovIXOz/mV/hYYWkWTR5sNYxQHMxtSqvp8y
	OX100gxaLCCWYzeJeUia90/jz8HHCfy6sA4vvnY0rTer6kJRLTlmUDvZQN+dL+BsaRFN+LaoOHdiC
	DsgmCZn6LuX3gC67CacvAWDqeH/NaacTdlFjsWq5nOQEowxTqagSH2ne9HpjrWdPWeBEmlIrMwI2S
	qRPpsXjQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQUNx-0000000ARB1-0rH7;
	Fri, 22 May 2026 18:14:13 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Chris Mason <clm@fb.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 3/3] btrfs: Remove use of bv_page
Date: Fri, 22 May 2026 19:14:09 +0100
Message-ID: <20260522181411.2487732-4-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522181411.2487732-1-willy@infradead.org>
References: <20260522181411.2487732-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is open-coded bvec_phys()

Fixes: 6f706f34fc4c (btrfs: switch to btrfs_compress_bio() interface for compressed writes)
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 75136a172710..10ca76b177b3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -842,7 +842,7 @@ static struct folio *compressed_bio_last_folio(struct compressed_bio *cb)
 	ASSERT(bio->bi_vcnt);
 
 	bvec = &bio->bi_io_vec[bio->bi_vcnt - 1];
-	paddr = page_to_phys(bvec->bv_page) + bvec->bv_offset + bvec->bv_len - 1;
+	paddr = bvec_phys(bvec) + bvec->bv_len - 1;
 	return page_folio(phys_to_page(paddr));
 }
 
-- 
2.47.3

