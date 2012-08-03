Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:44934 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2HCJvn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2012 05:51:43 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q739pfeS032416
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Aug 2012 09:51:41 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q739peXW023841
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Aug 2012 09:51:41 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q739pe8Y018801
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Aug 2012 04:51:40 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 8/9] Btrfs-progs: add otime to the snapshot list
Date: Fri,  3 Aug 2012 17:48:57 +0800
Message-Id: <1343987338-10612-10-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
References: <1343822481-26707-1-git-send-email-Anand.Jain@oracle.com>
 <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Alexander Block <ablock84@googlemail.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c |   45 ++++++++++++++++++++++++++++++++++++---------
 1 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 1db99ae..e0cb782 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -60,6 +60,9 @@ struct root_info {
 	/* generation when the root is created or last updated */
 	u64 gen;
 
+	/* creation time of this root in sec*/
+	time_t otime;
+
 	/* path from the subvol we live in to this root, including the
 	 * root's name.  This is null until we do the extra lookup ioctl.
 	 */
@@ -185,7 +188,7 @@ static struct root_info *tree_search(struct rb_root *root, u64 root_id)
  */
 static int add_root(struct root_lookup *root_lookup,
 		    u64 root_id, u64 ref_tree, u64 dir_id, char *name,
-		    int name_len, u64 *gen)
+		    int name_len, u64 *gen, time_t ot)
 {
 	struct root_info *ri;
 	struct rb_node *ret;
@@ -205,6 +208,7 @@ static int add_root(struct root_lookup *root_lookup,
 		ri->name[name_len-1] = 0;
 	if (gen)
 		ri->gen = *gen;
+	ri->otime = ot;
 
 	ret = tree_insert(&root_lookup->root, root_id, ref_tree, gen,
 			  &ri->rb_node);
@@ -215,7 +219,8 @@ static int add_root(struct root_lookup *root_lookup,
 	return 0;
 }
 
-static int update_root(struct root_lookup *root_lookup, u64 root_id, u64 gen)
+static int update_root(struct root_lookup *root_lookup, u64 root_id, u64 gen,
+			time_t ot)
 {
 	struct root_info *ri;
 
@@ -225,6 +230,7 @@ static int update_root(struct root_lookup *root_lookup, u64 root_id, u64 gen)
 		return -ENOENT;
 	}
 	ri->gen = gen;
+	ri->otime = ot;
 	return 0;
 }
 
@@ -658,6 +664,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	u64 gen = 0;
 	int i;
 	int get_gen = 0;
+	time_t t;
 
 	root_lookup_init(root_lookup);
 	memset(&args, 0, sizeof(args));
@@ -711,12 +718,16 @@ again:
 				dir_id = btrfs_stack_root_ref_dirid(ref);
 
 				add_root(root_lookup, sh->objectid, sh->offset,
-					 dir_id, name, name_len, NULL);
+					 dir_id, name, name_len, NULL, 0);
 			} else if (get_gen && sh->type == BTRFS_ROOT_ITEM_KEY) {
 				ri = (struct btrfs_root_item *)(args.buf + off);
 				gen = btrfs_root_generation(ri);
+				if(ri->generation == ri->generation_v2)
+					t = ri->otime.sec;
+				else
+					t = 0;
 
-				update_root(root_lookup, sh->objectid, gen);
+				update_root(root_lookup, sh->objectid, gen, t);
 			}
 
 			off += sh->len;
@@ -805,14 +816,21 @@ static int __list_snapshot_search(int fd, struct root_lookup *root_lookup)
 		 * read the root_ref item it contains
 		 */
 		for (i = 0; i < sk->nr_items; i++) {
+			struct btrfs_root_item *item;
+			time_t  t;
 			sh = (struct btrfs_ioctl_search_header *)(args.buf +
 								  off);
 			off += sizeof(*sh);
 			if (sh->type == BTRFS_ROOT_ITEM_KEY && sh->offset) {
+				item = (struct btrfs_root_item *)(args.buf + off);
+				if(item->generation == item->generation_v2)
+					t = item->otime.sec;
+				else
+					t = 0;
 				gen = sh->offset;
 
 				add_root(root_lookup, sh->objectid, 0,
-					 0, NULL, 0, &gen);
+					 0, NULL, 0, &gen, t);
 			}
 			off += sh->len;
 
@@ -981,24 +999,33 @@ int list_snapshots(int fd, int print_parent, int order)
 		u64 level;
 		u64 parent_id;
 		char *path;
+		time_t t;
+		char tstr[256];
 
 		entry_snap = rb_entry(n, struct root_info, rb_node);
 		entry = tree_search(&root_lookup.root, entry_snap->root_id);
 
 		resolve_root(&root_lookup, entry, &parent_id, &level, &path);
+		t = entry->otime;
+		if(t)
+			strftime(tstr,256,"%Y-%m-%d %X",localtime(&t));
+		else
+			strcpy(tstr,"-");
 		if (print_parent) {
-			printf("ID %llu gen %llu cgen %llu parent %llu top level %llu path %s\n",
+			printf("ID %llu gen %llu cgen %llu parent %llu top level %llu "
+				"otime %s path %s\n",
 				(unsigned long long)entry->root_id,
 				(unsigned long long)entry->gen,
 				(unsigned long long)entry_snap->gen,
 				(unsigned long long)parent_id,
-				(unsigned long long)level, path);
+				(unsigned long long)level, tstr, path);
 		} else {
-			printf("ID %llu gen %llu cgen %llu top level %llu path %s\n",
+			printf("ID %llu gen %llu cgen %llu top level %llu "
+				"otime %s path %s\n",
 				(unsigned long long)entry->root_id,
 				(unsigned long long)entry->gen,
 				(unsigned long long)entry_snap->gen,
-				(unsigned long long)level, path);
+				(unsigned long long)level, tstr, path);
 		}
 
 		free(path);
-- 
1.7.1

