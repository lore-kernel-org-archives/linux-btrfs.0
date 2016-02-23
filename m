Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34920 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754424AbcBWCUb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 21:20:31 -0500
Subject: Re: [Question]: Contributing to btrfs
To: Simon Quigley <tsimonq2@ubuntu.com>, Filipe Manana <fdmanana@gmail.com>
References: <20160220210903.GA3182@carbon.home>
 <20160220224050.GA10864@carbon.home> <56CA61CC.7010703@cn.fujitsu.com>
 <20160222072659.GC17243@carbon.ljdarc.local>
 <CAL3q7H7Ty4R8dQO=MWayn3xzROjRub7uzuGVdM7zMCfU0As1Eg@mail.gmail.com>
 <1456142520.3587.3.camel@ubuntu.com>
 <CAL3q7H7hhaDQ3e2oCW96iwr6NPww-57e9b675oQ-MY6EVTrVQA@mail.gmail.com>
 <CAM2nqdoqHdPbqg6n5=9KbCKwbFm6rM_7qQ+y1S5AfyiAMbWMNw@mail.gmail.com>
 <56CBB6B0.9020307@cn.fujitsu.com> <1456193250.3588.29.camel@ubuntu.com>
CC: Philippe Loctaux <phil@philippeloctaux.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56CBC1E6.9080809@cn.fujitsu.com>
Date: Tue, 23 Feb 2016 10:20:22 +0800
MIME-Version: 1.0
In-Reply-To: <1456193250.3588.29.camel@ubuntu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Simon Quigley wrote on 2016/02/22 20:07 -0600:
>> And, even employed, at least I also went through that phase.
>> (Not to mention I also started by sending small cleanups)
>
> Thank you. I read Linus' statement somewhere, I just can't find it!
>
>> Despite reading the code, which sometimes is quite boring and easy to
>> get lost especially when you are not familiar with btrfs,
>> personally I recommend to start from btrfs on-disk format with
>> btrfs-dedup-tree.
>
> I'll RTFM on this one because I don't know what this is.
>
>> And my personal quick-and-dirty skill up roadmap would be:
>> 1) Understand btrfs on-disk format
>> 2) btrfs-progs contributor
>> 3) btrfs kernel contributor
>
> Should this be documented somewhere?

Btrfs wiki has a Developer's FAQ, which includes how to start contribution.

And my method is just a *QUICK-AND-DIRTY* hack for guys who gets lost in 
codes easily, like myself.

BTW, btrfs wiki also has a lot of info on on-disk format and other 
things to help you get started.

>
>> On-disk data is static and you don't need to care any of the complicated
>> implementation or details.
>> All you need to care is, what is on disk, what's the meaning of that
>> on-disk data, and how on-disk data change after you did something with
>> the btrfs filesystem, like creating a empty file/dir, or write some data
>> into it.
>>
>> Also, when you play with btrfs-debug-tree, it's quite easy to get
>> familiar how btrfs-debug-tree works, and maybe found some easy
>> enhancement for btrfs-debug-tree.
>>
>> On-disk format also provides a super good entry point for further reading.
>>
>> If you want to understand how btrfs inserts file extents, as long as you
>> find file extents use EXTENT_DATA key type, you can easily find the
>> direct code which inserts that key into btrfs btree.
>>
>> With btrfs-debug-tree as a learning tool, you will be quite easy to
>> begin your contribution to btrfs-progs, like adding some output which
>> current btrfs-debug-tree lacks.
>>
>> After you're familiar with btrfs-progs enough, all skills learnt will
>> help you to start your kernel contribution, although kernel is never as
>> easy as btrfs-progs, but I think that's your object.
>
> I agree, because the userspace tool probably uses kernel calls of some sort.

Not all(although a lot of is), btrfs offline progs, like btrfsck is pure 
user-space program, and uses a simplified user-space only implementation.

And that's why I recommend to start from btrfs-progs, just because a lot 
of things is simplified and more easy to understand.

Thanks,
Qu

>
>> I think David, one of the kernel maintainers and btrfs-progs maintainer,
>> and Filipe, one of the core and the most active developer, their words
>> have carries a lot of weight.
>
> I apologize, I'm new around here, I thought Chris was the sole maintainer of all of btrfs. I also
> wanted his additional feedback, but I guess that isn't really needed. :)
>
> For all of you, thank you for taking time to help Philippe and myself out with this. I'm new to
> kernel development and I'd really like to help out with btrfs because I feel it has serious
> potential. I'm glad I learned how to submit patches, and I'll look into the resources suggested. In
> my opinion this should be documented somewhere, a btrfs-specific thing, because I would much rather
> RTFM then have to wait and ask questions (although the latter still is valuable). If you have any
> other feedback for beginning kernel development that you would like to share, please, send me an
> email or PM me on IRC. I'm on #btrfs on Freenode.
>
> Thanks,
> Simon Quigley
> tsimonq2@ubuntu.com
> tsimonq2 on Freenode
>
>


