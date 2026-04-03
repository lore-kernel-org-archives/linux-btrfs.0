Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A9E374E4C
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 22:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775255283; cv=none; b=UiJULcMdNPUl8MhDW/ZE1xpQa7XrtxihGMBB5bRMpg2XK1zQCvPa2YtpzFs0glYfsSfCVJOIRMlF/PhzYdu0ZHelmgsgQkL5BGFkvEqDiT78T6udcRfwC/bOrqH8dJ7txdmeGd4AvUcKvHCeSjh22sLlOjH8GFS7SwAhduMnDPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775255283; c=relaxed/simple;
	bh=jDKeTYXDsTlZv3arxN4W7TaB5KEvRdErQbNWG08XPww=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMfOk6hdY3epzBvbkLj99v7X2mMoWyTTUcvPNn0Dh+lr9gIT7ddTYlTy3aJBY6QQoLMzhU7w5UnecABS9Jgl0hhn/m9oIHSNHOu5kyTsakrPIpcPksqrmo+JiKK+2uThrVU7ttsuP58bYDqHud9yPmwSBJu06frX4McCwZN8MV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=JWPuI0ki; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=vWxp55Bc; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="JWPuI0ki";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vWxp55Bc"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id BD3E5EC00C0;
	Fri,  3 Apr 2026 18:28:01 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 03 Apr 2026 18:28:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1775255281; x=
	1775341681; bh=VkpfMe01MIla7/YE1qD7W2xcyadQKzlrUJoMeXPndrg=; b=J
	WPuI0kisBdAQtlaEwMttm6R/56te5+UqhmsSOx/vHQnFYokZeGOQ5vu4x/2rYwH4
	WY78hMHJd/Bhmevfm/SnphjSE442c4FuC1JH87W1roXFBIxurVCE2ySf7q6HMQCC
	doL0PYmnWdR0fqGpYGWrtVaKIb1e6mNVc0DysuVL6z2ZXCbfWGn2C1/eY2dXLX4P
	GCTwTDw5oGUyPS8RJbjJL7pPK1/ayNSIoJoF/0f/ebCVUuZ+pDrE/GFEJds+kdsi
	aVO+UXzWGqJWexxTYeJUAMwGn2QTILiW9wZaETHBODnE65We0+R81fLaR1NrPBs0
	QhSRXarjJwkVSSg4J8Bzw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1775255281; x=1775341681; bh=VkpfMe01MIla7/YE1qD7W2xcyadQ
	KzlrUJoMeXPndrg=; b=vWxp55BcYTrHhdaMSFuWjU8HAuN/HFrdB0OY5HAtBX6b
	bhcaCeRXA7KAvdF+qhaEU7ivyKajtOAvfBVhkOUWs9g74IUagGSSoY0z9imhdfGS
	izpZrCFMssT5oZYvklSE7t8wEZ57ffq6R74pxYMNU8FDCbbLhix2T4gQ/VqEpYCN
	V4sZijxorMnC17sYEGQGfVxsLNNTnQnZ8ZVXhI1B2fSBj+FxjL38/S3dC4paJmLW
	LeIguJf3Q+/TeP2fmcAe7h0eDyxGpnepDP3bBEJWd4PL0ImBBUhEyaMeamwpaTWM
	R3xAutn/lVauFOns+i8EYfidkDMSIP7R3d1DqnlX9A==
X-ME-Sender: <xms:8T7QaWR_hNm_sUr4NOAdnpzZh_EbgUI6-5npsUptNh204PDcs3kWRg>
    <xme:8T7QaRy1oaiIFXXI_j-WCqpYDKsri5GLnivH4PJvQHKnlMwtqRsXu2ozmIK2lWK4X
    mTaxSV2Y4csaJiV2WhP-2t2jbHsqjEWvIi3cnd0m2qavzVmTBdfNoy3>
X-ME-Received: <xmr:8T7QaRc7qodqavEYin5o7UJG_vXvmv-pzSdpEceevC7zLOHxZtLzltU0Aii32G8vGDQvnrtDvx13S1AGWgF8jcuo5UI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvdehtd
    dufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvg
    epshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:8T7QadIboEdtfbENT0X_ccLyZRCOyFdSZ1cmgoLaeuig4l-aWC5fwg>
    <xmx:8T7QaSECiQPFAYj1UfkxOLc-aWxazWcHLNsvTGtCtOcQkAFQ7jl82g>
    <xmx:8T7QaXp5Q8v1_M2HtF7FaDZ2nscAMw5tp4TdL2ikhh5nsDJmE4_hJw>
    <xmx:8T7QabQH684QjjcCz8YFHSZXMircYRxH9vIMzC3YQjGLh3My_HNr4A>
    <xmx:8T7Qae3u158ny_2qBlbONIz_6KOXXLyfJEjNyv-hqWAru0paSTt4I2pB>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Apr 2026 18:28:01 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 2/5] btrfs: account for csum delayed_refs in delalloc
Date: Fri,  3 Apr 2026 15:27:52 -0700
Message-ID: <c419f42eff7561e0a015bc6f5c7b6cc7c683ab0b.1775255085.git.boris@bur.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775255085.git.boris@bur.io>
References: <cover.1775255085.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As ordered_extents complete, they not only produce direct delayed refs,
they also add csums via add_pending_csums. This produces some number of
metadata delayed_refs as the csum tree is cow-ed. These refs are counted
against the trans_handle delayed_rsv, thanks to trans->adding_csums.

As a result, just like we account for the extent tree and free space
tree when reserving delayed_refs for delalloc, we must also reserve for
the csum tree. This is mirrored by the non-delayed-ref metadata
reservation already accounting for csums.

This serves to ensure we have a proper worst case estimate for
delayed_rsv from delalloc.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/delalloc-space.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index a087be55409f..c2e5c7758ed5 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -252,12 +252,19 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
 
 /*
  * Each delalloc extent could become an ordered_extent and end up inserting a
- * new extent into the extent and free space trees. So we must reserve
- * delayed ref space up front for that.
+ * new extent into the extent and free space trees. It also may end up writing
+ * csums, so we must reserve delayed ref space up front for all of that.
  */
 static u64 delalloc_calc_delayed_refs_rsv(const struct btrfs_fs_info *fs_info, u64 nr_extents)
 {
-	return btrfs_calc_delayed_ref_bytes(fs_info, nr_extents);
+	/*
+	 * btrfs_calc_delayed_ref_bytes() does not assume csums as it is
+	 * also called from metadata writing contexts. So the extra
+	 * metadata insertion reservation represents the possibility of
+	 * delayed refs during csum tree writes.
+	 */
+	return btrfs_calc_delayed_ref_bytes(fs_info, nr_extents) +
+		btrfs_calc_insert_metadata_size(fs_info, nr_extents);
 }
 
 static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
-- 
2.53.0

