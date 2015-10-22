Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43459 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbbJVDz3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 23:55:29 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t9M3tShT013894
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 03:55:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t9M3tSlA019180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 03:55:28 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t9M3tRro019215
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 03:55:27 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs-progs: fix uninitialized copy of btrfs_fs_devices list
Date: Thu, 22 Oct 2015 11:53:39 +0800
Message-Id: <1445486019-1173-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Noticed that at print_one_uuid() some of the members of btrfs_fs_devices
contained some junk values. It took a while to dig this further, and found
that we make a local copy of the btrfs_fs_devices list at
search_umounted_fs_uuids() and wasn't initialized properly.

Fixed using using zalloc instead of malloc.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 3663734..4d3a9a4 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -685,7 +685,7 @@ static int search_umounted_fs_uuids(struct list_head *all_uuids,
 		if (is_seen_fsid(cur_fs->fsid))
 			continue;
 
-		fs_copy = malloc(sizeof(*fs_copy));
+		fs_copy = kzalloc(sizeof(*fs_copy), GFP_NOFS);
 		if (!fs_copy) {
 			ret = -ENOMEM;
 			goto out;
-- 
2.4.1

