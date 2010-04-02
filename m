From: Tao Ma <tao.ma@oracle.com>
Subject: Re: [PATCH] Btrfs-progs: fix incompat flags
Date: Fri, 02 Apr 2010 14:10:53 +0800
Message-ID: <4BB58A6D.7030505@oracle.com>
References: <20100401191744.GC21486@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100401191744.GC21486@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

Josef Bacik wrote:
> I forgot to add BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL to the incompat flags in
> btrfs-progs.  This adds it so that our tools don't freak out when touching a fs
> with the default subvolume changed.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  ctree.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/ctree.h b/ctree.h
> index 64ecf12..b79e238 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -350,11 +350,13 @@ struct btrfs_super_block {
>   * ones specified below then we will fail to mount
>   */
>  #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
> +#define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(2ULL << 0)
I am not familiar with btrfs, but I guess the natural way is
+#define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1) ?
>  
>  #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
>  #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
>  #define BTRFS_FEATURE_INCOMPAT_SUPP		\
> -	BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF
> +	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |	\
> +	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL)
>  
>  /*
>   * A leaf is full of items. offset and size tell us where to find

Regards,
Tao
