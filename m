Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:17753 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462AbaKKVwh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 16:52:37 -0500
Date: Wed, 12 Nov 2014 08:52:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] mm: check memory reclaim bugs caused fs reentrance
Message-ID: <20141111215207.GW23575@dastard>
References: <1415706590-24159-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415706590-24159-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 11, 2014 at 03:49:50PM +0400, Dmitry Monakhov wrote:
> If filesystem holds transaction open 'current->journal_info' it should not
> performs memory allocations with __GFP_FS flag enabled otherwise this result in fs
> reentarance which lead to:
> 1) reentrance to itself : deadlock or internal assertion failure due to incorrect journal credits
> 1) entrance to another fs: assertion faulure or silient corruption due to incorrect journal
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  include/linux/kernel.h |    7 +++++++
>  mm/dmapool.c           |    1 +
>  mm/mempool.c           |    1 +
>  mm/page_alloc.c        |    1 +
>  mm/slab.c              |    1 +
>  mm/slub.c              |    1 +
>  6 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 3d770f5..69923d4 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -232,6 +232,13 @@ void might_fault(void);
>  static inline void might_fault(void) { }
>  #endif
>  
> +#ifdef CONFIG_PROVE_LOCKING
> +#define might_enter_fs_if(cond) \
> +	 WARN_ON_ONCE((cond) && current->journal_info)

XFS does not use current->journal_info, and so this won't ever
trigger on XFS. XFS uses PF_FSTRANS to indicate a transaction is in
progress.

Besides, isn't this redundant functionality? Lockdep already catches
these problems with it's reclaim context tracking and it's tracking
is more extensive than this simple check like this.  lockdep
regularly pointed out allocation/reclaim context problems in XFS
until we fixed them....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
