Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:65267 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933788Ab2J3RQU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 13:16:20 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp2) (RZmta 30.21 OK)
	with ESMTP id g013a9o9UCjm5c for <linux-btrfs@vger.kernel.org>;
	Tue, 30 Oct 2012 18:16:16 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: don't allow degraded mount if too many devices are missing
Date: Tue, 30 Oct 2012 18:16:16 +0100
Message-Id: <1351617376-5208-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The current behavior is to allow mounting or remounting a filesystem
writeable in degraded mode if at least one writeable device is
present.
The next failed write access to a missing device which is above
the tolerance of the configured level of redundancy results in an
read-only enforcement. Even without this, the next time
barrier_all_devices() is called and more devices are missing than
tolerable, the switch to read-only mode takes place.

In order to behave predictably and to provide proper feedback to
the user at mount time, this patch compares the number of missing
devices with the number of devices that are tolerated to be missing
according to the configured RAID level. If more devices are missing
than tolerated, e.g. if two devices are missing in case of RAID1,
only a read-only mount and remount is allowed.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/disk-io.c | 7 +++++++
 fs/btrfs/super.c   | 9 +++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7cda519..29de7c1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2503,6 +2503,13 @@ retry_root_backup:
 	}
 	fs_info->num_tolerated_disk_barrier_failures =
 		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
+	if (fs_info->fs_devices->missing_devices >
+	     fs_info->num_tolerated_disk_barrier_failures &&
+	    !(sb->s_flags & MS_RDONLY)) {
+		printk(KERN_WARNING
+		       "Btrfs: too many missing devices, writeable mount is not allowed\n");
+		goto fail_block_groups;
+	}
 
 	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
 					       "btrfs-cleaner");
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 915ac14..acd2df8 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1226,6 +1226,15 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			goto restore;
 		}
 
+		if (fs_info->fs_devices->missing_devices >
+		     fs_info->num_tolerated_disk_barrier_failures &&
+		    !(*flags & MS_RDONLY)) {
+			printk(KERN_WARNING
+			       "Btrfs: too many missing devices, writeable remount is not allowed\n");
+			ret = -EACCES;
+			goto restore;
+		}
+
 		if (btrfs_super_log_root(fs_info->super_copy) != 0) {
 			ret = -EINVAL;
 			goto restore;
-- 
1.8.0

