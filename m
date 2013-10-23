Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab3JWRAM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 13:00:12 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 39F38A591F
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 19:00:11 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: add filter for deleted but uncleanded subvolumes
Date: Wed, 23 Oct 2013 19:00:09 +0200
Message-Id: <1382547609-12858-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

New option to subvolume list that acts as a global filter and applies
the other filters to either live subvolumes or the uncleaned ones.

The path to the deleted subvolumes is lost at the deletion time, sample
output looks like:

ID 259 gen 7 top level 0 path <FS_TREE>/DELETED

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs-list.c     |   24 +++++++++++++++++++++---
 btrfs-list.h     |    4 ++++
 cmds-subvolume.c |    8 +++++++-
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 9411e4d..f3618b9 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1173,6 +1173,11 @@ static int filter_by_parent(struct root_info *ri, u64 data)
 	return !uuid_compare(ri->puuid, (u8 *)(unsigned long)data);
 }
 
+static int filter_deleted(struct root_info *ri, u64 data)
+{
+	return ri->deleted;
+}
+
 static btrfs_list_filter_func all_filter_funcs[] = {
 	[BTRFS_LIST_FILTER_ROOTID]		= filter_by_rootid,
 	[BTRFS_LIST_FILTER_SNAPSHOT_ONLY]	= filter_snapshot,
@@ -1186,6 +1191,7 @@ static btrfs_list_filter_func all_filter_funcs[] = {
 	[BTRFS_LIST_FILTER_TOPID_EQUAL]		= filter_topid_equal,
 	[BTRFS_LIST_FILTER_FULL_PATH]		= filter_full_path,
 	[BTRFS_LIST_FILTER_BY_PARENT]		= filter_by_parent,
+	[BTRFS_LIST_FILTER_DELETED]		= filter_deleted,
 };
 
 struct btrfs_list_filter_set *btrfs_list_alloc_filter_set(void)
@@ -1222,6 +1228,11 @@ int btrfs_list_setup_filter(struct btrfs_list_filter_set **filter_set,
 	BUG_ON(filter >= BTRFS_LIST_FILTER_MAX);
 	BUG_ON(set->nfilters > set->total);
 
+	if (filter == BTRFS_LIST_FILTER_DELETED) {
+		set->only_deleted = 1;
+		return 0;
+	}
+
 	if (set->nfilters == set->total) {
 		size = set->total + BTRFS_LIST_NFILTERS_INCREASE;
 		size = sizeof(*set) + size * sizeof(struct btrfs_list_filter);
@@ -1254,6 +1265,12 @@ static int filter_root(struct root_info *ri,
 	if (!set || !set->nfilters)
 		return 1;
 
+	if (set->only_deleted && !ri->deleted)
+		return 0;
+
+	if (!set->only_deleted && ri->deleted)
+		return 0;
+
 	for (i = 0; i < set->nfilters; i++) {
 		if (!set->filters[i].filter_func)
 			break;
@@ -1281,12 +1298,13 @@ static void __filter_and_sort_subvol(struct root_lookup *all_subvols,
 		entry = rb_entry(n, struct root_info, rb_node);
 
 		ret = resolve_root(all_subvols, entry, top_id);
-		if (ret == -ENOENT)
-			goto skip;
+		if (ret == -ENOENT) {
+			entry->full_path = strdup("DELETED");
+			entry->deleted = 1;
+		}
 		ret = filter_root(entry, filter_set);
 		if (ret)
 			sort_tree_insert(sort_tree, entry, comp_set);
-skip:
 		n = rb_prev(n);
 	}
 }
diff --git a/btrfs-list.h b/btrfs-list.h
index 5164467..724e973 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -71,6 +71,8 @@ struct root_info {
 	char *name;
 
 	char *full_path;
+
+	int deleted;
 };
 
 typedef int (*btrfs_list_filter_func)(struct root_info *, u64);
@@ -90,6 +92,7 @@ struct btrfs_list_comparer {
 struct btrfs_list_filter_set {
 	int total;
 	int nfilters;
+	int only_deleted;
 	struct btrfs_list_filter filters[0];
 };
 
@@ -127,6 +130,7 @@ enum btrfs_list_filter_enum {
 	BTRFS_LIST_FILTER_TOPID_EQUAL,
 	BTRFS_LIST_FILTER_FULL_PATH,
 	BTRFS_LIST_FILTER_BY_PARENT,
+	BTRFS_LIST_FILTER_DELETED,
 	BTRFS_LIST_FILTER_MAX,
 };
 
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 63c708e..76dab1f 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -317,6 +317,7 @@ static const char * const cmd_subvol_list_usage[] = {
 	"-t           print the result as a table",
 	"-s           list snapshots only in the filesystem",
 	"-r           list readonly subvolumes (including snapshots)",
+	"-d           list deleted subvolumes that are not yet cleaned",
 	"-G [+|-]value",
 	"             filter the subvolumes by generation",
 	"             (+value: >= value; -value: <= value; value: = value)",
@@ -355,7 +356,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	optind = 1;
 	while(1) {
 		c = getopt_long(argc, argv,
-				    "acgopqsurG:C:t", long_options, NULL);
+				    "acdgopqsurG:C:t", long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -369,6 +370,11 @@ static int cmd_subvol_list(int argc, char **argv)
 		case 'c':
 			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
 			break;
+		case 'd':
+			btrfs_list_setup_filter(&filter_set,
+						BTRFS_LIST_FILTER_DELETED,
+						0);
+			break;
 		case 'g':
 			btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
 			break;
-- 
1.7.9

