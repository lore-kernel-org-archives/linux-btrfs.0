Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:54109 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1432403AbdDYSGs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 14:06:48 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH v6 2/2] btrfs: scrub: Fix RAID56 recovery race condition
References: <20170414003555.4319-1-quwenruo@cn.fujitsu.com>
 <20170414003555.4319-2-quwenruo@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <5fada4b9-4b77-e262-f29e-543ae714cda7@inwind.it>
Date: Tue, 25 Apr 2017 19:58:32 +0200
MIME-Version: 1.0
In-Reply-To: <20170414003555.4319-2-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I Qu,

I tested these two patches on top of 4.10.12; however when I corrupt disk1, It seems that BTRFS is still unable to rebuild parity.

Because in the past the patches set V4 was composed by 5 patches and this one (V5) is composed by only 2 patches, are these 2 sufficient to solve all known bugs of raid56 ? Or I have to cherry pick other two ones ?

BR
G.Baroncelli

On 2017-04-14 02:35, Qu Wenruo wrote:
> When scrubbing a RAID5 which has recoverable data corruption (only one
> data stripe is corrupted), sometimes scrub will report more csum errors
> than expected. Sometimes even unrecoverable error will be reported.
> 
> The problem can be easily reproduced by the following steps:
> 1) Create a btrfs with RAID5 data profile with 3 devs
> 2) Mount it with nospace_cache or space_cache=v2
>    To avoid extra data space usage.
> 3) Create a 128K file and sync the fs, unmount it
>    Now the 128K file lies at the beginning of the data chunk
> 4) Locate the physical bytenr of data chunk on dev3
>    Dev3 is the 1st data stripe.
> 5) Corrupt the first 64K of the data chunk stripe on dev3
> 6) Mount the fs and scrub it
> 
> The correct csum error number should be 16(assuming using x86_64).
> Larger csum error number can be reported in a 1/3 chance.
> And unrecoverable error can also be reported in a 1/10 chance.
> 
> The root cause of the problem is RAID5/6 recover code has race
> condition, due to the fact that full scrub is initiated per device.
> 
> While for other mirror based profiles, each mirror is independent with
> each other, so race won't cause any big problem.
> 
> For example:
>         Corrupted       |       Correct          |      Correct        |
> |   Scrub dev3 (D1)     |    Scrub dev2 (D2)     |    Scrub dev1(P)    |
> ------------------------------------------------------------------------
> Read out D1             |Read out D2             |Read full stripe     |
> Check csum              |Check csum              |Check parity         |
> Csum mismatch           |Csum match, continue    |Parity mismatch      |
> handle_errored_block    |                        |handle_errored_block |
>  Read out full stripe   |                        | Read out full stripe|
>  D1 csum error(err++)   |                        | D1 csum error(err++)|
>  Recover D1             |                        | Recover D1          |
> 
> So D1's csum error is accounted twice, just because
> handle_errored_block() doesn't have enough protect, and race can happen.
> 
> On even worse case, for example D1's recovery code is re-writing
> D1/D2/P, and P's recovery code is just reading out full stripe, then we
> can cause unrecoverable error.
> 
> This patch will use previously introduced lock_full_stripe() and
> unlock_full_stripe() to protect the whole scrub_handle_errored_block()
> function for RAID56 recovery.
> So no extra csum error nor unrecoverable error.
> 
> Reported-by: Goffredo Baroncelli <kreijack@libero.it>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/scrub.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 980deb8aae47..7d8ce57fd08a 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -1113,6 +1113,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>  	int mirror_index;
>  	int page_num;
>  	int success;
> +	bool full_stripe_locked;
>  	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
>  				      DEFAULT_RATELIMIT_BURST);
>  
> @@ -1138,6 +1139,24 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>  	have_csum = sblock_to_check->pagev[0]->have_csum;
>  	dev = sblock_to_check->pagev[0]->dev;
>  
> +	/*
> +	 * For RAID5/6 race can happen for different dev scrub thread.
> +	 * For data corruption, Parity and Data thread will both try
> +	 * to recovery the data.
> +	 * Race can lead to double added csum error, or even unrecoverable
> +	 * error.
> +	 */
> +	ret = lock_full_stripe(fs_info, logical, &full_stripe_locked);
> +	if (ret < 0) {
> +		spin_lock(&sctx->stat_lock);
> +		if (ret == -ENOMEM)
> +			sctx->stat.malloc_errors++;
> +		sctx->stat.read_errors++;
> +		sctx->stat.uncorrectable_errors++;
> +		spin_unlock(&sctx->stat_lock);
> +		return ret;
> +	}
> +
>  	if (sctx->is_dev_replace && !is_metadata && !have_csum) {
>  		sblocks_for_recheck = NULL;
>  		goto nodatasum_case;
> @@ -1472,6 +1491,9 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>  		kfree(sblocks_for_recheck);
>  	}
>  
> +	ret = unlock_full_stripe(fs_info, logical, full_stripe_locked);
> +	if (ret < 0)
> +		return ret;
>  	return 0;
>  }
>  
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
