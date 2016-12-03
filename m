Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:33902 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750825AbcLCSbj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Dec 2016 13:31:39 -0500
Received: by mail-pg0-f49.google.com with SMTP id x23so119935406pgx.1
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Dec 2016 10:31:39 -0800 (PST)
Date: Sat, 3 Dec 2016 10:31:37 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Pan Bian <bianpan2016@163.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: volumes: fix improper return value
Message-ID: <20161203183137.GB18526@mew>
References: <1480762905-5163-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480762905-5163-1-git-send-email-bianpan2016@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 03, 2016 at 07:01:45PM +0800, Pan Bian wrote:
> Variable ret takes the errno on failures. However, it directly returns 0.
> It may be better to return "ret".
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188741
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 71a60cc..32fd903 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4222,7 +4222,7 @@ static int btrfs_uuid_scan_kthread(void *data)
>  	else
>  		set_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags);
>  	up(&fs_info->uuid_tree_rescan_sem);
> -	return 0;
> +	return ret;

This is a kthread, no one checks the return value. We already let the
user know if it fails:

	btrfs_warn(fs_info, "btrfs_uuid_scan_kthread failed %d", ret);

>  }
>  
>  /*
> -- 
> 1.9.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
