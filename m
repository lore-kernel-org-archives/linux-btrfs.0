Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63895 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751238AbbFOIC4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 04:02:56 -0400
Subject: Re: [PATCH RFC] btrfs: csum: Introduce partial csum for tree block.
To: Chris Mason <clm@fb.com>, <linux-btrfs@vger.kernel.org>
References: <1434078015-8868-1-git-send-email-quwenruo@cn.fujitsu.com>
 <557B076B.7050500@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <557E86A9.8040207@cn.fujitsu.com>
Date: Mon, 15 Jun 2015 16:02:49 +0800
MIME-Version: 1.0
In-Reply-To: <557B076B.7050500@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On 06/11/2015 11:00 PM, Qu Wenruo wrote:
>> Introduce the new partial csum mechanism for tree block.
>>
>> [Old tree block csum]
>> 0     4     8    12    16    20    24    28    32
>> -------------------------------------------------
>> |csum |   unused, all 0				|
>> -------------------------------------------------
>> Csum is the crc32 of the whole tree block data.
>>
>> [New tree block csum]
>> -------------------------------------------------
>> |csum0|csum1|csum2|csum3|csum4|csum5|csum6|csum7|
>> -------------------------------------------------
>> Where csum0 is the same as the old one, crc32 of the whole tree block
>> data.
>>
>> But csum1~csum7 will restore crc32 of each eighth part.
>> Take example of 16K leafsize, then:
>> csum1: crc32 of BTRFS_CSUM_SIZE~4K
>> csum2: crc32 of 4K~6K
>> ...
>> csum7: crc32 of 14K~16K
>>
>> This provides the ability for btrfs not only to detect corruption but
>> also to know where corruption is.
>> Further improve the robustness of btrfs.
>>
>> Although the best practise is to introduce new csum type and put every
>> eighth crc32 into corresponding place, but the benefit is not worthy to
>> break the backward compatibility.
>> So keep csum0 and modify csum1 range to keep backward compatibility.
>
> I do like how you're maintaining compatibility here, but I'm curious if
> you have data about situations this is likely to help?  Is there a
> particular kind of corruption you're targeting?
>
> Or is the goal to prevent tossing the whole block, and try to limit it
> to a smaller set of items in a node?
>
> -chris
>
To both Chris and Liu,

In the following case of corruption, RAID1 or DUP will fail to recover
it(Use 16K as leafsize)
0		4K		8K		12K		16K
Mirror 0:
|<-OK---------->|<----ERROR---->|<-----------------OK------------->|

Mirror 1:
|<----------------------------OK--------------->|<------Error----->|

Since the CRC32 stored in header is calculated for the whole leaf,
so both will fail the CRC32 check.

But the corruption are in different position, in fact, if we know where
the corruption is (no need to be so accurate), we can recover the tree
block by using the current part.

In above example, we can just use the correct 0~12K from mirror 1
and then 12K~16K from mirror 0.

And in my patch, since csum1~7 is the csum for each 1/8 parts
(except csum1), so csum1~5 in mirror 1 should pass the CRC32 check,
and csum6~6 in mirror 0 should pass too.

And scrub (or read_tree_block?) should be able to repair the tree block
using the correct parts.
The repair patches are still under coding as it's much harder to
implement with current scrub codes.

Yes, this corruption case may be minor enough, since even corruption in
one mirror is rare enough.
So I didn't introduce a new CRC32 checksum, but use the extra 32-4 bytes
to store the partial CRC32 to keep the backward compatibility.

Thanks,
Qu
