Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45498 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbbGNG05 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 02:26:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZEtg8-0004Qi-0j
	for linux-btrfs@vger.kernel.org; Tue, 14 Jul 2015 08:26:56 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2015 08:26:55 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2015 08:26:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Disk "failed" while doing scrub
Date: Tue, 14 Jul 2015 06:26:50 +0000 (UTC)
Message-ID: <pan$1df7$737a772d$db1436a8$ff6e1683@cox.net>
References: <CAOE4rSxMhwqn49fqPz2knzaRPyvkRr3roFD-JYTcm2rvB-LKkA@mail.gmail.com>
	<pan$5cbe0$8cc66c0e$aaa41b37$d4ac9035@cox.net>
	<CAOE4rSzBrvcGBuwiqPm33ZiajnKFYbZvWN-CweUnKQ_J-nFmsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dāvis Mosāns posted on Tue, 14 Jul 2015 04:54:27 +0300 as excerpted:

> 2015-07-13 11:12 GMT+03:00 Duncan <1i5t5.duncan@cox.net>:
>> You say five disk, but nowhere in your post do you mention what raid
>> mode you were using, neither do you post btrfs filesystem show and
>> btrfs filesystem df, as suggested on the wiki and which list that
>> information.
> 
> Sorry, I forgot. I'm running Arch Linux 4.0.7, with btrfs-progs v4.1
> Using RAID1 for metadata and single for data, with features
> big_metadata, extended_iref, mixed_backref, no_holes, skinny_metadata
> and mounted with noatime,compress=zlib,space_cache,autodefrag

Thanks.  FWIW, pretty similar here, but running gentoo, now with btrfs-
progs v4.1.1 and the mainline 4.2-rc1+ kernel.

BTW, note that space_cache has been the default for quite some time, 
now.  I've never actually manually mounted with space_cache on any of my 
filesystems over several years, now, yet they all report it when I check 
/proc/mounts, etc.  So if you're adding that manually, you can kill that 
option and save the commandline/fstab space. =:^)

> Label: 'Data'  uuid: 1ec5b839-acc6-4f70-be9d-6f9e6118c71c
>        Total devices 5 FS bytes used 7.16TiB
>        devid    1 size 2.73TiB used 2.35TiB path /dev/sdc
>        devid    2 size 1.82TiB used 1.44TiB path /dev/sdd
>        devid    3 size 1.82TiB used 1.44TiB path /dev/sde
>        devid    4 size 1.82TiB used 1.44TiB path /dev/sdg
>        devid    5 size 931.51GiB used 539.01GiB path /dev/sdh
> 
> Data, single: total=7.15TiB, used=7.15TiB
> System, RAID1: total=8.00MiB, used=784.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID1: total=16.00GiB, used=14.37GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=0.00B

And note that you can easily and quickly remove those empty single-mode 
system and metadata chunks, which are an artifact of the way mkfs.btrfs 
works, using balance filters.

btrfs balance start -mprofile=single

... should do it.  They're actually working on mkfs.btrfs patches to fix 
it not to do that, right now.  There's active patch and testing threads 
discussing it.  Hopefully for btrfs-progs v4.2.  (4.1.1 has the patches 
for single-device and prep work for multi-device, according to the 
changelog.)

>>> Because filesystem still mounts, I assume I should do "btrfs device
>>> delete /dev/sdd /mntpoint" and then restore damaged files from backup.
>>
>> You can try a replace, but with a failing drive still connected, people
>> report mixed results.  It's likely to fail as it can't read certain
>> blocks to transfer them to the new device.
> 
> As I understand, device delete will copy data from that disk and
> distribute across rest of disks, while btrfs replace will copy to new
> disk which must be atleast size of disk I'm replacing.

Sorry.  You wrote delete, I read replace.  How'd I do that? =:^(

You are absolutely correct.  Delete would be better here.

I guess I had just been reading a thread discussing the problems I 
mentioned with replace, and saw what I expected to see, not what you 
actually wrote.

>> There's no such partial-file with null-fill tools shipped just yet.

> From journal I have only 14 files mentioned where errors occurred. Now
> 13 files from them don't throw any errors and their SHA's match to my
> backups so they're fine.

Good.  I was going on the assumption that the questionable device was in 
much worse shape than that.

> And actually btrfs does allow to copy/read that one damaged file, only I
> get I/O error when trying to read data from those broken sectors

Good, and good to know.  Thanks. =:^)

> best and correct way to recover a file is using ddrescue

I was just going to mention ddrescue. =:^)

> $ du -m /tmp/damaged_file 6251    /tmp/damaged_file
> 
> so basically only like 8K bytes are unrecoverable from this file.
> Probably there could be created some tool which could get even more data
> knowing about btrfs.
> 
>> There /is/, however, a command that can be used to either regenerate or
>> zero-out the checksum tree.  See btrfs check --init-csum-tree.
>>
> Seems, you can't specify a path/file for it and it's quite destructive
> action if you want to get data only about some one specific file.

Yes.  It's whole-filesystem-all-or-nothing, unfortunately. =:^(

> I did scrub second time and this time there aren't that many
> uncorrectable errors and also there's no csum_errors so --init-csum-tree
> is useless here I think.

Agreed.

> Most likely previously scrub got that many errors because it still
> continued for a bit even if disk didn't respond.

Yes.

> scrub status [...]
>	 read_errors: 2
>	 csum_errors: 0
>	 verify_errors: 0
>        no_csum: 89600
>	 csum_discards: 656214
>	 super_errors: 0
>        malloc_errors: 0
>	 uncorrectable_errors: 2
>	 unverified_errors: 0
>        corrected_errors: 0
>	 last_physical: 2590041112576

OK, that matches up with 8 KiB bad, since blocks are 4 KiB and there's 
two uncorrectable errors.  With the scrub now reporting no further errors 
and the two it does report accounted for, nothing else should be 
affected. =:^)

> also now, there's i/o errors from device stats which were 0 previously

Good.  It's recording them now.

>> There's also btrfs restore, which works on the unmounted filesystem
>> without actually writing to it, copying the files it can read to a new
>> location, which of course has to be a filesystem with enough room to
>> restore the files to, altho it's possible to tell restore to do only
>> specific subdirs, for instance.
>>
>>
> I tried restore for that file, but it's not as good as ddrescue because
> it stopped on error even with --ignore-errors flag and seems there
> aren't option to continue and try more.

Yes.  It's primary use is when the filesystem can't be mounted and 
backups aren't available or at least aren't current.  The fact that it 
works without writing to the filesystem in question is also nice, as that 
lets people grab the files they can while they know they can, before 
trying potential fixes that might end up making things worse instead of 
better.

Since you could mount, and the questionable device turned out not as bad 
as it first seemed, actually mounting and working with the mounted 
filesystem is the better choice.  I was just throwing restore out as an 
available tool, because again, I thought the iffy device could fail at 
any time, leaving you grasping at straws.

>> What I'd recommend depends on how complete and how recent your backup
>> is.  If it's complete and recent enough, probably the easiest thing is
>> to simply blow away the bad filesystem and start over, recovering from
>> the backup to a new filesystem.
> 
> Actually this time I've 100% complete and up-to-date backups of all
> files so I can freely experiment and try practicing real world recovery
> which could be very useful.

=:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

