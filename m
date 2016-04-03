Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42470 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbcDCWUL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Apr 2016 18:20:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1amqNJ-00020d-16
	for linux-btrfs@vger.kernel.org; Mon, 04 Apr 2016 00:20:05 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 00:20:05 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 00:20:05 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
Date: Mon, 4 Apr 2016 00:19:25 +0200
Message-ID: <20160404001925.2abc2649@jupiter.sol.kaishome.de>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<20160402110001.0ec354b5@jupiter.sol.kaishome.de>
	<CAPmG0jaJdS26ABbC3Rz_D_FDfCKq8mYMHhmFwqhWYpDRdyFQhw@mail.gmail.com>
	<20160402221634.2e3dc71c@jupiter.sol.kaishome.de>
	<CAJCQCtQ+RnQqghDs060hrLJ850e0n=FiKNn9W8UuUP3DQV9u5g@mail.gmail.com>
	<20160403060202.03e67651@jupiter.sol.kaishome.de>
	<pan$2593b$f74bb320$4b6df891$663eb0b@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 3 Apr 2016 05:06:19 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Kai Krakow posted on Sun, 03 Apr 2016 06:02:02 +0200 as excerpted:
> 
> > No, other files are affected, too. And it looks like those files are
> > easily affected even when removed and recreated from whatever backup
> > source.  
> 
> I've seen you say that several times now, I think.  But none of those 
> times has it apparently occurred to you to double-check whether it's
> the /same/ corruptions every time, or at least, if you checked it,
> I've not seen it actually /reported/.  (Note that I didn't say you
> didn't report it, only that I've not seen it.  A difference there is!
> =:^)

Believe me, I would double check... But this FS is (and the affected
files are) just too big to create test cases, and backups, and copies,
and you know what...

So only chance I see is to offer help improving "btrfsck --repair"
before I wipe and restore from backup. Except the unlikely case
"--repair" will improve to a point it gets my FS back in order. ;-)

I'll have to wait for my new bcache SSD to arrive. I it's current state
(lifetime at 97%) I don't want to push my whole file data through it.

Then I'll backup the current state (the damaged files are skipped
anyways because they haven't been "modified" according to mtime), so
I'll get a clean backup except for the VDI file and some big Steam
files (which actually can easily be downloaded again through the
client).

And yes, you are true in that I didn't check if it is the same
corruption every time. But that's also a bit difficult to do because
I'd need either enough spare disk space to keep copies of the files to
compare against, or need to setup some block-identifying checksumming
like a hash tree.

> If I'm getting repeated corruptions of something, that's the first
> thing I'd check, is there some repeating pattern to those
> corruptions, same place in the file, same "wanted" value (expected),
> same "got" value, (not expected if it's reporting corruption), etc.

Way to go, usually...

> Then I'd try different variations like renaming the file, putting it
> in a different directory with all of the same other files, putting it
> in a different directory with all different files, putting it in a
> different directory by itself, putting it in the same directory but
> in a different subvolume... you get the point.

Here's the point: Shuffling files around should be done to different
filesystems. I neither have any spare files to do that, nor I currently
can afford time to shuffle around such big files - it takes multiple
hours to copy these. Already looking forward to restoring the backup...
*sigh*

BTW: Is it possible to use my backup drive (it's btrfs single-data
dup-metadata, single device) as a seed device for my newly created
btrfs pool (raid0-data, raid1-metadata, three devices)? I guess the
seed source cannot be mounted or modified...

> Then I'd try different mount options, with and without compression,
> with different kinds of compression, with compress-force and with
> simple compress, with and without autodefrag...

As a first step I've switched bcache to write-around mode. It should
prevent (or at least reduce) more corruption if bcache is at fault. And
it's the safer choice anyway for a soon-to-die SSD.

> I could try it with nocow enabled for the file (note that the file
> has to be created with nocow before it gets content, for nocow to
> take effect), tho of course that'll turn off btrfs checksumming, but
> I could still for instance md5sum the original source and the nocowed
> test version and see if it tests clean that way.

I already thought about putting the VDI back to nocow... I had this
before. But in this sense, csum errors would go unnoticed. So I don't
think that is adequate.

But in consequence I could actually md5sum the files as you wrote
because there won't be read errors due to csum mismatch. And I could
detect corruption that way.

> I could try it with nocow on the file but with a bunch of snapshots 
> interwoven with writing changes to the file (obviously this will kill 
> comparison against the original, but I could arrange to write the
> same changes to the test file on btrfs, and to a control copy of the
> file on non-btrfs, and then md5sum or whatever compare them).

That would probably work but I do not quite trust it due to the
corruptions already on disk which seemingly damage specific files or
areas on the disk.

> Then, if I had the devices available to do so, I'd try it in a
> different btrfs of the same layout (same redundancy mode and number
> of devices), both single and dup mode on a single device, etc.

In that sense: If I had the disks available I already would've taken a
block-by-block copy and then restored from backup.

> And again if available, I'd try swapping the filesystem to different 
> machines...

Maybe another time... ;-)

Actually, I only have that one system here. I could do that with the
other system I have problems with - but that's another story and
currently low priority.

> OK, so trying /all/ the above might be a bit overboard but I think
> you get the point.  Try to find some pattern or common element in the
> whole thing, and report back the results at least for the "simple"
> experiments like whether the corruption appears to be the same (same
> got at the same spot) or different, and whether putting the file in a
> different subdir or using a different name for it matters at all.
> =:^)

Your ideas are always welcome.

The corruptions seem to be different by the following observation:

While the VDI file was corrupted over and over again with a csum error,
I could simply remove it and restore from backup. The last thing I did
was ddescue it from the damaged version to my backup device, than rsync
the file back to the originating device (which created a new file
side-by-side, so in a new area of disk space, then replace-by-renamed
the old one). I didn't run VirtualBox since back then but the file
didn't become corrupted either since then.

But now, according to btrfsck, a csum error instead came up in another
big file from Steam. This time, when I rm the file, the kernel
backtraces and sends btrfs to RO mode. The file cannot be removed. I'm
going to leave it that way currently, the file won't be used currently.
And I can simply ignore it for backup and restore, it's not an
important one. Better have an "incorrectable" csum error there than
having one jumping unpredictably across my files.

Before you ask: Yes, I'm still working productively with this broken
file system. I'm not sure if this is a point for or against btrfs,
tho. ;-) It works perfectly stable as long as I do not touch any of the
damaged files (which was and currently continues to be easy). Ah, well,
"perfectly" except that commands "df" and "du" tend to freeze and be
unkillable. I'm going to ignore that and take the opportunity to test
how far I can stress btrfs before it finally breaks down.

Thus, I'll leave it that way until it breaks down or I decide to effort
the time to restore from backup. Until then, I keep my last known-good
snapshot and a known-incomplete backup scratch storage where I at least
know which files are broken. My daily-business files are stored twice
anyways (offsite and local backup).

I hope I can add some value to improving btrfsck until I have to
restore from backup. I know that with my current setup I cannot give
any help in finding a possible btrfs kernel flaw - which I actually
think maybe was in a previous kernel version and has been fixed by now.

-- 
Regards,
Kai

Replies to list-only preferred.

