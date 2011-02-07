From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Subject: [PATCH] Btrfs-progs utils Informative errors
Date: Mon, 7 Feb 2011 01:34:36 -0600
Message-ID: <AANLkTimF0WPOEufo2+R7xeeqDzWf=PZPfSXcZ929G4z1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs utils errors on removable media devices with no media
that cannot be read. Make the error more informative using strerror so
it may be safely be ignored by users.

Also corrected the directory name of the device directory being
scanned.

diff --git a/utils.c b/utils.c
index fd894f3..589bfd7 100644
--- a/utils.c
+++ b/utils.c
@@ -867,7 +867,7 @@ again:
 	}
 	dirp = opendir(dirname);
 	if (!dirp) {
-		fprintf(stderr, "Unable to open /sys/block for scanning\n");
+		fprintf(stderr, "Unable to open %s for scanning\n", dirname);
 		return -ENOENT;
 	}
 	while(1) {
@@ -902,7 +902,8 @@ again:
 		}
 		fd = open(fullpath, O_RDONLY);
 		if (fd < 0) {
-			fprintf(stderr, "failed to read %s\n", fullpath);
+			fprintf(stderr, "failed to read %s: %s\n", fullpath,
+					strerror(errno));
 			continue;
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,

-- 
Goldwyn
