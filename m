Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37465 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751162AbdCaF0x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 01:26:53 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ctp5A-00066v-Qs
        for linux-btrfs@vger.kernel.org; Fri, 31 Mar 2017 07:26:44 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Shrinking a device - performance?
Date: Fri, 31 Mar 2017 05:26:39 +0000 (UTC)
Message-ID: <pan$5c23$ddaeadec$128532fd$8595ddc4@cox.net>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
        <20170327194847.5c0c5545@natsu>
        <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
        <22746.30348.324000.636753@tree.ty.sabi.co.uk>
        <b0f6b00e-4c70-72d1-8683-c05bb72a0968@siedziba.pl>
        <22749.11946.474065.536986@tree.ty.sabi.co.uk>
        <67132222-17c3-b198-70c1-c3ae0c1cb8e7@siedziba.pl>
        <CAP8EXU2ufgLWL+kgKtaLjqHDBGV1OB8GWy+efCJf4Knb0DaEPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

GWB posted on Thu, 30 Mar 2017 20:00:22 -0500 as excerpted:

> CentOS, Redhat, and Oracle seem to take the position that very large
> data subvolumes using btrfs should work fine.  But I would be curious
> what the rest of the list thinks about 20 TiB in one volume/subvolume.

To be sure I'm a biased voice here, as I have multiple independent btrfs 
on multiple partitions here, with no btrfs over 100 GiB in size, and 
that's on ssd so maintenance commands normally return in minutes or even 
seconds, not the hours to days or even weeks it takes on multi-TB btrfs 
on spinning rust.  But FWIW...

IMO there are two rules favoring multiple relatively smaller btrfs over 
single far larger btrfs:

1) Don't put all your data eggs in one basket, especially when that 
basket isn't yet entirely stable and mature.

A mantra commonly repeated on this list is that btrfs is still 
stabilizing, not fully stable and mature, the result being that keeping 
backups of any data you value more than the time/cost/hassle-factor of 
the backup, and being practically prepared to use them, is even *MORE* 
important than it is on fully mature and stable filesystems.  If 
potential users aren't prepared to do that, flat answer, they should be 
looking at other filesystems, tho in reality, that rule applies to stable 
and mature filesystems too, and any good sysadmin understands that not 
having a backup is in reality defining the data in question as worth less 
than the cost of that backup, regardless of any protests to the contrary.

Based on that and the fact that if this less than 100% stable and mature 
filesystem fails, all those subvolumes and snapshots you painstakingly 
created aren't going to matter, it's all up in smoke, it just makes sense 
to subdivide that data roughly along functional lines and split it up 
into multiple independent btrfs, so that if a filesystem fails, it'll 
take only a fraction of the total data with it, and restoring/repairing/
rebuilding will hopefully only have to be done on a small fraction of 
that data.

Which brings us to rule #2:

2) Don't make your filesystems so large that any maintenance on them, 
including both filesystem maintenance like btrfs balance/scrub/check/
whatever, and normal backup and restore operations, takes impractically 
long, where "impractically" can be reasonably defined as so long it 
discourages you from doing them in the first place and/or so long that 
it's going to cause unwarranted downtime.

Some years ago, before I started using btrfs and while I was using 
mdraid, I learned this one the hard way.  I had a bunch of rather large 
mdraids setup, each with multiple partitions and filesystems[1].  This 
was before mdraid got proper write-intent bitmap support, so after a 
crash, I'd have to repair any of these large mdraids that had been active 
at the time, a process taking hours, even for the primary one containing 
root and /home, because it contained for example a large media partition 
that was unlikely to have been mounted at the same time.

After getting tired of this I redid things, putting each partition/
filesystem on its own mdraid.  Then it would take only a few minutes each 
for the mdraids for root, /home and /var/log, and I could be back in 
business with them in half an hour or so, instead of the couple hours I 
had to wait before, to get the bigger mdraid back up and repaired.  Sure, 
if the much larger media raid was active and the partition mounted too, 
I'd still have it to repair, but I could do that in the background.  And 
there was a good chance it was /not/ active and mounted at the time of 
the crash and thus didn't need repaired, saving that time entirely! =:^)

Eventually I arranged things so I could keep root mounted read-only 
unless I was updating it, and that's still the way I run it today.  That 
makes it very nice when a crash impairs /home and /var/log, since there's 
much less chance root was affected, and with a normal root mount, at 
least I have my full normal system available to me, including the latest 
installed btrfs-progs, and manpages and text-mode browsers such as lynx 
available to me to help troubleshoot, that aren't normally available in 
typical distros' rescue modes.

