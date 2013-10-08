Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17815 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab3JHDeR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 23:34:17 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/3 v2] btrfs-progs: add more parameter to the filesystem show
Date: Tue,  8 Oct 2013 11:41:39 +0800
Message-Id: <1381203700-17558-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1381203700-17558-1-git-send-email-anand.jain@oracle.com>
References: <1381203700-17558-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

for mounted btrfs filesystem this patch proposes to add
mount point and group profile to the filesystem show output.
this helps user to quickly understand short details of the
btrfs filesystem quickly.

end user using this new btrfs fi show would surely notice this
will reduce other commands normally used following the current
btrfs fi show command. (like mount and btrfs fi df). of course
user should use fi df to know detailed info about the sizes.

preview as below..

Label: none  uuid: 26d539a5-8968-4cf0-b4b5-5fd50105f8a0 mounted: /btrfs
	Group profile: Metadata: single  Metadata: DUP  Data: single
	Total devices 1 FS bytes used 28.00KiB
	devid    1 size 1.98GiB used 238.25MiB path /dev/mapper/mpatha

v2: commit message edited.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 9e0c8b9..74b7a06 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -273,10 +273,21 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 	int i;
 	char uuidbuf[37];
 	struct btrfs_ioctl_dev_info_args *tmp_dev_info;
+	u64 flags;
 
 	uuid_unparse(fs_info->fsid, uuidbuf);
-	printf("Label: %s  uuid: %s\n",
-		strlen(label) ? label : "none", uuidbuf);
+	printf("Label: %s  uuid: %s mounted: %s\n",
+		strlen(label) ? label : "none", uuidbuf, path);
+	printf("\tGroup profile:");
+	for (i = space_info->total_spaces - 1; i >= 0; i--) {
+		flags = space_info->spaces[i].flags;
+		if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
+			continue;
+		printf(" %s: %s", group_type_str(flags),
+					group_profile_str(flags));
+		printf(" ");
+	}
+	printf("\n");
 
 	printf("\tTotal devices %llu FS bytes used %s\n",
 				fs_info->num_devices,
-- 
1.7.1

