Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B936E28CF4A
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 00:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789086361; cv=none; b=CFZE/YtSYkFJvPBzSDYf8ZxbGT3a+6Ej6E/bDuLVAaDDzMyBgbF2jZzu18lrl5odrYKAglZ9gxsDLCKsWeB7hJZHJTXrmvYodF//Ypc6S7dT9qVkRo7Dahx9Ci8P1C3RRwhjpXkPo0P6P/2tsqtJMLpLCt8DI8LLx9ynFfGsTro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789086361; c=relaxed/simple;
	bh=qg935h0WTE73m4zvFFBbGLOGn6NV2dD2dFPnMtkbNMc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/v7rieAnoTBnxZCx/G4xzjwGzuojYJN+Rv37soJ8YWrIEbJk7uF6BGuEp6fOdpX6rR3LXEK8LLBpT4JHx7TzV2RhIBFzLz4VY8BrOU+g5kpNQyh7MDPk4EJuVz+dFcSGRRO3WsGOHKGtuX6gfwva3BBbTrLT2y3ZpYovfV/uXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Vp1WR7jP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=V9RZ55Hx; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Vp1WR7jP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="V9RZ55Hx"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 6EF4C7A00FF;
	Thu, 10 Sep 2026 20:25:58 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Thu, 10 Sep 2026 20:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789086358; x=
	1789172758; bh=prNdyVDbymJHMbAfpZsyDkOSVlTCnPRUg+Sj7B0X1Fs=; b=V
	p1WR7jPCWheCVBxzVDwQ5ih3JBDdGVpVzxuAB0C5E57YWjmiyMjNq8zG55FXct8a
	X7M+YGZ8HsKmjMwpw1jj62GlX/pSZCRAAEjmU7NgH9ux7SjVjAkrfUS5cT9d33F7
	xtHwUs6IkwxpggyBl4aKsHh691bLEf+ScDOj+bPk/ebwRD0YcNjFbLwSHp53RASP
	1kgYgZQ52Mcmp1Wbcr/3wseJDHx+XXBkZRf3wdDzWPA/kXShwpi3fPvb09JevkB7
	VwbiBuNLnjIXCbG27ijjM2B2WTKs/0lZFv9muIkVn67c0ohOaOQtxK130Xd2pTx3
	V01hWYp93q2IwK1EyWj+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1789086358; x=1789172758; bh=prNdyVDbymJHMbAfpZsyDkOSVlTC
	nPRUg+Sj7B0X1Fs=; b=V9RZ55Hxo+/NJic60plUrXagPjB25Ndhivraq7qClzKb
	Y5srd6DY6BpNGkHVYKxHFrw8drS/a3JSKPUPkr6z49p8zt0/hGOJeHUFdEUaWrZj
	z1WRxGxPUca3aFi21vKnIId6R6JfKfW/nndjNuBvc69r7XcF7550Gsm3LapC3/tP
	zfASFM+AmZgjgwMjOPCzleHWI+7mIYE22g658fQNf6qiIOth22ZMclBWA+kispfg
	CWdYNIY5TJqhSi569lzHe0DyOQPNpwAM0ejHfCFXbRSv86VCW1Eq3K18eYHds2hf
	lA1ZqCYWJ4x/AHeK5JmhHB1bH6YxJXcMKBaZNyCTqw==
X-ME-Sender: <xms:lkqjaltg-vn7cQEcXv_bbdq4BhfCqMFjzKcSHlO7R5pUsMARtcZMyw>
    <xme:lkqjakdopPi8u3-Gj11i3TBQ2hIDk8d2LQhraW1Ls2yT-tC0SiPiL2J6PfbgRi9Q7
    Ot6KidD_NRIpDkLjAK0wgIAskYLhQWDnSQenMAEg_O3hbn25ucIuCD6>
