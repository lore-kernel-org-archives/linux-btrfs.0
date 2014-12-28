Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55821 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaL1Nkn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Dec 2014 08:40:43 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Robert White <rwhite@pobox.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again (further tests, as close as I dare)
Date: Sun, 28 Dec 2014 14:40:32 +0100
Message-ID: <4646600.pkiZfU6OfG@merkaba>
In-Reply-To: <1930625.5Z83nuS5i9@merkaba>
References: <3738341.y7uRQFcLJH@merkaba> <2235526.D1sZ4Blnlh@merkaba> <1930625.5Z83nuS5i9@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2377056.MHhWEGL6Fq"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2377056.MHhWEGL6Fq
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Sonntag, 28. Dezember 2014, 14:00:19 schrieb Martin Steigerwald:
> Am Samstag, 27. Dezember 2014, 14:55:58 schrieb Martin Steigerwald:
> > Summarized at
> >=20
> > Bug 90401 - btrfs kworker thread uses up 100% of a Sandybridge core=
 for minutes on random write into big file
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D90401
> >=20
> > see below. This is reproducable with fio, no need for Windows XP in=

> > Virtualbox for reproducing the issue. Next I will try to reproduce =
with
> > a freshly creating filesystem.
> >=20
> >=20
> > Am Samstag, 27. Dezember 2014, 09:30:43 schrieb Hugo Mills:
> > > On Sat, Dec 27, 2014 at 10:01:17AM +0100, Martin Steigerwald wrot=
e:
> > > > Am Freitag, 26. Dezember 2014, 14:48:38 schrieb Robert White:
> > > > > On 12/26/2014 05:37 AM, Martin Steigerwald wrote:
> > > > > > Hello!
> > > > > >=20
> > > > > > First: Have a merry christmas and enjoy a quiet time in the=
se days.
> > > > > >=20
> > > > > > Second: At a time you feel like it, here is a little rant, =
but also a
> > > > > > bug
> > > > > > report:
> > > > > >=20
> > > > > > I have this on 3.18 kernel on Debian Sid with BTRFS Dual SS=
D RAID with
> > > > > > space_cache, skinny meta data extents =E2=80=93 are these a=
 problem? =E2=80=93 and
> > > > >=20
> > > > > > compress=3Dlzo:
> > > > > (there is no known problem with skinny metadata, it's actuall=
y more
> > > > > efficient than the older format. There has been some anecdote=
s about
> > > > > mixing the skinny and fat metadata but nothing has ever been
> > > > > demonstrated problematic.)
> > > > >=20
> > > > > > merkaba:~> btrfs fi sh /home
> > > > > > Label: 'home'  uuid: b96c4f72-0523-45ac-a401-f7be73dd624a
> > > > > >=20
> > > > > >          Total devices 2 FS bytes used 144.41GiB
> > > > > >          devid    1 size 160.00GiB used 160.00GiB path
> > > > > >          /dev/mapper/msata-home
> > > > > >          devid    2 size 160.00GiB used 160.00GiB path
> > > > > >          /dev/mapper/sata-home
> > > > > >=20
> > > > > > Btrfs v3.17
> > > > > > merkaba:~> btrfs fi df /home
> > > > > > Data, RAID1: total=3D154.97GiB, used=3D141.12GiB
> > > > > > System, RAID1: total=3D32.00MiB, used=3D48.00KiB
> > > > > > Metadata, RAID1: total=3D5.00GiB, used=3D3.29GiB
> > > > > > GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
> > > > >=20
> > > > > This filesystem, at the allocation level, is "very full" (see=
 below).
> > > > >=20
> > > > > > And I had hangs with BTRFS again. This time as I wanted to =
install tax
> > > > > > return software in Virtualbox=C2=B4d Windows XP VM (which I=
 use once a year
> > > > > > cause I know no tax return software for Linux which would b=
e suitable
> > > > > > for
> > > > > > Germany and I frankly don=C2=B4t care about the end of secu=
rity cause all
> > > > > > surfing and other network access I will do from the Linux b=
ox and I
> > > > > > only
> > > > > > run the VM behind a firewall).
> > > > >=20
> > > > > > And thus I try the balance dance again:
> > > > > ITEM: Balance... it doesn't do what you think it does... 8-)
> > > > >=20
> > > > > "Balancing" is something you should almost never need to do. =
It is only
> > > > > for cases of changing geometry (adding disks, switching RAID =
levels,
> > > > > etc.) of for cases when you've radically changed allocation b=
ehaviors
> > > > > (like you decided to remove all your VM's or you've decided t=
o remove a
> > > > > mail spool directory full of thousands of tiny files).
> > > > >=20
> > > > > People run balance all the time because they think they shoul=
d. They are
> > > > > _usually_ incorrect in that belief.
> > > >=20
> > > > I only see the lockups of BTRFS is the trees *occupy* all space=
 on the
> > > > device.
> > >    No, "the trees" occupy 3.29 GiB of your 5 GiB of mirrored meta=
data
> > > space. What's more, balance does *not* balance the metadata trees=
. The
> > > remaining space -- 154.97 GiB -- is unstructured storage for file=

> > > data, and you have some 13 GiB of that available for use.
> > >=20
> > >    Now, since you're seeing lockups when the space on your disks =
is
> > > all allocated I'd say that's a bug. However, you're the *only* pe=
rson
> > > who's reported this as a regular occurrence. Does this happen wit=
h all
> > > filesystems you have, or just this one?
> > >=20
> > > > I *never* so far saw it lockup if there is still space BTRFS ca=
n allocate
> > > > from to *extend* a tree.
> > >=20
> > >    It's not a tree. It's simply space allocation. It's not even s=
pace
> > > *usage* you're talking about here -- it's just allocation (i.e. t=
he FS
> > > saying "I'm going to use this piece of disk for this purpose").
> > >=20
> > > > This may be a bug, but this is what I see.
> > > >=20
> > > > And no amount of "you should not balance a BTRFS" will make tha=
t
> > > > perception go away.
> > > >=20
> > > > See, I see the sun coming out on a morning and you tell me "no,=
 it
> > > > doesn=C2=B4t". Simply that is not going to match my perception.=

> > >=20
> > >    Duncan's assertion is correct in its detail. Looking at your s=
pace
> >=20
> > Robert's :)
> >=20
> > > usage, I would not suggest that running a balance is something yo=
u
> > > need to do. Now, since you have these lockups that seem quite
> > > repeatable, there's probably a lurking bug in there, but hacking
> > > around with balance every time you hit it isn't going to get the
> > > problem solved properly.
> > >=20
> > >    I think I would suggest the following:
> > >=20
> > >  - make sure you have some way of logging your dmesg permanently =
(use
> > >    a different filesystem for /var/log, or a serial console, or a=

> > >    netconsole)
> > >=20
> > >  - when the lockup happens, hit Alt-SysRq-t a few times
> > >=20
> > >  - send the dmesg output here, or post to bugzilla.kernel.org
> > >=20
> > >    That's probably going to give enough information to the develo=
pers
> > > to work out where the lockup is happening, and is clearly the way=

