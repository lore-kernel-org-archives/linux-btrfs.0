Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6FF3C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 05:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA1A3218D2
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 05:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbfAYFJy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 00:09:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:56244 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726638AbfAYFJy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 00:09:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 34810ADF5;
        Fri, 25 Jan 2019 05:09:52 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Leonard Lausen <leonard@lausen.nl>
Subject: [PATCH v4 12/12] btrfs: Do mandatory tree block check before submitting bio
Date:   Fri, 25 Jan 2019 13:09:25 +0800
Message-Id: <20190125050925.30754-13-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125050925.30754-1-wqu@suse.com>
References: <20190125050925.30754-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are at least 2 reports about memory bit flip sneaking into on-disk
data.

Currently we only have a relaxed check triggered at
btrfs_mark_buffer_dirty() time, as it's not mandatory and only for
CONFIG_BTRFS_FS_CHECK_INTEGRITY enabled build, it doesn't help user to
detect such problem.

This patch will address the hole by triggering comprehensive check on
tree blocks before writing it back to disk.

The design points are:
- Timing of the check: Tree block write hook
  This timing is chosen to reduce the overhead.
  The comprehensive check should be as expensive as csum.
  Doing full check at btrfs_mark_buffer_dirty() is too expensive for end
  user.

- Loose empty leaf check
  Originally for empty leaf, tree-checker will report error if it's not
  a tree root.
  The problem for such check at write time is:
  * False alert for tree root created in current transaction
    In that case, the commit root still needs to be written to disk.
    And since current root can differ from commit root, then it will
    cause false alert.
    This happens for log tree.

  * False alert for relocated tree block
    Relocated tree block can be written to disk due to memory pressure,
    in that case an empty csum tree root can be written to disk and
    cause false alert, since csum root node hasn't been updated.

  Although some more reliable empty leaf check is still kept as is.
  Namely essential trees (e.g. extent, chunk) should never be empty.

The example error output will be something like:
  BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
  BTRFS error (device dm-3): write time tree block corruption detected
  BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=-5 IO failure (Error while writing out transaction)
  BTRFS info (device dm-3): forced readonly
  BTRFS warning (device dm-3): Skipping commit of aborted transaction.
  BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=-5 IO failure
  BTRFS info (device dm-3): delayed_refs has NO entry

Reported-by: Leonard Lausen <leonard@lausen.nl>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c      |  9 +++++++++
 fs/btrfs/tree-checker.c | 24 +++++++++++++++++++++---
 fs/btrfs/tree-checker.h |  8 ++++++++
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 426e9f450f70..135d84ed72eb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -313,6 +313,15 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
 			return -EUCLEAN;
 		}
 	} else {
+		if (btrfs_header_level(buf))
+			err = btrfs_check_node(fs_info, buf);
+		else
+			err = btrfs_check_leaf_write(fs_info, buf);
+		if (err < 0) {
+			btrfs_err(fs_info,
+				  "write time tree block corruption detected");
+			return err;
+		}
 		write_extent_buffer(buf, result, 0, csum_size);
 	}
 
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index a62e1e837a89..b8cdaf472031 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -477,7 +477,7 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
 }
 
 static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
-		      bool check_item_data)
+		      bool check_item_data, bool check_empty_leaf)
 {
 	/* No valid key type is 0, so all key should be larger than this key */
 	struct btrfs_key prev_key = {0, 0, 0};
@@ -516,6 +516,18 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 				    owner);
 			return -EUCLEAN;
 		}
+
+		/*
+		 * Skip empty leaf check, mostly for write time tree block
+		 *
+		 * Such skip mostly happens for tree block write time, as
+		 * we can't use @owner as accurate owner indicator.
+		 * Case like balance and new tree block created for commit root
+		 * can break owner check easily.
+		 */
+		if (!check_empty_leaf)
+			return 0;
+
 		key.objectid = owner;
 		key.type = BTRFS_ROOT_ITEM_KEY;
 		key.offset = (u64)-1;
@@ -636,13 +648,19 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 int btrfs_check_leaf_full(struct btrfs_fs_info *fs_info,
 			  struct extent_buffer *leaf)
 {
-	return check_leaf(fs_info, leaf, true);
+	return check_leaf(fs_info, leaf, true, true);
 }
 
 int btrfs_check_leaf_relaxed(struct btrfs_fs_info *fs_info,
 			     struct extent_buffer *leaf)
 {
-	return check_leaf(fs_info, leaf, false);
+	return check_leaf(fs_info, leaf, false, true);
+}
+
+int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
+			   struct extent_buffer *leaf)
+{
+	return check_leaf(fs_info, leaf, false, false);
 }
 
 int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node)
diff --git a/fs/btrfs/tree-checker.h b/fs/btrfs/tree-checker.h
index ff043275b784..6f8d1b627c53 100644
--- a/fs/btrfs/tree-checker.h
+++ b/fs/btrfs/tree-checker.h
@@ -23,6 +23,14 @@ int btrfs_check_leaf_full(struct btrfs_fs_info *fs_info,
  */
 int btrfs_check_leaf_relaxed(struct btrfs_fs_info *fs_info,
 			     struct extent_buffer *leaf);
+
+/*
+ * Write time specific leaf checker.
+ * Don't check if the empty leaf belongs to a tree root. Mostly for balance
+ * and new tree created in current transaction.
+ */
+int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
+			   struct extent_buffer *leaf);
 int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node);
 
 #endif
-- 
2.20.1

