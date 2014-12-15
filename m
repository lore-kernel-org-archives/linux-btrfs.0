Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:60445 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384AbaLOJhE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 04:37:04 -0500
Message-ID: <548EABBB.4060204@pobox.com>
Date: Mon, 15 Dec 2014 01:36:59 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Grzegorz Kowal <custos.mentis@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] Btrfs: get more accurate output in df command.
References: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com>	<548B4117.1040007@inwind.it>	<CA+qeAOokzptsxMKJaQwtVSFe5UxYuZnx5E22iMjRqM4AsuN8bA@mail.gmail.com>	<CABmMA7tw9BDsBXGHLO4vjcO4gaYmZPb_BQV8w22griqFvCJpPA@mail.gmail.com> <CABmMA7vtHzUYAhnEfpnx3Fx93SJyx=Qqoaz-PyQcivo=51jKsA@mail.gmail.com> <548E377D.6030804@cn.fujitsu.com> <548E7A7A.90505@pobox.com> <548E929B.2090203@pobox.com> <548E9B38.9080202@cn.fujitsu.com>
In-Reply-To: <548E9B38.9080202@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/15/2014 12:26 AM, Dongsheng Yang wrote:
> On 12/15/2014 03:49 PM, Robert White wrote:
>> On 12/14/2014 10:06 PM, Robert White wrote:
>>> On 12/14/2014 05:21 PM, Dongsheng Yang wrote:
>>>> Anyone have some suggestion about it?
>>> (... strong advocacy for raw numbers...)
>
> Hi Robert, thanx for your so detailed reply.
>
> You are proposing to report the raw numbers in df command, right?

Wrong. Well partly wrong. You didn't include the "geometrically 
unavailable" calculation from my suggestion. And you've largely ignored 
the commentary and justifications from the first email.

See, all the solutions being discussed basically drop out the hard 
parts. For instance god save your existing patch from a partially 
complete conversion. I'll bet we could get into negative @available 
numbers if we abort halfway through conversion between raid levels zero 
and one.

If we have two disks of 5GiB and they _were_ at RAID0 and we start a 
-dconvert to RAID1 and abort it or run out of space because there were 
7GiB in use... then what? If size is now 5GiB and used is now 6GiB but 
we've still got 1GiB available... well _how_ exactly is that _better_ 
information?


> Let's compare the space information in FS level and Device level.
>
> Example:
> /dev/sda == 1TiB
> /dev/sdb == 2TiB
>
> mkfs.btrfs /dev/sda /dev/sdb -d raid1
>
> (1). If we report the raw numbers in df command, we will get the result of
> @size=3T, @used=0 @available=3T. It's not a bad idea until now, as you said
> user can consider the raid when they are using the fs. Then if we fill
> 1T data
> into it. we will get @size=3, @used=2T, @avalable=1T. And at this
> moment, we
> will get ENOSPC when writing any more data. It's unacceptable.  Why you
> tell me there is 1T space available, but I can't write one byte into it?

See the last segment below where I addressed the idea of geometrically 
unavailable space. It explains why, in this case, available would have 
been 0TiB not 1TiB.

The solution has to be correct for all uses and BTRFS _WILL_ eventually 
reach a condition where _either_ @available will be zero but you can 
still add some small files, or @available will be non-zero but you 
_can't_ any large files.

It is _impossible_ _to_ _avoid_ both outcomes because the two modalities 
of file storage are incompatable.

We have mixed the metaphor of file storage and raw storage. We have done 
so with a dynamically self-restructuring system. As such we don't have a 
completely consistent option.

For instance, what happens when the user adds a third 1TiB drive to your 
example?

So we need to account, at a system-wide level, for every byte of 
storage. We need to then make as few assumptions as possible, but no 
fewer, when reporting the subsets of information to the tools that were 
invented before we stretched the paradigm outside that box.

>
> (2). Actually, there was an elder btrfs_statfs(), it reported the raw
> numbers to user.
> To solve the problem mentioned in (1), we need report the space
> information in the FS level.

No, we need to report the availability at the _raw_ level, but subtract 
the "absolutely inaccessable" tidbits. In short we need to report at the 
_storage_ _management_ _level_ w

So your example sizes in my methodology would report

SIZE=2TiB USED=0 AVAILABLE=2TiB

And if you wrote exactly 1GiB of data to that filesystem it would show

SIZE=2TiB USED=2GiB AVAILABLE=1.99TiB