> > > forward here.
> >=20
> > And I got it reproduced. *Perfectly* reproduced, I=C2=B4d say.
> >=20
> > But let me run the whole story:
> >=20
> > 1) I downsized my /home BTRFS from dual 170 GiB to dual 160 GiB aga=
in.
>=20
> [=E2=80=A6 story of trying to reproduce with Windows XP defragmenting=
 which was
> unsuccessful as BTRFS still had free device space to allocate new chu=
nks
> from =E2=80=A6]
>=20
> > But finally I got to:
> >=20
> > merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
> > Sa 27. Dez 13:26:39 CET 2014
> > Label: 'home'  uuid: [some UUID]
> >         Total devices 2 FS bytes used 152.83GiB
> >         devid    1 size 160.00GiB used 160.00GiB path /dev/mapper/m=
sata-home
> >         devid    2 size 160.00GiB used 160.00GiB path /dev/mapper/s=
ata-home
> >=20
> > Btrfs v3.17
> > Data, RAID1: total=3D154.97GiB, used=3D149.58GiB
> > System, RAID1: total=3D32.00MiB, used=3D48.00KiB
> > Metadata, RAID1: total=3D5.00GiB, used=3D3.26GiB
> > GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
> >=20
> >=20
> >=20
> > So I did, if Virtualbox can write randomly in a file, I can too.
> >=20
> > So I did:
> >=20
> >=20
> > martin@merkaba:~> cat ssd-test.fio=20
> > [global]
> > bs=3D4k
> > #ioengine=3Dlibaio
> > #iodepth=3D4
> > size=3D4g
> > #direct=3D1
> > runtime=3D120
> > filename=3Dssd.test.file
> >=20
> > [seq-write]
> > rw=3Dwrite
> > stonewall
> >=20
> > [rand-write]
> > rw=3Drandwrite
> > stonewall
> >=20
> >=20
> >=20
> > And got:
> >=20
> > ATOP - merkaba                          2014/12/27  13:41:02       =
                   -----------                           10s elapsed
> > PRC |  sys   10.14s |  user   0.38s |  #proc    332  | #trun      2=
  |  #tslpi   548 |  #tslpu     0 |  #zombie    0  | no  procacct  |
> > CPU |  sys     102% |  user      4% |  irq       0%  | idle    295%=
  |  wait      0% |  guest     0% |  curf 3.10GHz  | curscal  96%  |
> > cpu |  sys      76% |  user      0% |  irq       0%  | idle     24%=
  |  cpu001 w  0% |  guest     0% |  curf 3.20GHz  | curscal  99%  |
> > cpu |  sys      24% |  user      1% |  irq       0%  | idle     75%=
  |  cpu000 w  0% |  guest     0% |  curf 3.19GHz  | curscal  99%  |
> > cpu |  sys       1% |  user      1% |  irq       0%  | idle     98%=
  |  cpu002 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > cpu |  sys       1% |  user      1% |  irq       0%  | idle     98%=
  |  cpu003 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > CPL |  avg1    0.82 |  avg5    0.78 |  avg15   0.99  |             =
  |  csw     6233 |  intr   12023 |                | numcpu     4  |
> > MEM |  tot    15.5G |  free    4.0G |  cache   9.7G  | buff    0.0M=
  |  slab  333.1M |  shmem 206.6M |  vmbal   0.0M  | hptot   0.0M  |
> > SWP |  tot    12.0G |  free   11.7G |                |             =
  |               |               |  vmcom   3.4G  | vmlim  19.7G  |
> > LVM |     sata-home |  busy      0% |  read       8  | write      0=
  |  KiB/w      0 |  MBr/s   0.00 |  MBw/s   0.00  | avio 0.12 ms  |
> > DSK |           sda |  busy      0% |  read       8  | write      0=
  |  KiB/w      0 |  MBr/s   0.00 |  MBw/s   0.00  | avio 0.12 ms  |
> > NET |  transport    |  tcpi      16 |  tcpo      16  | udpi       0=
  |  udpo       0 |  tcpao      1 |  tcppo      1  | tcprs      0  |
> > NET |  network      |  ipi       16 |  ipo       16  | ipfrw      0=
  |  deliv     16 |               |  icmpi      0  | icmpo      0  |
> > NET |  lo      ---- |  pcki      16 |  pcko      16  | si    2 Kbps=
  |  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
> >=20
> >   PID    TID   RUID      EUID        THR  SYSCPU   USRCPU   VGROW  =
  RGROW   RDDSK    WRDSK  ST   EXC  S   CPUNR   CPU   CMD        1/2
> > 18079      -   martin    martin        2   9.99s    0.00s      0K  =
     0K      0K      16K  --     -  R       1  100%   fio
> >  4746      -   martin    martin        2   0.01s    0.14s      0K  =
     0K      0K       0K  --     -  S       2    2%   konsole
> >  3291      -   martin    martin        4   0.01s    0.11s      0K  =
     0K      0K       0K  --     -  S       0    1%   plasma-desktop
> >  1488      -   root      root          1   0.03s    0.04s      0K  =
     0K      0K       0K  --     -  S       0    1%   Xorg
> > 10036      -   root      root          1   0.04s    0.02s      0K  =
     0K      0K       0K  --     -  R       2    1%   atop
> >=20
> > while fio was just *laying* out the 4 GiB file. Yes, thats 100% sys=
tem CPU
> > for 10 seconds while allocatiing a 4 GiB file on a filesystem like:=

> >=20
> > martin@merkaba:~> LANG=3DC df -hT /home
> > Filesystem             Type   Size  Used Avail Use% Mounted on
> > /dev/mapper/msata-home btrfs  170G  156G   17G  91% /home
> >=20
> > where a 4 GiB file should easily fit, no? (And this output is with =
the 4
> > GiB file. So it was even 4 GiB more free before.)
> >=20
> >=20
> > But it gets even more visible:
> >=20
> > martin@merkaba:~> fio ssd-test.fio
> > seq-write: (g=3D0): rw=3Dwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3D=
sync, iodepth=3D1
> > rand-write: (g=3D1): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengi=
ne=3Dsync, iodepth=3D1
> > fio-2.1.11
> > Starting 2 processes
> > Jobs: 1 (f=3D1): [_(1),w(1)] [19.3% done] [0KB/0KB/0KB /s] [0/0/0 i=
ops] [eta 01m:57s]      =20
> > 0$ zsh  1$ zsh  2$ zsh  3-$ zsh  4$ zsh  5$* zsh                   =
               =20
> >=20
> >=20
> > yes, thats 0 IOPS.
> >=20
> > 0 IOPS and in zero IOPS. For minutes.
> >=20
> >=20
> >=20
> > And here is why:
> >=20
> > ATOP - merkaba                          2014/12/27  13:46:52       =
                   -----------                           10s elapsed
> > PRC |  sys   10.77s |  user   0.31s |  #proc    334  | #trun      2=
  |  #tslpi   548 |  #tslpu     3 |  #zombie    0  | no  procacct  |
> > CPU |  sys     108% |  user      3% |  irq       0%  | idle    286%=
  |  wait      2% |  guest     0% |  curf 3.08GHz  | curscal  96%  |
> > cpu |  sys      72% |  user      1% |  irq       0%  | idle     28%=
  |  cpu000 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > cpu |  sys      19% |  user      0% |  irq       0%  | idle     81%=
  |  cpu001 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > cpu |  sys      11% |  user      1% |  irq       0%  | idle     87%=
  |  cpu003 w  1% |  guest     0% |  curf 3.19GHz  | curscal  99%  |
> > cpu |  sys       6% |  user      1% |  irq       0%  | idle     91%=
  |  cpu002 w  1% |  guest     0% |  curf 3.11GHz  | curscal  97%  |
> > CPL |  avg1    2.78 |  avg5    1.34 |  avg15   1.12  |             =
  |  csw    50192 |  intr   32379 |                | numcpu     4  |
> > MEM |  tot    15.5G |  free    5.0G |  cache   8.7G  | buff    0.0M=
  |  slab  332.6M |  shmem 207.2M |  vmbal   0.0M  | hptot   0.0M  |
> > SWP |  tot    12.0G |  free   11.7G |                |             =
  |               |               |  vmcom   3.4G  | vmlim  19.7G  |
> > LVM |     sata-home |  busy      5% |  read     160  | write  11177=
  |  KiB/w      3 |  MBr/s   0.06 |  MBw/s   4.36  | avio 0.05 ms  |
> > LVM |    msata-home |  busy      4% |  read      28  | write  11177=
  |  KiB/w      3 |  MBr/s   0.01 |  MBw/s   4.36  | avio 0.04 ms  |
