From: Jeff Liu <jeff.liu@oracle.com>
Subject: Re: [PATCH]  Btrfs: return EUCLEAN rather than ENXIO once internal
 error has occurred for SEEK_DATA/SEEK_HOLE inquiry
Date: Thu, 09 Feb 2012 12:08:47 +0800
Message-ID: <4F3346CF.3090908@oracle.com>
References: <4F334178.7030704@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Dave Chinner <david@fromorbit.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F334178.7030704@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/09/2012 11:46 AM, Jeff Liu wrote:

> By referring to http://linux.die.net/man/2/lseek, return ENXIO only
> when "offset beyond EOF" for either SEEK_DATA or SEEK_HOLE inquiry.
> But we return it in case of internal issue too if btrfs_get_extent_fiemap() failed
> due to other issues.  This will confuse the user applications to be expecting ENXIO when
> trying to find a specific data or hole location once it has occurred.
> 
> Thanks Dave for pointing that out in XFS thread.
> 
> This patch fix it to return EUCLEAN, or maybe another particular errno is more reasonable in Btrfs to indicate this fatal error?

Or maybe just return the error that was happened at internal routine, to
give user more accurate error info, which is better?

Thanks,
-Jeff

> 
> Thanks,
> -Jeff
> 
> 
> Cc: david@fromorbit.com
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> ---
>  fs/btrfs/file.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 97fbe93..6693040 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1761,7 +1761,7 @@ static int find_desired_extent(struct inode *inode, loff_t *offset, int origin)
>  						     start - root->sectorsize,
>  						     root->sectorsize, 0);
>  		if (IS_ERR(em)) {
> -			ret = -ENXIO;
> +			ret = -EUCLEAN;
>  			goto out;
>  		}
>  		last_end = em->start + em->len;
> @@ -1773,7 +1773,7 @@ static int find_desired_extent(struct inode *inode, loff_t *offset, int origin)
>  	while (1) {
>  		em = btrfs_get_extent_fiemap(inode, NULL, 0, start, len, 0);
>  		if (IS_ERR(em)) {
> -			ret = -ENXIO;
> +			ret = -EUCLEAN;
>  			break;
>  		}
>  


