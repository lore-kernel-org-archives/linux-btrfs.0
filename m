Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43266 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752053AbeB0LJs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 06:09:48 -0500
Subject: Re: [PATCH 1/4] btrfs-progs: check: Check data csum for all copies
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180227091259.10877-1-wqu@suse.com>
 <20180227091259.10877-2-wqu@suse.com>
 <241a459e-048b-e872-0e99-dc6263c9a6dd@cn.fujitsu.com>
 <7c580d98-7ac9-0a0e-5f4f-2caeb637becd@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <523adf98-01bd-eb8b-e0d0-6d105e260f8f@suse.com>
Date: Tue, 27 Feb 2018 13:09:43 +0200
MIME-Version: 1.0
In-Reply-To: <7c580d98-7ac9-0a0e-5f4f-2caeb637becd@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 27.02.2018 12:31, Qu Wenruo wrote:
> 
> 
> On 2018年02月27日 18:01, Su Yue wrote:
>>
>>
>> On 02/27/2018 05:12 PM, Qu Wenruo wrote:
>>> Original --check-data-csum option will skip the extra copy if the first
>>> copy matches csum.
>>>
>>> Since offline scrub (with recoverability report) is still out-of-tree, at
>>> least enhance --check-data-csum option to handle multiple copies.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>   check/main.c | 65
>>> ++++++++++++++++++++++++++++++------------------------------
>>>   1 file changed, 32 insertions(+), 33 deletions(-)
>>>
>>> diff --git a/check/main.c b/check/main.c
>>> index 97baae583f04..f25fdc765d63 100644
>>> --- a/check/main.c
>>> +++ b/check/main.c
>>> @@ -5381,42 +5381,37 @@ static int check_extent_csums(struct
>>> btrfs_root *root, u64 bytenr,
>>>       if (!data)
>>>           return -ENOMEM;
>>>   +    num_copies = btrfs_num_copies(root->fs_info, bytenr, num_bytes);
>>>       while (offset < num_bytes) {
>>> -        mirror = 0;
>>> -again:
>>> -        read_len = num_bytes - offset;
>>> -        /* read as much space once a time */
>>> -        ret = read_extent_data(fs_info, data + offset,
>>> -                bytenr + offset, &read_len, mirror);
>>> -        if (ret)
>>> -            goto out;
>>> -        data_checked = 0;
>>> -        /* verify every 4k data's checksum */
>>> -        while (data_checked < read_len) {
>>> -            csum = ~(u32)0;
>>> -            tmp = offset + data_checked;
>>> -
>>> -            csum = btrfs_csum_data((char *)data + tmp,
>>> -                           csum, fs_info->sectorsize);
>>> -            btrfs_csum_final(csum, (u8 *)&csum);
>>> -
>>> -            csum_offset = leaf_offset +
>>> -                 tmp / fs_info->sectorsize * csum_size;
>>> -            read_extent_buffer(eb, (char *)&csum_expected,
>>> -                       csum_offset, csum_size);
>>> -            /* try another mirror */
>>> -            if (csum != csum_expected) {
>>> -                fprintf(stderr, "mirror %d bytenr %llu csum %u
>>> expected csum %u\n",
>>> +        for (mirror = 1; mirror <= num_copies; mirror++) {
>>
>> Got your point.
>> But what confuses me is that why mirror starts from 1 here.
>> The mirror influences btrfs_map_block() which is not related
>> to this patch though.
> 
> mirror number has different meanings in fact.
> 
> For 0, it means try to read *ANY* valid copy, it can be the copy of a
> duplication, or even rebuilt data from RAID5/6.
> 
> For 1, it means the fist copy. Either the only copy of
> SINGLE/RAID0/RAID5/6, or the first copy of RAID1/10.
> 
> For 2, it means the 2nd copy, it can be real copy for RAID1/RAID10, or
> rebuilt data from RAID5/6.
> 
> And in fact Liu Bo is adding new copy numbers for RAID5/6 to allow us to
> specify how to build the missing data for RAID6.
> 
> So here starting from mirror 1 is the correct behavior.

Shouldn't those be documented?

> 
> Thanks,
> Qu
>>
>> Thanks,
>> Su
>>> +            read_len = num_bytes - offset;
>>> +            /* read as much space once a time */
>>> +            ret = read_extent_data(fs_info, data + offset,
>>> +                    bytenr + offset, &read_len, mirror);
>>> +            if (ret)
>>> +                goto out;
>>> +
>>> +            data_checked = 0;
>>> +            /* verify every 4k data's checksum */
>>> +            while (data_checked < read_len) {
>>> +                csum = ~(u32)0;
>>> +                tmp = offset + data_checked;
>>> +
>>> +                csum = btrfs_csum_data((char *)data + tmp,
>>> +                        csum, fs_info->sectorsize);
>>> +                btrfs_csum_final(csum, (u8 *)&csum);
>>> +
>>> +                csum_offset = leaf_offset +
>>> +                     tmp / fs_info->sectorsize * csum_size;
>>> +                read_extent_buffer(eb, (char *)&csum_expected,
>>> +                           csum_offset, csum_size);
>>> +                if (csum != csum_expected)
>>> +                    fprintf(stderr,
>>> +            "mirror %d bytenr %llu csum %u expected csum %u\n",
>>>                           mirror, bytenr + tmp,
>>>                           csum, csum_expected);
>>> -                num_copies = btrfs_num_copies(root->fs_info,
>>> -                        bytenr, num_bytes);
>>> -                if (mirror < num_copies - 1) {
>>> -                    mirror += 1;
>>> -                    goto again;
>>> -                }
>>> +                data_checked += fs_info->sectorsize;
>>>               }
>>> -            data_checked += fs_info->sectorsize;
>>>           }
>>>           offset += read_len;
>>>       }
>>> @@ -5624,7 +5619,11 @@ static int check_csums(struct btrfs_root *root)
>>>           leaf_offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
>>>           ret = check_extent_csums(root, key.offset, data_len,
>>>                        leaf_offset, leaf);
>>> -        if (ret)
>>> +        /*
>>> +         * Only break for fatal errors, if mismatch is found,
>>> +         * continue checking until all extents are checked.
>>> +         */
>>> +        if (ret < 0)
>>>               break;
>>>   skip_csum_check:
>>>           if (!num_bytes) {
>>>
>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
