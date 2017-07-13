Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24893 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdGMEKH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 00:10:07 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: add support to sort by topid
Date: Thu, 13 Jul 2017 12:16:42 +0800
Message-Id: <20170713041642.27125-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As users generally organize the subvols and snapshots based on the subvol
directory hierarchy. So providing an ability to sort them by topid would
help. Thanks.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c     | 18 ++++++++++++++++++
 btrfs-list.h     |  1 +
 cmds-subvolume.c |  8 ++++----
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 92a537f425f3..733e22bc2524 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -188,11 +188,28 @@ static int comp_entry_with_path(struct root_info *entry1,
 	return is_descending ? -ret : ret;
 }
 
+static int comp_entry_with_topid(struct root_info *entry1,
+				struct root_info *entry2,
+				int is_descending)
+{
+	int ret;
+
+	if (entry1->top_id > entry2->top_id)
+		ret = 1;
+	else if (entry1->top_id < entry2->top_id)
+		ret = -1;
+	else
+		ret = 0;
+
+	return is_descending ? -ret : ret;
+}
+
 static btrfs_list_comp_func all_comp_funcs[] = {
 	[BTRFS_LIST_COMP_ROOTID]	= comp_entry_with_rootid,
 	[BTRFS_LIST_COMP_OGEN]		= comp_entry_with_ogen,
 	[BTRFS_LIST_COMP_GEN]		= comp_entry_with_gen,
 	[BTRFS_LIST_COMP_PATH]		= comp_entry_with_path,
+	[BTRFS_LIST_COMP_TOPID]		= comp_entry_with_topid,
 };
 
 static char *all_sort_items[] = {
@@ -200,6 +217,7 @@ static char *all_sort_items[] = {
 	[BTRFS_LIST_COMP_OGEN]		= "ogen",
 	[BTRFS_LIST_COMP_GEN]		= "gen",
 	[BTRFS_LIST_COMP_PATH]		= "path",
+	[BTRFS_LIST_COMP_TOPID]		= "topid",
 	[BTRFS_LIST_COMP_MAX]		= NULL,
 };
 
diff --git a/btrfs-list.h b/btrfs-list.h
index 6e5fc7784fb1..9a3869a452a8 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -152,6 +152,7 @@ enum btrfs_list_comp_enum {
 	BTRFS_LIST_COMP_OGEN,
 	BTRFS_LIST_COMP_GEN,
 	BTRFS_LIST_COMP_PATH,
+	BTRFS_LIST_COMP_TOPID,
 	BTRFS_LIST_COMP_MAX,
 };
 
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index de5e0da0ff48..17b680d26e86 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -416,10 +416,10 @@ static const char * const cmd_subvol_list_usage[] = {
 	"-C [+|-]value",
 	"             filter the subvolumes by ogeneration",
 	"             (+value: >= value; -value: <= value; value: = value)",
-	"--sort=gen,ogen,rootid,path",
-	"             list the subvolume in order of gen, ogen, rootid or path",
-	"             you also can add '+' or '-' in front of each items.",
-	"             (+:ascending, -:descending, ascending default)",
+	"--sort=gen,ogen,rootid,path,topid",
+	"             list the subvolumes in order of gen, ogen, rootid, path",
+	"             or topid. You also can add '+' or '-' in front of each",
+	"             items. (+:ascending, -:descending, ascending default)",
 	NULL,
 };
 
-- 
2.13.1

