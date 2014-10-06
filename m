Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43559 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751397AbaJFKSu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Oct 2014 06:18:50 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s96AInuc030935
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Oct 2014 18:18:49 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: fix BUG_ON when all devices under seed fs are missing
Date: Mon, 6 Oct 2014 18:17:49 +0800
Message-ID: <1412590669-5887-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
	# mkfs.btrfs -f /dev/sda[1-2]
	# btrfstune -S 1 /dev/sda1
	# mount /dev/sda /mnt
	# btrfs dev add /dev/sda3 /mnt
	# umount /mnt
	# mkfs.ext4 /dev/sda1		// kill seed dev
	# mkfs.ext4 /dev/sda2		// kill seed dev
	# btrfs-debug-tree /dev/sda3	<== BUG_ON
Output msg:
	volumes.c:1824: btrfs_read_chunk_tree: Assertion `ret` failed.
	btrfs-debug-tree[0x41cb36]
	btrfs-debug-tree(btrfs_read_chunk_tree+0x3ca)
	btrfs-debug-tree(btrfs_setup_chunk_tree_and_device_map
	btrfs-debug-tree[0x40f695]
	btrfs-debug-tree(open_ctree_fs_info+0x86)
	btrfs-debug-tree(main+0x12d)
	/lib64/libc.so.6(__libc_start_main+0xf5)
	btrfs-debug-tree[0x4062e9]

This BUG_ON complains about a failed @read_one_dev() call when
@open_seed_devices() failed to find the seed @fs_devices object
for a dev_item in chunk tree.
In this case, just insert a "shadow" @fs_devices with the fsid in
dev_item shall make no harm since no other tools will try to
make use of the stuff that the "shadow" @fs_devices possesses
after its creation.

After apply this commit, btrfs-debug-tree will report unable
to open the device.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
*Note*
This should be after patch:
	Btrfs-progs: fsck: disallow partial opening if critical \
						roots corrupted
---
 volumes.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/volumes.c b/volumes.c
index eaf3f9f..a9c7662 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1671,8 +1671,15 @@ static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
 
 	fs_devices = find_fsid(fsid);
 	if (!fs_devices) {
-		ret = -ENOENT;
-		goto out;
+		/* missing all seed devices */
+		fs_devices = kzalloc(sizeof(*fs_devices), GFP_NOFS);
+		if (!fs_devices) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		INIT_LIST_HEAD(&fs_devices->devices);
+		list_add(&fs_devices->list, &fs_uuids);
+		memcpy(fs_devices->fsid, fsid, BTRFS_FSID_SIZE);
 	}
 
 	ret = btrfs_open_devices(fs_devices, O_RDONLY);
-- 
1.8.1.4

