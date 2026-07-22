Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2485F3BE635
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 07:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784705679; cv=none; b=P1eDb6IVnJemhEhiFcJyKFGgZxNlEi3qxPkvevy+XTrGowc5YgaE6/K8GbUskrLjaYhJw80sUYlhm9PWEtoCiuQnFjW531DDQiaMpXzk0aE7sDqBC4bDfSgO0FNfeeMbiEGnfgjuVIlqu9WjlyzvwgvUl8dKZAPHDIkCOh6ca4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784705679; c=relaxed/simple;
	bh=HBT/HpRuzMdNicYIt8367EUqzOOVD1nP1VYlw+tw/qQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=emC4WuGekXBLW0VJPGyVBTnf2MOTJ+09EHpEpPVMZj41sNm+4JpnhsWKyqHWRSZbfqG5Bg9Mg8PtvaWf6MqKrR+mYD/Pfh+oYLAoiLyjFe/nXGiniRvXDhuhi7vArOrFoIiSUTVrbe3Xj0idCqLk3KcOmB9apxa+m8TcGe63AIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Rx3AWkrf; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Rx3AWkrf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Rx3AWkrf";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Rx3AWkrf"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 192463E2C
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 07:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784705670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=A44gsxI8ZjWv8hqpgTa4Enkv4elOTnAekX9d70Dnf/w=;
	b=Rx3AWkrfCROQ8D2U+bto3fTWWHpTm4Li6B+xj/UhaKYvf9PGm9yzaURr9VFJEg3vjPIL7m
	LtnFDtdUokvoTOH4HvP/H3FA+Yfdzzqn05+kKRNkIFztC4aZQwCo9ZPU4RD9dFtjpEmgUh
	wXhkCX3lXqaL7yirmpQldz9Qc8UVIgQ=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Rx3AWkrf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784705670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=A44gsxI8ZjWv8hqpgTa4Enkv4elOTnAekX9d70Dnf/w=;
	b=Rx3AWkrfCROQ8D2U+bto3fTWWHpTm4Li6B+xj/UhaKYvf9PGm9yzaURr9VFJEg3vjPIL7m
	LtnFDtdUokvoTOH4HvP/H3FA+Yfdzzqn05+kKRNkIFztC4aZQwCo9ZPU4RD9dFtjpEmgUh
	wXhkCX3lXqaL7yirmpQldz9Qc8UVIgQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1AFD9779B1
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 07:34:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oEiqM4RyYGo1HgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 07:34:28 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: use %pe for error code output
Date: Wed, 22 Jul 2026 17:04:07 +0930
Message-ID: <4ada48c6c1ae4978d6e6be44008b0060a7edaeae.1784705640.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 192463E2C
X-Spam-Score: -3.01

During an interrupted mount, I got the following messages:

 workqueue: Failed to create a rescuer kthread for wq "btrfs-qgroup-rescan": -EINTR
 BTRFS error (device dm-3): open_ctree failed: -12

Workqueue code is outputting a human readable error string, meanwhile
we're still using a numeric error code.

So follow the workqueue code to use "%pe" format, which will
automatically convert an error pointer to the human readable string.

However this is a minor pitfall, if the return value is not an error
code, e.g. a positive number, "%pe" with "ERR_PTR(ret)" will output the
pointer as a hash value, e.g.:

 ret=1 %pe out=0000000019414716
 ret=-22 %pe out=-EINVAL

So we should not use this "%pe" output for callsites that are known to
return positive values.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Revert the change in iterate_leaf_refs()
  Pointed out by sashiko where we can get positive return value.

- Slightly update the commit message
  To mention that we should not use "%pe" for return values that can
  be positive.
