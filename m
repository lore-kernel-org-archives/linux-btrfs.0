Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:41209 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887Ab3JKPPB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 11:15:01 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (RZmta 32.6 OK) with ESMTP id 601955p9AC7xjJ
	for <linux-btrfs@vger.kernel.org>;
	Fri, 11 Oct 2013 17:14:59 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: Wait for uuid-tree rebuild task on remount read-only
Date: Fri, 11 Oct 2013 17:14:58 +0200
Message-Id: <9a9a2f24e9323aa638995579c1030f3d32ad7727.1381504357.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the user remounts the filesystem read-only while the uuid-tree
scan and rebuild task is still running (this happens once after the
filesystem was mounted with an old kernel, or when forced with the
mount options), the remount should wait on the tasks completion
before setting the filesystem read-only. Otherwise the background
task continues to write to the filesystem which is apparently not
what users expect.

The reproducer:

TEST_DEV=/dev/sdzzzzz1
TEST_MNT=/mnt
mkfs.btrfs -f $TEST_DEV
mount $TEST_DEV $TEST_MNT
for i in `seq 50000`; do btrfs subvolume create ${TEST_MNT}/$i; done
umount $TEST_MNT
mount $TEST_DEV $TEST_MNT -o rescan_uuid_tree
sleep 1
ps -elf | fgrep '[btrfs-uuid]' | grep -v grep
mount $TEST_DEV $TEST_MNT -o ro,remount
ps -elf | fgrep '[btrfs-uuid]' | grep -v grep
sleep 1
umount $TEST_MNT

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 2bdaafd..1127d18 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1330,6 +1330,12 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		 * this also happens on 'umount -rf' or on shutdown, when
 		 * the filesystem is busy.
 		 */
+
+		/* wait for the uuid_scan task to finish */
+		down(&fs_info->uuid_tree_rescan_sem);
+		/* avoid complains from lockdep et al. */
+		up(&fs_info->uuid_tree_rescan_sem);
+
 		sb->s_flags |= MS_RDONLY;
 
 		btrfs_dev_replace_suspend_for_unmount(fs_info);
-- 
1.8.4

