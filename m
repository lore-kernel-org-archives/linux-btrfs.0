Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:41759 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaL2Jip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 04:38:45 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Ankur Tank <Ankur.Tank@lnttechservices.com>
Cc: Anand Jain <Anand.Jain@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs doesn't format eMMC if previous filesystem is ext4
Date: Mon, 29 Dec 2014 10:38:42 +0100
Message-ID: <1749413.JF4i0WjTJs@merkaba>
In-Reply-To: <CFB3B8F56DDE9F45B45EBDEBED372A664423AB@POCITMSEXMB05.LntUniverse.com>
References: <CFB3B8F56DDE9F45B45EBDEBED372A6644232D@POCITMSEXMB05.LntUniverse.com> <54A0C17C.7010009@oracle.com> <CFB3B8F56DDE9F45B45EBDEBED372A664423AB@POCITMSEXMB05.LntUniverse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 29. Dezember 2014, 07:15:11 schrieb Ankur Tank:

> > -----Original Message-----
> > From: Anand Jain [mailto:Anand.Jain@oracle.com]
> > Sent: Monday, December 29, 2014 8:21 AM
> > To: Ankur Tank; linux-btrfs@vger.kernel.org
> > Subject: Re: btrfs doesn't format eMMC if previous filesystem is ext4
> > 
> > On 12/26/2014 11:24 PM, Ankur Tank wrote:
> > > Hi,
> > > 
> > > I wanted to test btrfs on the eMMC of beaglebone black based custom
> > > board.
> > > 
> > > Precondition: eMMC is formatted with ext4 filesystem Use case:
> > >          Format eMMC with mkfs.btrfs  -L  <label>  <dev>
> > > 
> > > Result:
> > >          Mkfs.btrfs denies formatting eMMC because its existing
> > > 
> > > filesystem
> > > 
> > > # mkfs.btrfs -L "1storage" /dev/mmcblk0p2
> > > /dev/mmcblk0p2 appears to contain an existing filesystem (ext4).
> > > Error: Use the -f option to force overwrite.
> > > 
> > > If I add "-f" its possible to format the eMMC.
> > > 
> > > # mkfs.btrfs -f -L "1storage" /dev/mmcblk0p2 Detected a SSD, turning
> > > off metadata duplication.  Mkfs with -m dup if you want to force
> > > metadata duplication. Btrfs v3.17
> > > See http://btrfs.wiki.kernel.org for more information.
> > > 
> > > Performing full device TRIM (1.72GiB) ...
> > > Turning ON incompat feature 'extref': increased hardlink limit per
> > > file to 65536 [273917.692896] btrfs: device label 1storage devid 1
> > > transid 3 /dev/mmcblk0p2 fs created label 1storage on /dev/mmcblk0p2
> > > 
> > >          nodesize 16384 leafsize 16384 sectorsize 4096 size 1.72GiB
> > > 
> > > I had downloaded debian package from following link
> > > https://packages.debian.org/sid/armhf/btrfs-tools/download
> > > 
> > > Is it a bug ? or I am missing something ?
> > > 
> >   I don't see any bug. Can you be more specific ? Thanks.

> Hi Anand,
> 
> Precondition : Previous filesystem on eMMC  was --- ext4----
> Use case : Now format eMMC to btrfs format, using ---mkfs.btrfs---
> mkfs.btrfs denies formatting eMMC telling that eMMC contain an existing filesystem(ext4).
> 
> In my opinion mkfs.btrfs must allow to format eMMC with btrfs even if there is other filesystem on it.
> 
> mkfs.ext4 and mkfs.f2fs does allow formatting even if eMMC contains some other file system on it.
> 
> Note: If I add "-f" option mkfs.btrf does allow formatting eMMC to btrfs filesytem.

Thats intended.

It is like mkfs.xfs does it as well.

And I really like this.

Don´t just format an existing filesystem without an explicit request to do
so. I always disliked that on Linux / UNIX tools don´t ask at least once for
dangerous operations. Well some do very toroughly:

merkaba:~> LANG=C apt-get purge bash
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following packages will be REMOVED:
  bash* foomatic-db-engine*
WARNING: The following essential packages will be removed.
This should NOT be done unless you know exactly what you are doing!
  bash
0 upgraded, 0 newly installed, 2 to remove and 2 not upgraded.
After this operation, 5887 kB disk space will be freed.
You are about to do something potentially harmful.
To continue type in the phrase 'Yes, do as I say!'
 ?]


Yeah, I know the saying that "root" should know about own actions, yeah I
think alias rm="rm -i" is too much and doesn´t do much good cause people
are motivated to do "rm -f" then to override it after having been asked a
hundred times for each to delete file and if you want, and yeah I think
alias rm="rm -I" or how Z-Shell does it, is much better, but heck we are all
human beings, so I like being warned on actions that may make a ton of data
inaccessible real fast.

So if you want to script it, use "-f". :)

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
