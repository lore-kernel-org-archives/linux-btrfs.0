From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] Btrfs-progs: bugfix for scrubbing single devices
Date: Tue, 29 Nov 2011 08:40:28 +0100
Message-ID: <1322552428-6976-1-git-send-email-sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Scrub can be invoked to scrub only a single device of a (mounted) filesystem.
The code determines whether the given path is a mountpoint of a filesystem
by issueing a btrfs-specific ioctl to it. Only in case of EINVAL it assumed
it may be a device, all other errnos just caused it fail, but some devices
(correctly) return ENOTTY. This patch adds this to the error check.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 scrub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scrub.c b/scrub.c
index 9dca5f6..ca7cce7 100644
--- a/scrub.c
+++ b/scrub.c
@@ -987,7 +987,7 @@ static int scrub_fs_info(int fd, char *path,
 	memset(fi_args, 0, sizeof(*fi_args));
 
 	ret = ioctl(fd, BTRFS_IOC_FS_INFO, fi_args);
-	if (ret && errno == EINVAL) {
+	if (ret && (errno == EINVAL || errno == ENOTTY)) {
 		/* path is no mounted btrfs. try if it's a device */
 		ret = check_mounted_where(fd, path, mp, sizeof(mp),
 						&fs_devices_mnt);
-- 
1.7.3.4

