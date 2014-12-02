Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42155 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbaLBMsi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Dec 2014 07:48:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xvmsd-00048S-D8
	for linux-btrfs@vger.kernel.org; Tue, 02 Dec 2014 13:48:35 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 13:48:35 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 13:48:35 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs stuck with lot's of files
Date: Tue, 2 Dec 2014 12:48:21 +0000 (UTC)
Message-ID: <pan$9649c$5bf442fc$686ccac2$96f1d79b@cox.net>
References: <1417434411.20237.1.camel@gentoo.org>
	<547CB7D0.4040800@pobox.com> <1417485029.4310.22.camel@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Peter Volkov posted on Tue, 02 Dec 2014 04:50:29 +0300 as excerpted:

> В Пн, 01/12/2014 в 10:47 -0800, Robert White пишет:
>> On 12/01/2014 03:46 AM, Peter Volkov wrote:
>>  > (stuff about getting hung up trying to write to one drive)
>> 
>> That drive (/dev/sdn) is probably starting to fail.
>> (about failed drive)
> 
> Thank you Robert for the answer. It is not likely that drive fails here.
> Similar condition (write to a single drive) happens with other drives
> i.e. such write pattern may happen with any drive.
>
> After looking at what happens longer I see the following. During stuck
> single processor core is busy 100% of CPU in kernel space (some kworker
> is taking 100% CPU).

FWIW, agreed that it's unlikely to be the drive, especially if you're not 
seeing bus resets or drive errors in dmesg and smart says the drive is 
fine, as I expect it does/will.  It may be a btrfs bug or scaling issue, 
of which btrfs still has some, or it could simply be the single mode vs 
raid0 mode issue I explain below.

>> >   # btrfs filesystem df /store/
>> > Data, single: total=11.92TiB, used=10.86TiB
>> 
>> Reguardless of the above...
>> 
>> You have a terabyte of unused but allocated data storage. You probably
>> need to balance your system to un-jamb that. That's a lot of space that
>> is unavailable to the metadata (etc).
> 
> Well, I'm afraid that balance will put fs into even longer "stuck".
> 
>> ASIDE: Having your metadata set to RAID1 (as opposed to the default of
>> DUP) seems a little iffy since your data is still set to DUP.
> 
> That's true. But why data is duplicated? During btrfs volume creation
> I've set explicitly -d data single.

I believe Robert mis-wrote (thinko).  The btrfs filesystem df clearly 
shows that your data is in single mode, the data default mode, not dup 
mode, which is normally only available to metadata (not data) on a single-
device filesystem, where it is the metadata default.

However, in the original post you /did/ say raid1 for metadata, raid0 for 
data, and the above btrfs filesystem df again clearly says single, not 
raid0.

Which is very likely to be your problem.  In single mode, btrfs will 
create chunks one at a time, picking the device with the most free space 
to allocate it on.  The normal data chunk size is 1 GiB.  Because of the 
most-free-space allocation rule, with N devices (22 in your case) of the 
same size, after N (22) data chunks are allocated you'll tend to have one 
such chunk on each device.

Each of these 1 GiB chunks (along with space freed up by normal delete 
activity in other allocated data chunks) will be filled before another is 
allocated.

Which will mean you're writing a GiB worth of data to one device before 
you switch to the next one.  With your mostly sub-MiB file write pattern, 
that's probably 1500-2000 files written to a chunk on that single device, 
before another chunk is allocated on the next device.

Thus all your activity on that single device!

In raid0 mode, by contrast, the same 1 GiB chunks will be allocated on 
each device, but a stripe of chunks will be allocated across all devices 
(22 in your case) at the same time, and data being written is broken up 
into much smaller per-device strips.  I'm not sure what the actual per-
device is in raid0 mode, but it's *WELL* under a GiB and I believe in the 
KiBs not MiB range.  It might be 128 KiB, the compression block size when 
the compress mount option is used.

Obviously were you using raid0 data, you'd see the load spread out at 
least somewhat better.  But the df says it's single, not raid0.

To get raid0 mode you can use a balance with filters (see the wiki or 
recent btrfs-balance manpage), or blow away the existing filesystem and 
create a new one, setting --data raid0 when you mkfs.btrfs, and restore 
from backups (which you're already prepared to do if you value your data 
in any case[1]).

That missing btrfs filesystem show, due to the terminating / in /store/ 
(simply /store should work) is somewhat frustrating here, as it'd show 
per-device sizes and utilization.  Assuming near same-sized devices, with 
11 TiB of data being far greater than the 1 GiB data chunk size times 22 
devices I'd guess you're pretty evened out, utilization-wise, but the 
output from both show and df is necessary to get the full story.

>> FUTHER ASIDE: raid1 metadata and raid5 data might be good for you given
>> 22 volumes and 10% empty empty space it would only cost you half of
>> your existing empty space. If you don't RAID your data, there is no
>> real point to putting your metadata in RAID.
> 
> Is raid5 ready for use? As I read post[1] mentioned on[2] it is still
> some way to make it stable.

You are absolutely correct.  I'd strongly recommend staying AWAY from 
btrfs raid5/6 modes at this time.  While Robert is becoming an active 
regular and has the technical background to point out some things others 
miss, he's still reasonably new to this list and may not have been aware 
of the incomplete status of raid5/6 modes at this time.

Effectively btrfs raid56 (called raid56, no slash, in btrfs lingo, 
because it's the same code that handles both) at this time can be 
considered a slower raid0, with parity strips that are written but not 
able to be used for full recovery at this point, that will "magically" be 
upgraded to raid56 when the btrfs raid56 recovery code is complete.  
Operationally it works fine, and the parity strips are indeed written.  
It's the scrub and recovery code that's not yet complete.  Which means 
consider it a raid0 in terms of recovery, a total loss if a single device 
is lost, and have your backups and/or willingness to simply say bye to 
the data if a device is lost prepared accordingly, and you won't be 
caught unprepared.

Which since you're using single mode now but thought you were using raid0 
mode already, isn't far from your present situation in any case.  So you 
might actually want to think about raid56 modes if you do a mkfs.btrfs 
for some reason, since you're already going to be prepared for a raid0 
level meltdown, loss of all data that's not backed up, and while you'd 
not get a lot of benefit from it right now, you /would/ get the automatic 
upgrade to actually /recoverable/ raid56 when that code is deployed.

The other alternative if your devices and thus filesystem size are big 
enough (> 1 TiB per device, > 22 TiB total), would be raid10 mode for the 
data.  Btrfs raid1 and raid10 is exactly two-way, so you'd have 11-way-
striping instead of the 22-way you'd have with raid0 or the effective 
single-speed you have now due to single-mode data, but would also have 
the two-way-mirroring.  In addition to the normal benefits of two-way-
mirroring, that lets you take advantage of btrfs checksumming and data 
integrity features as well, reading from the good copy (and rewriting the 
bad one) if the first copy found doesn't match checksum.  If I had the 
capacity, raid10 would be my preferred mode here, but it /does/ mean 
halving effective capacity of the filesystem.


Hope that helps and best wishes from a fellow gentooer! =:^)

---
[1] Backups:  While btrfs isn't entirely experimental any more, it's 
still not entirely stable either, and data eating bugs can and do 
happen.  As such, the sysadmin's rule of thumb that says if you don't 
have a backup, you don't care about your data, and an untested backup is 
not a backup, applies even more than it does when your data is on a fully 
mature filesystem.  

Of course the same applies to raid0, so the general btrfs status isn't a 
big change from that in any case and I expect you either already have 
good backups or are prepared to simply lose the data if a device goes bad 
already.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

