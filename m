Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37240 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753895AbcGZBgX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jul 2016 21:36:23 -0400
Subject: Re: [BTRFS-PROGS][PATCH] Add two new commands: 'btrfs insp
 physical-find' and 'btrfs insp physical-dump'
To: <kreijack@inwind.it>, <linux-btrfs@vger.kernel.org>
References: <1469358209-9427-1-git-send-email-kreijack@libero.it>
 <6bfe86bd-990f-3f04-da9f-7b6fc3c09d12@cn.fujitsu.com>
 <fb09fd3a-583b-b7f0-a2ef-1c3a740c9f40@libero.it>
CC: <dsterba@suse.cz>, Chris Mason <clm@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f0f1753e-7302-b3fc-7684-15a2a28bb01f@cn.fujitsu.com>
Date: Tue, 26 Jul 2016 09:32:52 +0800
MIME-Version: 1.0
In-Reply-To: <fb09fd3a-583b-b7f0-a2ef-1c3a740c9f40@libero.it>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 07/26/2016 01:14 AM, Goffredo Baroncelli wrote:
> On 2016-07-25 04:14, Qu Wenruo wrote:
>> Hi Goffredo,
>>
>> At 07/24/2016 07:03 PM, Goffredo Baroncelli wrote:
>>> Hi all,
>>>
>>> the following patches add two new commands: 1) btrfs
>>> inspect-internal physical-find 2) btrfs inspect-internal
>>> physical-dump
>>>
>>> The aim of these two new commands is to locate (1) and dump (2) the
>>> stripe elements stored on the disks. I developed these two new
>>> command to simplify the debugging of some RAID5 bugs (but this is
>>> another discussion).
>>
>> That's pretty nice function. However the function seems to be a
>> combination of fiemap(to resolve file to logical) and resolve logical
>> (to resolve logical to on-device bytenr), with RAID5/6 specific
>> flags.
>>
>>
>> Instead of introduce a new functions doing a combination of existing
>> features, would you mind expanding current logical-resolve?
>
> [I suppose that you are referring to ./btrfs-map-logical and not logical-resolve]

Oh sorry, I misunderstand the recent trend to merge standalone tools 
into btrfs.
>
> Before developing these two utils, I was unaware of logical-resolve.
>
> Frankly speaking I am skeptical to extend btrfs-map-logical, which is
> outside the "btrfs" family function. So I consider it as legacy code: the one
> which should not be extended, because it was born as "a quick and dirty" utility.

IIRC, there is the trend to merge such tools into inspect-internal 
subcommands.

>
> Finally, there is a big differences between my tools and btrfs-map-logical.
> The former needs a mounted filesystem, the latter doesn't.

Oh, I really missed the difference.
So your tools is based on tree search ioctl, not the offline tree search.

And in that case, your tool is totally useful then, as we don't have any 
online tool for that purpose yet.
>
>>
>> IMHO, it's not a good idea to cross two different logical
>> layers(file<->logical mapping layer and logical<->dev exten mapping
>> layer) in one function.
>
> Indeed, it was the goal. The use case it a tool to help to
> find bug in the raid5 code. Before my tools, I used some hacks to
> parse the output of filefrag and combing this with btrfs-debug-tree info..
> So I develop "btrfs insp physical-find". Then Chris asked me to make a
> further step, so I made 'btrfs insp physical-dump'. I think that definitely
> we need a tool like "btrfs insp physical-find/dump".
>
> If you think that btrfs-map-logical has its use case, I can develop
> further physical-dump/find to start from a "logical" address instead of
> a file: it would be a lot more simple to me than extend btrfs-map-logical.

Please do it, and this makes it possible to inspect metadata extents too.

And it can also make the code easier to use from other subcommand.

Thanks,
Qu

>
>>
>> Thanks, Qu
>>>
>>> An example of 'btrfs inspect-internal physical-find' is the
>>> following:
>>>
>>> # btrfs inspect physical-find mnt/out.txt mnt/out.txt: 0 devid: 3
>>> dev_name: /dev/loop2 offset: 61931520 type: DATA devid: 2 dev_name:
>>> /dev/loop1 offset: 61931520 type: OTHER devid: 1 dev_name:
>>> /dev/loop0 offset: 81854464 type: PARITY devid: 4 dev_name:
>>> /dev/loop3 offset: 61931520 type: PARITY
>>>
>>> In the output above, DATA is the stripe elemnt conaining data.
>>> OTHER is the sibling stripe elemnt: it contains data related to or
>>> other files or to the same file but different position. The two
>>> stripe elements contain the RAID6 parity (P and Q).
>>>
>>> It is possible to pass the offset of the file to inspect.
>>>
>>> An example of 'btrfs inspect-internal physical-dump' is the
>>> following
>>>
>>> # btrfs insp physical-find mnt/out.txt mnt/out.txt: 0 devid: 5
>>> dev_name: /dev/loop4 offset: 56819712 type: OTHER devid: 4
>>> dev_name: /dev/loop3 offset: 56819712 type: OTHER devid: 3
>>> dev_name: /dev/loop2 offset: 56819712 type: DATA devid: 2 dev_name:
>>> /dev/loop1 offset: 56819712 type: PARITY devid: 1 dev_name:
>>> /dev/loop0 offset: 76742656 type: PARITY
>>>
>>> # btrfs insp physical-dump mnt/out.txt | xxd mnt/out.txt: 0 file:
>>> /dev/loop2 off=56819712 00000000: 6164 6161 6161 6161 6161 6161
>>> 6161 6161  adaaaaaaaaaaaaaa 00000010: 6161 6161 6161 6161 6161 6161
>>> 6161 6161  aaaaaaaaaaaaaaaa 00000020: 6161 6161 6161 6161 6161 6161
>>> 6161 6161  aaaaaaaaaaaaaaaa 00000030: 6161 6161 6161 6161 6161 6161
>>> 6161 6161  aaaaaaaaaaaaaaaa 00000040: 6161 6161 6161 6161 6161 6161
>>> 6161 6161  aaaaaaaaaaaaaaaa [...]
>>>
>>> In this case it is dumped the content of the first 4k of the file.
>>> It is possible to pass also an offset (at step of 4k). Moreover it
>>> is possible to select to dump: which copy has to be dumped (switch
>>> -c, only for RAID1/RAID10/DUP); which parity has to be dumped
>>> (switch -p, only for RAID5/RAID6); which stripe element other than
>>> data (switch -s, only for RAID5/RAID6).
>>>
>>> BR G.Baroncelli
>>>
>>>
>>> -- To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>
>>
>> -- To unsubscribe from this list: send the line "unsubscribe
>> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>


