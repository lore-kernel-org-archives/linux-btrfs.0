Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44969 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752166AbeAaHfR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 02:35:17 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BE55BAC64
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 07:35:15 +0000 (UTC)
Subject: Re: [PATCH] btrfs: volumes: Remove the meaningless condition of
 minimal nr_devs when allocating a chunk
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180131055615.14454-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <786c6ed0-0764-96cf-c494-78b40979f70d@suse.com>
Date: Wed, 31 Jan 2018 09:35:13 +0200
MIME-Version: 1.0
In-Reply-To: <20180131055615.14454-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 31.01.2018 07:56, Qu Wenruo wrote:
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
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Quick question : What exactly is a substripe? Stripe is essentially how
many contiguous portions of disk are necessary to satisfy the profile,
right? So for raid1 we write 1 copy of the data per device (hence
dev_stripes = 1). For DUP we have 2 copies of the data on the same disk
hence dev_stripes 2. How does sub_stripes fit in the grand scheme of things?
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
>  		ret = -ENOSPC;
>  		goto error;
>  	}
> 
