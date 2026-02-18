Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C58285CB3
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Feb 2026 16:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771433121; cv=none; b=h8ehG/mJAsumBRdupgCvDPewXKhKaHl3njHSdmPf67E/dsWnStmpu6K8J2NSt1wf3PuY83EFsqXkzaTrUi2HCz1a5pi2qdUsw7cgIjKJYir8XYybCbCVX9GcX1vMSiolGVZiL9xvWi79InAs2rTX5wD+SSYB2rwQJ74fZFFcd8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771433121; c=relaxed/simple;
	bh=YmEr5BeQ+mdt2boQFx153CS6hUnl+pTHDrl9BS0As30=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Q+Whuau/SgN+dofL8PGSH8wblZIDWxeH7MW5K/m0caJH/upQbcHH5VrhFvWODG7Lqf9iCaT74nIelBhyi3EpdUBHsDzbePB79A1ZCcTDQJXi0Lx6wc9RRSlIfn8dMS+i3o0rgvqfNgo+91brS2RKhBzZl3T1OneRlV1uSYg6mK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=efLoD/bN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efLoD/bN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE096C116D0
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Feb 2026 16:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771433121;
	bh=YmEr5BeQ+mdt2boQFx153CS6hUnl+pTHDrl9BS0As30=;
	h=From:To:Subject:Date:From;
	b=efLoD/bN4+aH6Arc4TZdbVXTUiR/MZ5uItFqEwRwOrFIbQwg7SqykTuox76RttPZB
	 JdBLks+fYBI4MA8kuQZ7/hAzFJLLvk07aK8VSpGSk7fx8TzDWZUED+8mJVgU/WmWEX
	 G2hTpO2kMoyBmou88rCMWUEvyCAalle2W0XGgRu0B/+UeewF0xF3C7XjXZwdmPkjdd
	 KqqAtdsbWGojZ+N14c5+9QwEO0mL3ew5TkiuAhKFLdqLglq6xAg4Xfrx7fgUCrUIgc
	 4By+Mr1O2z73ofEJOWTXwQAEQd1KpQEBgO08ACRDuSTvjXHDnTwb2KieYKq4D/Idpz
	 PKEYR9/afETHQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: avoid unnecessary root node COW during snapshotting
Date: Wed, 18 Feb 2026 16:45:16 +0000
Message-ID: <f4267e2d75ae6d1cf5a88b86616ff27ed08e2469.1771432096.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There's no need to COW the root node of the subvolume we are snaphotting
because we then call btrfs_copy_root(), which creates a copy of the root
node and sets its generation to the current transaction. So remove this
redudant COW right before calling btrfs_copy_root(), saving one extent
allocation, memory allocation, copying things, etc, and making the code
less confusing. Also rename the extent buffer variable from "old" to
"root_eb" since that name no longer makes any sense after removing the
unnecessary COW operation.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/transaction.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 02afd7d72454..3112bd5520b7 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1669,7 +1669,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	BTRFS_PATH_AUTO_FREE(path);
 	struct btrfs_dir_item *dir_item;
 	struct extent_buffer *tmp;
-	struct extent_buffer *old;
+	struct extent_buffer *root_eb;
 	struct timespec64 cur_time;
 	int ret = 0;
 	u64 to_reserve = 0;
@@ -1807,20 +1807,10 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_timespec_nsec(&new_root_item->otime, cur_time.tv_nsec);
 	btrfs_set_root_otransid(new_root_item, trans->transid);
 
-	old = btrfs_lock_root_node(root);
-	ret = btrfs_cow_block(trans, root, old, NULL, 0, &old,
-			      BTRFS_NESTING_COW);
-	if (unlikely(ret)) {
-		btrfs_tree_unlock(old);
-		free_extent_buffer(old);
-		btrfs_abort_transaction(trans, ret);
-		goto fail;
-	}
-
-	ret = btrfs_copy_root(trans, root, old, &tmp, objectid);
-	/* clean up in any case */
-	btrfs_tree_unlock(old);
-	free_extent_buffer(old);
+	root_eb = btrfs_lock_root_node(root);
+	ret = btrfs_copy_root(trans, root, root_eb, &tmp, objectid);
+	btrfs_tree_unlock(root_eb);
+	free_extent_buffer(root_eb);
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
-- 
2.47.2

