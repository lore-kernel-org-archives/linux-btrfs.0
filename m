Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33050 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbaKDIZf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Nov 2014 03:25:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XlZQi-0002ma-V6
	for linux-btrfs@vger.kernel.org; Tue, 04 Nov 2014 09:25:33 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Nov 2014 09:25:32 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Nov 2014 09:25:32 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: filesystem corruption
Date: Tue, 4 Nov 2014 08:25:21 +0000 (UTC)
Message-ID: <pan$e54ac$a490d88a$2b40e1fe$3abb4a79@cox.net>
References: <CAGwxe4hoJa6h3=qmsa6k+AzienjwZ2eifakKzhanXZVCru9koA@mail.gmail.com>
	<CAGwxe4inBLYrbq2t1T004dGR_vfE-GwgU=fho=SCDBa6LOkWow@mail.gmail.com>
	<CAGfcS_=f2TRGbeWpE186xE89jnXmPb=qiN6mPgjQGJRRX3UJ1g@mail.gmail.com>
	<CAGwxe4hC_BtPd41YCnFnyMD3TnOeuNgAZ1dZUFRUYuOkFjy0Yg@mail.gmail.com>
	<5455B7E7.3020404@pobox.com>
	<1C1C5F8B-DD79-4E4B-A530-D98DABA53E74@colorremedies.com>
	<20141103034337.GM17395@hungrycats.org>
	<935F962F-7DD6-4C18-88F3-65EF614B80E4@colorremedies.com>
	<20141104043130.GN17395@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zygo Blaxell posted on Mon, 03 Nov 2014 23:31:45 -0500 as excerpted:

> On Mon, Nov 03, 2014 at 10:11:18AM -0700, Chris Murphy wrote:
>> 
>> On Nov 2, 2014, at 8:43 PM, Zygo Blaxell <zblaxell@furryterror.org>
>> wrote:
>> > btrfs seems to assume the data is correct on both disks (the
>> > generation numbers and checksums are OK) but gets confused by equally
>> > plausible but different metadata on each disk.  It doesn't take long
>> > before the filesystem becomes data soup or crashes the kernel.
>> 
>> This is a pretty significant problem to still be present, honestly. I
>> can understand the "catchup" mechanism is probably not built yet,
>> but clearly the two devices don't have the same generation. The lower
>> generation device should probably be booted/ignored or declared missing
>> in the meantime to prevent trashing the file system.
> 
> The problem with generation numbers is when both devices get divergent
> generation numbers but we can't tell them apart

[snip very reasonable scenario]

> Now we have two disks with equal generation numbers. 
> Generations 6..9 on sda are not the same as generations 6..9 on sdb, so
> if we mix the two disks' metadata we get bad confusion.
> 
> It needs to be more than a sequential number.  If one of the disks
> disappears we need to record this fact on the surviving disks, and also
> cope with _both_ disks claiming to be the "surviving" one.

Zygo's absolutely correct.  There is an existing catchup mechanism, but 
the tracking is /purely/ sequential generation number based, and if the 
two generation sequences diverge, "Welcome to the (data) Twilight Zone!"

I noted this in my own early pre-deployment raid1 mode testing as well, 
except that I didn't at that point know about sequence numbers and never 
got as far as letting the filesystem make data soup of itself.

What I did was this:

1) Create a two-device raid1 data and metadata filesystem, mount it and 
stick some data on it.

2) Unmount, pull a device, mount degraded the remaining device.

3) Change a file.

4) Unmount, switch devices, mount degraded the other device.

5) Change the same file in an different/incompatible way.

6) Unmount, plug both devices in again, mount (not degraded).

7) Wait for the sync I was used to from mdraid, which of course didn't 
occur.

8) Check the file to see which version showed up.  I don't recall which 
version it was, but it wasn't the common pre-change version.

9) Unmount, pull each device one at a time, mounting the other one 
degraded and checking the file again.

10) The file on each device remained different, without a warning or 
indication of any problem at all when I mounted undegraded in 6/7.

Had I initiated a scrub, presumably it would have seen the difference and 
if one was a newer generation, it would have taken it, overwriting the 
other.  I don't know what it would have done if both were the same 
generation, tho the file being small (just a few line text file, big 
enough to test the effect of differing edits), I guess it would take one 
version or the other.  If the file was large enough to be multiple 
extents, however, I've no idea whether it'd take one or the other, or 
possibly combine the two, picking extents where they differed more or 
less randomly.

By that time the lack of warning and absolute resolution to one version 
or the other even after mounting undegraded and accessing the file with 
incompatible versions on each of the two devices was bothering me 
sufficiently that I didn't test any further.

Being just me I have to worry about (unlike a multi-admin corporate 
scenario where you can never be /sure/ what the other admins will do 
regardless of agreed procedure), I simply set myself a set of rules very 
similar to what Zygo proposed:

1) If for whatever reason I ever split a btrfs raid1 with the intent or 
even the possibility of bringing the pieces back together again, if at 
all possible, never mount the split pieces writable -- mount read-only.

2) If a writable mount is required, keep the writable mounts to one 
device of the split.  As long as the other device is never mounted 
writable, it will have an older generation when they're reunited and a 
scrub should take care of things, reliably resolving to the updated 
written device, rewriting the older generation on the other device.

What I'd do here is physically put the removed side of the raid1 in 
storage, far enough from the remaining side that I couldn't possibly get 
them mixed up.  I'd clearly label it as well, creating a "defense in 
depth" of at least two, the labeling and the physical separation and 
storage of the read-only device.

3) If for whatever reason the originally read-only side must be mounted 
writable, very clearly mark the originally mounted-writable device 
POISONED/TOXIC!!  *NEVER* *EVER* let such a POISONED device anywhere near 
its original raid1 mate, until it is wiped, such that there's no 
possibility of btrfs getting confused and contaminated with the poisoned 
data.

Given how unimpressed I was with btrfs' ability to do the right thing in 
such cases, I'd be tempted to wipefs the device, then dd from 
/dev/zero to it, then badblocks write-pattern test a couple patterns, 
then (if it was a full physical device not just a partition) hardware 
secure-erase it, then mkfs it to ext4 or vfat, then dd from /dev/zero it 
again and again hardware secure-erase it, then FINALLY mkfs.btrfs it 
again.  Of course being ssd, a single mkfs.btrfs would issue a trim and 
that should suffice, but I was really REALLY not impressed with btrfs' 
ability to reliably do the right thing, and would effectively be tearing 
up the schoolbooks (at least the workbooks, since they couldn't be bought 
back) and feeding them to the furnace at the end of the year, as I used 
to do when I was a kid, not because it made a difference, but because it 
was so emotionally rewarding! =:^)

Or maybe I'd make that an excuse to try dban[1].

But I'd probably just dd from /dev/zero or secure-erase it, or badblocks-
write-test a couple patterns if I wanted to badblocks-test it anyway, or 
mkfs.btrfs it to get the trim from that.

But I'd have fun doing it. =:^)

And then I'd plug it back in and btrfs replace the missing device.


Anyway, the point is, either don't reintroduce absent devices once split 
out of a btrfs raid1, or ensure they don't get written and immediately do 
a scrub to update them when reintroduced, or if they were written and the 
other device was too, separately, be sure the one is wiped (Destroy them 
with Lasers![2]) before using a full btrfs replace, to keep the remaining 
device(s) and the data on them healthy. =:^)

---
[1] https://www.google.com/search?q=dban

[2] Destroy them with Lazers! by Knife Party
https://www.google.com/search?q=destroy+them+with+lazers

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

