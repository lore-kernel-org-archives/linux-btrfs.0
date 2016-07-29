Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:52686 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbcG2GpN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 02:45:13 -0400
Subject: Re: [PATCH 2/5] New btrfs command: "btrfs inspect physical-find"
To: kreijack@inwind.it, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1469641398-3879-1-git-send-email-kreijack@libero.it>
 <1469641398-3879-3-git-send-email-kreijack@libero.it>
 <8b013280-7128-d6e4-2f62-b43851d6f6cd@cn.fujitsu.com>
 <2d33450d-3805-da54-a5e8-2fefde075957@libero.it>
 <c5c247b7-2e4d-3f4b-7cc4-b44f749a7a10@cn.fujitsu.com>
 <46c7bfc1-8e7a-3a0e-db56-889cf7a324d3@inwind.it>
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5cc22a84-e8eb-3ef4-14a9-857430334069@gmx.com>
Date: Fri, 29 Jul 2016 14:44:46 +0800
MIME-Version: 1.0
In-Reply-To: <46c7bfc1-8e7a-3a0e-db56-889cf7a324d3@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/29/2016 01:08 PM, Goffredo Baroncelli wrote:
> On 2016-07-29 03:34, Qu Wenruo wrote:
>>> I am not against about your proposal; however I have to point out
>>> that the goal of these command was not to *traverse* the file, but
>>> only to found the physical location of a file offset. My use case
>>> was to simulate a corruption of a raid5 stripe elements: for me it
>>> was sufficient to know the page position.
>>
>> For corruption case, the best practice would be extending
>> btrfs-corrupt-block command.
>>
>> And for your original proposal, to locate a page/sector containing
>> the bytenr/offset, then the returned value should always be aligned
>> to sectorsize. (And we need to state it clear in both man page and
>> help string)
>>
>> Unfortunately, that's not the case in current implementation. (And
>> don't forget future subpage sector size, so in that case, we need to
>> check sectorsize first.)
>>
>> For example, if user passes a unaligned logical, physical-find will
>> return the device offset unaligned.
>
> For the other command (physical-dump), there is a check about the
> alignment; the reason was to simplify the dump of the content.
> However I don't understand to the reason to ask for the alignment
> even in the -find tool: why the output have to be aligned ? Which is
> the difference if I return the first byte address of the file than the
> 2nd or the 3rd (taking in account all the detail, which for raid5/6
> is not very easy....)

Since it's quite easy for user to assume such find tool will dump info 
for the range [offset, offset + 4K(or whatever)).
In that unaligned case, user could get confused about if the tool will 
dump the 4K range, including the next stripe.

Just like map-logical.

So, if you only mean to dump the stripe info which contains the bytenr, 
then makes the doc more clear about the behavior.

Thanks,
Qu


>
>>
>> If only to locate the stripe/sector, at least returning a aligned
>> number seems more reasonable.
>>
>> IMHO if we only want a simple tool, then make it clear it's a just
>> simple tool, and add limitation and explain to make it simple and
>> won't accept any complext/unexpected input.
>>
>> Or, make it handle unexpected and complex input well.
>>
>>
>> BTW, long time ago, btrfs-map-logical is under the same situation,
>> just a simple tool do off-line logical->device offset mapping. But it
>> since it does provides offset/length pair options, it can cause wrong
>> or uesless result for unaligned input. And we spent some time to
>> improve it.
>>
>> So I hope we can avoid such problem which has already happened in
>> map-logical.
>
>