> > LVM |   sata-debian |  busy      0% |  read       0  | write    844=
  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.33  | avio 0.02 ms  |
> > LVM |  msata-debian |  busy      0% |  read       0  | write    844=
  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.33  | avio 0.02 ms  |
> > DSK |           sda |  busy      5% |  read     160  | write  10200=
  |  KiB/w      4 |  MBr/s   0.06 |  MBw/s   4.69  | avio 0.05 ms  |
> > DSK |           sdb |  busy      4% |  read      28  | write  10558=
  |  KiB/w      4 |  MBr/s   0.01 |  MBw/s   4.69  | avio 0.04 ms  |
> > NET |  transport    |  tcpi      35 |  tcpo      33  | udpi       3=
  |  udpo       3 |  tcpao      2 |  tcppo      1  | tcprs      0  |
> > NET |  network      |  ipi       38 |  ipo       36  | ipfrw      0=
  |  deliv     38 |               |  icmpi      0  | icmpo      0  |
> > NET |  eth0      0% |  pcki      22 |  pcko      20  | si    9 Kbps=
  |  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
> > NET |  lo      ---- |  pcki      16 |  pcko      16  | si    2 Kbps=
  |  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
> >=20
> >   PID    TID   RUID      EUID        THR  SYSCPU   USRCPU   VGROW  =
  RGROW   RDDSK    WRDSK  ST   EXC  S   CPUNR   CPU   CMD        1/3
> > 14973      -   root      root          1   8.92s    0.00s      0K  =
     0K      0K     144K  --     -  S       0   89%   kworker/u8:14
> > 17450      -   root      root          1   0.86s    0.00s      0K  =
     0K      0K      32K  --     -  R       3    9%   kworker/u8:5
> >   788      -   root      root          1   0.25s    0.00s      0K  =
     0K    128K   18880K  --     -  S       3    3%   btrfs-transact
> > 12254      -   root      root          1   0.14s    0.00s      0K  =
     0K     64K     576K  --     -  S       2    1%   kworker/u8:3
> > 17332      -   root      root          1   0.11s    0.00s      0K  =
     0K    112K    1348K  --     -  S       2    1%   kworker/u8:4
> >  3291      -   martin    martin        4   0.01s    0.09s      0K  =
     0K      0K       0K  --     -  S       1    1%   plasma-deskto
> >=20
> >=20
> >=20
> >=20
> > ATOP - merkaba                          2014/12/27  13:47:12       =
                   -----------                           10s elapsed
> > PRC |  sys   10.78s |  user   0.44s |  #proc    334  | #trun      3=
  |  #tslpi   547 |  #tslpu     3 |  #zombie    0  | no  procacct  |
> > CPU |  sys     106% |  user      4% |  irq       0%  | idle    288%=
  |  wait      1% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > cpu |  sys      93% |  user      0% |  irq       0%  | idle      7%=
  |  cpu002 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > cpu |  sys       7% |  user      0% |  irq       0%  | idle     93%=
  |  cpu003 w  0% |  guest     0% |  curf 3.01GHz  | curscal  94%  |
> > cpu |  sys       3% |  user      2% |  irq       0%  | idle     94%=
  |  cpu000 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > cpu |  sys       3% |  user      2% |  irq       0%  | idle     95%=
  |  cpu001 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > CPL |  avg1    3.33 |  avg5    1.56 |  avg15   1.20  |             =
  |  csw    38253 |  intr   23104 |                | numcpu     4  |
> > MEM |  tot    15.5G |  free    4.9G |  cache   8.7G  | buff    0.0M=
  |  slab  336.5M |  shmem 207.2M |  vmbal   0.0M  | hptot   0.0M  |
> > SWP |  tot    12.0G |  free   11.7G |                |             =
  |               |               |  vmcom   3.4G  | vmlim  19.7G  |
> > LVM |    msata-home |  busy      2% |  read       0  | write   2337=
  |  KiB/w      3 |  MBr/s   0.00 |  MBw/s   0.91  | avio 0.07 ms  |
> > LVM |     sata-home |  busy      2% |  read      36  | write   2337=
  |  KiB/w      3 |  MBr/s   0.01 |  MBw/s   0.91  | avio 0.07 ms  |
> > LVM |  msata-debian |  busy      1% |  read       1  | write   1630=
  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.65  | avio 0.03 ms  |
> > LVM |   sata-debian |  busy      0% |  read       0  | write   1019=
  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.41  | avio 0.02 ms  |
> > DSK |           sdb |  busy      2% |  read       1  | write   2545=
  |  KiB/w      5 |  MBr/s   0.00 |  MBw/s   1.45  | avio 0.07 ms  |
> > DSK |           sda |  busy      1% |  read      36  | write   2461=
  |  KiB/w      5 |  MBr/s   0.01 |  MBw/s   1.28  | avio 0.06 ms  |
> > NET |  transport    |  tcpi      20 |  tcpo      20  | udpi       1=
  |  udpo       1 |  tcpao      1 |  tcppo      1  | tcprs      0  |
> > NET |  network      |  ipi       21 |  ipo       21  | ipfrw      0=
  |  deliv     21 |               |  icmpi      0  | icmpo      0  |
> > NET |  eth0      0% |  pcki       5 |  pcko       5  | si    0 Kbps=
  |  so    0 Kbps |  erri       0 |  erro       0  | drpo       0  |
> > NET |  lo      ---- |  pcki      16 |  pcko      16  | si    2 Kbps=
  |  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
> >=20
> >   PID    TID   RUID      EUID        THR  SYSCPU   USRCPU   VGROW  =
  RGROW   RDDSK    WRDSK  ST   EXC  S   CPUNR   CPU   CMD        1/3
> > 17450      -   root      root          1   9.96s    0.00s      0K  =
     0K      0K       0K  --     -  R       2  100%   kworker/u8:5
> >  4746      -   martin    martin        2   0.06s    0.15s      0K  =
     0K      0K       0K  --     -  S       1    2%   konsole
> > 10508      -   root      root          1   0.13s    0.00s      0K  =
     0K     96K    4048K  --     -  S       1    1%   kworker/u8:18
> >  1488      -   root      root          1   0.06s    0.06s      0K  =
     0K      0K       0K  --     -  S       0    1%   Xorg
> > 17332      -   root      root          1   0.12s    0.00s      0K  =
     0K     96K     580K  --     -  R       3    1%   kworker/u8:4
> > 17454      -   root      root          1   0.11s    0.00s      0K  =
     0K     32K    4416K  --     -  D       1    1%   kworker/u8:6
> > 17516      -   root      root          1   0.09s    0.00s      0K  =
     0K     16K     136K  --     -  S       3    1%   kworker/u8:7
> >  3268      -   martin    martin        3   0.02s    0.05s      0K  =
     0K      0K       0K  --     -  S       1    1%   kwin
> > 10036      -   root      root          1   0.05s    0.02s      0K  =
     0K      0K       0K  --     -  R       0    1%   atop
