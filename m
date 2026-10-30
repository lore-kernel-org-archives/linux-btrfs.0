Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333751;
	b=g92XI8QQGQjaV52ZrS626IiliPOoPrfMlpxVqxKELAisxmhNNhuvj5qfBZVMsur2AkCa
	 /14cpF22M8YyF7dTOg0fDTu/FEzHRd8Z7pkcDIyKgR2IfuZjz8stmJ3+4bpWJ02RaOcYU
	 LZxEWJyxNVJNuI8N+Gl81QaDC+NCbMWNWFl0V6owhZjNbg+wpN6brA0iG0wlHehJIjNSw
	 JTSx6xiZNhs2ozVAZwGPYSGtV+6Nmm63AW/B2oVic+bdgIXY6B85ZW+fnINNS8jwN+MKD
	 C33SQO9lb2G1a2txog/LSTvF2LIiDgWOt0BzLKaQ8dtuc3KSEY1hy0OhER8AJN+nBbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333751;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=iW8DRAWMrJhYrKd9MZwNOUXOkKMy7UOSEnBlsZDVPME=;
	b=0eXkxWiPMQgOrmX4I6Gerb+HOp1j9RU7xCbx7Eb/pY+pNFHBvYotfB1Kg406rqDhqd4J
	 bx6V50yFopXBbJe8vrPeXQPgUOBkLJMcObByQjXQkHdDdGAVtQnfkU1d1x9ngp9j/PMNW
	 03B1/SzoqeHph4CcTYhRH1KAxq+Ggk6GAMQzDVsuJCqk79Uro3qggZrF2hERWtJ7u/WEz
	 U4yRKOKRh9P3IdDOAaHkWCvNRFyjOq+s63uY5yjlIVGVule5uyRe+JVOy1f85DnOFyP4w
	 /FAUEIvhHQDJYyONmS/qNf8GwjMSdII6XuKjwYKPlXLcLnJ3R7VVqZcdtNqQ6UyblMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=d0FmlGBh;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GPjL+eKc;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB00606A321
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CB00606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=d0FmlGBh;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GPjL+eKc
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EE3C7223FE
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333749; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iW8DRAWMrJhYrKd9MZwNOUXOkKMy7UOSEnBlsZDVPME=;
	b=d0FmlGBhmnhKev7YMW2IuWhWPZ6aHujfIgf0xJY2GHEddOtHge1P3kO9h/29CHqx3PLUwe
	TbnVABhdBrS42nhD9qbMANbc1itTrd7vgKuO/IS+pIszAhZoVes1EKjKBXrovhY9d/FFPm
	Jue0B+iYZFAJKuRfgSuPZ7cjljTtjxE=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=GPjL+eKc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iW8DRAWMrJhYrKd9MZwNOUXOkKMy7UOSEnBlsZDVPME=;
	b=GPjL+eKcEmdYuPyfbt7wXMzWeQxkwYjMBNyGerV2yO1dKXE1OaJ6tBUaqIqNFWaQgkW5Y0
	PVh0/0Zo0mY8b55Y9BmUwNbwB66qon3kcvtIm0sGYmcE+jYE8N/rrQ+v1Pi00qhNLD/EWt
	68jGd0DsUSAXm39P5JHA4wF10qANtvI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DAB4E13432
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0uAiEekZ5GrDGwAAD6G6ig:T7
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:47 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/12] btrfs-progs: check: use BTRFS_PATH_AUTO_RELEASE() for repair, qgroup-verify and mode-common
Date: Fri, 30 Oct 2026 14:45:13 +1030
Message-ID: <cb564a60920758b7c0a229ba99ed30864d301aa1.1793333606.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: EE3C7223FE

Convert all on-stack btrfs_path in check/repair.c, check/qgroup-verify.c
and check/mode-common.c to BTRFS_PATH_AUTO_RELEASE(), and drop the
btrfs_release_path() calls that only existed as function exit cleanup.

This also fixes the path leaks on error paths of:

- populate_used_from_extent_root()
- get_num_devs_in_chunk_tree()

