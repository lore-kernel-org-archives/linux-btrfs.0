Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:45480 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaBMTTk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:19:40 -0500
Received: from venice.bhome (151.28.65.181) by outrelay07.libero.it (8.6.033) (authenticated as kreijack@libero.it)
        id 52EA696D030907A6 for linux-btrfs@vger.kernel.org; Thu, 13 Feb 2014 20:19:39 +0100
Message-ID: <52FD1AD0.70201@libero.it>
Date: Thu, 13 Feb 2014 20:19:44 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/8] Allow use of get_device_info()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <52FD1A72.5060307@libero.it>


Allow the use of get_device_info()  for different units.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 utils.c | 2 +-
 utils.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 760db6b..69295b5 100644
--- a/utils.c
+++ b/utils.c
@@ -1591,7 +1591,7 @@ void close_file_or_dir(int fd, DIR *dirstream)
 		close(fd);
 }
 
-static int get_device_info(int fd, u64 devid,
+int get_device_info(int fd, u64 devid,
 		struct btrfs_ioctl_dev_info_args *di_args)
 {
 	int ret;
diff --git a/utils.h b/utils.h
index 0f7939c..58fb4a7 100644
--- a/utils.h
+++ b/utils.h
@@ -97,4 +97,6 @@ int btrfs_scan_lblkid(int update_kernel);
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
 
 u64 disk_size(char *path);
+int get_device_info(int fd, u64 devid,
+		struct btrfs_ioctl_dev_info_args *di_args);
 #endif
-- 
1.8.5.3



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
