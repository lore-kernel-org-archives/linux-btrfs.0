Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34575 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751609AbbHUDXb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 23:23:31 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <theosib@gmail.com>
Subject: [PATCH 1/2] btrfs-progs: Avoid reading bad fd in case of missing device.
Date: Fri, 21 Aug 2015 11:21:26 +0800
Message-ID: <1440127287-21368-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Offline btrfs tools, like btrfs-image, will infinitely loop when there
is missing device.

The reason is, for missing device, it's fd will be set to -1, but before
we reading, we only check the fd validation by checking if it's 0.
So in that case, -1 will pass the validation check, and cause pread to
return 0, and loop to read.

Just change the validation check from "== 0" to "<= 0" to avoid such
problem.

Reported-by: Timothy Normand Miller <theosib@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-image.c | 2 +-
 disk-io.c     | 4 ++--
 extent_io.c   | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 3684a05..b225325 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -894,7 +894,7 @@ static int read_data_extent(struct metadump_struct *md,
 
 		device = multi->stripes[0].dev;
 
-		if (device->fd == 0) {
+		if (device->fd <= 0) {
 			fprintf(stderr,
 				"Device we need to read from is not open\n");
 			free(multi);
diff --git a/disk-io.c b/disk-io.c
index fdcfd6d..d8ca101 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -266,7 +266,7 @@ int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, int mirr
 			}
 			device = multi->stripes[0].dev;
 
-			if (device->fd == 0) {
+			if (device->fd <= 0) {
 				kfree(multi);
 				return -EIO;
 			}
@@ -385,7 +385,7 @@ int read_extent_data(struct btrfs_root *root, char *data,
 	}
 	device = multi->stripes[0].dev;
 
-	if (device->fd == 0)
+	if (device->fd <= 0)
 		goto err;
 	if (*len > max_len)
 		*len = max_len;
diff --git a/extent_io.c b/extent_io.c
index 5d49710..07695ef 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -714,7 +714,7 @@ int read_data_from_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
 		device = multi->stripes[0].dev;
 
 		read_len = min(bytes_left, read_len);
-		if (device->fd == 0) {
+		if (device->fd <= 0) {
 			kfree(multi);
 			return -EIO;
 		}
@@ -790,7 +790,7 @@ int write_data_to_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
 			raid_map = NULL;
 		} else while (dev_nr < multi->num_stripes) {
 			device = multi->stripes[dev_nr].dev;
-			if (device->fd == 0) {
+			if (device->fd <= 0) {
 				kfree(multi);
 				return -EIO;
 			}
-- 
2.5.0

