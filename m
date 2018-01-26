Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48416 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751841AbeAZWtf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 17:49:35 -0500
From: Howard McLauchlan <hmclauchlan@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: <kernel-team@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Josef Bacik <jbacik@fb.com>, Howard McLauchlan <hmclauchlan@fb.com>
Subject: [PATCH] btrfs: print error if primary super block write fails
Date: Fri, 26 Jan 2018 14:47:09 -0800
Message-ID: <20180126224709.23139-1-hmclauchlan@fb.com>
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
 fs/btrfs/disk-io.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5da18ebc9222..8f96e1e4c613 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3293,11 +3293,13 @@ static int write_dev_supers(struct btrfs_device *device,
  * Return number of errors when buffer head is not found or not marked up to
  * date.
  */
-static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
+static int wait_dev_supers(struct btrfs_fs_info *fs_info,
+			   struct btrfs_device *device, int max_mirrors)
 {
 	struct buffer_head *bh;
 	int i;
 	int errors = 0;
+	bool primary_failed = false;
 	u64 bytenr;
 
 	if (max_mirrors == 0)
@@ -3314,11 +3316,14 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
 				      BTRFS_SUPER_INFO_SIZE);
 		if (!bh) {
 			errors++;
+			primary_failed = (i == 0) || primary_failed;
 			continue;
 		}
 		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh))
+		if (!buffer_uptodate(bh)) {
 			errors++;
+			primary_failed = (i == 0) || primary_failed;
+		}
 
 		/* drop our reference */
 		brelse(bh);
@@ -3327,6 +3332,12 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
 		brelse(bh);
 	}
 
+	/* log error, force error return */
+	if (primary_failed) {
+		btrfs_err(fs_info, "error encountered writing primary super block");
+		return -1;
+	}
+
 	return errors < i ? 0 : -1;
 }
 
@@ -3557,7 +3568,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
-		ret = wait_dev_supers(dev, max_mirrors);
+		ret = wait_dev_supers(fs_info, dev, max_mirrors);
 		if (ret)
 			total_errors++;
 	}
-- 
2.14.1

