Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35103 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161087AbcG1RoZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 13:44:25 -0400
Received: by mail-pf0-f196.google.com with SMTP id h186so4037364pfg.2
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 10:44:25 -0700 (PDT)
From: Justin Maggard <jmaggard10@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard@netgear.com>
Subject: [PATCH] btrfs-progs: fix memory leak with missing device
Date: Thu, 28 Jul 2016 10:44:11 -0700
Message-Id: <20160728174411.4998-1-jmaggard@netgear.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In read_one_chunk(), we may add an empty entry for a missing device.
However, this entry wasn't being added to the dev_list, and so it never
got freed.

Signed-off-by: Justin Maggard <jmaggard@netgear.com>
---
 volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/volumes.c b/volumes.c
index ccfa732..b5066b9 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1759,6 +1759,8 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 			map->stripes[i].dev = fill_missing_device(devid);
 			printf("warning, device %llu is missing\n",
 			       (unsigned long long)devid);
+			list_add(&map->stripes[i].dev->dev_list,
+				 &root->fs_info->fs_devices->devices);
 		}
 
 	}
-- 
2.9.2

