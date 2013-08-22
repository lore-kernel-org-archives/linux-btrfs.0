Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:42628 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab3HVPrx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 11:47:53 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id B54417C0403
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 09:47:52 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id 5YOljkGYqcbBtz9r (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 09:47:52 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix send to deal with sparse files properly V2
Date: Thu, 22 Aug 2013 11:47:50 -0400
Message-ID: <1377186470-4000-1-git-send-email-jbacik@fusionio.com>
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
V1->V2: fix where we were skipping holes that needed to be written because we
punched a hole between the original snapshot and the send snapshot.

 fs/btrfs/send.c |   34 +++++++++++++++++++++++++++++++---
 1 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index db7da68..cbe92da 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3920,7 +3920,8 @@ static int is_extent_unchanged(struct send_ctx *sctx,
 	btrfs_item_key_to_cpu(eb, &found_key, slot);
 	if (found_key.objectid != key.objectid ||
 	    found_key.type != key.type) {
-		ret = 0;
+		/* If we're a hole then just pretend nothing changed */
+		ret = (left_disknr) ? 0 : 1;
 		goto out;
 	}
 
@@ -3946,7 +3947,8 @@ static int is_extent_unchanged(struct send_ctx *sctx,
 		 * This may only happen on the first iteration.
 		 */
 		if (found_key.offset + right_len <= ekey->offset) {
-			ret = 0;
+			/* If we're a hole just pretend nothing changed */
+			ret = (left_disknr) ? 0 : 1;
 			goto out;
 		}
 
@@ -4011,8 +4013,8 @@ static int process_extent(struct send_ctx *sctx,
 			  struct btrfs_path *path,
 			  struct btrfs_key *key)
 {
-	int ret = 0;
 	struct clone_root *found_clone = NULL;
+	int ret = 0;
 
 	if (S_ISLNK(sctx->cur_inode_mode))
 		return 0;
@@ -4025,6 +4027,32 @@ static int process_extent(struct send_ctx *sctx,
 			ret = 0;
 			goto out;
 		}
+	} else {
+		struct btrfs_file_extent_item *ei;
+		u8 type;
+
+		ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				    struct btrfs_file_extent_item);
+		type = btrfs_file_extent_type(path->nodes[0], ei);
+		if (type == BTRFS_FILE_EXTENT_PREALLOC ||
+		    type == BTRFS_FILE_EXTENT_REG) {
+			/*
+			 * The send spec does not have a prealloc command yet,
+			 * so just leave a hole for prealloc'ed extents until
+			 * we have enough commands queued up to justify rev'ing
+			 * the send spec.
+			 */
+			if (type == BTRFS_FILE_EXTENT_PREALLOC) {
+				ret = 0;
+				goto out;
+			}
+
+			/* Have a hole, just skip it. */
+			if (btrfs_file_extent_disk_bytenr(path->nodes[0], ei) == 0) {
+				ret = 0;
+				goto out;
+			}
+		}
 	}
 
 	ret = find_extent_clone(sctx, path, key->objectid, key->offset,
-- 
1.7.7.6

