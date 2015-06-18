Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12956 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754600AbbFRBeF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 21:34:05 -0400
Subject: Re: [PATCH RFC] btrfs: csum: Introduce partial csum for tree block.
To: <dsterba@suse.cz>, Chris Mason <clm@fb.com>, <linux-btrfs@vger.kernel.org>
References: <1434078015-8868-1-git-send-email-quwenruo@cn.fujitsu.com>
 <557B076B.7050500@fb.com> <557E86A9.8040207@cn.fujitsu.com>
 <20150615131507.GL6761@twin.jikos.cz> <557F7A5F.5010206@cn.fujitsu.com>
 <557F8C78.7080304@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55822008.1090305@cn.fujitsu.com>
Date: Thu, 18 Jun 2015 09:34:00 +0800
MIME-Version: 1.0
In-Reply-To: <557F8C78.7080304@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ping?

New new comments?

Thanks,
Qu

Qu Wenruo wrote on 2015/06/16 10:39 +0800:
>
>
> Qu Wenruo wrote on 2015/06/16 09:22 +0800:
>>
>>
>> David Sterba wrote on 2015/06/15 15:15 +0200:
>>> On Mon, Jun 15, 2015 at 04:02:49PM +0800, Qu Wenruo wrote:
>>>> In the following case of corruption, RAID1 or DUP will fail to recover
>>>> it(Use 16K as leafsize)
>>>> 0        4K        8K        12K        16K
>>>> Mirror 0:
>>>> |<-OK---------->|<----ERROR---->|<-----------------OK------------->|
>>>>
>>>> Mirror 1:
>>>> |<----------------------------OK--------------->|<------Error----->|
>>>>
>>>> Since the CRC32 stored in header is calculated for the whole leaf,
>>>> so both will fail the CRC32 check.
>>>>
>>>> But the corruption are in different position, in fact, if we know where
>>>> the corruption is (no need to be so accurate), we can recover the tree
>>>> block by using the current part.
>>>>
>>>> In above example, we can just use the correct 0~12K from mirror 1
>>>> and then 12K~16K from mirror 0.
>>>
>>> If the mirror 0 copy is intact, you can use it entirely. Your
>>> improvement could help if each mirror is partially broken but we can
>>> find good copies of all 4k blocks among all mirrors.
>>>
>>> The natural question is how often this happens and if it's worth adding
>>> the code complexity and what's the estimated speed drop.
>>>
>>> I think the conditions are very rare and that we could add minimal code
>>> to attempt to build the metadata block from the available copies without
>>> the separate block checksums. This is an immediate idea so I could have
>>> missed something:
>>>
>>> * if a metadata-block checksum mismatches, do a direct comparison of the
>>>    metadata-blocks in all available mirrors
>>>    * if they match and checksums match, no help, it's damaged
>>>    * if there's a good copy (ie the original checksum or data were
>>>      corrupted), use it
>>>    * otherwise attempt to rebuild the metadata block from what's
>>> available
>>>
>>> * by direct comparisons of the 4k blocks, find the first where the
>>>    metadataA and mirror1 blocks mismatch, offset N
>>> * try to compute the checksum from metadataA[0..N-1] + mirror1 block N +
>>>    rest of metadataA
>>>    * if it's ok, use it
>>>    * if not: the block N is corrupted in mirror1 (we've skipped it in
>>>      metadataA)
>>>      then repeat with metadataA[0..N] + mirror1[N+1..end]
>> The method sounds good, but the codes will be even more complex than
>> mine.
>> Also, due to the nature of CRC32 and RAID1/Dup case, things will be
>> quite complex like the following case using your method.
>>
>> 0    4K    8K    12K    16K
>> Mirror 0
>> |    |   X    |    |    |
>> Mirror 1
>> |    |    |   X    |    |
>>
>> If using your method:
>> [0~4K]
>> CRC32 of 0~4K are the same. No problem.
>>
>> [4~8K]
>> CRC32 of 0~8K differs.
>> Now we know there is something wrong with 4~8K, but we still don't know
>> which is the good copy.
>>
>> We can continue, keep 2 different CRC32 seed for later checksum.
>> One seed using the 4~8 from mirror 0 and one from mirror1.
>>
>> Note, the crc32 is for the whole tree block, so until we calculate all
>> the tree block, we can know which one is correct.
> Sorry here, "can" -> "can't"
>
> Thanks,
> Qu
>>
>> [8~12K]
>> Now crc32 mismatches again.
>> We still don't know which part is correct.
>>
>> We can still continue by recording different CRC32 seed for them.
>> But don't forget the previous 2 seeds we recorded.
>> So we records 4 crc32 seeds for 0~12K.(Mi0, Mi0) (Mi0, Mi1) (Mi1, Mi0)
>> (Mi1, Mi1).
>>
>> [12~16K]
>> Continue calculate the crc32 with above 4 seeds.
>> Finally, we found the crc32 matches with the tree block is using the
>> combination of (Mi1, Mi0). And we can restore the tree block.
>>
>> Yes, with this behavior, we can restore the tree block even 3 parts are
>> corrupted, but in that case, we need to try 8 times.
>>
>> So, I don't consider this is more easy to implement than my idea.
>>
>> [ROOT CAUSE]
>> The root cause of the complex is:
>> 1) Checksum algorithm depends on previous input(seed)
>> Almost all checksum algorithm depends on previous input.
>> And you won't know the data is correct or not until all data is
>> calculated.
>>
>> 2) Only one extra duplication for RAID1/DUP
>> We don't have extra duplication to judge which block is correct as there
>> are only two mirror.
>>
>> So my partial checksum solves the 2 root cause at the same time.
>> With partial checksum, we don't depend on previous data to calculate
>> checksum.
>> And we have extra reference if mirror differs with each other, we use
>> checksum to judge which copy is correct.
>>
>>>
>>> That's a rough idea that I hope will cover most of the cases when it
>>> happens. With some more exhaustive attempts to rebuild the metadata
>>> block we can try to repair 2 damaged blocks.
>>>
>>> As this is completely independent, we can test it separately, and also
>>> add it as a rescue feature to the userspace tools.
>>>
>>>> Yes, this corruption case may be minor enough, since even corruption in
>>>> one mirror is rare enough.
>>>> So I didn't introduce a new CRC32 checksum, but use the extra 32-4
>>>> bytes
>>>> to store the partial CRC32 to keep the backward compatibility.
>>>
>>> The above would work with any checksums, without the need to store the
>>> per-block checksums which become impossible with strongher algorithms.
>>>
>> [FURTHER CSUM DESIGN]
>> As you mentioned in later part, yes, stronger checksum like SHA256 won't
>> be able to do such partial checksum as it uses all the space.
>>
>> But that's already a trade-off, right?
>>
>> If btrfs was using partial csum from the beginning, pros and cons of
>> strong checksum should be quite obvious:
>>
>> Stronger checksum:
>> (Pros)
>> 1. Less confliction
>> Which means more security.
>>
>> (Cons)
>> 1. More space usage for data.
>> 4Bytes/4K vs 32Bytes/4K. Obvious.
>>
>> 2. No/less partial checksum for metadata.
>> Harder to detect/repair partial error.
>>
>> 3. (generally) More CPU time
>> Normally, stronger checksums are cryptographic checksum, which uses
>> more CPU time.
>>
>> So with this patch, I also want to inspire other developers about the
>> trade off between different checksums.
>> Especially the fact, we can make better use of the spare metadata csum
>> space if the csum length is less than 32bytes.
>>
>> Thanks,
>> Qu
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
