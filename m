Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59144 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750773AbdLRKG3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 05:06:29 -0500
Subject: Re: [PATCH] btrfs: Fix memory leak on multiple mounts
To: linux-btrfs@vger.kernel.org
References: <1513591426-2349-1-git-send-email-nborisov@suse.com>
Cc: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <37bc650d-a3d9-f626-7670-2550a0eb4c64@suse.com>
Date: Mon, 18 Dec 2017 12:06:27 +0200
MIME-Version: 1.0
In-Reply-To: <1513591426-2349-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 18.12.2017 12:03, Nikolay Borisov wrote:
> Currently if a mounted-btrfs instance is mounted for the 2nd time
> without first unmounting the first instance then we hit a memory leak
> in btrfs_mount_root due to the fs_info of the acquired superblock is
> different than the newly allocated fs info. Fix this by specifically
> checking if the fs_info instance of the newly acquired superblock is
> the same as ours and free it if not.
> 
> Reproducer:
> 
> mount /dev/vdc /media/scratch
> mount /dev/vdc /media/scratch2 <- memory leak hit
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

This one fixes:

4da82a9e60a1 btrfs: add btrfs_mount_root() and new file_system_type

Which seems to be in for-next only.

> ---
>  fs/btrfs/super.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index e57eb6e70278..ea3bca85be44 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1612,7 +1612,11 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>  		goto error_sec_opts;
>  	}
>  
> -	fs_info = btrfs_sb(s);
> +	if (btrfs_sb(s) != fs_info) {
> +		free_fs_info(fs_info);
> +		fs_info = btrfs_sb(s);
> +	}
> +
>  	error = setup_security_options(fs_info, s, &new_sec_opts);
>  	if (error) {
>  		deactivate_locked_super(s);
> 
