Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35049 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbcGGKm1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 06:42:27 -0400
Received: by mail-pf0-f196.google.com with SMTP id t190so1500896pfb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 03:42:27 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, wangshilong1991@gmail.com
Subject: [PATCH v2] btrfs-progs: du: fix to skip not btrfs dir/file
Date: Thu,  7 Jul 2016 18:43:38 +0900
Message-Id: <1467884618-29630-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'btrfs file du' is a very useful tool to watch my system
file usage information with snapshot aware.

when trying to run following commands:
[root@localhost btrfs-progs]# btrfs file du /
     Total   Exclusive  Set shared  Filename
ERROR: Failed to lookup root id - Inappropriate ioctl for device
ERROR: cannot check space of '/': Unknown error -1

and My Filesystem looks like this:
[root@localhost btrfs-progs]# df -Th
Filesystem     Type      Size  Used Avail Use% Mounted on
devtmpfs       devtmpfs   16G     0   16G   0% /dev
tmpfs          tmpfs      16G  368K   16G   1% /dev/shm
tmpfs          tmpfs      16G  1.4M   16G   1% /run
tmpfs          tmpfs      16G     0   16G   0% /sys/fs/cgroup
/dev/sda3      btrfs      60G   19G   40G  33% /
tmpfs          tmpfs      16G  332K   16G   1% /tmp
/dev/sdc       btrfs     2.8T  166G  1.7T   9% /data
/dev/sda2      xfs       2.0G  452M  1.6G  23% /boot
/dev/sda1      vfat      1.9G   11M  1.9G   1% /boot/efi
tmpfs          tmpfs     3.2G   24K  3.2G   1% /run/user/1000

So I installed Btrfs as my root partition, but boot partition
can be other fs.

We can Let btrfs tool aware of this is not a btrfs file or
directory and skip those files, so that someone like me
could just run 'btrfs file du /' to scan all btrfs filesystems.

After patch, it will look like:
   Total   Exclusive  Set shared  Filename
     0.00B       0.00B           -  //root/.bash_logout
     0.00B       0.00B           -  //root/.bash_profile
     0.00B       0.00B           -  //root/.bashrc
     0.00B       0.00B           -  //root/.cshrc
     0.00B       0.00B           -  //root/.tcshrc

This works for me to analysis system usage and analysis
performaces.

Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
---
v1->v2: remove extra unnecessary messages output
---
 cmds-fi-du.c   | 8 +++++++-
 cmds-inspect.c | 2 +-
 utils.c        | 8 ++++----
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/cmds-fi-du.c b/cmds-fi-du.c
index 12855a5..6d5bf35 100644
--- a/cmds-fi-du.c
+++ b/cmds-fi-du.c
@@ -389,8 +389,14 @@ static int du_walk_dir(struct du_dir_ctxt *ctxt, struct rb_root *shared_extents)
 						  dirfd(dirstream),
 						  shared_extents, &tot, &shr,
 						  0);
-				if (ret)
+				if (ret == -ENOTTY) {
+					continue;
+				} else if (ret) {
+					fprintf(stderr,
+						"failed to walk dir/file: %s :%s\n",
+						entry->d_name, strerror(-ret));
 					break;
+				}
 
 				ctxt->bytes_total += tot;
 				ctxt->bytes_shared += shr;
diff --git a/cmds-inspect.c b/cmds-inspect.c
index dd7b9dd..2ae44be 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -323,7 +323,7 @@ static int cmd_inspect_rootid(int argc, char **argv)
 
 	ret = lookup_ino_rootid(fd, &rootid);
 	if (ret) {
-		error("rootid failed with ret=%d", ret);
+		error("failed to lookup root id: %s", strerror(-ret));
 		goto out;
 	}
 
diff --git a/utils.c b/utils.c
index 578fdb0..f73b048 100644
--- a/utils.c
+++ b/utils.c
@@ -2815,6 +2815,8 @@ path:
 	if (fd < 0)
 		goto err;
 	ret = lookup_ino_rootid(fd, &id);
+	if (ret)
+		error("failed to lookup root id: %s", strerror(-ret));
 	close(fd);
 	if (ret < 0)
 		goto err;
@@ -3497,10 +3499,8 @@ int lookup_ino_rootid(int fd, u64 *rootid)
 	args.objectid = BTRFS_FIRST_FREE_OBJECTID;
 
 	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
-	if (ret < 0) {
-		error("failed to lookup root id: %s", strerror(errno));
-		return ret;
-	}
+	if (ret < 0)
+		return -errno;
 
 	*rootid = args.treeid;
 
-- 
2.7.4

