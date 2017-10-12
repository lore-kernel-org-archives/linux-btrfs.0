Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:51798 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753277AbdJLRTl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 13:19:41 -0400
Received: by mail-io0-f178.google.com with SMTP id b186so6261373iof.8
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 10:19:41 -0700 (PDT)
Subject: Re: USB upgrade fun
To: Chris Murphy <lists@colorremedies.com>, Kai Hendry <hendry@iki.fi>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1507456690.745489.1131538472.25270157@webmail.messagingengine.com>
 <CAJCQCtRnbz5WGqZEO3b8a+3B2gDbG_zioqWEVoJz_dD0SB=6Ww@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0a3e71f7-1a8e-9a4f-7470-4c5cc2fb11a0@gmail.com>
Date: Thu, 12 Oct 2017 13:19:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRnbz5WGqZEO3b8a+3B2gDbG_zioqWEVoJz_dD0SB=6Ww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-12 12:57, Chris Murphy wrote:
> On Sun, Oct 8, 2017 at 10:58 AM, Kai Hendry <hendry@iki.fi> wrote:
>> Hi there,
>>
>> My /mnt/raid1 suddenly became full somewhat expectedly, so I bought 2
>> new USB 4TB hard drives (one WD, one Seagate) to upgrade to.
>>
>> After adding sde and sdd I started to see errors in dmesg [2].
>> https://s.natalian.org/2017-10-07/raid1-newdisks.txt
>> [2] https://s.natalian.org/2017-10-07/btrfs-errors.txt
> 
> I'm not sure what the call traces mean exactly but they seem
> non-fatal. The entire dmesg might be useful to see if there are device
> or bus related errors.
> 
> I have a similar modeled NUC and I can tell you for sure it does not
> provide enough USB bus power for 2.5" laptop drives. They must be
> externally powered, or you need a really good USB hub with an even
> better power supply that can handle e.g. 4 drives at the same time to
> bus power them. I had lots of problems before I fixed this, but Btrfs
> managed to recover gracefully once I solved the power issue.
Same here on a pair of 3 year old NUC's.  Based on the traces and the 
other information, I'd be willing to bet this is probably the root cause 
of the issues.>>
>> I assumed it had to perhaps with the USB bus on my NUC5CPYB being maxed
>> out, and to expedite the sync, I tried to remove one of the older 2TB
>> sdc1.  However the load went crazy and my system went completely
>> unstable. I shutdown the machine and after an hour I hard powered it
>> down since it seemed to hang (it's headless).
> 
> I've notice recent kernels hanging under trivial scrub and balance
> with hard drives. It does complete, but they are really laggy and
> sometimes unresponsive to anything else unless the operation is
> cancelled. I haven't had time to do regression testing. My assertion
> about this is in the archives, about versions I think it started with.
>>
>> Sidenote: I've since learnt that removing a drive actually deletes the
>> contents of the drive? I don't want that. I was hoping to put that drive
>> into cold storage. How do I remove a drive without losing data from a
>> RAID1 configuration?
> 
> I'm pretty sure, but not certain of the following:  device
> delete/remove is replicating chunk by chunk cow style. The entire
> operation is not atomic. The chunk operations themselves are atomic. I
> expect that metadata is updated as each chunk is properly replicated
> so I don't think what you want is possible.
This is correct.  Deleting a device first marks that device as zero size 
so nothing tries to allocate data there, and then runs a balance 
operation to force chunks onto other devices (I'm not sure if it only 
moves chunks that are on the device being removed though).  This results 
in two particularly important differences from most other RAID systems:

1. The device being removed is functionally wiped (it will appear to be 
empty), but not physically wiped (most of the data is still there, you 
just can't get to it through BTRFS).
2. The process as a whole is not atomic, but as a result of how it 
works, it is generally possible to restart it if it got stopped part way 
through (and you won't usually lose much progress).

That said, even if it was technically possible to remove the drive 
without messing things up, it would be of limited utility.  You couldn't 
later reconnect it and expect things to just work (you would have 
generation mismatches, which would hopefully cause the old disk to 
effectively be updated to match the new one, _IF_ the old disk even 
registered properly as part of the filesystem), and it would be 
non-trivial to get data off of it safely too (you would have to connect 
it to a different system, and hope that BTRFS doesn't choke on half a 
filesystem).
> 
> Again, pretty sure about this too, but not certain: device replace is
> an atomic operation, the whole thing succeeds or fails, and at the end
> merely the Btrfs signature is wiped from the deleted device(s). So you
> could restore that signature and the device would be valid again;
> HOWEVER it's going to have the same volume UUID as the new devices.
> Even though the device UUIDs are unique, and should prevent confusion,
> maybe confusion is possible.
Also correct.  This is part of why it's preferred to use the replace 
command instead of deleting and then adding a device to replace it (the 
other reason being that it's significantly more efficient, especially if 
the filesystem isn't full).
> 
> A better way, which currently doesn't exist, is to make the raid1 a
> seed device, and then add two new devices and remove the seed. That
> way you get the replication you want, the instant the sprout is
> mounted rw, it can be used in production (all changes go to the
> sprout), while the chunks from the seed are replicated. The reason
> this isn't viable right now is the tools aren't mature enough to
> handle multiple devices yet. Otherwise with a single device seed to a
> single sprout, this works and would be the way to do what you want.
Indeed, although it's worth noting that even with a single seed and 
single sprout, things aren't as well tested as most of the rest of BTRFS.
> 
> A better way that does exist is to setup an overlay for the two
> original devices. Mount the overlay devices, add the new devices,
> delete the overlays. So the overlay devices get the writes that cause
> those devices to be invalidated. The original devices aren't really
> touched. There's a way to do this with dmsetup like how live boot
> media work, and there's another way I haven't ever used before that's
> described here:
> 
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
Using block-level overlays with BTRFS is probably a bad idea for the 
same reasons that block-level copies are a bad idea, even with the 
dmsetup methods (also, most live boot media does it at the filesystem 
level, not the block level, it's safer and more efficient that way). 
Your safest bet is probably seed devices, though that of course is not 
very well documented.
> 
>> After a reboot it failed, namely because "nofail" wasn't in my fstab and
>> systemd is pedantic by default. After managing to get it booting into my
>> system without /mnt/raid1 I faced these "open ctree failed" issues.
>> After running btrfs check on all the drives and getting nowhere, I
>> decided to unplug the new drives and I discovered that when I take out
>> the new 4TB WD drive, I could mount it with -o degraded.
>>
>> dmesg errors with the WD include "My Passport" Wrong diagnostic page;
>> asked for 1 got 8 "Failed to get diagnostic page 0xffffffea" which
>> raised my suspicions. The model number btw is WDBYFT0040BYI-WESN
>>
>> Anyway, I'm back up and running with 2x2TB  (one of them didn't finish
>> removing, I don't know which) & 1x4TB.
> 
> 
> Be aware that you are likely in a very precarious position now.
> Anytime raid1 volumes are mounted rw,degraded, one or more of the
> devices will end up with new empty single chunks (there is a patch to
> prevent this, I'm not sure if it's in 4.13). The consequence of these
> new empty single chunks is that they will prevent any subsequent
> degraded rw mount. You get a one time degraded,rw. Any subsquent
> attempt will require ro,degraded to get it to mount. If you end up
> snared in this, there are patches in the archives to inhibit the
> kernels protection to allow mounting of such volumes. Super annoying.
> You'll have to build a custom kernel.
> 
> My opinion is you should update backups before  you do anything else,
> just in cas
> Next, you have to figure out a way to get all devices to be used in
> this volume healthy. Tricky as you technically have a 4 device raid 1
> with a missing device. I propose first to check if you have single
> chunks with either 'btrfs fi us' or 'btrfs fi df' and if so, get rid
> of them with a filtered balance 'btrfs balance start
> -mconvert=raid1,soft -dconvert=raid1,soft' and then in theory you
> should be able to do 'btrfs delete missing' to end up with a valid
> three device btrfs raid 1, which you can use until you get your USB
> power supply issues sorted.
I absolutely concur with Chris here, get your backups updated, and then 
worry about repairing the filesystem.  Or, alternatively, get your 
backups updated and then nuke the filesystem and rebuild it from scratch 
(this may be more work, but it's guaranteed to work).
