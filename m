Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbbKZRFz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 12:05:55 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 2A4EFAAC7
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2015 17:04:14 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: docs: mkfs, implications of DUP on devices
Date: Thu, 26 Nov 2015 18:04:05 +0100
Message-Id: <1448557445-30318-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We offer DUP but still depend on the hardware, to do the right thing.

Signed-off-by: David Sterba <dsterba@suse.com>
---

To wider audience: feel free to suggest improvements to the manual page text if
you think it's not clear or too technical etc.

 Documentation/mkfs.btrfs.asciidoc | 32 ++++++++++++++++++++++++++++----
 utils.c                           |  5 +++--
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index c9ba314c2220..0b145c7a01c3 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -50,7 +50,9 @@ mkfs.btrfs uses the entire device space for the filesystem.
 
 *-d|--data <profile>*::
 Specify the profile for the data block groups.  Valid values are 'raid0',
-'raid1', 'raid5', 'raid6', 'raid10' or 'single', (case does not matter).
+'raid1', 'raid5', 'raid6', 'raid10' or 'single' or dup (case does not matter).
++
+See 'DUP PROFILES ON A SINGLE DEVICE' for more.
 
 *-m|--metadata <profile>*::
 Specify the profile for the metadata block groups.
@@ -60,13 +62,12 @@ Valid values are 'raid0', 'raid1', 'raid5', 'raid6', 'raid10', 'single' or
 A single device filesystem will default to 'DUP', unless a SSD is detected. Then
 it will default to 'single'. The detection is based on the value of
 `/sys/block/DEV/queue/rotational`, where 'DEV' is the short name of the device.
-This is because SSDs can remap the blocks internally to a single copy thus
-deduplicating them which negates the purpose of increased metadata redunancy
-and just wastes space. 
 +
 Note that the rotational status can be arbitrarily set by the underlying block
 device driver and may not reflect the true status (network block device, memory-backed
 SCSI devices etc). Use the options '--data/--metadata' to avoid confusion.
++
+See 'DUP PROFILES ON A SINGLE DEVICE' for more details.
 
 *-M|--mixed*::
 Normally the data and metadata block groups are isolated. The 'mixed' mode
@@ -265,6 +266,29 @@ PROFILES
 another one is added, but *mkfs.btrfs* will not let you create DUP on multiple
 devices.
 
+DUP PROFILES ON A SINGLE DEVICE
+-------------------------------
+
+The mkfs utility will let the user create a filesystem with profiles that write
+the logical blocks to 2 physical locations. Whether there are really 2
+physical copies highly depends on the underlying device type.
+
+For example, a SSD drive can remap the blocks internally to a single copy thus
+deduplicating them. This negates the purpose of increased redunancy and just
+wastes space.
+
+The duplicated data/metadata may still be useful to statistically improve the
+chances on a device that might perform some internal optimizations. The actual
+details are not usually disclosed by vendors. As another example, the widely
+used USB flash or SD cards use a translation layer. The data lifetime may
+be affected by frequent plugging. The memory cells could get damaged, hopefully
+not destroying both copies of particular data.
+
+The traditional rotational hard drives usually fail at the sector level.
+
+In any case, a device that starts to misbehave and repairs from the DUP copy
+should be replaced! *DUP is not backup*.
+
 KNOWN ISSUES
 ------------
 
diff --git a/utils.c b/utils.c
index c20966c19768..d5f60a420135 100644
--- a/utils.c
+++ b/utils.c
@@ -2504,8 +2504,9 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 		return 1;
 	}
 
-	warning_on(!mixed && (data_profile & BTRFS_BLOCK_GROUP_DUP) && ssd,
-		   "DUP have no effect if your SSD have deduplication function");
+	/* warning_on(!mixed && (data_profile & BTRFS_BLOCK_GROUP_DUP) && ssd, */
+	warning_on(!mixed && (data_profile & BTRFS_BLOCK_GROUP_DUP),
+		   "DUP may not actually lead to 2 copies on the device, see manual page");
 
 	return 0;
 }
-- 
2.6.2

