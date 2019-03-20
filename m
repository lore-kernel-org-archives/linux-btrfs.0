Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B575C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 311BF2184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfCTGhk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:37:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:40924 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727726AbfCTGhj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:37:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DB96BAE20
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 06:37:37 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCh v2 8/9] btrfs: tree-checker: Verify inode item
Date:   Wed, 20 Mar 2019 14:37:16 +0800
Message-Id: <20190320063717.31770-9-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190320063717.31770-1-wqu@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is a report in kernel bugzilla about mismatch file type in dir
item and inode item.

This inspires us to check inode mode in inode item.

This patch will check the following members:
- inode key objectid
  Should be ROOT_DIR_DIR or [256, (u64)-256] or FREE_INO.

- inode key offset
  Should be 0

- inode item generation
- inode item transid
  No newer than sb generation + 1.
  The +1 is for log tree.

- inode item mode
  No unknown bits.
  No invalid S_IF* bit.
  NOTE: S_IFMT check is not enough, need to check every know type.

- inode item nlink
  Dir should have no more link than 1.

- inode item flags

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h        |  2 +
 fs/btrfs/tree-checker.c | 99 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b3642367a595..b0f19cc56485 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1539,6 +1539,8 @@ do {                                                                   \
 #define BTRFS_INODE_COMPRESS		(1 << 11)
 
 #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
+#define BTRFS_INODE_FLAG_MASK		(((1 << 12) - 1) |\
+					 BTRFS_INODE_ROOT_ITEM_INIT)
 
 struct btrfs_map_token {
 	const struct extent_buffer *eb;
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index fef0cd8c90a5..fa0ad9e7de6e 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -689,6 +689,102 @@ static int check_dev_item(struct btrfs_fs_info *fs_info,
 	return -EUCLEAN;
 }
 
+/* Inode item error output has the same format as dir_item_err() */
+#define inode_item_err(fs_info, eb, slot, fmt, ...)	\
+	dir_item_err(fs_info, eb, slot, fmt, __VA_ARGS__)
+
+static int check_inode_item(struct btrfs_fs_info *fs_info,
+			    struct extent_buffer *leaf,
+			    struct btrfs_key *key, int slot)
+{
+	struct btrfs_inode_item *iitem;
+	u64 super_gen = btrfs_super_generation(fs_info->super_copy);
+	u32 valid_mask = (S_IFMT | S_ISUID | S_ISGID | S_ISVTX | 0777);
+	u32 mode;
+
+	if ((key->objectid < BTRFS_FIRST_FREE_OBJECTID ||
+	     key->objectid > BTRFS_LAST_FREE_OBJECTID) &&
+	     key->objectid != BTRFS_ROOT_TREE_DIR_OBJECTID &&
+	     key->objectid != BTRFS_FREE_INO_OBJECTID) {
+		generic_err(fs_info, leaf, slot,
+	"invalid key objectid: has %llu expect %llu or [%llu, %llu] or %llu",
+			    key->objectid, BTRFS_ROOT_TREE_DIR_OBJECTID,
+			    BTRFS_FIRST_FREE_OBJECTID,
+			    BTRFS_LAST_FREE_OBJECTID,
+			    BTRFS_FREE_INO_OBJECTID);
+		goto error;
+	}
+	if (key->offset != 0) {
+		inode_item_err(fs_info, leaf, slot,
+			"invalid key offset: has %llu expect 0",
+			key->offset);
+		goto error;
+	}
+	iitem = btrfs_item_ptr(leaf, slot, struct btrfs_inode_item);
+
+	/* Here we use super block generation + 1 to handle log tree */
+	if (btrfs_inode_generation(leaf, iitem) > super_gen + 1) {
+		inode_item_err(fs_info, leaf, slot,
+			"invalid inode generation: has %llu expect (0, %llu]",
+			       btrfs_inode_generation(leaf, iitem),
+			       super_gen + 1);
+		goto error;
+	}
+	/* Note for ROOT_TREE_DIR_ITEM, mkfs could make its transid as 0 */
+	if (btrfs_inode_transid(leaf, iitem) > super_gen + 1) {
+		inode_item_err(fs_info, leaf, slot,
+			"invalid inode generation: has %llu expect [0, %llu]",
+			       btrfs_inode_transid(leaf, iitem),
+			       super_gen + 1);
+		goto error;
+	}
+
+	/*
+	 * For size and nbytes it's better not to be too strict, as for dir
+	 * item its size/nbytes can easily get wrong, but doesn't affect
+	 * any thing of the fs. So here we skip the check.
+	 */
+
+	mode = btrfs_inode_mode(leaf, iitem);
+	if (mode & ~valid_mask) {
+		inode_item_err(fs_info, leaf, slot,
+			       "unknown mode bit detected: 0x%x",
+			       mode & ~valid_mask);
+		goto error;
+	}
+
+	/*
+	 * S_IFMT is not bit mapped so we can't completely rely is_power_of_2(),
+	 * but is_power_of_2() can save us from checking FIFO/CHR/DIR/REG.
+	 * Only needs to check BLK, LNK and SOCKS
+	 */
+	if (!is_power_of_2(mode & S_IFMT)) {
+		if (!S_ISLNK(mode) && ! S_ISBLK(mode) && !S_ISSOCK(mode)) {
+			inode_item_err(fs_info, leaf, slot,
+			"invalid mode: has 0%o expect valid S_IF* bit(s)",
+				       mode & S_IFMT);
+			goto error;
+		}
+	}
+	if (S_ISDIR(mode) && btrfs_inode_nlink(leaf, iitem) > 1) {
+		inode_item_err(fs_info, leaf, slot,
+			       "invalid nlink: has %u expect no more than 1 for dir",
+			btrfs_inode_nlink(leaf, iitem));
+		goto error;
+	}
+	if (btrfs_inode_flags(leaf, iitem) & ~BTRFS_INODE_FLAG_MASK) {
+		inode_item_err(fs_info, leaf, slot,
+			       "unknown flags detected: 0x%llx",
+			       btrfs_inode_flags(leaf, iitem) &
+			       ~BTRFS_INODE_FLAG_MASK);
+		goto error;
+	}
+	return 0;
+
+error:
+	return -EUCLEAN;
+}
+
 /*
  * Common point to switch the item-specific validation.
  */
@@ -722,6 +818,9 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
 	case BTRFS_DEV_ITEM_KEY:
 		ret = check_dev_item(fs_info, leaf, key, slot);
 		break;
+	case BTRFS_INODE_ITEM_KEY:
+		ret = check_inode_item(fs_info, leaf, key, slot);
+		break;
 	}
 	return ret;
 }
-- 
2.21.0

