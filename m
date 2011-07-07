From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] Btrfs-progs: bugfix: bail out when check_mounted_where returns an error
Date: Thu,  7 Jul 2011 18:19:09 +0200
Message-ID: <1310055549-17510-1-git-send-email-list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 scrub.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scrub.c b/scrub.c
index 22052ed..8270431 100644
--- a/scrub.c
+++ b/scrub.c
@@ -942,6 +942,8 @@ static int scrub_fs_info(int fd, char *path,
 		                          &fs_devices_mnt);
 		if (!ret)
 			return -EINVAL;
+		if (ret < 0)
+			return ret;
 		fi_args->num_devices = 1;
 		fi_args->max_id = fs_devices_mnt->latest_devid;
 		i = fs_devices_mnt->latest_devid;
-- 
1.7.3.4

