Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35309 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752882AbeBTRHI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Feb 2018 12:07:08 -0500
Date: Tue, 20 Feb 2018 18:04:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix NPD during canceling replace when the target
 is missing
Message-ID: <20180220170448.GP10193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180220144809.9142-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180220144809.9142-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 20, 2018 at 10:48:09PM +0800, Anand Jain wrote:
> Replace target can be missing after a reboot during the replace.
> So check if device is null.
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000000000b0
> IP: btrfs_destroy_dev_replace_tgtdev+0x43/0xf0 [btrfs]
> Call Trace:
> btrfs_dev_replace_cancel+0x22b/0x250 [btrfs]
> btrfs_ioctl+0x2216/0x2590 [btrfs]
> ? do_vfs_ioctl+0x625/0x650
> do_vfs_ioctl+0x625/0x650
> ? security_file_ioctl+0x30/0x50
> SyS_ioctl+0x4e/0x80
> do_syscall_64+0x5d/0x160
> entry_SYSCALL64_slow_path+0x25/0x25
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/dev-replace.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 87f975143c05..476981c2cf55 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -749,7 +749,8 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
>  		   btrfs_dev_name(src_device), src_device->devid,
>  		   btrfs_dev_name(tgt_device));
>  
> -	btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
> +	if (tgt_device)
> +		btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);

I'll just discard the patch you sent a week ago that removes the 'if' in
the first place.

https://patchwork.kernel.org/patch/10215103/