> >=20
> >=20
> >=20
> > So BTRFS is basically busy with itself and nothing else. Look at th=
e SSD
> > usage. They are *idling* around. Heck 2400 write accesses in 10 sec=
onds.
> > Thats a joke with SSDs that can do 40000 IOPS (depending on how and=
 what
> > you measure of course, like request size, read, write, iodepth and =
so).
> >=20
> > Its kworker/u8:5 utilizing 100% of one core for minutes.
> >=20
> >=20
> >=20
> > Its the random write case it seems. Here are values from fio job:
> >=20
> > martin@merkaba:~> fio ssd-test.fio
> > seq-write: (g=3D0): rw=3Dwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3D=
sync, iodepth=3D1
> > rand-write: (g=3D1): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengi=
ne=3Dsync, iodepth=3D1
> > fio-2.1.11
> > Starting 2 processes
> > Jobs: 1 (f=3D1): [_(1),w(1)] [3.6% done] [0KB/0KB/0KB /s] [0/0/0 io=
ps] [eta 01h:06m:26s]
> > seq-write: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D19212: Sat Dec =
27 13:48:33 2014
> >   write: io=3D4096.0MB, bw=3D343683KB/s, iops=3D85920, runt=3D 1220=
4msec
> >     clat (usec): min=3D3, max=3D38048, avg=3D10.52, stdev=3D205.25
> >      lat (usec): min=3D3, max=3D38048, avg=3D10.66, stdev=3D205.43
> >     clat percentiles (usec):
> >      |  1.00th=3D[    4],  5.00th=3D[    4], 10.00th=3D[    4], 20.=
00th=3D[    4],
> >      | 30.00th=3D[    4], 40.00th=3D[    5], 50.00th=3D[    5], 60.=
00th=3D[    5],
> >      | 70.00th=3D[    7], 80.00th=3D[    8], 90.00th=3D[    8], 95.=
00th=3D[    9],
> >      | 99.00th=3D[   14], 99.50th=3D[   20], 99.90th=3D[  211], 99.=
95th=3D[ 2128],
> >      | 99.99th=3D[10304]
> >     bw (KB  /s): min=3D164328, max=3D812984, per=3D100.00%, avg=3D3=
45585.75, stdev=3D201695.20
> >     lat (usec) : 4=3D0.18%, 10=3D95.31%, 20=3D4.00%, 50=3D0.18%, 10=
0=3D0.12%
> >     lat (usec) : 250=3D0.12%, 500=3D0.02%, 750=3D0.01%, 1000=3D0.01=
%
> >     lat (msec) : 2=3D0.01%, 4=3D0.01%, 10=3D0.03%, 20=3D0.01%, 50=3D=
0.01%
> >   cpu          : usr=3D13.55%, sys=3D46.89%, ctx=3D7810, majf=3D0, =
minf=3D6
> >   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0=
%, 32=3D0.0%, >=3D64=3D0.0%
> >      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, 64=3D0.0%, >=3D64=3D0.0%
> >      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, 64=3D0.0%, >=3D64=3D0.0%
> >      issued    : total=3Dr=3D0/w=3D1048576/d=3D0, short=3Dr=3D0/w=3D=
0/d=3D0
> >      latency   : target=3D0, window=3D0, percentile=3D100.00%, dept=
h=3D1
> >=20
> > Seems fine.
> >=20
> >=20
> > But:
> >=20
> > rand-write: (groupid=3D1, jobs=3D1): err=3D 0: pid=3D19243: Sat Dec=
 27 13:48:33 2014
> >   write: io=3D140336KB, bw=3D1018.4KB/s, iops=3D254, runt=3D137803m=
sec
> >     clat (usec): min=3D4, max=3D21299K, avg=3D3708.02, stdev=3D2668=
85.61
> >      lat (usec): min=3D4, max=3D21299K, avg=3D3708.14, stdev=3D2668=
85.61
> >     clat percentiles (usec):
> >      |  1.00th=3D[    4],  5.00th=3D[    5], 10.00th=3D[    5], 20.=
00th=3D[    5],
> >      | 30.00th=3D[    6], 40.00th=3D[    6], 50.00th=3D[    6], 60.=
00th=3D[    6],
> >      | 70.00th=3D[    7], 80.00th=3D[    7], 90.00th=3D[    9], 95.=
00th=3D[   10],
> >      | 99.00th=3D[   18], 99.50th=3D[   19], 99.90th=3D[   28], 99.=
95th=3D[  116],
> >      | 99.99th=3D[16711680]
> >     bw (KB  /s): min=3D    0, max=3D 3426, per=3D100.00%, avg=3D103=
0.10, stdev=3D938.02
> >     lat (usec) : 10=3D92.63%, 20=3D6.89%, 50=3D0.43%, 100=3D0.01%, =
250=3D0.02%
> >     lat (msec) : 250=3D0.01%, 500=3D0.01%, >=3D2000=3D0.02%
> >   cpu          : usr=3D0.06%, sys=3D1.59%, ctx=3D28720, majf=3D0, m=
inf=3D7
> >   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0=
%, 32=3D0.0%, >=3D64=3D0.0%
> >      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, 64=3D0.0%, >=3D64=3D0.0%
> >      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, 64=3D0.0%, >=3D64=3D0.0%
> >      issued    : total=3Dr=3D0/w=3D35084/d=3D0, short=3Dr=3D0/w=3D0=
/d=3D0
> >      latency   : target=3D0, window=3D0, percentile=3D100.00%, dept=
h=3D1
> >=20
> > Run status group 0 (all jobs):
> >   WRITE: io=3D4096.0MB, aggrb=3D343682KB/s, minb=3D343682KB/s, maxb=
=3D343682KB/s, mint=3D12204msec, maxt=3D12204msec
> >=20
> > Run status group 1 (all jobs):
> >   WRITE: io=3D140336KB, aggrb=3D1018KB/s, minb=3D1018KB/s, maxb=3D1=
018KB/s, mint=3D137803msec, maxt=3D137803msec
> >=20
> >=20
> > What? 254 IOPS? With a Dual SSD BTRFS RAID 1?
> >=20
> > What?
> >=20
> > Ey, *what*?
[=E2=80=A6]=20
> > There we go:
> >=20
> > Bug 90401 - btrfs kworker thread uses up 100% of a Sandybridge core=
 for minutes on random write into big file
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D90401
>=20
> I have done more tests.
>=20
> This is on the same /home after extending it to 170 GiB and balancing=
 it to
> btrfs balance start -dusage=3D80
>=20
> It has plenty of free space free. I updated the bug report and hope i=
t can
> give an easy enough to comprehend summary. The new tests are in:
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D90401#c6
>=20
>=20
>=20
> Pasting below for discussion on list. Summary: I easily get 38000 (!)=

> IOPS. It may be an idea to reduce to 160 GiB, but right now this does=

> not work as it says no free space on device when trying to downsize i=
t.
> I may try with 165 or 162GiB.
>=20
> So now we have three IOPS figures:
>=20
> - 256 IOPS in worst case scenario
> - 4700 IOPS when trying to reproduce worst case scenario with a fresh=
 and small
> BTRFS
> - 38000 IOPS when /home has unused device space to allocate chunks fr=
om
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D90401#c8
>=20
>=20
> This is another test.


Okay, and this is the last series of tests for today.

Conclusion:

I cannot manage to get it down to the knees as before, but I come near =
to it.

Still its 8000 IOPS, instead of 250 IOPS, in an according to btrfs fi s=
h
even *worse* situation than before.

That hints me at the need to look at the free space fragmentation, as i=
n the
beginning the problem started appearing with:

merkaba:~> btrfs fi sh /home
Label: 'home'  uuid: [=E2=80=A6]
        Total devices 2 FS bytes used 144.41GiB
        devid    1 size 160.00GiB used 160.00GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 160.00GiB used 160.00GiB path /dev/mapper/sata-=
home

Btrfs v3.17
merkaba:~> btrfs fi df /home
Data, RAID1: total=3D154.97GiB, used=3D141.12GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D5.00GiB, used=3D3.29GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B



Yes, thats 13 GiB of free space *within* the chunks.

So while I can get it down in IOPS by bringing it to a situation where =
it
can not reserve additional data chunks again, I cannot recreate the
abysmal 250 IOPS figure by this. Not even with my /home filesystem.

So there is more to it. I think its important to look into free space
fragmentation. It seems it needs an *aged* filesystem to recreate. At
it seems the balances really helped. As I am not able to recreate the
issue to that extent right now.

So this shows my original idea about free device space to allocate from=

also doesn=C2=B4t explain it fully. It seems to be something thats goin=
g on
within the chunks that explains the worst case <300 IOPS, kworker using=

one core for minutes and desktop locked scenario.

