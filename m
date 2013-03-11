Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:21381 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754737Ab3CKWN3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 18:13:29 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/4] btrfs-progs: three new device/path helpers
Date: Mon, 11 Mar 2013 18:12:59 -0500
Message-Id: <1363043581-15812-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1363043581-15812-1-git-send-email-sandeen@redhat.com>
References: <1363043581-15812-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add 3 new helpers:

* is_block_device(), to test if a path is a block device.
* get_btrfs_mount(), to get the mountpoint of a device,
  if mounted.
* open_path_or_dev_mnt(path), to open either the pathname
  or, if it's a mounted btrfs dev, the mountpoint.  Useful
  for some commands which can take either type of arg.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 utils.c |   84 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h |    3 ++
 2 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/utils.c b/utils.c
index 1c73d67..4bf457f 100644
--- a/utils.c
+++ b/utils.c
@@ -640,6 +640,90 @@ error:
 	return ret;
 }
 
+/*
+ * checks if a path is a block device node
+ * Returns negative errno on failure, otherwise
+ * returns 1 for blockdev, 0 for not-blockdev
+ */
+int is_block_device (const char *path) {
+	struct stat statbuf;
+
+	if (stat(path, &statbuf) < 0)
+		return -errno;
+
+	return (S_ISBLK(statbuf.st_mode));
+}
+
+/*
+ * Find the mount point for a mounted device.
+ * On success, returns 0 with mountpoint in *mp.
+ * On failure, returns -errno (not mounted yields -EINVAL)
+ * Is noisy on failures, expects to be given a mounted device.
+ */
+int get_btrfs_mount(const char *dev, char *mp, size_t mp_size) {
+	int ret;
+	int fd = -1;
+
+	ret = is_block_device(dev);
+	if (ret <= 0) {
+		if (!ret) {
+			fprintf(stderr, "%s is not a block device\n", dev);
+			ret = -EINVAL;
+		} else
+			fprintf(stderr, "Could not check %s: %s\n",
+				dev, strerror(-ret));
+		goto out;
+	}
+
+	fd = open(dev, O_RDONLY);
+	if (fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "Could not open %s: %s\n", dev, strerror(errno));
+		goto out;
+	}
+
+	ret = check_mounted_where(fd, dev, mp, mp_size, NULL);
+	if (!ret) {
+		fprintf(stderr, "%s is not a mounted btrfs device\n", dev);
+		ret = -EINVAL;
+	} else /* mounted, all good */
+		ret = 0;
+out:
+	if (fd != -1)
+		close(fd);
+	if (ret)
+		fprintf(stderr, "Could not get mountpoint for %s\n", dev);
+	return ret;
+}
+
+/*
+ * Given a pathname, return a filehandle to:
+ * 	the original pathname or,
+ * 	if the pathname is a mounted btrfs device, to its mountpoint.
+ *
+ * On error, return -1, errno should be set.
+ */
+int open_path_or_dev_mnt(const char *path)
+{
+	char mp[BTRFS_PATH_NAME_MAX + 1];
+	int fdmnt;
+
+	if (is_block_device(path)) {
+		int ret;
+
+		ret = get_btrfs_mount(path, mp, sizeof(mp));
+		if (ret < 0) {
+			/* not a mounted btrfs dev */
+			errno = EINVAL;
+			return -1;
+		}
+		fdmnt = open(mp, O_RDWR);
+	} else
+		fdmnt = open_file_or_dir(path);
+
+	return fdmnt;
+}
+
 /* checks if a device is a loop device */
 int is_loop_device (const char* device) {
 	struct stat statbuf;
diff --git a/utils.h b/utils.h
index 0b681ed..8e0252b 100644
--- a/utils.h
+++ b/utils.h
@@ -56,6 +56,9 @@ int get_label(const char *btrfs_dev);
 int set_label(const char *btrfs_dev, const char *label);
 
 char *__strncpy__null(char *dest, const char *src, size_t n);
+int is_block_device(const char *file);
+int get_btrfs_mount(const char *path, char *mp, size_t mp_size);
+int open_path_or_dev_mnt(const char *path);
 int is_swap_device(const char *file);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
-- 
1.7.1

