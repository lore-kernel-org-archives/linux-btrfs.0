Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:34402 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932154Ab3CDVkd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 16:40:33 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 11/14] btrfs-progs: check return of posix_fadvise
Date: Mon,  4 Mar 2013 16:40:01 -0600
Message-Id: <1362436804-16766-12-git-send-email-sandeen@redhat.com>
In-Reply-To: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It seems highly unlikely that posix_fadvise could fail,
and even if it does, it was only advisory.  Still, if
it does, we could issue a notice to the user.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 disk-io.c |    6 ++++--
 volumes.c |    3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 897d0cf..97fbfbd 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -822,7 +822,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 		sb_bytenr = BTRFS_SUPER_INFO_OFFSET;
 
 	/* try to drop all the caches */
-	posix_fadvise(fp, 0, 0, POSIX_FADV_DONTNEED);
+	if (posix_fadvise(fp, 0, 0, POSIX_FADV_DONTNEED))
+		fprintf(stderr, "Warning, could not drop caches\n");
 
 	ret = btrfs_scan_one_device(fp, path, &fs_devices,
 				    &total_devs, sb_bytenr);
@@ -1282,7 +1283,8 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
 		device = list_entry(next, struct btrfs_device, dev_list);
 		if (device->fd) {
 			fsync(device->fd);
-			posix_fadvise(device->fd, 0, 0, POSIX_FADV_DONTNEED);
+			if (posix_fadvise(device->fd, 0, 0, POSIX_FADV_DONTNEED))
+				fprintf(stderr, "Warning, could not drop caches\n");
 		}
 		close(device->fd);
 	}
diff --git a/volumes.c b/volumes.c
index ca1b402..c0d02d1 100644
--- a/volumes.c
+++ b/volumes.c
@@ -193,7 +193,8 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags)
 			goto fail;
 		}
 
-		posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED);
+		if (posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED))
+			fprintf(stderr, "Warning, could not drop caches\n");
 
 		if (device->devid == fs_devices->latest_devid)
 			fs_devices->latest_bdev = fd;
-- 
1.7.1