X-ME-Received: <xmr:lkqjamYmbXvCVImoj1ZOkJ8IrdEraBbmSKbOqu9aVBuGpyLG4bvgz98>
X-ME-Proxy-Cause: dmFkZTG0Q3B5PBW5Xp+1KKG6/++KrTpZKC6wtfqmOinzqQW+KAbeF+f7Hw3YY7gpCmUjUH
    aBuHVCUK+s+glbMAv1F527tdaKEkxcKuyeSKWYgTJfpIv5GaLLWKigXrUO7ZSBTBAHkXAF
    7x6+Nse5eNCnkEuijA6Ms27XjDTKY4urvwcNSBmS8G6wPM4qNmpZurV8pSa1vlnX+ZfdOR
    1VGcUaB1OgM4rlWevV1laUVfSeRtko8tmooAbRxFf4Fbr8GANx2MmQgNyYGg6ODov5TWJg
    +AIdHF2armVU0mPtRAlm5KDPLIWL/IPeIofvBZvSs2IFVp3IKllhKE3+8UtzDcFLyJQYOB
    NT2i+8z5N9o4f2QFT60qUCy91qnOO+x1Eh/DDFXBDIdROmL8vpcYTedjSkAJeyhQll1pGI
    3/dtuvAbWsE86D6fjMVQ9nG7d8UmvZr29WqMaGeDfKVPFMbRNAtsfExk/OXxMZ/qayKl3C
    6biMe7Ya/oH3rVndUHX58r94Od1xCloEl+z8kd6sYNNuEIBH6C4MBuGmVdbTYMl5oERwz0
    tR2vg6bwCpjLCgPNgnBJ4OOynEjqxG1uykhPgO5hwQgr1/L4uSvfpbEMFgvCNBEdQar4Y+
    J4x/cAnMeAIC6PEnavnN37xOt7moo0iuBqzJ1vbjsL6kMYfbyFpy4RDcp84Q
X-ME-Proxy: <xmx:lkqjanVG25_c_zZ5UpwkrNowmcUpCnBaS6IixlywsvLmJfcvYbDs9w>
    <xmx:lkqjaoibTGXcE12vzhJfErAuwXPW49RaMmiXTAt0Z9B19SEq4heW8A>
    <xmx:lkqjalVUUuRrQrOJx9oI1oYBhme_qE6mD2OazEhm6MmRh-ThWToZag>
    <xmx:lkqjavP4wn6xNtM0N6bTU_VkvlFWN5BVEYVd6uxF3gBCpmsW8qayvw>
    <xmx:lkqjarsby1se2df49XgC3fxX9a2r4JFb6_-X-7yr9gi2D8Qp6Z676DXB>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 20:25:57 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 2/3] btrfs: skip unlocked reflink source flush if the inode has writers
Date: Thu, 10 Sep 2026 17:26:18 -0700
Message-ID: <e0179b25a2f40283eb7462f1e95866fe31428b6f.1789085863.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789085863.git.boris@bur.io>
References: <cover.1789085863.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The optimistic unlocked flushing is counter-productive if there is an
active writer dirtying pages, as it results in doubly writing back any
pages that get dirtied again before the locked flush. Therefore,
pessimize it slightly and don't do the unlocked flushing if we have
outstanding writable file descriptors or memory mappings. Since the
inode isn't locked, this is only advisory, any new mapping or fd that
sneaks in after the check but before the locking can still cause extra
writeback. But it trivially helps quite a bit in simple cases with a
long open file descriptor or mapping.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/reflink.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 7bab391f1be4..abe44769179a 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -978,13 +978,20 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
 		return -EINVAL;
 
-	ret = filemap_flush(src_inode->vfs_inode.i_mapping);
-	if (ret < 0)
-		return ret;
+	/*
+	 * If there are no outstanding writers, it is likely to be helpful to
+	 * flush any latent dirty pages before locking the inodes.
+	 */
+	if (atomic_read(&src_inode->vfs_inode.i_writecount) <= 0 &&
+	    !mapping_writably_mapped(src_inode->vfs_inode.i_mapping)) {
+		ret = filemap_flush(src_inode->vfs_inode.i_mapping);
+		if (ret < 0)
+			return ret;
 
-	ret = wait_existing_ordered_extents(src_inode);
-	if (ret < 0)
-		return ret;
+		ret = wait_existing_ordered_extents(src_inode);
+		if (ret < 0)
+			return ret;
+	}
 
 	if (same_inode) {
 		btrfs_inode_lock(src_inode, BTRFS_ILOCK_MMAP);
-- 
2.55.0

