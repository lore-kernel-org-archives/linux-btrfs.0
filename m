Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48685 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab3IUJuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Sep 2013 05:50:10 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [REGRESSION] 3.12-rc1: Trying to create snapshot corrupted filesystem
Date: Sat, 21 Sep 2013 11:50:07 +0200
Message-ID: <4931904.tGMXJrRqTA@merkaba>
In-Reply-To: <2354718.ZY0jrbsDUo@merkaba>
References: <5021349.IU75SGaY0J@merkaba> <20130921023415.GE5672@localhost.localdomain> <2354718.ZY0jrbsDUo@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 21. September 2013, 10:54:55 schrieb Martin Steigerwald:
> Am Freitag, 20. September 2013, 22:34:15 schrieb Josef Bacik:
> > On Sat, Sep 21, 2013 at 12:25:02AM +0200, Martin Steigerwald wrote:
> > > Hi!
> > > 
> > > I tried to create a snapshot today like this:
> > > 
> > > merkaba:/mnt/debian-zeit> ls -l
> > > insgesamt 0
> > > drwxr-xr-x 1 root root 210 Sep 20 11:48 root
> > > merkaba:/mnt/debian-zeit> btrfs subvol list /
> > > ID 256 gen 21382 top level 5 path root
> > > merkaba:/mnt/debian-zeit> btrfs subvol snap -r root root-2013-09-20
> > > merkaba:/mnt/debian-zeit#1>
> > 
> > You will want the patch I just sent,
> > 
> > Btrfs: create the uuid tree on remount rw
> > 
> > and that should fix the snapshot problems.  Thanks,
> 
> Many thanks, will compile a kernel with that patch.

Patch works. I can create snapshots again.

Reported-and-tested-by: Martin Steigerwald <martin@lichtvoll.de>

> Any idea how I can fix these checksum errors without reformatting? I would
> like to avoid it if possible.
> 
> In syslog it didn´t mention which files they affected, so maybe it is "just"
> metadata. But I just have single for metadata as per suggestion for SSDs.
> 
> Would it make sense to run fsck on it?

This problem remains. Could a rebalance of just the metadata help?

I just have these two csum errors but don´t see anything misbehaving.

Oh well, I had two csum errors, now it is one:

merkaba:~> btrfs scrub status /
scrub status for 2f5c334d-249b-4c89-95cc-18572f750bd7
        scrub started at Sat Sep 21 11:39:24 2013 and finished after 56 seconds
        total bytes scrubbed: 11.94GB with 1 errors
        error details: csum=1
        corrected errors: 0, uncorrectable errors: 1, unverified errors: 0


Uhm, I have a file name this time. I didn´t see it initially:
[   46.057796] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[   46.057899] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[   46.083806] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[   46.083914] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[   46.084012] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[   46.084102] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  128.121975] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  128.122159] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  128.428071] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  128.428182] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  140.865751] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  140.865903] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  140.867493] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  140.867736] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  140.868201] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  152.628173] btrfs: checksum error at logical 347918336 on dev /dev/sdb3, sector 679528, root 256, inode 703589, offset 122880, length 3984, links 1 (path: var/log/auth.log)
[  152.643045] btrfs: checksum error at logical 347918336 on dev /dev/sdb3, sector 679528, root 279, inode 703589, offset 122880, length 3984, links 1 (path: var/log/auth.log)
[  152.643059] btrfs: bdev /dev/sdb3 errs: wr 0, rd 0, flush 0, corrupt 5, gen 0
[  152.643062] btrfs: unable to fixup (regular) error at logical 347918336 on dev /dev/sdb3


I just run

merkaba:~> truncate -s0 /var/log/auth.log


And rescrub:

That wasn´t enough. So maybe its the directory entry.


I will remove the file.

Didn´t help either.


Oh wait, I just created a snapshot. May be a good idea to delete it again.

Uhm:

[  436.342060] btrfs: checksum error at logical 347918336 on dev /dev/sdb3, sector 679528, root 279, inode 703589, offset 122880, length 3984, links 1 (path: var/log/auth.log)
[  436.342072] btrfs: bdev /dev/sdb3 errs: wr 0, rd 0, flush 0, corrupt 7, gen 0
[  436.342075] btrfs: unable to fixup (regular) error at logical 347918336 on dev /dev/sdb3
[  496.413453] btrfs: checksum error at logical 347918336 on dev /dev/sdb3, sector 679528, root 279, inode 703589, offset 122880: path resolving failed with ret=-2
[  496.413471] btrfs: bdev /dev/sdb3 errs: wr 0, rd 0, flush 0, corrupt 8, gen 0
[  496.413475] btrfs: unable to fixup (regular) error at logical 347918336 on dev /dev/sdb3


It should be gone by now. Maybe snapshot deletion didn´t yet complete.


There we go. All is happy again:

merkaba:~> btrfs scrub status /
scrub status for 2f5c334d-249b-4c89-95cc-18572f750bd7
        scrub started at Sat Sep 21 11:47:57 2013 and finished after 60 seconds
        total bytes scrubbed: 11.94GB with 0 errors

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
