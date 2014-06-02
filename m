Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-6.server.virginmedia.net ([80.0.253.70]:53277
	"EHLO know-smtprelay-omc-6.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbaFBUy7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jun 2014 16:54:59 -0400
Message-ID: <538CE4A0.9020105@petezilla.co.uk>
Date: Mon, 02 Jun 2014 21:54:56 +0100
From: Peter Chant <pete@petezilla.co.uk>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: All free space eaten during defragmenting (3.14)
References: <1703083.hLnNuPsKpY@linux-suse.hu>	<pan$d1ec3$d22b3db$8681b9b1$d9742e40@cox.net>	<538B8F76.9090500@petezilla.co.uk> <pan$40c68$d9ca1c60$28b3a30c$43e8d611@cox.net>
In-Reply-To: <pan$40c68$d9ca1c60$28b3a30c$43e8d611@cox.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/01/2014 11:47 PM, Duncan wrote:

>>> Here's the deal.  Due to scaling issues the original snapshot aware
>>> defrag code was recently disabled, so defrag now doesn't worry about
>>> snapshots, only defragging whatever is currently mounted.  If you have
>>> a lot of fragmentation and are using snapshots, the defrag will copy
>>> all those fragmented files in ordered to defrag them, thus duplicating
>>> their blocks and doubling their required space.  Based on the title
>>> alone, that's what I /thought/ happened, and given what you did /not/
>>> say, I actually still think it is the case and the below assumes that,
>>> tho I'm no longer entirely sure.
>>
>> The above implies to me that snapshots should not normally be mounted? I
>> may have misread the intent.
> 
> Indeed you misread, because I didn't say exactly what I meant and you 
> found a different way of interpreting it that I didn't consider. =:^\
> 

I was mildly confused.  Situation normal...


> What I /meant/ was "only defragging what you pointed the defrag at", not 
> the other snapshots of the same subvolume.  "Mounted" shouldn't have 
> anything to do with it, except that I didn't consider the possibility of 
> having the other snapshots mounted at the same time, so said "mounted" 
> when I meant the one you pointed defrag at as I wasn't thinking about 
> having the others mounted too.

Interesting.  I have set autodefrag in fstab.  I _may_ have previously
tried to defrag the top-level subvolume - faint memory, that is
pointless, as if a file exists in more than one subvolume and it is
changed in one or more it cannot be optimally defraged in all subvols at
once if I understand it correctly - as bits of it are common and bits
differ?  Or maybe separate whole copies of the file are created?  So if
using snapshots only defrag the one you are actively using, if I
understand correctly.

Thanks for the hint, it has aided my understanding.


> 
>> My thought is that I have a btrfs to hold data on my system, it contains
>> /home in a subvolume and also subvolumes for various other things.  I
>> take daily, hourly and weekly snapshots and my script does delete old
>> ones after a while.
>>
>> I also mount the base/default btrfs file system on /mnt/data-pool.  This
>> means that my snapshots are available in their own subdirectory, so I
>> presume this means that they are mounted, if not in their own right, at
>> least they are as part of the default subvolume.  Given the
>> defragmentation discussion above should I be doing this or should my
>> setup ensure that they are not normally mounted?
> 
> Your setup is fine in that regard.  My mis-speak. =:^(


Don't think it is that big an issue!  I was slightly puzzled by a
potential implication of your post v my user knowledge of btrfs.

> 
> The question now is, did my mis-speak fatally flaw delivery of my 
> intended point, or did you get it (at least after this correction) in 
> spite of my mis-speak?
> 
> That point being in three parts... 
> 
> 1) btrfs snapshots work without using too much space because of btrfs' 
> copy-on-write (COW) nature.  Normally, unless there is a change in the 
> data from that which was snapshotted, the data will occupy the same 
> amount of space no matter how many times you snapshot it.
> 

Got this.  Killer feature unless you want to store tiny amounts of data
on huge disks if you snap-shot.  Got it.

> 2) With snapshot-aware-defrag (ideal but currently disabled due to 
> scaling issues with the current code), defrag would take account of all 
> the snapshots containing the same data, and would change them /all/ to 
> point to the new data location, when defragging a snapshotted file.
> 

