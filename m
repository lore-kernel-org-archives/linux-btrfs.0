Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36458 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758188Ab3D2OIV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Apr 2013 10:08:21 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 5B05E7C065C
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Apr 2013 08:08:21 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id YhEfe0jj5vlxEkpa (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 29 Apr 2013 08:08:20 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: deal with errors in write_dev_supers
Date: Mon, 29 Apr 2013 10:08:18 -0400
Message-ID: <1367244498-2100-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you try to mount -o loop a restored file system it will panic if the file
ends up being smaller than the original disk.  This is because we go to try and
get a block for a super that may be past the EOF which makes __getblk return
NULL for a buffer head when we aren't expecting it to.  Fix this by dealing with
this case and just jacking up the errors count.  With this patch we no longer
panic when mounting a restored file system loopback.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 06510f6..2d7da66 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3043,7 +3043,10 @@ static int write_dev_supers(struct btrfs_device *device,
 		if (wait) {
 			bh = __find_get_block(device->bdev, bytenr / 4096,
 					      BTRFS_SUPER_INFO_SIZE);
-			BUG_ON(!bh);
+			if (!bh) {
+				errors++;
+				continue;
+			}
 			wait_on_buffer(bh);
 			if (!buffer_uptodate(bh))
 				errors++;
@@ -3070,6 +3073,13 @@ static int write_dev_supers(struct btrfs_device *device,
 			 */
 			bh = __getblk(device->bdev, bytenr / 4096,
 				      BTRFS_SUPER_INFO_SIZE);
+			if (!bh) {
+				printk(KERN_ERR "btrfs: couldn't get super "
+				       "buffer head for bytenr %Lu\n", bytenr);
+				errors++;
+				continue;
+			}
+
 			memcpy(bh->b_data, sb, BTRFS_SUPER_INFO_SIZE);
 
 			/* one reference for submit_bh */
-- 
1.7.7.6

