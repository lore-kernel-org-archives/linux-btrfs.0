Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38245 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbbIZAfE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 20:35:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZfdS4-0006Zv-Ju
	for linux-btrfs@vger.kernel.org; Sat, 26 Sep 2015 02:34:56 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2015 02:34:56 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2015 02:34:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Too many missing devices, writeable mount is not allowed
Date: Sat, 26 Sep 2015 00:34:35 +0000 (UTC)
Message-ID: <pan$c02eb$eb6194ff$337f1420$14d8a8e@cox.net>
References: <20150925214544.GB4639@herrbischoff.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marcel Bischoff posted on Fri, 25 Sep 2015 23:45:44 +0200 as excerpted:

> Hello all,
> 
> I have kind of a serious problem with one of my disks.
> 
> The controller of one of my external drives died (WD Studio). The disk
> is alright though. I cracked open the case, got the drive out and
> connected it via a SATA-USB interface.
> 
> Now, mounting the filesystem is not possible. Here's the message:
> 
> $ btrfs fi show
> warning devid 3 not found already
> Label: none  uuid: bd6090df-5179-490e-a5f8-8fbad433657f
>         Total devices 3 FS bytes used 3.02TiB
>         devid    1 size 596.17GiB used 532.03GiB path /dev/sdd
>         devid    2 size 931.51GiB used 867.03GiB path /dev/sde
>         *** Some devices missing
> 
> Yes, I did bundle up three drives with very different sizes with the
> --single option on creating the file system.

[FWIW, the additional comments on the stackexchange link didn't load for 
me, presumably due to my default security settings.  I could of course 
fiddle with them to try to get it to work, but meh...  So I only saw the 
first three comments or so.  As a result, some of this might be repeat 
territory for you.]

?? --single doesn't appear to be a valid option for mkfs.btrfs.  Did you 
mean --metadata single and/or --data single?  Which?  Both?

If you were running single metadata, like raid0, you're effectively 
declaring the filesystem dead and not worth the effort to fix if a device 
dies and disappears.  In which case you got what you requested, a multi-
device filesystem that dies when one of the devices dies. =:^)  Tho it 
may still be possible to revive the filesystem if you can get the bad 
device recovered enough to get it to be pulled into the filesystem, again.

That's why metadata defaults to raid1 (tho btrfs raid1 is only pair-
mirror, even if there's more than two devices) on a multi-device 
filesystem.  So if you didn't specify --metadata single, then it should 
be raid1 (unless the filesystem started as a single device and was never 
balance-converted when the other devices were added).

--data single is the default on both single and multi-device filesystems, 
however, which, given raid1 metadata, should at least let you recover 
files that were 100% on the remaining devices.  I'm assuming this, as it 
would normally allow read-only mounting due to the second copy of the 
metadata, but isn't going to allow writable mounting because with single 
data, that would damage any possible chance of getting the data on the 
missing device back.  Chances of getting writable if the missing device 
is as damaged as it could be are slim, but it's possible, if you can 
bandaid it up.  However, even then I'd consider it suspect and would 
strongly recommend taking the chance you've been given to freshen your 
backups, then at least btrfs device delete (or btrfs replace with another 
device), if not blow away the filesystem and start over with a fresh 
mkfs.  Meanwhile, do a full write/read test (badblocks or the like) of 
the bad device, before trying to use it again.

The other (remote) possibility is mixed-bg mode, combining data and 
metadata in the same block-groups.  But that's default only with 1 GiB 
and under filesystems (and with filesystems converted from ext* with some 
versions of btrfs-convert), so it's extremely unlikely unless you 
specified that at mkfs.btrfs time, in which case mentioning that would 
have been useful.

A btrfs filesystem df (or usage) should confirm both data and metadata 
status.  The filesystem must be mounted to run it, but read-only degraded 
mount should do.

[More specific suggestions below.]

