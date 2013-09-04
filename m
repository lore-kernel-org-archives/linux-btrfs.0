Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44209 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3IDPWw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:22:52 -0400
Received: by mail-pa0-f45.google.com with SMTP id bg4so571295pad.18
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:22:51 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 03/20] Btrfs-progs: fix magic return value in cmds-chunk.c
Date: Wed,  4 Sep 2013 23:22:20 +0800
Message-Id: <1378308157-4621-4-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-chunk.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/cmds-chunk.c b/cmds-chunk.c
index 54f0573..115db61 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -794,13 +794,15 @@ static int scan_devices(struct recover_control *rc)
 	int ret = 0;
 	int fd;
 	struct btrfs_device *dev;
+	int e;
 
 	list_for_each_entry(dev, &rc->fs_devices->devices, dev_list) {
 		fd = open(dev->name, O_RDONLY);
 		if (fd < 0) {
+			e = errno;
 			fprintf(stderr, "Failed to open device %s\n",
 				dev->name);
-			return -1;
+			return -e;
 		}
 		ret = scan_one_device(rc, fd, dev);
 		close(fd);
@@ -1785,7 +1787,7 @@ int cmd_chunk_recover(int argc, char *argv[])
 	ret = check_mounted(file);
 	if (ret) {
 		fprintf(stderr, "the device is busy\n");
-		return ret;
+		goto out;
 	}
 
 	ret = btrfs_recover_chunk_tree(file, verbose, yes);
@@ -1797,5 +1799,6 @@ int cmd_chunk_recover(int argc, char *argv[])
 	} else {
 		fprintf(stdout, "Fail to recover the chunk tree.\n");
 	}
-	return ret;
+out:
+	return !!ret;
 }
-- 
1.7.11.7

