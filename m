Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shout01.mail.de ([62.201.172.24]:37395 "EHLO shout01.mail.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbeHPWjE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 18:39:04 -0400
From: erenthetitan@mail.de
To: menion@gmail.com, ce3g8jdj@umail.furryterror.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: List of known BTRFS Raid 5/6 Bugs?
In-Reply-To: <CAJVZm6fchrwgpBKeidpj6kOU_zKsVFxsicM70KBFB2vZZkaJ-w@mail.gmail.com>
References: <CAJVZm6fchrwgpBKeidpj6kOU_zKsVFxsicM70KBFB2vZZkaJ-w@mail.gmail.com>
Date: Thu, 16 Aug 2018 21:38:38 +0200
Content-Type: text/plain; charset=utf-8
MIME-Version: 1.0
Message-Id: <20180816193838.E9605824E5@smtp03.mail.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Could you show scrub status -d, then start a new scrub (all drives) and show scrub status -d again? This may help us diagnose the problem.

Am 15-Aug-2018 09:27:40 +0200 schrieb menion@gmail.com: 
> I needed to resume scrub two times after an unclear shutdown (I was
> cooking and using too much electricity) and two times after a manual
> cancel, because I wanted to watch a 4k movie and the array
> performances were not enough with scrub active.
> Each time I resumed it, I checked also the status, and the total
> number of data scrubbed was keep counting (never started from zero)
> Il giorno mer 15 ago 2018 alle ore 05:33 Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> ha scritto:
> >
> > On Tue, Aug 14, 2018 at 09:32:51AM +0200, Menion wrote:
> > > Hi
> > > Well, I think it is worth to give more details on the array.
> > > the array is built with 5x8TB HDD in an esternal USB3.0 to SATAIII enclosure
> > > The enclosure is a cheap JMicron based chinese stuff (from Orico).
> > > There is one USB3.0 link for all the 5 HDD with a SATAIII 3.0Gb
> > > multiplexer behind it. So you cannot expect peak performance, which is
> > > not the goal of this array (domestic data storage).
> > > Also the USB to SATA firmware is buggy, so UAS operations are not
> > > stable, it run in BOT mode.
> > > Having said so, the scrub has been started (and resumed) on the array
> > > mount point:
> > >
> > > sudo btrfs scrub start(resume) /media/storage/das1
> >
> > So is 2.59TB the amount scrubbed _since resume_? If you run a complete
> > scrub end to end without cancelling or rebooting in between, what is
> > the size on all disks (btrfs scrub status -d)?
> >
> > > even if reading the documentation I understand that it is the same
> > > invoking it on mountpoint or one of the HDD in the array.
> > > In the end, especially for a RAID5 array, does it really make sense to
> > > scrub only one disk in the array???
> >
> > You would set up a shell for-loop and scrub each disk of the array
> > in turn. Each scrub would correct errors on a single device.
> >
> > There was a bug in btrfs scrub where scrubbing the filesystem would
> > create one thread for each disk, and the threads would issue commands
> > to all disks and compete with each other for IO, resulting in terrible
> > performance on most non-SSD hardware. By scrubbing disks one at a time,
> > there are no competing threads, so the scrub runs many times faster.
> > With this bug the total time to scrub all disks individually is usually
> > less than the time to scrub the entire filesystem at once, especially
> > on HDD (and even if it's not faster, one-at-a-time disk scrubs are
> > much kinder to any other process trying to use the filesystem at the
> > same time).
> >
> > It appears this bug is not fixed, based on some timing results I am
> > getting from a test array. iostat shows 10x more reads than writes on
> > all disks even when all blocks on one disk are corrupted and the scrub
> > is given only a single disk to process (that should result in roughly
> > equal reads on all disks slightly above the number of writes on the
> > corrupted disk).
> >
> > This is where my earlier caveat about performance comes from. Many parts
> > of btrfs raid5 are somewhere between slower and *much* slower than
> > comparable software raid5 implementations. Some of that is by design:
> > btrfs must be at least 1% slower than mdadm because btrfs needs to read
> > metadata to verify data block csums in scrub, and the difference would
> > be much larger in practice due to HDD seek times, but 500%-900% overhead
> > still seems high especially when compared to btrfs raid1 that has the
> > same metadata csum reading issue without the huge performance gap.
> >
> > It seems like btrfs raid5 could still use a thorough profiling to figure
> > out where it's spending all its IO.
> >
> > > Regarding the data usage, here you have the current figures:
> > >
> > > menion@Menionubuntu:~$ sudo btrfs fi show
> > > [sudo] password for menion:
> > > Label: none uuid: 6db4baf7-fda8-41ac-a6ad-1ca7b083430f
> > > Total devices 1 FS bytes used 11.44GiB
> > > devid 1 size 27.07GiB used 18.07GiB path /dev/mmcblk0p3
> > >
> > > Label: none uuid: 931d40c6-7cd7-46f3-a4bf-61f3a53844bc
> > > Total devices 5 FS bytes used 6.57TiB
> > > devid 1 size 7.28TiB used 1.64TiB path /dev/sda
> > > devid 2 size 7.28TiB used 1.64TiB path /dev/sdb
> > > devid 3 size 7.28TiB used 1.64TiB path /dev/sdc
> > > devid 4 size 7.28TiB used 1.64TiB path /dev/sdd
> > > devid 5 size 7.28TiB used 1.64TiB path /dev/sde
> > >
> > > menion@Menionubuntu:~$ sudo btrfs fi df /media/storage/das1
> > > Data, RAID5: total=6.57TiB, used=6.56TiB
> > > System, RAID5: total=12.75MiB, used=416.00KiB
> > > Metadata, RAID5: total=9.00GiB, used=8.16GiB
> > > GlobalReserve, single: total=512.00MiB, used=0.00B
> > > menion@Menionubuntu:~$ sudo btrfs fi usage /media/storage/das1
> > > WARNING: RAID56 detected, not implemented
> > > WARNING: RAID56 detected, not implemented
> > > WARNING: RAID56 detected, not implemented
> > > Overall:
> > > Device size: 36.39TiB
> > > Device allocated: 0.00B
> > > Device unallocated: 36.39TiB
> > > Device missing: 0.00B
> > > Used: 0.00B
> > > Free (estimated): 0.00B (min: 8.00EiB)
> > > Data ratio: 0.00
> > > Metadata ratio: 0.00
> > > Global reserve: 512.00MiB (used: 32.00KiB)
> > >
> > > Data,RAID5: Size:6.57TiB, Used:6.56TiB
> > > /dev/sda 1.64TiB
> > > /dev/sdb 1.64TiB
> > > /dev/sdc 1.64TiB
> > > /dev/sdd 1.64TiB
> > > /dev/sde 1.64TiB
> > >
> > > Metadata,RAID5: Size:9.00GiB, Used:8.16GiB
> > > /dev/sda 2.25GiB
> > > /dev/sdb 2.25GiB
> > > /dev/sdc 2.25GiB
> > > /dev/sdd 2.25GiB
> > > /dev/sde 2.25GiB
> > >
> > > System,RAID5: Size:12.75MiB, Used:416.00KiB
> > > /dev/sda 3.19MiB
> > > /dev/sdb 3.19MiB
> > > /dev/sdc 3.19MiB
> > > /dev/sdd 3.19MiB
> > > /dev/sde 3.19MiB
> > >
> > > Unallocated:
> > > /dev/sda 5.63TiB
> > > /dev/sdb 5.63TiB
> > > /dev/sdc 5.63TiB
> > > /dev/sdd 5.63TiB
> > > /dev/sde 5.63TiB
> > > menion@Menionubuntu:~$
> > > menion@Menionubuntu:~$ sf -h
> > > The program 'sf' is currently not installed. You can install it by typing:
> > > sudo apt install ruby-sprite-factory
> > > menion@Menionubuntu:~$ df -h
> > > Filesystem Size Used Avail Use% Mounted on
> > > udev 934M 0 934M 0% /dev
> > > tmpfs 193M 22M 171M 12% /run
> > > /dev/mmcblk0p3 28G 12G 15G 44% /
> > > tmpfs 962M 0 962M 0% /dev/shm
> > > tmpfs 5,0M 0 5,0M 0% /run/lock
> > > tmpfs 962M 0 962M 0% /sys/fs/cgroup
> > > /dev/mmcblk0p1 188M 3,4M 184M 2% /boot/efi
> > > /dev/mmcblk0p3 28G 12G 15G 44% /home
> > > /dev/sda 37T 6,6T 29T 19% /media/storage/das1
> > > tmpfs 193M 0 193M 0% /run/user/1000
> > > menion@Menionubuntu:~$ btrfs --version
> > > btrfs-progs v4.17
> > >
> > > So I don't fully understand where the scrub data size comes from
> > > Il giorno lun 13 ago 2018 alle ore 23:56 <erenthetitan@mail.de> ha scritto:
> > > >
> > > > Running time of 55:06:35 indicates that the counter is right, it is not enough time to scrub the entire array using hdd.
> > > >
> > > > 2TiB might be right if you only scrubbed one disc, "sudo btrfs scrub start /dev/sdx1" only scrubs the selected partition,
> > > > whereas "sudo btrfs scrub start /media/storage/das1" scrubs the actual array.
> > > >
> > > > Use "sudo btrfs scrub status -d " to view per disc scrubbing statistics and post the output.
> > > > For live statistics, use "sudo watch -n 1".
> > > >
> > > > By the way:
> > > > 0 errors despite multiple unclean shutdowns? I assumed that the write hole would corrupt parity the first time around, was i wrong?
> > > >
> > > > Am 13-Aug-2018 09:20:36 +0200 schrieb menion@gmail.com:
> > > > > Hi
> > > > > I have a BTRFS RAID5 array built on 5x8TB HDD filled with, well :),
> > > > > there are contradicting opinions by the, well, "several" ways to check
> > > > > the used space on a BTRFS RAID5 array, but I should be aroud 8TB of
> > > > > data.
> > > > > This array is running on kernel 4.17.3 and it definitely experienced
> > > > > power loss while data was being written.
> > > > > I can say that it wen through at least a dozen of unclear shutdown
> > > > > So following this thread I started my first scrub on the array. and
> > > > > this is the outcome (after having resumed it 4 times, two after a
> > > > > power loss...):
> > > > >
> > > > > menion@Menionubuntu:~$ sudo btrfs scrub status /media/storage/das1/
> > > > > scrub status for 931d40c6-7cd7-46f3-a4bf-61f3a53844bc
> > > > > scrub resumed at Sun Aug 12 18:43:31 2018 and finished after 55:06:35
> > > > > total bytes scrubbed: 2.59TiB with 0 errors
> > > > >
> > > > > So, there are 0 errors, but I don't understand why it says 2.59TiB of
> > > > > scrubbed data. Is it possible that also this values is crap, as the
> > > > > non zero counters for RAID5 array?
> > > > > Il giorno sab 11 ago 2018 alle ore 17:29 Zygo Blaxell
> > > > > <ce3g8jdj@umail.furryterror.org> ha scritto:
> > > > > >
> > > > > > On Sat, Aug 11, 2018 at 08:27:04AM +0200, erenthetitan@mail.de wrote:
> > > > > > > I guess that covers most topics, two last questions:
> > > > > > >
> > > > > > > Will the write hole behave differently on Raid 6 compared to Raid 5 ?
> > > > > >
> > > > > > Not really. It changes the probability distribution (you get an extra
> > > > > > chance to recover using a parity block in some cases), but there are
> > > > > > still cases where data gets lost that didn't need to be.
> > > > > >
> > > > > > > Is there any benefit of running Raid 5 Metadata compared to Raid 1 ?
> > > > > >
> > > > > > There may be benefits of raid5 metadata, but they are small compared to
> > > > > > the risks.
> > > > > >
> > > > > > In some configurations it may not be possible to allocate the last
> > > > > > gigabyte of space. raid1 will allocate 1GB chunks from 2 disks at a
> > > > > > time while raid5 will allocate 1GB chunks from N disks at a time, and if
> > > > > > N is an odd number there could be one chunk left over in the array that
> > > > > > is unusable. Most users will find this irrelevant because a large disk
> > > > > > array that is filled to the last GB will become quite slow due to long
> > > > > > free space search and seek times--you really want to keep usage below 95%,
> > > > > > maybe 98% at most, and that means the last GB will never be needed.
> > > > > >
> > > > > > Reading raid5 metadata could theoretically be faster than raid1, but that
> > > > > > depends on a lot of variables, so you can't assume it as a rule of thumb.
> > > > > >
> > > > > > Raid6 metadata is more interesting because it's the only currently
> > > > > > supported way to get 2-disk failure tolerance in btrfs. Unfortunately
> > > > > > that benefit is rather limited due to the write hole bug.
> > > > > >
> > > > > > There are patches floating around that implement multi-disk raid1 (i.e. 3
> > > > > > or 4 mirror copies instead of just 2). This would be much better for
> > > > > > metadata than raid6--more flexible, more robust, and my guess is that
> > > > > > it will be faster as well (no need for RMW updates or journal seeks).
> > > > > >
> > > > > > > -------------------------------------------------------------------------------------------------
> > > > > > > FreeMail powered by mail.de - MEHR SICHERHEIT, SERIOSITÄT UND KOMFORT
> > > > > > >
> > > >
> > > >
> > > > -------------------------------------------------------------------------------------------------
> > > > FreeMail powered by mail.de - MEHR SICHERHEIT, SERIOSITÄT UND KOMFORT

-------------------------------------------------------------------------------------------------
FreeMail powered by mail.de - MEHR SICHERHEIT, SERIOSITÄT UND KOMFORT
