Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:52241 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab3JKMS0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 08:18:26 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (RZmta 32.6 OK) with ESMTP id g01630p9A9YOzt
	for <linux-btrfs@vger.kernel.org>;
	Fri, 11 Oct 2013 14:18:23 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fail device statistic reset on read-only filesystem
Date: Fri, 11 Oct 2013 14:18:23 +0200
Message-Id: <2a649d6a51055ac36352a73add403037acc537ef.1381493768.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently the attempt to reset the device statistics with
'btrfs device stat -z ...' on read-only filesystems does not return an
error. The statistics that are hold in main memory are reset but the
statistics that are stored in the filesystem are not reset.

Fix it by returning EROFS in this case.

This is the reproducer:

 #!/bin/sh
TEST_DEV1=/dev/sdzzzzz1
TEST_DEV2=/dev/sdzzzzz2
TEST_MNT=/mnt
echo 0 25165824 linear $TEST_DEV1 0 | dmsetup create foom
echo 0 25165824 linear $TEST_DEV2 0 | dmsetup create foon
mkfs.btrfs -f -d raid1 -m raid1 /dev/mapper/foom /dev/mapper/foon
mount /dev/mapper/foom $TEST_MNT
 # switch to I/O error mode:
echo 0 25165824 error | dmsetup reload foon
dmsetup resume foon
 # cause I/O errors:
touch ${TEST_MNT}/foo
sync
 # switch dm back to I/O good mode:
echo 0 25165824 linear $TEST_DEV1 0 | dmsetup reload foon
dmsetup resume foon
umount ${TEST_MNT}
btrfs dev scan
mount /dev/mapper/foom ${TEST_MNT} -o ro
 # will report counters != 0, should fail with EROFS
btrfs device stat -z ${TEST_MNT}
 # will report counters == 0:
btrfs device stat ${TEST_MNT}
umount ${TEST_MNT}
mount /dev/mapper/foom ${TEST_MNT} -o ro
 # will report counters != 0, i.e., the 'btrfs device stat -z' failed to
 # clear the counters on disk, only the counters in main memory had been
 # cleared:
btrfs device stat ${TEST_MNT}
umount ${TEST_MNT}
dmsetup remove foom; dmsetup remove foon

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fe0f2ef..646d10d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6250,6 +6250,8 @@ int btrfs_get_dev_stats(struct btrfs_root *root,
 		       "btrfs: get dev_stats failed, not yet valid\n");
 		return -ENODEV;
 	} else if (stats->flags & BTRFS_DEV_STATS_RESET) {
+		if (root->fs_info->sb->s_flags & MS_RDONLY)
+			return -EROFS;
 		for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++) {
 			if (stats->nr_items > i)
 				stats->values[i] =
-- 
1.8.4

