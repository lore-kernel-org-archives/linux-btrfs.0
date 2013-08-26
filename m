Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab3HZVVI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 17:21:08 -0400
Message-ID: <521BC6C0.9070305@redhat.com>
Date: Mon, 26 Aug 2013 16:21:04 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add support for asserts
References: <1377550566-10941-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1377550566-10941-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/26/13 3:56 PM, Josef Bacik wrote:
> One of the complaints we get a lot is how many BUG_ON()'s we have.  So to help
> with this I'm introducing a kconfig option to enable/disable a new ASSERT()
> mechanism much like what XFS does.  This will allow us developers to still get
> our nice panics but allow users/distros to compile them out.  With this we can
> go through and convert any BUG_ON()'s that we have to catch actual programming
> mistakes to the new ASSERT() and then fix everybody else to return errors.  This
> will also allow developers to leave sanity checks in their new code to make sure
> we don't trip over problems while testing stuff and vetting new features.
> Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

+1000 for inheriting the wildly popular XFS assfail() technology. ;)

I think this is a step in the right direction, it'll make it easier to
clearly mark things which are logic assertions vs. things which are just punts
in more common error-handling paths.

Acked-by: Eric Sandeen <sandeen@redhat.com>

Thanks,

-Eric

> ---
>  fs/btrfs/Kconfig |    9 +++++++++
>  fs/btrfs/ctree.h |   16 ++++++++++++++++
>  2 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
> index 2b3b832..398cbd5 100644
> --- a/fs/btrfs/Kconfig
> +++ b/fs/btrfs/Kconfig
> @@ -72,3 +72,12 @@ config BTRFS_DEBUG
>  	  performance, or export extra information via sysfs.
>  
>  	  If unsure, say N.
> +
> +config BTRFS_ASSERT
> +	bool "Btrfs assert support"
> +	depends on BTRFS_FS
> +	help
> +	  Enable run-time assertion checking.  This will result in panics if
> +	  any of the assertions trip.  This is meant for btrfs developers only.
> +
> +	  If unsure, say N.
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index c90be01..8278a3f 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3814,6 +3814,22 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
>  #define btrfs_debug(fs_info, fmt, args...) \
>  	btrfs_printk(fs_info, KERN_DEBUG fmt, ##args)
>  
> +#ifdef BTRFS_ASSERT
> +
> +static inline void assfail(char *expr, char *file, int lin)
> +{
> +	printk(KERN_ERR "BTRFS assertion failed: %s, file: %s, line: %d",
> +	       expr, file, line);
> +	BUG();
> +}
> +
> +#define ASSERT(expr)	\
> +	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
> +#else
> +#define ASSERT(expr)	((void)0)
> +#endif
> +
> +#define btrfs_assert()
>  __printf(5, 6)
>  void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
>  		     unsigned int line, int errno, const char *fmt, ...);
> 

