Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:37407 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752162AbeGBOmv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 10:42:51 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Marc MERLIN <marc@merlins.org>, Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
References: <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <02ba7ad4-b618-85f0-a99f-c43b25d367de@cn.fujitsu.com>
 <20180629061001.kkmgvdgqfhz23kll@merlins.org>
 <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org>
 <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
 <20180702140527.wfbq5jenm67fvvjg@merlins.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
Date: Mon, 2 Jul 2018 22:42:40 +0800
MIME-Version: 1.0
In-Reply-To: <20180702140527.wfbq5jenm67fvvjg@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月02日 22:05, Marc MERLIN wrote:
> On Mon, Jul 02, 2018 at 02:22:20PM +0800, Su Yue wrote:
>>> Ok, that's 29MB, so it doesn't fit on pastebin:
>>> http://marc.merlins.org/tmp/dshelf2_inspect.txt
>>>
>> Sorry Marc. After offline communication with Qu, both
>> of us think the filesystem is hard to repair.
>> The filesystem is too large to debug step by step.
>> Every time check and debug spent is too expensive.
>> And it already costs serveral days.
>>
>> Sadly, I am afarid that you have to recreate filesystem
>> and reback up your data. :(
>>
>> Sorry again and thanks for you reports and patient.
> 
> I appreciate your help. Honestly I only wanted to help you find why the
> tools aren't working. Fixing filesystems by hand (and remotely via Email
> on top of that), is way too time consuming like you said.
> 
> Is the btrfs design flawed in a way that repair tools just cannot repair
> on their own? 

For short and for your case, yes, you can consider repair tool just a
garbage and don't use them at any production system.

For full, it depends. (but for most real world case, it's still flawed)
We have small and crafted images as test cases, which btrfs check can
repair without problem at all.
But such images are *SMALL*, and only have *ONE* type of corruption,
which can represent real world case at all.

> I understand that data can be lost, but I don't understand how the tools
> just either keep crashing for me, go in infinite loops, or otherwise
> fail to give me back a stable filesystem, even if some data is missing
> after that.

There are several reasons here that repair tool can't help much:

1) Too large fs (especially too many snapshots)
   The use case (too many snapshots and shared extents, a lot of extents
   get shared over 1000 times) is in fact a super large challenge for
   lowmem mode check/repair.
   It needs O(n^2) or even O(n^3) to check each backref, which hugely
   slow the progress and make us hard to locate the real bug.

2) Corruption in extent tree and our objective is to mount RW
   Extent tree is almost useless if we just want to read data.
   But when we do any write, we needs it and if it goes wrong even a
   tiny bit, your fs could be damaged really badly.

   For other corruption, like some fs tree corruption, we could do
   something to discard some corrupted files, but if it's extent tree,
   we either mount RO and grab anything we have, or hopes the
   almost-never-working --init-extent-tree can work (that's mostly
   miracle).

So, I feel very sorry that we can't provide enough help for your case.

But still, we hope to provide some tips on next build if you still want
to choose btrfs.

1) Don't keep too many snapshots.
   Really, this is the core.
   For send/receive backup, IIRC it only needs the parent subvolume
   exists, there is no need to keep the whole history of all those
   snapshots.
   Keep the number of snapshots to minimal does greatly improve the
   possibility (both manual patch or check repair) of a successful
   repair.
   Normally I would suggest 4 hourly snapshots, 7 daily snapshots, 12
   monthly snapshots.

2) Don't keep unrelated snapshots in one btrfs.
   I totally understand that maintain different btrfs would hugely add
   maintenance pressure, but as explains, all snapshots share one
   fragile extent tree.
   If we limit the fragile extent tree from each other fs, it's less
   possible a single extent tree corruption to take down the whole fs.

Thanks,
Qu

> 
> Thanks,
> Marc
> 
