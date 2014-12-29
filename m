Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45741 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaL2JOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 04:14:33 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Robert White <rwhite@pobox.com>
Cc: Bardur Arantsson <spam@scientician.net>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Mon, 29 Dec 2014 10:14:31 +0100
Message-ID: <1901752.OTIncoD3om@merkaba>
In-Reply-To: <54A09FFD.4030107@pobox.com>
References: <3738341.y7uRQFcLJH@merkaba> <2330517.PVzv17pTee@merkaba> <54A09FFD.4030107@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 28. Dezember 2014, 16:27:41 schrieb Robert White:
> On 12/28/2014 07:42 AM, Martin Steigerwald wrote:
> > Am Sonntag, 28. Dezember 2014, 06:52:41 schrieb Robert White:
> >> On 12/28/2014 04:07 AM, Martin Steigerwald wrote:
> >>> Am Samstag, 27. Dezember 2014, 20:03:09 schrieb Robert White:
> >>>> Now:
> >>>>
> >>>> The complaining party has verified the minimum, repeatable case of
> >>>> simple file allocation on a very fragmented system and the responding
> >>>> party and several others have understood and supported the bug.
> >>>
> >>> I didn´t yet provide such a test case.
> >>
> >> My bad.
> >>
> >>>
> >>> At the moment I can only reproduce this kworker thread using a CPU for
> >>> minutes case with my /home filesystem.
> >>>
> >>> A mininmal test case for me would be to be able to reproduce it with a
> >>> fresh BTRFS filesystem. But yet with my testcase with the fresh BTRFS I
> >>> get 4800 instead of 270 IOPS.
> >>>
> >>
> >> A version of the test case to demonstrate absolutely system-clogging
> >> loads is pretty easy to construct.
> >>
> >> Make a raid1 filesystem.
> >> Balance it once to make sure the seed filesystem is fully integrated.
> >>
> >> Create a bunch of small files that are at least 4K in size, but are
> >> randomly sized. Fill the entire filesystem with them.
> >>
> >> BASH Script:
> >> typeset -i counter=0
> >> while
> >>    dd if=/dev/urandom of=/mnt/Work/$((++counter)) bs=$((4096 + $RANDOM))
> >> count=1 2>/dev/null
> >> do
> >> echo $counter >/dev/null #basically a noop
> >> done
> >>
> >> The while will exit when the dd encounters a full filesystem.
> >>
> >> Then delete ~10% of the files with
> >> rm *0
> >>
> >> Run the while loop again, then delete a different 10% with "rm *1".
> >>
> >> Then again with rm *2, etc...
> >>
> >> Do this a few times and with each iteration the CPU usage gets worse and
> >> worse. You'll easily get system-wide stalls on all IO tasks lasting ten
> >> or more seconds.
> >
> > Thanks Robert. Thats wonderful.
> >
> > I wondered about such a test case already and thought about reproducing
> > it just with fallocate calls instead to reduce the amount of actual
> > writes done. I.e. just do some silly fallocate, truncating, write just
> > some parts with dd seek and remove things again kind of workload.
> >
> > Feel free to add your testcase to the bug report:
> >
> > [Bug 90401] New: btrfs kworker thread uses up 100% of a Sandybridge core for minutes on random write into big file
> > https://bugzilla.kernel.org/show_bug.cgi?id=90401
> >
> > Cause anything that helps a BTRFS developer to reproduce will make it easier
> > to find and fix the root cause of it.
> >
> > I think I will try with this little critter:
> >
> > merkaba:/mnt/btrfsraid1> cat freespracefragment.sh
> > #!/bin/bash
> >
> > TESTDIR="./test"
> > mkdir -p "$TESTDIR"
> >
> > typeset -i counter=0
> > while true; do
> >          fallocate -l $((4096 + $RANDOM)) "$TESTDIR/$((++counter))"
> >          echo $counter >/dev/null #basically a noop
> > done
> 
> If you don't do the remove/delete passes you won't get as much 
> fragmentation...
> 
> I also noticed that fallocate would not actually create the files in my 
> toolset, so I had to touch them first. So the theoretical script became
> 
> e.g.
> 
> typeset -i counter=0
> for AA in {0..9}
> do
>    while
>      touch ${TESTDIR}/$((++counter)) &&
>      fallocate -l $((4096 + $RANDOM)) $TESTDIR/$((counter))
>    do
>      if ((counter%100 == 0))
>      then
>        echo $counter
>      fi
>    done
>    echo "removing ${AA}"
>    rm ${TESTDIR}/*${AA}
> done

Hmmm, strange. It did here. I had a ton of files in the test directory.

> Meanwhile, on my test rig using fallocate did _not_ result in final 
> exhaustion of resources. That is btrfs fi df /mnt/Work didn't show 
> significant changes on a near full expanse.

Hmmm, I had it running up to it allocating about 5 GiB in the data chunks.

But I stopped it yesterday. It took a long time to get there. It seems to be
quite slow on filling a 10 GiB RAID-1 BTRFS. I bet that may be due to lots
of forks for the fallocate command.

But it seems my fallocate works differently than yours. I have fallocate
from:

merkaba:~> fallocate --version
fallocate von util-linux 2.25.2

> I also never got a failed response back from fallocate, that is the 
> inner loop never terminated. This could be a problem with the system 
> call itself or it could be a problem with the application wrapper.

Hmmm, it should return a failure like this:

merkaba:/mnt/btrfsraid1> LANG=C fallocate -l 20G 20g
fallocate: fallocate failed: No space left on device
merkaba:/mnt/btrfsraid1#1> echo $?
1
 
> Nor did I reach the CPU saturation I expected.

No, I didn´t reach it as well. Just 5% or so for the script itself and I
didn´t see any notable kworker activity. But I stopped it before the
filesystem was full, so.

> e.g.
> Gust vm # btrfs fi df /mnt/Work/
> Data, RAID1: total=1.72GiB, used=1.66GiB
> System, RAID1: total=32.00MiB, used=16.00KiB
> Metadata, RAID1: total=256.00MiB, used=57.84MiB
> GlobalReserve, single: total=32.00MiB, used=0.00B
> 
> time passes while script running...
> 
> Gust vm # btrfs fi df /mnt/Work/
> Data, RAID1: total=1.72GiB, used=1.66GiB
> System, RAID1: total=32.00MiB, used=16.00KiB
> Metadata, RAID1: total=256.00MiB, used=57.84MiB
> GlobalReserve, single: total=32.00MiB, used=0.00B
> 
> So there may be some limiting factor or something.
> 
> Without the actual writes to the actual file expanse I don't get the stalls.

Interesting. We may have unveiled another performance issue with fallocate
on BTRFS then.

> 
> (I added a _touch_ of instrumentation, it makes the various catostrophy 
> events a little more obvious in context. 8-)
> 
> mount /dev/whattever /mnt/Work
> typeset -i counter=0
> for AA in {0..9}
> do
>    while
>      dd if=/dev/urandom of=/mnt/Work/$((++counter)) bs=$((4096 + 
> $RANDOM)) count=1 2>/dev/null
>    do
>      if ((counter%100 == 0))
>      then
>        echo $counter
>        if ((counter%1000 == 0))
>        then
>          btrfs fi df /mnt/Work
>        fi
>      fi
>    done
>    btrfs fi df /mnt/Work
>    echo "removing ${AA}"
>    rm /mnt/Work/*${AA}
>    btrfs fi df /mnt/Work
> done
> 
> So you definitely need the writes to really see the stalls.

Hmmm, interesting. Will try this some time. But right now other stuffs
that are also important, so I take a break from this.

> > I may try with with my test BTRFS. I could even make it 2x20 GiB RAID 1
> > as well.
> 
> I guess I never mentioned it... I am using 4x1GiB NOCOW files through 
> losetup as the basis of a RAID1. No compression (by virtue of the NOCOW 
> files in underlying fs, and not being set in the resulting mount). No 
> encryption. No LVM.

Well okay, I am using BTRFS RAID 1 on two logical volumes in two different
volume groups which are spun over a partition each on two different SSDs:

Intel SSD 320 with 300 GB on SATA-600 (but SSD can only do SATA-300) +
Crucial m500 480 GB on mSATA-300 (but SSD could do SATA-600)

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
