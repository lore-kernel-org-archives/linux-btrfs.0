Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:36441 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbcBJUB0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 15:01:26 -0500
Received: by mail-ig0-f181.google.com with SMTP id xg9so21491204igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Feb 2016 12:01:26 -0800 (PST)
Subject: Re: BTRFS RAM requirements, RAID 6 stability/write holes and
 expansion questions
To: Chris Murphy <lists@colorremedies.com>
References: <CAKr9ZMFwxZ01gw7SAyFReOfXFb=hVzUXNgYoGcUc2xzLuo+9mg@mail.gmail.com>
 <CAJCQCtQCadspcPie_f6nv=MvC=2=PxxpLbLqtkD3_hBjkBs-zw@mail.gmail.com>
 <56BB41E3.8050906@gmail.com>
 <CAJCQCtS8wDV93Eyb6pDaCJBY7_v8misn1p9e=4KVGdK6=CKL_A@mail.gmail.com>
Cc: Mackenzie Meyer <snackmasterx@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56BB9698.5020203@gmail.com>
Date: Wed, 10 Feb 2016 14:59:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS8wDV93Eyb6pDaCJBY7_v8misn1p9e=4KVGdK6=CKL_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-10 14:06, Chris Murphy wrote:
> On Wed, Feb 10, 2016 at 6:57 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> It's an issue of torn writes in this case, not of atomicity of BTRFS. Disks
>> can't atomically write more than sector size chunks, which means that almost
>> all BTRFS filesystems are doing writes that disks can't atomically complete.
>> Add to that that we serialized writes to different devices, and it becomes
>> trivial to lose some data if the system crashes while BTRFS is writing out a
>> stripe (it shouldn't screw up existing data though, you'll just loose
>> whatever you were trying to write).
>
> I follow all of this. I still don't know how a torn write leads to a
> write hole in the conventional sense though. If the write is partial,
> a pointer never should have been written to that unfinished write. So
> the pointer that's there after a crash should either point to the old
> stripe or new stripe (which includes parity), not to the new data
> strips but an old (stale) parity strip for that partial stripe write
> that was interrupted. It's easy to see how conventional raid gets this
> wrong because it has no pointers to strips, those locations are known
> due to the geometry (raid level, layout, number of devices) and fixed.
> I don't know what rmw looks like on Btrfs raid56 without overwriting
> the stripe - a whole new cow'd stripe, and then metadata is updated to
> reflect the new location of that stripe?
>
I agree, it's not technically a write hole in the conventional sense, 
but the terminology has become commonplace for data loss in RAID{5,6} 
due to a failure somewhere in the write path, and this does fit in that 
sense.  In this case the failure is in writing out the metadata that 
references the blocks instead of in writing out the blocks themselves. 
Even though you don't loose any existing data, you still loose anything 
that you were trying to write out.
>
>
>
>> One way to minimize this which would also boost performance on slow storage
>> would be to avoid writing parts of the stripe that aren't changed (so for
>> example, if only one disk in the stripe actually has changed data, only
>> write that and the parities).
>
> I'm pretty sure that's part of rmw, which is not a full stripe write.
> At least there appears to be some distinction in raid56.c between
> them. The additional optimization that md raid has had for some time
> is the ability during rmw of a single data chunk (what they call
> strips, or the smallest unit in a stripe), they can actually optimize
> the change down to a sector write. So they aren't even doing full
> chunk/strip writes either. The parity strip though I think must be
> completely rewritten.
I actually wasn't aware that BTRFS did this (it's been a while since I 
looked at the kernel code), although I'm glad to hear it does.
>
>
>>>
>>>
>>> If you're worried about raid56 write holes, then a.) you need a server
>>> running this raid where power failures or crashes don't happen b.)
>>> don't use raid56 c.) use ZFS.
>>
>> It's not just BTRFS that has this issue though, ZFS does too,
>
> Well it's widely considered to not have the write hole. From a ZFS
> conference I got this tidbit on how they closed the write hole, but I
> still don't understand why they'd be pointing to a partial (torn)
> write in the first place:
>
> "key insight was realizing instead of treating a stripe as it's a
> "stripe of separate blocks" you can take a block and break it up into
> many sectors and have a stripe across the sectors that is of one logic
> block, that eliminates the write hole because even if the write is
> partial until all of those writes are complete there's not going to be
> an uber block referencing any of that." –Bonwick
> https://www.youtube.com/watch?v=dcV2PaMTAJ4
> 14:45
Again, a torn write to the metadata referencing the block (stripe in 
this case I believe) will result in loosing anything written by the 
update to the stripe.  There is no way that _any_ system can avoid this 
issue without having the ability to truly atomically write out the 
entire metadata tree after the block (stripe) update.  Doing so would 
require a degree of tight hardware level integration that's functionally 
impossible for any general purpose system (in essence, the filesystem 
would have to be implemented in the hardware, not software).
>
>
>> What your using has impact on how you need to do backups.  For someone who
>> can afford long periods of down time for example, it may be perfectly fine
>> to use something like Amazon S3 Glacier storage (which has a 4 hour lead
>> time on restoration for read access) for backups. OTOH, if you can't afford
>> more than a few minutes of down time and want to use BTRFS, you should
>> probably have full on-line on-site backups which you can switch in on a
>> moments notice while you fix things.
>
> Right or use glusterfs or ceph if you need to stay up and running
> during a total brick implosion. Quite honestly, I would much rather
> see Btrfs single support multiple streams per device, like XFS does
> with allocation groups when used on linear/concat of multiple devices;
> two to four per
>
I'm not entirely certain that I understand what you're referring to WRT 
multiple streams per device.

