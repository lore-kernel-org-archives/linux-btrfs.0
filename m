Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:33026 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966825AbdDSVIB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Apr 2017 17:08:01 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Wed, 19 Apr 2017 23:07:45 +0200
Message-Id: <20170419210745.15263-1-kilobyte@angband.pl>
Subject: [PATCH ping] btrfs: warn about RAID5/6 being experimental at mount time
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Too many people come complaining about losing their data -- and indeed,
there's no warning outside a wiki and the mailing list tribal knowledge.
Message severity chosen for consistency with XFS -- "alert" makes dmesg
produce nice red background which should get the point across.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
Resent alone, the other patch in the original series (dropping the incompat
flag when no longer needed) is pointless on its own.

I intend to ask for inclusion of this one (or an equivalent) in 4.9, either
in Debian or via GregKH -- while for us kernels "that old" are history,
regular users expect stable releases to be free of known serious data loss
bugs.


 fs/btrfs/disk-io.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e54844767fe5..e7f91f70e149 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3083,6 +3083,14 @@ int open_ctree(struct super_block *sb,
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
 
+	if ((fs_info->avail_data_alloc_bits |
+	     fs_info->avail_metadata_alloc_bits |
+	     fs_info->avail_system_alloc_bits) &
+	    BTRFS_BLOCK_GROUP_RAID56_MASK) {
+		btrfs_alert(fs_info,
+		"btrfs RAID5/6 is EXPERIMENTAL and has known data-loss bugs");
+	}
+
 	/*
 	 * Mount does not set all options immediately, we can do it now and do
 	 * not have to wait for transaction commit
-- 
2.11.0