---
 fs/btrfs/delayed-inode.c | 12 +++----
 fs/btrfs/disk-io.c       | 76 +++++++++++++++++++++-------------------
 fs/btrfs/extent-tree.c   | 20 +++++------
 fs/btrfs/extent_io.c     |  8 ++---
 fs/btrfs/inode.c         | 31 ++++++++--------
 fs/btrfs/ioctl.c         |  4 +--
 fs/btrfs/messages.c      | 10 +++---
 fs/btrfs/qgroup.c        |  8 ++---
 fs/btrfs/root-tree.c     |  6 ++--
 fs/btrfs/super.c         |  2 +-
 fs/btrfs/transaction.c   |  8 ++---
 fs/btrfs/verity.c        |  2 +-
 12 files changed, 94 insertions(+), 93 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 09795439b9fb..db2ffab0941a 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1523,10 +1523,10 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	ret = __btrfs_add_delayed_item(delayed_node, delayed_item);
 	if (unlikely(ret)) {
 		btrfs_err(trans->fs_info,
-"error adding delayed dir index item, name: %.*s, index: %llu, root: %llu, dir: %llu, dir->index_cnt: %llu, delayed_node->index_cnt: %llu, error: %d",
+"error adding delayed dir index item, name: %.*s, index: %llu, root: %llu, dir: %llu, dir->index_cnt: %llu, delayed_node->index_cnt: %llu, error: %pe",
 			  name_len, name, index, btrfs_root_id(delayed_node->root),
 			  delayed_node->inode_id, dir->index_cnt,
-			  delayed_node->index_cnt, ret);
+			  delayed_node->index_cnt, ERR_PTR(ret));
 		btrfs_release_delayed_item(delayed_item);
 		btrfs_release_dir_index_item_space(trans);
 		mutex_unlock(&delayed_node->mutex);
@@ -1645,8 +1645,8 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 	 */
 	if (ret < 0) {
 		btrfs_err(trans->fs_info,
-"metadata reservation failed for delayed dir item deletion, index: %llu, root: %llu, inode: %llu, error: %d",
-			  index, btrfs_root_id(node->root), node->inode_id, ret);
+"metadata reservation failed for delayed dir item deletion, index: %llu, root: %llu, inode: %llu, error: %pe",
+			  index, btrfs_root_id(node->root), node->inode_id, ERR_PTR(ret));
 		btrfs_release_delayed_item(item);
 		goto end;
 	}
@@ -1655,8 +1655,8 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 	ret = __btrfs_add_delayed_item(node, item);
 	if (unlikely(ret)) {
 		btrfs_err(trans->fs_info,
-"failed to add delayed dir index item, root: %llu, inode: %llu, index: %llu, error: %d",
-			  btrfs_root_id(node->root), node->inode_id, index, ret);
+"failed to add delayed dir index item, root: %llu, inode: %llu, index: %llu, error: %pe",
+			  btrfs_root_id(node->root), node->inode_id, index, ERR_PTR(ret));
 		btrfs_delayed_item_release_metadata(dir->root, item);
 		btrfs_release_delayed_item(item);
 	}
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 37fc0d6b960d..d8e4e6e9896b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2047,7 +2047,7 @@ static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
 	if (IS_ERR(log_tree_root->node)) {
 		ret = PTR_ERR(log_tree_root->node);
 		log_tree_root->node = NULL;
-		btrfs_err(fs_info, "failed to read log tree with error: %d", ret);
+		btrfs_err(fs_info, "failed to read log tree with error: %pe", ERR_PTR(ret));
 		btrfs_put_root(log_tree_root);
 		return ret;
 	}
@@ -2057,7 +2057,7 @@ static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
 	btrfs_put_root(log_tree_root);
 	if (unlikely(ret)) {
 		ASSERT(BTRFS_FS_ERROR(fs_info) != 0);
-		btrfs_err(fs_info, "failed to recover log trees with error: %d", ret);
+		btrfs_err(fs_info, "failed to recover log trees with error: %pe", ERR_PTR(ret));
 		return ret;
 	}
 
@@ -2298,8 +2298,8 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
 
 	return 0;
 out:
-	btrfs_warn(fs_info, "failed to read root (objectid=%llu): %d",
-		   location.objectid, ret);
+	btrfs_warn(fs_info, "failed to read root (objectid=%llu): %pe",
+		   location.objectid, ERR_PTR(ret));
 	return ret;
 }
 
