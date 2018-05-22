Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:45780 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753004AbeEVWoR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 18:44:17 -0400
Received: by mail-pf0-f194.google.com with SMTP id c10-v6so9448174pfi.12
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 15:44:16 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, David Sterba <dsterba@suse.com>
Subject: [PATCH] Btrfs: fix memory and mount leak in btrfs_ioctl_rm_dev_v2()
Date: Tue, 22 May 2018 15:44:01 -0700
Message-Id: <78fcd50378fec419da9f60086ce8331e12c7563d.1527028634.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

If we have invalid flags set, when we error out we must drop our writer
counter and free the buffer we allocated for the arguments. This bug is
trivially reproduced with the following program:

	#include <fcntl.h>
	#include <stdint.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <unistd.h>
	#include <sys/ioctl.h>
	#include <sys/stat.h>
	#include <sys/types.h>
	#include <linux/btrfs.h>
	#include <linux/btrfs_tree.h>

	int main(int argc, char **argv)
	{
		struct btrfs_ioctl_vol_args_v2 vol_args = {
			.flags = UINT64_MAX,
		};
		int ret;
		int fd;

		if (argc != 2) {
			fprintf(stderr, "usage: %s PATH\n", argv[0]);
			return EXIT_FAILURE;
		}

		fd = open(argv[1], O_WRONLY);
		if (fd == -1) {
			perror("open");
			return EXIT_FAILURE;
		}

		ret = ioctl(fd, BTRFS_IOC_RM_DEV_V2, &vol_args);
		if (ret == -1)
			perror("ioctl");

		close(fd);
		return EXIT_SUCCESS;
	}

When unmounting the filesystem, we'll hit the
WARN_ON(mnt_get_writers(mnt)) in cleanup_mnt().

Fixes: 6b526ed70cf1 ("btrfs: introduce device delete by devid")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Sigh, I keep stepping in these ioctl bugs just trying to get my swap
file series ready. This one is based on top of my "Btrfs: fix partly
checksummed file races" series, although it should apply to for-next
without it +/- some moved lines.

 fs/btrfs/ioctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c2263bf4d6f5..9af3be96099f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3086,8 +3086,10 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 	}
 
 	/* Check for compatibility reject unknown flags */
-	if (vol_args->flags & ~BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED)
-		return -EOPNOTSUPP;
+	if (vol_args->flags & ~BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
 
 	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
 		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
-- 
2.17.0

