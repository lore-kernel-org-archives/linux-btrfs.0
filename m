Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56894 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3DTInR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 04:43:17 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Josef Bacik <jbacik@fusionio.com>
Subject: Re: btrfs scrub gives unable to find logical $hugenum len 16384
Date: Sat, 20 Apr 2013 10:43:11 +0200
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <5157386.Pre7jntDtG@merkaba> <201304191115.30452.Martin@lichtvoll.de> <20130420034938.GA2631@localhost.localdomain> (sfid-20130420_102140_219259_4FA13707)
In-Reply-To: <20130420034938.GA2631@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201304201043.11645.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 20. April 2013 schrieb Josef Bacik:
> On Fri, Apr 19, 2013 at 03:15:30AM -0600, Martin Steigerwald wrote:
> > Am Dienstag, 16. April 2013 schrieb Martin Steigerwald:
> > > On Saturday 13 April 2013 17:48:31 Martin Steigerwald wrote:
> > > > Hi!
> > > > 
> > > > Please answer soon whether it would be a good idea to replay a
> > > > backup right now as I am leaving to Berlin tomorrow for a week
> > > > without my backup drive with me. Well, I made space on an external
> > > > 2,5 inch drive, that I can take with me. I am taking that one with
> > > > me, after having made sure it has a consistent backup. :)
> > > 
> > > Ping.
> > > 
> > > Any hints on this one? I am going to recreate the filesystem next
> > > weekend at latest.
> > > 
> > > I did not see any I/O or BTRFS errors in logs so far, so filesystem
> > > appears to be good.
> > 
> > Last chance to let me dig out some more information about this.
> > 
> > Even with lack of any other oddities I am not going to tolerate a non
> > scrubbing BTRFS filesystem for longer than a week and will redo it
> > during the weekend.
> 
> Can you get a btrfs-image of the file system as it is and upload it
> somewhere for me to pull down so I can try and reproduce?  Thanks,

Hmmm, this doesn´t seem to work:

merkaba:~#134> btrfs-image -c9 -t4 /dev/merkaba/home /mnt/zeit/home.img
checksum verify failed on 65536 wanted E79F04C2 found 73
checksum verify failed on 65536 wanted E79F04C2 found 73
Csum didn't match
btrfs-image: btrfs-image.c:394: flush_pending: Assertion `!(!eb)' failed.
zsh: abort      btrfs-image -c9 -t4 /dev/merkaba/home /mnt/zeit/home.img
merkaba:~#134> btrfs-image /dev/merkaba/home /mnt/zeit/home.img
checksum verify failed on 65536 wanted E79F04C2 found 73
checksum verify failed on 65536 wanted E79F04C2 found 73
Csum didn't match
btrfs-image: btrfs-image.c:394: flush_pending: Assertion `!(!eb)' failed.
zsh: abort      btrfs-image /dev/merkaba/home /mnt/zeit/home.img
merkaba:~#134>


merkaba:~> ls -l /mnt/zeit/home.img
-rw-r--r-- 1 root root 0 Apr 20 10:32 /mnt/zeit/home.img


In order to be able to restore to a sane setup, I will do the following now:

- make another rsync backup without deleting older backup snapshots in case 
the BTRFS filesystem got corrupted and cannot retrieve some files which seems 
so from above and btrfs-debug-tree outputs.

- make a dd backup of the home partition to my backup harddisk for further 
investigation

- recreate the home filesystem as BTRFS or Ext4/XFS. But I think I will try 
BTRFS again, but I will put all the KDE Akonadi / Nepomuk related stuff onto 
another Ext4 partition as asked by a KDE developer to see whether the mail 
data loss issue is somehow related to using BTRFS, cause the developer as 
well as the main KMail developer also use KMail 2 with POP3 and they have no 
data losses.


I can try some stuff on the dd image then, maybe its still possible to get an 
btrfs-image somehow.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
