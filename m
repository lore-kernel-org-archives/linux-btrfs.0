Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60806 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbbGMIMf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jul 2015 04:12:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZEYqm-0007Po-RI
	for linux-btrfs@vger.kernel.org; Mon, 13 Jul 2015 10:12:33 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2015 10:12:32 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2015 10:12:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Disk "failed" while doing scrub
Date: Mon, 13 Jul 2015 08:12:27 +0000 (UTC)
Message-ID: <pan$5cbe0$8cc66c0e$aaa41b37$d4ac9035@cox.net>
References: <CAOE4rSxMhwqn49fqPz2knzaRPyvkRr3roFD-JYTcm2rvB-LKkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dāvis Mosāns posted on Mon, 13 Jul 2015 09:26:05 +0300 as excerpted:

> Short version: while doing scrub on 5 disk btrfs filesystem, /dev/sdd
> "failed" and also had some error on other disk (/dev/sdh)

You say five disk, but nowhere in your post do you mention what raid mode 
you were using, neither do you post btrfs filesystem show and btrfs 
filesystem df, as suggested on the wiki and which list that information.

FWIW, btrfs defaults for a multi-device filesystem are raid1 metadata, 
raid0 data.  If you didn't specify raid level at mkfs time, it's very 
likely that's what you're using.  The scrub results seem to support this 
as if the data had been raid1 or raid10, nearly all the errors should 
have been correctable by pulling from the second copy.  And raid5/6 
should have been able to recover from parity, tho this mode is new enough 
it's still not recommended as the chances of bugs and thus failure to 
work properly are much higher.

So you really should have been using raid1/10 if you wanted device 
failure tolerance, but you didn't say, and if you're using defaults as 
seems reasonably likely, your data was raid0, and thus it's likely many/
most files are either gone or damaged beyond repair.

(As it happens I have a number of btrfs raid1 data/metadata on a pair of 
partitioned ssds, with each btrfs on a corresponding partition on both of 
them, with one of the ssds developing bad sectors and basically slowly 
failing.  But the other member of the raid1 pair is solid and I have 
backups, as well as a spare I can replace the failing one with when I 
decide it's time, so I've been letting the bad one stick around due as 
much as anything to morbid curiosity, watching it slowly fail. So I know 
exactly how scrub on btrfs raid1 behaves in a bad-sector case, pulling 
the copy from the good device to overwrite the bad copy with, triggering 
the device's sector remapping in the process.  Despite all the read 
errors, they've all been correctable, because I'm using raid1 for both 
data and metadata.)

> Because filesystem still mounts, I assume I should do "btrfs device
> delete /dev/sdd /mntpoint" and then restore damaged files from backup.

You can try a replace, but with a failing drive still connected, people 
report mixed results.  It's likely to fail as it can't read certain 
blocks to transfer them to the new device.

With raid1 or better, physically disconnecting the failing device, and 
doing a device delete missing (or replace missing, but AFAIK this doesn't 
work with released versions and I'm not sure if it's even in integration 
yet, but there are patches on-list that should make it work) can work, 
but with raid0/single, you can mount with a missing device if you use 
degraded,ro, but obviously that'll only let you try to copy files off, 
and you'll likely not have a lot of luck with raid0, with files missing 
but a bit more luck with single.

In the likely raid0/single case, you're best bet is probably to try 
copying off what you can, and/or restoring from backups.  See the 
discussion below.

> Are all affected files listed in journal? there's messages about "x
> callbacks suppressed" so I'm not sure and if there aren't how to get
> full list of damaged files?

> Also I wonder if there are any tools to recover partial file fragments
> and reconstruct file? (where missing fragments filled with nulls)
> I assume that there's no point in running "btrfs check
> --check-data-csum" because scrub already does check that?

There's no such partial-file with null-fill tools shipped just yet.  
Those files normally simply trigger errors trying to read them, because 
btrfs won't let you at them if the checksum doesn't verify.

There /is/, however, a command that can be used to either regenerate or 
zero-out the checksum tree.  See btrfs check --init-csum-tree.  Current 
versions recalculate the csums, older versions (btrfsck as that was 
before btrfs check) simply zeroed it out.  Then you can read the file 
despite bad checksums, tho you'll still get errors if the block 
physically cannot be read.

There's also btrfs restore, which works on the unmounted filesystem 
without actually writing to it, copying the files it can read to a new 
location, which of course has to be a filesystem with enough room to 
restore the files to, altho it's possible to tell restore to do only 
specific subdirs, for instance.

What I'd recommend depends on how complete and how recent your backup 
is.  If it's complete and recent enough, probably the easiest thing is to 
simply blow away the bad filesystem and start over, recovering from the 
backup to a new filesystem.

If there's files you'd like to get back that weren't backed up or where 
the backup is old, since the filesystem is mountable, I'd probably copy 
everything off it I could.  Then, I'd try restore, letting it restore to 
the same location I had copied to, but NOT using the --overwrite option, 
so it only wrote any files it could restore that the copy wasn't able to 
get you, as they might be slightly older versions.

Then, if you really need more of the files, you can try using btrfs check 
--init-csum-tree as mentioned above, and then try mounting and see if you 
can access more files.  But as these are likely to be somewhat corrupt, 
I'd probably /not/ copy them to the same location as the others.  If you 
have space for two copies, you might duplicate the set of files as you 
were able to recover them with the initial copy and restore, and use the 
same don't-overwrite technique on one of the sets, marking it the 
possibly corrupted version.  Then you can do a diff or rsync dry-run to 
see the differences between the good version and the bad, and examine 
anything spitout by the diff/rsync individually.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

