Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:35937 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753105AbdCFRmi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Mar 2017 12:42:38 -0500
Received: by mail-pf0-f170.google.com with SMTP id o126so15950763pfb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Mar 2017 09:42:37 -0800 (PST)
Date: Mon, 6 Mar 2017 09:41:51 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs: No need to check !(flags & MS_RDONLY) twice
Message-ID: <20170306174151.GA16893@vader.DHCP.thefacebook.com>
References: <20170304183250.32295-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170304183250.32295-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 04, 2017 at 12:32:50PM -0600, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Code cleanup.
> The code block is for !(*flags & MS_RDONLY). We don't need
> to check it again.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/btrfs/super.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index da687dc..e9ae93e 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1785,8 +1785,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>  		}
>  
>  		if (fs_info->fs_devices->missing_devices >
> -		     fs_info->num_tolerated_disk_barrier_failures &&
> -		    !(*flags & MS_RDONLY)) {
> +		     fs_info->num_tolerated_disk_barrier_failures) {
>  			btrfs_warn(fs_info,
>  				"too many missing devices, writeable remount is not allowed");
>  			ret = -EACCES;
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
