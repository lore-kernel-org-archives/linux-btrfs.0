Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:54809 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3K2OXc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Nov 2013 09:23:32 -0500
Received: by mail-pd0-f171.google.com with SMTP id z10so13841120pdj.2
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Nov 2013 06:23:31 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH] Btrfs-progs: avoid using btrfs internal subvolume path to send
Date: Fri, 29 Nov 2013 22:23:09 +0800
Message-Id: <1385734989-8839-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Steps to reproduce:
	# mkfs.btrfs -f /dev/sda
	# mount /dev/sda /mnt
	# btrfs subvolume create /mnt/foo
	# umount /mnt
	# mount -o subvol=foo /dev/sda /mnt
	# btrfs sub snapshot -r /mnt /mnt/snap
	# btrfs send /mnt/snap > /dev/null

We will fail to send '/mnt/snap',this is because btrfs send try to
open '/mnt/snap' by btrfs internal subvolume path 'foo/snap' rather
than relative path based on mounted point, this will return us 'no
such file or directory',this is not right, fix it.

Reported-by: Thomas Scheiblauer <tom@sharkbay.at>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-send.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 53e9a53..b3dde83 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -283,7 +283,7 @@ out:
 }
 
 static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root_id,
-		   int is_first_subvol, int is_last_subvol)
+		   int is_first_subvol, int is_last_subvol, char *subvol)
 {
 	int ret;
 	pthread_t t_read;
@@ -303,10 +303,10 @@ static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root_id,
 		goto out;
 	}
 
-	subvol_fd = openat(send->mnt_fd, si->path, O_RDONLY | O_NOATIME);
+	subvol_fd = openat(send->mnt_fd, subvol, O_RDONLY | O_NOATIME);
 	if (subvol_fd < 0) {
 		ret = -errno;
-		fprintf(stderr, "ERROR: open %s failed. %s\n", si->path,
+		fprintf(stderr, "ERROR: open %s failed. %s\n", subvol,
 				strerror(-ret));
 		goto out;
 	}
@@ -701,7 +701,7 @@ int cmd_send(int argc, char **argv)
 			is_last_subvol = 1;
 		}
 		ret = do_send(&send, root_id, parent_root_id,
-			      is_first_subvol, is_last_subvol);
+			      is_first_subvol, is_last_subvol, subvol);
 		if (ret < 0)
 			goto out;
 
-- 
1.8.4

