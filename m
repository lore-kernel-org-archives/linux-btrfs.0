Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EC61EA84
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2026 10:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769163483; cv=none; b=K8GDxIaM8ArLC1UjNjRn9LPlF4en4KDLrmYzVfA+C+kn1yo1JM05GOrrkrImU53d9fdOKciP0qgi5Omtks7MspRjpL6VqczfseW4Fh/GTqayDcyPBhCMXHbc/VlpHwm2O/s9JiOWayDKLJj+fS2SSG5J9uZ5GsCIsXqsMcxiCDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769163483; c=relaxed/simple;
	bh=0gCKAfFCSg1hRBY/IqcrHICccG8hr/Q5pCR2j2lthlc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyjGsGmD92YaZCINFd5VHuUtKWiOySCDf4IXyOiPskhd+Hl9fEAb6z4kV09u0xt+m2oF+/3PAnpqS6/wvdtW23aW6DJ0n3DiHsXivUSDT2W0SduroEF4n82MlMaAXeXYXkZzRL38vh25aUz1429M+9EdH1BUhOAj/egJUHL1bek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T6oQEkDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T6oQEkDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58227C116D0
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2026 10:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769163482;
	bh=0gCKAfFCSg1hRBY/IqcrHICccG8hr/Q5pCR2j2lthlc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=T6oQEkDQIWeoAIo+Ygnxx38CWLTFVo2XsGfr8qiaEb00nuQ0NSeMN62LncUV4Sw8O
	 kqfkOPUR/APKOeBAIV9M2y1L2kKhWeSUitlP0sJWp5H0voYJyIzoMB6JYXNbAjQ8De
	 WJGnt5N4K4jkVlNlQG0UV+FrMD5GmetUyS6cEiPGdtFBrC7HTY/LnCB5roATKBHcg7
	 IDVFXGKrQYEYAIPnBEyyMqdmPh4vRwHTfPxVUTdrLAqnSoQmapgDXOGTe6dGyWJ+d2
	 wv4g557Ztg0Jm0R6lIoAucJCqOvGX5SCsFB8ECZYY6JRvs04ajiQyGVqnh3ErShrgT
	 PYDLjCYmPPmzA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: abort transaction on error in btrfs_remove_block_group()
Date: Fri, 23 Jan 2026 10:17:57 +0000
Message-ID: <99743ac0b4b9a69dcaa8f9adcaf301bd1a0f1a89.1769163248.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1769163248.git.fdmanana@suse.com>
References: <cover.1769163248.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

When btrfs_remove_block_group() fails we abort the transaction in its
single caller (btrfs_remove_chunk()). This makes it harder to find out
where exactly the failure happened, as several steps inside
btrfs_remove_block_group() can fail.

So make btrfs_remove_block_group() abort the transaction whenever an
error happens, instead of aborting in its caller.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-group.c | 19 ++++++++++++++-----
 fs/btrfs/volumes.c     |  7 +++----
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 3a0521236ecd..7b723571501e 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1108,8 +1108,10 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	bool remove_rsv = false;
 
 	block_group = btrfs_lookup_block_group(fs_info, map->start);
-	if (!block_group)
+	if (unlikely(!block_group)) {
+		btrfs_abort_transaction(trans, -ENOENT);
 		return -ENOENT;
+	}
 
 	BUG_ON(!block_group->ro && !(block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED));
 
@@ -1143,8 +1145,9 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	btrfs_clear_data_reloc_bg(block_group);
 
 	path = btrfs_alloc_path();
-	if (!path) {
+	if (unlikely(!path)) {
 		ret = -ENOMEM;
+		btrfs_abort_transaction(trans, ret);
 		goto out;
 	}
 
@@ -1180,8 +1183,10 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	mutex_unlock(&trans->transaction->cache_write_mutex);
 
 	ret = btrfs_remove_free_space_inode(trans, inode, block_group);
-	if (ret)
+	if (unlikely(ret)) {
+		btrfs_abort_transaction(trans, ret);
 		goto out;
+	}
 
 	write_lock(&fs_info->block_group_cache_lock);
 	rb_erase_cached(&block_group->cache_node,
@@ -1268,13 +1273,17 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	 */
 	if (!(block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)) {
 		ret = btrfs_remove_block_group_free_space(trans, block_group);
-		if (ret)
+		if (unlikely(ret)) {
+			btrfs_abort_transaction(trans, ret);
 			goto out;
+		}
 	}
 
 	ret = remove_block_group_item(trans, path, block_group);
-	if (ret < 0)
+	if (unlikely(ret < 0)) {
+		btrfs_abort_transaction(trans, ret);
 		goto out;
+	}
 
 	spin_lock(&block_group->lock);
 	/*
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cff2412bc879..d33780082b8d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3384,11 +3384,10 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans, u64 chunk_offset)
 	 */
 	btrfs_trans_release_chunk_metadata(trans);
 
+	/* On error, btrfs_remove_block_group() aborts the transaction. */
 	ret = btrfs_remove_block_group(trans, map);
-	if (unlikely(ret)) {
-		btrfs_abort_transaction(trans, ret);
-		goto out;
-	}
+	if (unlikely(ret))
+		ASSERT(BTRFS_FS_ERROR(fs_info) != 0);
 
 out:
 	if (trans->removing_chunk) {
-- 
2.47.2

