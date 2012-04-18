From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs in degraded mode
Date: Wed, 18 Apr 2012 06:42:16 +0000 (UTC)
Message-ID: <pan.2012.04.18.06.42.15@cox.net>
References: <loom.20120417T181336-69@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Shridhar Shetty posted on Tue, 17 Apr 2012 16:14:45 +0000 as excerpted:

> I have created a btrfs filesystem with RAID1 setup having 2 disks.
> Everything works fine but when I try to umount the device and remount it
> in degraded mode,
> the data still goes into both the disk. ideally in degraded mode only
> one disk show disk activity and not the failed ones.
> 
> System Config:
> Base OS: Slackware kernel: linux 3.3.2
> 
> "sar -pd 2 10" shows me that the data is been written/read from both
> devices.
> 
> Also, Is there any way in which I can remove the failed disk without
> adding a new one in a RAID1 (2 disk setup). The reason being we want the
> option to keep it running in degraded(single disk) mode for sometime and
> on a weekend replace the failed drive with a fresh one :-).

Are you sure you created the filesystem with raid1 mode for both data and 
metadata?  Some people end up with only one or the other set to raid1 
mode (metadata defaults to mirroring on two-device, but data will default 
to single if not specifically set).

Meanwhile, AFAIK the degraded option doesn't force degraded, it only 
allows mounting degraded if the other device is non-functional.  If btrfs 
detects all its devices and doesn't detect a problem with one, it'll 
still try to run all devices, regardless of the degraded mount-option.

Are you aware of the wiki and have you read up on multi-device btrfs 
there?  If not, I very strongly recommend it, as btrfs' so-called raid1 
mode isn't really raid1, but only two-way mirroring (tho on two devices 
it's about the same, but there's still some operational differences 
compared to say md/raid), and you really need to read up on how it works 
in ordered to understand what's going on here and how to do what you were 
intending to do.

FWIW the commands are btrfs device remove, btrfs device delete, then 
btrfs device add when you get the replacement, but you really need to 
read the wiki to understand the various implications.

Wiki front-page:
http://btrfs.ipv5.de/index.php?title=Main_Page

Documentation:
http://btrfs.ipv5.de/index.php?title=Main_Page#Documentation

(There's a wiki at btrfs.wiki.kernel.org as well, but it hasn't been 
updated since the kernel.org breakin some months ago, and is thus rather 
stale by now.  The above ipv5.de wiki was supposed to be temporary, but 
it's looking more and more permanent...)

Read getting started, of course, the faq, the problem faq, gotchas, 
usecases, sysadminguide, and using btrfs with multiple devices, at 
least.  That should give you a good handle on the filesystem in general, 
including what you're dealing with.  What you're particularly after is in 
the multiple devices section, but to really understand what btrfs is 
doing, I'd recommend reading or at least scanning the others as well.  
Otherwise, you'll likely miss something that could be critical at some 
point.

One additional point, which you may already know, but the implications of 
your question (waiting for a weekend to replace the old drive, like you 
can't afford for your btrfs to be out of service temporarily) have me 
fearing that you're not aware of it.

As you'll see repeatedly if you read the wiki and/or this list for long, 
btrfs is still marked experimental in the kernel and under heavy 
development, fit for testing only at this point.  Read that as still 
buggy enough to eat your data for lunch if you let it!  While a good 
sysadmin always has backups, on a mature filesystem, the data on the 
filesystem is the primary copy, with the backups there just in case.  By 
contrast, the best way to think of the data on btrfs at this point is as 
a throw-away testing-only copy that the filesystem can eat for lunch at 
any point.  If you value your data, you'll have what you consider your 
primary copy on a more mature filesystem, with the usual backups you'd 
normally have of that, and the data on your testing btrfs will be just 
that, testing, no big deal if it gets eaten, because it was an extra 
"testing-only" copy of your data all along.  Of course as a good tester, 
you'll be running current kernels (as I see you are), and following this 
list in ordered to see the issues others are reporting and to report your 
own if necessary.

We see people way too many people on this list asking for some way to 
restore their data... because it was their ONLY copy or because they were 
treating it as their primary copy and they allowed their backups to get 
stale.  Unfortunately they didn't get the message about btrfs being stull 
experimental, still buggy, and under heavy development, until it was too 
late.  Let's not have you as another example!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

