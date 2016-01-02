Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:33340 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbcABVVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jan 2016 16:21:37 -0500
Received: by mail-wm0-f49.google.com with SMTP id f206so136290285wmf.0
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jan 2016 13:21:36 -0800 (PST)
Received: from orione.localnet (16.Red-83-50-201.dynamicIP.rima-tde.net. [83.50.201.16])
        by smtp.gmail.com with ESMTPSA id 143sm70563191wmv.18.2016.01.02.13.21.35
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 02 Jan 2016 13:21:35 -0800 (PST)
From: =?ISO-8859-1?Q?fugazzi=AE?= <fugazzi99@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs send / receive freeze system?
Date: Sat, 02 Jan 2016 21:21:34 +0000
Message-ID: <2228194.PGMZPs5hoH@orione>
In-Reply-To: <CAPmG0jYbOhpmCNtx-3K=Qefabb8VJJCHqRRQzXH5-EUega75Xg@mail.gmail.com>
References: <2876879.yKrnxB0p8M@orione> <3883736.oK4BscmJWO@orione> <CAPmG0jYbOhpmCNtx-3K=Qefabb8VJJCHqRRQzXH5-EUega75Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks again for your kind answer, Henk .

Memetest86+ runs ok but I really don't know how much I have to leave it 
running. I left it 4 hours in normal mode because the multi thread one crash 
after a few minutes.

Anyway I suppose that if the ram was bad I would have some check-sum 
corruptions around after 1 months or I had noticed something bad even before 
moving to btrfs. 

Since this happen with the two integrated HD controller the mcp55 and the 
sil24 I suspect it could be a mainboard problem that for now it seem not to 
cause data corruption on linux.

Another clue about the possible mainboard failure is that today I installed 
windows(10) for the first time (windows was never installed on this machine 
before) and it was basically unusable: freezing, rebooting, restarting the 
video driver continuously. I don't know if it is the 10 that has problems but,
After a while I had to turn off the pc because after a sudden reboot it was 
stuck on the bios image even after pressing reset many time. I had to unplug 
it! Never see anything like this. May be is time to look for a new pc before 
the explosion!!

Cheers. Mario

On Saturday, January 2, 2016 9:35:31 PM WET Henk Slager wrote:
> On Sat, Jan 2, 2016 at 5:10 PM, fugazzi® <fugazzi99@gmail.com> wrote:
> > Thank you Henk.
> > 
> > Yes I already tried that but it seems the keyboard is also offline so sys
> > commands had no effect. In fact ping was not working also, it seem
> > interrupt got disconnected somehow.
> > 
> > I tried your suggestion but it freeze on different files on different run.
> > I got a freeze every 3-4 pass on average.
> > 
> > I also formatted again and tried to copy something from an external e-sata
> > drive (mounted read only) to the same internal sata drive, it freeze also
> > from there every time on a different file.
> > 
> > If I use rsync to copy or cp the freeze does not happen.
> > 
> > Reformatting the internal drive to XFS solve the freeze, I mean sending
> > the
> > gzipped send to the XFS formatted drive do not freeze the pc. Sending the
> > same gzipped send on the same drive formatted in btrfs freeze the system.
> Another test would be to write gzipped btrfs-stream to file that is on
> the same btrfs-filesystem as the source ro-snapshot that is send. E.g.
> the root stream to /home, ans see if it keeps running. Or write it to
> a subvolume with +C (nodatacow) attrib set, if you think double
> checksumming is the issue.
> 
> > Since no one had/have this problem I'm beginning to guess btrfs might be
> > exposing some hardware failure I was not aware of. It might be possible
> > that having the two drive formatted as btrfs is more hard to the system
> > due to double checksumming, etc.
> 
> I use this send | receive for almost 2 years with various setups, also
> with same kernel / tools version as you use currently. Although I have
> encountered some problems(but no complete freezes), they could all be
> solved or worked-around quite easily.
> I also was thinking of some HW issue. If   memtest86+  says OK, then I
> it will be hard to figure out what it is.
> It is not unthinkable that the same HW works with btrfs->XFS and
> crashes with btrfs->btrfs. I had a similar case: Windows was running
> fine, but linux+btrfs started producing strange errors w.r.t. the
> btrfs filesystem after several days. It turned out that one dataline
> on about 250 addresses in 1 memory module was faulty. But in your case
> I think it is not the memory.
> 
> > It is one month now that this system was converted to btrfs, I never had
> > any problems only this send problem and only after I converted also the
> > second internal drive to btrfs. Scrubs are OK, btrfs check are OK.
> > 
> > I would wait and see if someone else will have similar problems.
> > 
> > For now I mitigated adding a third internal drive formatted in XFS and
> > sending the backup there, then from there copying the backup back to the
> > btrfs drive. Now I have two copy of the same backup on different drive
> > :-)
> > 
> > Regards.
> > 
> > On Saturday, January 2, 2016 12:23:12 AM WET you wrote:
> >> On Fri, Jan 1, 2016 at 4:51 PM, fugazzi® <fugazzi99@gmail.com> wrote:
> >> > Hi everyone.
> >> > It's a few weeks that I converted my root partition into btrfs with
> >> > three
> >> > sub- volumes named boot,root,home. I'm booting with /boot on subvol.
> >> > 
> >> > I'm using btrfs send and receive to make backup of the three
> >> > snapshotted
> >> > subvolumes on a second btrfs formatted drive with three commands like
> >> > this:
> >> > 
> >> > btrfs send /btrfs-root/snap-root/ | gzip > $BKFOLDER/root.dump.gz
> >> > 
> >> > Sometimes, let say once a week, the system completely freeze (mouse
> >> > keyboard) during the send, only solution was the reset button. The
> >> > freeze
> >> > happened on different place every time. Last time happened at 80% of
> >> > the
> >> > home send for example.
> >> > 
> >> > The freeze also happened during a send/receive from an external e-sata
> >> > drive (to copy some mp3 using send instead of rsync) to the same
> >> > internal
> >> > drive where the backup are also made.
> >> > 
> >> > The system always run and was stable with XFS/xfsdump.
> >> > 
> >> > Kernel is 4.3.3, btrfs progs are 4.3.1, system is Arch Linux 64 bit,
> >> > Ram
> >> > 8Gb Mainboard Asus striker extreme Nvidia 680i, 8 years old.
> >> > 
> >> > After the crash nothing is shown in the systemd log, it simply freeze.
> >> 
> >> You could try this (maybe you have already) and see if and where the
> >> problem is in btrfs:
> >> https://en.m.wikipedia.org/wiki/Magic_SysRq_key
> >> 
> >> Instead of pipe to gzip you could do:
> >> | btrfs receive -vv <some btrfs mount>
> >> 
> >> and trace back at which file the freeze happens. Maybe that tells
> >> something
> >> about the source filesystem.
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