Is there a way to view free space fragmentation in BTRFS?




Test log follows, also added to bug report:

https://bugzilla.kernel.org/show_bug.cgi?id=3D90401#c9


Okay, retesting with=20

merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
So 28. Dez 14:01:05 CET 2014
Label: 'home'  uuid: [=E2=80=A6]
        Total devices 2 FS bytes used 155.15GiB
        devid    1 size 163.00GiB used 159.92GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 163.00GiB used 159.92GiB path /dev/mapper/sata-=
home

Btrfs v3.17
Data, RAID1: total=3D154.95GiB, used=3D151.84GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D4.94GiB, used=3D3.31GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B


Thats is just 3 GiB to reserve new data chunks from from.

First run =E2=80=93 all good:

martin@merkaba:~> fio ssd-test.fio
rand-write: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3D=
sync, iodepth=3D1
fio-2.1.11
Starting 1 process
Jobs: 1 (f=3D1): [w(1)] [100.0% done] [0KB/134.2MB/0KB /s] [0/34.4K/0 i=
ops] [eta 00m:00s]
rand-write: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D10483: Sun Dec 28 =
14:02:59 2014
  write: io=3D4096.0MB, bw=3D218101KB/s, iops=3D54525, runt=3D 19231mse=
c
    clat (usec): min=3D4, max=3D20056, avg=3D14.87, stdev=3D143.15
     lat (usec): min=3D4, max=3D20056, avg=3D15.09, stdev=3D143.26
    clat percentiles (usec):
     |  1.00th=3D[    6],  5.00th=3D[    7], 10.00th=3D[    7], 20.00th=
=3D[    8],
     | 30.00th=3D[    8], 40.00th=3D[   10], 50.00th=3D[   11], 60.00th=
=3D[   12],
     | 70.00th=3D[   13], 80.00th=3D[   14], 90.00th=3D[   15], 95.00th=
=3D[   17],
     | 99.00th=3D[   52], 99.50th=3D[   99], 99.90th=3D[  434], 99.95th=
=3D[  980],
     | 99.99th=3D[ 7968]
    bw (KB  /s): min=3D62600, max=3D424456, per=3D100.00%, avg=3D218821=
.63, stdev=3D93695.28
    lat (usec) : 10=3D38.19%, 20=3D58.83%, 50=3D1.90%, 100=3D0.59%, 250=
=3D0.33%
    lat (usec) : 500=3D0.09%, 750=3D0.03%, 1000=3D0.01%
    lat (msec) : 2=3D0.02%, 4=3D0.01%, 10=3D0.02%, 20=3D0.01%, 50=3D0.0=
1%
  cpu          : usr=3D15.50%, sys=3D61.86%, ctx=3D93432, majf=3D0, min=
f=3D5
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D1048576/d=3D0, short=3Dr=3D0/w=3D0/d=
=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1

Run status group 0 (all jobs):
  WRITE: io=3D4096.0MB, aggrb=3D218101KB/s, minb=3D218101KB/s, maxb=3D2=
18101KB/s, mint=3D19231msec, maxt=3D19231msec




Second run:


merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
So 28. Dez 14:04:01 CET 2014
Label: 'home'  uuid: [=E2=80=A6]
        Total devices 2 FS bytes used 155.23GiB
        devid    1 size 163.00GiB used 160.95GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 163.00GiB used 160.95GiB path /dev/mapper/sata-=
home

Btrfs v3.17
Data, RAID1: total=3D155.98GiB, used=3D151.91GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D4.94GiB, used=3D3.32GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B




martin@merkaba:~> fio ssd-test.fio
rand-write: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3D=
sync, iodepth=3D1
fio-2.1.11
Starting 1 process
Jobs: 1 (f=3D1): [w(1)] [100.0% done] [0KB/171.3MB/0KB /s] [0/43.9K/0 i=
ops] [eta 00m:00s]
rand-write: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D10501: Sun Dec 28 =
14:05:03 2014
  write: io=3D4096.0MB, bw=3D220637KB/s, iops=3D55159, runt=3D 19010mse=
c
    clat (usec): min=3D4, max=3D20578, avg=3D14.45, stdev=3D160.84
     lat (usec): min=3D4, max=3D20578, avg=3D14.65, stdev=3D160.88
    clat percentiles (usec):
     |  1.00th=3D[    6],  5.00th=3D[    7], 10.00th=3D[    7], 20.00th=
=3D[    7],
     | 30.00th=3D[    8], 40.00th=3D[   10], 50.00th=3D[   11], 60.00th=
=3D[   12],
     | 70.00th=3D[   12], 80.00th=3D[   13], 90.00th=3D[   15], 95.00th=
=3D[   17],
     | 99.00th=3D[   42], 99.50th=3D[   79], 99.90th=3D[  278], 99.95th=
=3D[  620],
     | 99.99th=3D[ 9792]
    bw (KB  /s): min=3D    5, max=3D454816, per=3D100.00%, avg=3D224700=
.32, stdev=3D100763.29
    lat (usec) : 10=3D38.15%, 20=3D58.73%, 50=3D2.28%, 100=3D0.47%, 250=
=3D0.26%
    lat (usec) : 500=3D0.06%, 750=3D0.01%, 1000=3D0.01%
    lat (msec) : 2=3D0.01%, 4=3D0.01%, 10=3D0.02%, 20=3D0.01%, 50=3D0.0=
1%
  cpu          : usr=3D15.83%, sys=3D63.17%, ctx=3D74934, majf=3D0, min=
f=3D5
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D1048576/d=3D0, short=3Dr=3D0/w=3D0/d=
=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1

Run status group 0 (all jobs):
  WRITE: io=3D4096.0MB, aggrb=3D220636KB/s, minb=3D220636KB/s, maxb=3D2=
20636KB/s, mint=3D19010msec, maxt=3D19010msec



Okay, now try the same without space for a free chunk to allocate.

The testfile is still there, fio doesn=C2=B4t delete and recreate it on=

every attempt, but just writes into it:

martin@merkaba:~> ls -l ssd.test.file=20
=2Drw-r--r-- 1 martin martin 4294967296 Dez 28 14:05 ssd.test.file


Okay =E2=80=93 with still one chunk to allocate:

merkaba:~> btrfs filesystem resize 1:161G /home
Resize '/home' of '1:161G'
merkaba:~> btrfs filesystem resize 2:161G /home
Resize '/home' of '2:161G'
merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
So 28. Dez 14:08:45 CET 2014
Label: 'home'  uuid: [=E2=80=A6]
        Total devices 2 FS bytes used 155.15GiB
        devid    1 size 161.00GiB used 159.92GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 161.00GiB used 159.92GiB path /dev/mapper/sata-=
home

Btrfs v3.17
Data, RAID1: total=3D154.95GiB, used=3D151.84GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D4.94GiB, used=3D3.31GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B



I would like to have it allocate the chunks by other means, but it free=
s
them eventually afterwards again, so I did it this way.

Note, we still have the original file there. The space it currently
occupies is already taken into account.


Next test:

martin@merkaba:~> fio ssd-test.fio  =20
rand-write: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3D=
sync, iodepth=3D1
fio-2.1.11
Starting 1 process
Jobs: 1 (f=3D1): [w(1)] [100.0% done] [0KB/130.5MB/0KB /s] [0/33.5K/0 i=
ops] [eta 00m:00s]
rand-write: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D10563: Sun Dec 28 =
14:10:34 2014
  write: io=3D4096.0MB, bw=3D210526KB/s, iops=3D52631, runt=3D 19923mse=
c
    clat (usec): min=3D4, max=3D21820, avg=3D14.78, stdev=3D119.40
     lat (usec): min=3D4, max=3D21821, avg=3D15.03, stdev=3D120.26
    clat percentiles (usec):
     |  1.00th=3D[    6],  5.00th=3D[    7], 10.00th=3D[    7], 20.00th=