@@ -2973,8 +2973,8 @@ static int btrfs_uuid_rescan_kthread(void *data)
 	ret = btrfs_uuid_tree_iterate(fs_info);
 	if (ret < 0) {
 		if (ret != -EINTR)
-			btrfs_warn(fs_info, "iterating uuid_tree failed %d",
-				   ret);
+			btrfs_warn(fs_info, "iterating uuid_tree failed %pe",
+				   ERR_PTR(ret));
 		up(&fs_info->uuid_tree_rescan_sem);
 		return ret;
 	}
@@ -3077,7 +3077,7 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 		ret = btrfs_rebuild_free_space_tree(fs_info);
 		if (ret) {
 			btrfs_warn(fs_info,
-				   "failed to rebuild free space tree: %d", ret);
+				   "failed to rebuild free space tree: %pe", ERR_PTR(ret));
 			return ret;
 		}
 	}
@@ -3088,7 +3088,7 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 		ret = btrfs_delete_free_space_tree(fs_info);
 		if (ret) {
 			btrfs_warn(fs_info,
-				   "failed to disable free space tree: %d", ret);
+				   "failed to disable free space tree: %pe", ERR_PTR(ret));
 			return ret;
 		}
 	}
@@ -3099,7 +3099,8 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 	 */
 	ret = btrfs_delete_orphan_free_space_entries(fs_info);
 	if (ret < 0) {
-		btrfs_err(fs_info, "failed to delete orphan free space tree entries: %d", ret);
+		btrfs_err(fs_info, "failed to delete orphan free space tree entries: %pe",
+			  ERR_PTR(ret));
 		return ret;
 	}
 	/*
@@ -3133,7 +3134,7 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 	ret = btrfs_recover_relocation(fs_info);
 	mutex_unlock(&fs_info->cleaner_mutex);
 	if (ret < 0) {
-		btrfs_warn(fs_info, "failed to recover relocation: %d", ret);
+		btrfs_warn(fs_info, "failed to recover relocation: %pe", ERR_PTR(ret));
 		return ret;
 	}
 
@@ -3143,7 +3144,7 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 		ret = btrfs_create_free_space_tree(fs_info);
 		if (ret) {
 			btrfs_warn(fs_info,
-				"failed to create free space tree: %d", ret);
+				"failed to create free space tree: %pe", ERR_PTR(ret));
 			return ret;
 		}
 	}
@@ -3171,7 +3172,7 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 		ret = btrfs_create_uuid_tree(fs_info);
 		if (ret) {
 			btrfs_warn(fs_info,
-				   "failed to create the UUID tree %d", ret);
+				   "failed to create the UUID tree %pe", ERR_PTR(ret));
 			return ret;
 		}
 	}
@@ -3544,7 +3545,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	ret = btrfs_read_sys_array(fs_info);
 	mutex_unlock(&fs_info->chunk_mutex);
 	if (ret) {
-		btrfs_err(fs_info, "failed to read the system array: %d", ret);
+		btrfs_err(fs_info, "failed to read the system array: %pe", ERR_PTR(ret));
 		goto fail_sb_buffer;
 	}
 
@@ -3563,7 +3564,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 
 	ret = btrfs_read_chunk_tree(fs_info);
 	if (ret) {
-		btrfs_err(fs_info, "failed to read chunk tree: %d", ret);
+		btrfs_err(fs_info, "failed to read chunk tree: %pe", ERR_PTR(ret));
 		goto fail_tree_roots;
 	}
 
@@ -3593,7 +3594,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	ret = btrfs_get_dev_zone_info_all_devices(fs_info);
 	if (ret) {
 		btrfs_err(fs_info,
-			  "zoned: failed to read device zone info: %d", ret);
+			  "zoned: failed to read device zone info: %pe", ERR_PTR(ret));
 		goto fail_block_groups;
 	}
 
@@ -3616,72 +3617,73 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	ret = btrfs_verify_dev_extents(fs_info);
 	if (ret) {
 		btrfs_err(fs_info,
-			  "failed to verify dev extents against chunks: %d",
-			  ret);
+			  "failed to verify dev extents against chunks: %pe",
+			  ERR_PTR(ret));
 		goto fail_block_groups;
 	}
 	ret = btrfs_recover_balance(fs_info);
 	if (ret) {
-		btrfs_err(fs_info, "failed to recover balance: %d", ret);
+		btrfs_err(fs_info, "failed to recover balance: %pe", ERR_PTR(ret));
 		goto fail_block_groups;
 	}
 
 	ret = btrfs_init_dev_stats(fs_info);
 	if (ret) {
-		btrfs_err(fs_info, "failed to init dev_stats: %d", ret);
+		btrfs_err(fs_info, "failed to init dev_stats: %pe", ERR_PTR(ret));
 		goto fail_block_groups;
 	}
 
 	ret = btrfs_init_dev_replace(fs_info);
 	if (ret) {
-		btrfs_err(fs_info, "failed to init dev_replace: %d", ret);
+		btrfs_err(fs_info, "failed to init dev_replace: %pe", ERR_PTR(ret));
 		goto fail_block_groups;
 	}
 
 	ret = btrfs_check_zoned_mode(fs_info);
 	if (ret) {
-		btrfs_err(fs_info, "failed to initialize zoned mode: %d",
-			  ret);
+		btrfs_err(fs_info, "failed to initialize zoned mode: %pe",
+			  ERR_PTR(ret));
 		goto fail_block_groups;
 	}
 
 	ret = btrfs_sysfs_add_fsid(fs_devices);
 	if (ret) {
-		btrfs_err(fs_info, "failed to init sysfs fsid interface: %d",
-				ret);
+		btrfs_err(fs_info, "failed to init sysfs fsid interface: %pe",
+			  ERR_PTR(ret));
 		goto fail_block_groups;
 	}
 
 	ret = btrfs_sysfs_add_mounted(fs_info);
 	if (ret) {
-		btrfs_err(fs_info, "failed to init sysfs interface: %d", ret);
+		btrfs_err(fs_info, "failed to init sysfs interface: %pe", ERR_PTR(ret));
 		goto fail_fsdev_sysfs;
 	}
 
 	ret = btrfs_init_space_info(fs_info);
 	if (ret) {
-		btrfs_err(fs_info, "failed to initialize space info: %d", ret);
+		btrfs_err(fs_info, "failed to initialize space info: %pe", ERR_PTR(ret));
 		goto fail_sysfs;
 	}
 
 	ret = btrfs_read_block_groups(fs_info);
 	if (ret) {
-		btrfs_err(fs_info, "failed to read block groups: %d", ret);
+		btrfs_err(fs_info, "failed to read block groups: %pe", ERR_PTR(ret));
 		goto fail_sysfs;
 	}
 
 	if (btrfs_fs_incompat(fs_info, REMAP_TREE)) {
 		ret = btrfs_populate_fully_remapped_bgs_list(fs_info);
 		if (ret) {
-			btrfs_err(fs_info, "failed to populate fully_remapped_bgs list: %d", ret);
+			btrfs_err(fs_info, "failed to populate fully_remapped_bgs list: %pe",
+				  ERR_PTR(ret));
 			goto fail_sysfs;
 		}
 	}
 
 	ret = btrfs_init_writeback_bio_size(fs_info);
 	if (ret) {
-		btrfs_err(fs_info, "failed to get optimum writeback size: %d",
-			  ret);
+		btrfs_err(fs_info, "failed to get optimum writeback size: %pe",
+			  ERR_PTR(ret));
 		goto fail_sysfs;
 	}
 
@@ -3737,7 +3739,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	fs_info->fs_root = btrfs_get_fs_root(fs_info, BTRFS_FS_TREE_OBJECTID, true);
 	if (IS_ERR(fs_info->fs_root)) {
 		ret = PTR_ERR(fs_info->fs_root);
-		btrfs_err(fs_info, "failed to read fs tree: %d", ret);
+		btrfs_err(fs_info, "failed to read fs tree: %pe", ERR_PTR(ret));
 		fs_info->fs_root = NULL;
 		goto fail_qgroup;
 	}
@@ -3758,7 +3760,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		btrfs_info(fs_info, "checking UUID tree");
 		ret = btrfs_check_uuid_tree(fs_info);
 		if (ret) {
-			btrfs_err(fs_info, "failed to check the UUID tree: %d", ret);
+			btrfs_err(fs_info, "failed to check the UUID tree: %pe", ERR_PTR(ret));
 			close_ctree(fs_info);
 			return ret;
 		}
@@ -3874,8 +3876,8 @@ static int write_dev_supers(struct btrfs_device *device,
 			continue;
 		} else if (ret < 0) {
 			btrfs_err(device->fs_info,
-			  "couldn't get super block location for mirror %d error %d",
-			  i, ret);
+			  "couldn't get super block location for mirror %d error %pe",
+			  i, ERR_PTR(ret));
 			atomic_inc(&device->sb_write_errors);
 			continue;
 		}
@@ -3893,8 +3895,8 @@ static int write_dev_supers(struct btrfs_device *device,
 					    GFP_NOFS);
 		if (IS_ERR(folio)) {
 			btrfs_err(device->fs_info,
-			  "couldn't get super block page for bytenr %llu error %ld",
-			  bytenr, PTR_ERR(folio));
+			  "couldn't get super block page for bytenr %llu error %pe",
+			  bytenr, folio);
 			atomic_inc(&device->sb_write_errors);
 			continue;
 		}
@@ -4500,7 +4502,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 		if (!btrfs_is_shutdown(fs_info)) {
 			ret = btrfs_commit_super(fs_info);
 			if (ret)
-				btrfs_err(fs_info, "commit super block returned %d", ret);
+				btrfs_err(fs_info, "commit super block returned %pe", ERR_PTR(ret));
 		}
 	}
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 235381b31298..365735c54e56 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5880,8 +5880,8 @@ static int maybe_drop_reference(struct btrfs_trans_handle *trans, struct btrfs_r
 		ret = btrfs_qgroup_trace_subtree(trans, next, generation, level - 1);
 		if (ret) {
 			btrfs_err_rl(root->fs_info,
-"error %d accounting shared subtree, quota is out of sync, rescan required",
-				     ret);
+"error %pe accounting shared subtree, quota is out of sync, rescan required",
+				     ERR_PTR(ret));
 		}
 	}
 
@@ -6096,8 +6096,8 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 				ret = btrfs_qgroup_trace_leaf_items(trans, eb);
 				if (ret) {
 					btrfs_err_rl(fs_info,
-	"error %d accounting leaf items, quota is out of sync, rescan required",
-					     ret);
+	"error %pe accounting leaf items, quota is out of sync, rescan required",
+					     ERR_PTR(ret));
 				}
 			}
 		}
@@ -6498,8 +6498,8 @@ int btrfs_drop_snapshot(struct btrfs_root *root, bool update_ref, bool for_reloc
 		ret = btrfs_qgroup_cleanup_dropped_subvolume(fs_info, rootid);
 		if (ret < 0)
 			btrfs_warn_rl(fs_info,
-				      "failed to cleanup qgroup 0/%llu: %d",
-				      rootid, ret);
+				      "failed to cleanup qgroup 0/%llu: %pe",
+				      rootid, ERR_PTR(ret));
 		ret = 0;
 	}
 	/*
@@ -6914,8 +6914,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 
 	if (bg_failed)
 		btrfs_warn(fs_info,
-			"failed to trim %llu block group(s), first error %d",
-			bg_failed, bg_ret);
+			"failed to trim %llu block group(s), first error %pe",
+			bg_failed, ERR_PTR(bg_ret));
 
 	if (ret == -ERESTARTSYS || ret == -EINTR)
 		return ret;
@@ -6925,8 +6925,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 
 	if (dev_failed)
 		btrfs_warn(fs_info,
-			"failed to trim %llu device(s), first error %d",
-			dev_failed, dev_ret);
+			"failed to trim %llu device(s), first error %pe",
+			dev_failed, ERR_PTR(dev_ret));
 	range->len = trimmed;
 	if (ret == -ERESTARTSYS || ret == -EINTR)
 		return ret;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d285bc98b0fb..d119dcf9e34b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1585,13 +1585,13 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 				last_finished_delalloc_end = found_start + found_len;
 			if (unlikely(ret < 0))
 				btrfs_err_rl(fs_info,
-"failed to run delalloc range, root=%lld ino=%llu folio=%llu submit_bitmap=%*pbl start=%llu len=%u: %d",
+"failed to run delalloc range, root=%lld ino=%llu folio=%llu submit_bitmap=%*pbl start=%llu len=%u: %pe",
 					     btrfs_root_id(inode->root),
 					     btrfs_ino(inode),
 					     folio_pos(folio),
 					     blocks_per_folio,
 					     bio_ctrl->submit_bitmap,
-					     found_start, found_len, ret);
+					     found_start, found_len, ERR_PTR(ret));
 		} else {
 			/*
 			 * We've hit an error during previous delalloc range,
@@ -1968,10 +1968,10 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
 		return 0;
 	if (unlikely(ret < 0))
 		btrfs_err_rl(fs_info,
-"failed to submit blocks, root=%lld inode=%llu folio=%llu submit_bitmap=%*pbl: %d",
+"failed to submit blocks, root=%lld inode=%llu folio=%llu submit_bitmap=%*pbl: %pe",
 			     btrfs_root_id(inode->root), btrfs_ino(inode),
 			     folio_pos(folio), blocks_per_folio,
-			     bio_ctrl->submit_bitmap, ret);
+			     bio_ctrl->submit_bitmap, ERR_PTR(ret));
 
 	bio_ctrl->wbc->nr_to_write--;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 636196705fa3..bbcbd9c44a47 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -250,8 +250,8 @@ static void print_data_reloc_error(const struct btrfs_inode *inode, u64 file_off
 
 	ret = extent_from_logical(fs_info, logical, &path, &found_key, &flags);
 	if (ret < 0) {
-		btrfs_err_rl(fs_info, "failed to lookup extent item for logical %llu: %d",
-			     logical, ret);
+		btrfs_err_rl(fs_info, "failed to lookup extent item for logical %llu: %pe",
+			     logical, ERR_PTR(ret));
 		return;
 	}
 	eb = path.nodes[0];
@@ -1019,9 +1019,10 @@ static void submit_uncompressed_range(struct btrfs_inode *inode,
 			btrfs_folio_end_lock(inode->root->fs_info, locked_folio,
 					     start, async_extent->ram_size);
 		btrfs_err_rl(inode->root->fs_info,
-			"%s failed, root=%llu inode=%llu start=%llu len=%llu: %d",
+			"%s failed, root=%llu inode=%llu start=%llu len=%llu: %pe",
 			     __func__, btrfs_root_id(inode->root),
-			     btrfs_ino(inode), start, async_extent->ram_size, ret);
+			     btrfs_ino(inode), start, async_extent->ram_size,
+			     ERR_PTR(ret));
 	}
 }
 
@@ -1508,10 +1509,10 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 				       end - start - cur_alloc_size + 1, NULL);
 	}
 	btrfs_err(fs_info,
-"%s failed, root=%llu inode=%llu start=%llu len=%llu cur_offset=%llu cur_alloc_size=%u: %d",
+"%s failed, root=%llu inode=%llu start=%llu len=%llu cur_offset=%llu cur_alloc_size=%u: %pe",
 		  __func__, btrfs_root_id(inode->root),
 		  btrfs_ino(inode), orig_start, end + 1 - orig_start,
-		  start, cur_alloc_size, ret);
+		  start, cur_alloc_size, ERR_PTR(ret));
 	return ret;
 }
 
@@ -1962,9 +1963,9 @@ static int nocow_one_range(struct btrfs_inode *inode, struct folio *locked_folio
 				     PAGE_UNLOCK | PAGE_START_WRITEBACK |
 				     PAGE_END_WRITEBACK);
 	btrfs_err(inode->root->fs_info,
-		  "%s failed, root=%lld inode=%llu start=%llu len=%llu: %d",
+		  "%s failed, root=%lld inode=%llu start=%llu len=%llu: %pe",
 		  __func__, btrfs_root_id(inode->root), btrfs_ino(inode),
-		  file_pos, len, ret);
+		  file_pos, len, ERR_PTR(ret));
 	return ret;
 }
 
@@ -2285,10 +2286,10 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 	}
 	btrfs_free_path(path);
 	btrfs_err(fs_info,
-"%s failed, root=%llu inode=%llu start=%llu len=%llu cur_offset=%llu oe_cleanup=%llu oe_cleanup_len=%llu untouched_start=%llu untouched_len=%llu: %d",
+"%s failed, root=%llu inode=%llu start=%llu len=%llu cur_offset=%llu oe_cleanup=%llu oe_cleanup_len=%llu untouched_start=%llu untouched_len=%llu: %pe",
 		  __func__, btrfs_root_id(inode->root), btrfs_ino(inode),
 		  start, end + 1 - start, cur_offset, oe_cleanup_start, oe_cleanup_len,
-		  untouched_start, untouched_len, ret);
+		  untouched_start, untouched_len, ERR_PTR(ret));
 	return ret;
 }
 
@@ -3733,7 +3734,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 
 out:
 	if (ret)
-		btrfs_err(fs_info, "could not do orphan cleanup %d", ret);
+		btrfs_err(fs_info, "could not do orphan cleanup %pe", ERR_PTR(ret));
 	return ret;
 }
 
@@ -4035,8 +4036,8 @@ static int btrfs_read_locked_inode(struct btrfs_inode *inode, struct btrfs_path
 		ret = btrfs_load_inode_props(inode, path);
 		if (ret)
 			btrfs_err(fs_info,
-				  "error loading props for ino %llu (root %llu): %d",
-				  btrfs_ino(inode), btrfs_root_id(root), ret);
+				  "error loading props for ino %llu (root %llu): %pe",
+				  btrfs_ino(inode), btrfs_root_id(root), ERR_PTR(ret));
 	}
 
 	/*
@@ -6650,8 +6651,8 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 	}
 	if (ret) {
 		btrfs_err(fs_info,
-			  "error inheriting props for ino %llu (root %llu): %d",
-			  btrfs_ino(BTRFS_I(inode)), btrfs_root_id(root), ret);
+			  "error inheriting props for ino %llu (root %llu): %pe",
+			  btrfs_ino(BTRFS_I(inode)), btrfs_root_id(root), ERR_PTR(ret));
 	}
 
 	/*
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5cb927c6e53d..ebfb258161c8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2839,8 +2839,8 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 		else
 			ret = -ENOENT;
 		btrfs_err(fs_info,
-			  "could not find default diritem for dir %llu: %d",
-			  dir_id, ret);
+			  "could not find default diritem for dir %llu: %pe",
+			  dir_id, ERR_PTR(ret));
 		goto out_free;
 	}
 
diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index 7c60c14e60fa..198d1747c80a 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -279,7 +279,6 @@ void __btrfs_panic(const struct btrfs_fs_info *fs_info, const char *function,
 		   unsigned int line, int error, const char *fmt, ...)
 {
 	char *s_id = "<unknown>";
-	const char *errstr;
 	struct va_format vaf = { .fmt = fmt };
 	va_list args;
 
@@ -289,13 +288,12 @@ void __btrfs_panic(const struct btrfs_fs_info *fs_info, const char *function,
 	va_start(args, fmt);
 	vaf.va = &args;
 
-	errstr = btrfs_decode_error(error);
 	if (fs_info && (btrfs_test_opt(fs_info, PANIC_ON_FATAL_ERROR)))
-		panic(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (errno=%d %s)\n",
-			s_id, function, line, &vaf, error, errstr);
+		panic(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (errno=%d %pe)\n",
+			s_id, function, line, &vaf, error, ERR_PTR(error));
 
-	btrfs_crit(fs_info, "panic in %s:%d: %pV (errno=%d %s)",
-		   function, line, &vaf, error, errstr);
+	btrfs_crit(fs_info, "panic in %s:%d: %pV (errno=%d %pe)",
+		   function, line, &vaf, error, ERR_PTR(error));
 	va_end(args);
 	/* Caller calls BUG() */
 }
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 502fb4a55cb2..210af4d7d4b5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3915,8 +3915,8 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 			ret = PTR_ERR(trans);
 			trans = NULL;
 			btrfs_err(fs_info,
-				  "fail to start transaction for status update: %d",
-				  ret);
+				  "fail to start transaction for status update: %pe",
+				  ERR_PTR(ret));
 		}
 	} else {
 		trans = NULL;
@@ -3931,7 +3931,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 
 		if (ret2 < 0) {
 			ret = ret2;
-			btrfs_err(fs_info, "fail to update qgroup status: %d", ret);
+			btrfs_err(fs_info, "fail to update qgroup status: %pe", ERR_PTR(ret));
 		}
 	}
 	fs_info->qgroup_rescan_running = false;
