Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41832 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbbLZFVA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Dec 2015 00:21:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aChHl-0006kV-Je
	for linux-btrfs@vger.kernel.org; Sat, 26 Dec 2015 06:20:57 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Dec 2015 06:20:57 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Dec 2015 06:20:57 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs problems on new file system
Date: Sat, 26 Dec 2015 05:20:49 +0000 (UTC)
Message-ID: <pan$5b392$be4c0a13$5e032f42$d915874d@cox.net>
References: <16107.1451037790@ccs.covici.com>
	<CAPmG0jbOu6BmKfbaoJ6pzprWzbch3tf7=zbBS8AcDz4MQVEJZA@mail.gmail.com>
	<18552.1451078098@ccs.covici.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

covici posted on Fri, 25 Dec 2015 16:14:58 -0500 as excerpted:

> Henk Slager <eye1tm@gmail.com> wrote:
> 
>> On Fri, Dec 25, 2015 at 11:03 AM,  <covici@ccs.covici.com> wrote:
>> > Hi.  I created a file system using 4.3.1 version of btrfsprogs and
>> > have been using it for some three days.  I have gotten the following
>> > errors in the log this morning:

>> > Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
>> > transid verify failed on 51776421888 wanted 4983 found 4981

[Several of these within a second, same block and transids, wanted 4983, 
found 4981.]

>> > The file system was then made read only.  I unmounted, did a check
>> > without repair which said it was fine, and remounted successfully in
>> > read/write mode, but am I in trouble?  This was on a solid state
>> > drive using lvm.
>> What kernel version are you using?
>> I think you might have some hardware error or glitch somewhere,
>> otherwise I don't know why you have such errors. These kind of errors
>> remind me of SATA/cable failures over quite a period of time (multipe
>> days). Or something with lvm or trim of SSD.
>> Any unusual with the SSD if you run  smartctl?
>> A btrfs check will indeed likely result in an OK for this case.
>> What about running read-only scrub?
>> Maybe running  memtest86+  can rule-out the worst case.
> 
> I am running 4.1.12-gentoo and btrfs progs 4.3.1.  Same thing happened
> on another filesystem, so I switched them over to ext4 and no troubles
> since.  As far as I know the ssd drives are fine, I have been using them
> for months.  Maybe btrfs needs some more work.  I did do scrubs on the
> filesystems after I went offline and remounted them, and they were
> successful, and I got no errors from the lower layers at all.  Maybe
> I'll try this in a year or so.

Well, as I seem to say every few posts, btrfs is "still stabilizing, not 
fully stable and mature", so it's a given that more work is needed, tho 
it's demonstrated to be "stable enough" for many in daily use, as long as 
they're generally aware of stability status and are following the admin's 
rule of backups[1] with the increased risk-factor of running "still 
stabilizing" filesystems in mind.

The very close generation/transid numbers, only two commits apart, for 
the exact same block, within the same second, indicate a quite recent 
block-write update failure, possibly only a minute or two old.  You could 
tell how recent by comparing the generation/transid in the superblock 
(using btrfs-show-super) at as close to the same time as possible, seeing 
how far ahead it is.

I'd check smartctl -A for the device(s), then run scrub and check it 
again, to see if the raw number for ID5, Reallocated_Sector_Ct (or 
similar for your device) changed.  (I have some experience with this.[2])

If the raw reallocated sector count goes up, it's obviously the device.  
If it doesn't but scrub fixes an error, then it's likely elsewhere in the 
hardware (cabling, power, memory or storage bus errors, sata/scsi 
controller...).  If scrub detects but can't fix the error the lack of fix 
is probably due to single mode, with the original error due possibly to a 
bad shutdown/umount or a btrfs bug.  If scrub says it's fine, then 
whatever it was was temporary could be due to all sorts of things, from a 
cosmic ray induced memory error, to btrfs bug, to...

In any case, if scrub fixes or doesn't detect an error, I'd not worry 
about it too much, as it doesn't seem to be affecting operation, you 
didn't get a lockup or backtrace, etc.  In fact, I'd take that as 
indication of btrfs normal problem detection and self-healing, likely due 
to being able to pull a valid copy from elsewhere due to raidN or dup 
redundancy or parity.

Tho there's no shame in simply deciding btrfs is still too "stabilizing, 
not fully stable and mature" for you, either.  I know I'd still hesitate 
to use it in a full production environment, unless I had both good/tested 
backups and failover in place.  "Good enough for daily use, provided 
there's backups if you don't consider the data throwaway", is just that; 
it's not really yet good enough for "I just need it to work, reliably, 
because it's big money and people's jobs if it doesn't."

---
[1] Admin's rule of backups:  For any given level of backup, you either 
have it, or by your actions are defining the data to be of less value 
than the hassle and resources taken to do the backup, multiplied by the 
risk factor of actually needing that backup.  As a consequence, after the 
fact protests to the contrary are simply lies, as actions spoke louder 
than words and they defined the time and hassle saved as more valuable, 
so the valuable was saved in any case and in this case the user should be 
happy they saved the more valuable hassle and resources even if the data 
got lost.

And of course with btrfs still stabilizing, that risk factor remains 
somewhat elevated, meaning more levels of backups need to be kept, for 
relatively lower value data.

But AFAIK, you've stated elsewhere that you have backups, so this is more 
for completeness and for other readers than for you, thus its footnoting, 
here.

[2] smartctl -A: ID5, reallocated sectors: 

For some months I ran a bad ssd that was gradually failing sectors and 
reallocating them, in btrfs raid1 mode for both data and metadata, using 
scrub to detect and rewrite the errors from the good copy on the other 
device, forcing device sector reallocation in the process.  I ran it down 
to about 85% spare sectors remaining, 36% being the reported threshold 
value.  (My cooked value dropped from 253, none replaced, to 100, percent 
remaining, with the first replacement, and continued dropping percentage 
from there over time.

Primarily I was just curious to see how both the device and btrfs behaved 
a bit longer term with a failing device, and I took the opportunity 
afforded me by btrfs raid1 and the btrfs data integrity features to find 
out.  At about 85% I decided I had learned about all I was going to learn 
and it wasn't worth the hassle any longer, and replaced the ssd.

My primary takeaway, besides getting rather good at doing scrubs and 
looking at that particular smartctl -A failure mode, was that at least 
with that device, there were a *LOT* more spare sectors than I had 
imagined there'd be.  At 85% I had replaced several MiB worth, at half a 
KiB per sector, 2000 sectors per MiB, and it looked to have 100 to 
perhaps 128 MiB or so of spare sectors, on a 238 GiB ssd.  I'd have 
guessed perhaps 8-16 MiB worth, which I had already used up by the time I 
replaced it at 85% still available, so I didn't actually get to see what 
it did when they ran out, as I had hoped. =:^(  But I was tired of 
dealing with it and wasn't anywhere close to running out of sectors, when 
I gave up on it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

