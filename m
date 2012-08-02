Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:42698 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620Ab2HBOVM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Aug 2012 10:21:12 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id UgiM2vdIA2tX2uoi (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 02 Aug 2012 08:21:11 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not strdup non existent strings
Date: Thu, 2 Aug 2012 10:26:14 -0400
Message-ID: <1343917574-1919-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we close devices we add back empty devices for some reason that escapes
me.  In the case of a missing dev we don't allocate an rcu_string for it's
name, so check to see if the device has a name and if it doesn't don't
bother strdup()'ing it.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/volumes.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3821302..0b1e69d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -568,9 +568,11 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		memcpy(new_device, device, sizeof(*new_device));
 
 		/* Safe because we are under uuid_mutex */
-		name = rcu_string_strdup(device->name->str, GFP_NOFS);
-		BUG_ON(device->name && !name); /* -ENOMEM */
-		rcu_assign_pointer(new_device->name, name);
+		if (device->name) {
+			name = rcu_string_strdup(device->name->str, GFP_NOFS);
+			BUG_ON(device->name && !name); /* -ENOMEM */
+			rcu_assign_pointer(new_device->name, name);
+		}
 		new_device->bdev = NULL;
 		new_device->writeable = 0;
 		new_device->in_fs_metadata = 0;
-- 
1.7.7.6

