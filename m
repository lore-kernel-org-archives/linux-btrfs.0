Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40762 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751414AbeCNU7T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 16:59:19 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DF219AC0D
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018 20:59:17 +0000 (UTC)
Date: Wed, 14 Mar 2018 21:56:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: volumes: Remove the meaningless condition of
 minimal nr_devs when allocating a chunk
Message-ID: <20180314205655.GT32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180131055615.14454-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180131055615.14454-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 31, 2018 at 01:56:15PM +0800, Qu Wenruo wrote:
> When checking the minimal nr_devs, there is one dead and meaningless
> condition:
> 
> if (ndevs < devs_increment * sub_stripes || ndevs < devs_min) {
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> This condition is meaningless, @devs_increment has nothing to do with
> @sub_stripes.
> 
> In fact, in btrfs_raid_array[], profile with sub_stripes larger than 1
> (RAID10) already has the @devs_increment set to 2.
> So no need to multiple it by @sub_stripes.
> 
> And above condition is also dead.
> For RAID10, @devs_increment * @sub_stripes equals 4, which is also the
> @devs_min of RAID10.
> For other profiles, @sub_stripes is always 1, and since @ndevs is
> rounded down to @devs_increment, the condition will always be true.
> 
> Remove the meaningless condition to make later reader wander less.

I think the condition is a leftover from times when we did not have the nice
raid table and the various values were defined in the function.

Reviewed-by: David Sterba <dsterba@suse.com>

> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 215e85e22c8e..cb0a8d27661b 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4729,7 +4729,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	/* round down to number of usable stripes */
>  	ndevs = round_down(ndevs, devs_increment);
>  
> -	if (ndevs < devs_increment * sub_stripes || ndevs < devs_min) {
> +	if (ndevs < devs_min) {

The redundant condtion is duplicated in the error message a few lines
below:

4840         if (ndevs < devs_min) {
4841                 ret = -ENOSPC;
4842                 if (btrfs_test_opt(info, ENOSPC_DEBUG)) {
4843                         btrfs_debug(info,
4844         "%s: not enough devices with free space: have=%d minimum required=%d",
4845                                     __func__, ndevs, min(devs_min,
4846                                     devs_increment * sub_stripes));
                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

so I'll remove it as well.

4847                 }
4848                 goto error;
4849         }
>  		ret = -ENOSPC;
>  		goto error;
>  	}
