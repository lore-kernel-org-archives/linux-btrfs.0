Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333746;
	b=bVP197Ea1uRDXnP2hmCwHCCR/aHYVAWBLgHhq/IWpm8m97oTDEQ8sOq+ZLnDG5W367Fo
	 qaigLSdXT5jH3ju58mOhkKTdal4DsexgbsDIVplzWH+yicaBHZwJk7gksFbDmLa8j97eu
	 XQn3E+xvTB8UeGhUDtGkhySIFKjoBp/FFbkcWCMb4069fBhUJjXXy6ShJQl950rhGMPxi
	 JIzK+ACVtXmyZje5BC92wHkRi5KU2dbLw2y3KpHt9ciVYoa0aMKnwKvnygH4rQLA/ImU1
	 onbJFa6D/uReHF+Nt81Ch9Ti6AEWaIhSttFyMC7IcadX3oV1D6CuqLQmGlJAohqFPWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333746;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=En40Zs8fO5R54FpgN882vMwgFo52twxbfFb4koGXNhs=;
	b=aHilEwcBSn1+B31iMW/gD1ccsZNVOZJM4eOt7WA4WafFbMO1mVCnIwiR5Khvq2gwMd3t
	 P4B0wbtWJyUWlwf7tCnWCu25Mf4N/m4lNuExS0OfM5YBn9WQXE0e/Kz1ob/4mhvNpeiXR
	 v0w+72D11p+EcCkK/S1VxkQEVulJEq2CydjCeiP1Uqkj7tMQauzAcKkeLa8rGwUINsBME
	 5mGv3stJ7qkno806AyXxcW7I6aW2HYA8SAX1OE1Fl5m1uKX18DD2P5WW8P6yRM9tDlXm/
	 Bvzj2G4wL4mRtZ0nbR5vKLCDRZhQUoqWo8R9MKGBamuFHI4dYjSYYmWW2JGBmAWDsIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=stSTcA0G;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=stSTcA0G;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0709606A31D
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0709606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=stSTcA0G;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=stSTcA0G
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D0033223FE
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=En40Zs8fO5R54FpgN882vMwgFo52twxbfFb4koGXNhs=;
	b=stSTcA0G/ykGdwnGXhKrkTbuv1k+e2iyOmbDxyYXXhMbDH60m4EjWx/+XFjwrdde6OxInM
	Q9tklUgO7U5B1Or+U+xxgmQdvX2yVD933nJ7ZvjVgePzDp4rgPsLxbIgTdXcXzhoDMNLev
	aUuwrDvA9LmeM2KT440ZsxAa4gozbo4=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=En40Zs8fO5R54FpgN882vMwgFo52twxbfFb4koGXNhs=;
	b=stSTcA0G/ykGdwnGXhKrkTbuv1k+e2iyOmbDxyYXXhMbDH60m4EjWx/+XFjwrdde6OxInM
	Q9tklUgO7U5B1Or+U+xxgmQdvX2yVD933nJ7ZvjVgePzDp4rgPsLxbIgTdXcXzhoDMNLev
	aUuwrDvA9LmeM2KT440ZsxAa4gozbo4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA2A313432
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0uAiEekZ5GrDGwAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:42 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 03/12] btrfs-progs: mkfs: use BTRFS_PATH_AUTO_RELEASE() for on-stack paths
Date: Fri, 30 Oct 2026 14:45:10 +1030
Message-ID: <9a7d56bd79a29db41e81a8638ff4a00ace5fe07a.1793333606.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

Convert all on-stack btrfs_path in mkfs/ to BTRFS_PATH_AUTO_RELEASE(),
and drop the btrfs_release_path() calls that only existed as function
exit cleanup.

For the block group cleanup loop in the mkfs allocation fixup code, the
path is only used inside the loop body, so declare it there and let it be
released at the end of each iteration, before the transaction commit.

This also fixes the path leaks on error paths of:

- __recow_root()
- setup_quota_root()
- discard_free_space()

Explicit releases which are not at function exit are kept.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c    | 42 ++++++++++++++----------------------------
 mkfs/rootdir.c | 36 ++++++++++++------------------------
 2 files changed, 26 insertions(+), 52 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index b7f0bb4521e0..d61af04e055e 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -266,7 +266,7 @@ err:
 
 static int __recow_root(struct btrfs_trans_handle *trans, struct btrfs_root *root)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 
