Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42357 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbbHaSsj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 14:48:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZWU8B-0000RQ-Je
	for linux-btrfs@vger.kernel.org; Mon, 31 Aug 2015 20:48:35 +0200
Received: from host-78-149-214-125.as13285.net ([78.149.214.125])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 20:48:35 +0200
Received: from samtygier by host-78-149-214-125.as13285.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 20:48:35 +0200
To: linux-btrfs@vger.kernel.org
From: sam tygier <samtygier@yahoo.co.uk>
Subject: [PATCH] Btrfs: Check metadata redundancy on balance
Date: Mon, 31 Aug 2015 19:48:24 +0100
Message-ID: <ms27ho$tl7$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resending, as I received no comments on previous submission.

Currently BTRFS allows you to make bad choices of data and 
metadata levels. For example -d raid1 -m raid0 means you can
only use half your total disk space, but will loose everything
if 1 disk fails. It should give a warning in these cases.

This patch is a follow up to
[PATCH v2] btrfs-progs: check metadata redundancy
in order to cover the case of using balance to convert to such
a set of raid levels.

A simple example to hit this is to create a single device fs, 
which will default to single:dup, then to add a second device and
attempt to convert to raid1 with the command
btrfs balance start -dconvert=raid1  /mnt
this will result in a filesystem with raid1:dup, which will not
survive the loss of one drive. I personally don't see why the tools
should allow this, but in the previous thread a warning was
considered sufficient.

Signed-off-by: Sam Tygier <samtygier@yahoo.co.uk>

From: Sam Tygier <samtygier@yahoo.co.uk>
Date: Sat, 13 Jun 2015 18:13:06 +0100
Subject: [PATCH] Btrfs: Check metadata redundancy on balance

When converting a filesystem via balance check that metadata mode
is at least as redundant as the data mode. For example give warning
when:
-dconvert=raid1 -mconvert=single
---
 fs/btrfs/volumes.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fbe7c10..a0ce1f7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3454,6 +3454,24 @@ static void __cancel_balance(struct btrfs_fs_info *fs_info)
 	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
 }
 
+static int group_profile_max_safe_loss(u64 flag)
+{
+	switch (flag & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+	case 0: /* single */
+	case BTRFS_BLOCK_GROUP_DUP:
+	case BTRFS_BLOCK_GROUP_RAID0:
+		return 0;
+	case BTRFS_BLOCK_GROUP_RAID1:
+	case BTRFS_BLOCK_GROUP_RAID5:
+	case BTRFS_BLOCK_GROUP_RAID10:
+		return 1;
+	case BTRFS_BLOCK_GROUP_RAID6:
+		return 2;
+	default:
+		return -1;
+	}
+}
+
 /*
  * Should be called with both balance and volume mutexes held
  */
@@ -3572,6 +3590,12 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		}
 	} while (read_seqretry(&fs_info->profiles_lock, seq));
 
+	if (group_profile_max_safe_loss(bctl->meta.target) <
+		group_profile_max_safe_loss(bctl->data.target)){
+		btrfs_info(fs_info,
+			"Warning: metatdata has lower redundancy than data\n");
+	}
+
 	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
 		int num_tolerated_disk_barrier_failures;
 		u64 target = bctl->sys.target;
-- 
2.4.3


