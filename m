Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab3HZVx3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 17:53:29 -0400
Date: Mon, 26 Aug 2013 14:53:26 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add support for asserts
Message-ID: <20130826215326.GH26818@lenny.home.zabbo.net>
References: <1377550566-10941-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377550566-10941-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> With this we can
> go through and convert any BUG_ON()'s that we have to catch actual programming
> mistakes to the new ASSERT() and then fix everybody else to return errors.

I like the sound of that!

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

I'm not sure why this is needed.

> +#define ASSERT(expr)	\
> +	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))

(Passing the assertion is unlikely()?  I know, this is from xfs...
still.)

> +#else
> +#define ASSERT(expr)	((void)0)
> +#endif

Anyway, if you're going to do it this way, why not:

	#ifdef BTRFS_ASSERT
	#define btrfs_assert(cond)  BUG_ON(!(cond))
	#else
	#define btrfs_assert(cond)  do { if (cond) ; } while (0)
	#endif

?

- z
