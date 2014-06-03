Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60923 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbaFCEqt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jun 2014 00:46:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wrgca-0004Xr-1G
	for linux-btrfs@vger.kernel.org; Tue, 03 Jun 2014 06:46:48 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jun 2014 06:46:48 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jun 2014 06:46:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: All free space eaten during defragmenting (3.14)
Date: Tue, 3 Jun 2014 04:46:35 +0000 (UTC)
Message-ID: <pan$70d58$14dcbb11$e72f6493$4dc866e2@cox.net>
References: <1703083.hLnNuPsKpY@linux-suse.hu>
	<pan$d1ec3$d22b3db$8681b9b1$d9742e40@cox.net>
	<538B8F76.9090500@petezilla.co.uk>
	<pan$40c68$d9ca1c60$28b3a30c$43e8d611@cox.net>
	<538CE4A0.9020105@petezilla.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Peter Chant posted on Mon, 02 Jun 2014 21:54:56 +0100 as excerpted:

>> What I /meant/ was "only defragging what you pointed the defrag at",
>> not the other snapshots of the same subvolume.  "Mounted" shouldn't
>> have anything to do with it, except that I didn't consider the
>> possibility of having the other snapshots mounted at the same time, so
>> said "mounted" when I meant the one you pointed defrag at as I wasn't
>> thinking about having the others mounted too.
> 
> Interesting.  I have set autodefrag in fstab.  I _may_ have previously
> tried to defrag the top-level subvolume - faint memory, that is
> pointless, as if a file exists in more than one subvolume and it is
> changed in one or more it cannot be optimally defraged in all subvols at
> once if I understand it correctly - as bits of it are common and bits
> differ?  Or maybe separate whole copies of the file are created?  So if
> using snapshots only defrag the one you are actively using, if I
> understand correctly.

Hmm... that brings up an interesting question.  I know snapshots stop at 
subvolume boundaries, but I haven't the foggiest how the -r/recursive 
option to defrag behaves.  Does defrag stop at subvolume boundaries (and 
thus snapshot boundaries, as they're simply special-case subvolumes that 
point at the same data as another subvolume as of the time they were 
taken) too?  If not, what about entirely separate filesystem boundaries 
where a second btrfs filesystem happen to be mounted inside the 
recursively defragged tree?  I simply don't know, tho I strongly suspect 
it doesn't cross full filesystem boundaries, at least.

Of course if you were using something like find and executing defrag on 
each found entry, then yes it would recurse, as find would recurse across 
filesystems and keep going (unless you told it not to using find's -xdev 
option).


Meanwhile, you mention the autodefrag mount option.  Assuming you have it 
on all the time, there should be that much to defrag, *EXCEPT* if the -c/
compress option is used as well.  If you aren't also using the compress 
mount option by default, then you are effectively telling defrag to 
compress everything as it goes, so it will defrag-and-compressed all 
files.  Which wouldn't be a problem with snapshot-aware-defrag as it'd 
compress for all snapshots at the same time too.  But with snapshot-aware-
defrag currently disabled, that would effectively force ALL files to be 
rewritten in ordered to compress them, thereby breaking the COW link with 
the other snapshots and duplicating ALL data.

Which would SERIOUSLY increased data usage, doubling it, except that the 
compression would reduce the size of the new version, so perhaps only a 
50% increase in data usage, with the caveat that the effectiveness of the 
compression and thus the 50% number would vary greatly depending on the 
compressibility of the data in question.

Thus, if the OP were NOT using compression previously, it was the -clzo 
that /really/ blew things up the data usage, as without snapshot-aware-
defrag enabled he was effectively duplicating everything that defrag saw 
in ordered to compress it!  (If he was using the compress=lzo option 
before and had always used it, then adding the -clzo to defrag shouldn't 
have mattered at all, since the compress mount option would have done the 
same thing during the defrag as the defrag compress option.)

I guess that wasn't quite the intended effect of adding the -clzo flag!  
All because of the lack of snapshot-aware-defrag.

>> 2) With snapshot-aware-defrag (ideal but currently disabled due to
>> scaling issues with the current code), defrag would take account of all
>> the snapshots containing the same data, and would change them /all/ to
>> point to the new data location, when defragging a snapshotted file.
>> 
>> 
> This is an issue I'm not really up on, and is one of the things I was
> reading with interest on the list.
> 
>> 3) Unfortunately, with the snapshot-awareness disabled, it will only
>> defrag the particular instance of the data (normally the online working
>> instance) you actually pointed defrag at, ignoring the other snapshots
>> still pointing at the old instance, thereby duplicating the data, with
>> all the other instances of the data still pinned by their snapshot to
>> the old location, while only the single instance you pointed defrag at
>> actually gets defragged, thereby breaking the COW link with the other
>> instances and duplicating the defragged data.
> 
> So with what I am doing, creating snapshots for 'backup' purposes only,
> this should not be a big issue as this will only affect the 'working
> copy'.  (No, btrfs snapshots are not my backup solution.)

