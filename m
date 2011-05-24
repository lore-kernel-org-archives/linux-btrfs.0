From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] remove unneeded DEFINE_WAITs
Date: Tue, 24 May 2011 10:49:37 +0200
Message-ID: <4DDB7121.4020004@gmx.net>
References: <1299584050-6014-1-git-send-email-sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1299584050-6014-1-git-send-email-sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

these two are still in the integration-test tree...

-Arne

On 08.03.2011 12:34, Arne Jansen wrote:
> Signed-off-by: Arne Jansen <sensille@gmx.net>
> ---
>  fs/btrfs/extent-tree.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a7aaa10..c1f0c28 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4790,7 +4790,6 @@ wait_block_group_cache_progress(struct btrfs_block_group_cache *cache,
>  				u64 num_bytes)
>  {
>  	struct btrfs_caching_control *caching_ctl;
> -	DEFINE_WAIT(wait);
>  
>  	caching_ctl = get_caching_control(cache);
>  	if (!caching_ctl)
> @@ -4807,7 +4806,6 @@ static noinline int
>  wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
>  {
>  	struct btrfs_caching_control *caching_ctl;
> -	DEFINE_WAIT(wait);
>  
>  	caching_ctl = get_caching_control(cache);
>  	if (!caching_ctl)

