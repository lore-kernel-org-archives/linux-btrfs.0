Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25344 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750721AbbDWGVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 02:21:40 -0400
Message-ID: <55388F73.8060000@cn.fujitsu.com>
Date: Thu, 23 Apr 2015 14:21:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Lukas Lueg <lukas.lueg@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Add extra check for sub_stripes to avoid hostile
 0 division attack.
References: <1429758045-27027-1-git-send-email-quwenruo@cn.fujitsu.com> <CAJF-kYnhho8RA3WyVfC6oQZXfdcNJ+7Wud6LJBBeKrEovsVfdQ@mail.gmail.com>
In-Reply-To: <CAJF-kYnhho8RA3WyVfC6oQZXfdcNJ+7Wud6LJBBeKrEovsVfdQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

IMHO Zeroing the RAID10 bit is not a good idea to "repair".

As in that case, since the csum matched, normally we should trust
whatever we read. But if RAID10 bit is set but sub_stripe is still 0,
we are not sure whether the RAID10 bit or the sub_stripe value is wrong.

So what we know is, something unexpected happened. Normally
we will call a BUG_ON(), but that will crash the kernel anyway, so we 
can only return -EINVAL and abort the mount process.

Thanks,
Qu

-------- Original Message  --------
Subject: Re: [PATCH] btrfs: Add extra check for sub_stripes to avoid 
hostile 0 division attack.
From: Lukas Lueg <lukas.lueg@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年04月23日 14:07

> I didn't check but "repair" should be made able to fix this situation
> on an existing fs fairly easily by zeroing the BLOCK_GROUP_RAID10-bit
> in case sub_stripes is zero or some unreasonable number and set the
> bit in case sub_stripes has a reasonable, small value.
>
> 2015-04-23 5:00 GMT+02:00 Qu Wenruo <quwenruo@cn.fujitsu.com>:
>> Although only RAID10 use sub_stripes, a hostile attack can modify chunk
>> tree and just add RAID10 bit to a single chunk.
>> Then btrfs_map_block will trigger a 0 division in kernel and destroy
>> everything.
>>
>> Just add extra check when reading chunk from disk.
>>
>> Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>   fs/btrfs/volumes.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 8222f6f..a764726 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -6061,6 +6061,14 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
>>          map->stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
>>          map->type = btrfs_chunk_type(leaf, chunk);
>>          map->sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
>> +
>> +       /* Add extra check to avoid hostile 0 division attack */
>> +       if (map->type & BTRFS_BLOCK_GROUP_RAID10 &&
>> +           map->sub_stripes == 0) {
>> +               free_extent_map(em);
>> +               return -EINVAL;
>> +       }
>> +
>>          for (i = 0; i < num_stripes; i++) {
>>                  map->stripes[i].physical =
>>                          btrfs_stripe_offset_nr(leaf, chunk, i);
>> --
>> 2.3.5
>>
