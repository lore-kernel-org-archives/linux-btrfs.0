Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40186 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752589AbeBBTLL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 14:11:11 -0500
From: Howard McLauchlan <hmclauchlan@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: <kernel-team@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Josef Bacik <jbacik@fb.com>, Howard McLauchlan <hmclauchlan@fb.com>
Subject: [PATCH v3] btrfs: print error if primary super block write fails
Date: Fri, 2 Feb 2018 11:09:01 -0800
Message-ID: <20180202190901.10988-1-hmclauchlan@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Presently, failing a primary super block write but succeeding in at
least one super block write in general will appear to users as if
nothing important went wrong. However, upon unmounting and re-mounting,
the file system will be in a rolled back state. This was discovered
with a BCC program that uses bpf_override_return() to fail super block
writes.

This patch outputs an error clarifying that the primary super block
write has failed, so users can expect potentially erroneous behaviour.
It also forces wait_dev_supers() to return an error to its caller if
the primary super block write fails.

Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
---
V3: Rewrote boolean setting logic for clarity
V2: Added devid to output, removed unnecessary fs_info parameter

 fs/btrfs/disk-io.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5da18ebc9222..6ef32eb94669 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3298,6 +3298,7 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
 	struct buffer_head *bh;
 	int i;
 	int errors = 0;
+	bool primary_failed = false;
 	u64 bytenr;
 
 	if (max_mirrors == 0)
@@ -3314,11 +3315,16 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
 				      BTRFS_SUPER_INFO_SIZE);
 		if (!bh) {
 			errors++;
+			if (i == 0)
+				primary_failed = true;
 			continue;
 		}
 		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh))
+		if (!buffer_uptodate(bh)) {
 			errors++;
+			if (i == 0)
+				primary_failed = true;
+		}
 
 		/* drop our reference */
 		brelse(bh);
@@ -3327,6 +3333,13 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
 		brelse(bh);
 	}
 
+	/* log error, force error return */
+	if (primary_failed) {
+		btrfs_err(device->fs_info, "error writing primary super block to device %llu",
+			  device->devid);
+		return -1;
+	}
+
 	return errors < i ? 0 : -1;
 }
 
-- 
2.14.1

