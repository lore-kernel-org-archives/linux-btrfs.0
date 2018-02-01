Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35429 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751399AbeBAI2P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Feb 2018 03:28:15 -0500
Subject: Re: [PATCH v2 3/3] btrfs-progs: check: Cleanup all checkpatch error
 and warning
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180201064541.14603-1-wqu@suse.com>
 <20180201064541.14603-4-wqu@suse.com>
 <a3275ec5-c4af-88e0-b1b6-022ff820a9b4@cn.fujitsu.com>
 <56a60440-c066-4f24-257d-21e7efa0ff38@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <88127c19-73ba-a376-327c-6be93a63d251@suse.com>
Date: Thu, 1 Feb 2018 10:28:13 +0200
MIME-Version: 1.0
In-Reply-To: <56a60440-c066-4f24-257d-21e7efa0ff38@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  1.02.2018 09:48, Qu Wenruo wrote:
> 
> 
> On 2018年02月01日 15:08, Su Yue wrote:
>>
>>
>> On 02/01/2018 02:45 PM, Qu Wenruo wrote:
>>> Since we're moving tons of codes, it's a good idea to fix all errors and
> [snip]
>>>               }
>>> @@ -2500,7 +2507,8 @@ static int repair_extent_data_item(struct
>>> btrfs_trans_handle *trans,
>>>           if (ret)
>>>               goto out;
>>>           eb = path.nodes[0];
>>> -        ei = btrfs_item_ptr(eb, path.slots[0], struct
>>> btrfs_extent_item);
>>> +        ei = btrfs_item_ptr(eb, path.slots[0],
>>> +                    struct btrfs_extent_item);
>>>             btrfs_set_extent_refs(eb, ei, 0);
>>>           btrfs_set_extent_generation(eb, ei, generation);
>>> @@ -2657,7 +2665,8 @@ static int check_extent_data_item(struct
>>> btrfs_root *root,
>>>           }
>>>           if (type == BTRFS_EXTENT_DATA_REF_KEY) {
>>>               ref_root = btrfs_extent_data_ref_root(leaf, dref);
>>> -            ref_objectid = btrfs_extent_data_ref_objectid(leaf, dref);
>>> +            ref_objectid = btrfs_extent_data_ref_objectid(leaf,
>>> +                                      dref);
>>>               ref_offset = btrfs_extent_data_ref_offset(leaf, dref);
>>>                 if (ref_objectid == fi_key.objectid &&
>>> @@ -2820,8 +2829,8 @@ static int check_block_group_item(struct
>>> btrfs_fs_info *fs_info,
>>>               if (!(bg_flags & BTRFS_BLOCK_GROUP_DATA)) {
>>>                   error(
>>>               "bad extent[%llu, %llu) type mismatch with chunk",
>>> -                    extent_key.objectid,
>>> -                    extent_key.objectid + extent_key.offset);
>>> +                      extent_key.objectid,
>>> +                      extent_key.objectid + extent_key.offset);
>>>                   err |= CHUNK_TYPE_MISMATCH;
>>>               }
>>>           } else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
>>> @@ -3175,7 +3184,8 @@ static int check_extent_data_backref(struct
>>> btrfs_fs_info *fs_info,
>>>               btrfs_header_owner(leaf) != root_id)
>>>               goto next;
>>>           btrfs_item_key_to_cpu(leaf, &key, slot);
>>> -        if (key.objectid != objectid || key.type !=
>>> BTRFS_EXTENT_DATA_KEY)
>>> +        if (key.objectid != objectid || key.type !=
>>> +            BTRFS_EXTENT_DATA_KEY)
>> if (key.objectid != objectid ||
>>     key.type != BTRFS_EXTENT_DATA_KEY)
>> is more better.
>> Other changes are nice.
> 
> I also thought about that, but that leaves too much space in previous line.
> 
> Not sure what should be the best practice here.

Su's suggestion is more readable so I'd say go with it

> 
> Thank,
> Qu
>>
>> Thanks,
>> Su
> 
