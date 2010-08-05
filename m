From: Wang Shaoyan <stufever@gmail.com>
Subject: [PATCH] btrfs: when mkfs.btrfs, add control to the multiple device
	which have mounted
Date: Thu, 5 Aug 2010 18:04:51 +0800
Message-ID: <AANLkTi=uYk5A+5QTwLA8bS2KDpe12yAyxTNORfqzCV=X@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If some devices were formatted as a fs, and mounted to some directory,
mkfs.btrfs do no check to devices except the first one. Then even if
the device is mounted, we can also mkfs. I think when a device is in
use, we can not mkfs.

But there are some other problems, for examle when we do offline fsck
to an device, then we mkfs it, we also can, it should be prevent.

diff --git a/mkfs.c b/mkfs.c
index 2e99b95..ceb65cb 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -431,6 +431,10 @@ int main(int ac, char **av)
 		fprintf(stderr, "%s is mounted\n", file);
 		exit(1);
 	}
+	if (ret == 2) {
+		fprintf(stderr, "%s is apparently in use by the system\n", file);
+		exit(1);
+	}
 	ac--;
 	fd = open(file, O_RDWR);
 	if (fd < 0) {
@@ -489,6 +493,10 @@ int main(int ac, char **av)
 			fprintf(stderr, "%s is mounted\n", file);
 			exit(1);
 		}
+		if (ret == 2) {
+			fprintf(stderr, "%s is apparently in use by the system\n", file);
+			exit(1);
+		}
 		fd = open(file, O_RDWR);
 		if (fd < 0) {
 			fprintf(stderr, "unable to open %s\n", file);
diff --git a/utils.c b/utils.c
index 2f4c6e1..e400745 100644
--- a/utils.c
+++ b/utils.c
@@ -587,7 +587,7 @@ error:
 }

 /*
- * returns 1 if the device was mounted, < 0 on error or 0 if everything
+ * returns 2 if the device is busy, returns 1 if the device was
mounted, < 0 on error or 0 if everything
  * is safe to continue.  TODO, this should also scan multi-device filesystems
  */
 int check_mounted(char *file)
@@ -599,6 +599,7 @@ int check_mounted(char *file)
 	ino_t file_ino = 0;
 	FILE *f;
 	int ret = 0;
+	int fd;

 	if ((f = setmntent ("/proc/mounts", "r")) == NULL)
 		return -errno;
@@ -629,12 +630,22 @@ int check_mounted(char *file)
 		}
 	}

+	endmntent (f);
 	if (mnt) {
 		/* found an entry in mnt table */
 		ret = 1;
+		goto out;
 	}

-	endmntent (f);
+	fd = open(file, O_RDONLY | O_EXCL);
+	if (fd < 0) {
+		if (errno == EBUSY) {
+			ret = 2;
+		}
+	} else
+		close(fd);
+
+out:
 	return ret;
 }


-- 
Wang Shaoyan