because that one 1GiB took 2GiB to store. No attempt would be made to 
make the filesystem appear 1TiB-ish. The operator knows its RAID1 so he 
knows it will be sucked down at a 2x rate.

And when the user said "WTF" regarding the missing 1TiB he'd be directed 
to show-super and the 1TiB "unavailable because of geometry".

But if the user built the filesystem with btrfs device add and never 
rebalanced it, absolutely no attempt would be made to "protect him" from 
the knowledge that he could "run out of space" while still having blocks 
available.

mkfs.btrfs /dev/sda
(time pases)
btrfs device add /dev/sdd /mountpoint

Would show SIZE=3TiB (etc) and would take no steps to warn about the 
possibly jammed up condition caused by the existing concentration 
duplicate metata on /dev/sda.

> Current btrfs_statfs() is designed like this, but not working in any cases.
> My new btrfs_statfs() here is following this design and implementing it
> to show a *better* output to user.
>
> Thanx
> Yang
>>
>> Concise Example to attempt to be clearer:
>>
>> /dev/sda == 1TiB
>> /dev/sdb == 2TiB
>> /dev/sdc == 3TiB
>> /dev/sdd == 3TiB
>>
>> mkfs.btrfs /dev/sd{a..d} -d raid0
>> mount /dev/sda /mnt
>>
>> Now compare ::
>>
>> #!/bin/bash
>> dd if=/dev/urandom of=/mnt/example bs=1G
>>
>> vs
>>
>> #!/bin/bash
>> typeset -i counter
>> for ((counter=0;;counter++)); do
>> dd if=/dev/urandom of=/mnt/example$conter bs=44 count=1
>> done
>>
>> vs
>>
>> #!/bin/bash
>> typeset -i counter
>> for ((counter=0;;counter++)); do
>> dd if=/dev/urandom of=/mnt/example$conter bs=44 count=1
>> done &
>> dd if=/dev/urandom of=/mnt/example bs=1G
>>
>> Now repeat the above 3 models for
>> mkfs.btrfs /dev/sd{a..d} -d raid5
>>
>>
>> ......
>>
>> As you watch these six examples evolve you can ponder the ultimate
>> futility of doing adaptive prediction within statfs().
>>
>> Then go back and change the metadata from the default of RAID1 to
>> RAID5 or RAID6 or RAID10.
>>
>> Then go back and try
>>
>> mkfs.btrfs /dev/sd{a..d} -d raid10
>>
>> then balance when the big file runs out of space, then resume the big
>> file with oflag=append
>>
>> ......
>>
>> Unlike _all_ our predecessors, we are active at both the semantic file
>> storage level _and_ the physical media management level.
>>
>> None of the prior filesystems match this new ground exactly.
>>
>> The only real option is to expose the raw numbers and then tell people
>> the corner cases.
>>

=== Re-read from here down ===

>> Absolutely unavailable blocks, such as the massive waste of 5TiB in
>> the above sized media if raid10 were selected for both data and
>> metadata would be subtracted from size if and only if it's
>> _impossible_ for it to be accessed by this sort of restriction. But
>> even in this case, the correct answer for size is 4TiB because that
>> exactly answers "how big is this filesystem".
>>
>> It might be worth having a "dev_item.bytes_excluded" or unusable or
>> whatever to account for the difference between total_bytes and
>> bytes_used and the implicit bytes available. This would account for
>> the 0,1,2,2 TiB that a raid10 of the example sizes could never reach
>> in the current geometry. I'm betting that this sort of number also
>> shows up as some number of sectors in any filesystem that has an odd
>> tidbit of size up at the top where no structure is ever gong to fit.
>> That's just a feature of the way disks use GB instead of GiB and msdos
>> style partitions love the number 63.
>>
>> So resize sets the size. Geometry limitations may reduce the effective
>> size by some, or a _lot_, but then the used-vs-available should _not_
>> try to correct for whatever geometry is in use. Even when it might be
>> simple because if it does it well in the simple cases like
>> raid10/raid10, it would have to botch it up on the hard cases.
>>
>>
>> .
>>
>
>

So we don't just hand-wave over statfs(). We include the 
dev_item.bytes_excluded in the superblock and we decide once-and-for-all 
(with any geometry creation, or completed conversion) how many bytes 
just _can't_ be reached but only once we _know_ they cant be reached. 
And we memorialize that unreachable data in the superblocks.

Thereafter we report the raw numbers after subtracting anything we know 
cannot be reached.

All other "helpful" solutions are NP-complete and insoluble.

