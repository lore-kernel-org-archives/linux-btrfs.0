Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38627 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaFAWrV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 Jun 2014 18:47:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WrEX6-00012A-JC
	for linux-btrfs@vger.kernel.org; Mon, 02 Jun 2014 00:47:16 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jun 2014 00:47:16 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jun 2014 00:47:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: All free space eaten during defragmenting (3.14)
Date: Sun, 1 Jun 2014 22:47:04 +0000 (UTC)
Message-ID: <pan$40c68$d9ca1c60$28b3a30c$43e8d611@cox.net>
References: <1703083.hLnNuPsKpY@linux-suse.hu>
	<pan$d1ec3$d22b3db$8681b9b1$d9742e40@cox.net>
	<538B8F76.9090500@petezilla.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Peter Chant posted on Sun, 01 Jun 2014 21:39:18 +0100 as excerpted:

> I have a question that has arisen from reading one of Duncan's posts:
> 
> On 06/01/2014 01:56 AM, Duncan wrote:
> 
>> Here's the deal.  Due to scaling issues the original snapshot aware
>> defrag code was recently disabled, so defrag now doesn't worry about
>> snapshots, only defragging whatever is currently mounted.  If you have
>> a lot of fragmentation and are using snapshots, the defrag will copy
>> all those fragmented files in ordered to defrag them, thus duplicating
>> their blocks and doubling their required space.  Based on the title
>> alone, that's what I /thought/ happened, and given what you did /not/
>> say, I actually still think it is the case and the below assumes that,
>> tho I'm no longer entirely sure.
> 
> The above implies to me that snapshots should not normally be mounted? I
> may have misread the intent.

Indeed you misread, because I didn't say exactly what I meant and you 
found a different way of interpreting it that I didn't consider. =:^\

What I /meant/ was "only defragging what you pointed the defrag at", not 
the other snapshots of the same subvolume.  "Mounted" shouldn't have 
anything to do with it, except that I didn't consider the possibility of 
having the other snapshots mounted at the same time, so said "mounted" 
when I meant the one you pointed defrag at as I wasn't thinking about 
having the others mounted too.

> My thought is that I have a btrfs to hold data on my system, it contains
> /home in a subvolume and also subvolumes for various other things.  I
> take daily, hourly and weekly snapshots and my script does delete old
> ones after a while.
> 
> I also mount the base/default btrfs file system on /mnt/data-pool.  This
> means that my snapshots are available in their own subdirectory, so I
> presume this means that they are mounted, if not in their own right, at
> least they are as part of the default subvolume.  Given the
> defragmentation discussion above should I be doing this or should my
> setup ensure that they are not normally mounted?

Your setup is fine in that regard.  My mis-speak. =:^(

The question now is, did my mis-speak fatally flaw delivery of my 
intended point, or did you get it (at least after this correction) in 
spite of my mis-speak?

That point being in three parts... 

1) btrfs snapshots work without using too much space because of btrfs' 
copy-on-write (COW) nature.  Normally, unless there is a change in the 
data from that which was snapshotted, the data will occupy the same 
amount of space no matter how many times you snapshot it.

2) With snapshot-aware-defrag (ideal but currently disabled due to 
scaling issues with the current code), defrag would take account of all 
the snapshots containing the same data, and would change them /all/ to 
point to the new data location, when defragging a snapshotted file.

3) Unfortunately, with the snapshot-awareness disabled, it will only 
defrag the particular instance of the data (normally the online working 
instance) you actually pointed defrag at, ignoring the other snapshots 
still pointing at the old instance, thereby duplicating the data, with 
all the other instances of the data still pinned by their snapshot to the 
old location, while only the single instance you pointed defrag at 
actually gets defragged, thereby breaking the COW link with the other 
instances and duplicating the defragged data.

> I'm not aware of how you would create a subvolume that was outside of a
> mounted part of the file system 'tree' - so if I did not want my
> subvolumes mounted and I wanted snapshots then I'd have to mount the
> default subvolume, make snapshots, and then unmount it?  This seems a
> bit clumsy and I'm not convinced that this is a sensible plan.  I don't
> think this is right, can anyone confirm or deny?

Doing the mount "master" subvolume, make snapshots, then unmount, so the 
snapshots are only available when the "master" subvolume is mounted, is 
one valid way of handling things.  However, it's not the only way.  Your 
way, keeping the "master" mounted all the time as well, is also valid.  I 
simply forgot that case in my original mis-speak.

That said, there's a couple reasons one might go to the inconvenience of 
doing the mount/umount dance, so the snapshots are only available when 
they're actually being worked with.  The first is that unmounted data is 
less likely to be accidentally damaged (altho when it's subvolumes/
snapshots on the same master filesystem, the separation and protection 
from damage isn't as great as if they were entirely seperate filesystems, 
but of course you can't snapshot to entirely separate filesystems).

The second and arguably more important reason has to do with security, 
specifically root escalation vulnerabilities.  Consider system updates 
that include a security update for such a root escalation vulnerability.  
Normally, you'd take a snapshot before doing the update, so as to have a 
chance to rollback to the pre-update snapshot in case something in the 
update goes wrong.  That's a good policy, but what happens to that 
security update?  Now the pre-update snapshot still contains the 
vulnerable version, even while the working copy is patched and is no 
longer vulnerable.  Now, if you keep those snapshots mounted and some bad 
guy gets user access to your system, they can access the still vulnerable 
copy in the pre-update snapshot to upgrade their user access to root. =:^(

Now most systems today are effectively single-human-user and that human 
user has root access anyway, so it's not the huge deal it would be on a 
full multi-user system.  However, just as best practice says don't run as 
root all the time, best practice also says don't leave those pre-update 
root-escalation vulnerable executables laying around for just anyone who 
happens to have user-level execute privileges to access.  Thus, keeping 
the "master" subvolume unmounted and access to those old snapshots 
restricted, except when actually working with the snapshots, is 
considered good policy, for the same reason that not "taking the name of 
root in vain" is considered good policy.

But it's your system and your policies, serving at your convenience.  So 
whether that's too much security at the price of too little convenience, 
is up to you. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

