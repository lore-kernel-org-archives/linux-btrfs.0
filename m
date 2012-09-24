Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:45955 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756754Ab2IXSSr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 14:18:47 -0400
Message-ID: <5060A428.80302@gmx.net>
Date: Mon, 24 Sep 2012 20:19:20 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not async metadata csums if we have hardware
 crc32c
References: <1348510264-5781-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1348510264-5781-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/24/12 20:11, Josef Bacik wrote:
> The reason we offload csumming is because it is CPU intensive, except it is
> not on modern intel CPUs.  So check to see if we support hardware crc32c,
> and if we do just do the csumming in our current threads context.  Otherwise
> we can farm it off.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/disk-io.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index dcaf556..830b9af 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -31,6 +31,7 @@
>  #include <linux/migrate.h>
>  #include <linux/ratelimit.h>
>  #include <asm/unaligned.h>
> +#include <asm/cpufeature.h>
>  #include "compat.h"
>  #include "ctree.h"
>  #include "disk-io.h"
> @@ -880,6 +881,22 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
>  	}
>  
>  	/*
> +	 * Pretty sure I'm going to hell for this.  If our CPU can do crc32cs in
> +	 * the hardware then there is no reason to do the csum stuff
> +	 * asynchronously, it will be faster to do it inline, so test to see if
> +	 * our CPU can do hardware crc32c and if it can just do the csum in our
> +	 * threads context.
> +	 */
> +#ifdef CONFIG_X86
> +	if (cpu_has_xmm4_2) {
> +		printk(KERN_ERR "doing it the fast way\n");

You'll probably go to hell for the printk...

> +		ret = btree_csum_one_bio(bio);
> +		if (ret)
> +			return ret;
> +		return btrfs_map_bio(BTRFS_I(inode)->root, rw, bio, mirror_num, 0);
> +	}
> +#endif
> +	/*
>  	 * kthread helpers are used to submit writes so that checksumming
>  	 * can happen in parallel across all CPUs
>  	 */
> 

