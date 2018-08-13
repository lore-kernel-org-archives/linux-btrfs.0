Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shout02.mail.de ([62.201.172.25]:44249 "EHLO shout02.mail.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729102AbeHNAkN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Aug 2018 20:40:13 -0400
From: erenthetitan@mail.de
To: menion@gmail.com, ce3g8jdj@umail.furryterror.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: List of known BTRFS Raid 5/6 Bugs?
Date: Mon, 13 Aug 2018 23:56:05 +0200
Content-Type: text/plain; charset=utf-8
MIME-Version: 1.0
Message-Id: <20180813215605.705238033D@smtp03.mail.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Running time of 55:06:35 indicates that the counter is right, it is not enough time to scrub the entire array using hdd.

2TiB might be right if you only scrubbed one disc, "sudo btrfs scrub start /dev/sdx1" only scrubs the selected partition, 
whereas "sudo btrfs scrub start /media/storage/das1" scrubs the actual array.

Use "sudo btrfs scrub status -d " to view per disc scrubbing statistics and post the output.
For live statistics, use "sudo watch -n 1".

By the way:
0 errors despite multiple unclean shutdowns? I assumed that the write hole would corrupt parity the first time around, was i wrong?

Am 13-Aug-2018 09:20:36 +0200 schrieb menion@gmail.com: 
> Hi
> I have a BTRFS RAID5 array built on 5x8TB HDD filled with, well :),
> there are contradicting opinions by the, well, "several" ways to check
> the used space on a BTRFS RAID5 array, but I should be aroud 8TB of
> data.
> This array is running on kernel 4.17.3 and it definitely experienced
> power loss while data was being written.
> I can say that it wen through at least a dozen of unclear shutdown
> So following this thread I started my first scrub on the array. and
> this is the outcome (after having resumed it 4 times, two after a
> power loss...):
> 
> menion@Menionubuntu:~$ sudo btrfs scrub status /media/storage/das1/
> scrub status for 931d40c6-7cd7-46f3-a4bf-61f3a53844bc
> scrub resumed at Sun Aug 12 18:43:31 2018 and finished after 55:06:35
> total bytes scrubbed: 2.59TiB with 0 errors
> 
> So, there are 0 errors, but I don't understand why it says 2.59TiB of
> scrubbed data. Is it possible that also this values is crap, as the
> non zero counters for RAID5 array?
> Il giorno sab 11 ago 2018 alle ore 17:29 Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> ha scritto:
> >
> > On Sat, Aug 11, 2018 at 08:27:04AM +0200, erenthetitan@mail.de wrote:
> > > I guess that covers most topics, two last questions:
> > >
> > > Will the write hole behave differently on Raid 6 compared to Raid 5 ?
> >
> > Not really. It changes the probability distribution (you get an extra
> > chance to recover using a parity block in some cases), but there are
> > still cases where data gets lost that didn't need to be.
> >
> > > Is there any benefit of running Raid 5 Metadata compared to Raid 1 ?
> >
> > There may be benefits of raid5 metadata, but they are small compared to
> > the risks.
> >
> > In some configurations it may not be possible to allocate the last
> > gigabyte of space. raid1 will allocate 1GB chunks from 2 disks at a
> > time while raid5 will allocate 1GB chunks from N disks at a time, and if
> > N is an odd number there could be one chunk left over in the array that
> > is unusable. Most users will find this irrelevant because a large disk
> > array that is filled to the last GB will become quite slow due to long
> > free space search and seek times--you really want to keep usage below 95%,
> > maybe 98% at most, and that means the last GB will never be needed.
> >
> > Reading raid5 metadata could theoretically be faster than raid1, but that
> > depends on a lot of variables, so you can't assume it as a rule of thumb.
> >
> > Raid6 metadata is more interesting because it's the only currently
> > supported way to get 2-disk failure tolerance in btrfs. Unfortunately
> > that benefit is rather limited due to the write hole bug.
> >
> > There are patches floating around that implement multi-disk raid1 (i.e. 3
> > or 4 mirror copies instead of just 2). This would be much better for
> > metadata than raid6--more flexible, more robust, and my guess is that
> > it will be faster as well (no need for RMW updates or journal seeks).
> >
> > > -------------------------------------------------------------------------------------------------
> > > FreeMail powered by mail.de - MEHR SICHERHEIT, SERIOSITÄT UND KOMFORT
> > >


-------------------------------------------------------------------------------------------------
FreeMail powered by mail.de - MEHR SICHERHEIT, SERIOSITÄT UND KOMFORT
