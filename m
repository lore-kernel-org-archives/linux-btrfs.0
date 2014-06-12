Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43216 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbaFLGWl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 02:22:41 -0400
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl.fnst@cn.fujitsu.com, Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH 1/1] btrfs: looping 'mkfs.btrfs -f <dev>' may fail with EBUSY
Date: Thu, 12 Jun 2014 14:25:00 +0800
Message-Id: <1402554300-13931-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The thread holding the O_EXCL flag seems to be BTRFS_IOC_SCAN_DEV ioctl,
which in turn calls btrfs_scan_one_device() to open dev with the O_EXCL flag.

But btrfs_scan_one_device() does not write anything to the disk.
and it is called by
      . An intermediary step (not the final open_ctree) in the
        mount thread to read the SB and
      . btrfs-control ioctls viz BTRFS_IOC_SCAN_DEV and
        BTRFS_IOC_DEVICES_READY
they don't need the O_EXCL.

test script: (run this in a loop)
static int test_skip_this_disk(char *path)
{
    int fd;
    char c;

    printf("%s ", path);
    fd = open(path, O_RDWR|O_EXCL);
    if (fd < 0) {
        printf("Open failed\n");
        return 1;
    }
    /*fflush(stdout);
    printf("Open Fine press enter\n");
    scanf("%c", &c);*/
    close(fd);
    return 0;
}

main(int arg, char **argv)
{
    int i;

    if (arg == 1) {
        printf("usage: %s <dev-with-btrfs-sb> .. \n", argv[0]);
        exit(1);
    }

    for (i = 1; i < arg; i++)
        test_skip_this_disk(argv[i]);
}

dump stack after the userland close(fd)

dump_stack+0x9/0x60
btrfs_scan_one_device+0x18d/0x1f0 [btrfs]
btrfs_control_ioctl+0xb9/0x210 [btrfs]
do_vfs_ioctl+0x84/0x4c0
inode_has_perm+0x28/0x30
file_has_perm+0x8a/0xa0
SyS_ioctl+0x91/0xa0
system_call_fastpath+0x16/0x1b

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 fs/btrfs/volumes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 636faa0..c186b5e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -914,7 +914,6 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	 */
 	bytenr = btrfs_sb_offset(0);
-	flags |= FMODE_EXCL;
 	mutex_lock(&uuid_mutex);
 
 	bdev = blkdev_get_by_path(path, flags, holder);
-- 
1.8.5.3

