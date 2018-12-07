Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A31C07E85
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 14:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F1E820882
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 14:45:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F1E820882
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbeLGOpn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Dec 2018 09:45:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:50618 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725998AbeLGOpm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Dec 2018 09:45:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 93843AD77;
        Fri,  7 Dec 2018 14:45:39 +0000 (UTC)
Subject: Re: [PATCH 05/10] btrfs: introduce delayed_refs_rsv
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
References: <20181203152038.21388-1-josef@toxicpanda.com>
 <20181203152038.21388-6-josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <b9d58b65-cccd-4e66-ae1c-15847f947a62@suse.com>
Date:   Fri, 7 Dec 2018 16:45:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181203152038.21388-6-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3.12.18 г. 17:20 ч., Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Traditionally we've had voodoo in btrfs to account for the space that
> delayed refs may take up by having a global_block_rsv.  This works most
> of the time, except when it doesn't.  We've had issues reported and seen
> in production where sometimes the global reserve is exhausted during
> transaction commit before we can run all of our delayed refs, resulting
> in an aborted transaction.  Because of this voodoo we have equally
> dubious flushing semantics around throttling delayed refs which we often
> get wrong.
> 
> So instead give them their own block_rsv.  This way we can always know
> exactly how much outstanding space we need for delayed refs.  This
> allows us to make sure we are constantly filling that reservation up
> with space, and allows us to put more precise pressure on the enospc
> system.  Instead of doing math to see if its a good time to throttle,
> the normal enospc code will be invoked if we have a lot of delayed refs
> pending, and they will be run via the normal flushing mechanism.
> 
> For now the delayed_refs_rsv will hold the reservations for the delayed
> refs, the block group updates, and deleting csums.  We could have a
> separate rsv for the block group updates, but the csum deletion stuff is
> still handled via the delayed_refs so that will stay there.


I see one difference in the way that the space is managed. Essentially
for delayed refs rsv you'll only ever be increasaing the size and
->reserved only when you have to refill. This is opposite to the way
other metadata space is managed i.e by using use_block_rsv which
subtracts ->reserved everytime a block has to be CoW'ed. Why this
difference?


> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/ctree.h       |  14 +++-
>  fs/btrfs/delayed-ref.c |  43 ++++++++--
>  fs/btrfs/disk-io.c     |   4 +
>  fs/btrfs/extent-tree.c | 212 +++++++++++++++++++++++++++++++++++++++++++++----
>  fs/btrfs/transaction.c |  37 ++++++++-
>  5 files changed, 284 insertions(+), 26 deletions(-)
> 

<snip>

> +/**
> + * btrfs_migrate_to_delayed_refs_rsv - transfer bytes to our delayed refs rsv.
> + * @fs_info - the fs info for our fs.
> + * @src - the source block rsv to transfer from.
> + * @num_bytes - the number of bytes to transfer.
> + *
> + * This transfers up to the num_bytes amount from the src rsv to the
> + * delayed_refs_rsv.  Any extra bytes are returned to the space info.
> + */
> +void btrfs_migrate_to_delayed_refs_rsv(struct btrfs_fs_info *fs_info,
> +				       struct btrfs_block_rsv *src,
> +				       u64 num_bytes)

This function is currently used only during transaction start, it seems
to be rather specific to the delayed refs so I'd suggest making it
private to transaction.c

> +{
> +	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
> +	u64 to_free = 0;
> +
> +	spin_lock(&src->lock);
> +	src->reserved -= num_bytes;
> +	src->size -= num_bytes;
> +	spin_unlock(&src->lock);
> +
> +	spin_lock(&delayed_refs_rsv->lock);
> +	if (delayed_refs_rsv->size > delayed_refs_rsv->reserved) {
> +		u64 delta = delayed_refs_rsv->size -
> +			delayed_refs_rsv->reserved;
> +		if (num_bytes > delta) {
> +			to_free = num_bytes - delta;
> +			num_bytes = delta;
> +		}
> +	} else {
> +		to_free = num_bytes;
> +		num_bytes = 0;
> +	}
> +
> +	if (num_bytes)
> +		delayed_refs_rsv->reserved += num_bytes;
> +	if (delayed_refs_rsv->reserved >= delayed_refs_rsv->size)
> +		delayed_refs_rsv->full = 1;
> +	spin_unlock(&delayed_refs_rsv->lock);
> +
> +	if (num_bytes)
> +		trace_btrfs_space_reservation(fs_info, "delayed_refs_rsv",
> +					      0, num_bytes, 1);
> +	if (to_free)
> +		space_info_add_old_bytes(fs_info, delayed_refs_rsv->space_info,
> +					 to_free);
> +}
> +
> +/**
> + * btrfs_delayed_refs_rsv_refill - refill based on our delayed refs usage.
> + * @fs_info - the fs_info for our fs.
> + * @flush - control how we can flush for this reservation.
> + *
> + * This will refill the delayed block_rsv up to 1 items size worth of space and
> + * will return -ENOSPC if we can't make the reservation.
> + */
> +int btrfs_delayed_refs_rsv_refill(struct btrfs_fs_info *fs_info,
> +				  enum btrfs_reserve_flush_enum flush)
> +{
> +	struct btrfs_block_rsv *block_rsv = &fs_info->delayed_refs_rsv;
> +	u64 limit = btrfs_calc_trans_metadata_size(fs_info, 1);
> +	u64 num_bytes = 0;
> +	int ret = -ENOSPC;
> +
> +	spin_lock(&block_rsv->lock);
> +	if (block_rsv->reserved < block_rsv->size) {
> +		num_bytes = block_rsv->size - block_rsv->reserved;
> +		num_bytes = min(num_bytes, limit);
> +	}
> +	spin_unlock(&block_rsv->lock);
> +
> +	if (!num_bytes)
> +		return 0;
> +
> +	ret = reserve_metadata_bytes(fs_info->extent_root, block_rsv,
> +				     num_bytes, flush);
> +	if (ret)
> +		return ret;
> +	block_rsv_add_bytes(block_rsv, num_bytes, 0);
> +	trace_btrfs_space_reservation(fs_info, "delayed_refs_rsv",
> +				      0, num_bytes, 1);
> +	return 0;
> +}