@@ -3952,7 +3952,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 		btrfs_info(fs_info, "qgroup scan completed%s",
 			ret > 0 ? " (inconsistency flag cleared)" : "");
 	} else {
-		btrfs_err(fs_info, "qgroup scan failed with %d", ret);
+		btrfs_err(fs_info, "qgroup scan failed with %pe", ERR_PTR(ret));
 	}
 }
 
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 90659b287d90..2e4c3efbd02f 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -265,15 +265,15 @@ int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info)
 			if (IS_ERR(trans)) {
 				ret = PTR_ERR(trans);
 				btrfs_err(fs_info,
-			  "failed to join transaction to delete orphan item: %d",
-					  ret);
+			  "failed to join transaction to delete orphan item: %pe",
+					  ERR_PTR(ret));
 				return ret;
 			}
 			ret = btrfs_del_orphan_item(trans, tree_root, root_objectid);
 			btrfs_end_transaction(trans);
 			if (ret) {
 				btrfs_err(fs_info,
-				  "failed to delete root orphan item: %d", ret);
+				  "failed to delete root orphan item: %pe", ERR_PTR(ret));
 				return ret;
 			}
 			continue;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5843254e3aaf..805a1ffc8ab6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -972,7 +972,7 @@ static int btrfs_fill_super(struct super_block *sb,
 
 	ret = open_ctree(sb, fs_devices);
 	if (ret) {
-		btrfs_err(fs_info, "open_ctree failed: %d", ret);
+		btrfs_err(fs_info, "open_ctree failed: %pe", ERR_PTR(ret));
 		return ret;
 	}
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 45149d027740..a1a3043a2cad 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1640,7 +1640,7 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 	ret = btrfs_write_and_wait_transaction(trans);
 	if (unlikely(ret)) {
 		btrfs_err(fs_info,
-"error while writing out transaction during qgroup snapshot accounting: %d", ret);
+"error while writing out transaction during qgroup snapshot accounting: %pe", ERR_PTR(ret));
 		return ret;
 	}
 
