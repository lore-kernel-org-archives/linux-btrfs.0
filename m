Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:48205 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752113AbcJKI6n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 04:58:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 11 Oct 2016 16:58:30 +0800
From: robbieko <robbieko@synology.com>
To: fdmanana@gmail.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix enospc in punch hole
In-Reply-To: <CAL3q7H4rQq_yC6PsohCN=9XAU8QTauQhhxB2sKRe+OEZqmQVUA@mail.gmail.com>
References: <1475820576-27316-1-git-send-email-robbieko@synology.com>
 <CAL3q7H4rQq_yC6PsohCN=9XAU8QTauQhhxB2sKRe+OEZqmQVUA@mail.gmail.com>
Message-ID: <e2448ed0e27a17c935bac50bc33d709c@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe:

because btrfs_calc_trunc_metadata_size is reserved leafsize + nodesize * 
(8 - 1)
assume leafsize is the same as nodesize, we total reserved 8 nodesize
when split leaf, we need 2 path, if extent_tree level small than 4, it's 
OK
because worst case is (leafsize + nodesize * 3) *2, is 8 nodesize.
but if extent_tree is greater level 4, worst case is need (leafsize + 
nodesize * 7) * 2,
is bigger than resvered size, so we should use 
btrfs_calc_trans_metadata_size,
is taken into account split leaf case.

Thanks.
robbieko

Filipe Manana 於 2016-10-07 18:18 寫到:
> On Fri, Oct 7, 2016 at 7:09 AM, robbieko <robbieko@synology.com> wrote:
>> From: Robbie Ko <robbieko@synology.com>
>> 
>> when extent-tree level > BTRFS_MAX_LEVEL / 2,
>> __btrfs_drop_extents -> btrfs_duplicate_item ->
>> setup_leaf_for_split -> split_leaf
>> maybe enospc, because min_size is too small,
>> need use btrfs_calc_trans_metadata_size.
> 
> This change log is terrible.
> You should describe the problem and fix. That is, that hole punching
> can result in adding new leafs (and as a consequence new nodes) to the
> tree because when we find file extent items that span beyond the hole
> range we may end up not deleting them (just adjusting them) and add
> new file extent items representing holes.
> 
> And I don't see why this is exclusive for the case where the height of
> the extent tree is greater than 4 (BTRFS_MAX_LEVEL / 2).
> 
> The code changes themselves look good to me.
> 
> thanks
> 
>> 
>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>> ---
>>  fs/btrfs/file.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index fea31a4..809ca85 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -2322,7 +2322,7 @@ static int btrfs_punch_hole(struct inode *inode, 
>> loff_t offset, loff_t len)
>>         u64 tail_len;
>>         u64 orig_start = offset;
>>         u64 cur_offset;
>> -       u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
>> +       u64 min_size = btrfs_calc_trans_metadata_size(root, 1);
>>         u64 drop_end;
>>         int ret = 0;
>>         int err = 0;
>> @@ -2469,7 +2469,7 @@ static int btrfs_punch_hole(struct inode *inode, 
>> loff_t offset, loff_t len)
>>                 ret = -ENOMEM;
>>                 goto out_free;
>>         }
>> -       rsv->size = btrfs_calc_trunc_metadata_size(root, 1);
>> +       rsv->size = btrfs_calc_trans_metadata_size(root, 1);
>>         rsv->failfast = 1;
>> 
>>         /*
>> --
>> 1.9.1
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

