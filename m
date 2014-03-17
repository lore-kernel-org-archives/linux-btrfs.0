Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48959 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbaCQUeY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 16:34:24 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s2HKVJsq003778
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Mar 2014 13:34:23 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1jny3khsuj-3
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Mar 2014 13:34:23 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: take into account total references when doing backref lookup
Date: Mon, 17 Mar 2014 16:34:02 -0400
Message-ID: <1395088442-6468-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I added an optimization for large files where we would stop searching for
backrefs once we had looked at the number of references we currently had for
this extent.  This works great most of the time, but for snapshots that point to
this extent and has changes in the original root this assumption falls on it
face.  So keep track of any shared refs that point at the bytenr and add their
count to any ref that is going to need indirect references looked up.  Then use
this count as the upper limit for searching through an inode for a bytenr.  With
this patch we can now find offsets deep in heavily fragmented extents.  Thanks,

Reportedy-by: Hugo Mills <hugo@carfax.org.uk>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/backref.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 0be0e94..4a56d83 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -127,6 +127,7 @@ struct __prelim_ref {
 	struct extent_inode_elem *inode_list;
 	u64 parent;
 	u64 wanted_disk_byte;
+	u64 total_possible_refs;
 };
 
 static struct kmem_cache *btrfs_prelim_ref_cache;
@@ -213,6 +214,7 @@ static int __add_prelim_ref(struct list_head *head, u64 root_id,
 	ref->count = count;
 	ref->parent = parent;
 	ref->wanted_disk_byte = wanted_disk_byte;
+	ref->total_possible_refs = count;
 	list_add_tail(&ref->list, head);
 
 	return 0;
@@ -249,7 +251,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 	if (path->slots[0] >= btrfs_header_nritems(path->nodes[0]))
 		ret = btrfs_next_old_leaf(root, path, time_seq);
 
-	while (!ret && count < ref->count) {
+	while (!ret && count < ref->total_possible_refs) {
 		eb = path->nodes[0];
 		slot = path->slots[0];
 
@@ -521,19 +523,16 @@ static void __merge_refs(struct list_head *head, int mode)
 		for (pos2 = pos1->next, n2 = pos2->next; pos2 != head;
 		     pos2 = n2, n2 = pos2->next) {
 			struct __prelim_ref *ref2;
-			struct __prelim_ref *xchg;
 			struct extent_inode_elem *eie;
 
 			ref2 = list_entry(pos2, struct __prelim_ref, list);
 
 			if (mode == 1) {
+				if (!ref1->parent && ref2->parent)
+					ref1->total_possible_refs +=
+						ref2->count;
 				if (!ref_for_same_block(ref1, ref2))
 					continue;
-				if (!ref1->parent && ref2->parent) {
-					xchg = ref1;
-					ref1 = ref2;
-					ref2 = xchg;
-				}
 			} else {
 				if (ref1->parent != ref2->parent)
 					continue;
@@ -547,6 +546,7 @@ static void __merge_refs(struct list_head *head, int mode)
 			else
 				ref1->inode_list = ref2->inode_list;
 			ref1->count += ref2->count;
+			ref1->total_possible_refs += ref2->count;
 
 			list_del(&ref2->list);
 			kmem_cache_free(btrfs_prelim_ref_cache, ref2);
-- 
1.8.3.1