=3D[    8],
     | 30.00th=3D[    9], 40.00th=3D[   10], 50.00th=3D[   11], 60.00th=
=3D[   11],
     | 70.00th=3D[   12], 80.00th=3D[   13], 90.00th=3D[   14], 95.00th=
=3D[   17],
     | 99.00th=3D[   62], 99.50th=3D[  131], 99.90th=3D[  490], 99.95th=
=3D[  964],
     | 99.99th=3D[ 6816]
    bw (KB  /s): min=3D    3, max=3D410480, per=3D100.00%, avg=3D216892=
.84, stdev=3D95620.33
    lat (usec) : 10=3D33.20%, 20=3D63.71%, 50=3D1.86%, 100=3D0.59%, 250=
=3D0.42%
    lat (usec) : 500=3D0.12%, 750=3D0.03%, 1000=3D0.01%
    lat (msec) : 2=3D0.02%, 4=3D0.01%, 10=3D0.03%, 20=3D0.01%, 50=3D0.0=
1%
  cpu          : usr=3D15.13%, sys=3D62.74%, ctx=3D94346, majf=3D0, min=
f=3D5
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D1048576/d=3D0, short=3Dr=3D0/w=3D0/d=
=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1

Run status group 0 (all jobs):
  WRITE: io=3D4096.0MB, aggrb=3D210525KB/s, minb=3D210525KB/s, maxb=3D2=
10525KB/s, mint=3D19923msec, maxt=3D19923msec


Okay, this is still good.

merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
So 28. Dez 14:11:18 CET 2014
Label: 'home'  uuid: [=E2=80=A6]
        Total devices 2 FS bytes used 155.17GiB
        devid    1 size 161.00GiB used 160.91GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 161.00GiB used 160.91GiB path /dev/mapper/sata-=
home

Btrfs v3.17
Data, RAID1: total=3D155.94GiB, used=3D151.86GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D4.94GiB, used=3D3.30GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B




Now no space left to reserve additional chunks anymore. Another test:


martin@merkaba:~> fio ssd-test.fio
rand-write: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3D=
sync, iodepth=3D1
fio-2.1.11
Starting 1 process
Jobs: 1 (f=3D1): [w(1)] [100.0% done] [0KB/152.3MB/0KB /s] [0/38.1K/0 i=
ops] [eta 00m:00s]
rand-write: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D10580: Sun Dec 28 =
14:13:26 2014
  write: io=3D4096.0MB, bw=3D225804KB/s, iops=3D56450, runt=3D 18575mse=
c
    clat (usec): min=3D4, max=3D16669, avg=3D13.66, stdev=3D72.88
     lat (usec): min=3D4, max=3D16669, avg=3D13.89, stdev=3D73.06
    clat percentiles (usec):
     |  1.00th=3D[    6],  5.00th=3D[    7], 10.00th=3D[    7], 20.00th=
=3D[    8],
     | 30.00th=3D[    8], 40.00th=3D[   10], 50.00th=3D[   11], 60.00th=
=3D[   12],
     | 70.00th=3D[   13], 80.00th=3D[   14], 90.00th=3D[   15], 95.00th=
=3D[   20],
     | 99.00th=3D[   65], 99.50th=3D[  113], 99.90th=3D[  314], 99.95th=
=3D[  506],
     | 99.99th=3D[ 2768]
    bw (KB  /s): min=3D    4, max=3D444568, per=3D100.00%, avg=3D231326=
.97, stdev=3D93374.31
    lat (usec) : 10=3D36.50%, 20=3D58.44%, 50=3D3.73%, 100=3D0.76%, 250=
=3D0.44%
    lat (usec) : 500=3D0.09%, 750=3D0.02%, 1000=3D0.01%
    lat (msec) : 2=3D0.01%, 4=3D0.01%, 10=3D0.01%, 20=3D0.01%
  cpu          : usr=3D16.35%, sys=3D68.39%, ctx=3D127221, majf=3D0, mi=
nf=3D5
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D1048576/d=3D0, short=3Dr=3D0/w=3D0/d=
=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1

Run status group 0 (all jobs):
  WRITE: io=3D4096.0MB, aggrb=3D225803KB/s, minb=3D225803KB/s, maxb=3D2=
25803KB/s, mint=3D18575msec, maxt=3D18575msec



Okay, this still does not trigger it.


Another test, it even freed some chunk:

merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
So 28. Dez 14:14:21 CET 2014
Label: 'home'  uuid: [=E2=80=A6]
        Total devices 2 FS bytes used 155.28GiB
        devid    1 size 161.00GiB used 160.85GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 161.00GiB used 160.85GiB path /dev/mapper/sata-=
home

Btrfs v3.17
Data, RAID1: total=3D155.89GiB, used=3D151.97GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D4.94GiB, used=3D3.31GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B



Still good:

martin@merkaba:~> fio ssd-test.fio
rand-write: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3D=
sync, iodepth=3D1
fio-2.1.11
Starting 1 process
Jobs: 1 (f=3D1): [w(1)] [100.0% done] [0KB/156.5MB/0KB /s] [0/40.6K/0 i=
ops] [eta 00m:00s]
rand-write: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D10589: Sun Dec 28 =
14:14:37 2014
  write: io=3D4096.0MB, bw=3D161121KB/s, iops=3D40280, runt=3D 26032mse=
c
    clat (usec): min=3D4, max=3D1228.9K, avg=3D15.69, stdev=3D1205.88
     lat (usec): min=3D4, max=3D1228.9K, avg=3D15.92, stdev=3D1205.90
    clat percentiles (usec):
     |  1.00th=3D[    6],  5.00th=3D[    7], 10.00th=3D[    7], 20.00th=
=3D[    8],
     | 30.00th=3D[    8], 40.00th=3D[   10], 50.00th=3D[   11], 60.00th=
=3D[   12],
     | 70.00th=3D[   13], 80.00th=3D[   14], 90.00th=3D[   15], 95.00th=
=3D[   19],
     | 99.00th=3D[   53], 99.50th=3D[   96], 99.90th=3D[  366], 99.95th=
=3D[  764],
     | 99.99th=3D[ 7776]
    bw (KB  /s): min=3D    0, max=3D431680, per=3D100.00%, avg=3D219856=
.30, stdev=3D98172.64
    lat (usec) : 10=3D39.24%, 20=3D55.83%, 50=3D3.81%, 100=3D0.63%, 250=
=3D0.33%
    lat (usec) : 500=3D0.08%, 750=3D0.02%, 1000=3D0.01%
    lat (msec) : 2=3D0.01%, 4=3D0.01%, 10=3D0.02%, 20=3D0.01%, 2000=3D0=
.01%
  cpu          : usr=3D11.50%, sys=3D61.08%, ctx=3D123428, majf=3D0, mi=
nf=3D6
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D1048576/d=3D0, short=3Dr=3D0/w=3D0/d=
=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1

Run status group 0 (all jobs):
  WRITE: io=3D4096.0MB, aggrb=3D161121KB/s, minb=3D161121KB/s, maxb=3D1=
61121KB/s, mint=3D26032msec, maxt=3D26032msec



Okay, lets allocate one GiB with fallocate to make free space tighter:

martin@merkaba:~> /usr/bin/time fallocate -l 1G 1g-1
0.00user 0.09system 0:00.11elapsed 86%CPU (0avgtext+0avgdata 1752maxres=
ident)k
112inputs+64outputs (1major+89minor)pagefaults 0swaps
martin@merkaba:~> ls -lh 1g-1
=2Drw-r--r-- 1 martin martin 1,0G Dez 28 14:16 1g


merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
So 28. Dez 14:16:24 CET 2014
Label: 'home'  uuid: [=E2=80=A6]
        Total devices 2 FS bytes used 156.15GiB
        devid    1 size 161.00GiB used 160.94GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 161.00GiB used 160.94GiB path /dev/mapper/sata-=
