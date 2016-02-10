Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:33806 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbcBJTG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 14:06:59 -0500
Received: by mail-io0-f179.google.com with SMTP id 9so31671806iom.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Feb 2016 11:06:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56BB41E3.8050906@gmail.com>
References: <CAKr9ZMFwxZ01gw7SAyFReOfXFb=hVzUXNgYoGcUc2xzLuo+9mg@mail.gmail.com>
	<CAJCQCtQCadspcPie_f6nv=MvC=2=PxxpLbLqtkD3_hBjkBs-zw@mail.gmail.com>
	<56BB41E3.8050906@gmail.com>
Date: Wed, 10 Feb 2016 12:06:59 -0700
Message-ID: <CAJCQCtS8wDV93Eyb6pDaCJBY7_v8misn1p9e=4KVGdK6=CKL_A@mail.gmail.com>
Subject: Re: BTRFS RAM requirements, RAID 6 stability/write holes and
 expansion questions
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Mackenzie Meyer <snackmasterx@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 10, 2016 at 6:57 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> It's an issue of torn writes in this case, not of atomicity of BTRFS. Disks
> can't atomically write more than sector size chunks, which means that almost
> all BTRFS filesystems are doing writes that disks can't atomically complete.
> Add to that that we serialized writes to different devices, and it becomes
> trivial to lose some data if the system crashes while BTRFS is writing out a
> stripe (it shouldn't screw up existing data though, you'll just loose
> whatever you were trying to write).

I follow all of this. I still don't know how a torn write leads to a
write hole in the conventional sense though. If the write is partial,
a pointer never should have been written to that unfinished write. So
the pointer that's there after a crash should either point to the old
stripe or new stripe (which includes parity), not to the new data
strips but an old (stale) parity strip for that partial stripe write
that was interrupted. It's easy to see how conventional raid gets this
wrong because it has no pointers to strips, those locations are known
due to the geometry (raid level, layout, number of devices) and fixed.
I don't know what rmw looks like on Btrfs raid56 without overwriting
the stripe - a whole new cow'd stripe, and then metadata is updated to
reflect the new location of that stripe?




> One way to minimize this which would also boost performance on slow storage
> would be to avoid writing parts of the stripe that aren't changed (so for
> example, if only one disk in the stripe actually has changed data, only
> write that and the parities).

I'm pretty sure that's part of rmw, which is not a full stripe write.
At least there appears to be some distinction in raid56.c between
them. The additional optimization that md raid has had for some time
is the ability during rmw of a single data chunk (what they call
strips, or the smallest unit in a stripe), they can actually optimize
the change down to a sector write. So they aren't even doing full
chunk/strip writes either. The parity strip though I think must be
completely rewritten.


>>
>>
>> If you're worried about raid56 write holes, then a.) you need a server
>> running this raid where power failures or crashes don't happen b.)
>> don't use raid56 c.) use ZFS.
>
> It's not just BTRFS that has this issue though, ZFS does too,

Well it's widely considered to not have the write hole. From a ZFS
conference I got this tidbit on how they closed the write hole, but I
still don't understand why they'd be pointing to a partial (torn)
write in the first place:

"key insight was realizing instead of treating a stripe as it's a
"stripe of separate blocks" you can take a block and break it up into
many sectors and have a stripe across the sectors that is of one logic
block, that eliminates the write hole because even if the write is
partial until all of those writes are complete there's not going to be
an uber block referencing any of that." –Bonwick
https://www.youtube.com/watch?v=dcV2PaMTAJ4
14:45


> What your using has impact on how you need to do backups.  For someone who
> can afford long periods of down time for example, it may be perfectly fine
> to use something like Amazon S3 Glacier storage (which has a 4 hour lead
> time on restoration for read access) for backups. OTOH, if you can't afford
> more than a few minutes of down time and want to use BTRFS, you should
> probably have full on-line on-site backups which you can switch in on a
> moments notice while you fix things.

Right or use glusterfs or ceph if you need to stay up and running
during a total brick implosion. Quite honestly, I would much rather
see Btrfs single support multiple streams per device, like XFS does
with allocation groups when used on linear/concat of multiple devices;
two to four per



-- 
Chris Murphy
