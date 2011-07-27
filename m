From: Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no read/write devices
Date: Wed, 27 Jul 2011 12:01:31 +0100
Message-ID: <1311764491-5687-1-git-send-email-apw@canonical.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When we mount a btrfs filesystem from read-only media there will be no
read/write devices; for example mounting an SD card with its lock enabled.
This triggers an immediate BUG during mount:

  kernel BUG at .../fs/btrfs/super.c:984!

This is triggered by statfs when calculating the free space in the
filesytem.  We bug if the number of read/write devices is 0.

It seems more appropriate to indicate we have no writable space.  Note
that this does make df return 0 free blocks on a read-only device.
Whether that is reasonable is debatable.

BugLink: http://bugs.launchpad.net/bugs/816770
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/btrfs/super.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 15634d4..8d3f9b0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -981,7 +981,10 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	int ret;
 
 	nr_devices = fs_info->fs_devices->rw_devices;
-	BUG_ON(!nr_devices);
+	if (!nr_devices) {
+		*free_bytes = 0;
+		return 0;
+	}
 
 	devices_info = kmalloc(sizeof(*devices_info) * nr_devices,
 			       GFP_NOFS);
-- 
1.7.4.1

