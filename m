Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54360 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbbBJDLd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 22:11:33 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YL1EX-0000pi-Bp
	for linux-btrfs@vger.kernel.org; Tue, 10 Feb 2015 04:11:29 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 04:11:29 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 04:11:29 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs
 filesystem
Date: Tue, 10 Feb 2015 03:11:23 +0000 (UTC)
Message-ID: <pan$cb155$6f4aa7b1$1e08c38e$68d996b5@cox.net>
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
	<CANcfdL2FgE9UDCjVkzNUa8X1y63=JLfjcwqT4=KDLOu-YTe=sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

constantine posted on Tue, 10 Feb 2015 00:54:56 +0000 as excerpted:

> Could you please answer two questions?:
> 
> 1.  I am testing various files and all seem readable. Is there a way to
> list every file that resides on a particular device (like /dev/sdc1?) so
> as to check them?

I don't know of such a way, but there are folks here that know way more 
than me about it.

> There are a handful of files that seem corrupted,
> since I get from scrub:
> """
> BTRFS: checksum error at logical 10792783298560 on dev /dev/sdc1,
> sector 737159648, root 5, inode 1376754, offset 175428419584, length
> 4096, links 1 (path: long/path/file.img) """,
> but are these the only files that could be corrupted?

Assuming you don't have any "missing" metadata, AFAIK that should be all 
of them.  With raid1 data and metadata, you would have had two copies of 
each chunk for both data and metadata, and if there's metadata where one 
copy existed on the missing device and the other copy is corrupted on the 
problem device... but then there'd be errors where the parents of the 
missing metadata didn't check out.  If all the scrub errors you're seeing 
can be matched to files, then you are lucky and should have at least one 
good copy of all metadata, which means only the files that scrub shows as 
corrupt should be corrupt.

> 
> 2. Chris mentioned:
> 
> A. On Mon, Feb 9, 2015 at 12:31 AM, Chris Murphy
> <lists@colorremedies.com> wrote:
>> [[[try # btrfs device delete /dev/sdc1 /mnt/mountpoint]]]. Just realize
>> that any data that's on both the failed drive and sdc1 will be lost
> 
> and later
> 
> B. On Mon, Feb 9, 2015 at 1:34 AM, Chris Murphy
> <lists@colorremedies.com> wrote:
>> So now I have a 4 device raid1 mounted degraded. And I can still device
>> delete another device.
>> So one device missing and one device removed.
> 
> So when I do the "# btrfs device delete /dev/sdc1 /mnt/mountpoint" the
> normal behavior would for the files that are located in /dev/sdc1 (and
> also were on the missing/failed drive) to be transferred to other drives
> and not lose them, right? (Does B. hold and contradict A.?)

Normally you'd device delete missing first, then device delete the other 
failing one (sdc1).

If it'll even let you delete a second device with one missing, if you're 
lucky, there will be at least one valid copy of everything on the device 
you're trying to delete and it'll just work.  However, as we already 
know, there's some corrupted files, so as long as they are there it'll 
probably error out in some way part way thru, where the one copy was on 
the missing device and the other copy is corrupted on the device you're 
trying to delete.

What you may be able to do, however, is delete the corrupted files.  Once 
they're gone and a scrub doesn't show any further corruption, you should, 
with luck, be able to device delete the failing device.

Alternatively, once you've gotten valid files for everything you can, you 
can try Chris's checksum reset suggestion, which will reset the checksum 
on all files including the bad ones.  Assuming they're stable enough on 
the failing device for the faked checksum to hold long enough to read 
them, you can then copy them to backup and test to see if they're garbage 
or at least some data worth saving is left in them.  After which you can 
of course delete them and proceed as above.

The other alternative is to try using restore on the unmounted filesystem 
for just those files, using the regex option to confine it to just those 
files (perhaps one at a time if they don't combine into a nice regex, as 
is likely).  That's last-ditch and may not work either, particularly if 
the problem device is returning different random garbage every time an 
attempt to read the corrupted blocks is made, such that the checksum 
reset doesn't work.


Personally, what I'd do if it were me, is get all the data off I could, 
physically remove that problem device, and then call that filesystem 
toast and start over with a new filesystem with what remains, giving up 
on what's there.  Then I'd restore from the backup to the new filesystem 
(or newly designed layout, however you do it).  I'd not even worry about 
trying to repair what's there, beyond backing up what I could before 
wiping it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

