Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:41725 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbcFJWjX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 18:39:23 -0400
Subject: Re: Cannot balance FS (No space left on device)
To: ojab // <ojab@ojab.ru>
References: <CAKzrAgRQOvpy3ZVrLHHaRQt-JcjiFSFz6HPGr1vnvBK0xy5xGg@mail.gmail.com>
 <CAPmG0jZUx+V+1eyw1cDpHDkudXqfLQFL9+53Lzb3f0_PGXw+Xw@mail.gmail.com>
 <CAKzrAgTngBtK+eRGFh75GZ3MmuBKYyjbQXjD_LBhE8J-TuN0yg@mail.gmail.com>
 <575B378E.8050304@mendix.com>
 <CAKzrAgTSnSyNV7KO4ERkH1BohdPEzzwbqGVSx3UhET+5PwUH2g@mail.gmail.com>
Cc: Henk Slager <eye1tm@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <575B4198.4050803@mendix.com>
Date: Sat, 11 Jun 2016 00:39:20 +0200
MIME-Version: 1.0
In-Reply-To: <CAKzrAgTSnSyNV7KO4ERkH1BohdPEzzwbqGVSx3UhET+5PwUH2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/11/2016 12:10 AM, ojab // wrote:
> On Fri, Jun 10, 2016 at 9:56 PM, Hans van Kranenburg
> <hans.van.kranenburg@mendix.com> wrote:
>> You can work around it by either adding two disks (like Henk said), or by
>> temporarily converting some chunks to single. Just enough to get some free
>> space on the first two disks to get a balance going that can fill the third
>> one. You don't have to convert all of your data or metadata to single!
>>
>> Something like:
>>
>> btrfs balance start -v -dconvert=single,limit=10 /mnt/xxx/
>
> Unfortunately it fails even if I set limit=1:
>> $ sudo btrfs balance start -v -dconvert=single,limit=1 /mnt/xxx/
>> Dumping filters: flags 0x1, state 0x0, force is off
>>   DATA (flags 0x120): converting, target=281474976710656, soft is off, limit=1
>> ERROR: error during balancing '/mnt/xxx/': No space left on device
>> There may be more info in syslog - try dmesg | tail

Ah, apparently the balance operation *always* wants to allocate some new 
empty space before starting to look more close at the task you give it...

This means that it's trying to allocate a new set of RAID0 chunks 
first... and that's exactly the opposite of what we want to accomplish here.

If you really can add only one extra device now, there's always a more 
dirty way to get the job done.

What you can do for example is:
- partition the new disk in two partitions
- add them both to the filesystem (btrfs doesn't know both block devices 
are on the same physical disk, ghehe)
- convert a small number of data blocks to single
- then device delete the third disk again so the single chunks move back 
to the two first disks
- add the third disk back as one whole block device
- etc...

:D

Moo,

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
