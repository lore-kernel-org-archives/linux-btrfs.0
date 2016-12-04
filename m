Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:34085 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbcLDT5P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Dec 2016 14:57:15 -0500
Received: by mail-pg0-f43.google.com with SMTP id x23so128301910pgx.1
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Dec 2016 11:57:15 -0800 (PST)
Date: Sun, 4 Dec 2016 11:57:07 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Pan Bian <bianpan2016@163.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: fix improper return value
Message-ID: <20161204195707.GA21783@vader>
References: <1480827113-3928-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480827113-3928-1-git-send-email-bianpan2016@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 04, 2016 at 12:51:53PM +0800, Pan Bian wrote:
> In function btrfs_uuid_tree_iterate(), errno is assigned to variable ret
> on errors. However, it directly returns 0. It may be better to return
> ret. This patch also removes the warning, because the caller already
> prints a warning.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188731

Looks good.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  fs/btrfs/uuid-tree.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
> index 7fc89e4..83bb2f2 100644
> --- a/fs/btrfs/uuid-tree.c
> +++ b/fs/btrfs/uuid-tree.c
> @@ -351,7 +351,5 @@ int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info,
>  
>  out:
>  	btrfs_free_path(path);
> -	if (ret)
> -		btrfs_warn(fs_info, "btrfs_uuid_tree_iterate failed %d", ret);
> -	return 0;
> +	return ret;
>  }
> -- 
> 1.9.1
> 
> 
