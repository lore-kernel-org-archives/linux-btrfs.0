From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH] btrfs-progs: Fix over-sized limit on buffer
Date: Sun, 12 Jun 2011 21:57:06 +0100
Message-ID: <13b1c964d3bbd1ce59b89b1671e2c5da239e8931.1307912196.git.hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

gcc-4.4 complains (rightly) that the strncpy has a limit too large for
the array it's copying into. Use the correct array length.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs_cmds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 7de28b6..9d94f6f 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -427,7 +427,7 @@ int do_clone(int argc, char **argv)
 	}
 
 	args.fd = fd;
-	strncpy(args.name, newname, BTRFS_PATH_NAME_MAX);
+	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
 	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
 	e = errno;
 
-- 
1.7.2.5

