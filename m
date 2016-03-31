Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16571 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750928AbcCaCUn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 22:20:43 -0400
Subject: Re: [PATCH] btrfs: handle non-fatal errors in btrfs_qgroup_inherit()
To: Mark Fasheh <mfasheh@suse.de>, <linux-btrfs@vger.kernel.org>
References: <20160331005748.GI15881@wotan.suse.de>
CC: <clm@fb.com>, <jbacik@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56FC8973.6060600@cn.fujitsu.com>
Date: Thu, 31 Mar 2016 10:20:35 +0800
MIME-Version: 1.0
In-Reply-To: <20160331005748.GI15881@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Mark Fasheh wrote on 2016/03/30 17:57 -0700:
> create_pending_snapshot() will go readonly on _any_ error return from
> btrfs_qgroup_inherit(). If qgroups are enabled, a user can crash their fs by
> just making a snapshot and asking it to inherit from an invalid qgroup. For
> example:
>
> $ btrfs sub snap -i 1/10 /btrfs/ /btrfs/foo
>
> Will cause a transaction abort.
>
> Fix this by only throwing errors in btrfs_qgroup_inherit() when we know
> going readonly is acceptable.
>
> The following xfstests test case reproduces this bug:
>
>    seq=`basename $0`
>    seqres=$RESULT_DIR/$seq
>    echo "QA output created by $seq"
>
>    here=`pwd`
>    tmp=/tmp/$$
>    status=1	# failure is the default!
>    trap "_cleanup; exit \$status" 0 1 2 3 15
>
>    _cleanup()
>    {
>    	cd /
>    	rm -f $tmp.*
>    }
>
>    # get standard environment, filters and checks
>    . ./common/rc
>    . ./common/filter
>
>    # remove previous $seqres.full before test
>    rm -f $seqres.full
>
>    # real QA test starts here
>    _supported_fs btrfs
>    _supported_os Linux
>    _require_scratch
>
>    rm -f $seqres.full
>
>    _scratch_mkfs
>    _scratch_mount
>    _run_btrfs_util_prog quota enable $SCRATCH_MNT
>    # The qgroup '1/10' does not exist and should be silently ignored
>    _run_btrfs_util_prog subvolume snapshot -i 1/10 $SCRATCH_MNT $SCRATCH_MNT/snap1
>
>    _scratch_unmount
>
>    echo "Silence is golden"
>
>    status=0
>    exit
>
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Looks good to me, and right current check is too restrict and will cause 
annoying abort_transaction.

Although silently ignore invalid assign is somewhat too casual, that's 
already much better than current abort_transaction.

Thanks,
Qu
> ---
>   fs/btrfs/qgroup.c | 54 ++++++++++++++++++++++++++++++++----------------------
>   1 file changed, 32 insertions(+), 22 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 994dab0..9e11955 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1851,8 +1851,10 @@ out:
>   }
>
>   /*
> - * copy the acounting information between qgroups. This is necessary when a
> - * snapshot or a subvolume is created
> + * Copy the acounting information between qgroups. This is necessary
> + * when a snapshot or a subvolume is created. Throwing an error will
> + * cause a transaction abort so we take extra care here to only error
> + * when a readonly fs is a reasonable outcome.
>    */
>   int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
>   			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
> @@ -1882,15 +1884,15 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
>   		       2 * inherit->num_excl_copies;
>   		for (i = 0; i < nums; ++i) {
>   			srcgroup = find_qgroup_rb(fs_info, *i_qgroups);
> -			if (!srcgroup) {
> -				ret = -EINVAL;
> -				goto out;
> -			}
>
> -			if ((srcgroup->qgroupid >> 48) <= (objectid >> 48)) {
> -				ret = -EINVAL;
> -				goto out;
> -			}
> +			/*
> +			 * Zero out invalid groups so we can ignore
> +			 * them later.
> +			 */
> +			if (!srcgroup ||
> +			    ((srcgroup->qgroupid >> 48) <= (objectid >> 48)))
> +				*i_qgroups = 0ULL;
> +
>   			++i_qgroups;
>   		}
>   	}
> @@ -1925,17 +1927,19 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
>   	 */
>   	if (inherit) {
>   		i_qgroups = (u64 *)(inherit + 1);
> -		for (i = 0; i < inherit->num_qgroups; ++i) {
> +		for (i = 0; i < inherit->num_qgroups; ++i, ++i_qgroups) {
> +			if (*i_qgroups == 0)
> +				continue;
>   			ret = add_qgroup_relation_item(trans, quota_root,
>   						       objectid, *i_qgroups);
> -			if (ret)
> +			if (ret && ret != -EEXIST)
>   				goto out;
>   			ret = add_qgroup_relation_item(trans, quota_root,
>   						       *i_qgroups, objectid);
> -			if (ret)
> +			if (ret && ret != -EEXIST)
>   				goto out;
> -			++i_qgroups;
>   		}
> +		ret = 0;
>   	}
>
>
> @@ -1996,17 +2000,22 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
>
>   	i_qgroups = (u64 *)(inherit + 1);
>   	for (i = 0; i < inherit->num_qgroups; ++i) {
> -		ret = add_relation_rb(quota_root->fs_info, objectid,
> -				      *i_qgroups);
> -		if (ret)
> -			goto unlock;
> +		if (*i_qgroups) {
> +			ret = add_relation_rb(quota_root->fs_info, objectid,
> +					      *i_qgroups);
> +			if (ret)
> +				goto unlock;
> +		}
>   		++i_qgroups;
>   	}
>
> -	for (i = 0; i <  inherit->num_ref_copies; ++i) {
> +	for (i = 0; i <  inherit->num_ref_copies; ++i, i_qgroups += 2) {
>   		struct btrfs_qgroup *src;
>   		struct btrfs_qgroup *dst;
>
> +		if (!i_qgroups[0] || !i_qgroups[1])
> +			continue;
> +
>   		src = find_qgroup_rb(fs_info, i_qgroups[0]);
>   		dst = find_qgroup_rb(fs_info, i_qgroups[1]);
>
> @@ -2017,12 +2026,14 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
>
>   		dst->rfer = src->rfer - level_size;
>   		dst->rfer_cmpr = src->rfer_cmpr - level_size;
> -		i_qgroups += 2;
>   	}
> -	for (i = 0; i <  inherit->num_excl_copies; ++i) {
> +	for (i = 0; i <  inherit->num_excl_copies; ++i, i_qgroups += 2) {
>   		struct btrfs_qgroup *src;
>   		struct btrfs_qgroup *dst;
>
> +		if (!i_qgroups[0] || !i_qgroups[1])
> +			continue;
> +
>   		src = find_qgroup_rb(fs_info, i_qgroups[0]);
>   		dst = find_qgroup_rb(fs_info, i_qgroups[1]);
>
> @@ -2033,7 +2044,6 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
>
>   		dst->excl = src->excl + level_size;
>   		dst->excl_cmpr = src->excl_cmpr + level_size;
> -		i_qgroups += 2;
>   	}
>
>   unlock:
>


