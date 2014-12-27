Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:40948 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaL0OVq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 09:21:46 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Robert White <rwhite@pobox.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sat, 27 Dec 2014 15:21:43 +0100
Message-ID: <34633403.WlleJmkifE@merkaba>
In-Reply-To: <1779212.Cg9zjTft4U@merkaba>
References: <3738341.y7uRQFcLJH@merkaba> <549EBB90.5070406@pobox.com> <1779212.Cg9zjTft4U@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 27. Dezember 2014, 15:14:05 schrieb Martin Steigerwald:
> Am Samstag, 27. Dezember 2014, 06:00:48 schrieb Robert White:
> > On 12/27/2014 05:16 AM, Martin Steigerwald wrote:
> > > It can easily be reproduced without even using Virtualbox, just by a
> > > nice
> > > simple fio job.
> > 
> > TL;DR: If you want a worst-case example of consuming a BTRFS filesystem
> > with one single file...
> > 
> > #!/bin/bash
> > # not tested, so correct any syntax errors
> > typeset -i counter
> > for ((counter=250;counter>0;counter--)); do
> > 
> >   dd if=/dev/urandom of=/some/file bs=4k count=$counter
> > 
> > done
> > exit
> > 
> > 
> > Each pass over /some/file is 4k shorter than the previous one, but none
> > of the extents can be deallocated. File will be 1MiB in size and usage
> > will be something like 125.5MiB (if I've done the math correctly).
> > larger values of counter will result in exponentially larger amounts of
> > waste.
> 
> Robert, I experienced this hang issues even before the defragmenting case.
> It happened while just installed a 400 MiB tax returns application to it
> (that is no joke, it is that big).
> 
> It happens while just using the VM.
> 
> Yes, I recommend not to use BTRFS for any VM image or any larger database on
> rotating storage for exactly that COW semantics.
> 
> But on SSD?
> 
> Its busy looping a CPU core and while the flash is basically idling.
> 
> I refuse to believe that this is by design.
> 
> I do think there is a *bug*.
> 
> Either acknowledge it and try to fix it, or say its by design *without even
> looking at it closely enough to be sure that it is not a bug* and limit your
> own possibilities by it.
> 
> I´d rather see it treated as a bug for now.
> 
> Come on, 254 IOPS on a filesystem with still 17 GiB of free space while
> randomly writing to a 4 GiB file.
> 
> People do these kind of things. Ditch that defrag Windows XP VM case, I had
> performance issue even before by just installing things to it. Databases,
> VMs, emulators. And heck even while just *creating* the file with fio as I
> shown.

Add to these use cases things like this:

martin@merkaba:~/.local/share/akonadi/db_data/akonadi> ls -lSh | head -5
insgesamt 2,2G
-rw-rw---- 1 martin martin 1,7G Dez 27 15:17 parttable.ibd
-rw-rw---- 1 martin martin 488M Dez 27 15:17 pimitemtable.ibd
-rw-rw---- 1 martin martin  23M Dez 27 15:17 pimitemflagrelation.ibd
-rw-rw---- 1 martin martin 240K Dez 27 15:17 collectiontable.ibd


Or this:

martin@merkaba:~/.local/share/baloo> du -sch * | sort -rh
9,2G    insgesamt
8,0G    email
1,2G    file
51M     emailContacts
408K    contacts
76K     notes
16K     calendars

martin@merkaba:~/.local/share/baloo> ls -lSh email | head -5
insgesamt 8,0G
-rw-r--r-- 1 martin martin 4,0G Dez 27 15:16 postlist.DB
-rw-r--r-- 1 martin martin 3,9G Dez 27 15:16 termlist.DB
-rw-r--r-- 1 martin martin 143M Dez 27 15:16 record.DB
-rw-r--r-- 1 martin martin  63K Dez 27 15:16 postlist.baseA



These will not be as bad as the fio test case, but still these files are
written into. They are updated in place.

And thats running on every Plasma desktop by default. And on GNOME desktops
there is similar stuff.

I haven´t seen this spike out a kworker yet tough, so maybe the workload is 
light enough not to trigger it that easily.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
