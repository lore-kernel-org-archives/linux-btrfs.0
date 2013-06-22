Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ae1-f3.auone-net.jp ([106.187.231.3]:38970 "EHLO
	dmta02.auone-net.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750767Ab3FVGBq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Jun 2013 02:01:46 -0400
Received: from amlmta037.auone-net.jp (amlmta037-MM [10.188.22.95])
	by dmta02.auone-net.jp (au one net mail) with ESMTP id 2C9E840006C
	for <linux-btrfs@vger.kernel.org>; Sat, 22 Jun 2013 14:39:22 +0900 (JST)
Date: Sat, 22 Jun 2013 14:39:21 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Fix segmentation fault
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-Id: <51c53889000d9fe000004a0d00004a0ea000000e0f48@amlmta037.auone-net.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'btrfs subvolume delete' crashes with segv if it runs in a detached mount.

Steps to reprduce:
# mkfs.btrfs /dev/vdb

WARNING! - Btrfs v0.20-rc1 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/vdb
        nodesize 4096 leafsize 4096 sectorsize 4096 size 2.00GB
Btrfs v0.20-rc1
# mount -t btrfs /dev/vdb /mnt
[  333.689984] device fsid b242775b-5e34-4e8b-8f7f-7db585ba1392 devid 1 transid 4 /dev/vdb
[  333.691756] btrfs: disk space caching is enabled
# cd /mnt
# btrfs subvolume create vol
Create subvolume './vol'
# btrfs subvolume snapshot vol snap
Create a snapshot of 'vol' in './snap'
# umount -l .
# btrfs subvolume delete snap
[  377.897175] btrfs[1875]: segfault at 0 ip 00007f6f86100131 sp 00007fff17917318 error 4 in libc-2.17.so[7f6f8607c000+1a4000]
Segmentation fault (core dumped)


Backtrace:
#0  __strlen_sse2 () at ../sysdeps/x86_64/multiarch/../strlen.S:31
No locals.
#1  0x00007f6f860ffda6 in __GI___strdup (s=0x0) at strdup.c:41
        len = <optimized out>
        new = <optimized out>
#2  0x0000000000405a3d in cmd_subvol_delete (argc=2, argv=<optimized out>) at cmds-subvolume.c:228
        res = <optimized out>
        fd = <optimized out>
        len = <optimized out>
        e = <optimized out>
        cnt = 1
        ret = 0
        args = {fd = 0, name = '\000' <repeats 976 times>...}
        dname = <optimized out>
        vname = <optimized out>
        path = <optimized out>
#3  0x0000000000403b1a in handle_command_group (grp=grp@entry=0x6500c0 <subvolume_cmd_group>, argc=2, argv=0x7fff179184e8) at btrfs.c:154
        cmd = 0x6500f8
#4  0x0000000000405c26 in cmd_subvolume (argc=<optimized out>, argv=<optimized out>) at cmds-subvolume.c:969
No locals.
#5  0x0000000000403d69 in main (argc=3, argv=0x7fff179184e0) at btrfs.c:295
        cmd = 0x6515d0
        bname = <optimized out>

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 cmds-subvolume.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ccb4762..f005ba8 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -203,7 +203,7 @@ static int cmd_subvol_delete(int argc, char **argv)
 {
 	int	res, fd, len, e, cnt = 1, ret = 0;
 	struct btrfs_ioctl_vol_args	args;
-	char	*dname, *vname, *cpath;
+	char	*dname, *vname;
 	char	*path;
 
 	if (argc < 2)
@@ -224,12 +224,10 @@ again:
 		goto out;
 	}
 
-	cpath = realpath(path, 0);
-	dname = strdup(cpath);
+	dname = strdup(path);
 	dname = dirname(dname);
-	vname = strdup(cpath);
+	vname = strdup(path);
 	vname = basename(vname);
-	free(cpath);
 
 	if( !strcmp(vname,".") || !strcmp(vname,"..") ||
 	     strchr(vname, '/') ){
-- 
1.8.3.1

