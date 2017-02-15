Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17685 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750902AbdBOBN7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 20:13:59 -0500
Subject: Re: [PATCH v2] btrfs: relocation: Enhance kernel error output for
 relocation
To: <fdmanana@gmail.com>
References: <20170214005750.414-1-quwenruo@cn.fujitsu.com>
 <CAL3q7H4RQzJaBiELCyjQNBb=NQ8kq-064vLAcYOKeTe4qeQOcw@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Liu Bo <bo.li.liu@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <fb3968ca-7dd7-a5c5-cfe0-b70c2480bd4d@cn.fujitsu.com>
Date: Wed, 15 Feb 2017 09:13:44 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4RQzJaBiELCyjQNBb=NQ8kq-064vLAcYOKeTe4qeQOcw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/15/2017 04:34 AM, Filipe Manana wrote:
> On Tue, Feb 14, 2017 at 12:57 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> When balance(relocation) fails, btrfs-progs will report like:
>>
>> ERROR: error during balancing '/mnt/scratch': Input/output error
>> There may be more info in syslog - try dmesg | tail
>>
>> However kernel can't provide may useful info in many cases to locate the
>> problem.
>>
>> This patch will add error messages in relocation to help user and
>> developer to locate the problem.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> v2:
>>   Fix typo where 'err' and 'ret' are used wrong.
>> ---
>>  fs/btrfs/relocation.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 56 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index 379711048fb0..d26809807c1b 100644
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -4011,6 +4011,8 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>>                                         rc->block_rsv, rc->block_rsv->size,
>>                                         BTRFS_RESERVE_FLUSH_ALL);
>>                 if (ret) {
>> +                       btrfs_err(fs_info, "failed to reserve space: %d(%s)",
>
> Please leave a space between %d and the opening parenthesis (a common
> style you follow but it's not correct in most western languages afaik,
> and makes things harder to the eye).
>

Thanks for pointing out my bad habit.

I'll avoid such usage in later patches.

Thanks,
Qu
>> +                                 ret, btrfs_decode_error(ret));
>>                         err = ret;
>>                         break;
>>                 }
>> @@ -4019,6 +4021,9 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>>                 if (IS_ERR(trans)) {
>>                         err = PTR_ERR(trans);
>>                         trans = NULL;
>> +                       btrfs_err(fs_info,
>> +                                 "failed to start transaction: %d(%s)",
>
> Same, space before parenthesis missing.
>
>> +                                 err, btrfs_decode_error(err));
>>                         break;
>>                 }
>>  restart:
>> @@ -4028,8 +4033,11 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>>                 }
>>
>>                 ret = find_next_extent(rc, path, &key);
>> -               if (ret < 0)
>> +               if (ret < 0) {
>> +                       btrfs_err(fs_info, "failed to find next extent: %d(%s)",
>
> Same, space before parenthesis missing.
>
>> +                                 ret, btrfs_decode_error(ret));
>>                         err = ret;
>> +               }
>>                 if (ret != 0)
>>                         break;
>>
>> @@ -4081,9 +4089,17 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>>
>>                 if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
>>                         ret = add_tree_block(rc, &key, path, &blocks);
>> +                       if (ret < 0)
>> +                               btrfs_err(fs_info,
>> +                                         "failed to record tree block: %d(%s)",
>> +                                         ret, btrfs_decode_error(ret));
>>                 } else if (rc->stage == UPDATE_DATA_PTRS &&
>>                            (flags & BTRFS_EXTENT_FLAG_DATA)) {
>>                         ret = add_data_references(rc, &key, path, &blocks);
>> +                       if (ret < 0)
>> +                               btrfs_err(fs_info,
>> +                                         "failed to record data extent: %d(%s)",
>
> Same, space before parenthesis missing.
>
>> +                                         ret, btrfs_decode_error(ret));
>>                 } else {
>>                         btrfs_release_path(path);
>>                         ret = 0;
>> @@ -4103,6 +4119,9 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>>                                 rc->backref_cache.last_trans = trans->transid - 1;
>>
>>                                 if (ret != -EAGAIN) {
>> +                                       btrfs_err(fs_info,
>> +                                       "faild to relocate tree blocks: %d(%s)",
>
> faild -> failed
>
> Same, space before parenthesis missing.
>
>> +                                                 ret, btrfs_decode_error(ret));
>>                                         err = ret;
>>                                         break;
>>                                 }
>> @@ -4121,6 +4140,9 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>>                         ret = relocate_data_extent(rc->data_inode,
>>                                                    &key, &rc->cluster);
>>                         if (ret < 0) {
>> +                               btrfs_err(fs_info,
>> +                               "failed to relocate data extent: %d(%s)",
>
> Same, space before parenthesis missing.
>
>> +                                         ret, btrfs_decode_error(ret));
>>                                 err = ret;
>>                                 break;
>>                         }
>> @@ -4147,8 +4169,12 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>>         if (!err) {
>>                 ret = relocate_file_extent_cluster(rc->data_inode,
>>                                                    &rc->cluster);
>> -               if (ret < 0)
>> +               if (ret < 0) {
>> +                       btrfs_err(fs_info,
>> +                       "failed to relocate file extent cluster: %d(%s)",
>
> Same, space before parenthesis missing.
>
>> +                                 ret, btrfs_decode_error(ret));
>>                         err = ret;
>> +               }
>>         }
>>
>>         rc->create_reloc_tree = 0;
>> @@ -4158,6 +4184,10 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>>         btrfs_block_rsv_release(fs_info, rc->block_rsv, (u64)-1);
>>
>>         err = prepare_to_merge(rc, err);
>> +       if (err < 0)
>> +               btrfs_err(fs_info,
>> +                         "failed to preapre merge relocate trees: %d(%s)",
>
> preapre -> prepare
>
> Also, grammar errors, should be something like for example: "failed to
> prepare merging of relocation trees".
>
>> +                         err, btrfs_decode_error(err));
>>
>>         merge_reloc_roots(rc);
>>
>> @@ -4336,6 +4366,9 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
>>
>>         ret = btrfs_inc_block_group_ro(extent_root, rc->block_group);
>>         if (ret) {
>> +               btrfs_err(fs_info,
>> +                       "failed to set block group read-only: %d(%s)",
>
> Same, space before parenthesis missing.
>
>> +                         ret, btrfs_decode_error(ret));
>>                 err = ret;
>>                 goto out;
>>         }
>> @@ -4351,10 +4384,19 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
>>                                         path);
>>         btrfs_free_path(path);
>>
>> -       if (!IS_ERR(inode))
>> +       if (!IS_ERR(inode)) {
>>                 ret = delete_block_group_cache(fs_info, rc->block_group, inode, 0);
>> -       else
>> +               if (ret < 0)
>> +                       btrfs_err(fs_info,
>> +                               "failed to delete block group cache: %d(%s)",
>
> Same, space before parenthesis missing.
>
>> +                                 ret, btrfs_decode_error(ret));
>> +       } else {
>>                 ret = PTR_ERR(inode);
>> +               if (ret < 0 && ret != -ENOENT)
>> +                       btrfs_err(fs_info,
>> +                               "failed to lookup free space inode: %d(%s)",
>
> Same, space before parenthesis missing.
>
>> +                                 ret, btrfs_decode_error(ret));
>> +       }
>>
>>         if (ret && ret != -ENOENT) {
>>                 err = ret;
>> @@ -4364,6 +4406,8 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
>>         rc->data_inode = create_reloc_inode(fs_info, rc->block_group);
>>         if (IS_ERR(rc->data_inode)) {
>>                 err = PTR_ERR(rc->data_inode);
>> +               btrfs_err(fs_info, "failed to create relocate inode: %d(%s)",
>
> relocate -> relocation
>
>> +                         err, btrfs_decode_error(err));
>>                 rc->data_inode = NULL;
>>                 goto out;
>>         }
>> @@ -4394,6 +4438,9 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
>>                         ret = btrfs_wait_ordered_range(rc->data_inode, 0,
>>                                                        (u64)-1);
>>                         if (ret) {
>> +                               btrfs_err(fs_info,
>> +                                       "failed to wait ordered range: %d(%s)",
>
> Same, space before parenthesis missing.
>
> And grammar errors, should be something like: "failure waiting for
> ordered range".
>
>> +                                         ret, btrfs_decode_error(ret));
>>                                 err = ret;
>>                                 goto out;
>>                         }
>> @@ -4407,6 +4454,11 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
>>         WARN_ON(rc->block_group->reserved > 0);
>>         WARN_ON(btrfs_block_group_used(&rc->block_group->item) > 0);
>>  out:
>> +       if (err < 0)
>> +               btrfs_err(fs_info,
>> +                         "failed to relocate block group %llu: %d(%s)",
>
> Same, space before parenthesis missing.
>
> Thanks.
>
>> +                         rc->block_group->key.objectid, err,
>> +                         btrfs_decode_error(err));
>>         if (err && rw)
>>                 btrfs_dec_block_group_ro(rc->block_group);
>>         iput(rc->data_inode);
>> --
>> 2.11.1
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>


