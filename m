From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Fix minor type issues
Date: Wed, 25 Apr 2012 13:11:22 -0400
Message-ID: <20120425171122.GB17006@localhost.localdomain>
References: <1335371834-28943-1-git-send-email-daniel@quora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1335371834-28943-1-git-send-email-daniel@quora.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2012 at 12:37:14AM +0800, Daniel J Blueman wrote:
> Address some minor type issues identified by sparse checker.
> 
> Signed-off-by: Daniel J Blueman <daniel@quora.org>
> ---
>  fs/btrfs/ioctl.c |    2 +-
>  fs/btrfs/ulist.c |    4 ++--
>  fs/btrfs/ulist.h |    5 ++---
>  3 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 18cc23d..b410879 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2911,7 +2911,7 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
>  		up_read(&info->groups_sem);
>  	}
>  
> -	user_dest = (struct btrfs_ioctl_space_info *)
> +	user_dest = (struct btrfs_ioctl_space_info __user *)
>  		(arg + sizeof(struct btrfs_ioctl_space_args));
>  
>  	if (copy_to_user(user_dest, dest_orig, alloc_size))
> diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
> index 12f5147..ad993bc 100644
> --- a/fs/btrfs/ulist.c
> +++ b/fs/btrfs/ulist.c
> @@ -95,7 +95,7 @@ EXPORT_SYMBOL(ulist_reinit);
>   *
>   * The allocated ulist will be returned in an initialized state.
>   */
> -struct ulist *ulist_alloc(unsigned long gfp_mask)
> +struct ulist *ulist_alloc(gfp_t gfp_mask)
>  {
>  	struct ulist *ulist = kmalloc(sizeof(*ulist), gfp_mask);
>  
> @@ -144,7 +144,7 @@ EXPORT_SYMBOL(ulist_free);
>   * unaltered.
>   */
>  int ulist_add(struct ulist *ulist, u64 val, unsigned long aux,
> -	      unsigned long gfp_mask)
> +	      gfp_t gfp_mask)
>  {
>  	int i;
>  
> diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
> index 2e25dec..6568c35 100644
> --- a/fs/btrfs/ulist.h
> +++ b/fs/btrfs/ulist.h
> @@ -59,10 +59,9 @@ struct ulist {
>  void ulist_init(struct ulist *ulist);
>  void ulist_fini(struct ulist *ulist);
>  void ulist_reinit(struct ulist *ulist);
> -struct ulist *ulist_alloc(unsigned long gfp_mask);
> +struct ulist *ulist_alloc(gfp_t gfp_mask);
>  void ulist_free(struct ulist *ulist);
> -int ulist_add(struct ulist *ulist, u64 val, unsigned long aux,
> -	      unsigned long gfp_mask);
> +int ulist_add(struct ulist *ulist, u64 val, unsigned long aux, gfp_t gfp_mask);
>  struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_node *prev);
>  
>  #endif
> -- 
> 1.7.9.5
> 

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
