From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH] Improve error handling in filesystem df
Date: Mon, 20 Dec 2010 21:16:31 +0100
Message-ID: <201012202116.32179.kreijack@libero.it>
References: <1292797781-3877-1-git-send-email-bgamari.foss@gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: Ben Gamari <bgamari.foss@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1292797781-3877-1-git-send-email-bgamari.foss@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Ben,

I integrated your patch on the my one (see my next email). However I changed 
the argument of the strerror function from the ioctl return code to
the errno variable.

Regards
G.Baroncelli

On Sunday, 19 December, 2010, Ben Gamari wrote:
> The return values of ioctl weren't being printed to stderr on failure,
> causing the command to silently fail, resulting in a very confused
> user.
> 
> Signed-off-by: Ben Gamari <bgamari.foss@gmail.com>
> ---
>  btrfs_cmds.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
> index 8031c58..45da2bd 100644
> --- a/btrfs_cmds.c
> +++ b/btrfs_cmds.c
> @@ -857,6 +857,7 @@ int do_df_filesystem(int nargs, char **argv)
>  
>  	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
>  	if (ret) {
> +		fprintf(stderr, "ERROR: can't query '%s' for free space 
(%s)\n", path, strerror(-ret));
>  		free(sargs);
>  		return ret;
>  	}
> @@ -875,6 +876,7 @@ int do_df_filesystem(int nargs, char **argv)
>  
>  	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
>  	if (ret) {
> +		fprintf(stderr, "ERROR: can't query '%s' for free space 
(%s)\n", path, strerror(-ret));
>  		free(sargs);
>  		return ret;
>  	}
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
