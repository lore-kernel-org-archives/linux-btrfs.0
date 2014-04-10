Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34432 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965306AbaDJDuC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 23:50:02 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, <alanqk@gmail.com>,
        Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH v10 10/16] Btrfs: improve the delayed refs process in rm case
Date: Thu, 10 Apr 2014 11:48:40 +0800
Message-Id: <1397101727-20806-11-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
References: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While removing a file with dedup extents, we could have a great number of
delayed refs pending to process, and these refs refer to droping
a ref of the extent, which is of BTRFS_DROP_DELAYED_REF type.

But in order to prevent an extent's ref count from going down to zero when
there still are pending delayed refs, we first select those "adding a ref"
ones, which is of BTRFS_ADD_DELAYED_REF type.

So in removing case, all of our delayed refs are of BTRFS_DROP_DELAYED_REF type,
but we have to walk all the refs issued to the extent to find any
BTRFS_ADD_DELAYED_REF types and end up there is no such thing, and then start
over again to find BTRFS_DROP_DELAYED_REF.

This is really unnecessary, we can improve this by tracking how many
BTRFS_ADD_DELAYED_REF refs we have and search by the right type.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/delayed-ref.c |  8 ++++++++
 fs/btrfs/delayed-ref.h |  3 +++
 fs/btrfs/extent-tree.c | 16 +++++++++++++---
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 3ab37b6..6435d78 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -538,6 +538,9 @@ update_existing_head_ref(struct btrfs_delayed_ref_node *existing,
 	 * currently, for refs we just added we know we're a-ok.
 	 */
 	existing->ref_mod += update->ref_mod;
+	WARN_ON(update->ref_mod > 1);
+	if (update->ref_mod == 1)
+		existing_ref->add_cnt++;
 	spin_unlock(&existing_ref->lock);
 }
 
@@ -601,6 +604,11 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	head_ref->is_data = is_data;
 	head_ref->ref_root = RB_ROOT;
 	head_ref->processing = 0;
+	/* track added ref, more comments in select_delayed_ref() */
+	if (count_mod == 1)
+		head_ref->add_cnt = 1;
+	else
+		head_ref->add_cnt = 0;
 
 	spin_lock_init(&head_ref->lock);
 	mutex_init(&head_ref->mutex);
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 4ba9b93..905f991 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -87,6 +87,9 @@ struct btrfs_delayed_ref_head {
 	struct rb_node href_node;
 
 	struct btrfs_delayed_extent_op *extent_op;
+
+	int add_cnt;
+
 	/*
 	 * when a new extent is allocated, it is just reserved in memory
 	 * The actual extent isn't inserted into the extent allocation tree
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 088846c..191f0a7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2347,7 +2347,11 @@ static noinline struct btrfs_delayed_ref_node *
 select_delayed_ref(struct btrfs_delayed_ref_head *head)
 {
 	struct rb_node *node;
-	struct btrfs_delayed_ref_node *ref, *last = NULL;;
+	struct btrfs_delayed_ref_node *ref, *last = NULL;
+	int action = BTRFS_ADD_DELAYED_REF;
+
+	if (head->add_cnt == 0)
+		action = BTRFS_DROP_DELAYED_REF;
 
 	/*
 	 * select delayed ref of type BTRFS_ADD_DELAYED_REF first.
@@ -2358,10 +2362,13 @@ select_delayed_ref(struct btrfs_delayed_ref_head *head)
 	while (node) {
 		ref = rb_entry(node, struct btrfs_delayed_ref_node,
 				rb_node);
-		if (ref->action == BTRFS_ADD_DELAYED_REF)
+		if (ref->action == action) {
+			if (ref->action == BTRFS_ADD_DELAYED_REF)
+				head->add_cnt--;
 			return ref;
-		else if (last == NULL)
+		} else if (last == NULL) {
 			last = ref;
+		}
 		node = rb_next(node);
 	}
 	return last;
@@ -2435,6 +2442,9 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 
 		if (ref && ref->seq &&
 		    btrfs_check_delayed_seq(fs_info, delayed_refs, ref->seq)) {
+			if (ref->action == BTRFS_ADD_DELAYED_REF)
+				locked_ref->add_cnt++;
+
 			spin_unlock(&locked_ref->lock);
 			btrfs_delayed_ref_unlock(locked_ref);
 			spin_lock(&delayed_refs->lock);
-- 
1.8.1.4

