From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH -V2] btrfs-progs: add mounted-checking for btrfs-vol
Date: Wed, 03 Feb 2010 10:12:44 +0800
Message-ID: <4B68DB9C.9050501@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Wengang Wang <wen.gang.wang@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Adding a mounted device is dangerous because it will destroy the filesystem
on that mounted device. So we add mounted-checking for btrfs-vol.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 btrfs-vol.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/btrfs-vol.c b/btrfs-vol.c
index 8069778..4ed799d 100644
--- a/btrfs-vol.c
+++ b/btrfs-vol.c
@@ -108,10 +108,24 @@ int main(int ac, char **av)
 	if (device && strcmp(device, "missing") == 0 &&
 	    cmd == BTRFS_IOC_RM_DEV) {
 		fprintf(stderr, "removing missing devices from %s\n", mnt);
-	} else if (device) {
+	} else if (cmd != BTRFS_IOC_BALANCE) {
+		if (cmd == BTRFS_IOC_ADD_DEV) {
+			ret = check_mounted(device);
+			if (ret < 0) {
+				fprintf(stderr,
+					"error checking %s mount status\n",
+					device);
+				exit(1);
+			}
+			if (ret == 1) {
+				fprintf(stderr, "%s is mounted\n", device);
+				exit(1);
+			}
+		}
 		devfd = open(device, O_RDWR);
-		if (!devfd) {
+		if (devfd < 0) {
 			fprintf(stderr, "Unable to open device %s\n", device);
+			exit(1);
 		}
 		ret = fstat(devfd, &st);
 		if (ret) {
-- 
1.6.5.2