Explicit releases which are not at function exit are kept.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-common.c   | 135 +++++++++++++++---------------------------
 check/qgroup-verify.c |  29 ++++-----
 check/repair.c        |   5 +-
 3 files changed, 62 insertions(+), 107 deletions(-)

diff --git a/check/mode-common.c b/check/mode-common.c
index eb82bb99e827..7d829661eb3d 100644
--- a/check/mode-common.c
+++ b/check/mode-common.c
@@ -55,17 +55,15 @@ static int check_prealloc_data_ref(u64 disk_bytenr,
 	u64 offset = btrfs_extent_data_ref_offset(eb, dref);
 	struct btrfs_root *root;
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int ret;
 
 	key.objectid = rootid;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
 	root = btrfs_read_fs_root(gfs_info, &key);
-	if (IS_ERR(root)) {
-		ret = PTR_ERR(root);
-		goto out;
-	}
+	if (IS_ERR(root))
+		return PTR_ERR(root);
 
 	key.objectid = objectid;
 	key.type = BTRFS_EXTENT_DATA_KEY;
@@ -78,7 +76,7 @@ static int check_prealloc_data_ref(u64 disk_bytenr,
 		ret = -ENOENT;
 	}
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	while (true) {
 		struct btrfs_file_extent_item *fi;
@@ -87,7 +85,7 @@ static int check_prealloc_data_ref(u64 disk_bytenr,
 		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
 			ret = btrfs_next_leaf(root, &path);
 			if (ret < 0)
-				goto out;
+				return ret;
 			if (ret > 0)
 				break;
 		}
@@ -108,16 +106,12 @@ static int check_prealloc_data_ref(u64 disk_bytenr,
 		    disk_bytenr)
 			break;
 
-		if (extent_type == BTRFS_FILE_EXTENT_REG) {
-			ret = 1;
-			goto out;
-		}
+		if (extent_type == BTRFS_FILE_EXTENT_REG)
+			return 1;
 next:
 		path.slots[0]++;
 	}
 	ret = 0;
- out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -193,7 +187,7 @@ int check_prealloc_extent_written(u64 disk_bytenr, u64 num_bytes)
 {
 	struct btrfs_root *extent_root = btrfs_extent_root(gfs_info,
 							   disk_bytenr);
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 	struct btrfs_extent_item *ei;
@@ -213,7 +207,7 @@ int check_prealloc_extent_written(u64 disk_bytenr, u64 num_bytes)
 		ret = -ENOENT;
 	}
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	/* First check all inline refs. */
 	ei = btrfs_item_ptr(path.nodes[0], path.slots[0],
@@ -237,7 +231,7 @@ int check_prealloc_extent_written(u64 disk_bytenr, u64 num_bytes)
 			ret = check_prealloc_data_ref(disk_bytenr,
 						      dref, path.nodes[0]);
 			if (ret != 0)
-				goto out;
+				return ret;
 		} else if (type == BTRFS_SHARED_DATA_REF_KEY) {
 			u64 parent;
 
@@ -246,7 +240,7 @@ int check_prealloc_extent_written(u64 disk_bytenr, u64 num_bytes)
 			ret = check_prealloc_shared_data_ref(parent,
 							     disk_bytenr);
 			if (ret != 0)
-				goto out;
+				return ret;
 		}
 
 		ptr += btrfs_extent_inline_ref_size(type);
@@ -258,7 +252,7 @@ int check_prealloc_extent_written(u64 disk_bytenr, u64 num_bytes)
 		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
 			ret = btrfs_next_leaf(extent_root, &path);
 			if (ret < 0)
-				goto out;
+				return ret;
 			if (ret > 0) {
 				ret = 0;
 				break;
@@ -277,18 +271,16 @@ int check_prealloc_extent_written(u64 disk_bytenr, u64 num_bytes)
 			ret = check_prealloc_data_ref(disk_bytenr,
 						      dref, path.nodes[0]);
 			if (ret != 0)
-				goto out;
+				return ret;
 		} else if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
 			ret = check_prealloc_shared_data_ref(key.offset,
 							     disk_bytenr);
 			if (ret != 0)
-				goto out;
+				return ret;
 		}
 
 		path.slots[0]++;
 	}
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -305,7 +297,7 @@ int count_csum_range(u64 start, u64 len, u64 *found)
 {
 	struct btrfs_root *csum_root = btrfs_csum_root(gfs_info, start);
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	int ret;
 	size_t size;
@@ -364,7 +356,6 @@ int count_csum_range(u64 start, u64 len, u64 *found)
 		path.slots[0]++;
 	}
 out:
