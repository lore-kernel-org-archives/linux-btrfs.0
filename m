Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333754;
	b=wAeYlAXZW7gd3i2BdEOj+SLH74LoYg3l953moicuMXHPgZOXzH77cMw66qtvpRQFTwmR
	 ZYbDcU6nQIk3WGH0x/rd/8QMqbUt/nFr7dDsPY4yP5aAX/RZOIgFhN0eNqnv9eHoOeuxh
	 N/XMtzg/W0Q62XeX1dlWaNjfD1zbjo7v/tFs/in/8Qlj3RM4sF1yS0RjazgGfIoQwLwT0
	 5afJ3YxovZ1Eo9jrG92ihm/7nYtIyTu328Wzvpjt10s/zz6//CijZWoC7nviUBvtZ1pCW
	 mhRJTzdX7df32+A+875OSDmtLWEz2ZK9LjjY29cZvUt+IedWdIjo+qjWkCRDhmKyLfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333754;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=hUX2z6DM9lKFSb1DcJUwo7JaQzGeS1ukOnfLf033tSs=;
	b=v2Cx+VrJ892S1gDSMfxFelg58xnvBP4DqgYSGScGOUWUwqmkZunvYD3rA4ewSBfEkArW
	 OUDR4TW7/qZgAG8PcbK6AjyLtu5viMokUvaOfDAJLIpu7reyCacoczUvyOtMVvtI4TNKh
	 vWzEGDB7dsv8OvEsVPnJjIlflH0V1q4juZJIFMUM3NwwXNKQW5/yizXDpJeuRk2SJkPIG
	 TbV30DdGROAkB1shFtF0t7VQJAmuzmTBQxcttNq5dTFZEQRVr4osgX0sNVKL9a+263oNa
	 oEXULGIJxCi3b/4PNOjIOKFLSt/E4OvpSf2VDyGDomNrxLCUvPB9KEUZAqD8Zsnx3xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=f7hvkSqx;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=f7hvkSqx;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF500606A321
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF500606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=f7hvkSqx;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=f7hvkSqx
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 304FC223FE
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hUX2z6DM9lKFSb1DcJUwo7JaQzGeS1ukOnfLf033tSs=;
	b=f7hvkSqx1uN+8N3v+80lcQXVZPQF91mP8wH1VRfMUxBrZm31Oj1VEbVgn9oR9HFQ3yGbt0
	CsgZNU9izHLFVIe1eKdrRZEoEV//DoiP/B1kwmxa8MWzDjPdiMnKgpk8/i4mXOd3OjCCkS
	hfmjICaXe8UKr06J2g88SwFAeJ+CvC0=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=f7hvkSqx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hUX2z6DM9lKFSb1DcJUwo7JaQzGeS1ukOnfLf033tSs=;
	b=f7hvkSqx1uN+8N3v+80lcQXVZPQF91mP8wH1VRfMUxBrZm31Oj1VEbVgn9oR9HFQ3yGbt0
	CsgZNU9izHLFVIe1eKdrRZEoEV//DoiP/B1kwmxa8MWzDjPdiMnKgpk8/i4mXOd3OjCCkS
	hfmjICaXe8UKr06J2g88SwFAeJ+CvC0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1BAAD13432
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0uAiEekZ5GrDGwAAD6G6ig:T9
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:50 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/12] btrfs-progs: check: use BTRFS_PATH_AUTO_RELEASE() for original mode
Date: Fri, 30 Oct 2026 14:45:15 +1030
Message-ID: <93ee74279e16c501e3e02d0598aaf4a6c371e5da.1793333606.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 304FC223FE
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email]
X-Spam-Score: -12.01

Convert all on-stack btrfs_path in check/main.c to
BTRFS_PATH_AUTO_RELEASE(), and drop the btrfs_release_path() calls that
only existed as function exit cleanup.

This also fixes the path leaks on error paths of:

- is_child_root()
- check_owner_ref()
- check_range_csummed()
- check_log_root()
- parse_tree_roots()

