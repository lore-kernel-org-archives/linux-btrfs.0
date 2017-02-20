Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37133 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751918AbdBTEf7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Feb 2017 23:35:59 -0500
Subject: Re: [PATCH] qgroup: Retry after commit on getting EDQUOT
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20170219133059.20939-1-rgoldwyn@suse.de>
 <41d7ef6d-28fe-7d32-982f-57823e3ce943@cn.fujitsu.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <227e0a99-5eae-03d4-1a9a-b9bc45861c8a@suse.de>
Date: Sun, 19 Feb 2017 22:35:53 -0600
MIME-Version: 1.0
In-Reply-To: <41d7ef6d-28fe-7d32-982f-57823e3ce943@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

On 02/19/2017 09:07 PM, Qu Wenruo wrote:
> 
> 
> At 02/19/2017 09:30 PM, Goldwyn Rodrigues wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> We are facing the same problem with EDQUOT which was experienced with
>> ENOSPC. Not sure if we require a full ticketing system such as ENOSPC,
>> but
>> here is a fix. Let me know if it is too big a hammer.
>>
>> Quotas are reserved during the start of an operation, incrementing
>> qg->reserved. However, it is written to disk in a commit_transaction
>> which could take as long as commit_interval. In the meantime there
>> could be deletions which are not accounted for because deletions are
>> accounted for only while committed (free_refroot). So, when we get
>> a EDQUOT flush the data to disk and try again.
> 
> IIRC Jeff submitted a qgroup patch to allow unlink to be done even we
> already hit EDQUOT.
> https://patchwork.kernel.org/patch/9537193/
> 
> I think that's a better solution, which is quite like what we do to
> handle ENOSPC.
> 

These are two separate issues. This issue is where qg->reserved gets
over-inflated because of repeated deletions and recreations within a
commit_interval.

Jeff's patch deals with allowing removal even if the quota is exceeded
so that eventually there can be space freed.

I would suggest you apply Jeff's patch and try to run the script I have
presented.


> Thanks,
> Qu
> 
>>
>> I combined the conditions of rfer and excl to reduce code lines, though
>> the condition looks uglier.
>>
>> Here is a sample script which shows this issue.
>>
>> DEVICE=/dev/vdb
>> MOUNTPOINT=/mnt
>> TESTVOL=$MOUNTPOINT/tmp
>> QUOTA=5
>> PROG=btrfs
>> DD_BS="4k"
>> DD_COUNT="256"
>> RUN_TIMES=5000
>>
>> mkfs.btrfs -f $DEVICE
>> mount -o commit=240 $DEVICE $MOUNTPOINT
>> $PROG subvolume create $TESTVOL
>> $PROG quota enable $TESTVOL
>> $PROG qgroup limit ${QUOTA}G $TESTVOL
>>
>> typeset -i DD_RUN_GOOD
>> typeset -i QUOTA
>>
>> function _check_cmd() {
>>         if [[ ${?} > 0 ]]; then
>>                 echo -n "$(date) E: Running previous command"
>>                 echo ${*}
>>         echo "Without sync"
>>         $PROG qgroup show -pcreFf ${TESTVOL}
>>         echo "With sync"
>>         $PROG qgroup show -pcreFf --sync ${TESTVOL}
>>                 exit 1
>>         fi
>> }
>>
>> while true; do
>> DD_RUN_GOOD=$RUN_TIMES
>>
>> while (( ${DD_RUN_GOOD} != 0 )); do
>>     dd if=/dev/zero of=${TESTVOL}/quotatest${DD_RUN_GOOD} bs=${DD_BS}
>> count=${DD_COUNT}
>>     _check_cmd "dd if=/dev/zero of=${TESTVOL}/quotatest${DD_RUN_GOOD}
>> bs=${DD_BS} count=${DD_COUNT}"
>>     DD_RUN_GOOD=(${DD_RUN_GOOD}-1)
>> done
>>
>> $PROG qgroup show -pcref $TESTVOL
>> echo "----------- Cleanup ---------- "
>> rm $TESTVOL/quotatest*
>>
>> done
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>>  fs/btrfs/qgroup.c | 28 +++++++++++++++++-----------
>>  1 file changed, 17 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 4700cac..9ace407 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -2093,6 +2093,7 @@ static int qgroup_reserve(struct btrfs_root
>> *root, u64 num_bytes)
>>      struct btrfs_fs_info *fs_info = root->fs_info;
>>      u64 ref_root = root->root_key.objectid;
>>      int ret = 0;
>> +    int retried = 0;
>>      struct ulist_node *unode;
>>      struct ulist_iterator uiter;
>>
>> @@ -2101,7 +2102,7 @@ static int qgroup_reserve(struct btrfs_root
>> *root, u64 num_bytes)
>>
>>      if (num_bytes == 0)
>>          return 0;
>> -
>> +retry:
>>      spin_lock(&fs_info->qgroup_lock);
>>      quota_root = fs_info->quota_root;
>>      if (!quota_root)
>> @@ -2127,16 +2128,21 @@ static int qgroup_reserve(struct btrfs_root
>> *root, u64 num_bytes)
>>
>>          qg = u64_to_ptr(unode->aux);
>>
>> -        if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
>> -            qg->reserved + (s64)qg->rfer + num_bytes >
>> -            qg->max_rfer) {
>> -            ret = -EDQUOT;
>> -            goto out;
>> -        }
>> -
>> -        if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
>> -            qg->reserved + (s64)qg->excl + num_bytes >
>> -            qg->max_excl) {
>> +        if (((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
>> +              qg->reserved + (s64)qg->rfer + num_bytes >
>> qg->max_rfer) ||
>> +            ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
>> +            qg->reserved + (s64)qg->excl + num_bytes > qg->max_excl)) {
>> +            if (!retried && qg->reserved > 0) {
>> +                struct btrfs_trans_handle *trans;
>> +                spin_unlock(&fs_info->qgroup_lock);
>> +                btrfs_start_delalloc_roots(fs_info, 0, -1);
>> +                trans = btrfs_join_transaction(root);
>> +                if (IS_ERR(trans))
>> +                    return PTR_ERR(trans);
>> +                btrfs_commit_transaction(trans, root);
>> +                retried++;
>> +                goto retry;
>> +            }
>>              ret = -EDQUOT;
>>              goto out;
>>          }
>>
> 
> 

-- 
Goldwyn
