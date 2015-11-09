Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51913 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbbKIK7s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:59:48 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9AxlQD016242
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:59:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AxlCL013955
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:59:47 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AxlE9004271
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:59:47 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs-progs: add fi show for spare
Date: Mon,  9 Nov 2015 18:58:38 +0800
Message-Id: <1447066719-3880-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066719-3880-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
 <1447066719-3880-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 4d3a9a4..11d0406 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -353,6 +353,9 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices,
 	if (add_seen_fsid(fs_devices->fsid))
 		return;
 
+	if (fs_devices->spare)
+		return;
+
 	uuid_unparse(fs_devices->fsid, uuidbuf);
 	device = list_entry(fs_devices->devices.next, struct btrfs_device,
 			    dev_list);
@@ -610,6 +613,7 @@ static int copy_fs_devices(struct btrfs_fs_devices *dst,
 	memcpy(dst->fsid, src->fsid, BTRFS_FSID_SIZE);
 	INIT_LIST_HEAD(&dst->devices);
 	dst->seed = NULL;
+	dst->spare = src->spare;
 
 	list_for_each_entry(cur_dev, &src->devices, dev_list) {
 		dev_copy = malloc(sizeof(*dev_copy));
-- 
2.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
