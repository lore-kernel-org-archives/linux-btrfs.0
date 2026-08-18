Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39C83C8700
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 04:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029064; cv=none; b=COxLM8z9FMqcg4QqOtjzQOgpJHR6Pb4JbWHeOM1MFbOhI2/TGT2HvdQnaCAIX2r+wacHBHAY+BrhhG5JRakzmOfgBf3ES2JF6vfVqXQ+SH9KIH1E7fE6Hm3WucPHuSpm9+GBiIuLGKx34nWZtk4JRapZqYYDyLD310oaoeAPv4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029064; c=relaxed/simple;
	bh=5kd/BPOJ4DTUQG6IoPuyGBNUsc11BhuCIa4YUWF9OH0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TyxzTMdCEBT5VKyk7Mk6yZ01bIKmWExHO+o37TmrY8FPgleimYnq2KEiy6FAjzBGqrmdY5h/oD9mpHbwhWSw1JwGfRDbAMA7+yXFsilyilxBzv4DjxmDnubVQiDYE0mPmZqxM70hrHRLV0igijkafwlnsgY2+B4bZOa/1RDSWXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Bv0k03XQ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=bXbeoc6V; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Bv0k03XQ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bXbeoc6V"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 499E63E49;
	Tue, 18 Aug 2026 04:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787029056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vMAMpzwbbO2PcP763W17bjWyM5n0PJ8ANMuz8yzLNmo=;
	b=Bv0k03XQvecsAoWRH29/nhLEtnjYXCKN1C4SyWoeafVam6fxH9k204a/x7oObB6J8BjiH+
	XY8eplX8YNaU18Cc5UztDcOxXnkGj0menqWFO6pHG+kujB9HuypnTeGfJ09vcwsN8UzK3O
	ipPOmeGdVtRM0vB4c/gKcpoF4mNU5Og=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787029052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vMAMpzwbbO2PcP763W17bjWyM5n0PJ8ANMuz8yzLNmo=;
	b=bXbeoc6VClK6xufhI3AdW+xALhwHjfM5JOK4c6QgfXHjelJl6Ib5BnRs220i+fyt/WG8o0
	fEndBu3FD+nxKbcsvtYGifspAfQ4RYDMey2frA6OOKzQUztkUMNcVWn0Yk7zJV1wFQkns2
	oXx7xu7SVxurBSfqNGmK2jxG9zmpJXQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB33022BA;
	Tue, 18 Aug 2026 04:57:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2HL5Gzrmg2rORwAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 18 Aug 2026 04:57:30 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] btrfs: tree-checker: reject file extent items for special files
Date: Tue, 18 Aug 2026 14:27:11 +0930
Message-ID: <b2dd29edaf1c476df248eb433ec2edf1771bcb96.1787029007.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

File extent items are only utilized by regular files or symlinks, other
files like directory/char/block/fifo/sock files should not have any file
extent item.

Previously we were unable to reject such cases, as the inode item may not
be in the same leaf.
But we already have @prev_key in check_leaf_item(), this means we just
need a new way to pass the mode of the previously hit inode item, then
we can detect such problems.

Introduce a new and tiny helper structure, last_inode_info, to record
the last hit inode number and its mode, and keep it across the whole
leaf.
Then if we hit a file extent item, and the inode item is in the same
leaf, we can refer to that last_inode_info to determine if we need to
reject the file extent item.

Now with the following corrupted fs tree, the kernel can safely reject
the leaf:

	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
		generation 3 transid 9 size 12 nbytes 16384
		block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
		sequence 1 flags 0x0(none)
	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
		index 0 namelen 2 name: ..
	item 2 key (256 DIR_ITEM 496027801) itemoff 16075 itemsize 36
		location key (257 INODE_ITEM 0) type FILE
		transid 9 data_len 0 name_len 6
		name: foobar
	item 3 key (256 DIR_INDEX 2) itemoff 16039 itemsize 36
		location key (257 INODE_ITEM 0) type FILE
		transid 9 data_len 0 name_len 6
		name: foobar
	item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
		generation 9 transid 9 size 8192 nbytes 8192
		block group 0 mode 60600 links 1 uid 0 gid 0 rdev 0
		                   ^^ This is BLK type, not REG.
		sequence 2 flags 0x0(none)
	item 5 key (257 INODE_REF 256) itemoff 15863 itemsize 16
		index 2 namelen 6 name: foobar
	item 6 key (257 EXTENT_DATA 0) itemoff 15810 itemsize 53
		generation 9 type 1 (regular)
		extent data disk byte 13631488 nr 8192
		extent data offset 0 nr 8192 ram 8192
		extent compression 0 (none)
		extent encryption 0

With the patch, kernel will reject it with the following tree-checker
errors:

 BTRFS critical (device loop0): corrupt leaf: root=5 block=30408704 slot=6 ino=257 file_offset=0, invalid file extent item, should not have any file extent for inode mode 060600
 BTRFS error (device loop0): read time tree block corruption detected on logical 30408704 mirror 1

Reported-by: ZhengYuan Huang <gality369@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/20260817132051.267646-1-gality369@gmail.com/
Assisted-by: LLM (for generating the corrupted image)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 68 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 0ce91396b517..b0858f6c88e4 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -163,6 +163,12 @@ static void dir_item_err(const struct extent_buffer *eb, int slot,
 	va_end(args);
 }
 
