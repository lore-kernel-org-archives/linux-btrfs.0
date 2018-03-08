Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54353 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751355AbeCHMaR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Mar 2018 07:30:17 -0500
Received: by mail-wm0-f66.google.com with SMTP id z81so10929744wmb.4
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Mar 2018 04:30:17 -0800 (PST)
Subject: Re: [PATCH 1/2] btrfs: introduce conditional wakeup helpers
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1520509627.git.dsterba@suse.com>
 <96b9c7113ac06d981c3f69638762c4502651f6af.1520509627.git.dsterba@suse.com>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <f92b1fbf-cec1-2e8c-a032-560bc7888730@gmail.com>
Date: Thu, 8 Mar 2018 14:30:14 +0200
MIME-Version: 1.0
In-Reply-To: <96b9c7113ac06d981c3f69638762c4502651f6af.1520509627.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  8.03.2018 13:49, David Sterba wrote:
> Add convenience wrappers for the waitqueue management that involves
> memory barriers to prevent deadlocks. The helpers will let us remove
> barriers and the necessary comments in several places.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/ctree.h | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index bf545e7552b8..c9827a1b676d 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3748,4 +3748,27 @@ static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
>  #endif
>  	return 0;
>  }
> +
> +static inline void cond_wake_up(struct wait_queue_head *wq)
> +{
> +	/*
> +	 * This implies a full smp_mb barrier, see comments for
> +	 * waitqueue_active why.
> +	 */
> +	if (wq_has_sleeper(wq))
> +		wake_up(wq);
> +}
> +
> +static inline void cond_wake_up_nomb(struct wait_queue_head *wq)
> +{
> +	/*
> +	 * Special case for conditional wakeup where the barrier required for
> +	 * waitqueue_active is implied by some of the preceding code. Eg. one
> +	 * of such atomic operations (atomic_dec_and_return, ...), or a
> +	 * unlock/lock sequence, etc.
> +	 */
> +	if (waitqueue_active(wq))
> +		wake_up(wq);
> +}
> +
>  #endif
> 