Meanwhile, a scrub (my btrfs but for /boot are raid1 both data and 
metadata, and /boot is mixed-mode dup, so scrub can normally repair crash 
damage getting the two mirrors out of sync) of root takes only ~10 
seconds, a scrub of /home takes only ~45 seconds, and a scrub of /var/log 
is normally done nearly as fast as I hit enter on the command.  
Similarly, btrfs balance and btrfs check normally run in under a minute, 
partly because I'm on ssd, and partly because those three filesystems are 
all well under 50 GiB each.

Of course I may have to run two or three scrubs, depending on what was 
mounted writable at the time of the crash, and I've had /home and /var/
log (but not root as it's read-only by default) go unmountable until 
repaired a couple times, but repairs are typically short too, and if that 
fails, blow away with a fresh mkfs.btrfs and restore from backup is 
typically well under an hour.

So I don't tend to be down for more than an hour.  Of course some other 
partitions may still need fixed, but that can continue in the background, 
while I'm back up and posting about it to the btrfs list or whatever.

Compare that to the current thread where someone's trying to do a resize 
of a 20+ TB btrfs and it was looking to take a week, due to the massive 
size and the slow speed of balance on his highly reflinked filesystem on 
spinning rust.

Point of fact.  If it's multiple TBs, chances are it's going to be faster 
to simply blow away and recreate from backup, than it is to try to 
repair... and repair may or may not actually work and leave you with a 
fully functional btrfs afterward.

Apparently that 20+ TB /is/ the backup, but it's a backup of a whole 
bunch of systems.  OK, so even if they'd still put all those backups on 
the same physical hardware, consider how much simpler it would have been 
had they had an independent btrfs of say a TB or two for each system they 
were backing up.  At 2 TB, it's possible to work with one or two at a 
time, copying them over to say a 3-4 TB hard drive (or btrfs raid1 with a 
pair of hard drives), blowing away the original partition, and copying 
back from the second backup.  But with a single 20+ TB monster, they 
don't have anything else close to that size to work with, and have to do 
the shrink-current-btrfs, expand-new-filesystem (which is xfs IIRC, 
they're getting off of btrfs), move-more-over-from-the-old-one, repeat, 
dance.  And /each/ /iteration/ of that dance is taking them a week or so!

What would they have done had the btrfs gone bad and needed repaired?  
Try repair and wait a week or two to see if it worked?  Blow away the 
filesystem as it was only the backup and recreate?

A single 20+ TB btrfs was clearly beyond anything practical for them.  
Had rule #2 been followed, they'd have never been in this spot in the 
first place, as even if all those backups from multiple machines (virtual 
or physical) were on the same hardware, they'd be in different 
independent btrfs, and those could be handled independently.

Of course once they're multiple independent btrfs, it would make sense to 
split that 20+ TB onto smaller hardware setups as well, and they'd have 
been dealing with less data overall too, because part of it would have 
been unaffected (or handled separately if they were moving it /all/) as 
it would have been on other machines.  Much like creating multiple mdraids 
and putting a single filesystem in each, instead of putting a bunch of 
data on a single mdraid, ended up working much better for me, because 
then only a fraction of the data was affected and I could do the repairs 
on those mdraids far faster as there wasn't as much data to deal with!

But like I said I'm biased.  By hard experience, yes, and getting the 
sizes for the partitions wrong can be a hassle until you get to know your 
use-case and size them correctly, but it's a definite bias.

---
[1] Partitions and filesystems:  I had learned about a somewhat different 
benefit of multiple partitions and filesystems even longer ago, 1997 or 
so, when I was still on MS, testing an IE 4 beta that for performance 
reasons used direct-disk IO on its cache-index file, but it forgot to set 
the system attribute on it that would have kept defrag from touching it.  
So defrag would move the file out from under the now constantly running 
IE, as IE was part of the explorer shell.  IE would then happily 
overwrite whatever got moved into the old index file location, and a 
number of testers had important files seriously damaged that way.  I 
didn't, because I had my cache on a separate "temp" partition, so while 
it could and did still damage data, all it could touch was "temporary" 
data in the first place, meaning no real damage on my system. =:^)  All 
because I had the temp data on its own partition/filesystem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

