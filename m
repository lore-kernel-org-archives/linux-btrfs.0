Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333744;
	b=iS3DwlaPqfNu41r55g0gdFYbEka8fK3CBH5PkIzUdlnlVSbdl/44d2V/ncN7PMyY/0bO
	 4nFS0T6LSv35SikMOWV45vxBZY5jV/LQMj800OHUneA2hN3vaQ35aHk+4I0dh2n84ofDT
	 XxxDpZu0Uu9GPQ0lowCMhK8Br1QZaFbtd1HiIf1Cv2ohviWVzdU49nuB7weg4lgidVaA1
	 ymqhcR4zb2mrI5qTZbesZgSv1ilxQsNJaoP0NOA6NgQqIvEMDlUBdCbTRqt2pfJcC4X+u
	 w82QaWkAd8DiyVzJbFkJ8BLqXnHQAEZMAmep/03uZ1qDalPOqdxeAWOwj8Hz8Vhz53A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333744;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=aMqUbSOAqSw62G392g2WZjxpSh5nc1IT9s9nOVC9JA4=;
	b=3uuhE+yWGPAxtfSjlNM13kqp5DVBbCn/WMybovah0MOk/nF1sf8M0DINS9JESfhG18kM
	 FMfKvkSMEd816aHNfFlxPFRezYET7yywyThbVPLcSyyqc7aqV5bEI0ABHsVqm9b6ZQQ0g
	 R2bnTEQutnqiixANMWas6ibelvwWuTqd+abPZ59dJ64wANGCencREnFzTPKLJMIk/uFsZ
	 J00plCdT14HjrkfFCr7p8PWtDTc0kpkrMDRwK5La7feoP2g9xHzeMErpvKsh2Pp/W8iWN
	 fGJ0VMjg3I+EZyN7BSNMMdkgfZu6PFCV+nCz3dcwXrMOAdakfyi6Ebs5pu/YHTk9Zrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Ov1oZvE9;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Ov1oZvE9;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C1A606A325
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0C1A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Ov1oZvE9;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Ov1oZvE9
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 38F901FCFB
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aMqUbSOAqSw62G392g2WZjxpSh5nc1IT9s9nOVC9JA4=;
	b=Ov1oZvE9VyLTsfjmWa9h5D1rPoKm9bdldGV82fqshOpSL27Yd4YrA0HwUGPoZpJQ3t+v50
	DJMSsZqKZAZKSbNA7evIF/OVLlHoCXf5LLor365y9RUlyMb/0TPGPEa314GKArhWxyeI89
	V4ZFbCGLjqychxIysaEsMfQtjrdYOvU=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aMqUbSOAqSw62G392g2WZjxpSh5nc1IT9s9nOVC9JA4=;
	b=Ov1oZvE9VyLTsfjmWa9h5D1rPoKm9bdldGV82fqshOpSL27Yd4YrA0HwUGPoZpJQ3t+v50
	DJMSsZqKZAZKSbNA7evIF/OVLlHoCXf5LLor365y9RUlyMb/0TPGPEa314GKArhWxyeI89
	V4ZFbCGLjqychxIysaEsMfQtjrdYOvU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2686213432
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0uAiEekZ5GrDGwAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 02/12] btrfs-progs: common, convert, image: use BTRFS_PATH_AUTO_RELEASE() for on-stack paths
Date: Fri, 30 Oct 2026 14:45:09 +1030
Message-ID: <24cf7df68b2ed6355fac31a664ebdb593e4b99fa.1793333606.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793333606.git.wqu@suse.com>
References: <cover.1793333606.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

Convert all on-stack btrfs_path in common/, convert/ and image/ to
BTRFS_PATH_AUTO_RELEASE(), and drop the btrfs_release_path() calls that
only existed as function exit cleanup.

Where the path is only used inside one loop (rescan_uuid_tree(),
record_file_blocks(), truncate_free_ino_items()) the variable is declared
in the loop body, so the path is released as early as possible.

This also fixes the path leaks on error paths of:

- has_running_replace_or_balance()
- truncate_free_ino_items()
- find_next_root()
- rescan_uuid_tree()
- ext2_create_inode()
- update_disk_super_on_device()
- fixup_device_size()

Explicit releases which are not at function exit are kept, including the
ones before close_ctree() in create_metadump() and do_rollback(), as the
path must not outlive the extent buffer cache.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/clear-cache.c     | 73 +++++++++++++---------------------------
 common/root-tree-utils.c | 10 +++---
 convert/main.c           |  9 ++---
 convert/source-ext2.c    |  3 +-
 convert/source-fs.c      |  3 +-
 image/common.c           |  2 +-
 image/image-create.c     |  2 +-
 image/image-restore.c    | 20 ++++-------
 8 files changed, 41 insertions(+), 81 deletions(-)

