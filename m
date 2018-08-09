Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42310 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbeHIUhN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:37:13 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 02/12] btrfs-progs: utils: Introduce queue_param
Date: Fri, 10 Aug 2018 03:10:55 +0900
Message-Id: <20180809181105.12856-2-naota@elisp.net>
In-Reply-To: <20180809181105.12856-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
 <20180809181105.12856-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce the queue_param function to get a device request queue
parameter and this function to test if the device is an SSD in
is_ssd().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
[Naohiro] fixed error return value
Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 mkfs/main.c | 40 ++--------------------------------------
 utils.c     | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 utils.h     |  1 +
 3 files changed, 49 insertions(+), 38 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index b76462a7..83969b4b 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -435,49 +435,13 @@ static int zero_output_file(int out_fd, u64 size)
 
 static int is_ssd(const char *file)
 {
-	blkid_probe probe;
-	char wholedisk[PATH_MAX];
-	char sysfs_path[PATH_MAX];
-	dev_t devno;
-	int fd;
 	char rotational;
 	int ret;
 
-	probe = blkid_new_probe_from_filename(file);
-	if (!probe)
+	ret = queue_param(file, "rotational", &rotational, 1);
+	if (ret < 1)
 		return 0;
 
-	/* Device number of this disk (possibly a partition) */
-	devno = blkid_probe_get_devno(probe);
-	if (!devno) {
-		blkid_free_probe(probe);
-		return 0;
-	}
-
-	/* Get whole disk name (not full path) for this devno */
-	ret = blkid_devno_to_wholedisk(devno,
-			wholedisk, sizeof(wholedisk), NULL);
-	if (ret) {
-		blkid_free_probe(probe);
-		return 0;
-	}
-
-	snprintf(sysfs_path, PATH_MAX, "/sys/block/%s/queue/rotational",
-		 wholedisk);
-
-	blkid_free_probe(probe);
-
-	fd = open(sysfs_path, O_RDONLY);
-	if (fd < 0) {
-		return 0;
-	}
-
-	if (read(fd, &rotational, 1) < 1) {
-		close(fd);
-		return 0;
-	}
-	close(fd);
-
 	return rotational == '0';
 }
 
diff --git a/utils.c b/utils.c
index d4395b1f..2212692c 100644
--- a/utils.c
+++ b/utils.c
@@ -65,6 +65,52 @@ static unsigned short rand_seed[3];
 
 struct btrfs_config bconf;
 
+/*
+ * Get a device request queue parameter.
+ */
+int queue_param(const char *file, const char *param, char *buf, size_t len)
+{
+	blkid_probe probe;
+	char wholedisk[PATH_MAX];
+	char sysfs_path[PATH_MAX];
+	dev_t devno;
+	int fd;
+	int ret;
+
+	probe = blkid_new_probe_from_filename(file);
+	if (!probe)
+		return 0;
+
+	/* Device number of this disk (possibly a partition) */
+	devno = blkid_probe_get_devno(probe);
+	if (!devno) {
+		blkid_free_probe(probe);
+		return 0;
+	}
+
+	/* Get whole disk name (not full path) for this devno */
+	ret = blkid_devno_to_wholedisk(devno,
+			wholedisk, sizeof(wholedisk), NULL);
+	if (ret) {
+		blkid_free_probe(probe);
+		return 0;
+	}
+
+	snprintf(sysfs_path, PATH_MAX, "/sys/block/%s/queue/%s",
+		 wholedisk, param);
+
+	blkid_free_probe(probe);
+
+	fd = open(sysfs_path, O_RDONLY);
+	if (fd < 0)
+		return 0;
+
+	len = read(fd, buf, len);
+	close(fd);
+
+	return len;
+}
+
 /*
  * Discard the given range in one go
  */
diff --git a/utils.h b/utils.h
index b6c00cfa..ac333095 100644
--- a/utils.h
+++ b/utils.h
@@ -120,6 +120,7 @@ int get_label(const char *btrfs_dev, char *label);
 int set_label(const char *btrfs_dev, const char *label);
 
 char *__strncpy_null(char *dest, const char *src, size_t n);
+int queue_param(const char *file, const char *param, char *buf, size_t len);
 int is_block_device(const char *file);
 int is_mount_point(const char *file);
 int is_path_exist(const char *file);
-- 
2.18.0