@@ -2586,7 +2586,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	ret = btrfs_write_and_wait_transaction(trans);
 	if (unlikely(ret)) {
-		btrfs_err(fs_info, "error while writing out transaction: %d", ret);
+		btrfs_err(fs_info, "error while writing out transaction: %pe", ERR_PTR(ret));
 		mutex_unlock(&fs_info->tree_log_mutex);
 		goto scrub_continue;
 	}
@@ -2747,8 +2747,8 @@ void __cold __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 	WRITE_ONCE(trans->transaction->aborted, error);
 	trace_btrfs_transaction_abort(trans);
 	if (first_hit) {
-		btrfs_err(fs_info, "Transaction %llu aborted (error %d)",
-			  trans->transid, error);
+		btrfs_err(fs_info, "Transaction %llu aborted (%pe)",
+			  trans->transid, ERR_PTR(error));
 		if (error == -ENOSPC)
 			btrfs_dump_space_info_for_trans_abort(fs_info);
 	}
diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 983365a73541..ebada817bd33 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -638,7 +638,7 @@ static int btrfs_end_enable_verity(struct file *filp, const void *desc,
 	rollback_ret = rollback_verity(inode);
 	if (rollback_ret)
 		btrfs_err(inode->root->fs_info,
-			  "failed to rollback verity items: %d", rollback_ret);
+			  "failed to rollback verity items: %pe", ERR_PTR(rollback_ret));
 	return ret;
 }
 
-- 
2.54.0

