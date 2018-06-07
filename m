Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37825 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932851AbeFGQPV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Jun 2018 12:15:21 -0400
Date: Thu, 7 Jun 2018 18:12:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix race between free_stale_devices and
 close_fs_devices
Message-ID: <20180607161234.GG3215@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <000000000000b9e25a056de4dd10@google.com>
 <20180606160109.10177-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180606160109.10177-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 07, 2018 at 12:01:09AM +0800, Anand Jain wrote:
> %fs_devices can be free-ed by btrfs_free_stale_devices() when the
> close_fs_devices() drops fs_devices::opened to zero, but close_fs_devices
> tries to access the %fs_devices again without the device_list_mutex.
> 
> Fix this by bringing the %fs_devices access with in the device_list_mutex.
> 
> Stack trace as below.
> 
> HEAD commit:    716a685fdb89 Merge branch 'x86-hyperv-for-linus' of git://..
> ::
> CPU: 1 PID: 4499 Comm: syz-executor921 Not tainted 4.17.0+ #84
> ::
> WARNING: CPU: 1 PID: 4499 at fs/btrfs/volumes.c:1071 close_fs_devices+0xbc7/0xfa0 fs/btrfs/volumes.c:1071
> Kernel panic - not syncing: panic_on_warn set ...
> ::
> RIP: 0010:close_fs_devices+0xbc7/0xfa0 fs/btrfs/volumes.c:1071
> ::
>  btrfs_close_devices+0x29/0x150 fs/btrfs/volumes.c:1085
>  open_ctree+0x589/0x7898 fs/btrfs/disk-io.c:3358
>  btrfs_fill_super fs/btrfs/super.c:1202 [inline]
>  btrfs_mount_root+0x16df/0x1e70 fs/btrfs/super.c:1593
>  mount_fs+0xae/0x328 fs/super.c:1277
>  vfs_kern_mount.part.34+0xd4/0x4d0 fs/namespace.c:1037
>  vfs_kern_mount+0x40/0x60 fs/namespace.c:1027
>  btrfs_mount+0x4a1/0x213e fs/btrfs/super.c:1661
>  mount_fs+0xae/0x328 fs/super.c:1277
> 
> Reported-by: syzbot+ceb2606025ec1cc3479c@syzkaller.appspotmail.com
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index c2b7d66192e8..32fba4e24027 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1153,6 +1153,12 @@ static int close_fs_devices(struct btrfs_fs_devices *fs_devices)
>  		btrfs_prepare_close_one_device(device);
>  		list_add(&device->dev_list, &pending_put);
>  	}
> +
> +	WARN_ON(fs_devices->open_devices);
> +	WARN_ON(fs_devices->rw_devices);
> +	fs_devices->opened = 0;
> +	clear_bit(BTRFS_VOLUME_STATE_SEEDING, &fs_devices->volume_state);

This is from some other patch.

Moving that to the protected section should fix it but we'd also need to
extend the critical section to:

1047         if (--fs_devices->opened > 0)
1048                 return 0;

Otherwise I think there are still some cornercases to fix as the
fs_devices members are not accessed properly everywhere. This patch
should be enough to fix the parallel mount and stale device freeing
races though, so I'll queue it up.

> +
>  	mutex_unlock(&fs_devices->device_list_mutex);
