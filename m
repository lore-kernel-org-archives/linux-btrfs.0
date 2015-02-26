Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15061 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750768AbbBZGIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Feb 2015 01:08:40 -0500
Message-ID: <54EEB798.1070105@cn.fujitsu.com>
Date: Thu, 26 Feb 2015 14:05:12 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, <mfasheh@suse.de>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] btrfs: qgroup: fix a wrong parameter of no_quota.
References: <1423563845-9103-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1423563845-9103-4-git-send-email-yangds.fnst@cn.fujitsu.com> <54DDC62D.4070206@cn.fujitsu.com>
In-Reply-To: <54DDC62D.4070206@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wait a minute, this patch seems not working well in accounting quota 
number when
deleting data shared by different subvolumes.

I will investigate more about it and send a V2 out.

Thanx
Yang

On 02/13/2015 05:38 PM, Dongsheng Yang wrote:hen
> Hi Josef and Mark,
>
> I saw the commit message of 1152651a:
>
> [btrfs: qgroup: account shared subtrees during snapshot delete]
>
> that SUBTREE operation was introduced to account the quota number
> in subvolume deleting.
>
> But, I found it does not work well currently：
>
> Create subvolume '/mnt/sub'
> + btrfs qgroup show -prce /mnt
> qgroupid rfer excl max_rfer max_excl parent child
> -------- ---- ---- -------- -------- ------ -----
> 0/5 16.00KiB 16.00KiB 0.00B 0.00B --- ---
> 0/257 16.00KiB 16.00KiB 0.00B 0.00B --- ---
> + dd if=/dev/zero of=/mnt/sub/data bs=1024 count=100
> 100+0 records in
> 100+0 records out
> 102400 bytes (102 kB) copied, 0.000876526 s, 117 MB/s
> + sync
> + btrfs qgroup show -prce --raw /mnt
> qgroupid rfer excl max_rfer max_excl parent child
> -------- ---- ---- -------- -------- ------ -----
> 0/5 16384 16384 0 0 --- ---
> 0/257 118784 118784 0 0 --- ---
> + btrfs sub snap /mnt/sub /mnt/snap
> Create a snapshot of '/mnt/sub' in '/mnt/snap'
> + sync
> + btrfs qgroup show -prce --raw /mnt
> qgroupid rfer excl max_rfer max_excl parent child
> -------- ---- ---- -------- -------- ------ -----
> 0/5 16384 16384 0 0 --- ---
> 0/257 118784 16384 0 0 --- ---
> 0/258 118784 16384 0 0 --- ---
> + btrfs sub delete /mnt/sub
> Delete subvolume (no-commit): '/mnt/sub'
> + sync
> + btrfs qgroup show -prce --raw /mnt
> qgroupid rfer excl max_rfer max_excl parent child
> -------- ---- ---- -------- -------- ------ -----
> 0/5 16384 16384 0 0 --- ---
> 0/257 118784 16384 0 0 --- ---
> 0/258 118784 16384 0 0 --- ---
>
> --------------------------------------------------------------------------- 
> <------- WAIT for cleaner
> [root@atest-guest linux_btrfs]# btrfs qgroup show -prce /mnt
> qgroupid rfer excl max_rfer max_excl parent child
> -------- ---- ---- -------- -------- ------ -----
> 0/5 16.00KiB 16.00KiB 0.00B 0.00B --- ---
> 0/257 100.00KiB 0.00B 0.00B 0.00B --- --- <------- the data size was 
> not cleaned from qgroup.
> 0/258 116.00KiB 116.00KiB 0.00B 0.00B --- --- <------- but the excl in 
> the snapshot qgroup is increased to 116KB by SUBTREE operation
>
> My question is:
> (1), SUBTREE is not working well.
> (2), why we need a rule-breaker in qgroup operations SUBTREE to do 
> this work?
> We can do it via the delayed-ref routine like the other qgroup 
> operations.
>
> with my patch here applied and 1152651a reverted, I got the result:
> qgroupid rfer excl max_rfer max_excl parent child
> -------- ---- ---- -------- -------- ------ -----
> 0/5 16.00KiB 16.00KiB 0.00B 0.00B --- ---
> 0/257 0.00B 0.00B 0.00B 0.00B --- --- <----------- data and tree block 
> both are cleaned
> 0/258 116.00KiB 116.00KiB 0.00B 0.00B --- --- <------ quota numbers in 
> snapshot qgroup is correct.
>
> (1), quota is working well now in subvolume deleting.
> (2), all operations are inserted by delayed-ref.
>
> So, the conclusion seems like that:
> (1), commit 1152651a was introducing a SUBTREE operation to account 
> the number in subvolume deleted.
> (2). SUBTREE is not working well.
> (3). we can solve the same problem in a better way without introducing 
> a new operation of SUBTREE.
>
> To be honest, I am suspecting myself *very much*. I trust you guys and 
> believe there must be something I am missing.
>
> Then I send this mail to ask your help.
>
> Thanx in advance.
> Yang
>
>
> On 02/10/2015 06:24 PM, Dongsheng Yang wrote:
>> In function of __btrfs_mod_ref(), we are passing the no_quota=1
>> to process_func() anyway. It will make the numbers in qgroup be
>> wrong when deleting a subvolume. The data size in a deleted subvolume
>> will never be decressed from all related qgroups.
>>
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/extent-tree.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 652be74..f59809c 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -3056,6 +3056,7 @@ static int __btrfs_mod_ref(struct 
>> btrfs_trans_handle *trans,
>>       int i;
>>       int level;
>>       int ret = 0;
>> +    int no_quota = 0;
>>       int (*process_func)(struct btrfs_trans_handle *, struct 
>> btrfs_root *,
>>                   u64, u64, u64, u64, u64, u64, int);
>>   @@ -3080,6 +3081,9 @@ static int __btrfs_mod_ref(struct 
>> btrfs_trans_handle *trans,
>>       else
>>           parent = 0;
>>   +    if (!root->fs_info->quota_enabled || !is_fstree(ref_root))
>> +        no_quota = 1;
>> +
>>       for (i = 0; i < nritems; i++) {
>>           if (level == 0) {
>>               btrfs_item_key_to_cpu(buf, &key, i);
>> @@ -3098,7 +3102,7 @@ static int __btrfs_mod_ref(struct 
>> btrfs_trans_handle *trans,
>>               key.offset -= btrfs_file_extent_offset(buf, fi);
>>               ret = process_func(trans, root, bytenr, num_bytes,
>>                          parent, ref_root, key.objectid,
>> -                       key.offset, 1);
>> +                       key.offset, no_quota);
>>               if (ret)
>>                   goto fail;
>>           } else {
>> @@ -3106,7 +3110,7 @@ static int __btrfs_mod_ref(struct 
>> btrfs_trans_handle *trans,
>>               num_bytes = root->nodesize;
>>               ret = process_func(trans, root, bytenr, num_bytes,
>>                          parent, ref_root, level - 1, 0,
>> -                       1);
>> +                       no_quota);
>>               if (ret)
>>                   goto fail;
>>           }
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
>

