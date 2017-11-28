Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752227AbdK1P7I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 10:59:08 -0500
Date: Tue, 28 Nov 2017 16:57:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 2/3] btrfs-progs: fi defrag: do not exit if defrag
 range ioctl is unsupported
Message-ID: <20171128155710.GU3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
 <20171128091450.21789-2-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171128091450.21789-2-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 28, 2017 at 05:14:49PM +0800, Su Yue wrote:
> If ioctl of defrag range is unsupported, defrag will exit
> immediately.
> 
> Since caller can handle the error, let cmd_filesystem_defrag()
> break the loop and return error instead of calling exit(1).
> 
> Suggested-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
> Changelog:
> v2:	Separate the patch from commit 6e991b9161fa ("btrfs-progs: fi
> 	defrag: clean up duplicate code if find errors").
> ---
>  cmds-filesystem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 17d399d58adf..3931333f76c6 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -1050,7 +1050,7 @@ static int cmd_filesystem_defrag(int argc, char **argv)
>  			ret = nftw(argv[i], defrag_callback, 10,
>  						FTW_MOUNT | FTW_PHYS);
>  			if (ret == ENOTTY)
> -				exit(1);
> +				break;

And we still need to call close_file_or_dir.

>  			/* errors are handled in the callback */
>  			ret = 0;
>  		} else {
> -- 
> 2.15.0
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
