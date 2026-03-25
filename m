Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3088920A5F3
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 00:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774399338; cv=none; b=Rvv/E7FJFWas5HMiWdMY2s8QgZ91OagKUenOOuuhNskQowtBHTeyXCUc/sMmTynhAEXy7IAl72NOcVP1XL11BxZKLhmjE7a6jAR+X3CiMyzNRGSPuLx/Il/xoQf8bx6YbfphHB/aX7TrBDZ1TNLrEwGC35Ymxiu3F3QvRuTSK+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774399338; c=relaxed/simple;
	bh=BmE7WejpeoqBltKyFC2zKD9qPoB1Wm/RPHgbiKIkKqo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pz2drzedZxuyYEMGRB9RrgoFP2vN13UvtebD+xd0O6KiDRO6moKdbqumIKjfSPb7AAoaYuptn79kJH25PFhiIMxBNtg02HkLSXMfYU7kq09SDTQSCZo+F583mUM32Jc2RUmC5lg45VAp1wAsYFoDzAGkNfQFRlIhX2hGFL9+0AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=kM+PK7Re; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=0ahaSVho; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="kM+PK7Re";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="0ahaSVho"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 6BA69EC00EF;
	Tue, 24 Mar 2026 20:42:16 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 24 Mar 2026 20:42:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1774399336; x=
	1774485736; bh=5r9k4NgxaD2cqJSuBOmyGsvJZG5DtYsv1B5gplKeC5Y=; b=k
	M+PK7Re60tLB7qU4sXM2UkPRhyTuNbVJ37ZEovl2F8xHWqNm5sJay/RBr4r1AZHZ
	fyKXDVZO01d4UiAcae8eBnz7BvEjmFxfFxmF8w8YkuI0BE7w9KKM2EWclcCwDitk
	fMjUPiqguQ7WDyyNQM5rvJp7f41XHa3+ORYCm6hxwrVTZgPuPt2WlDPuX284EwTU
	WgP3hk4I5wnKivxpXSCRA47JolPHO9iDnG1gKNguK743lcOQVegHDvEjhjOqoX2A
	sajhwYPwJ6XY2idW3iPXf7IBrg0/dS7f5GXBClYWtUkmPA4GWH4qBmN5oMbgYbCQ
	J6q5scTTR/T+ukZfLBsxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1774399336; x=1774485736; bh=5r9k4NgxaD2cqJSuBOmyGsvJZG5D
	tYsv1B5gplKeC5Y=; b=0ahaSVhoL4q0qbByV+6avkJ3NeUr8HGjn5UjWmfyGauq
	KP2uYIADYZuUrHoUuESC0kHfnMkLXZ68VoQ6O3QmxYuEqzlY6LA2XQdGhRMtozAj
	/WNICVmz4j7Sp5QNRatkOTF0pmTCc/nhP4zrCW7WXmE4ZQ/S3JvN+nOD2BmUmamY
	NLRGYoyw8Y1T+hxvZJ2weB6/6Bia01/PNUSTMoNB4tgd9PDqSFIz1tExvYdfeILV
	xCwFvnMXYxQZCOYiqB8/2fdgDZ5mfVIie/1as+G3Q5oZQwxQhqknaTayBwnw5jln
	edxKGHJ5SLwmtwR6HTDDPAq8lZXUrPXgSDsxSHkZyQ==
X-ME-Sender: <xms:aC_DabaCWutVWmWPTX0cYAGhiRD-vxu7-MdipeA8rV7gLQTYoZ8Otg>
    <xme:aC_DaQbLVLOQz8zAy0YspIwVv71sBlmV-2I5jSPRMPMmwtWyTylhLio8kpGK9VXI4
    UhYecvK6cZUMSWEoH8tLyfmN0Y8sfJE5Vb-BaETk1prXWGhVZmvsIM>
X-ME-Received: <xmr:aC_DabnLUhsBo-Q1dTFB15iY2qNbD3G6ht4fVVASoOMD5HQr1h8I1WvH99ehPLyj9AgPolUjfprTuUDuwHx6aHg2kuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdeftdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffvedvhe
    dtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhrihhssegsuhhrrdhiohdpnhgspghrtghpthhtohepvddpmhhoug
    gvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehfsgdrtghomh
X-ME-Proxy: <xmx:aC_Dacw8r2lCYAOCMqE1Xdo9DHAPi5GsyLWno2NOn3WWQ3mD8RcaWQ>
    <xmx:aC_DaZOoEk7MEe9VxNqmwj2ulasBsjPXUJ4JIBmUECdmROSrBXOS_g>
    <xmx:aC_DaQTEgYA8Jo2foEALto7kWXfNqfgFueObP_JRt0QPc42MbpeqgQ>
    <xmx:aC_DaXbAoFSj41FrNVjwkhzWO4Aw75tGNHfnMx2VsSD6baZ1Y7GxrQ>
    <xmx:aC_DaV-2v_t5UIyF8elis6oV-dhMYDKf2e8UXczQwyhjxsFa3XM-jiW5>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Mar 2026 20:42:15 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 2/5] btrfs: account for csum delayed_refs in delalloc
Date: Tue, 24 Mar 2026 17:41:50 -0700
Message-ID: <36b185d69a6bf98d76a445dddfd6aa14629390fe.1774398665.git.boris@bur.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774398665.git.boris@bur.io>
References: <cover.1774398665.git.boris@bur.io>
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
 fs/btrfs/delalloc-space.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index e2944ff4fe47..2eeafada96ec 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -255,6 +255,20 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
 						   qgroup_to_release);
 }
 
+/*
+ * ordered_extent completion will generate metadata delayed refs for
+ * the extent, free_space, and csum trees. btrfs_calc_delayed_ref_bytes()
+ * accounts for the former two, and we explicitly reserve for the latter.
+ * This ensures that we reserve enough delayed_ref space for each
+ * ordered_extent.
+ */
+static u64 delalloc_calc_delayed_refs_rsv(const struct btrfs_fs_info *fs_info,
+					  unsigned int nr_extents)
+{
+	return btrfs_calc_delayed_ref_bytes(fs_info, nr_extents) +
+		btrfs_calc_insert_metadata_size(fs_info, nr_extents);
+}
+
 static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 						 struct btrfs_inode *inode)
 {
@@ -276,8 +290,8 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 		reserve_size = btrfs_calc_insert_metadata_size(fs_info,
 						outstanding_extents);
 		reserve_size += btrfs_calc_metadata_size(fs_info, 1);
-		delayed_refs_size += btrfs_calc_delayed_ref_bytes(fs_info,
-						outstanding_extents);
+		delayed_refs_size +=
+			delalloc_calc_delayed_refs_rsv(fs_info, outstanding_extents);
 	}
 	if (!(inode->flags & BTRFS_INODE_NODATASUM)) {
 		u64 csum_leaves;
@@ -328,8 +342,7 @@ static void calc_inode_reservations(struct btrfs_inode *inode,
 	 */
 	*meta_reserve += inode_update;
 
-	*delayed_refs_reserve = btrfs_calc_delayed_ref_bytes(fs_info,
-							     nr_extents);
+	*delayed_refs_reserve = delalloc_calc_delayed_refs_rsv(fs_info, nr_extents);
 
 	*qgroup_reserve = nr_extents * fs_info->nodesize;
 }
-- 
2.53.0