This is an issue I'm not really up on, and is one of the things I was
reading with interest on the list.

> 3) Unfortunately, with the snapshot-awareness disabled, it will only 
> defrag the particular instance of the data (normally the online working 
> instance) you actually pointed defrag at, ignoring the other snapshots 
> still pointing at the old instance, thereby duplicating the data, with 
> all the other instances of the data still pinned by their snapshot to the 
> old location, while only the single instance you pointed defrag at 
> actually gets defragged, thereby breaking the COW link with the other 
> instances and duplicating the defragged data.

So with what I am doing, creating snapshots for 'backup' purposes only,
this should not be a big issue as this will only affect the 'working
copy'.  (No, btrfs snapshots are not my backup solution.)

> 
>> I'm not aware of how you would create a subvolume that was outside of a
>> mounted part of the file system 'tree' - so if I did not want my
>> subvolumes mounted and I wanted snapshots then I'd have to mount the
>> default subvolume, make snapshots, and then unmount it?  This seems a
>> bit clumsy and I'm not convinced that this is a sensible plan.  I don't
>> think this is right, can anyone confirm or deny?
> 
> Doing the mount "master" subvolume, make snapshots, then unmount, so the 
> snapshots are only available when the "master" subvolume is mounted, is 
> one valid way of handling things.  However, it's not the only way.  Your 
> way, keeping the "master" mounted all the time as well, is also valid.  I 
> simply forgot that case in my original mis-speak.
> 
> That said, there's a couple reasons one might go to the inconvenience of 
> doing the mount/umount dance, so the snapshots are only available when 
> they're actually being worked with.  The first is that unmounted data is 
> less likely to be accidentally damaged (altho when it's subvolumes/
> snapshots on the same master filesystem, the separation and protection 
> from damage isn't as great as if they were entirely seperate filesystems, 
> but of course you can't snapshot to entirely separate filesystems).
> 

The protection from damage could also or perhaps better being enforced
using read only snapshots?

> The second and arguably more important reason has to do with security, 
> specifically root escalation vulnerabilities.  Consider system updates 
> that include a security update for such a root escalation vulnerability.  
> Normally, you'd take a snapshot before doing the update, so as to have a 
> chance to rollback to the pre-update snapshot in case something in the 
> update goes wrong.  That's a good policy, but what happens to that 
> security update?  Now the pre-update snapshot still contains the 
> vulnerable version, even while the working copy is patched and is no 
> longer vulnerable.  Now, if you keep those snapshots mounted and some bad 
> guy gets user access to your system, they can access the still vulnerable 
> copy in the pre-update snapshot to upgrade their user access to root. =:^(
> 
> Now most systems today are effectively single-human-user and that human 
> user has root access anyway, so it's not the huge deal it would be on a 
> full multi-user system.  However, just as best practice says don't run as 
> root all the time, best practice also says don't leave those pre-update 
> root-escalation vulnerable executables laying around for just anyone who 
> happens to have user-level execute privileges to access.  Thus, keeping 
> the "master" subvolume unmounted and access to those old snapshots 
> restricted, except when actually working with the snapshots, is 
> considered good policy, for the same reason that not "taking the name of 
> root in vain" is considered good policy.
> 
> But it's your system and your policies, serving at your convenience.  So 
> whether that's too much security at the price of too little convenience, 
> is up to you. =:^)
> 

This is an interesting point.  The changes are not too radical, all I
need to do is add code to my snapshot scripts to mount and unmount my
toplevel btrfs tree when performing a snapshot. Not sure if this causes
any sigificant time penulty as in slowing of the system with any heavy
IO.  Since snapshots are run by cron then the time taken to complete is
not critical, rather whether the act of mounting and unmounting causes
any slowing due to heavy IO.

It does not seem to offer too many absolutes in the way of security or
does it?  I suppose it does, for a normal user, remove access to older
binaries that may have shortcomings.  Suspect permissions could solve
that as well.

Food for thought in any case.  Thank you.

Pete




-- 
Peter Chant