@@ -299,7 +299,7 @@ static int __recow_root(struct btrfs_trans_handle *trans, struct btrfs_root *roo
 		/* This will ensure this leaf and all its parent get COWed */
 		ret = btrfs_search_slot(trans, root, &key, &path, 0, 1);
 		if (ret < 0)
-			goto out;
+			return ret;
 		ret = 0;
 		btrfs_item_key_to_cpu(path.nodes[0], &found_key, 0);
 		UASSERT(btrfs_comp_cpu_keys(&key, &found_key) == 0);
@@ -307,15 +307,10 @@ static int __recow_root(struct btrfs_trans_handle *trans, struct btrfs_root *roo
 next:
 		ret = btrfs_next_leaf(root, &path);
 		if (ret < 0)
-			goto out;
-		if (ret > 0) {
-			ret = 0;
-			goto out;
-		}
+			return ret;
+		if (ret > 0)
+			return 0;
 	}
-out:
-	btrfs_release_path(&path);
-	return ret;
 }
 
 static int recow_global_roots(struct btrfs_trans_handle *trans)
@@ -712,7 +707,6 @@ static int cleanup_temp_chunks(struct btrfs_fs_info *fs_info,
 	struct btrfs_root *root = btrfs_block_group_root(fs_info);
 	struct btrfs_key key;
 	struct btrfs_key found_key;
-	struct btrfs_path path = { 0 };
 	int ret = 0;
 
 	trans = btrfs_start_transaction(root, 1);
@@ -728,6 +722,8 @@ static int cleanup_temp_chunks(struct btrfs_fs_info *fs_info,
 	key.offset = 0;
 
 	while (1) {
+		BTRFS_PATH_AUTO_RELEASE(path);
+
 		/*
 		 * as the rest of the loop may modify the tree, we need to
 		 * start a new search each time.
@@ -789,7 +785,6 @@ static int cleanup_temp_chunks(struct btrfs_fs_info *fs_info,
 				  BTRFS_BLOCK_GROUP_DATA))
 				alloc->mixed -= found_key.offset;
 		}
-		btrfs_release_path(&path);
 		key.objectid = found_key.objectid + found_key.offset;
 	}
 out:
@@ -800,7 +795,6 @@ out:
 			error_msg(ERROR_MSG_COMMIT_TRANS, "%m");
 		}
 	}
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -887,7 +881,7 @@ static int insert_qgroup_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_fs_info *fs_info,
 			       u64 qgroupid)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_root *quota_root = fs_info->quota_root;
 	struct btrfs_key key;
 	int ret;
@@ -912,7 +906,6 @@ static int insert_qgroup_items(struct btrfs_trans_handle *trans,
 	key.offset = qgroupid;
 	ret = btrfs_insert_empty_item(trans, quota_root, &path, &key,
 				      sizeof(struct btrfs_qgroup_limit_item));
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -929,7 +922,7 @@ static int touch_root_subvol(struct btrfs_fs_info *fs_info)
 	};
 	struct extent_buffer *leaf;
 	int slot;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int ret;
 
 	trans = btrfs_start_transaction(fs_info->fs_root, 1);
@@ -952,11 +945,9 @@ static int touch_root_subvol(struct btrfs_fs_info *fs_info)
 		error_msg(ERROR_MSG_COMMIT_TRANS, "%m");
 		return ret;
 	}
-	btrfs_release_path(&path);
 	return 0;
 fail:
 	btrfs_abort_transaction(trans, ret);
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -965,7 +956,7 @@ static int setup_quota_root(struct btrfs_fs_info *fs_info)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_qgroup_status_item *qsi;
 	struct btrfs_root *quota_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int qgroup_repaired = 0;
 	bool simple = btrfs_fs_incompat(fs_info, SIMPLE_QUOTA);
@@ -1405,7 +1396,7 @@ static int discard_all_devices(struct btrfs_fs_info *fs_info)
 static int discard_free_space(struct btrfs_fs_info *fs_info, u64 metadata_profile)
 {
 	struct btrfs_root *free_space_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	int ret;
 	struct btrfs_key key = {
@@ -1453,7 +1444,7 @@ static int discard_free_space(struct btrfs_fs_info *fs_info, u64 metadata_profil
 		if (key.type == BTRFS_FREE_SPACE_EXTENT_KEY) {
 			ret = queue_discard_logical(fs_info, key.objectid, key.offset);
 			if (ret < 0)
-				goto out;
+				return ret;
 		} else if (key.type == BTRFS_FREE_SPACE_BITMAP_KEY) {
 			int size, nrbits;
 			void *bitmap;
@@ -1462,8 +1453,7 @@ static int discard_free_space(struct btrfs_fs_info *fs_info, u64 metadata_profil
 			size = btrfs_item_size(leaf, path.slots[0]);
 			bitmap = malloc(size);
 			if (!bitmap) {
-				ret = -ENOMEM;
-				goto out;
+				return -ENOMEM;
 			}
 
 			read_extent_buffer(leaf, bitmap,
@@ -1483,7 +1473,7 @@ static int discard_free_space(struct btrfs_fs_info *fs_info, u64 metadata_profil
 				ret = queue_discard_logical(fs_info, addr, length);
 				if (ret < 0) {
 					free(bitmap);
-					goto out;
+					return ret;
 				}
 
 				start_bit = find_next_bit_le(bitmap, nrbits, end_bit);
@@ -1498,10 +1488,6 @@ static int discard_free_space(struct btrfs_fs_info *fs_info, u64 metadata_profil
 
 	/* Every discard range is properly queued. Now submit the real discard request. */
 	return discard_all_devices(fs_info);
-
-out:
-	btrfs_release_path(&path);
-	return ret;
 }
 
 int BOX_MAIN(mkfs)(int argc, char **argv)
diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index 0b5dbee12cca..47837ab067fa 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -1682,7 +1682,7 @@ static int update_inode_item(struct btrfs_trans_handle *trans,
 			     const struct btrfs_inode_item *inode_item,
 			     u64 ino)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key = {
 		.objectid = ino,
 		.type = BTRFS_INODE_ITEM_KEY,
@@ -1694,14 +1694,11 @@ static int update_inode_item(struct btrfs_trans_handle *trans,
 	ret = btrfs_lookup_inode(trans, root, &path, &key, 1);
 	if (ret > 0)
 		ret = -ENOENT;
-	if (ret < 0) {
-		btrfs_release_path(&path);
+	if (ret < 0)
 		return ret;
-	}
 	item_ptr_off = btrfs_item_ptr_offset(path.nodes[0], path.slots[0]);
 	write_extent_buffer(path.nodes[0], inode_item, item_ptr_off, sizeof(*inode_item));
 	btrfs_mark_buffer_dirty(path.nodes[0]);
-	btrfs_release_path(&path);
 	return 0;
 }
 
@@ -1850,7 +1847,7 @@ out:
 static int read_inode_item(struct btrfs_root *root, struct btrfs_inode_item *inode_item,
 			   u64 ino)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 
@@ -1862,14 +1859,12 @@ static int read_inode_item(struct btrfs_root *root, struct btrfs_inode_item *ino
 	if (ret > 0)
 		ret = -ENOENT;
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	read_extent_buffer(path.nodes[0], inode_item,
 			   btrfs_item_ptr_offset(path.nodes[0], path.slots[0]),
 			   sizeof(*inode_item));
-out:
-	btrfs_release_path(&path);
-	return ret;
+	return 0;
 }
 
 static int ftw_add_inode(const char *full_path, const struct stat *st,
@@ -2123,7 +2118,7 @@ static int ftw_add_inode(const char *full_path, const struct stat *st,
 
 static int set_default_subvolume(struct btrfs_trans_handle *trans)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_dir_item *di;
 	struct btrfs_key location;
 	struct extent_buffer *leaf;
@@ -2134,8 +2129,6 @@ static int set_default_subvolume(struct btrfs_trans_handle *trans)
 				   btrfs_super_root_dir(trans->fs_info->super_copy),
 				   "default", 7, 1);
 	if (IS_ERR_OR_NULL(di)) {
-		btrfs_release_path(&path);
-
 		if (di)
 			return PTR_ERR(di);
 		else
@@ -2388,7 +2381,7 @@ static int get_device_extent_end(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_root *dev_root = fs_info->dev_root;
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_dev_extent *de;
 	int ret;
 
@@ -2399,29 +2392,25 @@ static int get_device_extent_end(struct btrfs_fs_info *fs_info,
 	ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
 	if (ret == 0) {
 		error("DEV_EXTENT for devid %llu not found", devid);
-		ret = -EUCLEAN;
-		goto out;
+		return -EUCLEAN;
 	}
 
 	ret = btrfs_previous_item(dev_root, &path, devid, BTRFS_DEV_EXTENT_KEY);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	/* No dev_extent at all, not really possible for rootdir case */
 	if (ret > 0) {
 		*size_ret = 0;
-		ret = -EUCLEAN;
-		goto out;
+		return -EUCLEAN;
 	}
 
 	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 	de = btrfs_item_ptr(path.nodes[0], path.slots[0],
 			    struct btrfs_dev_extent);
 	*size_ret = key.offset + btrfs_dev_extent_length(path.nodes[0], de);
-out:
-	btrfs_release_path(&path);
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -2439,7 +2428,7 @@ static int set_device_size(struct btrfs_fs_info *fs_info,
 	struct btrfs_root *chunk_root = fs_info->chunk_root;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_dev_item *di;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 
@@ -2486,7 +2475,6 @@ static int set_device_size(struct btrfs_fs_info *fs_info,
 		errno = -ret;
 		error_msg(ERROR_MSG_COMMIT_TRANS, "%m");
 	}
-	btrfs_release_path(&path);
 	return ret;
 
 err:
-- 
2.56.0

