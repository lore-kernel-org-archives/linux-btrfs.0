Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:33372 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964997AbcFMMdw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jun 2016 08:33:52 -0400
Received: by mail-io0-f179.google.com with SMTP id d2so31149872iof.0
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jun 2016 05:33:52 -0700 (PDT)
Subject: Re: Cannot balance FS (No space left on device)
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        ojab // <ojab@ojab.ru>
References: <CAKzrAgRQOvpy3ZVrLHHaRQt-JcjiFSFz6HPGr1vnvBK0xy5xGg@mail.gmail.com>
 <CAPmG0jZUx+V+1eyw1cDpHDkudXqfLQFL9+53Lzb3f0_PGXw+Xw@mail.gmail.com>
 <CAKzrAgTngBtK+eRGFh75GZ3MmuBKYyjbQXjD_LBhE8J-TuN0yg@mail.gmail.com>
 <575B378E.8050304@mendix.com>
 <CAKzrAgTSnSyNV7KO4ERkH1BohdPEzzwbqGVSx3UhET+5PwUH2g@mail.gmail.com>
 <575B4198.4050803@mendix.com>
Cc: Henk Slager <eye1tm@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <57d127c6-8362-8d47-79c2-19f60d930858@gmail.com>
Date: Mon, 13 Jun 2016 08:33:44 -0400
MIME-Version: 1.0
In-Reply-To: <575B4198.4050803@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-10 18:39, Hans van Kranenburg wrote:
> On 06/11/2016 12:10 AM, ojab // wrote:
>> On Fri, Jun 10, 2016 at 9:56 PM, Hans van Kranenburg
>> <hans.van.kranenburg@mendix.com> wrote:
>>> You can work around it by either adding two disks (like Henk said),
>>> or by
>>> temporarily converting some chunks to single. Just enough to get some
>>> free
>>> space on the first two disks to get a balance going that can fill the
>>> third
>>> one. You don't have to convert all of your data or metadata to single!
>>>
>>> Something like:
>>>
>>> btrfs balance start -v -dconvert=single,limit=10 /mnt/xxx/
>>
>> Unfortunately it fails even if I set limit=1:
>>> $ sudo btrfs balance start -v -dconvert=single,limit=1 /mnt/xxx/
>>> Dumping filters: flags 0x1, state 0x0, force is off
>>>   DATA (flags 0x120): converting, target=281474976710656, soft is
>>> off, limit=1
>>> ERROR: error during balancing '/mnt/xxx/': No space left on device
>>> There may be more info in syslog - try dmesg | tail
>
> Ah, apparently the balance operation *always* wants to allocate some new
> empty space before starting to look more close at the task you give it...
No, that's not exactly true.  It seems to be a rather common fallacy 
right now that balance repacks data into existing chunks, which is 
absolutely false.  What a balance does is to send everything selected by 
the filters through the allocator again, and specifically prevent any 
existing chunks from being used to satisfy the allocation.  When you 
have 5 data chunks that are 20% used and run 'balance -dlimit=20', it 
doesn't pack that all into the first chunk, it allocates a new chunk, 
and then packs it all into that, then frees all the other chunks.  This 
behavior is actually a pretty important property when adding or removing 
devices or converting between profiles, because it's what forces things 
into the new configuration of the filesystem.

In an ideal situation, the limit filters should make it repack into 
existing chunks when specified alone, but currently that's not how it 
works, and I kind of doubt that that will ever be how it works.
