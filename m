Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44714 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab3KPWTr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 17:19:47 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VhoDR-0006yP-Qt
	for linux-btrfs@vger.kernel.org; Sat, 16 Nov 2013 23:19:45 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 23:19:45 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 23:19:45 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs resize partition problem
Date: Sat, 16 Nov 2013 22:19:21 +0000 (UTC)
Message-ID: <pan$32f6c$5635c224$e9b25768$a7831c50@cox.net>
References: <5287D775.1090105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dejan Ribič posted on Sat, 16 Nov 2013 21:37:09 +0100 as excerpted:

> but it got me thinking why do I even have a seperate partition for home

[List plus direct mail reply, as requested.  Please remind me again with 
followups and don't post to both me and the list as I do follow the list 
and don't need duplicates.]

I've no direct answer to your posted problem, tho I have some 
suggestions.  But, based on your mention of pacman I guess you're on 
arch, and FWIW I'm on gentoo, both considered reasonably "expert" level 
distros, and based on that...

Far be it from me to interfere with another admin's partitioning choices, 
but because the question came up and based both on general 
recommendations and my own at times hard learned experience...

People often use separate partitions because they don't want all their 
data eggs in one basket, and because it makes administration easier for 
some things.  A read-only by default rootfs is far safer in the event of 
a system crash, for instance, and can be quite practical if any data 
that's routinely written is kept on other partitions (like /home) while a 
read-only /home isn't viable for a normal desktop use-case, at least.  
While it's possible to mount a subvolume read-only while another is 
mounted read-write, or to use bind-mounts on part of a filesystem to make 
only part of it read-write, much of the data safety of the read-only side 
disappears if they're on the same overall filesystem, since its the same 
overall filesystem tree exposed to corruption in the case of a crash.  
Keep the filesystems separate, and read-only mounts are relatively 
unlikely to be harmed at all in the event of a crash, generally limiting 
risk to read-write mounted filesystems.

A read-only root (and /usr if it's separately mounted, not so often these 
days and /usr is on rootfs here) is particularly useful, since that's 
normally where all the recovery tools live, along with full usage 
documentation (manpages, etc, NOT typically available in an initr* based 
recovery situaiton), meaning if a working full rootfs is mountable, it's 
far easier to do further recovery from there, and a read-only-by-default 
rootfs makes problem free mounting of that rootfs FAR more likely!

Meanwhile, /home is often kept separate both because it usually needs to 
be mounted writable, and because that makes dealing with user data only, 
generally the most valuable part of a desktop/laptop installation, far 
easier.

Similarly, either all of /var, or bits such as /var/log, /var/cache, /var/
spool, etc, are often managed separately so they can be writable, some of 
them (/var/run) can be tmpfs, etc.  And keeping /var/log in particular on 
its own partition tends to be VERY helpful in a runaway logging event, 
since the full partition is then caught rather sooner and resultant 
damage is confined to logs.  Additionally, logfiles tend to be actively 
open for write in a crash, and keeping an independent /var/log again 
drastically limits the likely damage to /just/ /var/log.

While the case can certainly be debated and a lot of the big name distros 
*ARE* going for a single big btrfs with a bunch of subvolumes these days, 
I expect any admin with a decent bit of hard-earned experience under his 
belt will view such a practice as suspect, likely EXTREMELY suspect.  
"Let the distros do what they want by default, but that's not getting 
anywhere NEAR *MY* systems!!" level suspect!

Certainly that's the case here.  There's a /reason/ I maintain separate 
partitions.  That reason is that doing so has MANY times saved my data!


That goes double for an experimental filesystem under heavy development 
such as btrfs remains ATM.  Certainly, keep solid and tested backups 
applies even more to experimental filesystems such as btrfs than stable 
filesystems such as ext3/4 and reiserfs, and NOT keeping tested backups 
on any data you're putting on an experimental filesystem such as btrfs 
demonstrates by action that you do NOT care about that data, whatever you 
might SAY, but that does NOT mean throwing routine caution to the wind!

And again, btrfs being experimental as it is, a read-only-by-default 
rootfs (or even read-write by default, since it's relatively unlikely to 
have been being actively written at the time of a crash) tends not to get 
the damage constantly written to filesystems such as /home and /var/log 
get, so keeping them on entirely separate filesystems makes even MORE 
sense, as it severely limits the risk placed on the rootfs, making 
recovery of damaged filesystems both shorter and easier since they are 
smaller and there's simply less data and metadata involved /to/ need 
recovery.


OTOH, the big name distros are going subvolumed btrfs, and if it's good 
enough for them...

But it's *STILL* not getting anywhere near *MY* systems!  Let them do 
what they do, I've learned waayyy too many of my lessons the HARD way, 
and I'm *NOT* going to unlearn them just to have to learn them again!

That said, your system, your call.  I'd not /dream/ of taking that right 
away from you. =:^)


Meanwhile, addressing your problem:  Try mounting with the clear_cache 
option as described on the btrfs wiki, under documentation, mount 
options.  Also, the fact that you weren't already aware of that hints 
that you likely weren't aware of the wiki itself, or haven't spent much 
time reading it.  I'd suggest you do so, as there's likely quite a bit 
more information there that you'll find useful:

https://btrfs.wiki.kernel.org

https://btrfs.wiki.kernel.org/index.php/Mount_options

Finally, keep in mind that btrfs does remain experimental at this point, 
under rapid development, and anyone using it is in effect volunteering to 
test btrfs using their data.  I *STRONGLY* recommend a backup and backup 
recovery testing strategy keeping that in mind.  Similarly, keeping 
current on both kernel and btrfs-progs is vital -- you should be on at 
LEAST a 3.11 kernel if not 3.12 by now and likely switching to 3.13 
sometime in the development cycle, as running btrfs on a kernel more than 
two releases old means you're unnecessarily risking your data to known 
patched bugs, as well as making any problem reports less useful.  And 
btrfs-progs should be at LEAST version 0.20-rc1, which is already about a 
year old, and preferably you should be running a recent git build, as 
btrfs-progs development happens in branches and the git master branch 
policy is release quality at all times.

And as a btrfs tester, you really /should/ either subscribe to the list, 
or follow it regularly somewhere like gmane.org (FWIW I use their nntp 
interface here), as that way you know what's going on and may well get a 
heads-up on bugs before they affect you, or at least know better how to 
fix them when they do.  Of course, nobody's forcing you.  But it's your 
data at risk (or at least restore time, since your data should be backed 
up and thus restorable) if you hit a bug that might have been avoided had 
you been following the list and would have thus known about it before you 
hit it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

