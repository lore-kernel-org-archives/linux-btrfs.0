Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AB0330644
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 19:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773776831; cv=none; b=saNAp9MHxXxWp77mLx+zBKZK3P1rZBQ7VVazT7wF7631MbluISNxglHfdRzm6BxEBsF9BpBB92RlE4CpI3s3nxhtKeDGEgcfQOAtr/e+yMMzHhAWOro9tbr32UfrS2wf3viaUh/jp/eFJ6InNPgQsWAZ4bNvgOS+VQnUcmGkSvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773776831; c=relaxed/simple;
	bh=wW9UUr0+aHgZVvQ1xKdRLDyxiEv2WsUDBIsjKhAYhPU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJDhgoOn7Lhyda/DvOPUlvlyDLjiyRAMhFoh65x42toteY/MF7b/8Ni1GP8dGgbWAygof7+k9q3zkcVVJ1Pg417lMFZyqEdTCuD9eAlmzIqmka7brsS/qe05KtyTN0uYDijeW2/Pv7r4s9ZW2NvqbQkU4XfThuQamAGVYAmnJds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NzN9lkgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NzN9lkgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC27EC2BC86
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 19:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773776831;
	bh=wW9UUr0+aHgZVvQ1xKdRLDyxiEv2WsUDBIsjKhAYhPU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NzN9lkgpGmf/X1ahNFeDF8onLsZUXgcqWpAqb6K31rXQUziqig1Y5HPxUwhIbw8Yl
	 dUhRBLOfFiH4qbVNdV150/YX6HKsExFEbYQv6h0S7bmz+YY6WADB4aoJ738cOJJi1M
	 Os2XE5cRy6sVAZuIgwBMdN95wVLJjr3UvGN7uBt5yXOVOU7PnrOPuFCBN/yycJKGYs
	 oifL2G92Iy1AjrzY9DhI3PKpEjjEOR1UFUTrgFcw0UlPMOQ4AFcdkW8IJ/aYtnh2jb
	 56KWFPenlMbY6W7SE6JIOFr0h9Dx29DDgJO71pn1HfShm9K6cFCZ5/88M7wEXW1VtT
	 I7TbD5fVh6dqg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs: collapse __btrfs_qgroup_free_meta() into btrfs_qgroup_free_meta_prealloc()
Date: Tue, 17 Mar 2026 19:47:01 +0000
Message-ID: <2b6035bc5438581a0667cfba7eec3558dc13d18e.1773776355.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1773776354.git.fdmanana@suse.com>
References: <cover.1773776354.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Since __btrfs_qgroup_free_meta() is only called by
btrfs_qgroup_free_meta_prealloc(), which is a simple inline wrapper, get
rid of the later and rename __btrfs_qgroup_free_meta() to the later.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c | 12 +++++++-----
 fs/btrfs/qgroup.h | 10 +---------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 65ec45859507..8a9039fba158 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4551,8 +4551,7 @@ void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root)
 				  BTRFS_QGROUP_RSV_META_PERTRANS);
 }
 
-void __btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes,
-			      enum btrfs_qgroup_rsv_type type)
+void btrfs_qgroup_free_meta_prealloc(struct btrfs_root *root, int num_bytes)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
@@ -4565,10 +4564,13 @@ void __btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes,
 	 * which can lead to underflow.
 	 * Here ensure we will only free what we really have reserved.
 	 */
-	num_bytes = sub_root_meta_rsv(root, num_bytes, type);
+	num_bytes = sub_root_meta_rsv(root, num_bytes,
+				      BTRFS_QGROUP_RSV_META_PREALLOC);
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
-	trace_btrfs_qgroup_meta_reserve(root, -(s64)num_bytes, type);
-	btrfs_qgroup_free_refroot(fs_info, btrfs_root_id(root), num_bytes, type);
+	trace_btrfs_qgroup_meta_reserve(root, -(s64)num_bytes,
+					BTRFS_QGROUP_RSV_META_PREALLOC);
+	btrfs_qgroup_free_refroot(fs_info, btrfs_root_id(root), num_bytes,
+				  BTRFS_QGROUP_RSV_META_PREALLOC);
 }
 
 static void qgroup_convert_meta(struct btrfs_fs_info *fs_info, u64 ref_root,
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 419f3c4120ce..190efe3ca64b 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -407,16 +407,8 @@ static inline int btrfs_qgroup_reserve_meta_prealloc(struct btrfs_root *root,
 					   enforce, noflush);
 }
 
-void __btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes,
-			     enum btrfs_qgroup_rsv_type type);
-
 /* Pre-allocated meta reservation can be freed at need */
-static inline void btrfs_qgroup_free_meta_prealloc(struct btrfs_root *root,
-						   int num_bytes)
-{
-	__btrfs_qgroup_free_meta(root, num_bytes,
-			BTRFS_QGROUP_RSV_META_PREALLOC);
-}
+void btrfs_qgroup_free_meta_prealloc(struct btrfs_root *root, int num_bytes);
 
 void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root);
 void btrfs_qgroup_convert_reserved_meta(struct btrfs_root *root, int num_bytes);
-- 
2.47.2