+/* Record info for the last hit inode. */
+struct last_inode_info {
+	u64 ino;
+	u32 mode;
+};
+
 /*
  * This functions checks prev_key->objectid, to ensure current key and prev_key
  * share the same objectid as inode number.
@@ -204,15 +210,47 @@ static bool check_prev_ino(struct extent_buffer *leaf,
 		prev_key->objectid, key->objectid);
 	return false;
 }
+
+static bool check_last_inode_info(struct extent_buffer *leaf,
+				  struct btrfs_key *key, int slot,
+				  u8 fi_type,
+				  const struct last_inode_info *last_inode)
+{
+	/* No inode item in this leaf. */
+	if (last_inode->ino != key->objectid)
+		return true;
+	if (S_ISREG(last_inode->mode))
+		return true;
+	if (S_ISLNK(last_inode->mode)) {
+		/* For symlink, the file extent item should always be inlined. */
+		if (unlikely(fi_type != BTRFS_FILE_EXTENT_INLINE)) {
+			file_extent_err(leaf, slot,
+			"invalid file extent type, have %u expect %u for symlink",
+					fi_type, BTRFS_FILE_EXTENT_INLINE);
+			return false;
+		}
+		return true;
+	}
+	/*
+	 * The remaining are special files, e.g. block/fifo files, which should
+	 * not have any file extent.
+	 */
+	file_extent_err(leaf, slot, "file extent item not allowed for inode mode 0%o",
+			last_inode->mode);
+	return false;
+}
+
 static int check_extent_data_item(struct extent_buffer *leaf,
 				  struct btrfs_key *key, int slot,
-				  struct btrfs_key *prev_key)
+				  struct btrfs_key *prev_key,
+				  const struct last_inode_info *last_inode)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_file_extent_item *fi;
 	u32 sectorsize = fs_info->sectorsize;
 	u32 item_size = btrfs_item_size(leaf, slot);
 	u64 extent_end;
+	u8 fi_type;
 
 	if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
 		file_extent_err(leaf, slot,
@@ -243,15 +281,17 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 				SZ_4K);
 		return -EUCLEAN;
 	}
-	if (unlikely(btrfs_file_extent_type(leaf, fi) >=
-		     BTRFS_NR_FILE_EXTENT_TYPES)) {
+	fi_type = btrfs_file_extent_type(leaf, fi);
+	if (unlikely(fi_type >= BTRFS_NR_FILE_EXTENT_TYPES)) {
 		file_extent_err(leaf, slot,
 		"invalid type for file extent, have %u expect range [0, %u]",
-			btrfs_file_extent_type(leaf, fi),
-			BTRFS_NR_FILE_EXTENT_TYPES - 1);
+			fi_type, BTRFS_NR_FILE_EXTENT_TYPES - 1);
 		return -EUCLEAN;
 	}
 
+	if (unlikely(!check_last_inode_info(leaf, key, slot, fi_type, last_inode)))
+		return -EUCLEAN;
+
 	/*
 	 * Support for new compression/encryption must introduce incompat flag,
 	 * and must be caught in open_ctree().
@@ -270,7 +310,8 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 			btrfs_file_extent_encryption(leaf, fi));
 		return -EUCLEAN;
 	}
-	if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
+
+	if (fi_type == BTRFS_FILE_EXTENT_INLINE) {
 		/* Inline extent must have 0 as key offset */
 		if (unlikely(key->offset)) {
 			file_extent_err(leaf, slot,
@@ -1206,7 +1247,8 @@ static int check_dev_item(struct extent_buffer *leaf,
 }
 
 static int check_inode_item(struct extent_buffer *leaf,
-			    struct btrfs_key *key, int slot)
+			    struct btrfs_key *key, int slot,
+			    struct last_inode_info *last_inode)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_inode_item *iitem;
@@ -1291,6 +1333,8 @@ static int check_inode_item(struct extent_buffer *leaf,
 			ro_flags);
 		return -EUCLEAN;
 	}
+	last_inode->ino = key->objectid;
+	last_inode->mode = mode;
 	return 0;
 }
 
@@ -2319,14 +2363,15 @@ static int check_free_space_bitmap(struct extent_buffer *leaf,
 static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 						    struct btrfs_key *key,
 						    int slot,
-						    struct btrfs_key *prev_key)
+						    struct btrfs_key *prev_key,
+						    struct last_inode_info *last_inode)
 {
 	int ret = 0;
 	struct btrfs_chunk *chunk;
 
 	switch (key->type) {
 	case BTRFS_EXTENT_DATA_KEY:
-		ret = check_extent_data_item(leaf, key, slot, prev_key);
+		ret = check_extent_data_item(leaf, key, slot, prev_key, last_inode);
 		break;
 	case BTRFS_EXTENT_CSUM_KEY:
 		ret = check_csum_item(leaf, key, slot, prev_key);
@@ -2356,7 +2401,7 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 		ret = check_dev_extent_item(leaf, key, slot, prev_key);
 		break;
 	case BTRFS_INODE_ITEM_KEY:
-		ret = check_inode_item(leaf, key, slot);
+		ret = check_inode_item(leaf, key, slot, last_inode);
 		break;
 	case BTRFS_ROOT_ITEM_KEY:
 		ret = check_root_item(leaf, key, slot);
@@ -2404,6 +2449,7 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 enum btrfs_tree_block_status __btrfs_check_leaf(struct extent_buffer *leaf)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
+	struct last_inode_info last_inode = { 0 };
 	/* No valid key type is 0, so all key should be larger than this key */
 	struct btrfs_key prev_key = {0, 0, 0};
 	struct btrfs_key key;
@@ -2539,7 +2585,7 @@ enum btrfs_tree_block_status __btrfs_check_leaf(struct extent_buffer *leaf)
 		}
 
 		/* Check if the item size and content meet other criteria. */
-		ret = check_leaf_item(leaf, &key, slot, &prev_key);
+		ret = check_leaf_item(leaf, &key, slot, &prev_key, &last_inode);
 		if (unlikely(ret != BTRFS_TREE_BLOCK_CLEAN))
 			return ret;
 
-- 
2.54.0

