Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1353 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751600AbcF0DE2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 23:04:28 -0400
Subject: Re: [PATCH v11 00/13] Btrfs dedupe framework
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
 <2530830.B25feXa6fV@reserved-192-168-1-6.rchland.ibm.com>
 <fe84125c-12e6-3425-7948-73819a891e77@gmx.com>
 <1761846.d56ix9Vzn2@localhost.localdomain>
CC: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <e0a46109-623c-5f75-cbff-01055cc010d0@cn.fujitsu.com>
Date: Mon, 27 Jun 2016 11:04:13 +0800
MIME-Version: 1.0
In-Reply-To: <1761846.d56ix9Vzn2@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/25/2016 01:45 PM, Chandan Rajendra wrote:
> On Saturday, June 25, 2016 09:22:44 AM Qu Wenruo wrote:
>>
>> On 06/24/2016 05:29 PM, Chandan Rajendra wrote:
>>> On Friday, June 24, 2016 10:50:41 AM Qu Wenruo wrote:
>>>> Hi Chandan, David,
>>>>
>>>> When I'm trying to rebase dedupe patchset on top of Chadan's sub page
>>>> size patchset (using David's for-next-test-20160620), although the
>>>> rebase itself is quite simple, but I'm afraid that I found some bugs for
>>>> sub page size patchset, *without* dedupe patchset applied.
>>>>
>>>> These bugs seems to be unrelated to each other
>>>> 1) state leak at btrfs rmmod time
>>>
>>> The leak was due to not freeing 'cached_state' in
>>> read_extent_buffer_pages(). I have fixed this and the fix will be part of the
>>> patchset when I post the next version to the mailing list.
>>>
>>> I have always compiled the btrfs code as part of the vmlinux image and hence
>>> have never rmmod the btrfs module during my local testing. The space leak
>>> messages might have appeared when I shut down my guest. Hence I had never
>>> noticed them before. Thanks once again for informing me about it.
>>>
>>>> 2) bytes_may_use leak at qgroup EDQUOTA error time
>>>
>>> I have a slightly older version of btrfs-progs which does not yet have btrfs
>>> dedupe" command. I will get the new version and check if the space leak can be
>>> reproduced on my machine.
>>>
>>> However, I don't see the space leak warning messages when the reproducer
>>> script is executed after commenting out "btrfs dedupe enable $mnt".
>>
>> Strange.
>> That dedupe command is not useful at all, as I'm using the branch
>> without the dedupe patchset.
>> Even with btrfs-progs dedupe patchset, dedupe enable only output ENOTTY
>> error message.
>>
>> I'll double check if it's related to the dedupe.
>>
>> BTW, are you testing with 4K page size?
>
> Yes, I executed the script with 4k page size. I had based my patchset on top
> of 4.7-rc2 kernel. If you are interested, you can get the kernel sources at
> 'https://github.com/chandanr/linux subpagesize-blocksize'.
>
> I will soon rebase my patchset on David's master branch. I will let you know
> if I hit the space leak issue on the rebased kernel.
>

Thanks　for your info.

Confirmed that leaked space is unrelated to your sub page size.

It's another patchset causing the bug.
Bisected and I'll inform the author.

Great thanks for your help.
Qu


