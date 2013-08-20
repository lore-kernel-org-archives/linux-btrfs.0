Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33549 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3HTT5M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 15:57:12 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2AFAE9A06AE
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 13:57:11 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id gCHNTUa4syQCoTSP (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 13:57:10 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix send to deal with sparse files properly
Date: Tue, 20 Aug 2013 15:57:08 -0400
Message-ID: <1377028628-19544-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Send was just sending everything it found, even if the extent was a hole.  This
is unpleasant for users, so just skip holes when we are sending.  This will also
skip sending prealloc extents since the send spec doesn't have a prealloc
command.  Eventually we will add a prealloc command and rev the send version so
we can send down the prealloc info.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/send.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index db7da68..3a1e75a 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4011,8 +4011,10 @@ static int process_extent(struct send_ctx *sctx,
 			  struct btrfs_path *path,
 			  struct btrfs_key *key)
 {
-	int ret = 0;
 	struct clone_root *found_clone = NULL;
+	struct btrfs_file_extent_item *ei;
+	int ret = 0;
+	u8 type;
 
 	if (S_ISLNK(sctx->cur_inode_mode))
 		return 0;
@@ -4027,6 +4029,27 @@ static int process_extent(struct send_ctx *sctx,
 		}
 	}
 
+	ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			    struct btrfs_file_extent_item);
+	type = btrfs_file_extent_type(path->nodes[0], ei);
+	if (type == BTRFS_FILE_EXTENT_PREALLOC ||
+	    type == BTRFS_FILE_EXTENT_REG) {
+		/*
+		 * The send spec does not have a prealloc command yet, so just
+		 * leave a hole for prealloc'ed extents until we have enough
+		 * commands queued up to justify rev'ing the send spec.
+		 */
+		if (type == BTRFS_FILE_EXTENT_PREALLOC) {
+			ret = 0;
+			goto out;
+		}
+
+		/* Have a hole, just skip it. */
+		if (btrfs_file_extent_disk_bytenr(path->nodes[0], ei) == 0) {
+			ret = 0;
+			goto out;
+		}
+	}
 	ret = find_extent_clone(sctx, path, key->objectid, key->offset,
 			sctx->cur_inode_size, &found_clone);
 	if (ret != -ENOENT && ret < 0)
-- 
1.7.7.6

