Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38164 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaL1PrC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Dec 2014 10:47:02 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Robert White <rwhite@pobox.com>
Cc: Bardur Arantsson <spam@scientician.net>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sun, 28 Dec 2014 16:47 +0100
Message-ID: <2555795.UuG01n5GBN@merkaba>
In-Reply-To: <2330517.PVzv17pTee@merkaba>
References: <3738341.y7uRQFcLJH@merkaba> <54A01939.3010204@pobox.com> <2330517.PVzv17pTee@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 28. Dezember 2014, 16:42:20 schrieb Martin Steigerwald:
> Am Sonntag, 28. Dezember 2014, 06:52:41 schrieb Robert White:
> > On 12/28/2014 04:07 AM, Martin Steigerwald wrote:
> > > Am Samstag, 27. Dezember 2014, 20:03:09 schrieb Robert White:
> > >> Now:
> > >>
> > >> The complaining party has verified the minimum, repeatable case of
> > >> simple file allocation on a very fragmented system and the responding
> > >> party and several others have understood and supported the bug.
> > >
> > > I didn´t yet provide such a test case.
> > 
> > My bad.
> > 
> > >
> > > At the moment I can only reproduce this kworker thread using a CPU for
> > > minutes case with my /home filesystem.
> > >
> > > A mininmal test case for me would be to be able to reproduce it with a
> > > fresh BTRFS filesystem. But yet with my testcase with the fresh BTRFS I
> > > get 4800 instead of 270 IOPS.
> > >
> > 
> > A version of the test case to demonstrate absolutely system-clogging 
> > loads is pretty easy to construct.
> > 
> > Make a raid1 filesystem.
> > Balance it once to make sure the seed filesystem is fully integrated.
> > 
> > Create a bunch of small files that are at least 4K in size, but are 
> > randomly sized. Fill the entire filesystem with them.
> > 
> > BASH Script:
> > typeset -i counter=0
> > while
> >   dd if=/dev/urandom of=/mnt/Work/$((++counter)) bs=$((4096 + $RANDOM)) 
> > count=1 2>/dev/null
> > do
> > echo $counter >/dev/null #basically a noop
> > done
> >
> > The while will exit when the dd encounters a full filesystem.
> > 
> > Then delete ~10% of the files with
> > rm *0
> > 
> > Run the while loop again, then delete a different 10% with "rm *1".
> > 
> > Then again with rm *2, etc...
> > 
> > Do this a few times and with each iteration the CPU usage gets worse and 
> > worse. You'll easily get system-wide stalls on all IO tasks lasting ten 
> > or more seconds.
> 
> Thanks Robert. Thats wonderful.
> 
> I wondered about such a test case already and thought about reproducing
> it just with fallocate calls instead to reduce the amount of actual
> writes done. I.e. just do some silly fallocate, truncating, write just
> some parts with dd seek and remove things again kind of workload.
> 
> Feel free to add your testcase to the bug report:
> 
> [Bug 90401] New: btrfs kworker thread uses up 100% of a Sandybridge core for minutes on random write into big file
> https://bugzilla.kernel.org/show_bug.cgi?id=90401
> 
> Cause anything that helps a BTRFS developer to reproduce will make it easier
> to find and fix the root cause of it.
> 
> I think I will try with this little critter:
> 
> merkaba:/mnt/btrfsraid1> cat freespracefragment.sh 
> #!/bin/bash
> 
> TESTDIR="./test"
> mkdir -p "$TESTDIR"
> 
> typeset -i counter=0
> while true; do
>         fallocate -l $((4096 + $RANDOM)) "$TESTDIR/$((++counter))"
>         echo $counter >/dev/null #basically a noop
> done
> 
> It takes a time, the script itself is using only a few percent of one core
> there, while busying out the SSDs more heavily than I thought it would do.
> But well I see up to 12000 writes per 10 seconds – thats not that much, still
> it busies one SSD for 80%:
> 
> ATOP - merkaba                                 2014/12/28  16:40:57                                 -----------                                   10s elapsed
> PRC | sys    1.50s | user   3.47s | #proc    367  | #trun      1 | #tslpi   649 | #tslpu     0 | #zombie    0 | clones   839  |              | no  procacct |
> CPU | sys      30% | user     38% | irq       1%  | idle    293% | wait     37% |              | steal     0% | guest     0%  | curf 1.63GHz | curscal  50% |
> cpu | sys       7% | user     11% | irq       1%  | idle     75% | cpu000 w  6% |              | steal     0% | guest     0%  | curf 1.25GHz | curscal  39% |
> cpu | sys       8% | user     11% | irq       0%  | idle     76% | cpu002 w  4% |              | steal     0% | guest     0%  | curf 1.55GHz | curscal  48% |
> cpu | sys       7% | user      9% | irq       0%  | idle     71% | cpu001 w 13% |              | steal     0% | guest     0%  | curf 1.75GHz | curscal  54% |
> cpu | sys       8% | user      7% | irq       0%  | idle     71% | cpu003 w 14% |              | steal     0% | guest     0%  | curf 1.96GHz | curscal  61% |
> CPL | avg1    1.69 | avg5    1.30 | avg15   0.94  |              |              | csw    68387 | intr   36928 |               |              | numcpu     4 |
> MEM | tot    15.5G | free    3.1G | cache   8.8G  | buff    4.2M | slab    1.0G | shmem 210.3M | shrss  79.1M | vmbal   0.0M  | hptot   0.0M | hpuse   0.0M |
> SWP | tot    12.0G | free   11.5G |               |              |              |              |              |               | vmcom   4.9G | vmlim  19.7G |
> LVM | a-btrfsraid1 | busy     80% | read       0  | write  11873 | KiB/r      0 | KiB/w      3 | MBr/s   0.00 | MBw/s   4.31  | avq     1.11 | avio 0.67 ms |
> LVM | a-btrfsraid1 | busy      5% | read       0  | write  11873 | KiB/r      0 | KiB/w      3 | MBr/s   0.00 | MBw/s   4.31  | avq     2.45 | avio 0.04 ms |
> LVM |   msata-home | busy      3% | read       0  | write    175 | KiB/r      0 | KiB/w      3 | MBr/s   0.00 | MBw/s   0.06  | avq     1.71 | avio 1.43 ms |
> LVM | msata-debian | busy      0% | read       0  | write     10 | KiB/r      0 | KiB/w      8 | MBr/s   0.00 | MBw/s   0.01  | avq     1.15 | avio 3.40 ms |
> LVM |    sata-home | busy      0% | read       0  | write    175 | KiB/r      0 | KiB/w      3 | MBr/s   0.00 | MBw/s   0.06  | avq     1.71 | avio 0.04 ms |
> LVM |  sata-debian | busy      0% | read       0  | write     10 | KiB/r      0 | KiB/w      8 | MBr/s   0.00 | MBw/s   0.01  | avq     1.00 | avio 0.10 ms |
> DSK |          sdb | busy     80% | read       0  | write  11880 | KiB/r      0 | KiB/w      3 | MBr/s   0.00 | MBw/s   4.38  | avq     1.11 | avio 0.67 ms |
> DSK |          sda | busy      5% | read       0  | write  12069 | KiB/r      0 | KiB/w      3 | MBr/s   0.00 | MBw/s   4.38  | avq     2.51 | avio 0.04 ms |
> NET | transport    | tcpi      26 | tcpo      26  | udpi       0 | udpo       0 | tcpao      2 | tcppo      1 | tcprs      0  | tcpie      0 | udpie      0 |
> NET | network      | ipi       26 | ipo       26  | ipfrw      0 | deliv     26 |              |              |               | icmpi      0 | icmpo      0 |
> NET | eth0      0% | pcki      10 | pcko      10  | si    5 Kbps | so    1 Kbps | coll       0 | erri       0 | erro       0  | drpi       0 | drpo       0 |
> NET | lo      ---- | pcki      16 | pcko      16  | si    2 Kbps | so    2 Kbps | coll       0 | erri       0 | erro       0  | drpi       0 | drpo       0 |
> 
>   PID     TID    RUID        EUID         THR    SYSCPU    USRCPU     VGROW     RGROW    RDDSK     WRDSK    ST    EXC    S    CPUNR     CPU    CMD        1/4
>  9169       -    martin      martin        14     0.22s     1.53s        0K        0K       0K        4K    --      -    S        1     18%    amarok
>  1488       -    root        root           1     0.34s     0.27s      220K        0K       0K        0K    --      -    S        2      6%    Xorg
>  6816       -    martin      martin         7     0.05s     0.44s        0K        0K       0K        0K    --      -    S        1      5%    kmail
> 24390       -    root        root           1     0.20s     0.25s       24K       24K       0K    40800K    --      -    S        0      5%    freespracefrag
>  3268       -    martin      martin         3     0.08s     0.34s        0K        0K       0K       24K    --      -    S        0      4%    kwin
> 
> 
> 
> But only with a low amount of writes:
> 
> merkaba:/mnt/btrfsraid1> vmstat 1
> procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
>  2  0 538424 3326248   4304 9202576    6   11  1968  4029  273  207 15 10 72  3  0
>  1  0 538424 3325244   4304 9202836    0    0     0  6456 3498 7635 11  8 72 10  0
>  0  0 538424 3325168   4304 9202932    0    0     0  9032 3719 6764  9  9 74  9  0
>  0  0 538424 3334508   4304 9202932    0    0     0  8936 3548 6035  7  8 76  9  0
>  0  0 538424 3334144   4304 9202876    0    0     0  9008 3335 5635  7  7 76 10  0
>  0  0 538424 3332724   4304 9202728    0    0     0 11240 3555 5699  7  8 76 10  0
>  2  0 538424 3333328   4304 9202876    0    0     0  9080 3724 6542  8  8 75  9  0
>  0  0 538424 3333328   4304 9202876    0    0     0  6968 2951 5015  7  7 76 10  0
>  0  1 538424 3332832   4304 9202584    0    0     0  9160 3663 6772  8  8 76  9  0

