Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36351 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751203AbaL3Akq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 19:40:46 -0500
Message-ID: <54A1F48A.1080906@cn.fujitsu.com>
Date: Tue, 30 Dec 2014 08:40:42 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] btrfs: Enhance btrfs chunk allocation algorithm
 to reduce ENOSPC caused by unbalanced data/metadata allocation.
References: <1419386114-21703-1-git-send-email-quwenruo@cn.fujitsu.com> <1419386114-21703-2-git-send-email-quwenruo@cn.fujitsu.com> <20141229145619.GG6490@twin.jikos.cz>
In-Reply-To: <20141229145619.GG6490@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH v2 2/2] btrfs: Enhance btrfs chunk allocation 
algorithm to reduce ENOSPC caused by unbalanced data/metadata allocation.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年12月29日 22:56
> On Wed, Dec 24, 2014 at 09:55:14AM +0800, Qu Wenruo wrote:
>> When btrfs allocate a chunk, it will try to alloc up to 1G for data and
>> 256M for metadata, or 10% of all the writeable space if there is enough
>> space for the stripe on device.
>>
>> However, when we run out of space, this allocation may cause unbalanced
>> chunk allocation.
>> For example, there are only 1G unallocated space, and request for
>> allocate DATA chunk is sent, and all the space will be allocated as data
>> chunk, making later metadata chunk alloc request unable to handle, which
>> will cause ENOSPC.
> The question is why the metadata is full although there's 1G free, as
> the metadata chunks are being preallocated according to the metadata
> ratio.
This can still happen after the data chunk is allocated but later only 
heavy metadata workload.
>
>> This is the one of the common complains from end users about why ENOSPC
>> happens but there is still available space.
>>
>> This patch will try not to alloc chunk which is more than half of the
>> unallocated space, making the last space more balanced at a small cost
>> of more fragmented chunk at the last 1G.
> I'm really worried about the small chunks and the fragmentation on that
> level wrt balancing. The small chunks will be relolcated to bigger free
> chunks (eg. 256mb) and make it unusable for further rebalancing of the
> 256mb chunks. Newly allocated chunks will have to be reduced in size to
> fit in the remaining place and will cause further fragmentation of the
> chunk space.
>
> The drawbacks of small chunks are obvious:
>
> * more chunks mean more processing
> * smaller chance of getting big contiguous space for extents, leading to
>    file fragmentation that cannot be much improved fixed by
>    defragmentation
You're right, such half-half method will mess up with relocate, that's I 
forgot.
>
> IMO the chunk allocation should be more predictable and should give some
> clue how the layout happens, otherwise this will become another dark
> corner that would make debugging harder and can negatively and
> unpreditactably affect performance after some time.
Some other methods also come to me, like predict the data:metadata ratio 
using current or recent
allocated data:metadata ratio, but it seems not help for the last 1GB case.

Or when it comes to the last 1GB, allocate it as mixed(data+metadata) ?
It seems needs new incompat flags and some tweaks on relocate.

Thanks,
Qu
>
> The problems you're trying to address are real, no doubt here, but I'd
> rather try to address them in a different way.

