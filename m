Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37991 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbbHNKdr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:47 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 16/23] Btrfs: device path change must be logged
Date: Fri, 14 Aug 2015 18:33:01 +0800
Message-Id: <1439548388-29686-17-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From the issue diagnosable point of view, log if the device path is
changed.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ebf37a9..dcb10fa 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -595,6 +595,10 @@ static noinline int device_list_add(const char *path,
 			return -EEXIST;
 		}
 
+		printk_in_rcu(KERN_INFO \
+			"BTRFS: device fsid %pU devid %llu old path %s new path %s\n",
+			disk_super->fsid, devid, rcu_str_deref(device->name), path);
+
 		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name)
 			return -ENOMEM;
-- 
2.4.1