Let me rephrase that.

One one hand rather low, but for the kind of workload just for *fallocating*
new files actually quite much. I just tell it to *reserve* the space for the
file I do not tell it to write to them. And yet its about 6-12 MiB/s.

> Still it busies one of both SSDs for about 80%:
> 
> iostat -xz 1
> 
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            7,04    0,00    7,04    9,80    0,00   76,13
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sda               0,00     0,00    0,00 1220,00     0,00  4556,00     7,47     0,12    0,10    0,00    0,10   0,04   5,10
> sdb               0,00    10,00    0,00 1210,00     0,00  4556,00     7,53     0,85    0,70    0,00    0,70   0,66  79,90
> dm-2              0,00     0,00    0,00    4,00     0,00    36,00    18,00     0,02    5,00    0,00    5,00   4,25   1,70
> dm-5              0,00     0,00    0,00    4,00     0,00    36,00    18,00     0,00    0,25    0,00    0,25   0,25   0,10
> dm-6              0,00     0,00    0,00 1216,00     0,00  4520,00     7,43     0,12    0,10    0,00    0,10   0,04   5,00
> dm-7              0,00     0,00    0,00 1216,00     0,00  4520,00     7,43     0,84    0,69    0,00    0,69   0,66  79,70
> 
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            6,55    0,00    7,81    9,32    0,00   76,32
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sda               0,00     0,00    0,00 1203,00     0,00  4472,00     7,43     0,09    0,07    0,00    0,07   0,03   3,80
> sdb               0,00     0,00    0,00 1203,00     0,00  4472,00     7,43     0,79    0,66    0,00    0,66   0,64  77,10
> dm-6              0,00     0,00    0,00 1203,00     0,00  4472,00     7,43     0,09    0,07    0,00    0,07   0,03   4,00
> dm-7              0,00     0,00    0,00 1203,00     0,00  4472,00     7,43     0,79    0,66    0,00    0,66   0,64  77,10
> 
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            7,79    0,00    7,79    9,30    0,00   75,13
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sda               0,00     0,00    0,00 1202,00     0,00  4468,00     7,43     0,09    0,07    0,00    0,07   0,04   4,70
> sdb               0,00     0,00    4,00 1202,00  2048,00  4468,00    10,81     0,86    0,71    4,75    0,70   0,65  78,10
> dm-1              0,00     0,00    4,00    0,00  2048,00     0,00  1024,00     0,02    4,75    4,75    0,00   2,00   0,80
> dm-6              0,00     0,00    0,00 1202,00     0,00  4468,00     7,43     0,08    0,07    0,00    0,07   0,04   4,60
> dm-7              0,00     0,00    0,00 1202,00     0,00  4468,00     7,43     0,84    0,70    0,00    0,70   0,65  77,80
> 
> 
> But yet, neither I hit full CPU usage nor full SSD usage (just 80%), so
> this is yet another interesting case.
[…]
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
