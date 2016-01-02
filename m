Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38686 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbcABQKY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jan 2016 11:10:24 -0500
Received: by mail-wm0-f50.google.com with SMTP id b14so132389141wmb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jan 2016 08:10:23 -0800 (PST)
Received: from orione.localnet (16.Red-83-50-201.dynamicIP.rima-tde.net. [83.50.201.16])
        by smtp.gmail.com with ESMTPSA id u126sm69440571wme.3.2016.01.02.08.10.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 02 Jan 2016 08:10:22 -0800 (PST)
From: =?ISO-8859-1?Q?fugazzi=AE?= <fugazzi99@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs send / receive freeze system?
Date: Sat, 02 Jan 2016 16:10:20 +0000
Message-ID: <3883736.oK4BscmJWO@orione>
In-Reply-To: <CAPmG0jYHf90fuw1kds1aMhUbopmZX-wOLqDkR36mfb_hSm6szw@mail.gmail.com>
References: <2876879.yKrnxB0p8M@orione> <CAPmG0jYHf90fuw1kds1aMhUbopmZX-wOLqDkR36mfb_hSm6szw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you Henk.

Yes I already tried that but it seems the keyboard is also offline so sys 
commands had no effect. In fact ping was not working also, it seem interrupt 
got disconnected somehow.

I tried your suggestion but it freeze on different files on different run. 
I got a freeze every 3-4 pass on average.

I also formatted again and tried to copy something from an external e-sata 
drive (mounted read only) to the same internal sata drive, it freeze also from 
there every time on a different file.

If I use rsync to copy or cp the freeze does not happen.

Reformatting the internal drive to XFS solve the freeze, I mean sending the 
gzipped send to the XFS formatted drive do not freeze the pc. Sending the same 
gzipped send on the same drive formatted in btrfs freeze the system.

Since no one had/have this problem I'm beginning to guess btrfs might be 
exposing some hardware failure I was not aware of. It might be possible that 
having the two drive formatted as btrfs is more hard to the system due to 
double checksumming, etc.

It is one month now that this system was converted to btrfs, I never had any 
problems only this send problem and only after I converted also the second 
internal drive to btrfs. Scrubs are OK, btrfs check are OK.

I would wait and see if someone else will have similar problems.

For now I mitigated adding a third internal drive formatted in XFS and sending 
the backup there, then from there copying the backup back to the btrfs drive. 
Now I have two copy of the same backup on different drive :-)

Regards.  

On Saturday, January 2, 2016 12:23:12 AM WET you wrote:
> On Fri, Jan 1, 2016 at 4:51 PM, fugazzi® <fugazzi99@gmail.com> wrote:
> > Hi everyone.
> > It's a few weeks that I converted my root partition into btrfs with three
> > sub- volumes named boot,root,home. I'm booting with /boot on subvol.
> > 
> > I'm using btrfs send and receive to make backup of the three snapshotted
> > subvolumes on a second btrfs formatted drive with three commands like
> > this:
> > 
> > btrfs send /btrfs-root/snap-root/ | gzip > $BKFOLDER/root.dump.gz
> > 
> > Sometimes, let say once a week, the system completely freeze (mouse
> > keyboard) during the send, only solution was the reset button. The freeze
> > happened on different place every time. Last time happened at 80% of the
> > home send for example.
> > 
> > The freeze also happened during a send/receive from an external e-sata
> > drive (to copy some mp3 using send instead of rsync) to the same internal
> > drive where the backup are also made.
> > 
> > The system always run and was stable with XFS/xfsdump.
> > 
> > Kernel is 4.3.3, btrfs progs are 4.3.1, system is Arch Linux 64 bit, Ram
> > 8Gb Mainboard Asus striker extreme Nvidia 680i, 8 years old.
> > 
> > After the crash nothing is shown in the systemd log, it simply freeze.
> 
> You could try this (maybe you have already) and see if and where the
> problem is in btrfs:
> https://en.m.wikipedia.org/wiki/Magic_SysRq_key
> 
> Instead of pipe to gzip you could do:
> | btrfs receive -vv <some btrfs mount>
> 
> and trace back at which file the freeze happens. Maybe that tells something
> about the source filesystem.