> I have already asked for help on StackExchange but replies have been
> few. Now I thought people on this list, close to btrfs development may
> be able and willing to help. This would be so much appreciated.
> 
> Here's the issue with lots of information and a record of what I/we have
> tried up until now:
> http://unix.stackexchange.com/questions/231174/btrfs-too-many-missing-
devices-writeable-mount-is-not-allowed

OK, first the safe stuff, then some more risky possibilities...

1) Sysadmin's rule of backups:  If you value data, by definition, you 
have it backed up.  If it's not backed up, by definition, you definitely 
value it less than the time and resources saved by not doing the backups, 
not withstanding any claims to the contrary.  (And by the same token, a 
would-be backup that hasn't been tested restorable isn't yet a backup, as 
the job isn't complete until you know it can be restored.)

1a) Btrfs addendum: Because btrfs is still a maturing filesystem not yet 
fully stabilized, the above backup rule applies even more strongly than 
it does to a more mature filesystem.

So in worst-case, just blow away the existing filesystem and start over, 
either restoring from those backups, or happy in the knowledge that since 
you didn't have them, you self-evidently didn't value the data on the 
filesystem, and can go on without it.[1]

2) Since you can mount read-only, I'll guess your metadata is raid1, with 
single data.  Which (as mentioned above) means you should at least have 
access to the files that didn't have any extents on the missing device.  
If you don't yet have backups, now is your best chance to salvage what 
you can by doing a backup of the files you can read, while you can.  From 
the looks of that btrfs fi show, you might be able to save a TiB worth, 
out of the three TiB data it says you had.  Depending on fragmentation, 
it could be much less than that, but in any case, might as well retrieve 
what you can while you know you can.


That's the end of the easy/safe stuff.  If you didn't have backups and 
didn't choose to backup what you could still get at above while you can 
still mount read-only at least, the below risks losing access to what you 
have now, so I'd strongly urge you to reconsider before proceeding.

3) Try btrfs-show-super -a (all superblocks, there are three copies, the 
first of which is normally used but which appears to be blank in your 
case) on the bad device.

With luck, it'll reveal at least one intact superblock.  If it does, you 
can use btrfs rescue super-recover to try to restore the first/primary 
superblock.

But even with a restored superblock, there's a good chance the rest of 
the filesystem on that device is too mangled to work.  There's btrfs 
rescue chunk-recover, and a couple btrfs check --repair options, but I've 
never had to use them, and would thus be pretty much shooting in the dark 
trying to use them myself, so won't attempt to tell you how to use them.


Bottom line, sysadmin's backups rule above, if you value the data, it's 
backed up, if it's not backed up, you self-evidently don't value the 
data, despite claims to the contrary.  And if you want your btrfs multi-
device filesystem to work after loss of a device, use a raid mode that 
will allow you to recover using either redundancy (raid1,10) or parity 
(raid5,6), for both data and metadata.  Because using single or (worse) 
raid1, even for just data with metadata having better protection, 
basically means you're willing to simply scrap the filesystem and restore 
from backups if you lose a device.  And as anybody who has run raid0 for 
long can tell you, losing one device out of many is a LOT more likely 
than losing the only device in a single-device setup.  Yes, it's 
sometimes possible to recover still, especially if the metadata was 
parity/redundancy protected, but you can't count on it, and even if so, 
it's a huge hassle, such that if you have backups it's generally easier 
just to blow it away and restore from the backups, and if not, well, 
since you're defining the value of that data as pretty low by not having 
those backups, no big loss, meaning it's still often easier to simply 
blow it away and start over.

---
[1] Seriously!  Big-picture, there are more important things in life than 
computer data.  My neighbor had his house burn down a couple months ago.  
Got out with a pair of shorts he was wearing to bed, not so much as ID to 
help him get started again!  I don't know about you, but while losing un-
backed-up-data isn't pleasant, I'd a whole lot rather be picking up my 
life after some lost data than picking it up after losing everything in a 
fire, as he is! But he counts himself lucky getting out alive and not 
even burned, as a lot of people in bed asleep when the fire starts don't 
make it.  As I said, big picture, a bit of data on a lost filesystem is 
downright trivial compared to that!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

