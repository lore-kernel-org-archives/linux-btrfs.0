Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2114 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751622AbaGBDlH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 23:41:07 -0400
Message-ID: <53B37E4D.4000403@cn.fujitsu.com>
Date: Wed, 2 Jul 2014 11:36:45 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/1] btrfs: looping 'mkfs.btrfs -f <dev>' may fail with
 EBUSY
References: <1402554300-13931-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1402554300-13931-1-git-send-email-Anand.Jain@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/12/2014 02:25 PM, Anand Jain wrote:
> The thread holding the O_EXCL flag seems to be BTRFS_IOC_SCAN_DEV ioctl,
> which in turn calls btrfs_scan_one_device() to open dev with the O_EXCL flag.
>
> But btrfs_scan_one_device() does not write anything to the disk.
> and it is called by
>        . An intermediary step (not the final open_ctree) in the
>          mount thread to read the SB and
>        . btrfs-control ioctls viz BTRFS_IOC_SCAN_DEV and
>          BTRFS_IOC_DEVICES_READY
> they don't need the O_EXCL.
>
> test script: (run this in a loop)
> static int test_skip_this_disk(char *path)
> {
>      int fd;
>      char c;
>
>      printf("%s ", path);
>      fd = open(path, O_RDWR|O_EXCL);
>      if (fd < 0) {
>          printf("Open failed\n");
>          return 1;
>      }
>      /*fflush(stdout);
>      printf("Open Fine press enter\n");
>      scanf("%c", &c);*/
>      close(fd);
>      return 0;
> }
>
> main(int arg, char **argv)
> {
>      int i;
>
>      if (arg == 1) {
>          printf("usage: %s <dev-with-btrfs-sb> .. \n", argv[0]);
>          exit(1);
>      }
>
>      for (i = 1; i < arg; i++)
>          test_skip_this_disk(argv[i]);
> }
>
> dump stack after the userland close(fd)
>
> dump_stack+0x9/0x60
> btrfs_scan_one_device+0x18d/0x1f0 [btrfs]
> btrfs_control_ioctl+0xb9/0x210 [btrfs]
> do_vfs_ioctl+0x84/0x4c0
> inode_has_perm+0x28/0x30
> file_has_perm+0x8a/0xa0
> SyS_ioctl+0x91/0xa0
> system_call_fastpath+0x16/0x1b
>
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
> ---
>   fs/btrfs/volumes.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 636faa0..c186b5e 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -914,7 +914,6 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>   	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
>   	 */
>   	bytenr = btrfs_sb_offset(0);
> -	flags |= FMODE_EXCL;
I could not think whether it will cause some big problem if we remove 
this flag.
So Cc Chris and others.

Any ideas about this problem?

Thanks,
Wang
>   	mutex_lock(&uuid_mutex);
>   
>   	bdev = blkdev_get_by_path(path, flags, holder);

