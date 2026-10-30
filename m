Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333743;
	b=5tZlBgSKMcgaCJYLBoi753jDuuEEU1nn3JfTYmBmCz6O/eFbE82ztkHTxB4SUlMF07Zu
	 BsT/4bdwxvLaV6kK4jZNUlROcEvrkhzNWWd4eXxLmaOSFlfeGQdhVgOYBMTox5IqBa3DR
	 xMAtpR8uT7e+8qJRVJoNcy5OUr9isRjLwIRbPjmtvk+dl14p84dk/5/6Othf8cuXpazBw
	 0DJwZrl8DcVK4KAcv58oB+1Nv4ZwA65yXtL2f4EHuT481yCVckC9T/Z5X+/rpPmTEULB0
	 U9lPz/yQnVtLgHXYcatlXL5NRvY8wP188Mh6r6DyiIOkg0tRysLancG1wx2Mj+djvXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333743;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=aIDKnInqOT0eq/ytZRA+LeIEaWccoL5gTt+rYVJJsmQ=;
	b=Pl2conco9Wqnp5G+j5bBLfdmNgO0s8fN3Q2TN8TugnMDfdnP1c6W8fTtHnVo/9Ob4hFT
	 u38SrOXuDQd2tmsKiglE5WUvHHARn9eoCTIQeKzYjQDxEUBNAmO0P/4V0VndfC+S7E4/o
	 i3NXs2n1G32NO2JkxWpEviyAOg3lIOypelEjRjSFIe2CvKnFBYUSIDkVplDbJKytkrR85
	 r8ZmIibeSeU9PXnNbI4NN9UKIqTDa5MxQ29WWc4Tcp8h4e5i/jAWSx+g6LRXVdmEydoDk
	 mE1biO5sqz8XZoB9UFf3QZGe6gpZdJZL88kJo0HMMyoBEnjUECrGmsksPy2ikWnyn1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UIlLDWb0;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UIlLDWb0;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9AD606A31E
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E9AD606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UIlLDWb0;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UIlLDWb0
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A18BD1FCFA
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aIDKnInqOT0eq/ytZRA+LeIEaWccoL5gTt+rYVJJsmQ=;
	b=UIlLDWb0csWQbyebeAzwChCH3uxOIgLCHKNgFNfpInbzmcrGQfjGXPoo0/niEJvo0T6Y+d
	TpOgWEWvG4SsANq2wB2Xj+hdWUhAy+UzjYZJUxxgEri8xPwpkvNSlZQbU9CNPMM+i5upST
	0QlrkZzvxwiK0zFAry4QJZ9jC8u41Zg=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=UIlLDWb0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aIDKnInqOT0eq/ytZRA+LeIEaWccoL5gTt+rYVJJsmQ=;
	b=UIlLDWb0csWQbyebeAzwChCH3uxOIgLCHKNgFNfpInbzmcrGQfjGXPoo0/niEJvo0T6Y+d
	TpOgWEWvG4SsANq2wB2Xj+hdWUhAy+UzjYZJUxxgEri8xPwpkvNSlZQbU9CNPMM+i5upST
	0QlrkZzvxwiK0zFAry4QJZ9jC8u41Zg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8518B13625
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0uAiEekZ5GrDGwAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 01/12] btrfs-progs: kernel-shared: use BTRFS_PATH_AUTO_RELEASE() for on-stack paths
Date: Fri, 30 Oct 2026 14:45:08 +1030
Message-ID: <bedf1acd0adb0d911bf8187b55031c6fc229dc98.1793333606.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: A18BD1FCFA
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

Convert all on-stack btrfs_path in kernel-shared/ (and the btree-test
tool) to BTRFS_PATH_AUTO_RELEASE(), and drop the btrfs_release_path()
calls that only existed as function exit cleanup.

This also fixes the path leaks on error paths of:

- btrfs_stripe_tree_logical_to_physical()
- check_dev_extent_beyond_bytenr()
- get_last_converted_bg()

where btrfs_search_slot() failure returned without releasing the path.