home

Btrfs v3.17
Data, RAID1: total=3D155.97GiB, used=3D152.84GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D4.94GiB, used=3D3.31GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B


Still not:

martin@merkaba:~> fio ssd-test.fio                 =20
rand-write: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3D=
sync, iodepth=3D1
fio-2.1.11
Starting 1 process
Jobs: 1 (f=3D1): [w(1)] [100.0% done] [0KB/132.1MB/0KB /s] [0/34.4K/0 i=
ops] [eta 00m:00s]
rand-write: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D10632: Sun Dec 28 =
14:17:12 2014
  write: io=3D4096.0MB, bw=3D198773KB/s, iops=3D49693, runt=3D 21101mse=
c
    clat (usec): min=3D4, max=3D543255, avg=3D16.27, stdev=3D563.85
     lat (usec): min=3D4, max=3D543255, avg=3D16.48, stdev=3D563.91
    clat percentiles (usec):
     |  1.00th=3D[    6],  5.00th=3D[    7], 10.00th=3D[    7], 20.00th=
=3D[    8],
     | 30.00th=3D[    9], 40.00th=3D[   10], 50.00th=3D[   11], 60.00th=
=3D[   12],
     | 70.00th=3D[   12], 80.00th=3D[   13], 90.00th=3D[   14], 95.00th=
=3D[   17],
     | 99.00th=3D[   49], 99.50th=3D[   98], 99.90th=3D[  386], 99.95th=
=3D[  828],
     | 99.99th=3D[10816]
    bw (KB  /s): min=3D    4, max=3D444848, per=3D100.00%, avg=3D203909=
.07, stdev=3D109502.11
    lat (usec) : 10=3D33.97%, 20=3D62.99%, 50=3D2.05%, 100=3D0.51%, 250=
=3D0.33%
    lat (usec) : 500=3D0.08%, 750=3D0.02%, 1000=3D0.01%
    lat (msec) : 2=3D0.01%, 4=3D0.01%, 10=3D0.02%, 20=3D0.01%, 750=3D0.=
01%
  cpu          : usr=3D14.21%, sys=3D60.44%, ctx=3D70273, majf=3D0, min=
f=3D6
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D1048576/d=3D0, short=3Dr=3D0/w=3D0/d=
=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1

Run status group 0 (all jobs):
  WRITE: io=3D4096.0MB, aggrb=3D198772KB/s, minb=3D198772KB/s, maxb=3D1=
98772KB/s, mint=3D21101msec, maxt=3D21101msec




Another 1G file.

Got it:

ATOP - merkaba                       2014/12/28  14:18:14              =
         -----------                        10s elapsed
PRC | sys   21.74s | user   2.48s | #proc    382 | #trun      8 |  #tsl=
pi   698 | #tslpu     1 | #zombie    0 | no  procacct |
CPU | sys     218% | user     24% | irq       1% | idle    155% |  wait=
      2% | guest     0% | curf 3.00GHz | curscal  93% |
cpu | sys      75% | user      5% | irq       0% | idle     19% |  cpu0=
03 w  0% | guest     0% | curf 3.00GHz | curscal  93% |
cpu | sys      59% | user      3% | irq       0% | idle     37% |  cpu0=
01 w  0% | guest     0% | curf 3.00GHz | curscal  93% |
cpu | sys      48% | user      6% | irq       1% | idle     45% |  cpu0=
00 w  1% | guest     0% | curf 3.00GHz | curscal  93% |
cpu | sys      36% | user      9% | irq       0% | idle     54% |  cpu0=
02 w  1% | guest     0% | curf 3.00GHz | curscal  93% |
CPL | avg1    2.13 | avg5    2.37 | avg15   1.92 |              |  csw =
   67473 | intr   59152 |              | numcpu     4 |
MEM | tot    15.5G | free    1.1G | cache  11.0G | buff    0.1M |  slab=
  740.2M | shmem 190.9M | vmbal   0.0M | hptot   0.0M |
SWP | tot    12.0G | free   11.4G |              |              |      =
         |              | vmcom   5.4G | vmlim  19.7G |
PAG | scan       0 | steal      0 | stall      1 |              |      =
         |              | swin      19 | swout      0 |
LVM |    sata-home | busy      8% | read       4 | write  26062 |  KiB/=
w      3 | MBr/s   0.00 | MBw/s  10.18 | avio 0.03 ms |
LVM |   msata-home | busy      5% | read       4 | write  26062 |  KiB/=
w      3 | MBr/s   0.00 | MBw/s  10.18 | avio 0.02 ms |
LVM |    sata-swap | busy      0% | read      19 | write      0 |  KiB/=
w      0 | MBr/s   0.01 | MBw/s   0.00 | avio 0.05 ms |
LVM | msata-debian | busy      0% | read       0 | write      4 |  KiB/=
w      4 | MBr/s   0.00 | MBw/s   0.00 | avio 0.00 ms |
LVM |  sata-debian | busy      0% | read       0 | write      4 |  KiB/=
w      4 | MBr/s   0.00 | MBw/s   0.00 | avio 0.00 ms |
DSK |          sda | busy      8% | read      23 | write  13239 |  KiB/=
w      7 | MBr/s   0.01 | MBw/s  10.18 | avio 0.06 ms |
DSK |          sdb | busy      5% | read       4 | write  14360 |  KiB/=
w      7 | MBr/s   0.00 | MBw/s  10.18 | avio 0.04 ms |
NET | transport    | tcpi      18 | tcpo      18 | udpi       0 |  udpo=
       0 | tcpao      1 | tcppo      1 | tcprs      0 |
NET | network      | ipi       18 | ipo       18 | ipfrw      0 |  deli=
v     18 |              | icmpi      0 | icmpo      0 |
NET | eth0      0% | pcki       2 | pcko       2 | si    0 Kbps |  so  =
  0 Kbps | erri       0 | erro       0 | drpo       0 |
NET | lo      ---- | pcki      16 | pcko      16 | si    2 Kbps |  so  =
  2 Kbps | erri       0 | erro       0 | drpo       0 |

  PID   TID  RUID      EUID       THR  SYSCPU  USRCPU   VGROW   RGROW  =
 RDDSK   WRDSK  ST  EXC  S  CPUNR   CPU  CMD        1/5
10657     -  martin    martin       1   9.88s   0.00s      0K      0K  =
    0K     48K  --    -  R      1   99%  fallocate
 9685     -  root      root         1   9.84s   0.00s      0K      0K  =
    0K      0K  --    -  D      0   99%  kworker/u8:10



martin@merkaba:~> /usr/bin/time fallocate -l 1G 1g-2 ; ls -l 1g*
0.00user 59.28system 1:00.21elapsed 98%CPU (0avgtext+0avgdata 1756maxre=
sident)k
0inputs+416outputs (0major+90minor)pagefaults 0swaps
=2Drw-r--r-- 1 martin martin 1073741824 Dez 28 14:16 1g-1
=2Drw-r--r-- 1 martin martin 1073741824 Dez 28 14:17 1g-2


One minute in system CPU for this.



Okay, so now another test:

merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
So 28. Dez 14:19:30 CET 2014
Label: 'home'  uuid: [=E2=80=A6]
        Total devices 2 FS bytes used 157.18GiB
        devid    1 size 161.00GiB used 160.91GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 161.00GiB used 160.91GiB path /dev/mapper/sata-=
home

Btrfs v3.17
Data, RAID1: total=3D155.94GiB, used=3D153.87GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D4.94GiB, used=3D3.30GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B



I admit, this now really isn=C2=B4t nice to it anymore, but I want to s=
ee
where it starts to become an issue.



ATOP - merkaba                                  2014/12/28  14:21:18   =
                               -----------                             =
     1s elapsed