This is also called from a single place in transaction.c so can be made
static.

> +
> +
>  /*
>   * This is for space we already have accounted in space_info->bytes_may_use, so
>   * basically when we're returning space from block_rsv's.
> @@ -5709,6 +5809,31 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
>  	return ret;
>  }
>  
> +static u64 __btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
> +				     struct btrfs_block_rsv *block_rsv,
> +				     u64 num_bytes, u64 *qgroup_to_release)
> +{
> +	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
> +	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_refs_rsv;
> +	struct btrfs_block_rsv *target = delayed_rsv;
> +
> +	if (target->full || target == block_rsv)
> +		target = global_rsv;
> +
> +	if (block_rsv->space_info != target->space_info)
> +		target = NULL;
> +
> +	return block_rsv_release_bytes(fs_info, block_rsv, target, num_bytes,
> +				       qgroup_to_release);
> +}
> +
> +void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
> +			     struct btrfs_block_rsv *block_rsv,
> +			     u64 num_bytes)
> +{
> +	__btrfs_block_rsv_release(fs_info, block_rsv, num_bytes, NULL);
> +}

Again, I think the changelog should mention that one of the major
changes to behavior you do is essentially prioritize delayed refs
refilling over global rsv refilling by "hijacking" all block group
releases to go through __btrfs_block_rsv_release

> +
>  /**
>   * btrfs_inode_rsv_release - release any excessive reservation.
>   * @inode - the inode we need to release from.
> @@ -5723,7 +5848,6 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
>  static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
>  {
>  	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> -	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
>  	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
>  	u64 released = 0;
>  	u64 qgroup_to_release = 0;
> @@ -5733,8 +5857,8 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
>  	 * are releasing 0 bytes, and then we'll just get the reservation over
>  	 * the size free'd.
>  	 */
> -	released = block_rsv_release_bytes(fs_info, block_rsv, global_rsv, 0,
> -					   &qgroup_to_release);
> +	released = __btrfs_block_rsv_release(fs_info, block_rsv, 0,
> +					     &qgroup_to_release);

This change requires a bit more explanation. Now when releasing the
bytes for an inode we execute the additional logic in
__btrfs_block_rsv_release to decide if we need to refill the globalrsv
or delayed refs rsf based on whether delayed refs rsv is full or not.
Before global rsv will be refilled by whatever is the excess amount and
right now if delayed refs rsv is not full delayed refs rsv will be
refilled.

>  	if (released > 0)
>  		trace_btrfs_space_reservation(fs_info, "delalloc",
>  					      btrfs_ino(inode), released, 0);
> @@ -5745,16 +5869,26 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
>  						   qgroup_to_release);
>  }
>  
> -void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
> -			     struct btrfs_block_rsv *block_rsv,
> -			     u64 num_bytes)
> +/**
> + * btrfs_delayed_refs_rsv_release - release a ref head's reservation.
> + * @fs_info - the fs_info for our fs.
> + * @nr - the number of items to drop.
> + *
> + * This drops the delayed ref head's count from the delayed refs rsv and free's
> + * any excess reservation we had.
> + */
> +void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int nr)
>  {
> +	struct btrfs_block_rsv *block_rsv = &fs_info->delayed_refs_rsv;
>  	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
> +	u64 num_bytes = btrfs_calc_trans_metadata_size(fs_info, nr);
> +	u64 released = 0;
>  
> -	if (global_rsv == block_rsv ||
> -	    block_rsv->space_info != global_rsv->space_info)
> -		global_rsv = NULL;
> -	block_rsv_release_bytes(fs_info, block_rsv, global_rsv, num_bytes, NULL);
> +	released = block_rsv_release_bytes(fs_info, block_rsv, global_rsv,
> +					   num_bytes, NULL);
> +	if (released)
> +		trace_btrfs_space_reservation(fs_info, "delayed_refs_rsv",
> +					      0, released, 0);
>  }
>  
>  static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
> @@ -5819,9 +5953,10 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
>  	fs_info->trans_block_rsv.space_info = space_info;
>  	fs_info->empty_block_rsv.space_info = space_info;
>  	fs_info->delayed_block_rsv.space_info = space_info;
> +	fs_info->delayed_refs_rsv.space_info = space_info;
>  
> -	fs_info->extent_root->block_rsv = &fs_info->global_block_rsv;
> -	fs_info->csum_root->block_rsv = &fs_info->global_block_rsv;
> +	fs_info->extent_root->block_rsv = &fs_info->delayed_refs_rsv;
> +	fs_info->csum_root->block_rsv = &fs_info->delayed_refs_rsv;

nit: Some whitespace damage

>  	fs_info->dev_root->block_rsv = &fs_info->global_block_rsv;
>  	fs_info->tree_root->block_rsv = &fs_info->global_block_rsv;
>  	if (fs_info->quota_root)

<snip>
