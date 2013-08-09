Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030942Ab3HIUh1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 16:37:27 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r79KbRu0004131
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Aug 2013 16:37:27 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r79KbNvk001231
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Aug 2013 16:37:27 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: don't double brelse on device rm
Date: Fri,  9 Aug 2013 13:37:14 -0700
Message-Id: <1376080634-1714-2-git-send-email-zab@redhat.com>
In-Reply-To: <1376080634-1714-1-git-send-email-zab@redhat.com>
References: <1376080634-1714-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Device removal currently causes bdev removal to try to double free a bh
in the bdev:

[   55.714833] WARNING: at fs/buffer.c:1160 __brelse+0x36/0x40()
[   55.714833] VFS: brelse: Trying to free free buffer

Commit 7e3d9ebb1 added a double release of the bh for a device being
removed when all the supers don't fit in the device.  In that case it
releases the bh assuming that it's going to read a new one, finds that
it won't read, and goes to a label that releases the bh again.

All it needed to do was only brelse() right before overwriting the
current bh with __bread().

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 090f57c..adb0bca 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1656,11 +1656,12 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		 * the below would take of the rest
 		 */
 		for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-			brelse(bh);
 			bytenr = btrfs_sb_offset(i);
 			if (bytenr + BTRFS_SUPER_INFO_SIZE >=
 					i_size_read(bdev->bd_inode))
 				break;
+
+			brelse(bh);
 			bh = __bread(bdev, bytenr / 4096,
 					BTRFS_SUPER_INFO_SIZE);
 			if (!bh)
-- 
1.7.11.7

