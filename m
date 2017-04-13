Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752233AbdDMS5d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Apr 2017 14:57:33 -0400
Date: Thu, 13 Apr 2017 20:57:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Subject: Re: [PATCH v5 1/2] btrfs: scrub: Introduce full stripe lock for
 RAID56
Message-ID: <20170413185728.GP4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170403021347.4958-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170403021347.4958-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 03, 2017 at 10:13:46AM +0800, Qu Wenruo wrote:
> Unlike mirror based profiles, RAID5/6 recovery needs to read out the
> whole full stripe.
> 
> And if we don't do proper protect, it can easily cause race condition.
> 
> Introduce 2 new functions: lock_full_stripe() and unlock_full_stripe()
> for RAID5/6.
> Which stores a rb_tree of mutex for full stripes, so scrub callers can
> use them to lock a full stripe to avoid race.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Overall looks good to me now. A few comments below.

> +/*
> + * Unlock a full stripe.
> + * NOTE: Caller must ensure it's the same context calling corresponding
> + * lock_full_stripe().
> + *
> + * Return 0 if we unlock full stripe without problem.
> + * Return <0 for error
> + */
> +static int unlock_full_stripe(struct btrfs_fs_info *fs_info, u64 bytenr,
> +			      bool locked)
> +{
> +	struct btrfs_block_group_cache *bg_cache;
> +	struct btrfs_full_stripe_locks_tree *locks_root;
> +	struct full_stripe_lock *fstripe_lock;
> +	u64 fstripe_start;
> +	bool freeit = false;
> +	int ret = 0;
> +
> +	/* If we didn't acquire full stripe lock, no need to continue */
> +	if (!locked)
> +		return 0;
> +
> +	bg_cache = btrfs_lookup_block_group(fs_info, bytenr);
> +	if (!bg_cache) {
> +		ASSERT(0);

Well, ok. As mentioned in other mails, the asserts will need a
systematic change all over the codebase.

> +		return -ENOENT;
> +	}
> +	if (!(bg_cache->flags & BTRFS_BLOCK_GROUP_RAID56_MASK))
> +		goto out;
> +
> +	locks_root = &bg_cache->full_stripe_locks_root;
> +	fstripe_start = get_full_stripe_logical(bg_cache, bytenr);
> +	if (ret < 0)
> +		goto out;

This 'if' is a no-op, as ret is not modified since initialization.

> +
> +	mutex_lock(&locks_root->lock);
> +	fstripe_lock = search_full_stripe_lock(locks_root, fstripe_start);
> +	/* Unpaired unlock_full_stripe() detected */
> +	if (!fstripe_lock) {
> +		WARN_ON(1);
> +		ret = -ENOENT;
> +		mutex_unlock(&locks_root->lock);
> +		goto out;
> +	}
> +
> +	if (fstripe_lock->refs == 0) {
> +		WARN_ON(1);
> +		btrfs_warn(fs_info, "full stripe lock at %llu refcount underflow",
> +			fstripe_lock->logical);
> +	} else {
> +		fstripe_lock->refs--;
> +	}
> +
> +	if (fstripe_lock->refs == 0) {
> +		rb_erase(&fstripe_lock->node, &locks_root->root);
> +		freeit = true;
> +	}
> +	mutex_unlock(&locks_root->lock);
> +
> +	mutex_unlock(&fstripe_lock->mutex);
> +	if (freeit)
> +		kfree(fstripe_lock);
> +out:
> +	btrfs_put_block_group(bg_cache);
> +	return ret;
> +}
> +
> +/*
>   * used for workers that require transaction commits (i.e., for the
>   * NOCOW case)
>   */