Explicit releases which are not at function exit are kept, including the
ones in check_fs_root() and repair_root_items() which must happen before
the repair routines modify the trees.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 218 +++++++++++++++++----------------------------------
 1 file changed, 71 insertions(+), 147 deletions(-)

diff --git a/check/main.c b/check/main.c
index 322855173d1c..b3641cd39169 100644
--- a/check/main.c
+++ b/check/main.c
@@ -906,7 +906,7 @@ static void maybe_free_inode_rec(struct cache_tree *inode_cache,
 
 static int check_orphan_item(struct btrfs_root *root, u64 ino)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 
@@ -1372,7 +1372,7 @@ static int leave_shared_node(struct btrfs_root *root,
 static int is_child_root(struct btrfs_root *root, u64 parent_root_id,
 			 u64 child_root_id)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
 	int has_parent = 0;
@@ -1413,15 +1413,12 @@ static int is_child_root(struct btrfs_root *root, u64 parent_root_id,
 
 		has_parent = 1;
 
-		if (key.offset == parent_root_id) {
-			btrfs_release_path(&path);
+		if (key.offset == parent_root_id)
 			return 1;
-		}
 
 		path.slots[0]++;
 	}
 out:
-	btrfs_release_path(&path);
 	if (ret < 0)
 		return ret;
 	return has_parent ? 0 : 2;
@@ -2231,7 +2228,7 @@ static int add_missing_dir_index(struct btrfs_root *root,
 				 struct inode_record *rec,
 				 struct inode_backref *backref)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_trans_handle *trans;
 	struct btrfs_dir_item *dir_item;
 	struct extent_buffer *leaf;
@@ -2295,7 +2292,7 @@ static int delete_dir_index(struct btrfs_root *root,
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_dir_item *di;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int ret = 0;
 
 	trans = btrfs_start_transaction(root, 1);
@@ -2713,7 +2710,7 @@ out:
  */
 static int find_normal_file_extent(struct btrfs_root *root, u64 ino)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_file_extent_item *fi;
@@ -2725,16 +2722,12 @@ static int find_normal_file_extent(struct btrfs_root *root, u64 ino)
 	key.offset = 0;
 
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
-	if (ret < 0) {
-		ret = 0;
-		goto out;
-	}
+	if (ret < 0)
+		return 0;
 	if (ret && path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
 		ret = btrfs_next_leaf(root, &path);
-		if (ret) {
-			ret = 0;
-			goto out;
-		}
+		if (ret)
+			return 0;
 	}
 	while (1) {
 		btrfs_item_key_to_cpu(path.nodes[0], &found_key,
@@ -2745,13 +2738,9 @@ static int find_normal_file_extent(struct btrfs_root *root, u64 ino)
 		fi = btrfs_item_ptr(path.nodes[0], path.slots[0],
 				    struct btrfs_file_extent_item);
 		type = btrfs_file_extent_type(path.nodes[0], fi);
-		if (type != BTRFS_FILE_EXTENT_INLINE) {
-			ret = 1;
-			goto out;
-		}
+		if (type != BTRFS_FILE_EXTENT_INLINE)
+			return 1;
 	}
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -2932,7 +2921,7 @@ static int repair_mismatch_dir_hash(struct btrfs_trans_handle *trans,
 static int btrfs_delete_item(struct btrfs_trans_handle *trans,
 		struct btrfs_root *root, struct btrfs_key *key)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int ret = 0;
 
 	ret = btrfs_search_slot(trans, root, key, &path, -1, 1);
@@ -2940,13 +2929,11 @@ static int btrfs_delete_item(struct btrfs_trans_handle *trans,
 		if (ret > 0)
 			ret = -ENOENT;
 
-		btrfs_release_path(&path);
 		return ret;
 	}
 
 	ret = btrfs_del_item(trans, root, &path);
 
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -2954,7 +2941,7 @@ static int find_file_extent_offset_by_bytenr(struct btrfs_root *root,
 		u64 owner, u64 bytenr, u64 *offset_ret)
 {
 	int ret = 0;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_file_extent_item *fi;
@@ -2970,7 +2957,6 @@ static int find_file_extent_offset_by_bytenr(struct btrfs_root *root,
 	if (ret) {
 		if (ret > 0)
 			ret = -ENOENT;
-		btrfs_release_path(&path);
 		return ret;
 	}
 
@@ -2981,10 +2967,8 @@ static int find_file_extent_offset_by_bytenr(struct btrfs_root *root,
 	key.offset = 0;
 
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
-	if (ret < 0) {
-		btrfs_release_path(&path);
+	if (ret < 0)
 		return ret;
-	}
 
 	while (1) {
 		leaf = path.nodes[0];
@@ -3019,7 +3003,6 @@ static int find_file_extent_offset_by_bytenr(struct btrfs_root *root,
 		path.slots[0]++;
 	}
 
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -3133,7 +3116,7 @@ static int repair_inode_gen_original(struct btrfs_trans_handle *trans,
 static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 {
 	struct btrfs_trans_handle *trans;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int ret = 0;
 
 	/* unaligned extent recs always lead to csum missing error, clean it */
@@ -3193,7 +3176,6 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 	if (!ret && rec->errors & I_ERR_INVALID_GEN)
 		ret = repair_inode_gen_original(trans, root, &path, rec);
 	btrfs_commit_transaction(trans, root);
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -3727,7 +3709,7 @@ static int repair_btree(struct btrfs_root *root,
 			struct cache_tree *corrupt_blocks)
 {
 	struct btrfs_trans_handle *trans;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_corrupt_block *corrupt;
 	struct cache_extent *cache;
 	struct btrfs_key key;
@@ -3797,7 +3779,6 @@ static int repair_btree(struct btrfs_root *root,
 	}
 out:
 	btrfs_commit_transaction(trans, root);
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -3811,7 +3792,7 @@ static int check_fs_root(struct btrfs_root *root,
 	int wret;
 	int level;
 	u64 super_generation;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct shared_node root_node;
 	struct root_record *rec;
 	struct btrfs_root_item *root_item = &root->root_item;
@@ -3989,7 +3970,7 @@ skip_walking:
 
 static int check_fs_roots(struct cache_tree *root_cache)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct walk_control wc;
 	struct extent_buffer *leaf, *tree_node;
@@ -4093,7 +4074,6 @@ next:
 		path.slots[0]++;
 	}
 out:
-	btrfs_release_path(&path);
 	if (err)
 		free_extent_cache_tree(&wc.shared);
 	if (!cache_tree_empty(&wc.shared))
@@ -4418,7 +4398,7 @@ static bool check_owner_ref(struct btrfs_root *root,
 	struct tree_backref *back;
 	struct btrfs_root *ref_root;
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *parent;
 	int level;
 	bool found = false;
@@ -4468,7 +4448,6 @@ static bool check_owner_ref(struct btrfs_root *root,
 							path.slots[level + 1]))
 		found = true;
 
-	btrfs_release_path(&path);
 	return !found;
 }
 
@@ -4714,7 +4693,7 @@ static int try_to_fix_bad_block(struct btrfs_root *root,
 	struct ulist *roots;
 	struct ulist_node *node;
 	struct btrfs_root *search_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct ulist_iterator iter;
 	struct btrfs_key root_key, key;
 	int ret;
@@ -4777,7 +4756,6 @@ static int try_to_fix_bad_block(struct btrfs_root *root,
 		btrfs_commit_transaction(trans, search_root);
 	}
 	ulist_free(roots);
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -6021,7 +5999,7 @@ static int check_extent_exists(struct btrfs_root *root, u64 bytenr,
 			       u64 num_bytes)
 {
 	struct btrfs_root *extent_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
 	int ret;
@@ -6036,7 +6014,6 @@ again:
 				0, 0);
 	if (ret < 0) {
 		fprintf(stderr, "Error looking up extent record %d\n", ret);
-		btrfs_release_path(&path);
 		return ret;
 	} else if (ret) {
 		if (path.slots[0] > 0) {
@@ -6083,7 +6060,6 @@ again:
 			if (ret < 0) {
 				fprintf(stderr, "Error going to next leaf "
 					"%d\n", ret);
-				btrfs_release_path(&path);
 				return ret;
 			} else if (ret) {
 				break;
@@ -6155,13 +6131,12 @@ out:
 		ret = 1;
 	}
 
-	btrfs_release_path(&path);
 	return ret;
 }
 
 static int check_csum_root(struct btrfs_root *root)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
 	u64 last_data_end = 0;
@@ -6188,7 +6163,6 @@ static int check_csum_root(struct btrfs_root *root)
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 	if (ret < 0) {
 		fprintf(stderr, "Error searching csum tree %d\n", ret);
-		btrfs_release_path(&path);
 		return ret;
 	}
 
@@ -6276,7 +6250,6 @@ skip_csum_check:
 		path.slots[0]++;
 	}
 
-	btrfs_release_path(&path);
 	return errors;
 }
 
@@ -7640,7 +7613,7 @@ static int delete_duplicate_records(struct btrfs_root *root,
 {
 	struct btrfs_trans_handle *trans;
 	LIST_HEAD(delete_list);
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_record *tmp, *good, *n;
 	int nr_del = 0;
 	int ret = 0, err;
@@ -7726,8 +7699,6 @@ out:
 		free(tmp);
 	}
 
-	btrfs_release_path(&path);
-
 	if (!ret && !nr_del)
 		rec->num_duplicates = 0;
 
@@ -7743,7 +7714,7 @@ static int __find_possible_backrefs(struct btrfs_root *root,
 		u64 *bytes_ret)
 {
 	int ret = 0;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_file_extent_item *fi;
@@ -7758,10 +7729,8 @@ static int __find_possible_backrefs(struct btrfs_root *root,
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 	if (ret > 0)
 		ret = -ENOENT;
-	if (ret) {
-		btrfs_release_path(&path);
+	if (ret)
 		return ret;
-	}
 
 	btrfs_release_path(&path);
 
@@ -7770,10 +7739,8 @@ static int __find_possible_backrefs(struct btrfs_root *root,
 	key.offset = 0;
 
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
-	if (ret < 0) {
-		btrfs_release_path(&path);
+	if (ret < 0)
 		return ret;
-	}
 
 	while (1) {
 		leaf = path.nodes[0];
@@ -7811,7 +7778,6 @@ static int __find_possible_backrefs(struct btrfs_root *root,
 		path.slots[0]++;
 	}
 
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -7904,7 +7870,7 @@ static int fixup_extent_refs(struct cache_tree *extent_cache,
 {
 	struct btrfs_trans_handle *trans = NULL;
 	int ret;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct cache_extent *cache;
 	struct extent_backref *back, *tmp;
 	int allocated = 0;
@@ -7981,7 +7947,6 @@ out:
 	if (!ret)
 		fprintf(stderr, "Repaired extent references for %llu\n", rec->start);
 
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -7989,7 +7954,7 @@ static int fixup_extent_flags(struct extent_record *rec)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = btrfs_extent_root(gfs_info, rec->start);
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_extent_item *ei;
 	struct btrfs_key key;
 	u64 flags;
@@ -8058,7 +8023,7 @@ static int prune_one_block(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_root *extent_root;
 	int ret;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *eb;
 	u64 found;
 	int slot;
@@ -8074,13 +8039,11 @@ again:
 				-1, 1);
 
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	eb = path.nodes[level];
-	if (!eb) {
-		ret = -ENOENT;
-		goto out;
-	}
+	if (!eb)
+		return -ENOENT;
 
 	/*
 	 * hopefully the search gave us the block we want to prune,
@@ -8104,8 +8067,7 @@ again:
 	 * TODO: search all the nodes for pointers to this block
 	 */
 	if (eb == extent_root->node) {
-		ret = -ENOENT;
-		goto out;
+		return -ENOENT;
 	} else {
 		level++;
 		btrfs_release_path(&path);
@@ -8115,9 +8077,6 @@ again:
 del_ptr:
 	printk("deleting pointer to block %llu\n", corrupt->cache.start);
 	btrfs_del_ptr(trans, extent_root, &path, level, slot);
-
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -8248,7 +8207,7 @@ static int record_unaligned_extent_rec(struct extent_record *rec)
 static int repair_extent_item_generation(struct extent_record *rec)
 {
 	struct btrfs_trans_handle *trans;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_extent_item *ei;
 	struct btrfs_root *extent_root = btrfs_extent_root(gfs_info,
@@ -9066,7 +9025,7 @@ static int check_block_groups(struct block_group_tree *bg_cache)
 static int parse_tree_roots(struct list_head *normal_trees,
 			    struct list_head *dropping_trees)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_root_item ri;
@@ -9079,7 +9038,7 @@ static int parse_tree_roots(struct list_head *normal_trees,
 	key.offset = 0;
 	ret = btrfs_search_slot(NULL, gfs_info->tree_root, &key, &path, 0, 0);
 	if (ret < 0)
-		goto out;
+		return ret;
 	while (1) {
 		leaf = path.nodes[0];
 		slot = path.slots[0];
@@ -9125,8 +9084,6 @@ static int parse_tree_roots(struct list_head *normal_trees,
 		path.slots[0]++;
 	}
 
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -9147,7 +9104,7 @@ static int check_zoned_active_zones(void)
 
 	list_for_each_entry(dev, &gfs_info->fs_devices->devices, dev_list) {
 		struct btrfs_zoned_device_info *zinfo = dev->zone_info;
-		struct btrfs_path path = { 0 };
+		BTRFS_PATH_AUTO_RELEASE(path);
 		struct btrfs_key key;
 		unsigned long *covered;
 		int shift;
@@ -9175,7 +9132,6 @@ static int check_zoned_active_zones(void)
 		key.offset = 0;
 		ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
 		if (ret < 0) {
-			btrfs_release_path(&path);
 			free(covered);
 			return ret;
 		}
@@ -9187,7 +9143,6 @@ static int check_zoned_active_zones(void)
 			if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
 				ret = btrfs_next_leaf(dev_root, &path);
 				if (ret < 0) {
-					btrfs_release_path(&path);
 					free(covered);
 					return ret;
 				}
@@ -9283,7 +9238,7 @@ static int check_zoned(void)
  */
 static int check_dev_extents(void)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_root *dev_root = gfs_info->dev_root;
 	int ret;
@@ -9298,19 +9253,17 @@ static int check_dev_extents(void)
 	if (ret < 0) {
 		errno = -ret;
 		error("failed to search device tree: %m");
-		goto out;
+		return ret;
 	}
 	if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
 		ret = btrfs_next_leaf(dev_root, &path);
 		if (ret < 0) {
 			errno = -ret;
 			error("failed to find next leaf: %m");
-			goto out;
-		}
-		if (ret > 0) {
-			ret = 0;
-			goto out;
+			return ret;
 		}
+		if (ret > 0)
+			return 0;
 	}
 
 	while (1) {
@@ -9332,23 +9285,20 @@ static int check_dev_extents(void)
 		dev = btrfs_find_device(gfs_info, devid, NULL, NULL);
 		if (!dev) {
 			error("failed to find device with devid %llu", devid);
-			ret = -EUCLEAN;
-			goto out;
+			return -EUCLEAN;
 		}
 		if (prev_devid == devid && prev_dev_ext_end > physical_offset) {
 			error(
 "dev extent devid %llu physical offset %llu overlap with previous dev extent end %llu",
 			      devid, physical_offset, prev_dev_ext_end);
-			ret = -EUCLEAN;
-			goto out;
+			return -EUCLEAN;
 		}
 		if (physical_offset + physical_len > dev->total_bytes) {
 			error(
 "dev extent devid %llu physical offset %llu len %llu is beyond device boundary %llu",
 			      devid, physical_offset, physical_len,
 			      dev->total_bytes);
-			ret = -EUCLEAN;
-			goto out;
+			return -EUCLEAN;
 		}
 		prev_devid = devid;
 		prev_dev_ext_end = physical_offset + physical_len;
@@ -9357,15 +9307,13 @@ static int check_dev_extents(void)
 		if (ret < 0) {
 			errno = -ret;
 			error("failed to find next leaf: %m");
-			goto out;
+			return ret;
 		}
 		if (ret > 0) {
 			ret = 0;
 			break;
 		}
 	}
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -9660,7 +9608,7 @@ static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 static int reset_block_groups(void)
 {
 	struct btrfs_block_group *cache;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	struct btrfs_chunk *chunk;
 	struct btrfs_key key;
@@ -9671,10 +9619,8 @@ static int reset_block_groups(void)
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 	key.offset = 0;
 	ret = btrfs_search_slot(NULL, gfs_info->chunk_root, &key, &path, 0, 0);
-	if (ret < 0) {
-		btrfs_release_path(&path);
+	if (ret < 0)
 		return ret;
-	}
 
 	/*
 	 * We do this in case the block groups were screwed up and had alloc
@@ -9689,10 +9635,8 @@ static int reset_block_groups(void)
 	while (1) {
 		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
 			ret = btrfs_next_leaf(gfs_info->chunk_root, &path);
-			if (ret < 0) {
-				btrfs_release_path(&path);
+			if (ret < 0)
 				return ret;
-			}
 			if (ret) {
 				ret = 0;
 				break;
@@ -9723,14 +9667,13 @@ static int reset_block_groups(void)
 		start = cache->start + cache->length;
 	}
 
-	btrfs_release_path(&path);
 	return 0;
 }
 
 static int reset_balance(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_root *root = gfs_info->tree_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
 	int del_slot, del_nr = 0;
@@ -9747,12 +9690,12 @@ static int reset_balance(struct btrfs_trans_handle *trans)
 		if (!ret)
 			goto reinit_data_reloc;
 		else
-			goto out;
+			return ret;
 	}
 
 	ret = btrfs_del_item(trans, root, &path);
 	if (ret)
-		goto out;
+		return ret;
 	btrfs_release_path(&path);
 
 	key.objectid = BTRFS_TREE_RELOC_OBJECTID;
@@ -9760,7 +9703,7 @@ static int reset_balance(struct btrfs_trans_handle *trans)
 	key.offset = 0;
 	ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
 	if (ret < 0)
-		goto out;
+		return ret;
 	while (1) {
 		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
 			if (!found)
@@ -9771,7 +9714,7 @@ static int reset_balance(struct btrfs_trans_handle *trans)
 						      del_slot, del_nr);
 				del_nr = 0;
 				if (ret)
-					goto out;
+					return ret;
 			}
 			key.offset++;
 			btrfs_release_path(&path);
@@ -9780,7 +9723,7 @@ static int reset_balance(struct btrfs_trans_handle *trans)
 			ret = btrfs_search_slot(trans, root, &key, &path,
 						-1, 1);
 			if (ret < 0)
-				goto out;
+				return ret;
 			continue;
 		}
 		found = 1;
@@ -9804,7 +9747,7 @@ static int reset_balance(struct btrfs_trans_handle *trans)
 	if (del_nr) {
 		ret = btrfs_del_items(trans, root, &path, del_slot, del_nr);
 		if (ret)
-			goto out;
+			return ret;
 	}
 	btrfs_release_path(&path);
 
@@ -9815,16 +9758,13 @@ reinit_data_reloc:
 	root = btrfs_read_fs_root(gfs_info, &key);
 	if (IS_ERR(root)) {
 		fprintf(stderr, "Error reading data reloc tree\n");
-		ret = PTR_ERR(root);
-		goto out;
+		return PTR_ERR(root);
 	}
 	record_root_in_trans(trans, root);
 	ret = btrfs_fsck_reinit_root(trans, root);
 	if (ret)
-		goto out;
+		return ret;
 	ret = btrfs_make_root_dir(trans, root, BTRFS_FIRST_FREE_OBJECTID);
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -9835,7 +9775,7 @@ static int reinit_global_roots(struct btrfs_trans_handle *trans, u64 objectid)
 		.type = BTRFS_ROOT_ITEM_KEY,
 		.offset = 0,
 	};
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_root *tree_root = gfs_info->tree_root;
 	struct btrfs_root *root;
 	int ret;
@@ -9869,7 +9809,6 @@ static int reinit_global_roots(struct btrfs_trans_handle *trans, u64 objectid)
 			break;
 		key.offset++;
 	}
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -9992,7 +9931,7 @@ again:
 
 static int delete_bad_item(struct btrfs_root *root, struct bad_item *bad)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key key;
 	int ret;
@@ -10027,7 +9966,6 @@ static int delete_bad_item(struct btrfs_root *root, struct bad_item *bad)
 	ret = btrfs_del_item(trans, root, &path);
 out:
 	btrfs_commit_transaction(trans, root);
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -10044,7 +9982,7 @@ static int zero_log_tree(struct btrfs_root *root)
 
 static int check_range_csummed(struct btrfs_root *root, u64 addr, u64 length)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key = {
 		.objectid = BTRFS_EXTENT_CSUM_OBJECTID,
 		.type = BTRFS_EXTENT_CSUM_KEY,
@@ -10106,8 +10044,6 @@ next:
 		path.slots[0]++;
 	}
 
-	btrfs_release_path(&path);
-
 	if (ret >= 0)
 		ret = (length != 0);
 
@@ -10116,7 +10052,7 @@ next:
 
 static int check_log_root(struct btrfs_root *root, struct cache_tree *root_cache)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key = {
 		.objectid = BTRFS_FIRST_FREE_OBJECTID,
 		.type = BTRFS_INODE_ITEM_KEY,
@@ -10204,8 +10140,6 @@ next:
 		path.slots[0]++;
 	}
 
-	btrfs_release_path(&path);
-
 	return err;
 }
 
@@ -10253,7 +10187,7 @@ static int load_log_root(u64 root_id, struct btrfs_path *path, struct btrfs_root
 
 static int check_log(struct cache_tree *root_cache)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key = {
 		.objectid = BTRFS_TREE_LOG_OBJECTID,
 		.type = BTRFS_ROOT_ITEM_KEY,
@@ -10265,10 +10199,8 @@ static int check_log(struct cache_tree *root_cache)
 	int err = 0;
 
 	ret = btrfs_search_slot(NULL, log_root, &key, &path, 0, 0);
-	if (ret < 0) {
-		err = 1;
-		goto out;
-	}
+	if (ret < 0)
+		return 1;
 
 	while (1) {
 		leaf = path.nodes[0];
@@ -10311,8 +10243,6 @@ next:
 
 		path.slots[0]++;
 	}
-out:
-	btrfs_release_path(&path);
 
 	return err;
 }
@@ -10344,7 +10274,7 @@ static int build_roots_info_cache(void)
 	int ret = 0;
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 
 	if (!roots_info_cache) {
 		roots_info_cache = malloc(sizeof(*roots_info_cache));
@@ -10358,7 +10288,7 @@ static int build_roots_info_cache(void)
 	key.offset = 0;
 	ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
 	if (ret < 0)
-		goto out;
+		return ret;
 	leaf = path.nodes[0];
 
 	while (1) {
@@ -10433,10 +10363,8 @@ static int build_roots_info_cache(void)
 		entry = lookup_cache_extent(roots_info_cache, root_id, 1);
 		if (!entry) {
 			rii = malloc(sizeof(struct root_item_info));
-			if (!rii) {
-				ret = -ENOMEM;
-				goto out;
-			}
+			if (!rii)
+				return -ENOMEM;
 			rii->cache_extent.start = root_id;
 			rii->cache_extent.size = 1;
 			rii->level = (u8)-1;
@@ -10462,10 +10390,6 @@ static int build_roots_info_cache(void)
 next:
 		path.slots[0]++;
 	}
-
-out:
-	btrfs_release_path(&path);
-
 	return ret;
 }
 
@@ -10559,7 +10483,7 @@ static int maybe_repair_root_item(struct btrfs_path *path,
  */
 static int repair_root_items(void)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
 	struct btrfs_trans_handle *trans = NULL;
-- 
2.56.0

