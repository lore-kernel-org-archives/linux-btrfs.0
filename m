Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49160 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaL0JBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 04:01:23 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Robert White <rwhite@pobox.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sat, 27 Dec 2014 10:01:17 +0100
Message-ID: <4232026.31LFOYpm2s@merkaba>
In-Reply-To: <549DE5C6.2000606@pobox.com>
References: <3738341.y7uRQFcLJH@merkaba> <549DE5C6.2000606@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 26. Dezember 2014, 14:48:38 schrieb Robert White:
> On 12/26/2014 05:37 AM, Martin Steigerwald wrote:
> > Hello!
> > 
> > First: Have a merry christmas and enjoy a quiet time in these days.
> > 
> > Second: At a time you feel like it, here is a little rant, but also a bug
> > report:
> > 
> > I have this on 3.18 kernel on Debian Sid with BTRFS Dual SSD RAID with
> > space_cache, skinny meta data extents – are these a problem? – and
> 
> > compress=lzo:
> (there is no known problem with skinny metadata, it's actually more
> efficient than the older format. There has been some anecdotes about
> mixing the skinny and fat metadata but nothing has ever been
> demonstrated problematic.)
> 
> > merkaba:~> btrfs fi sh /home
> > Label: 'home'  uuid: b96c4f72-0523-45ac-a401-f7be73dd624a
> > 
> >          Total devices 2 FS bytes used 144.41GiB
> >          devid    1 size 160.00GiB used 160.00GiB path
> >          /dev/mapper/msata-home
> >          devid    2 size 160.00GiB used 160.00GiB path
> >          /dev/mapper/sata-home
> > 
> > Btrfs v3.17
> > merkaba:~> btrfs fi df /home
> > Data, RAID1: total=154.97GiB, used=141.12GiB
> > System, RAID1: total=32.00MiB, used=48.00KiB
> > Metadata, RAID1: total=5.00GiB, used=3.29GiB
> > GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> This filesystem, at the allocation level, is "very full" (see below).
> 
> > And I had hangs with BTRFS again. This time as I wanted to install tax
> > return software in Virtualbox´d Windows XP VM (which I use once a year
> > cause I know no tax return software for Linux which would be suitable for
> > Germany and I frankly don´t care about the end of security cause all
> > surfing and other network access I will do from the Linux box and I only
> > run the VM behind a firewall).
> 
> > And thus I try the balance dance again:
> ITEM: Balance... it doesn't do what you think it does... 8-)
> 
> "Balancing" is something you should almost never need to do. It is only
> for cases of changing geometry (adding disks, switching RAID levels,
> etc.) of for cases when you've radically changed allocation behaviors
> (like you decided to remove all your VM's or you've decided to remove a
> mail spool directory full of thousands of tiny files).
> 
> People run balance all the time because they think they should. They are
> _usually_ incorrect in that belief.

I only see the lockups of BTRFS is the trees *occupy* all space on the device.

I *never* so far saw it lockup if there is still space BTRFS can allocate from 
to *extend* a tree.

This may be a bug, but this is what I see.

And no amount of "you should not balance a BTRFS" will make that perception go 
away.

See, I see the sun coming out on a morning and you tell me "no, it doesn´t". 
Simply that is not going to match my perception.

> > merkaba:~> btrfs balance start -dusage=5 -musage=5 /home
> > ERROR: error during balancing '/home' - No space left on device
> 
> ITEM: Running out of space during a balance is not running out of space
> for files. BTRFS has two layers of allocation. That is, there are two
> levels of abstraction where "no space" can occur.

I understand that *very* well. I know about the allocation of *device* space 
for tree and I know about the allocation *inside* a tree.

> The first level of allocation is the "making more BTRFS structures out

Skipped rest of explaination that I already now. 

I also don´t buy in the SSD makes kworker thread to use 100% for minutes 
explaination - *while* this SSDs are basically idling. A sandybridge core is 
not exactly slow and these are still consumer SSDs, we are not talking about a 
million of IOPS here.

And again:

This does not ever happen on when the trees do *not* fully allocate all device 
space. Even the defragmentation of the Windows XP run fine until after the 
trees allocated all space on the device again.

Try to reread the last two sentences in case it doesn´t sink to you.


Thats why I consider it a bug. I totally agree with you that a balance should 
not be necessary, but in my observation it is. That is the actual bug.




And no, no one needs me to tell to nocow the file. Even the extents are no 
issue: Not with SSDs which provide good enough random access.

My interpretation from what I see is this: BTRFS free space *in tree* handling 
is still not up to producation quality.


Now you either try out what I describe and see whether you perceive the same, 
or if you don´t, please don´t argue with my perception. You can argue with my 
conclusion, but I know what I see here. Thanks.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
