Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:59866 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750810AbdI3NIR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 09:08:17 -0400
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dsterba@suse.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: [PATCH] btrfs-progs: add option to only list parent subvolumes
Message-ID: <6c01643a-b6cd-21ae-45ec-e074995a5de2@applied-asynchrony.com>
Date: Sat, 30 Sep 2017 15:08:13 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

When listing subvolumes it can be useful to filter out any snapshots;
surprisingly enough I couldn't find an option to do this easily, only
the opposite (list only snapshots).

A "root" subvolume is identified by a null parent UUID, so adding a new
subvolume filter and flag -P ("Parent") does the trick. 

The same can of course be accomplished with shell hackery, e.g.:

 btrfs subvol list -q -o <path> | grep -i "parent_uuid -" | cut -d " " -f 11

but a built-in way seems less fragile.

I originally cooked this up for myself, but David Sterba encouraged me to
send this to the list, so here it is. I'm not too proud of the -P but
couldn't find a better option letter; suggestions welcome. :)

cheers,
Holger

Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>
---
 btrfs-list.c     | 6 ++++++
 btrfs-list.h     | 1 +
 cmds-subvolume.c | 8 +++++++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 4cc2ed49..6aa7a290 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1175,6 +1175,11 @@ static int filter_deleted(struct root_info *ri, u64 data)
 	return ri->deleted;
 }
 
+static int filter_parent_subvol_only(struct root_info *ri, u64 data)
+{
+	return uuid_is_null(ri->puuid);
+}
+
 static btrfs_list_filter_func all_filter_funcs[] = {
 	[BTRFS_LIST_FILTER_ROOTID]		= filter_by_rootid,
 	[BTRFS_LIST_FILTER_SNAPSHOT_ONLY]	= filter_snapshot,
@@ -1189,6 +1194,7 @@ static btrfs_list_filter_func all_filter_funcs[] = {
 	[BTRFS_LIST_FILTER_FULL_PATH]		= filter_full_path,
 	[BTRFS_LIST_FILTER_BY_PARENT]		= filter_by_parent,
 	[BTRFS_LIST_FILTER_DELETED]		= filter_deleted,
+	[BTRFS_LIST_FILTER_PARENT_SUBVOL_ONLY]	= filter_parent_subvol_only,
 };
 
 struct btrfs_list_filter_set *btrfs_list_alloc_filter_set(void)
diff --git a/btrfs-list.h b/btrfs-list.h
index 13f44c3a..54aab123 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -142,6 +142,7 @@ enum btrfs_list_filter_enum {
 	BTRFS_LIST_FILTER_FULL_PATH,
 	BTRFS_LIST_FILTER_BY_PARENT,
 	BTRFS_LIST_FILTER_DELETED,
+	BTRFS_LIST_FILTER_PARENT_SUBVOL_ONLY,
 	BTRFS_LIST_FILTER_MAX,
 };
 
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index e7ef67d3..2371338e 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -404,6 +404,7 @@ static const char * const cmd_subvol_list_usage[] = {
 	"-q           print the parent uuid of the snapshots",
 	"-R           print the uuid of the received snapshots",
 	"-t           print the result as a table",
+	"-P           list parent subvolumes only",
 	"-s           list snapshots only in the filesystem",
 	"-r           list readonly subvolumes (including snapshots)",
 	"-d           list deleted subvolumes that are not yet cleaned",
@@ -445,7 +446,7 @@ static int cmd_subvol_list(int argc, char **argv)
 		};
 
 		c = getopt_long(argc, argv,
-				    "acdgopqsurRG:C:t", long_options, NULL);
+				    "acdgopPqsurRG:C:t", long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -473,6 +474,11 @@ static int cmd_subvol_list(int argc, char **argv)
 		case 't':
 			is_tab_result = 1;
 			break;
+		case 'P':
+			btrfs_list_setup_filter(&filter_set,
+						BTRFS_LIST_FILTER_PARENT_SUBVOL_ONLY,
+						0);
+			break;
 		case 's':
 			btrfs_list_setup_filter(&filter_set,
 						BTRFS_LIST_FILTER_SNAPSHOT_ONLY,
-- 
2.14.2

