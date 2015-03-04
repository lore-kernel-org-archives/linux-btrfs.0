Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46029 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932261AbbCDDNG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Mar 2015 22:13:06 -0500
Message-ID: <54F6783C.8030303@cn.fujitsu.com>
Date: Wed, 4 Mar 2015 11:13:00 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: rework qgroup accounting V2
References: <1399992661-18059-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1399992661-18059-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

...
>
> 1) qgroup ref operations: instead of tracking qgroup operations through the
> delayed refs we simply add new ref operations whenever we notice that we need to
> when we've modified the refs themselves.
>
> 2) tree mod seq:  we no longer have this separation of major/minor counters.
> this makes the sequence number stuff much more sane and we can remove some
> locking that was needed to protect the counter.
>
> 3) delayed ref seq: we now read the tree mod seq number and use that as our
> sequence.  This means each new delayed ref doesn't have it's own unique sequence
> number, rather whenever we go to lookup backrefs we inc the sequence number so
> we can make sure to keep any new operations from screwing up our world view at
> that given point.  This allows us to merge delayed refs during runtime.
>
> With all of these changes the delayed ref stuff is a little saner and the qgroup
> accounting stuff no longer goes negative in some cases like it was before.
> Thanks,
Although the patch is already merged, but sadlly there is still some 
cases of negative values in qgroup. e.g btrfs/057. :(

>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
[snip]
> @@ -2698,8 +2711,6 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>   	if (root == root->fs_info->extent_root)
>   		root = root->fs_info->tree_root;
>
> -	btrfs_delayed_refs_qgroup_accounting(trans, root->fs_info);
> -
>   	delayed_refs = &trans->transaction->delayed_refs;
>   	if (count == 0) {
>   		count = atomic_read(&delayed_refs->num_entries) * 2;
> @@ -2758,6 +2769,9 @@ again:
>   		goto again;
>   	}
>   out:
> +	ret = btrfs_delayed_qgroup_accounting(trans, root->fs_info);
I'm curious about why delay the real qgroup data calculation.

Since the refs are already delayed, I didn't really see the advantage to 
deley qgroup again. (Maybe put them together can reduce cache miss?)

And more important, at this point of time, the backref changes are 
already done. This will make qgroup accounting more complicated.

Some problem is already happen as Liu Bo pointed out:
https://www.marc.info/?l=linux-btrfs&m=142380342319441&w=3

Why not directly do the calculation at the timing of 
btrfs_qgroup_record_ref()?
At that point, all backrefs should be as what we see.

> +	if (ret)
> +		return ret;
>   	assert_qgroups_uptodate(trans);
>   	return 0;
>   }
[snip]
>
>   /*
> - * btrfs_qgroup_record_ref is called when the ref is added or deleted. it puts
> - * the modification into a list that's later used by btrfs_end_transaction to
> - * pass the recorded modifications on to btrfs_qgroup_account_ref.
> + * Record a quota operation for processing later on.
> + * @trans: the transaction we are adding the delayed op to.
> + * @fs_info: the fs_info for this fs.
> + * @ref_root: the root of the reference we are acting on,
> + * @bytenr: the bytenr we are acting on.
> + * @num_bytes: the number of bytes in the reference.
> + * @type: the type of operation this is.
> + * @mod_seq: do we need to get a sequence number for looking up roots.
> + *
> + * We just add it to our trans qgroup_ref_list and carry on and process these
> + * operations in order at some later point.  If the reference root isn't a fs
> + * root then we don't bother with doing anything.
> + *
> + * MUST BE HOLDING THE REF LOCK.
>    */
>   int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
> -			    struct btrfs_delayed_ref_node *node,
> -			    struct btrfs_delayed_extent_op *extent_op)
> +			    struct btrfs_fs_info *fs_info, u64 ref_root,
> +			    u64 bytenr, u64 num_bytes,
> +			    enum btrfs_qgroup_operation_type type, int mod_seq)
It seems the parameters can't provide enough info than the original ones.

For example, current we pass ref_root as root_to_skip in 
qgroup_calc_old_refcnt(), but in case of cp --reflink in the same 
subvol, all the original refcnt will be skipped, which is overkilled and 
may cause problems.

The ref_node one can provide enough data to pin-point the ref we are 
add, so we should not need to skip given root and get actual old refcnt.

Thanks,
Qu
