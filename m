Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38355 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3I0MZD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 08:25:03 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/3] btrfs-progs: add more parameter to the filesystem show
Date: Fri, 27 Sep 2013 20:24:43 +0800
Message-Id: <1380284683-3751-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1380284683-3751-1-git-send-email-anand.jain@oracle.com>
References: <1380284683-3751-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

for mounted btrfs filesystem this patch proposes to add
information to also show the mount point and group profile,
to help user to quickly understand near details of the
btrfs filesystem

end user using this new btrfs fi show would surely notice this
will reduce other commands normally used following the current
btrfs fi show command. (like mount and btrfs fi df). of course
user should use fi df to know detailed info about the sizes.

preview as below..

Label: none  uuid: 26d539a5-8968-4cf0-b4b5-5fd50105f8a0 mounted: /btrfs
	Group profile: Metadata: single  Metadata: DUP  Data: single
	Total devices 1 FS bytes used 28.00KiB
	devid    1 size 1.98GiB used 238.25MiB path /dev/mapper/mpatha

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 5300060..064841b 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -270,10 +270,21 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
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
1.8.4.rc4.1.g0d8beaa