If the data that you're trying to defrag is snapshotted, the defrag will 
currently break the COW link and double usage.  However, as long as you 
have the space to spare and are deleting the snapshots in a reasonable 
time (as it sounds like you are since it seems you're doing snapshots 
only to enable a stable backup), once you delete all the snapshots from 
before the defrag, you should get the space back, so it's not a permanent 
issue.

>> That said, there's a couple reasons one might go to the inconvenience
>> of doing the mount/umount dance, so the snapshots are only available
>> when they're actually being worked with.  The first is that unmounted
>> data is less likely to be accidentally damaged (altho when it's
>> subvolumes/ snapshots on the same master filesystem, the separation and
>> protection from damage isn't as great as if they were entirely seperate
>> filesystems, but of course you can't snapshot to entirely separate
>> filesystems).
>> 
>> 
> The protection from damage could also or perhaps better being enforced
> using read only snapshots?

Yes.  But you can put me in the multiple independent btrfs filesystems, 
each on their own partitions, camp.  My problem in principle with one big 
filesystem with subvolumes and snapshots, is that should something happen 
to damage that filesystem such that it cannot be fully recovered, all 
those snapshot and subvolume "data eggs" are in the same filesystem 
"basket", and if it drops, all those eggs are lost at the same time!

So I still vastly prefer traditional partitioning methods, with several 
independent filesystems each on their own partition, and in fact, backup 
partitions/filesystems as well, with the primary backups on partitions on 
the same pair of (mostly btrfs raid1) physical devices.  That way, if one 
btrfs filesystem or even all that were currently mounted go unrecoverably 
bad at the same time, the damage is limited, and I still have the first-
backups on the same device-pair I can boot to.  (FWIW, I have additional 
backups on other devices, just in case it's the operating device pair 
that go bad at the same time, tho I don't necessarily keep them to the 
same level of currency, as I don't consider the risk of both operating 
devices going bad at the same time all that high and accept that level of 
risk should it actually occur.)

So I'm used to unmounted meaning the whole filesystem is not in use and 
therefore reasonable safe from damage, while if it's only subvolumes/
snapshots on the same master filesystem, the level of safety in keeping 
them unmounted (or read-only mounted if mounted at all) isn't really 
comparable to the entirely separate filesystem case.  But certainly, 
there's still /some/ benefit to it.  But that's why I added the 
parenthetical caveat, because in the middle of writing that paragraph, I 
realized that the safety element wasn't as big a deal as I had originally 
thought when I started the paragraph, because I'm used to dealing with 
the separate filesystems case and that didn't apply here.

>> The second and arguably more important reason has to do with security,
>> specifically root escalation vulnerabilities.  Consider system updates
>> that include a security update for such a root escalation
>> vulnerability. Normally, you'd take a snapshot before doing the update,
>> so as to have a chance to rollback to the pre-update snapshot in case
>> something in the update goes wrong.  That's a good policy, but what
>> happens to that security update?  Now the pre-update snapshot still
>> contains the vulnerable version, even while the working copy is patched
>> and is no longer vulnerable.  Now, if you keep those snapshots mounted
>> and some bad guy gets user access to your system, they can access the
>> still vulnerable copy in the pre-update snapshot to upgrade their user
>> access to root. =:^(
>> 
> This is an interesting point.  The changes are not too radical, all I
> need to do is add code to my snapshot scripts to mount and unmount my
> toplevel btrfs tree when performing a snapshot. Not sure if this causes
> any sigificant time penulty as in slowing of the system with any heavy
> IO.  Since snapshots are run by cron then the time taken to complete is
> not critical, rather whether the act of mounting and unmounting causes
> any slowing due to heavy IO.

Lest there be any confusion I should note that idea isn't original to 
me.  But as I'm reasonably security focused, once I read it on the list, 
it definitely ranked rather high on my "snapshots considerations" list, 
and you can bet I'll never have the master subvolume routinely mounted 
here as a result!

Meanwhile, unless there's something strange going on, mounts shouldn't 
affect ongoing I/O much at all.  Umounts are slightly different, in that 
on btrfs there can be some housekeeping that must be done before the 
filesystem is fully unmounted that could in theory disrupt ongoing I/O 
temporarily, but that's limited to writable mounts where some serious 
write-activity occurred, such that if you're just mounting to do a 
snapshot and umounting again, I don't believe that should be a problem, 
since in the normal case there will be only a bit of metadata to update 
from the process of doing the snapshot.

FWIW, while I actually don't do much snapshotting here, I have something 
similar setup for my "packages" filesystem, which is unmounted unless I'm 
doing system updates or package queries, and for my rootfs, which is 
mounted read-only, again unless I'm updating it.  My package-tree-update 
scripts check to see if the packages filesystem is mounted and if not 
mount it, and remount my rootfs read-write, before syncing the packages-
tree from remote.  When I'm done, I have another script that umounts the 
packages tree, and remounts the rootfs ro once again.

And you're right, in comparison to the rest of the scripts, the mounting 
bit is actually quite trivial. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