diff --git a/common/clear-cache.c b/common/clear-cache.c
index e8740eaca085..bfefd325d700 100644
--- a/common/clear-cache.c
+++ b/common/clear-cache.c
@@ -109,7 +109,7 @@ int btrfs_clear_v1_cache(struct btrfs_fs_info *fs_info)
 static int has_reloc_trees(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *tree_root = fs_info->tree_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	unsigned int found = 0;
 	int ret;
@@ -164,7 +164,6 @@ static int has_reloc_trees(struct btrfs_fs_info *fs_info)
 	}
 
 out:
-	btrfs_release_path(&path);
 	if (ret < 0)
 		return ret;
 	return found;
@@ -180,7 +179,7 @@ out:
 int has_running_replace_or_balance(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *dev_root = fs_info->dev_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_dev_replace_item *dri;
 	u64 replace_state;
@@ -198,10 +197,8 @@ int has_running_replace_or_balance(struct btrfs_fs_info *fs_info)
 	ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
 	if (ret < 0)
 		return ret;
-	if (ret > 0) {
-		btrfs_release_path(&path);
+	if (ret > 0)
 		return 0;
-	}
 
 	/*
 	 * We still need to check if the dev_replace item to determine if there
@@ -209,7 +206,6 @@ int has_running_replace_or_balance(struct btrfs_fs_info *fs_info)
 	 */
 	dri = btrfs_item_ptr(path.nodes[0], path.slots[0], struct btrfs_dev_replace_item);
 	replace_state = btrfs_dev_replace_replace_state(path.nodes[0], dri);
-	btrfs_release_path(&path);
 	if (replace_state == BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED ||
 	    replace_state == BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED)
 		return 1;
@@ -384,7 +380,7 @@ static int check_free_space_tree(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_key key = { 0 };
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int ret = 0;
 	bool found_orphan = false;
 
@@ -394,7 +390,7 @@ static int check_free_space_tree(struct btrfs_root *root)
 
 		ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 		if (ret < 0)
-			goto out;
+			return ret;
 
 		/*
 		 * We should be landing on an item, so if we're above the
@@ -409,8 +405,7 @@ static int check_free_space_tree(struct btrfs_root *root)
 			fprintf(stderr,
 			"Failed to find a space info key at %llu [%llu %u %llu]\n",
 				cur_start, key.objectid, key.type, key.offset);
-			ret = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 
 		bg = btrfs_lookup_block_group(fs_info, key.objectid);
@@ -435,8 +430,6 @@ static int check_free_space_tree(struct btrfs_root *root)
 		ret = -EINVAL;
 	else
 		ret = 0;
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -563,7 +556,7 @@ static int check_cache_range(struct btrfs_root *root,
 static int find_next_identity_remap_entry(struct btrfs_fs_info *fs_info, u64 *start, u64 *end)
 {
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	int ret;
 
@@ -572,10 +565,8 @@ static int find_next_identity_remap_entry(struct btrfs_fs_info *fs_info, u64 *st
 	key.offset = 0;
 
 	ret = btrfs_search_slot(NULL, fs_info->remap_root, &key, &path, 0, 0);
-	if (ret < 0) {
-		btrfs_release_path(&path);
+	if (ret < 0)
 		return ret;
-	}
 
 	while (1) {
 		leaf = path.nodes[0];
@@ -591,22 +582,19 @@ static int find_next_identity_remap_entry(struct btrfs_fs_info *fs_info, u64 *st
 		if (key.type == BTRFS_IDENTITY_REMAP_KEY) {
 			*start = key.objectid;
 			*end = key.objectid + key.offset - 1;
-			btrfs_release_path(&path);
 			return 0;
 		}
 
 		path.slots[0]++;
 	}
 
-	btrfs_release_path(&path);
-
 	return -ENOENT;
 }
 
 static int find_next_remap_backref_entry(struct btrfs_fs_info *fs_info, u64 *start, u64 *end)
 {
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	int ret;
 
@@ -615,10 +603,8 @@ static int find_next_remap_backref_entry(struct btrfs_fs_info *fs_info, u64 *sta
 	key.offset = 0;
 
 	ret = btrfs_search_slot(NULL, fs_info->remap_root, &key, &path, 0, 0);
-	if (ret < 0) {
-		btrfs_release_path(&path);
+	if (ret < 0)
 		return ret;
-	}
 
 	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 
@@ -636,15 +622,12 @@ static int find_next_remap_backref_entry(struct btrfs_fs_info *fs_info, u64 *sta
 		if (key.type == BTRFS_REMAP_BACKREF_KEY) {
 			*start = key.objectid;
 			*end = key.objectid + key.offset - 1;
-			btrfs_release_path(&path);
 			return 0;
 		}
 
 		path.slots[0]++;
 	}
 
-	btrfs_release_path(&path);
-
 	return -ENOENT;
 }
 
@@ -886,20 +869,19 @@ int truncate_free_ino_items(struct btrfs_root *root)
 		struct btrfs_file_extent_item *fi;
 		struct btrfs_root *csum_root;
 		struct btrfs_key found_key;
-		struct btrfs_path path = { 0 };
+		BTRFS_PATH_AUTO_RELEASE(path);
 		u8 found_type;
 
 		ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
 		if (ret < 0) {
+			btrfs_release_path(&path);
 			btrfs_abort_transaction(trans, ret);
-			goto out;
+			return ret;
 		} else if (ret > 0) {
 			ret = 0;
 			/* No more items, finished truncating */
-			if (path.slots[0] == 0) {
-				btrfs_release_path(&path);
-				goto out;
-			}
+			if (path.slots[0] == 0)
+				return ret;
 			path.slots[0]--;
 		}
 		fi = NULL;
@@ -910,7 +892,6 @@ int truncate_free_ino_items(struct btrfs_root *root)
 		/* Ino cache also has free space bitmaps in the fs stree */
 		if (found_key.objectid != BTRFS_FREE_INO_OBJECTID &&
 		    found_key.objectid != BTRFS_FREE_SPACE_OBJECTID) {
-			btrfs_release_path(&path);
 			/* Now delete the FREE_SPACE_OBJECTID */
 			if (key.objectid == BTRFS_FREE_INO_OBJECTID) {
 				key.objectid = BTRFS_FREE_SPACE_OBJECTID;
@@ -939,9 +920,9 @@ int truncate_free_ino_items(struct btrfs_root *root)
 						root->objectid,
 						BTRFS_FREE_INO_OBJECTID, 0);
 			if (ret < 0) {
-				btrfs_abort_transaction(trans, ret);
 				btrfs_release_path(&path);
-				goto out;
+				btrfs_abort_transaction(trans, ret);
+				return ret;
 			}
 
 			csum_root = btrfs_csum_root(trans->fs_info,
@@ -950,23 +931,21 @@ int truncate_free_ino_items(struct btrfs_root *root)
 					      extent_disk_bytenr,
 					      extent_num_bytes);
 			if (ret < 0) {
-				btrfs_abort_transaction(trans, ret);
 				btrfs_release_path(&path);
-				goto out;
+				btrfs_abort_transaction(trans, ret);
+				return ret;
 			}
 		}
 
 		ret = btrfs_del_item(trans, root, &path);
 		if (ret < 0) {
-			btrfs_abort_transaction(trans, ret);
 			btrfs_release_path(&path);
-			goto out;
+			btrfs_abort_transaction(trans, ret);
+			return ret;
 		}
-		btrfs_release_path(&path);
 	}
 
 	btrfs_commit_transaction(trans, root);