Explicit releases which are not at function exit (e.g. before
re-searching with the same path) are kept.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/extent-tree.c      | 62 ++++++++++++--------------------
 kernel-shared/file.c             |  3 +-
 kernel-shared/free-space-cache.c | 24 ++++++-------
 kernel-shared/inode.c            |  8 ++---
 kernel-shared/print-tree.c       |  9 ++---
 kernel-shared/volumes.c          | 15 +++-----
 tests/btree-test.c               |  2 +-
 7 files changed, 45 insertions(+), 78 deletions(-)

diff --git a/kernel-shared/extent-tree.c b/kernel-shared/extent-tree.c
index bac44654eab8..b73fe8c63431 100644
--- a/kernel-shared/extent-tree.c
+++ b/kernel-shared/extent-tree.c
@@ -2782,7 +2782,7 @@ static int read_one_block_group(struct btrfs_fs_info *fs_info,
 static int get_last_converted_bg(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *bg_root = fs_info->block_group_root;
-	struct btrfs_path path = {0};
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key = {0};
 	int ret;
 
@@ -2809,7 +2809,7 @@ static int get_last_converted_bg(struct btrfs_fs_info *fs_info)
 
 			btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 			fs_info->last_converted_bg_bytenr = key.objectid;
-			goto out;
+			return ret;
 		}
 		btrfs_release_path(&path);
 
@@ -2820,21 +2820,20 @@ static int get_last_converted_bg(struct btrfs_fs_info *fs_info)
 
 		ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
 		if (ret < 0)
-			goto out;
+			return ret;
 		ASSERT(ret > 0);
 		ret = btrfs_previous_item(extent_root, &path, 0, BTRFS_BLOCK_GROUP_ITEM_KEY);
 		if (ret < 0)
-			goto out;
+			return ret;
 
 		/* No converted bg item in extent tree.*/
 		if (ret > 0) {
-			ret = 0;
 			fs_info->last_converted_bg_bytenr = (u64)-1;
-			goto out;
+			return 0;
 		}
 		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 		fs_info->last_converted_bg_bytenr = key.objectid;
-		goto out;
+		return ret;
 	}
 	/* Load the first bg in bg tree, that would be our last converted bg. */
 	ret = btrfs_search_slot(NULL, bg_root, &key, &path, 0, 0);
