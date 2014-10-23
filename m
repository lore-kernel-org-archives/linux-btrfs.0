Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10871 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753250AbaJWB53 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 21:57:29 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s9N1vNNu024478
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 09:57:23 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: fix dev stats error output related to replace handle
Date: Thu, 23 Oct 2014 09:56:11 +0800
Message-ID: <1414029371-6765-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
	# mkfs.btrfs -f /dev/sdb7
	# mount /dev/sdb7 /mnt
	# btrfs dev stats /dev/sdb7
output:
	[/dev/sdb7].write_io_errs   0
	[/dev/sdb7].read_io_errs    0
	[/dev/sdb7].flush_io_errs   0
	[/dev/sdb7].corruption_errs 0
	[/dev/sdb7].generation_errs 0
	* ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on  failed: No such device

while the following cmd:
	# btrfs dev stats /mnt
yields the right thing:
	[/dev/sdb7].write_io_errs   0
	[/dev/sdb7].read_io_errs    0
	[/dev/sdb7].flush_io_errs   0
	[/dev/sdb7].corruption_errs 0
	[/dev/sdb7].generation_errs 0

This is caused by commit:
	commit d0588bfa479409b2a0f6243f894338a01a56221a
	btrfs-progs: do a separate probe for transient replacing device

The above commit trys to handle the fi show problem with device under
replacing, but it changes the @get_fs_info() logic which annoys dev stats.
For @get_fs_info():
o If the passed in @path is a mount point, then the @get_device_info() to
  probe the replacing device will be glad to accept the device index
  var @i as its init value 0 and the following i++ correctly sets @i
  to 1 as the start of all devices in btrfs.
o If @path is a block device, then the problem comes...
  The device index @i is set to devid of the block device passed in,
  and the @get_device_info() will be forced to accept the devid unwillingly.
  Then the following i++ do the evil of skip the block device desired and an
  empty piece is handled next which causes the ERROR above.

To fix this problem, let's just pass 0 to the @get_device_info() explicitly,
and set the index @i to 1 if a mount point is passed in.

Under my own test, this will not affect the original fix of the fi show
problem with device under replacing.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 utils.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index f10c178..0ba2b26 100644
--- a/utils.c
+++ b/utils.c
@@ -1881,12 +1881,15 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 	}
 
 	/* get the replace target device if it is there */
-	ret = get_device_info(fd, i, &di_args[ndevs]);
+	ret = get_device_info(fd, 0, &di_args[ndevs]);
 	if (!ret) {
 		ndevs++;
 		fi_args->num_devices++;
 	}
-	i++;
+
+	/* if a mount point is passed in, start from devid 1 */
+	if (fi_args->num_devices != 1)
+		i = 1;
 
 	for (; i <= fi_args->max_id; ++i) {
 		BUG_ON(ndevs >= fi_args->num_devices);
-- 
1.8.1.4