-	btrfs_release_path(&path);
 	if (ret < 0)
 		return ret;
 	return 0;
@@ -653,7 +644,7 @@ int delete_corrupted_dir_item(struct btrfs_trans_handle *trans,
 			      u32 namelen)
 {
 	struct btrfs_dir_item *di_item;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int ret;
 
 	ret = btrfs_search_slot(trans, root, di_key, &path, 0, 1);
@@ -661,13 +652,12 @@ int delete_corrupted_dir_item(struct btrfs_trans_handle *trans,
 		error("key (%llu %u %llu) doesn't exist in root %llu",
 			di_key->objectid, di_key->type, di_key->offset,
 			root->root_key.objectid);
-		ret = -ENOENT;
-		goto out;
+		return -ENOENT;
 	}
 	if (ret < 0) {
 		error("failed to search root %llu: %d",
 			root->root_key.objectid, ret);
-		goto out;
+		return ret;
 	}
 
 	di_item = btrfs_match_dir_item_name(root, &path, namebuf, namelen);
@@ -679,15 +669,11 @@ int delete_corrupted_dir_item(struct btrfs_trans_handle *trans,
 		error("no dir item named '%s' found with key (%llu %u %llu)",
 			namebuf, di_key->objectid, di_key->type,
 			di_key->offset);
-		ret = -ENOENT;
-		goto out;
+		return -ENOENT;
 	}
 	ret = btrfs_delete_one_dir_name(trans, root, &path, di_item);
 	if (ret < 0)
 		error("failed to delete one dir name: %d", ret);
-
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -734,7 +720,7 @@ static int find_file_type_dir_index(struct btrfs_root *root, u64 ino, u64 dirid,
 				    u64 index, const char *name, u32 name_len,
 				    u32 *imode_ret)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_key location;
 	struct btrfs_dir_item *di;
@@ -775,7 +761,6 @@ static int find_file_type_dir_index(struct btrfs_root *root, u64 ino, u64 dirid,
 	found = true;
 	*imode_ret = btrfs_type_to_imode(filetype);
 out:
-	btrfs_release_path(&path);
 	if (!found && !ret)
 		ret = -ENOENT;
 	return ret;
@@ -785,7 +770,7 @@ static int find_file_type_dir_item(struct btrfs_root *root, u64 ino, u64 dirid,
 				   const char *name, u32 name_len,
 				   u32 *imode_ret)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_key location;
 	struct btrfs_dir_item *di;
@@ -837,7 +822,6 @@ static int find_file_type_dir_item(struct btrfs_root *root, u64 ino, u64 dirid,
 		goto out;
 	}
 out:
-	btrfs_release_path(&path);
 	if (!found && !ret)
 		ret = -ENOENT;
 	return ret;
@@ -1052,7 +1036,7 @@ int check_repair_free_space_inode(struct btrfs_path *path)
 
 int recow_extent_buffer(struct btrfs_root *root, struct extent_buffer *eb)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key key;
 	int ret;
@@ -1085,7 +1069,6 @@ int recow_extent_buffer(struct btrfs_root *root, struct extent_buffer *eb)
 
 	ret = btrfs_search_slot(trans, root, &key, &path, 0, 1);
 	btrfs_commit_transaction(trans, root);
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -1099,7 +1082,7 @@ int get_extent_item_generation(u64 bytenr, u64 *gen_ret)
 {
 	struct btrfs_root *root = btrfs_extent_root(gfs_info, bytenr);
 	struct btrfs_extent_item *ei;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 
@@ -1112,12 +1095,12 @@ int get_extent_item_generation(u64 bytenr, u64 *gen_ret)
 	if (ret == 0)
 		ret = -EUCLEAN;
 	if (ret < 0)
-		goto out;
+		return ret;
 	ret = btrfs_previous_extent_item(root, &path, bytenr);
 	if (ret > 0)
 		ret = -ENOENT;
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	ei = btrfs_item_ptr(path.nodes[0], path.slots[0], struct btrfs_extent_item);
 
@@ -1142,8 +1125,6 @@ int get_extent_item_generation(u64 bytenr, u64 *gen_ret)
 		 */
 		ret = -ENOTSUP;
 	}
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -1232,7 +1213,7 @@ static int fill_csum_tree_from_one_fs_root(struct btrfs_trans_handle *trans,
 					   struct btrfs_root *cur_root)
 {
 	struct btrfs_root *csum_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct extent_buffer *node;
 	struct btrfs_file_extent_item *fi;
@@ -1331,14 +1312,13 @@ next:
 	}
 
 out:
-	btrfs_release_path(&path);
 	free(buf);
 	return ret;
 }
 
 static int fill_csum_tree_from_fs(struct btrfs_trans_handle *trans)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_root *tree_root = gfs_info->tree_root;
 	struct btrfs_root *cur_root;
 	struct extent_buffer *node;
@@ -1351,18 +1331,16 @@ static int fill_csum_tree_from_fs(struct btrfs_trans_handle *trans)
 	key.offset = 0;
 	ret = btrfs_search_slot(NULL, tree_root, &key, &path, 0, 0);
 	if (ret < 0)
-		goto out;
-	if (ret > 0) {
-		ret = -ENOENT;
-		goto out;
-	}
+		return ret;
+	if (ret > 0)
+		return -ENOENT;
 
 	while (1) {
 		node = path.nodes[0];
 		slot = path.slots[0];
 		btrfs_item_key_to_cpu(node, &key, slot);
 		if (key.objectid > BTRFS_LAST_FREE_OBJECTID)
-			goto out;
+			return ret;
 		if (key.type != BTRFS_ROOT_ITEM_KEY)
 			goto next;
 		if (!is_fstree(key.objectid))
@@ -1373,23 +1351,18 @@ static int fill_csum_tree_from_fs(struct btrfs_trans_handle *trans)
 		if (IS_ERR(cur_root) || !cur_root) {
 			fprintf(stderr, "Fail to read fs/subvol tree: %lld\n",
 				key.objectid);
-			goto out;
+			return ret;
 		}
 		ret = fill_csum_tree_from_one_fs_root(trans, cur_root);
 		if (ret < 0)
-			goto out;
+			return ret;
 next:
 		ret = btrfs_next_item(tree_root, &path);
-		if (ret > 0) {
-			ret = 0;
-			goto out;
-		}
+		if (ret > 0)
+			return 0;
 		if (ret < 0)
-			goto out;
+			return ret;
 	}
-
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -1399,7 +1372,7 @@ static int remove_csum_for_file_extent(u64 ino, u64 offset, u64 rootid, void *ct
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_inode_item *ii;
-	struct btrfs_path path = {};
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_root *root;
 	bool nocsum = false;
@@ -1412,10 +1385,8 @@ static int remove_csum_for_file_extent(u64 ino, u64 offset, u64 rootid, void *ct
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
 	root = btrfs_read_fs_root(fs_info, &key);
-	if (IS_ERR(root)) {
-		ret = PTR_ERR(root);
-		goto out;
-	}
+	if (IS_ERR(root))
+		return PTR_ERR(root);
 
 	/* Check if the inode has NODATASUM flag */
 	key.objectid = ino;
@@ -1425,7 +1396,7 @@ static int remove_csum_for_file_extent(u64 ino, u64 offset, u64 rootid, void *ct
 	if (ret > 0)
 		ret = -ENOENT;
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	ii = btrfs_item_ptr(path.nodes[0], path.slots[0],
 			    struct btrfs_inode_item);
@@ -1442,24 +1413,24 @@ static int remove_csum_for_file_extent(u64 ino, u64 offset, u64 rootid, void *ct
 	if (ret > 0)
 		ret = -ENOENT;
 	if (ret < 0)
-		goto out;
+		return ret;
 	fi = btrfs_item_ptr(path.nodes[0], path.slots[0],
 			    struct btrfs_file_extent_item);
 	type = btrfs_file_extent_type(path.nodes[0], fi);
 
 	if (btrfs_file_extent_disk_bytenr(path.nodes[0], fi) == 0)
-		goto out;
+		return ret;
 
 	/* Compressed extent should have csum, skip it */
 	if (btrfs_file_extent_compression(path.nodes[0], fi) !=
 	    BTRFS_COMPRESS_NONE)
-		goto out;
+		return ret;
 	/*
 	 * We only want to delete the csum range if the inode has NODATASUM
 	 * flag or it's a preallocated extent.
 	 */
 	if (!(nocsum || type == BTRFS_FILE_EXTENT_PREALLOC))
-		goto out;
+		return ret;
 
 	/* If NODATASUM, we need to remove all csum for the extent */
 	if (nocsum) {
@@ -1475,8 +1446,6 @@ static int remove_csum_for_file_extent(u64 ino, u64 offset, u64 rootid, void *ct
 	/* Now delete the csum for the preallocated or nodatasum range */
 	root = btrfs_csum_root(fs_info, disk_bytenr);
 	ret = btrfs_del_csums(trans, root, disk_bytenr, disk_len);
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -1484,7 +1453,7 @@ static int fill_csum_tree_from_extent(struct btrfs_trans_handle *trans,
 				      struct btrfs_root *extent_root)
 {
 	struct btrfs_root *csum_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_extent_item *ei;
 	struct extent_buffer *leaf;
 	char *buf;
@@ -1495,16 +1464,12 @@ static int fill_csum_tree_from_extent(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_EXTENT_ITEM_KEY;
 	key.offset = 0;
 	ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
-	if (ret < 0) {
-		btrfs_release_path(&path);
+	if (ret < 0)
 		return ret;
-	}
 
 	buf = malloc(gfs_info->sectorsize);
-	if (!buf) {
-		btrfs_release_path(&path);
+	if (!buf)
 		return -ENOMEM;
-	}
 
 	while (1) {
 		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
@@ -1557,7 +1522,6 @@ static int fill_csum_tree_from_extent(struct btrfs_trans_handle *trans,
 		path.slots[0]++;
 	}
 
-	btrfs_release_path(&path);
 	free(buf);
 	return ret;
 }
@@ -1597,7 +1561,7 @@ int fill_csum_tree(struct btrfs_trans_handle *trans, bool search_fs_tree)
 static int get_num_devs_in_chunk_tree(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *chunk_root = fs_info->chunk_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key = { 0 };
 	int found_devs = 0;
 	int ret;
@@ -1630,7 +1594,6 @@ static int get_num_devs_in_chunk_tree(struct btrfs_fs_info *fs_info)
 		}
 		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 	}
-	btrfs_release_path(&path);
 	if (ret < 0)
 		return ret;
 	return found_devs;
@@ -1677,7 +1640,7 @@ int repair_subvol_orphan_item(struct btrfs_fs_info *fs_info, u64 rootid)
 {
 	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int ret;
 
 	trans = btrfs_start_transaction(tree_root, 1);
diff --git a/check/qgroup-verify.c b/check/qgroup-verify.c
index 63902ffa6f5b..b58ef36669b2 100644
--- a/check/qgroup-verify.c
+++ b/check/qgroup-verify.c
@@ -993,7 +993,7 @@ static int load_quota_info(struct btrfs_fs_info *info)
 {
 	int ret;
 	struct btrfs_root *root = info->quota_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
 
@@ -1008,7 +1008,7 @@ static int load_quota_info(struct btrfs_fs_info *info)
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 	if (ret < 0) {
 		error("couldn't search slot: %d", ret);
-		goto out;
+		return ret;
 	}
 
 	while (1) {
@@ -1016,17 +1016,15 @@ static int load_quota_info(struct btrfs_fs_info *info)
 
 		ret = load_one_quota_leaf(leaf);
 		if (ret < 0)
-			goto out;
+			return ret;
 		ret = btrfs_next_leaf(root, &path);
 		if (ret < 0)
-			goto out;
+			return ret;
 		if (ret > 0) {
 			ret = 0;
 			break;
 		}
 	}
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -1217,7 +1215,7 @@ static int scan_extents(struct btrfs_fs_info *info,
 	int ret, i, nr, level;
 	struct btrfs_root *root = btrfs_extent_root(info, start);
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_disk_key disk_key;
 	struct extent_buffer *leaf;
 	u64 bytenr = 0, num_bytes = 0;
@@ -1229,7 +1227,7 @@ static int scan_extents(struct btrfs_fs_info *info,
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 	if (ret < 0) {
 		error("couldn't search slot: %d", ret);
-		goto out;
+		return ret;
 	}
 	path.reada = READA_BACK;
 
@@ -1263,7 +1261,7 @@ static int scan_extents(struct btrfs_fs_info *info,
 				ret = add_inline_refs(info, leaf, i, bytenr,
 						      num_bytes, meta);
 				if (ret)
-					goto out;
+					return ret;
 
 				level = get_tree_block_level(&key, leaf, i);
 				if (level) {
@@ -1292,23 +1290,20 @@ static int scan_extents(struct btrfs_fs_info *info,
 			ret = add_keyed_ref(info, &key, leaf, i, bytenr,
 					    num_bytes);
 			if (ret)
-				goto out;
+				return ret;
 		}
 
 		ret = btrfs_next_leaf(root, &path);
 		if (ret != 0) {
 			if (ret < 0) {
 				error("next leaf failed: %d", ret);
-				goto out;
+				return ret;
 			}
 			break;
 		}
 	}
 done:
 	ret = 0;
-out:
-	btrfs_release_path(&path);
-
 	return ret;
 }
 
@@ -1626,7 +1621,7 @@ static int repair_qgroup_info(struct btrfs_fs_info *info,
 	int ret;
 	struct btrfs_root *root = info->quota_root;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_qgroup_info_item *info_item;
 	struct btrfs_key key;
 
@@ -1672,7 +1667,6 @@ static int repair_qgroup_info(struct btrfs_fs_info *info,
 
 out:
 	btrfs_commit_transaction(trans, root);
-	btrfs_release_path(&path);
 
 	return ret;
 }
@@ -1682,7 +1676,7 @@ static int repair_qgroup_status(struct btrfs_fs_info *info, bool silent)
 	int ret;
 	struct btrfs_root *root = info->quota_root;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_qgroup_status_item *status_item;
 	bool simple = btrfs_fs_incompat(info, SIMPLE_QUOTA);
@@ -1721,7 +1715,6 @@ static int repair_qgroup_status(struct btrfs_fs_info *info, bool silent)
 
 out:
 	btrfs_commit_transaction(trans, root);
-	btrfs_release_path(&path);
 
 	return ret;
 }
diff --git a/check/repair.c b/check/repair.c
index 214b30301f78..4948416f66c4 100644
--- a/check/repair.c
+++ b/check/repair.c
@@ -224,7 +224,7 @@ static int populate_used_from_extent_root(struct btrfs_root *root,
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *leaf;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int slot;
 	int ret;
@@ -272,7 +272,6 @@ static int populate_used_from_extent_root(struct btrfs_root *root,
 
 		path.slots[0]++;
 	}
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -414,7 +413,7 @@ int btrfs_remove_dev_extent(struct btrfs_fs_info *fs_info, u64 devid, u64 physic
 		.type = BTRFS_DEV_EXTENT_KEY,
 		.offset = physical,
 	};
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_dev_extent *dext;
 	struct btrfs_device *dev;
 	u64 length;
-- 
2.56.0

