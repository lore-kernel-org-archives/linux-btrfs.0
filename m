Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:55224 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161035Ab3BHJji (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2013 04:39:38 -0500
Message-ID: <5114C7E4.5040103@giantdisaster.de>
Date: Fri, 08 Feb 2013 10:39:48 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: cleanup orphan reservation if truncate fails
References: <1360272524-19548-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1360272524-19548-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 7 Feb 2013 16:28:44 -0500, Josef Bacik wrote:
> I noticed we were getting lots of warnings with xfstest 83 because we have
> reservations outstanding.  This is because we moved the orphan add outside
> of the truncate, but we don't actually cleanup our reservation if something
> fails.  This fixes the problem and I no longer see warnings.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/inode.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 73e9409..905297f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2538,6 +2538,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
>  				goto out;
>  
>  			ret = btrfs_truncate(inode);
> +			if (ret)
> +				btrfs_orphan_del(NULL, inode);
>  		} else {
>  			nr_unlink++;
>  		}

There are more warnings when running xfstest 083. With btrfs-next plus your two new patches ("[PATCH] Btrfs: steal from global reserve if we are cleaning up orphans V2" and "[PATCH] Btrfs: cleanup orphan reservation if truncate fails") I get a warning (see below) almost every time when I run xfstest 083.
If I apply only the 1st patch, it happens in 50% of the cases. And if I apply only the 2nd patch, the warning and the "Busy inodes" message happens in 50% of the cases as well.

With btrfs-next _without_ your new patches, the same thing happens in 3% of the cases. You made it happen more often with your new patches.


run xfstest 083
btrfs: disk space caching is enabled
Btrfs detected SSD devices, enabling SSD mode
------------[ cut here ]------------
WARNING: at fs/btrfs/disk-io.c:3227 free_fs_root+0x86/0x90 [btrfs]()
Hardware name: X8SIL
Modules linked in: btrfs raid1 mpt2sas scsi_transport_sas raid_class [last unloaded: btrfs]
Pid: 24225, comm: umount Tainted: G    B   W    3.7.0+ #27
Call Trace:
 [<ffffffff8108642a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81086475>] warn_slowpath_null+0x15/0x20
 [<ffffffffa03403a6>] free_fs_root+0x86/0x90 [btrfs]
 [<ffffffffa03438eb>] btrfs_free_fs_root+0x7b/0x90 [btrfs]
 [<ffffffffa03439cf>] del_fs_roots+0xcf/0x110 [btrfs]
 [<ffffffffa033809f>] ? btrfs_free_block_groups+0x28f/0x360 [btrfs]
 [<ffffffffa0345240>] close_ctree+0x1d0/0x350 [btrfs]
 [<ffffffff811b1dc4>] ? evict_inodes+0x104/0x120
 [<ffffffffa031a284>] btrfs_put_super+0x14/0x20 [btrfs]
 [<ffffffff8119949c>] generic_shutdown_super+0x5c/0xe0
 [<ffffffff811995b1>] kill_anon_super+0x11/0x20
 [<ffffffffa031e3a5>] btrfs_kill_super+0x15/0x90 [btrfs]
 [<ffffffff8119a601>] ? deactivate_super+0x41/0x70
 [<ffffffff811999bd>] deactivate_locked_super+0x3d/0x70
 [<ffffffff8119a609>] deactivate_super+0x49/0x70
 [<ffffffff811b5b3c>] mntput_no_expire+0xfc/0x160
 [<ffffffff811b6af1>] sys_umount+0x71/0x3a0
 [<ffffffff81963fd2>] system_call_fastpath+0x16/0x1b
---[ end trace 0742f5dfe09cd270 ]---
VFS: Busy inodes after unmount of sds. Self-destruct in 5 seconds.  Have a nice day...


The VFS style "Have a nice day" is much more friendly than the Btrfs style "cleanup orphan" or "truncate orphan" BTW.