-out:
 	return ret;
 }
 
@@ -986,7 +965,7 @@ static int find_next_root(struct btrfs_fs_info *fs_info, u64 rootid,
 		.type = BTRFS_ROOT_ITEM_KEY,
 		.offset = 0,
 	};
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int ret;
 
 	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, &path, 0, 0);
@@ -996,16 +975,12 @@ static int find_next_root(struct btrfs_fs_info *fs_info, u64 rootid,
 		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 		if (key.type == BTRFS_ROOT_ITEM_KEY && key.objectid >= rootid) {
 			memcpy(found_key, &key, sizeof(key));
-			ret = 0;
-			goto out;
+			return 0;
 		}
 		ret = btrfs_next_item(fs_info->tree_root, &path);
 		if (ret)
-			goto out;
+			return ret;
 	}
-out:
-	btrfs_release_path(&path);
-	return ret;
 }
 
 int clear_ino_cache_items(struct btrfs_fs_info *fs_info)
diff --git a/common/root-tree-utils.c b/common/root-tree-utils.c
index ad5a9557ff23..bb27a894443b 100644
--- a/common/root-tree-utils.c
+++ b/common/root-tree-utils.c
@@ -139,7 +139,7 @@ int btrfs_link_subvolume(struct btrfs_trans_handle *trans,
 			 int namelen, struct btrfs_root *subvol)
 {
 	struct btrfs_root *tree_root = trans->fs_info->tree_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_inode_item *ii;
 	u64 index;
@@ -159,10 +159,8 @@ int btrfs_link_subvolume(struct btrfs_trans_handle *trans,
 	ret = btrfs_search_slot(NULL, parent_root, &key, &path, 0, 0);
 	if (ret > 0)
 		ret = -ENOENT;
-	if (ret < 0) {
-		btrfs_release_path(&path);
+	if (ret < 0)
 		return ret;
-	}
 	ii = btrfs_item_ptr(path.nodes[0], path.slots[0], struct btrfs_inode_item);
 	imode = btrfs_inode_mode(path.nodes[0], ii);
 	btrfs_release_path(&path);
@@ -337,7 +335,6 @@ static int rescan_uuid_tree(struct btrfs_fs_info *fs_info)
 	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_root *uuid_root = fs_info->uuid_root;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_path path = { 0 };
 	struct btrfs_key key = { 0 };
 	int ret;
 
@@ -356,6 +353,7 @@ static int rescan_uuid_tree(struct btrfs_fs_info *fs_info)
 	while (true) {
 		struct btrfs_key found_key;
 		struct extent_buffer *leaf;
+		BTRFS_PATH_AUTO_RELEASE(path);
 		int slot;
 
 		/* No more subvolume. */
@@ -367,6 +365,7 @@ static int rescan_uuid_tree(struct btrfs_fs_info *fs_info)
 		if (ret < 0) {
 			errno = -ret;
 			error_msg(ERROR_MSG_READ, "iterate subvolumes: %m");
+			btrfs_release_path(&path);
 			btrfs_abort_transaction(trans, ret);
 			return ret;
 		}
@@ -384,7 +383,6 @@ static int rescan_uuid_tree(struct btrfs_fs_info *fs_info)
 			/* No more subvolume. */
 			if (ret > 0) {
 				ret = 0;
-				btrfs_release_path(&path);
 				break;
 			}
 		}
diff --git a/convert/main.c b/convert/main.c
index 2e0b764fab56..0e7f24162947 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -802,7 +802,7 @@ static int create_image(struct btrfs_root *root,
 {
 	struct btrfs_inode_item buf;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct cache_extent *cache;
 	struct cache_tree used_tmp;
@@ -1510,7 +1510,7 @@ static int check_convert_image(struct btrfs_root *image_root, u64 ino,
 			       u64 total_size, char *reserved_ranges[])
 {
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_fs_info *fs_info = image_root->fs_info;
 	u64 checked_bytes = 0;
 	int ret;
@@ -1529,7 +1529,6 @@ static int check_convert_image(struct btrfs_root *image_root, u64 ino,
 	if (ret < 0) {
 		errno = -ret;
 		error("failed to iterate file extents at offset 0: %m");
-		btrfs_release_path(&path);
 		return ret;
 	}
 
@@ -1674,7 +1673,7 @@ static int do_rollback(const char *devname)
 	struct btrfs_root *image_root;
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_dir_item *dir;
 	struct btrfs_inode_item *inode_item;
 	struct btrfs_root_ref *root_ref_item;
@@ -1775,7 +1774,6 @@ static int do_rollback(const char *devname)
 			image_name, strlen(image_name), 0);
 
 	if (!dir || IS_ERR(dir)) {
-		btrfs_release_path(&path);
 		if (dir)
 			ret = PTR_ERR(dir);
 		else
@@ -1793,7 +1791,6 @@ static int do_rollback(const char *devname)
 	ret = btrfs_lookup_inode(NULL, image_root, &path, &key, 0);
 
 	if (ret < 0) {
-		btrfs_release_path(&path);
 		errno = -ret;
 		error("unable to find inode %llu: %m", ino);
 		goto close_fs;
diff --git a/convert/source-ext2.c b/convert/source-ext2.c
index 647e64411c06..3d68bcf5e5c1 100644
--- a/convert/source-ext2.c
+++ b/convert/source-ext2.c
@@ -978,7 +978,7 @@ static int ext2_copy_single_inode(struct btrfs_trans_handle *trans,
 	int s_inode_size;
 	struct btrfs_inode_item btrfs_inode;
 	struct btrfs_key inode_key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 
 	inode_key.objectid = objectid;
 	inode_key.type = BTRFS_INODE_ITEM_KEY;
@@ -1062,7 +1062,6 @@ static int ext2_copy_single_inode(struct btrfs_trans_handle *trans,
 	write_extent_buffer(path.nodes[0], &btrfs_inode,
 			    btrfs_item_ptr_offset(path.nodes[0], path.slots[0]),
 			    sizeof(btrfs_inode));
-	btrfs_release_path(&path);
 	return 0;
 }
 
diff --git a/convert/source-fs.c b/convert/source-fs.c
index 8a296bd9c7f4..cc998d245d96 100644
--- a/convert/source-fs.c
+++ b/convert/source-fs.c
@@ -251,7 +251,6 @@ int record_file_blocks(struct blk_iterate_data *data,
 	int ret = 0;
 	struct btrfs_root *root = data->root;
 	struct btrfs_root *convert_root = data->convert_root;
-	struct btrfs_path path = { 0 };
 	u32 sectorsize = root->fs_info->sectorsize;
 	u64 file_pos = file_block * sectorsize;
 	u64 old_disk_bytenr = disk_block * sectorsize;
@@ -269,6 +268,7 @@ int record_file_blocks(struct blk_iterate_data *data,
 	 */
 	while (cur_off < old_disk_bytenr + num_bytes) {
 		struct btrfs_key key;
+		BTRFS_PATH_AUTO_RELEASE(path);
 		struct btrfs_file_extent_item *fi;
 		struct extent_buffer *node;
 		int slot;
@@ -328,7 +328,6 @@ int record_file_blocks(struct blk_iterate_data *data,
 		 * need to waste CPU cycles now.
 		 */
 	}
-	btrfs_release_path(&path);
 	return ret;
 }
 
diff --git a/image/common.c b/image/common.c
index 77fb95580049..ec8fb29379cc 100644
--- a/image/common.c
+++ b/image/common.c
@@ -148,7 +148,7 @@ int update_disk_super_on_device(struct btrfs_fs_info *info,
 {
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_dev_item *dev_item;
 	struct btrfs_super_block disk_super;
 	char dev_uuid[BTRFS_UUID_SIZE];
diff --git a/image/image-create.c b/image/image-create.c
index 97348f37acaa..09300b167044 100644
--- a/image/image-create.c
+++ b/image/image-create.c
@@ -779,7 +779,7 @@ int create_metadump(const char *input, FILE *out, int num_threads,
 		    int walk_trees, bool dump_data)
 {
 	struct btrfs_root *root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct metadump_struct metadump;
 	int ret;
 	int err = 0;
diff --git a/image/image-restore.c b/image/image-restore.c
index 3d76440599ec..cd74a2d66431 100644
--- a/image/image-restore.c
+++ b/image/image-restore.c
@@ -1506,7 +1506,7 @@ static int remove_all_dev_extents(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root = fs_info->dev_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
 	int slot;
@@ -1531,12 +1531,10 @@ static int remove_all_dev_extents(struct btrfs_trans_handle *trans)
 			if (ret < 0) {
 				errno = -ret;
 				error("failed to search dev tree: %m");
-				goto out;
-			}
-			if (ret > 0) {
-				ret = 0;
-				goto out;
+				return ret;
 			}
+			if (ret > 0)
+				return 0;
 		}
 
 		btrfs_item_key_to_cpu(leaf, &key, slot);
@@ -1547,11 +1545,9 @@ static int remove_all_dev_extents(struct btrfs_trans_handle *trans)
 			errno = -ret;
 			error("failed to delete dev extent %llu, %llu: %m",
 				key.objectid, key.offset);
-			goto out;
+			return ret;
 		}
 	}
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -1653,7 +1649,7 @@ static int fixup_device_size(struct btrfs_trans_handle *trans,
 	struct btrfs_dev_item *dev_item;
 	struct btrfs_dev_extent *dev_ext;
 	struct btrfs_device *dev;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_key key;
@@ -1677,12 +1673,10 @@ static int fixup_device_size(struct btrfs_trans_handle *trans,
 		errno = -ret;
 		error("failed to locate last dev extent of devid %llu: %m",
 			devid);
-		btrfs_release_path(&path);
 		return ret;
 	}
 	if (ret == 0) {
 		error("found invalid dev extent devid %llu offset -1", devid);
-		btrfs_release_path(&path);
 		return -EUCLEAN;
 	}
 	ret = btrfs_previous_item(fs_info->dev_root, &path, devid,
@@ -1693,7 +1687,6 @@ static int fixup_device_size(struct btrfs_trans_handle *trans,
 		errno = -ret;
 		error("failed to locate last dev extent of devid %llu: %m",
 			devid);
-		btrfs_release_path(&path);
 		return ret;
 	}
 
@@ -1776,7 +1769,6 @@ again:
 		path.slots[0]++;
 	}
 
-	btrfs_release_path(&path);
 	return 0;
 }
 
-- 
2.56.0

