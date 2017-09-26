Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64271 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965481AbdIZMRQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 08:17:16 -0400
Subject: Re: btrfs scrub crashes OS
To: Lukas Pirl <btrfs@lukas-pirl.de>
Cc: linux-btrfs@vger.kernel.org
References: <6e6dc9a3-b3e9-2831-8149-94f7c11b9df1@lukas-pirl.de>
 <67942154-0940-e1f3-318a-6a9a893fe351@gmx.com>
 <f01fc6f7-a0d4-dbae-b5fa-ea51842c4793@lukas-pirl.de>
 <9e86bf20-a686-4c73-22d8-1f8332409c54@gmx.com>
 <e9cfdde0-f07d-c73b-23f0-49ef55709240@lukas-pirl.de>
 <2c7db235-827c-1f17-484b-2a7f8da4810c@gmx.com>
 <2d813e0f-2b9e-90b0-039f-58cc6a55d4e4@lukas-pirl.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <cdf87f77-e6b3-b4cc-a47f-ad86f3111f3d@gmx.com>
Date: Tue, 26 Sep 2017 20:16:43 +0800
MIME-Version: 1.0
In-Reply-To: <2d813e0f-2b9e-90b0-039f-58cc6a55d4e4@lukas-pirl.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月26日 19:50, Lukas Pirl wrote:
> On 09/26/2017 11:36 AM, Qu Wenruo wrote as excerpted:
>> This is strange, this means that we can't find a chunk map for a 72K
>> length data extent.
>>
>> Either the new mapper code has some bug, or it's a big problem.
>> But I think it's more possible for former case.
>>
>> Would you please try to dump the chunk tree (which should be quite
>> small) using the following command?
>>
>> $ btrfs inspect-internal dump-tree -t chunk <device>
> 
> Sure, happy to provide that:
>    https://static.lukas-pirl.de/dump-chunk-tree.txt
> (too large for Pastebin, file will probably go away in a couple of weeks).
> 

Found the needed info.

Your original data extent range is [644337258496, +72K].
Which is just in the range of the following 2 chunks:

---
	item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 643200712704) itemoff 15611 
itemsize 112
		length 1073741824 owner 2 stripe_len 65536 type DATA|RAID1
                 <snip>

	item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 645348196352) itemoff 15499 
itemsize 112
		length 1073741824 owner 2 stripe_len 65536 type DATA|RAID1
		io_align 65536 io_width 65536 sector_size 4096
                 <snip>
---
Those two chunks are covering the ranges of:
[643200712704, +1G)
[645348196352, +1G)

And no other chunk covers the hole between them.
But your original data extent range is in that hole.

So offline scrub output that error messages.
At least the chunk mapping code is correct.

Maybe something is wrong in the extent tree.
But anyway, it shouldn't cause too much trouble in offline scrub as you 
can see, it's a user space program and handles the problem quite well.
(Outputs error message and continue, without panic out)

So reading all your disk may still be needed to wipe out or confirm the 
possibility of the disk IO routine.

Thanks,
Qu

> Cheers,
> 
> Lukas
> 
