Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46410 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbbLOXSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 18:18:55 -0500
Received: from merkaba.localnet (host-188-174-196-227.customer.m-online.net [188.174.196.227])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 8FA62235
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 00:18:53 +0100 (CET)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.3-rc4] scrubbing aborts before finishing (probably solved)
Date: Wed, 16 Dec 2015 00:18:53 +0100
Message-ID: <4230736.3pqTg9ZQT8@merkaba>
In-Reply-To: <2196957.diBSeBoUhe@merkaba>
References: <16063727.bYixifcRQC@merkaba> <4738187.k1WenrURk2@merkaba> <2196957.diBSeBoUhe@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 14. Dezember 2015, 08:59:59 CET schrieb Martin Steigerwald:
> Am Mittwoch, 25. November 2015, 16:35:39 CET schrieben Sie:
> > Am Samstag, 31. Oktober 2015, 12:10:37 CET schrieb Martin Steigerwald:
> > > Am Donnerstag, 22. Oktober 2015, 10:41:15 CET schrieb Martin 
Steigerwald:
> > > > I get this:
> > > > 
> > > > merkaba:~> btrfs scrub status -d /
> > > > scrub status for […]
> > > > scrub device /dev/mapper/sata-debian (id 1) history
> > > > 
> > > >         scrub started at Thu Oct 22 10:05:49 2015 and was aborted
> > > >         after
> > > >         00:00:00
> > > >         total bytes scrubbed: 0.00B with 0 errors
> > > > 
> > > > scrub device /dev/dm-2 (id 2) history
> > > > 
> > > >         scrub started at Thu Oct 22 10:05:49 2015 and was aborted
> > > >         after
> > > >         00:01:30
> > > >         total bytes scrubbed: 23.81GiB with 0 errors
> > > > 
> > > > For / scrub aborts for sata SSD immediately.
> > > > 
> > > > For /home scrub aborts for both SSDs at some time.
> > > > 
> > > > merkaba:~> btrfs scrub status -d /home
> > > > scrub status for […]
> > > > scrub device /dev/mapper/msata-home (id 1) history
> > > > 
> > > >         scrub started at Thu Oct 22 10:09:37 2015 and was aborted
> > > >         after
> > > >         00:01:31
> > > >         total bytes scrubbed: 22.03GiB with 0 errors
> > > > 
> > > > scrub device /dev/dm-3 (id 2) history
> > > > 
> > > >         scrub started at Thu Oct 22 10:09:37 2015 and was aborted
> > > >         after
> > > >         00:03:34
> > > >         total bytes scrubbed: 53.30GiB with 0 errors
> > > > 
> > > > Also single volume BTRFS is affected:
> > > > 
> > > > merkaba:~> btrfs scrub status /daten
> > > > scrub status for […]
> > > > 
> > > >         scrub started at Thu Oct 22 10:36:38 2015 and was aborted
> > > >         after
> > > >         00:00:00
> > > >         total bytes scrubbed: 0.00B with 0 errors
> > > > 
> > > > No errors in dmesg, btrfs device stat or smartctl -a.
> > > > 
> > > > Any known issue?
> > > 
> > > I am still seeing this in 4.3-rc7. It happens so that on one SSD BTRFS
> > > doesn´t even start scrubbing. But in the end it aborts it scrubbing
> > > anyway.
> > > 
> > > I do not see any other issue so far. But I would really like to be able
> > > to
> > > scrub my BTRFS filesystems completely again. Any hints? Any further
> > > information needed?
> > > 
> > > merkaba:~> btrfs scrub status -d /
> > > scrub status for […]
> > > scrub device /dev/dm-5 (id 1) history
> > > 
> > >         scrub started at Sat Oct 31 11:58:45 2015, running for 00:00:00
> > >         total bytes scrubbed: 0.00B with 0 errors
> > > 
> > > scrub device /dev/mapper/msata-debian (id 2) status
> > > 
> > >         scrub started at Sat Oct 31 11:58:45 2015, running for 00:00:20
> > >         total bytes scrubbed: 5.27GiB with 0 errors
> > > 
> > > merkaba:~> btrfs scrub status -d /
> > > scrub status for […]
> > > scrub device /dev/dm-5 (id 1) history
> > > 
> > >         scrub started at Sat Oct 31 11:58:45 2015, running for 00:00:00
> > >         total bytes scrubbed: 0.00B with 0 errors
> > > 
> > > scrub device /dev/mapper/msata-debian (id 2) status
> > > 
> > >         scrub started at Sat Oct 31 11:58:45 2015, running for 00:00:25
> > >         total bytes scrubbed: 6.59GiB with 0 errors
> > > 
> > > merkaba:~> btrfs scrub status -d /
> > > scrub status for […]
> > > scrub device /dev/dm-5 (id 1) history
> > > 
> > >         scrub started at Sat Oct 31 11:58:45 2015, running for 00:00:00
> > >         total bytes scrubbed: 0.00B with 0 errors
> > > 
> > > scrub device /dev/mapper/msata-debian (id 2) status
> > > 
> > >         scrub started at Sat Oct 31 11:58:45 2015, running for 00:01:25
> > >         total bytes scrubbed: 21.97GiB with 0 errors
> > > 
> > > merkaba:~> btrfs scrub status -d /
> > > scrub status for […]
> > > scrub device /dev/dm-5 (id 1) history
> > > 
> > >         scrub started at Sat Oct 31 11:58:45 2015 and was aborted after
> > > 
> > > 00:00:00 total bytes scrubbed: 0.00B with 0 errors
> > > scrub device /dev/mapper/msata-debian (id 2) history
> > > 
> > >         scrub started at Sat Oct 31 11:58:45 2015 and was aborted after
> > > 
> > > 00:01:32 total bytes scrubbed: 23.63GiB with 0 errors
> > > 
> > > 
> > > For the sake of it I am going to btrfs check one of the filesystem where
> > > BTRFS aborts scrubbing (which is all of the laptop filesystems, not only
> > > the RAID 1 one).
> > > 
> > > I will use the /daten filesystem as I can unmount it during laptop
> > > runtime
> > > easily. There scrubbing aborts immediately:
> > > 
> > > merkaba:~> btrfs scrub start /daten
> > > scrub started on /daten, fsid […] (pid=13861)
> > > merkaba:~> btrfs scrub status /daten
> > > scrub status for […]
> > > 
> > >         scrub started at Sat Oct 31 12:04:25 2015 and was aborted after
> > > 
> > > 00:00:00 total bytes scrubbed: 0.00B with 0 errors
> > > 
> > > It is single device:
> > > 
> > > merkaba:~> btrfs fi sh /daten
> > > Label: 'daten'  uuid: […]
> > > 
> > >         Total devices 1 FS bytes used 227.23GiB
> > >         devid    1 size 230.00GiB used 230.00GiB path
> > > 
> > > /dev/mapper/msata-daten
> > > 
> > > btrfs-progs v4.2.2
> > > merkaba:~> btrfs fi df /daten
> > > Data, single: total=228.99GiB, used=226.79GiB
> > > System, single: total=4.00MiB, used=48.00KiB
> > > Metadata, single: total=1.01GiB, used=449.50MiB
> > > GlobalReserve, single: total=160.00MiB, used=0.00B
> > > 
> > > 
> > > I do not see any output in btrfs check that points to any issue:
> > > 
> > > merkaba:~> btrfs check /dev/msata/daten
> > > Checking filesystem on /dev/msata/daten
> > > UUID: 7918274f-e2ec-4983-bbb0-aa93ef95fcf7
> > > checking extents
> > > checking free space cache
> > > checking fs roots
> > > checking csums
> > > checking root refs
> > > found 243936530607 bytes used err is 0
> > > total csum bytes: 237758932
> > > total tree bytes: 471384064
> > > total fs tree bytes: 116473856
> > > total extent tree bytes: 78544896
> > > btree space waste bytes: 57523323
> > > file data blocks allocated: 422700576768
> > > 
> > >  referenced 243803443200
> > > 
> > > btrfs-progs v4.2.2
> > 
> > Even with 4.4-rc2 this issue still happens:
> > 
> > merkaba:~> btrfs scrub status -d /
> > scrub status for […]
> > scrub device /dev/mapper/sata-debian (id 1) history
> > 
> >         scrub started at Wed Nov 25 16:28:33 2015, running for 00:00:00
> >         total bytes scrubbed: 0.00B with 0 errors
> > 
> > scrub device /dev/dm-2 (id 2) status
> > 
> >         scrub started at Wed Nov 25 16:28:33 2015, running for 00:00:55
> >         total bytes scrubbed: 14.24GiB with 0 errors
> > 
> > merkaba:~> btrfs scrub status -d /
> > scrub status for […]
> > scrub device /dev/mapper/sata-debian (id 1) history
> > 
> >         scrub started at Wed Nov 25 16:28:33 2015 and was aborted after
> > 
> > 00:00:00
> > 
> >         total bytes scrubbed: 0.00B with 0 errors
> > 
> > scrub device /dev/dm-2 (id 2) history
> > 
> >         scrub started at Wed Nov 25 16:28:33 2015 and was aborted after
> > 
> > 00:01:33
> > 
> >         total bytes scrubbed: 23.71GiB with 0 errors
> > 
> > merkaba:~> cat /proc/version
> > Linux version 4.4.0-rc2-tp520+ (martin@merkaba) (gcc version 5.2.1
> > 20151121
> > (Debian 5.2.1-24) ) #45 SMP PREEMPT Mon Nov 23 17:10:16 CET 2015
> > 
> > This time I also removed all files in /var/lib/btrfs to avoid any possible
> > issues with saved BTRFS status reports. (Yeah, I think it would have been
> > enough to just delete the one for the filesystem with that UUID.)
> > 
> > As written this bug also happens with a single device BTRFS.
> > 
> > 
> > I´d report a bug report, in case anyone would be interested. But if the
> > interest it like in this mailinglist post I can spare myself the time for
> > reporting via bugzilla.
> > 
> > So does anyone at all care about this issue?
> 
> I am replying to this a fourth time in the hope that someone can at least
> give some suggestion on how to move forward with this.

It was a third time, and well:

I now have 4.4-rc5 running, the boot crash I had appears to be fixed. Oh, and 
I see that scrubbing / at leasted worked now:

merkaba:~> btrfs scrub status -d /
scrub status for […]
scrub device /dev/dm-5 (id 1) history
        scrub started at Wed Dec 16 00:13:20 2015 and finished after 00:01:42
        total bytes scrubbed: 23.94GiB with 0 errors
scrub device /dev/mapper/msata-debian (id 2) history
        scrub started at Wed Dec 16 00:13:20 2015 and finished after 00:01:34
        total bytes scrubbed: 23.94GiB with 0 errors

I will check with other BTRFS filesystems tomorrow and report back whether 
scrubbing is stable for meagain.

Ciao,
-- 
Martin
