Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39854 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbbEQIT5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 May 2015 04:19:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yttnd-0002mJ-FY
	for linux-btrfs@vger.kernel.org; Sun, 17 May 2015 10:19:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 17 May 2015 10:19:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 17 May 2015 10:19:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Got 10 csum errors according to dmesg but 0 errors according to
 dev stats
Date: Sun, 17 May 2015 08:19:48 +0000 (UTC)
Message-ID: <pan$f32b4$a31b2df$ac4903ed$b7bd68b4@cox.net>
References: <554F6D43.2060806@googlemail.com>
	<554F7232.9080804@googlemail.com> <5557F490.5000606@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Philip Seeger posted on Sun, 17 May 2015 03:53:20 +0200 as excerpted:
> 
> On 05/10/2015 04:58 PM, Philip Seeger wrote:
>> 
>> Forgot to mention kernel version: Linux 4.0.1-1-ARCH
>>
>> $ sudo btrfs fi show Label: none  uuid:
>> 3e8973d3-83ce-4d93-8d50-2989c0be256a
>>     Total devices 1 FS bytes used 19.87GiB
>>     devid    1 size 45.00GiB used 21.03GiB path /dev/sda1
>>
>> btrfs-progs v3.19.1
>>
> I think I forgot to mention that this btrfs filesystem was converted
> from ext4 (not initially created as btrfs).
> Could this cause this corruption?
> 
> Also, does this df output look weird to anyone, shouldn't metadata be
> duplicated?
> # btrfs fi df /
> Data, single: total=21.00GiB, used=20.82GiB
> System, single: total=32.00MiB, used=4.00KiB
> Metadata, single: total=1.25GiB, used=901.21MiB
> GlobalReserve, single: total=304.00MiB, used=0.00B

[Reordered to standard quote/reply order, so replies have proper 
context.  Top posting... not so fun to reply to! =:^( ]

I can't answer the corruption bit, but answering the df metadata 
question...

Normally, btrfs on a single device defaults to dup metadata type, single 
data type.  The one /normal/ exception to that is when mkfs.btrfs detects 
an ssd, where it defaults to single data due to ssd firmware often 
canceling out the intended redundancy of dup anyway.[1]

However, conversion from ext* is a bit of a different ball game, and 
while it /should/ default to dup metadata as well, on 4.0 and into 4.1-rcs 
as a proper fix hasn't been posted, there's a balance-conversion bug 
that's keeping type conversion from occurring, both in the normal btrfs 
balance convert case and in the ext* conversion case.  Thus, ext* 
conversions remain metadata-single mode and cannot be converted to 
metadata-dup until this bug is fixed.

I said that a /proper/ fix hasn't yet been posted.  There has been a 
bisect trace to the commit that killed balance-convert, and that can be 
reverted, as I guess some distros are doing in their current releases.  
However, that commit happened to fix an ext* to btrfs conversion fault, 
that would cause ext* conversions to fail entirely.  So reverting that 
commit does fix normal btrfs balance conversions, but it breaks the 
ability to convert from ext* at all.  I don't know when /that/ was 
broken, but apparently it was further back.

So right now, the only way to get a desired btrfs chunk redundancy type 
is to use mkfs.btrfs to create it that way in the first place.  Which 
means no ext* conversion unless you're happy with single-data/single-
metadata, since that's what it ends up with, and balance-convert is ATM 
currently broken and can't convert to other redundancy types.

Well, unless you want to do the ext* to btrfs convert with the current 
tools as they are (with the commit in question so the ext*-conversion 
actually works), then rebuild with that commit reverted, so balance-
convert works...

Chris Mason has stated he has what he believes to be the correct fix in 
his head, but he hasn't posted it yet.  Either it turned out to have 
other problems, or he simply hasn't had time to write it out and properly 
test that it /doesn't/ have other problems.

Either way, as I said above, until that patch appears, the only /current/ 
way (other than jumping thru rebuild and revert hoops) to get other than 
single data/metadata both on data that's currently on ext4, is to either 
back it up or use it as a backup, and create a /new/ btrfs of the 
intended chunk redundancy layout using mkfs.btrfs, mount it and copy the 
data into it from that backup.

---
[1] Ssd firmware canceling out dup redundancy: This can happen in two 
ways.  First, some common ssd firmware (sandforce, IIRC, perhaps others) 
does its own dedup, such that two identical copies only get written once 
anyway, thus directly canceling out the benefits of filesystem dup.  
Second, even for firmware that actually writes two copies, because they 
are written one right after the other, they may well be written into the 
same erase block, and since the fail-pattern of ssds normally fails 
entire erase-blocks at the same time or very close to it, dup won't 
provide the intended redundancy protection anyway.  Thus, on ssds one 
really needs two physically separate devices in raid1 mode to provide the 
redundancy single-device dup is intended to provide.  Some ssds /may/ 
provide dup protection as intended, but it's sufficiently unreliable on 
available ssds that simply defaulting to single and not pretending 
otherwise was seen to be the wiser path, particularly since users can 
still specify dup mode at mkfs.btrfs time if they like, or (normally, 
when balance-convert is working) convert to it later if necessary.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

