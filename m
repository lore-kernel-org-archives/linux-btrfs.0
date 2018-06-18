Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:33183 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968200AbeFRIiQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:16 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id C7D0BAC0142
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:10 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 07E116925F1
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:10 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 13/20] btrfs-progs: sub list: Update -a option and remove meaningless filter
Date: Mon, 18 Jun 2018 17:41:01 +0900
Message-ID: <fa76c79b5525d49b0829009be4b6d628d20ab4a5.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, -a option add filter and change subvolume path as follows:
  - If a subvolume is a child of the specified path, nothing changes
  - otherwise, adds <FS_TREE> to head

This is rather meaningless, so let's remove this filter.

As a result, the behavior of -a option becomes the same as
default behavior of sub list in progs <= 4.17

[Example]
 $ mkfs.btrfs -f $DEV
 $ mount $DEV /mnt

 $ btrfs subvolume create /mnt/AAA
 $ btrfs subvolume create /mnt/AAA/BBB
 $ btrfs subvolume create /mnt/ZZZ

 $ btrfs subvolume list -a /mnt
 ID 256 gen 9 top level 5 path AAA
 ID 257 gen 9 top level 256 path AAA/BBB
 ID 258 gen 10 top level 5 path ZZZ

 ** output of progs <= 4.17
 $ btrfs subvolume list -a /mnt
 ID 256 gen 9 top level 5 path AAA
 ID 257 gen 9 top level 256 path <FS_TREE>/AAA/BBB
 ID 258 gen 10 top level 5 path ZZZ

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 Documentation/btrfs-subvolume.asciidoc |  6 ++++--
 cmds-subvolume.c                       | 35 ++++------------------------------
 2 files changed, 8 insertions(+), 33 deletions(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index cd91385a..20fae1e1 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -118,8 +118,10 @@ Path filtering;;
 -o::::
 print only subvolumes below specified <path>.
 -a::::
-print all the subvolumes in the filesystem and distinguish between
-absolute and relative path with respect to the given <path>.
+print all the subvolumes in the filesystem, including subvolumes
+which cannot be accessed from current mount point.
+path to be shown is relative to the top-level subvolume
+(require root privileges).
 -f::::
 follow mounted subvolumes below <path> recursively and list them too
 (only if it is the same filesystem). If top-level subvolume is mounted
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 802f5c5e..dab266aa 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -759,28 +759,6 @@ static int filter_topid_equal(struct listed_subvol *subvol, uint64_t data)
 	return subvol->info.parent_id == data;
 }
 
-static int filter_full_path(struct listed_subvol *subvol, uint64_t data)
-{
-	/*
-	 * This implements the same behavior as before the conversion to
-	 * libbtrfsutil, which is mostly nonsensical.
-	 */
-	if (subvol->info.parent_id != data) {
-		char *tmp;
-		int ret;
-
-		ret = asprintf(&tmp, "<FS_TREE>/%s", subvol->path);
-		if (ret == -1) {
-			error("out of memory");
-			exit(1);
-		}
-
-		free(subvol->path);
-		subvol->path = tmp;
-	}
-	return 1;
-}
-
 static int filter_by_parent(struct listed_subvol *subvol, uint64_t data)
 {
 	return !uuid_compare(subvol->info.parent_uuid,
@@ -798,7 +776,6 @@ static btrfs_list_filter_func_v2 all_filter_funcs[] = {
 	[BTRFS_LIST_FILTER_CGEN_LESS]		= filter_cgen_less,
 	[BTRFS_LIST_FILTER_CGEN_EQUAL]          = filter_cgen_equal,
 	[BTRFS_LIST_FILTER_TOPID_EQUAL]		= filter_topid_equal,
-	[BTRFS_LIST_FILTER_FULL_PATH]		= filter_full_path,
 	[BTRFS_LIST_FILTER_BY_PARENT]		= filter_by_parent,
 };
 
@@ -1574,9 +1551,9 @@ static const char * const cmd_subvol_list_usage[] = {
 	"",
 	"Path filtering:",
 	"-o           print only subvolumes below specified path",
-	"-a           print all the subvolumes in the filesystem and",
-	"             distinguish absolute and relative path with respect",
-	"             to the given <path> (require root privileges)",
+	"-a           print all the subvolumes in the filesystem.",
+	"             path to be shown is relative to the top-level",
+	"             subvolume (require root privileges)",
 	"-f           follow mounted subvolumes below the specified path",
 	"             and list them too (only if it is the same filesystem)",
 	"",
@@ -1783,11 +1760,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	if (ret)
 		goto out;
 
-	if (is_list_all)
-		btrfs_list_setup_filter_v2(&filter_set,
-					BTRFS_LIST_FILTER_FULL_PATH,
-					top_id);
-	else if (is_only_in_path)
+	if (is_only_in_path)
 		btrfs_list_setup_filter_v2(&filter_set,
 					BTRFS_LIST_FILTER_TOPID_EQUAL,
 					top_id);
-- 
2.14.4


