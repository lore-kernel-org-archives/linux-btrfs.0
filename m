Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53078 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaL0QKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 11:10:54 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Robert White <rwhite@pobox.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sat, 27 Dec 2014 17:10:52 +0100
Message-ID: <1810750.aST4eKQcpl@merkaba>
In-Reply-To: <549ECCD8.6090307@pobox.com>
References: <3738341.y7uRQFcLJH@merkaba> <34633403.WlleJmkifE@merkaba> <549ECCD8.6090307@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 27. Dezember 2014, 07:14:32 schrieb Robert White:
> On 12/27/2014 06:21 AM, Martin Steigerwald wrote:
> > Am Samstag, 27. Dezember 2014, 15:14:05 schrieb Martin Steigerwald:
> >> Am Samstag, 27. Dezember 2014, 06:00:48 schrieb Robert White:
> >>> On 12/27/2014 05:16 AM, Martin Steigerwald wrote:
> >>>> It can easily be reproduced without even using Virtualbox, just by a
> >>>> nice
> >>>> simple fio job.
> >>>
> >>> TL;DR: If you want a worst-case example of consuming a BTRFS filesystem
> >>> with one single file...
> >>>
> >>> #!/bin/bash
> >>> # not tested, so correct any syntax errors
> >>> typeset -i counter
> >>> for ((counter=250;counter>0;counter--)); do
> >>>
> >>>    dd if=/dev/urandom of=/some/file bs=4k count=$counter
> >>>
> >>> done
> >>> exit
> >>>
> >>>
> >>> Each pass over /some/file is 4k shorter than the previous one, but none
> >>> of the extents can be deallocated. File will be 1MiB in size and usage
> >>> will be something like 125.5MiB (if I've done the math correctly).
> >>> larger values of counter will result in exponentially larger amounts of
> >>> waste.
> >>
> >> Robert, I experienced this hang issues even before the defragmenting case.
> >> It happened while just installed a 400 MiB tax returns application to it
> >> (that is no joke, it is that big).
> >>
> >> It happens while just using the VM.
> >>
> >> Yes, I recommend not to use BTRFS for any VM image or any larger database on
> >> rotating storage for exactly that COW semantics.
> >>
> >> But on SSD?
> >>
> >> Its busy looping a CPU core and while the flash is basically idling.
> >>
> >> I refuse to believe that this is by design.
> >>
> >> I do think there is a *bug*.
> >>
> >> Either acknowledge it and try to fix it, or say its by design *without even
> >> looking at it closely enough to be sure that it is not a bug* and limit your
> >> own possibilities by it.
> >>
> >> I´d rather see it treated as a bug for now.
> >>
> >> Come on, 254 IOPS on a filesystem with still 17 GiB of free space while
> >> randomly writing to a 4 GiB file.
> >>
> >> People do these kind of things. Ditch that defrag Windows XP VM case, I had
> >> performance issue even before by just installing things to it. Databases,
> >> VMs, emulators. And heck even while just *creating* the file with fio as I
> >> shown.
> >
> > Add to these use cases things like this:
> >
> > martin@merkaba:~/.local/share/akonadi/db_data/akonadi> ls -lSh | head -5
> > insgesamt 2,2G
> > -rw-rw---- 1 martin martin 1,7G Dez 27 15:17 parttable.ibd
> > -rw-rw---- 1 martin martin 488M Dez 27 15:17 pimitemtable.ibd
> > -rw-rw---- 1 martin martin  23M Dez 27 15:17 pimitemflagrelation.ibd
> > -rw-rw---- 1 martin martin 240K Dez 27 15:17 collectiontable.ibd
> >
> >
> > Or this:
> >
> > martin@merkaba:~/.local/share/baloo> du -sch * | sort -rh
> > 9,2G    insgesamt
> > 8,0G    email
> > 1,2G    file
> > 51M     emailContacts
> > 408K    contacts
> > 76K     notes
> > 16K     calendars
> >
> > martin@merkaba:~/.local/share/baloo> ls -lSh email | head -5
> > insgesamt 8,0G
> > -rw-r--r-- 1 martin martin 4,0G Dez 27 15:16 postlist.DB
> > -rw-r--r-- 1 martin martin 3,9G Dez 27 15:16 termlist.DB
> > -rw-r--r-- 1 martin martin 143M Dez 27 15:16 record.DB
> > -rw-r--r-- 1 martin martin  63K Dez 27 15:16 postlist.baseA
> 
> /usr/bin/du and /usr/bin/df and /bin/ls are all _useless_ for showing 
> the amount of filespace used by a file in BTRFS.

Yes.

But they are *useful* to demonstrate that there are regular desktop
application which randomly write into huge files. And that was *exactly*
the point I was trying to make.

Yes, I didn´t prove the random aspect. But heck, one is a MySQL and
one is a Xapian. I am fairly sure that for a desktop search and for maildir
folder indexing there is some random aspect in the workload. Do you
agree to that?

So what you call as "bad" – that was my exact point I was going to make
– point is going to happen on systems. Maybe not as fierce as a fio job,
granted. And for these said /home BTRFS worked fine, but for just
installed a 400 MiB application onto the Windows XP I had the hang
already. With more than 8 GiB of free space within the chunks at that
time.

If BTRFS fails like <300 IOPS on Dual SSD on disk full conditions on
workloads like this it will fail in real world scenarios. And again my
recommendation to leave way more free space than with other filesystems
still holds.

Yes, I saw XFS developer Dave Chinner recommending about 50% of free
space of XFS for a crazy workload in case you want the filesystem in a young
state even after 10 years. So I am fully aware that filesystems will age.

But to *this* extent? After about the six months I actually run the BTRFS
RAID 1, and started with a fresh single BTRFS that I balanced as RAID 1 to
the second SSD then?

I still think it is a bug. Especially as it just does not happen with a
simple disk full condition as I spent several hours in trying to reproduce
this worst case.

If it only happens with my /home, I am willing to accept that something may
be borked with it. And I haven´t been able to produce with a clean filesystem
yet. So maybe it doesn´t happen for others. Then all fine, I recreate the FS
and forget about it.

But before I do any of this, I will wait whether a developer can make sense of
the sysrq-t triggers in syslog.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
