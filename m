Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64227 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820AbaAXTYw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 14:24:52 -0500
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s0OJOZYj019484
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 11:24:51 -0800
Received: from mail.thefacebook.com (prn1-cmdf-dc01-fw1-nat.corp.tfbnw.net [173.252.71.129] (may be forged))
	by mx0a-00082601.pphosted.com with ESMTP id 1hktw6gp6x-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 11:24:51 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: only process as many file extents as there are refs
Date: Fri, 24 Jan 2014 14:24:48 -0500
Message-ID: <1390591488-17642-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The backref walking code will search down to the key it is looking for and then
proceed to walk _all_ of the extents on the file until it hits the end.  This is
suboptimal with large files, we only need to look for as many extents as we have
references for that inode.  I have a testcase that creates a randomly written 4
gig file and before this patch it took 6min 30sec to do the initial send, with
this patch it takes 2min 30sec to do the intial send.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/backref.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index dcf2448..1538496 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -209,18 +209,19 @@ static int __add_prelim_ref(struct list_head *head, u64 root_id,
 }
 
 static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
-				struct ulist *parents, int level,
-				struct btrfs_key *key_for_search, u64 time_seq,
-				u64 wanted_disk_byte,
-				const u64 *extent_item_pos)
+			   struct ulist *parents, struct __prelim_ref *ref,
+			   int level, u64 time_seq, const u64 *extent_item_pos)
 {
 	int ret = 0;
 	int slot;
 	struct extent_buffer *eb;
 	struct btrfs_key key;
+	struct btrfs_key *key_for_search = &ref->key_for_search;
 	struct btrfs_file_extent_item *fi;
 	struct extent_inode_elem *eie = NULL, *old = NULL;
 	u64 disk_byte;
+	u64 wanted_disk_byte = ref->wanted_disk_byte;
+	u64 count = 0;
 
 	if (level != 0) {
 		eb = path->nodes[level];
@@ -238,7 +239,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 	if (path->slots[0] >= btrfs_header_nritems(path->nodes[0]))
 		ret = btrfs_next_old_leaf(root, path, time_seq);
 
-	while (!ret) {
+	while (!ret && count < ref->count) {
 		eb = path->nodes[0];
 		slot = path->slots[0];
 
@@ -254,6 +255,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 		if (disk_byte == wanted_disk_byte) {
 			eie = NULL;
 			old = NULL;
+			count++;
 			if (extent_item_pos) {
 				ret = check_extent_in_eb(&key, eb, fi,
 						*extent_item_pos,
@@ -334,9 +336,8 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 		eb = path->nodes[level];
 	}
 
-	ret = add_all_parents(root, path, parents, level, &ref->key_for_search,
-				time_seq, ref->wanted_disk_byte,
-				extent_item_pos);
+	ret = add_all_parents(root, path, parents, ref, level, time_seq,
+			      extent_item_pos);
 out:
 	path->lowest_level = 0;
 	btrfs_release_path(path);
-- 
1.8.3.1

