Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50956 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbcC2O1n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 10:27:43 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 3/4] btrfs-progs: add fi show for spare
Date: Tue, 29 Mar 2016 22:27:20 +0800
Message-Id: <1459261641-32254-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1459261641-32254-1-git-send-email-anand.jain@oracle.com>
References: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
 <1459261641-32254-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 38404d29026e..0901c47e8679 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -351,6 +351,9 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices,
 	if (add_seen_fsid(fs_devices->fsid))
 		return;
 
+	if (fs_devices->spare)
+		return;
+
 	uuid_unparse(fs_devices->fsid, uuidbuf);
 	device = list_entry(fs_devices->devices.next, struct btrfs_device,
 			    dev_list);
@@ -597,6 +600,7 @@ static int copy_fs_devices(struct btrfs_fs_devices *dst,
 	memcpy(dst->fsid, src->fsid, BTRFS_FSID_SIZE);
 	INIT_LIST_HEAD(&dst->devices);
 	dst->seed = NULL;
+	dst->spare = src->spare;
 
 	list_for_each_entry(cur_dev, &src->devices, dev_list) {
 		dev_copy = malloc(sizeof(*dev_copy));
-- 
2.7.0

