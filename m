From: Ben Gamari <bgamari.foss@gmail.com>
Subject: [PATCH] Improve error handling in filesystem df
Date: Sun, 19 Dec 2010 17:29:41 -0500
Message-ID: <1292797781-3877-1-git-send-email-bgamari.foss@gmail.com>
Cc: Ben Gamari <bgamari.foss@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The return values of ioctl weren't being printed to stderr on failure,
causing the command to silently fail, resulting in a very confused
user.

Signed-off-by: Ben Gamari <bgamari.foss@gmail.com>
---
 btrfs_cmds.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..45da2bd 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -857,6 +857,7 @@ int do_df_filesystem(int nargs, char **argv)
 
 	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
 	if (ret) {
+		fprintf(stderr, "ERROR: can't query '%s' for free space (%s)\n", path, strerror(-ret));
 		free(sargs);
 		return ret;
 	}
@@ -875,6 +876,7 @@ int do_df_filesystem(int nargs, char **argv)
 
 	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
 	if (ret) {
+		fprintf(stderr, "ERROR: can't query '%s' for free space (%s)\n", path, strerror(-ret));
 		free(sargs);
 		return ret;
 	}
-- 
1.7.1