@@ -2847,14 +2846,11 @@ static int get_last_converted_bg(struct btrfs_fs_info *fs_info)
 	/* Empty bg tree, no converted bg item at all. */
 	if (btrfs_header_nritems(path.nodes[0]) == 0) {
 		fs_info->last_converted_bg_bytenr = (u64)-1;
-		ret = 0;
-		goto out;
+		return 0;
 	}
 	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 	ASSERT(key.type == BTRFS_BLOCK_GROUP_ITEM_KEY);
 	fs_info->last_converted_bg_bytenr = key.objectid;
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -2870,7 +2866,7 @@ out:
 static int read_old_block_groups_from_root(struct btrfs_fs_info *fs_info,
 					   struct btrfs_root *root)
 {
-	struct btrfs_path path = {0};
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key = { 0 };
 	int ret;
 
@@ -2878,18 +2874,15 @@ static int read_old_block_groups_from_root(struct btrfs_fs_info *fs_info,
 
 	while (true) {
 		ret = find_first_block_group(root, &path, &key, fs_info->last_converted_bg_bytenr);
-		if (ret > 0) {
-			ret = 0;
-			goto out;
-		}
-		if (ret != 0) {
-			goto out;
-		}
+		if (ret > 0)
+			return 0;
+		if (ret < 0)
+			return ret;
 		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 
 		ret = read_one_block_group(fs_info, &path);
 		if (ret < 0 && ret != -ENOENT)
-			goto out;
+			return ret;
 
 		if (key.offset == 0)
 			key.objectid++;
@@ -2898,17 +2891,14 @@ static int read_old_block_groups_from_root(struct btrfs_fs_info *fs_info,
 		key.offset = 0;
 		btrfs_release_path(&path);
 	}
-	ret = 0;
-out:
-	btrfs_release_path(&path);
-	return ret;
+	return 0;
 }
 
 /* Helper to read all block groups items from specified root. */
 static int read_block_groups_from_root(struct btrfs_fs_info *fs_info,
 					   struct btrfs_root *root)
 {
-	struct btrfs_path path = {0};
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key = {0};
 	int ret;
 
@@ -2916,18 +2906,15 @@ static int read_block_groups_from_root(struct btrfs_fs_info *fs_info,
 
 	while (true) {
 		ret = find_first_block_group(root, &path, &key, (u64)-1);
-		if (ret > 0) {
-			ret = 0;
-			goto out;
-		}
-		if (ret != 0) {
-			goto out;
-		}
+		if (ret > 0)
+			return 0;
+		if (ret < 0)
+			return ret;
 		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 
 		ret = read_one_block_group(fs_info, &path);
 		if (ret < 0 && ret != -ENOENT)
-			goto out;
+			return ret;
 
 		if (key.offset == 0)
 			key.objectid++;
@@ -2936,10 +2923,7 @@ static int read_block_groups_from_root(struct btrfs_fs_info *fs_info,
 		key.offset = 0;
 		btrfs_release_path(&path);
 	}
-	ret = 0;
-out:
-	btrfs_release_path(&path);
-	return ret;
+	return 0;
 }
 
 static int read_converting_block_groups(struct btrfs_fs_info *fs_info)
@@ -3472,7 +3456,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_block_group *block_group;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int ret = 0;
 
 	block_group = btrfs_lookup_block_group(fs_info, bytenr);
@@ -3893,7 +3877,7 @@ int btrfs_convert_one_bg(struct btrfs_trans_handle *trans, u64 bytenr)
 	struct btrfs_root *new_root = fs_info->block_group_root;
 	struct btrfs_root *old_root = btrfs_extent_root(fs_info, 0);
 	struct btrfs_block_group *bg;
-	struct btrfs_path path = {0};
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int ret;
 
 	ASSERT(new_root);
diff --git a/kernel-shared/file.c b/kernel-shared/file.c
index 546e161abfdb..7fe5ae3b7595 100644
--- a/kernel-shared/file.c
+++ b/kernel-shared/file.c
@@ -192,7 +192,7 @@ int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	struct btrfs_inode_item *ii;
 	u64 isize;
@@ -331,7 +331,6 @@ next:
 		read = min_t(u64, isize - start, len);
 	}
 out:
-	btrfs_release_path(&path);
 	if (!ret)
 		ret = read;
 	return ret;
diff --git a/kernel-shared/free-space-cache.c b/kernel-shared/free-space-cache.c
index d80fe5707eb5..bc511b442f23 100644
--- a/kernel-shared/free-space-cache.c
+++ b/kernel-shared/free-space-cache.c
@@ -917,7 +917,7 @@ int btrfs_clear_free_space_cache(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *tree_root = fs_info->tree_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_disk_key location;
 	struct btrfs_free_space_header *sc_header;
@@ -931,12 +931,10 @@ int btrfs_clear_free_space_cache(struct btrfs_trans_handle *trans,
 	key.offset = bg->start;
 
 	ret = btrfs_search_slot(trans, tree_root, &key, &path, -1, 1);
-	if (ret > 0) {
-		ret = 0;
-		goto out;
-	}
+	if (ret > 0)
+		return 0;
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	node = path.nodes[0];
 	slot = path.slots[0];
@@ -949,7 +947,7 @@ int btrfs_clear_free_space_cache(struct btrfs_trans_handle *trans,
 	if (ret < 0) {
 		error("failed to remove free space header for block group %llu: %d",
 		      bg->start, ret);
-		goto out;
+		return ret;
 	}
 	btrfs_release_path(&path);
 
@@ -961,7 +959,7 @@ int btrfs_clear_free_space_cache(struct btrfs_trans_handle *trans,
 	if (ret < 0) {
 		error("failed to locate free space cache extent for block group %llu: %d",
 		      bg->start, ret);
-		goto out;
+		return ret;
 	}
 	while (1) {
 		struct btrfs_file_extent_item *fi;
@@ -978,7 +976,7 @@ int btrfs_clear_free_space_cache(struct btrfs_trans_handle *trans,
 			error(
 	"failed to locate free space cache extent for block group %llu: %d",
 				bg->start, ret);
-			goto out;
+			return ret;
 		}
 		node = path.nodes[0];
 		slot = path.slots[0];
@@ -992,14 +990,14 @@ int btrfs_clear_free_space_cache(struct btrfs_trans_handle *trans,
 		if (ret < 0) {
 			error("failed to remove backref for disk bytenr %llu: %d",
 			      disk_bytenr, ret);
-			goto out;
+			return ret;
 		}
 		ret = btrfs_del_item(trans, tree_root, &path);
 		if (ret < 0) {
 			error(
 	"failed to remove free space extent data for ino %llu offset %llu: %d",
 			      ino, key.offset, ret);
-			goto out;
+			return ret;
 		}
 	}
 	btrfs_release_path(&path);
@@ -1016,7 +1014,7 @@ int btrfs_clear_free_space_cache(struct btrfs_trans_handle *trans,
 		error(
 	"failed to locate free space cache inode %llu for block group %llu: %d",
 		      ino, bg->start, ret);
-		goto out;
+		return ret;
 	}
 	ret = btrfs_del_item(trans, tree_root, &path);
 	if (ret < 0) {
@@ -1024,7 +1022,5 @@ int btrfs_clear_free_space_cache(struct btrfs_trans_handle *trans,
 	"failed to delete free space cache inode %llu for block group %llu: %d",
 		      ino, bg->start, ret);
 	}
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
diff --git a/kernel-shared/inode.c b/kernel-shared/inode.c
index f77157a2df14..d75e6fa3dd98 100644
--- a/kernel-shared/inode.c
+++ b/kernel-shared/inode.c
@@ -162,7 +162,7 @@ out:
 static int inherit_inode_flags(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, u64 ino, u64 parent_ino)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_inode_item *iitem;
 	u64 parent_inode_flags;
@@ -177,7 +177,7 @@ static int inherit_inode_flags(struct btrfs_trans_handle *trans,
 	if (ret > 0)
 		ret = -ENOENT;
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	iitem = btrfs_item_ptr(path.nodes[0], path.slots[0], struct btrfs_inode_item);
 	parent_inode_flags = btrfs_inode_flags(path.nodes[0], iitem);
@@ -189,7 +189,7 @@ static int inherit_inode_flags(struct btrfs_trans_handle *trans,
 	if (ret > 0)
 		ret = -ENOENT;
 	if (ret < 0)
-		goto out;
+		return ret;
 	iitem = btrfs_item_ptr(path.nodes[0], path.slots[0], struct btrfs_inode_item);
 	child_inode_flags = btrfs_inode_flags(path.nodes[0], iitem);
 
@@ -206,8 +206,6 @@ static int inherit_inode_flags(struct btrfs_trans_handle *trans,
 			child_inode_flags |= BTRFS_INODE_NODATASUM;
 	}
 	btrfs_set_inode_flags(path.nodes[0], iitem, child_inode_flags);
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
index 4b3ad093f278..832ce0678e71 100644
--- a/kernel-shared/print-tree.c
+++ b/kernel-shared/print-tree.c
@@ -1768,7 +1768,7 @@ static int next_sibling_tree_block(struct btrfs_fs_info *fs_info,
 static void bfs_print_children(struct extent_buffer *root_eb, unsigned int mode)
 {
 	struct btrfs_fs_info *fs_info = root_eb->fs_info;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int root_level = btrfs_header_level(root_eb);
 	int cur_level;
 	int ret;
@@ -1790,23 +1790,20 @@ static void bfs_print_children(struct extent_buffer *root_eb, unsigned int mode)
 		/* Use the leftmost tree block as a starting point */
 		ret = search_leftmost_tree_block(fs_info, &path, root_level);
 		if (ret < 0)
-			goto out;
+			return;
 
 		/* Print all sibling tree blocks */
 		while (1) {
 			btrfs_print_tree(path.nodes[cur_level], mode);
 			ret = next_sibling_tree_block(fs_info, &path);
 			if (ret < 0)
-				goto out;
+				return;
 			if (ret > 0) {
 				ret = 0;
 				break;
 			}
 		}
 	}
-out:
-	btrfs_release_path(&path);
-	return;
 }
 
 static void dfs_print_children(struct extent_buffer *root_eb, unsigned int mode)
diff --git a/kernel-shared/volumes.c b/kernel-shared/volumes.c
index fedcaa5f9216..ed9b769b42fc 100644
--- a/kernel-shared/volumes.c
+++ b/kernel-shared/volumes.c
@@ -2033,7 +2033,7 @@ static int btrfs_stripe_tree_logical_to_physical(struct btrfs_fs_info *fs_info,
 						struct btrfs_bio_stripe *stripe)
 {
 	struct btrfs_root *root = fs_info->stripe_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
 	int slot;
@@ -2061,7 +2061,7 @@ static int btrfs_stripe_tree_logical_to_physical(struct btrfs_fs_info *fs_info,
 			if (ret == 0)
 				continue;
 			if (ret < 0)
-				goto error;
+				return ret;
 			break;
 		}
 
@@ -2080,15 +2080,12 @@ static int btrfs_stripe_tree_logical_to_physical(struct btrfs_fs_info *fs_info,
 			    btrfs_raid_stride_devid_nr(leaf, extent, i))
 				continue;
 			stripe->physical = btrfs_raid_stride_physical_nr(leaf, extent, i);
-			btrfs_release_path(&path);
 			return 0;
 		}
 next:
 		path.slots[0]++;
 	}
 
-	btrfs_release_path(&path);
-error:
 	return ret;
 }
 
@@ -3053,7 +3050,7 @@ static int check_dev_extent_beyond_bytenr(struct btrfs_fs_info *fs_info,
 					  u64 physical)
 {
 	struct btrfs_root *root = fs_info->dev_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_dev_extent *dext;
 	struct btrfs_key key;
 	u64 dext_len;
@@ -3088,7 +3085,6 @@ static int check_dev_extent_beyond_bytenr(struct btrfs_fs_info *fs_info,
 	last_dev_extent_end = dext_len + key.offset;
 
 out:
-	btrfs_release_path(&path);
 	if (ret < 0)
 		return ret;
 	if (last_dev_extent_end <= physical)
@@ -3102,7 +3098,7 @@ static int reset_device_item_total_bytes(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_root *chunk_root = fs_info->chunk_root;
 	struct btrfs_dev_item *di;
 	u64 old_bytes = device->total_bytes;
@@ -3143,10 +3139,8 @@ static int reset_device_item_total_bytes(struct btrfs_fs_info *fs_info,
 	if (ret < 0) {
 		errno = -ret;
 		error_msg(ERROR_MSG_COMMIT_TRANS, "%m");
-		btrfs_release_path(&path);
 		return ret;
 	}
-	btrfs_release_path(&path);
 	printf("Fixed device size for devid %llu, old size: %llu new size: %llu\n",
 		device->devid, old_bytes, device->total_bytes);
 	return 1;
@@ -3154,7 +3148,6 @@ static int reset_device_item_total_bytes(struct btrfs_fs_info *fs_info,
 err:
 	/* We haven't modified anything, it's OK to commit current trans */
 	btrfs_commit_transaction(trans, chunk_root);
-	btrfs_release_path(&path);
 	return ret;
 }
 
diff --git a/tests/btree-test.c b/tests/btree-test.c
index ddb13472e2f1..7dbbc1685aeb 100644
--- a/tests/btree-test.c
+++ b/tests/btree-test.c
@@ -41,7 +41,7 @@ int main(int argc, char **argv) {
 	int run_size = 300000;
 	int max_key =  100000000;
 	int tree_size = 2;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_root *root;
 	struct btrfs_trans_handle *trans;
 
-- 
2.56.0

