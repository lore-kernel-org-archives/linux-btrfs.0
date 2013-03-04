Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from scaletech.ca ([69.164.214.189]:60830 "EHLO scaletech.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451Ab3CDXU6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 18:20:58 -0500
Subject: [RFC][PATCH] Btrfs: Release uuid_mutex for shrink during device
 delete
From: Carey Underwood <carey@scaletech.ca>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, idryomov@gmail.com, cwillu@cwillu.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Mar 2013 16:37:06 -0600
Message-ID: <1362436626.26135.16.camel@applicati>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Device scanning waits on the uuid_mutex, which can result in a very long
wait if dev delete is shrinking the device.

Signed-off-by: Carey Underwood <cwillu@cwillu.com>
---
 fs/btrfs/volumes.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5cce6aa..996af00 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1468,7 +1468,9 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		clear_super = true;
 	}
 
+	mutex_unlock(&uuid_mutex);
 	ret = btrfs_shrink_device(device, 0);
+	mutex_lock(&uuid_mutex);
 	if (ret)
 		goto error_undo;
 
-- 
1.7.0.4




