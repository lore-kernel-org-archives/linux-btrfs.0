Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17814 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab3JHDeQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 23:34:16 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/3] btrfs-progs: use BTRFS_SCAN_LBLKID as default scan in filesystem show
Date: Tue,  8 Oct 2013 11:41:40 +0800
Message-Id: <1381203700-17558-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1381203700-17558-1-git-send-email-anand.jain@oracle.com>
References: <1381203700-17558-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs progs has to scan for the btrfs disks for two main reasons,
 one to register them with the btrfs kernel (under btrfs dev scan)
 2nd to report btrfs disks to the user (under btrfs fi show)
 (there few more minor reasons like check_mounted etc..).

 To facilitate the scan, in total we have the following methods
 to scan for the btrfs

 BTRFS_SCAN_PROC
  which uses the /proc/partitions to look for the disks, when
  scanning it does it twice first would look for non dm- paths
  and in the 2nd scan it would pick only dm- paths.

 BTRFS_SCAN_DEV
  which scans all the block dev under /dev as they appear during
  scanning.

 BTRFS_SCAN_LBLKID
  this uses the library functions provided  by the lblkid to get
  only disks which contains the btrfs SB.

 The better method to use would be BTRFS_SCAN_LBLKID for the obvious
 reasons we don't have to reinvent that feature with in btrfs-progs.

 For the btrfs fi show - This patch will..
   - make BTRFS_SCAN_LBLKID as the default scan option

   (BTRFS_SCAN_DEV is accessible under the option --all-devices and
   BTRFS_SCAN_PROC won't be used by btrfs fi show any more)

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 74b7a06..b737ec9 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -398,11 +398,10 @@ static int cmd_show(int argc, char **argv)
 {
 	struct list_head *all_uuids;
 	struct btrfs_fs_devices *fs_devices;
-	struct btrfs_device *device;
 	struct list_head *cur_uuid;
 	char *search = NULL;
 	int ret;
-	int where = BTRFS_SCAN_PROC;
+	int where = BTRFS_SCAN_LBLKID;
 	int type = 0;
 
 	while (1) {
@@ -464,17 +463,6 @@ devs_only:
 		if (search && uuid_search(fs_devices, search) == 0)
 			continue;
 
-		/* skip mounted as they are already printed by
-		 * btrfs_scan_kernel
-		*/
-		/* do it only for the default, no option */
-		if (where == BTRFS_SCAN_PROC) {
-			device = list_entry(fs_devices->devices.next,
-					struct btrfs_device, dev_list);
-			ret = check_mounted(device->name);
-			if (ret)
-				continue;
-		}
 		print_one_uuid(fs_devices);
 	}
 
-- 
1.7.1

