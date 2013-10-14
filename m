Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30975 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3JNFBE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 01:01:04 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r9E513dn000453
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:03 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E5124b029331
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:03 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E512pT029867
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:02 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v7 02/13] Btrfs: improve the delayed refs process in rm case
Date: Mon, 14 Oct 2013 12:59:44 +0800
Message-Id: <1381726796-27191-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
References: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
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
 fs/btrfs/delayed-ref.c |   10 ++++++++++
 fs/btrfs/delayed-ref.h |    3 +++
 fs/btrfs/extent-tree.c |   17 ++++++++++++++++-
 3 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index b0d5d79..9596649 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -543,6 +543,10 @@ update_existing_head_ref(struct btrfs_delayed_ref_node *existing,
 	 * update the reference mod on the head to reflect this new operation
 	 */
 	existing->ref_mod += update->ref_mod;
+
+	WARN_ON_ONCE(update->ref_mod > 1);
+	if (update->ref_mod == 1)
+		existing_ref->add_cnt++;
 }
 
 /*
@@ -604,6 +608,12 @@ static noinline void add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	head_ref->must_insert_reserved = must_insert_reserved;
 	head_ref->is_data = is_data;
 
+	/* track added ref, more comments in select_delayed_ref() */
+	if (count_mod == 1)
+		head_ref->add_cnt = 1;
+	else
+		head_ref->add_cnt = 0;
+
 	INIT_LIST_HEAD(&head_ref->cluster);
 	mutex_init(&head_ref->mutex);
 
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 70b962c..9377b27 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -84,6 +84,9 @@ struct btrfs_delayed_ref_head {
 	struct list_head cluster;
 
 	struct btrfs_delayed_extent_op *extent_op;
+
+	int add_cnt;
+
 	/*
 	 * when a new extent is allocated, it is just reserved in memory
 	 * The actual extent isn't inserted into the extent allocation tree
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d58bef1..f5bf1a8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2280,6 +2280,16 @@ select_delayed_ref(struct btrfs_delayed_ref_head *head)
 	struct rb_node *node;
 	struct btrfs_delayed_ref_node *ref;
 	int action = BTRFS_ADD_DELAYED_REF;
+
+	/*
+	 * track the count of BTRFS_ADD_DELAYED_REF,
+	 * in the case that there's no BTRFS_ADD_DELAYED_REF while there're a
+	 * a great number of BTRFS_DROP_DELAYED_REF,
+	 * it'll waste time on searching BTRFS_ADD_DELAYED_REF, usually this
+	 * happens with dedup enabled.
+	 */
+	if (head->add_cnt == 0)
+		action = BTRFS_DROP_DELAYED_REF;
 again:
 	/*
 	 * select delayed ref of type BTRFS_ADD_DELAYED_REF first.
@@ -2294,8 +2304,11 @@ again:
 				rb_node);
 		if (ref->bytenr != head->node.bytenr)
 			break;
-		if (ref->action == action)
+		if (ref->action == action) {
+			if (action == BTRFS_ADD_DELAYED_REF)
+				head->add_cnt--;
 			return ref;
+		}
 		node = rb_prev(node);
 	}
 	if (action == BTRFS_ADD_DELAYED_REF) {
@@ -2371,6 +2384,8 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 			 * there are still refs with lower seq numbers in the
 			 * process of being added. Don't run this ref yet.
 			 */
+			if (ref->action == BTRFS_ADD_DELAYED_REF)
+				locked_ref->add_cnt++;
 			list_del_init(&locked_ref->cluster);
 			btrfs_delayed_ref_unlock(locked_ref);
 			locked_ref = NULL;
-- 
1.7.7

