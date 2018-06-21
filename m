Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43186 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932858AbeFUQGs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 12:06:48 -0400
Subject: Re: [PATCH 1/2] [v2] btrfs: use monotonic time for transaction
 handling
To: Arnd Bergmann <arnd@arndb.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>,
        Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180621160420.139575-1-arnd@arndb.de>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <8252f9b0-dcf2-a10e-3e21-aa069668c916@suse.com>
Date: Thu, 21 Jun 2018 19:06:44 +0300
MIME-Version: 1.0
In-Reply-To: <20180621160420.139575-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.06.2018 19:04, Arnd Bergmann wrote:
> The transaction times were changed to ktime_get_real_seconds to avoid
> the y2038 overflow, but they still have a minor problem when they go
> backwards or jump due to settimeofday() or leap seconds.
> 
> This changes the transaction handling to instead use ktime_get_seconds(),
> which returns a CLOCK_MONOTONIC timestamp that has neither of those
> problems.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> v2: Rebased on top of an earlier patch by Allen Pais, which
>     also obsoleted the original patch 2/3
> ---
>  fs/btrfs/disk-io.c     | 2 +-
>  fs/btrfs/transaction.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index f3224e23d5fa..bf0717f2824d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1819,7 +1819,7 @@ static int transaction_kthread(void *arg)
>  			goto sleep;
>  		}
>  
> -		now = ktime_get_real_seconds();
> +		now = ktime_get_seconds();
>  		if (cur->state < TRANS_STATE_BLOCKED &&
>  		    !test_bit(BTRFS_FS_NEED_ASYNC_COMMIT, &fs_info->flags) &&
>  		    (now < cur->start_time ||
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 56c8bab0b816..ebe50dfb8947 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -241,7 +241,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
>  	refcount_set(&cur_trans->use_count, 2);
>  	atomic_set(&cur_trans->pending_ordered, 0);
>  	cur_trans->flags = 0;
> -	cur_trans->start_time = ktime_get_real_seconds();
> +	cur_trans->start_time = ktime_get_seconds();
>  
>  	memset(&cur_trans->delayed_refs, 0, sizeof(cur_trans->delayed_refs));
>  
> 