PRC | sys    1.15s | user   0.16s | #proc    382  | #trun      2 | #tsl=
pi   707 | #tslpu     1 | #zombie    0 | clones     0  |              |=
 no  procacct |
CPU | sys     163% | user     24% | irq       1%  | idle    189% | wait=
     26% |              | steal     0% | guest     0%  | curf 3.01GHz |=
 curscal  94% |
cpu | sys      72% | user      1% | irq       0%  | idle     25% | cpu0=
01 w  1% |              | steal     0% | guest     0%  | curf 3.00GHz |=
 curscal  93% |
cpu | sys      41% | user      9% | irq       0%  | idle     32% | cpu0=
02 w 19% |              | steal     0% | guest     0%  | curf 3.00GHz |=
 curscal  93% |
cpu | sys      34% | user     10% | irq       0%  | idle     53% | cpu0=
03 w  3% |              | steal     0% | guest     0%  | curf 3.03GHz |=
 curscal  94% |
cpu | sys      16% | user      4% | irq       0%  | idle     77% | cpu0=
00 w  3% |              | steal     0% | guest     0%  | curf 3.00GHz |=
 curscal  93% |
CPL | avg1    2.37 | avg5    2.64 | avg15   2.13  |              |     =
         | csw    18687 | intr   12435 |               |              |=
 numcpu     4 |
MEM | tot    15.5G | free    2.5G | cache   9.5G  | buff    0.1M | slab=
  742.6M | shmem 242.8M | shrss 115.5M | vmbal   0.0M  | hptot   0.0M |=
 hpuse   0.0M |
SWP | tot    12.0G | free   11.4G |               |              |     =
         |              |              |               | vmcom   5.5G |=
 vmlim  19.7G |
LVM |   msata-home | busy     71% | read      28  | write   8134 | KiB/=
r      4 | KiB/w      3 | MBr/s   0.11 | MBw/s  31.68  | avq    13.21 |=
 avio 0.06 ms |
LVM |    sata-home | busy     40% | read      72  | write   8135 | KiB/=
r      4 | KiB/w      3 | MBr/s   0.28 | MBw/s  31.69  | avq    41.67 |=
 avio 0.03 ms |
DSK |          sdb | busy     71% | read      24  | write   6049 | KiB/=
r      4 | KiB/w      5 | MBr/s   0.11 | MBw/s  31.68  | avq     5.64 |=
 avio 0.08 ms |
DSK |          sda | busy     38% | read      60  | write   5987 | KiB/=
r      4 | KiB/w      5 | MBr/s   0.28 | MBw/s  31.69  | avq    20.40 |=
 avio 0.04 ms |
NET | transport    | tcpi      16 | tcpo      16  | udpi       0 | udpo=
       0 | tcpao      1 | tcppo      1 | tcprs      0  | tcpie      0 |=
 udpie      0 |
NET | network      | ipi       16 | ipo       16  | ipfrw      0 | deli=
v     16 |              |              |               | icmpi      0 |=
 icmpo      0 |
NET | lo      ---- | pcki      16 | pcko      16  | si   20 Kbps | so  =
 20 Kbps | coll       0 | erri       0 | erro       0  | drpi       0 |=
 drpo       0 |

  PID     TID    RUID        EUID         THR    SYSCPU    USRCPU     V=
GROW     RGROW    RDDSK     WRDSK    ST    EXC    S    CPUNR     CPU   =
 CMD        1/2
10459       -    root        root           1     0.70s     0.00s      =
  0K        0K       0K        0K    --      -    D        3    100%   =
 kworker/u8:17
10674       -    martin      martin         1     0.20s     0.01s      =
  0K        0K       0K    27504K    --      -    R        0     30%   =
 fio



Okay.

It is jumping between 0 IOPS and 40000 IOPS and hogging 100% with one k=
worker.



Still quite okay in terms of IOPS tough:

martin@merkaba:~> fio ssd-test.fio                             =20
rand-write: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3D=
sync, iodepth=3D1
fio-2.1.11
Starting 1 process
Jobs: 1 (f=3D1): [w(1)] [100.0% done] [0KB/126.8MB/0KB /s] [0/32.5K/0 i=
ops] [eta 00m:00s]
rand-write: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D10674: Sun Dec 28 =
14:22:16 2014
  write: io=3D3801.3MB, bw=3D32415KB/s, iops=3D8103, runt=3D120083msec
    clat (usec): min=3D4, max=3D1809.9K, avg=3D83.88, stdev=3D3615.98
     lat (usec): min=3D4, max=3D1809.9K, avg=3D84.10, stdev=3D3616.00
    clat percentiles (usec):
     |  1.00th=3D[    6],  5.00th=3D[    7], 10.00th=3D[    7], 20.00th=
=3D[    8],
     | 30.00th=3D[    9], 40.00th=3D[   10], 50.00th=3D[   11], 60.00th=
=3D[   11],
     | 70.00th=3D[   12], 80.00th=3D[   13], 90.00th=3D[   15], 95.00th=
=3D[   18],
     | 99.00th=3D[   52], 99.50th=3D[  124], 99.90th=3D[24704], 99.95th=
=3D[30592],
     | 99.99th=3D[57088]
    bw (KB  /s): min=3D    0, max=3D417544, per=3D100.00%, avg=3D48302.=
16, stdev=3D89108.07
    lat (usec) : 10=3D35.61%, 20=3D60.17%, 50=3D3.17%, 100=3D0.47%, 250=
=3D0.27%
    lat (usec) : 500=3D0.05%, 750=3D0.02%, 1000=3D0.01%
    lat (msec) : 2=3D0.01%, 4=3D0.01%, 10=3D0.01%, 20=3D0.04%, 50=3D0.1=
6%
    lat (msec) : 100=3D0.01%, 250=3D0.01%, 500=3D0.01%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D2.37%, sys=3D29.74%, ctx=3D202984, majf=3D0, min=
f=3D6
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D973128/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1

Run status group 0 (all jobs):
  WRITE: io=3D3801.3MB, aggrb=3D32415KB/s, minb=3D32415KB/s, maxb=3D324=
15KB/s, mint=3D120083msec, maxt=3D120083msec



I stop this here now.


Its interesting to see that even with:

merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
So 28. Dez 14:23:11 CET 2014
Label: 'home'  uuid: [=E2=80=A6]
        Total devices 2 FS bytes used 157.89GiB
        devid    1 size 161.00GiB used 160.91GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 161.00GiB used 160.91GiB path /dev/mapper/sata-=
home

Btrfs v3.17
Data, RAID1: total=3D155.94GiB, used=3D154.59GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D4.94GiB, used=3D3.30GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

I am not able to fully reproduce it.


I can partly reproduce it, but it behaves way better than before.



I think to go further one needs to have a look at the free space
fragmentation inside the chunks.

As in the beginning I had:

I have this on 3.18 kernel on Debian Sid with BTRFS Dual SSD RAID with
space_cache, skinny meta data extents =E2=80=93 are these a problem? =E2=
=80=93 and
compress=3Dlzo:

merkaba:~> btrfs fi sh /home
Label: 'home'  uuid: [=E2=80=A6]
        Total devices 2 FS bytes used 144.41GiB
        devid    1 size 160.00GiB used 160.00GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 160.00GiB used 160.00GiB path /dev/mapper/sata-=
home

Btrfs v3.17
merkaba:~> btrfs fi df /home
Data, RAID1: total=3D154.97GiB, used=3D141.12GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D5.00GiB, used=3D3.29GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B



So I had quite some free space *within* the chunks and it still was a
problem.










=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart2377056.MHhWEGL6Fq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlSgCFUACgkQmRvqrKWZhMeUZACfbeJnwvbH7X2izgqiLT1syI4Q
PfoAn0g/hl+X7SJCw0O/hua252D70AMo
=RYrg
-----END PGP SIGNATURE-----

--nextPart2377056.MHhWEGL6Fq--

