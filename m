Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49042 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755279AbaC0Xli (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Mar 2014 19:41:38 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: <stable@vger.kernel.org>
Subject: [PATCH] Btrfs: check for an extent_op on the locked ref
Date: Thu, 27 Mar 2014 19:41:34 -0400
Message-ID: <1395963694-1634-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We could have possibly added an extent_op to the locked_ref while we dropped
locked_ref->lock, so check for this case as well and loop around.  Otherwise we
could lose flag updates which would lead to extent tree corruption.  Thanks,

cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a050e83..af5a656 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2448,7 +2448,8 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			spin_unlock(&locked_ref->lock);
 			spin_lock(&delayed_refs->lock);
 			spin_lock(&locked_ref->lock);
-			if (rb_first(&locked_ref->ref_root)) {
+			if (rb_first(&locked_ref->ref_root) ||
+			    locked_ref->extent_op) {
 				spin_unlock(&locked_ref->lock);
 				spin_unlock(&delayed_refs->lock);
 				continue;
-- 
1.8.3.1

