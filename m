Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35277 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaL1NAb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Dec 2014 08:00:31 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Robert White <rwhite@pobox.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again (further tests)
Date: Sun, 28 Dec 2014 14:00:19 +0100
Message-ID: <1930625.5Z83nuS5i9@merkaba>
In-Reply-To: <2235526.D1sZ4Blnlh@merkaba>
References: <3738341.y7uRQFcLJH@merkaba> <20141227093043.GJ25267@carfax.org.uk> <2235526.D1sZ4Blnlh@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2970848.2f8U433XaG"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2970848.2f8U433XaG
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Samstag, 27. Dezember 2014, 14:55:58 schrieb Martin Steigerwald:
> Summarized at
>=20
> Bug 90401 - btrfs kworker thread uses up 100% of a Sandybridge core f=
or minutes on random write into big file
> https://bugzilla.kernel.org/show_bug.cgi?id=3D90401
>=20
> see below. This is reproducable with fio, no need for Windows XP in
> Virtualbox for reproducing the issue. Next I will try to reproduce wi=
th
> a freshly creating filesystem.
>=20
>=20
> Am Samstag, 27. Dezember 2014, 09:30:43 schrieb Hugo Mills:
> > On Sat, Dec 27, 2014 at 10:01:17AM +0100, Martin Steigerwald wrote:=

> > > Am Freitag, 26. Dezember 2014, 14:48:38 schrieb Robert White:
> > > > On 12/26/2014 05:37 AM, Martin Steigerwald wrote:
> > > > > Hello!
> > > > >=20
> > > > > First: Have a merry christmas and enjoy a quiet time in these=
 days.
> > > > >=20
> > > > > Second: At a time you feel like it, here is a little rant, bu=
t also a
> > > > > bug
> > > > > report:
> > > > >=20
> > > > > I have this on 3.18 kernel on Debian Sid with BTRFS Dual SSD =
RAID with
> > > > > space_cache, skinny meta data extents =E2=80=93 are these a p=
roblem? =E2=80=93 and
> > > >=20
> > > > > compress=3Dlzo:
> > > > (there is no known problem with skinny metadata, it's actually =
more
> > > > efficient than the older format. There has been some anecdotes =
about
> > > > mixing the skinny and fat metadata but nothing has ever been
> > > > demonstrated problematic.)
> > > >=20
> > > > > merkaba:~> btrfs fi sh /home
> > > > > Label: 'home'  uuid: b96c4f72-0523-45ac-a401-f7be73dd624a
> > > > >=20
> > > > >          Total devices 2 FS bytes used 144.41GiB
> > > > >          devid    1 size 160.00GiB used 160.00GiB path
> > > > >          /dev/mapper/msata-home
> > > > >          devid    2 size 160.00GiB used 160.00GiB path
> > > > >          /dev/mapper/sata-home
> > > > >=20
> > > > > Btrfs v3.17
> > > > > merkaba:~> btrfs fi df /home
> > > > > Data, RAID1: total=3D154.97GiB, used=3D141.12GiB
> > > > > System, RAID1: total=3D32.00MiB, used=3D48.00KiB
> > > > > Metadata, RAID1: total=3D5.00GiB, used=3D3.29GiB
> > > > > GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
> > > >=20
> > > > This filesystem, at the allocation level, is "very full" (see b=
elow).
> > > >=20
> > > > > And I had hangs with BTRFS again. This time as I wanted to in=
stall tax
> > > > > return software in Virtualbox=C2=B4d Windows XP VM (which I u=
se once a year
> > > > > cause I know no tax return software for Linux which would be =
suitable
> > > > > for
> > > > > Germany and I frankly don=C2=B4t care about the end of securi=
ty cause all
> > > > > surfing and other network access I will do from the Linux box=
 and I
> > > > > only
> > > > > run the VM behind a firewall).
> > > >=20
> > > > > And thus I try the balance dance again:
> > > > ITEM: Balance... it doesn't do what you think it does... 8-)
> > > >=20
> > > > "Balancing" is something you should almost never need to do. It=
 is only
> > > > for cases of changing geometry (adding disks, switching RAID le=
vels,
> > > > etc.) of for cases when you've radically changed allocation beh=
aviors
> > > > (like you decided to remove all your VM's or you've decided to =
remove a
> > > > mail spool directory full of thousands of tiny files).
> > > >=20
> > > > People run balance all the time because they think they should.=
 They are
> > > > _usually_ incorrect in that belief.
> > >=20
> > > I only see the lockups of BTRFS is the trees *occupy* all space o=
n the
> > > device.
> >    No, "the trees" occupy 3.29 GiB of your 5 GiB of mirrored metada=
ta
> > space. What's more, balance does *not* balance the metadata trees. =
The
> > remaining space -- 154.97 GiB -- is unstructured storage for file
> > data, and you have some 13 GiB of that available for use.
> >=20
> >    Now, since you're seeing lockups when the space on your disks is=

> > all allocated I'd say that's a bug. However, you're the *only* pers=
on
> > who's reported this as a regular occurrence. Does this happen with =
all
> > filesystems you have, or just this one?
> >=20
> > > I *never* so far saw it lockup if there is still space BTRFS can =
allocate
> > > from to *extend* a tree.
> >=20
> >    It's not a tree. It's simply space allocation. It's not even spa=
ce
> > *usage* you're talking about here -- it's just allocation (i.e. the=
 FS
> > saying "I'm going to use this piece of disk for this purpose").
> >=20
> > > This may be a bug, but this is what I see.
> > >=20
> > > And no amount of "you should not balance a BTRFS" will make that
> > > perception go away.
> > >=20
> > > See, I see the sun coming out on a morning and you tell me "no, i=
t
> > > doesn=C2=B4t". Simply that is not going to match my perception.
> >=20
> >    Duncan's assertion is correct in its detail. Looking at your spa=
ce
>=20
> Robert's :)
>=20
> > usage, I would not suggest that running a balance is something you
> > need to do. Now, since you have these lockups that seem quite
> > repeatable, there's probably a lurking bug in there, but hacking
> > around with balance every time you hit it isn't going to get the
> > problem solved properly.
> >=20
> >    I think I would suggest the following:
> >=20
> >  - make sure you have some way of logging your dmesg permanently (u=
se
> >    a different filesystem for /var/log, or a serial console, or a
> >    netconsole)
> >=20
> >  - when the lockup happens, hit Alt-SysRq-t a few times
> >=20
> >  - send the dmesg output here, or post to bugzilla.kernel.org
> >=20
> >    That's probably going to give enough information to the develope=
rs
> > to work out where the lockup is happening, and is clearly the way
> > forward here.
>=20
> And I got it reproduced. *Perfectly* reproduced, I=C2=B4d say.
>=20
> But let me run the whole story:
>=20
> 1) I downsized my /home BTRFS from dual 170 GiB to dual 160 GiB again=
.

[=E2=80=A6 story of trying to reproduce with Windows XP defragmenting w=
hich was
unsuccessful as BTRFS still had free device space to allocate new chunk=
s
from=20=E2=80=A6]

> But finally I got to:
>=20
> merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
> Sa 27. Dez 13:26:39 CET 2014
> Label: 'home'  uuid: [some UUID]
>         Total devices 2 FS bytes used 152.83GiB
>         devid    1 size 160.00GiB used 160.00GiB path /dev/mapper/msa=
ta-home
>         devid    2 size 160.00GiB used 160.00GiB path /dev/mapper/sat=
a-home
>=20
> Btrfs v3.17
> Data, RAID1: total=3D154.97GiB, used=3D149.58GiB
> System, RAID1: total=3D32.00MiB, used=3D48.00KiB
> Metadata, RAID1: total=3D5.00GiB, used=3D3.26GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
>=20
>=20
> So I did, if Virtualbox can write randomly in a file, I can too.
>=20
> So I did:
>=20
>=20
> martin@merkaba:~> cat ssd-test.fio=20
> [global]
> bs=3D4k
> #ioengine=3Dlibaio
> #iodepth=3D4
> size=3D4g
> #direct=3D1
> runtime=3D120
> filename=3Dssd.test.file
>=20
> [seq-write]
> rw=3Dwrite
> stonewall
>=20
> [rand-write]
> rw=3Drandwrite
> stonewall
>=20
>=20
>=20
> And got:
>=20
> ATOP - merkaba                          2014/12/27  13:41:02         =
                 -----------                           10s elapsed
> PRC |  sys   10.14s |  user   0.38s |  #proc    332  | #trun      2  =
|  #tslpi   548 |  #tslpu     0 |  #zombie    0  | no  procacct  |
> CPU |  sys     102% |  user      4% |  irq       0%  | idle    295%  =
|  wait      0% |  guest     0% |  curf 3.10GHz  | curscal  96%  |
> cpu |  sys      76% |  user      0% |  irq       0%  | idle     24%  =
|  cpu001 w  0% |  guest     0% |  curf 3.20GHz  | curscal  99%  |
> cpu |  sys      24% |  user      1% |  irq       0%  | idle     75%  =
|  cpu000 w  0% |  guest     0% |  curf 3.19GHz  | curscal  99%  |
> cpu |  sys       1% |  user      1% |  irq       0%  | idle     98%  =
|  cpu002 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys       1% |  user      1% |  irq       0%  | idle     98%  =
|  cpu003 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> CPL |  avg1    0.82 |  avg5    0.78 |  avg15   0.99  |               =
|  csw     6233 |  intr   12023 |                | numcpu     4  |
> MEM |  tot    15.5G |  free    4.0G |  cache   9.7G  | buff    0.0M  =
|  slab  333.1M |  shmem 206.6M |  vmbal   0.0M  | hptot   0.0M  |
> SWP |  tot    12.0G |  free   11.7G |                |               =
|               |               |  vmcom   3.4G  | vmlim  19.7G  |
> LVM |     sata-home |  busy      0% |  read       8  | write      0  =
|  KiB/w      0 |  MBr/s   0.00 |  MBw/s   0.00  | avio 0.12 ms  |
> DSK |           sda |  busy      0% |  read       8  | write      0  =
|  KiB/w      0 |  MBr/s   0.00 |  MBw/s   0.00  | avio 0.12 ms  |
> NET |  transport    |  tcpi      16 |  tcpo      16  | udpi       0  =
|  udpo       0 |  tcpao      1 |  tcppo      1  | tcprs      0  |
> NET |  network      |  ipi       16 |  ipo       16  | ipfrw      0  =
|  deliv     16 |               |  icmpi      0  | icmpo      0  |
> NET |  lo      ---- |  pcki      16 |  pcko      16  | si    2 Kbps  =
|  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
>=20
>   PID    TID   RUID      EUID        THR  SYSCPU   USRCPU   VGROW    =
RGROW   RDDSK    WRDSK  ST   EXC  S   CPUNR   CPU   CMD        1/2
> 18079      -   martin    martin        2   9.99s    0.00s      0K    =
   0K      0K      16K  --     -  R       1  100%   fio
>  4746      -   martin    martin        2   0.01s    0.14s      0K    =
   0K      0K       0K  --     -  S       2    2%   konsole
>  3291      -   martin    martin        4   0.01s    0.11s      0K    =
   0K      0K       0K  --     -  S       0    1%   plasma-desktop
>  1488      -   root      root          1   0.03s    0.04s      0K    =
   0K      0K       0K  --     -  S       0    1%   Xorg
> 10036      -   root      root          1   0.04s    0.02s      0K    =
   0K      0K       0K  --     -  R       2    1%   atop
>=20
> while fio was just *laying* out the 4 GiB file. Yes, thats 100% syste=
m CPU
> for 10 seconds while allocatiing a 4 GiB file on a filesystem like:
>=20
> martin@merkaba:~> LANG=3DC df -hT /home
> Filesystem             Type   Size  Used Avail Use% Mounted on
> /dev/mapper/msata-home btrfs  170G  156G   17G  91% /home
>=20
> where a 4 GiB file should easily fit, no? (And this output is with th=
e 4
> GiB file. So it was even 4 GiB more free before.)
>=20
>=20
> But it gets even more visible:
>=20
> martin@merkaba:~> fio ssd-test.fio
> seq-write: (g=3D0): rw=3Dwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dsy=
nc, iodepth=3D1
> rand-write: (g=3D1): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=
=3Dsync, iodepth=3D1
> fio-2.1.11
> Starting 2 processes
> Jobs: 1 (f=3D1): [_(1),w(1)] [19.3% done] [0KB/0KB/0KB /s] [0/0/0 iop=
s] [eta 01m:57s]      =20
> 0$ zsh  1$ zsh  2$ zsh  3-$ zsh  4$ zsh  5$* zsh                     =
             =20
>=20
>=20
> yes, thats 0 IOPS.
>=20
> 0 IOPS and in zero IOPS. For minutes.
>=20
>=20
>=20
> And here is why:
>=20
> ATOP - merkaba                          2014/12/27  13:46:52         =
                 -----------                           10s elapsed
> PRC |  sys   10.77s |  user   0.31s |  #proc    334  | #trun      2  =
|  #tslpi   548 |  #tslpu     3 |  #zombie    0  | no  procacct  |
> CPU |  sys     108% |  user      3% |  irq       0%  | idle    286%  =
|  wait      2% |  guest     0% |  curf 3.08GHz  | curscal  96%  |
> cpu |  sys      72% |  user      1% |  irq       0%  | idle     28%  =
|  cpu000 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys      19% |  user      0% |  irq       0%  | idle     81%  =
|  cpu001 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys      11% |  user      1% |  irq       0%  | idle     87%  =
|  cpu003 w  1% |  guest     0% |  curf 3.19GHz  | curscal  99%  |
> cpu |  sys       6% |  user      1% |  irq       0%  | idle     91%  =
|  cpu002 w  1% |  guest     0% |  curf 3.11GHz  | curscal  97%  |
> CPL |  avg1    2.78 |  avg5    1.34 |  avg15   1.12  |               =
|  csw    50192 |  intr   32379 |                | numcpu     4  |
> MEM |  tot    15.5G |  free    5.0G |  cache   8.7G  | buff    0.0M  =
|  slab  332.6M |  shmem 207.2M |  vmbal   0.0M  | hptot   0.0M  |
> SWP |  tot    12.0G |  free   11.7G |                |               =
|               |               |  vmcom   3.4G  | vmlim  19.7G  |
> LVM |     sata-home |  busy      5% |  read     160  | write  11177  =
|  KiB/w      3 |  MBr/s   0.06 |  MBw/s   4.36  | avio 0.05 ms  |
> LVM |    msata-home |  busy      4% |  read      28  | write  11177  =
|  KiB/w      3 |  MBr/s   0.01 |  MBw/s   4.36  | avio 0.04 ms  |
> LVM |   sata-debian |  busy      0% |  read       0  | write    844  =
|  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.33  | avio 0.02 ms  |
> LVM |  msata-debian |  busy      0% |  read       0  | write    844  =
|  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.33  | avio 0.02 ms  |
> DSK |           sda |  busy      5% |  read     160  | write  10200  =
|  KiB/w      4 |  MBr/s   0.06 |  MBw/s   4.69  | avio 0.05 ms  |
> DSK |           sdb |  busy      4% |  read      28  | write  10558  =
|  KiB/w      4 |  MBr/s   0.01 |  MBw/s   4.69  | avio 0.04 ms  |
> NET |  transport    |  tcpi      35 |  tcpo      33  | udpi       3  =
|  udpo       3 |  tcpao      2 |  tcppo      1  | tcprs      0  |
> NET |  network      |  ipi       38 |  ipo       36  | ipfrw      0  =
|  deliv     38 |               |  icmpi      0  | icmpo      0  |
> NET |  eth0      0% |  pcki      22 |  pcko      20  | si    9 Kbps  =
|  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
> NET |  lo      ---- |  pcki      16 |  pcko      16  | si    2 Kbps  =
|  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
>=20
>   PID    TID   RUID      EUID        THR  SYSCPU   USRCPU   VGROW    =
RGROW   RDDSK    WRDSK  ST   EXC  S   CPUNR   CPU   CMD        1/3
> 14973      -   root      root          1   8.92s    0.00s      0K    =
   0K      0K     144K  --     -  S       0   89%   kworker/u8:14
> 17450      -   root      root          1   0.86s    0.00s      0K    =
   0K      0K      32K  --     -  R       3    9%   kworker/u8:5
>   788      -   root      root          1   0.25s    0.00s      0K    =
   0K    128K   18880K  --     -  S       3    3%   btrfs-transact
> 12254      -   root      root          1   0.14s    0.00s      0K    =
   0K     64K     576K  --     -  S       2    1%   kworker/u8:3
> 17332      -   root      root          1   0.11s    0.00s      0K    =
   0K    112K    1348K  --     -  S       2    1%   kworker/u8:4
>  3291      -   martin    martin        4   0.01s    0.09s      0K    =
   0K      0K       0K  --     -  S       1    1%   plasma-deskto
>=20
>=20
>=20
>=20
> ATOP - merkaba                          2014/12/27  13:47:12         =
                 -----------                           10s elapsed
> PRC |  sys   10.78s |  user   0.44s |  #proc    334  | #trun      3  =
|  #tslpi   547 |  #tslpu     3 |  #zombie    0  | no  procacct  |
> CPU |  sys     106% |  user      4% |  irq       0%  | idle    288%  =
|  wait      1% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys      93% |  user      0% |  irq       0%  | idle      7%  =
|  cpu002 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys       7% |  user      0% |  irq       0%  | idle     93%  =
|  cpu003 w  0% |  guest     0% |  curf 3.01GHz  | curscal  94%  |
> cpu |  sys       3% |  user      2% |  irq       0%  | idle     94%  =
|  cpu000 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys       3% |  user      2% |  irq       0%  | idle     95%  =
|  cpu001 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> CPL |  avg1    3.33 |  avg5    1.56 |  avg15   1.20  |               =
|  csw    38253 |  intr   23104 |                | numcpu     4  |
> MEM |  tot    15.5G |  free    4.9G |  cache   8.7G  | buff    0.0M  =
|  slab  336.5M |  shmem 207.2M |  vmbal   0.0M  | hptot   0.0M  |
> SWP |  tot    12.0G |  free   11.7G |                |               =
|               |               |  vmcom   3.4G  | vmlim  19.7G  |
> LVM |    msata-home |  busy      2% |  read       0  | write   2337  =
|  KiB/w      3 |  MBr/s   0.00 |  MBw/s   0.91  | avio 0.07 ms  |
> LVM |     sata-home |  busy      2% |  read      36  | write   2337  =
|  KiB/w      3 |  MBr/s   0.01 |  MBw/s   0.91  | avio 0.07 ms  |
> LVM |  msata-debian |  busy      1% |  read       1  | write   1630  =
|  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.65  | avio 0.03 ms  |
> LVM |   sata-debian |  busy      0% |  read       0  | write   1019  =
|  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.41  | avio 0.02 ms  |
> DSK |           sdb |  busy      2% |  read       1  | write   2545  =
|  KiB/w      5 |  MBr/s   0.00 |  MBw/s   1.45  | avio 0.07 ms  |
> DSK |           sda |  busy      1% |  read      36  | write   2461  =
|  KiB/w      5 |  MBr/s   0.01 |  MBw/s   1.28  | avio 0.06 ms  |
> NET |  transport    |  tcpi      20 |  tcpo      20  | udpi       1  =
|  udpo       1 |  tcpao      1 |  tcppo      1  | tcprs      0  |
> NET |  network      |  ipi       21 |  ipo       21  | ipfrw      0  =
|  deliv     21 |               |  icmpi      0  | icmpo      0  |
> NET |  eth0      0% |  pcki       5 |  pcko       5  | si    0 Kbps  =
|  so    0 Kbps |  erri       0 |  erro       0  | drpo       0  |
> NET |  lo      ---- |  pcki      16 |  pcko      16  | si    2 Kbps  =
|  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
>=20
>   PID    TID   RUID      EUID        THR  SYSCPU   USRCPU   VGROW    =
RGROW   RDDSK    WRDSK  ST   EXC  S   CPUNR   CPU   CMD        1/3
> 17450      -   root      root          1   9.96s    0.00s      0K    =
   0K      0K       0K  --     -  R       2  100%   kworker/u8:5
>  4746      -   martin    martin        2   0.06s    0.15s      0K    =
   0K      0K       0K  --     -  S       1    2%   konsole
> 10508      -   root      root          1   0.13s    0.00s      0K    =
   0K     96K    4048K  --     -  S       1    1%   kworker/u8:18
>  1488      -   root      root          1   0.06s    0.06s      0K    =
   0K      0K       0K  --     -  S       0    1%   Xorg
> 17332      -   root      root          1   0.12s    0.00s      0K    =
   0K     96K     580K  --     -  R       3    1%   kworker/u8:4
> 17454      -   root      root          1   0.11s    0.00s      0K    =
   0K     32K    4416K  --     -  D       1    1%   kworker/u8:6
> 17516      -   root      root          1   0.09s    0.00s      0K    =
   0K     16K     136K  --     -  S       3    1%   kworker/u8:7
>  3268      -   martin    martin        3   0.02s    0.05s      0K    =
   0K      0K       0K  --     -  S       1    1%   kwin
> 10036      -   root      root          1   0.05s    0.02s      0K    =
   0K      0K       0K  --     -  R       0    1%   atop
>=20
>=20
>=20
> So BTRFS is basically busy with itself and nothing else. Look at the =
SSD
> usage. They are *idling* around. Heck 2400 write accesses in 10 secon=
ds.
> Thats a joke with SSDs that can do 40000 IOPS (depending on how and w=
hat
> you measure of course, like request size, read, write, iodepth and so=
).
>=20
> Its kworker/u8:5 utilizing 100% of one core for minutes.
>=20
>=20
>=20
> Its the random write case it seems. Here are values from fio job:
>=20
> martin@merkaba:~> fio ssd-test.fio
> seq-write: (g=3D0): rw=3Dwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dsy=
nc, iodepth=3D1
> rand-write: (g=3D1): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=
=3Dsync, iodepth=3D1
> fio-2.1.11
> Starting 2 processes
> Jobs: 1 (f=3D1): [_(1),w(1)] [3.6% done] [0KB/0KB/0KB /s] [0/0/0 iops=
] [eta 01h:06m:26s]
> seq-write: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D19212: Sat Dec 27=
 13:48:33 2014
>   write: io=3D4096.0MB, bw=3D343683KB/s, iops=3D85920, runt=3D 12204m=
sec
>     clat (usec): min=3D3, max=3D38048, avg=3D10.52, stdev=3D205.25
>      lat (usec): min=3D3, max=3D38048, avg=3D10.66, stdev=3D205.43
>     clat percentiles (usec):
>      |  1.00th=3D[    4],  5.00th=3D[    4], 10.00th=3D[    4], 20.00=
th=3D[    4],
>      | 30.00th=3D[    4], 40.00th=3D[    5], 50.00th=3D[    5], 60.00=
th=3D[    5],
>      | 70.00th=3D[    7], 80.00th=3D[    8], 90.00th=3D[    8], 95.00=
th=3D[    9],
>      | 99.00th=3D[   14], 99.50th=3D[   20], 99.90th=3D[  211], 99.95=
th=3D[ 2128],
>      | 99.99th=3D[10304]
>     bw (KB  /s): min=3D164328, max=3D812984, per=3D100.00%, avg=3D345=
585.75, stdev=3D201695.20
>     lat (usec) : 4=3D0.18%, 10=3D95.31%, 20=3D4.00%, 50=3D0.18%, 100=3D=
0.12%
>     lat (usec) : 250=3D0.12%, 500=3D0.02%, 750=3D0.01%, 1000=3D0.01%
>     lat (msec) : 2=3D0.01%, 4=3D0.01%, 10=3D0.03%, 20=3D0.01%, 50=3D0=
.01%
>   cpu          : usr=3D13.55%, sys=3D46.89%, ctx=3D7810, majf=3D0, mi=
nf=3D6
>   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%,=
 32=3D0.0%, >=3D64=3D0.0%
>      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%=
, 64=3D0.0%, >=3D64=3D0.0%
>      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%=
, 64=3D0.0%, >=3D64=3D0.0%
>      issued    : total=3Dr=3D0/w=3D1048576/d=3D0, short=3Dr=3D0/w=3D0=
/d=3D0
>      latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1
>=20
> Seems fine.
>=20
>=20
> But:
>=20
> rand-write: (groupid=3D1, jobs=3D1): err=3D 0: pid=3D19243: Sat Dec 2=
7 13:48:33 2014
>   write: io=3D140336KB, bw=3D1018.4KB/s, iops=3D254, runt=3D137803mse=
c
>     clat (usec): min=3D4, max=3D21299K, avg=3D3708.02, stdev=3D266885=
.61
>      lat (usec): min=3D4, max=3D21299K, avg=3D3708.14, stdev=3D266885=
.61
>     clat percentiles (usec):
>      |  1.00th=3D[    4],  5.00th=3D[    5], 10.00th=3D[    5], 20.00=
th=3D[    5],
>      | 30.00th=3D[    6], 40.00th=3D[    6], 50.00th=3D[    6], 60.00=
th=3D[    6],
>      | 70.00th=3D[    7], 80.00th=3D[    7], 90.00th=3D[    9], 95.00=
th=3D[   10],
>      | 99.00th=3D[   18], 99.50th=3D[   19], 99.90th=3D[   28], 99.95=
th=3D[  116],
>      | 99.99th=3D[16711680]
>     bw (KB  /s): min=3D    0, max=3D 3426, per=3D100.00%, avg=3D1030.=
10, stdev=3D938.02
>     lat (usec) : 10=3D92.63%, 20=3D6.89%, 50=3D0.43%, 100=3D0.01%, 25=
0=3D0.02%
>     lat (msec) : 250=3D0.01%, 500=3D0.01%, >=3D2000=3D0.02%
>   cpu          : usr=3D0.06%, sys=3D1.59%, ctx=3D28720, majf=3D0, min=
f=3D7
>   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%,=
 32=3D0.0%, >=3D64=3D0.0%
>      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%=
, 64=3D0.0%, >=3D64=3D0.0%
>      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%=
, 64=3D0.0%, >=3D64=3D0.0%
>      issued    : total=3Dr=3D0/w=3D35084/d=3D0, short=3Dr=3D0/w=3D0/d=
=3D0
>      latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1
>=20
> Run status group 0 (all jobs):
>   WRITE: io=3D4096.0MB, aggrb=3D343682KB/s, minb=3D343682KB/s, maxb=3D=
343682KB/s, mint=3D12204msec, maxt=3D12204msec
>=20
> Run status group 1 (all jobs):
>   WRITE: io=3D140336KB, aggrb=3D1018KB/s, minb=3D1018KB/s, maxb=3D101=
8KB/s, mint=3D137803msec, maxt=3D137803msec
>=20
>=20
> What? 254 IOPS? With a Dual SSD BTRFS RAID 1?
>=20
> What?
>=20
> Ey, *what*?
>=20
>=20
>=20
> Repeating with the random write case.
>=20
> Its a different kworker now, but similar result:
>=20
> ATOP - merkaba                          2014/12/27  13:51:48         =
                 -----------                           10s elapsed
> PRC |  sys   10.66s |  user   0.25s |  #proc    330  | #trun      2  =
|  #tslpi   545 |  #tslpu     2 |  #zombie    0  | no  procacct  |
> CPU |  sys     105% |  user      3% |  irq       0%  | idle    292%  =
|  wait      0% |  guest     0% |  curf 3.07GHz  | curscal  95%  |
> cpu |  sys      92% |  user      0% |  irq       0%  | idle      8%  =
|  cpu002 w  0% |  guest     0% |  curf 3.19GHz  | curscal  99%  |
> cpu |  sys       8% |  user      0% |  irq       0%  | idle     92%  =
|  cpu003 w  0% |  guest     0% |  curf 3.09GHz  | curscal  96%  |
> cpu |  sys       3% |  user      2% |  irq       0%  | idle     95%  =
|  cpu000 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> cpu |  sys       2% |  user      1% |  irq       0%  | idle     97%  =
|  cpu001 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> CPL |  avg1    1.00 |  avg5    1.32 |  avg15   1.23  |               =
|  csw    34484 |  intr   23182 |                | numcpu     4  |
> MEM |  tot    15.5G |  free    5.4G |  cache   8.3G  | buff    0.0M  =
|  slab  334.8M |  shmem 207.2M |  vmbal   0.0M  | hptot   0.0M  |
> SWP |  tot    12.0G |  free   11.7G |                |               =
|               |               |  vmcom   3.4G  | vmlim  19.7G  |
> LVM |     sata-home |  busy      1% |  read      36  | write   2502  =
|  KiB/w      4 |  MBr/s   0.01 |  MBw/s   0.98  | avio 0.06 ms  |
> LVM |    msata-home |  busy      1% |  read      48  | write   2502  =
|  KiB/w      4 |  MBr/s   0.02 |  MBw/s   0.98  | avio 0.04 ms  |
> LVM |  msata-debian |  busy      0% |  read       0  | write      6  =
|  KiB/w      7 |  MBr/s   0.00 |  MBw/s   0.00  | avio 1.33 ms  |
> LVM |   sata-debian |  busy      0% |  read       0  | write      6  =
|  KiB/w      7 |  MBr/s   0.00 |  MBw/s   0.00  | avio 0.17 ms  |
> DSK |           sda |  busy      1% |  read      36  | write   2494  =
|  KiB/w      4 |  MBr/s   0.01 |  MBw/s   0.98  | avio 0.06 ms  |
> DSK |           sdb |  busy      1% |  read      48  | write   2494  =
|  KiB/w      4 |  MBr/s   0.02 |  MBw/s   0.98  | avio 0.04 ms  |
> NET |  transport    |  tcpi      32 |  tcpo      30  | udpi       2  =
|  udpo       2 |  tcpao      2 |  tcppo      1  | tcprs      0  |
> NET |  network      |  ipi       35 |  ipo       32  | ipfrw      0  =
|  deliv     35 |               |  icmpi      0  | icmpo      0  |
> NET |  eth0      0% |  pcki      19 |  pcko      16  | si    9 Kbps  =
|  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
> NET |  lo      ---- |  pcki      16 |  pcko      16  | si    2 Kbps  =
|  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
>=20
>   PID    TID   RUID      EUID        THR  SYSCPU   USRCPU   VGROW    =
RGROW   RDDSK    WRDSK  ST   EXC  S   CPUNR   CPU   CMD        1/2
> 11746      -   root      root          1  10.00s    0.00s      0K    =
   0K      0K       0K  --     -  R       2  100%   kworker/u8:0
> 12254      -   root      root          1   0.16s    0.00s      0K    =
   0K    112K    1712K  --     -  S       3    2%   kworker/u8:3 =20
> 17517      -   root      root          1   0.16s    0.00s      0K    =
   0K    144K    1764K  --     -  S       1    2%   kworker/u8:8
>=20
>=20
>=20
> And now the graphical environemnt is locked. Continuining on TTY1.
>=20
> Doing another fio job with tee so I can get output easily.
>=20
> Wow! I wonder whether this is reproducable with a fresh BTRFS with fi=
o stressing it.
>=20
> Like a 10 GiB BTRFS with 5 GiB fio test file and just letting it run.=

>=20
>=20
> Okay, I let the final fio job complete and include the output here.
>=20
>=20
> Okay, and there we are and I do have sysrq-t figures.=20
>=20
> Okay, this is 1,2 MiB xz packed. So I better start a bug report about=
 this
> and attach it there. Is dislike cloud URLs that may disappear at some=
 time.
>=20
>=20
>=20
> Now please finally acknowledge that there is an issue. Maybe I was no=
t
> using the correct terms at the beginning, but there is a real issue. =
I do
> performance things for half a decade at least, I know that there is a=
n issue
> when I see it.
>=20
>=20
>=20
>=20
> There we go:
>=20
> Bug 90401 - btrfs kworker thread uses up 100% of a Sandybridge core f=
or minutes on random write into big file
> https://bugzilla.kernel.org/show_bug.cgi?id=3D90401

I have done more tests.

This is on the same /home after extending it to 170 GiB and balancing i=
t to
btrfs balance start -dusage=3D80

It has plenty of free space free. I updated the bug report and hope it =
can
give an easy enough to comprehend summary. The new tests are in:

https://bugzilla.kernel.org/show_bug.cgi?id=3D90401#c6



Pasting below for discussion on list. Summary: I easily get 38000 (!)
IOPS. It may be an idea to reduce to 160 GiB, but right now this does
not work as it says no free space on device when trying to downsize it.=

I may try with 165 or 162GiB.

So now we have three IOPS figures:

=2D 256 IOPS in worst case scenario
=2D 4700 IOPS when trying to reproduce worst case scenario with a fresh a=
nd small
BTRFS
=2D 38000 IOPS when /home has unused device space to allocate chunks from=


https://bugzilla.kernel.org/show_bug.cgi?id=3D90401#c8


This is another test.

With my /home. This time while it has enough free device space to reser=
ve
new chunks from.

Remember this for the case where is hasn=C2=B4t:

merkaba:~> btrfs fi sh /home
Label: 'home'  uuid: [some UUID]
        Total devices 2 FS bytes used 144.19GiB
        devid    1 size 160.00GiB used 150.01GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 160.00GiB used 150.01GiB path /dev/mapper/sata-=
home

Btrfs v3.17
merkaba:~> btrfs fi df /home
Data, RAID1: total=3D144.98GiB, used=3D140.95GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D5.00GiB, used=3D3.24GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

rand-write: (groupid=3D1, jobs=3D1): err=3D 0: pid=3D19243: Sat Dec 27 =
13:48:33 2014
  write: io=3D140336KB, bw=3D1018.4KB/s, iops=3D254, runt=3D137803msec
    clat (usec): min=3D4, max=3D21299K, avg=3D3708.02, stdev=3D266885.6=
1
     lat (usec): min=3D4, max=3D21299K, avg=3D3708.14, stdev=3D266885.6=
1
    clat percentiles (usec):
     |  1.00th=3D[    4],  5.00th=3D[    5], 10.00th=3D[    5], 20.00th=
=3D[    5],
     | 30.00th=3D[    6], 40.00th=3D[    6], 50.00th=3D[    6], 60.00th=
=3D[    6],
     | 70.00th=3D[    7], 80.00th=3D[    7], 90.00th=3D[    9], 95.00th=
=3D[   10],
     | 99.00th=3D[   18], 99.50th=3D[   19], 99.90th=3D[   28], 99.95th=
=3D[  116],
     | 99.99th=3D[16711680]
    bw (KB  /s): min=3D    0, max=3D 3426, per=3D100.00%, avg=3D1030.10=
, stdev=3D938.02
    lat (usec) : 10=3D92.63%, 20=3D6.89%, 50=3D0.43%, 100=3D0.01%, 250=3D=
0.02%
    lat (msec) : 250=3D0.01%, 500=3D0.01%, >=3D2000=3D0.02%
  cpu          : usr=3D0.06%, sys=3D1.59%, ctx=3D28720, majf=3D0, minf=3D=
7
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D35084/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1
[=E2=80=A6]
Run status group 1 (all jobs):
  WRITE: io=3D140336KB, aggrb=3D1018KB/s, minb=3D1018KB/s, maxb=3D1018K=
B/s, mint=3D137803msec, maxt=3D137803msec

That is where I saw this kworker thread at 100% of one Sandybridge core=

for minutes. This is where I made kern.log with sysrq-t triggers in

https://bugzilla.kernel.org/show_bug.cgi?id=3D90401#c0

made from.


But now as I extended it to 170 GiB and did some basic rebalancing
(upto btrfs balance start -dusage=3D80) I have this:


First attempt:

merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
So 28. Dez 13:13:47 CET 2014
Label: 'home'  uuid: [some UUID]
        Total devices 2 FS bytes used 151.09GiB
        devid    1 size 170.00GiB used 158.03GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 170.00GiB used 158.03GiB path /dev/mapper/sata-=
home

Btrfs v3.17
Data, RAID1: total=3D153.00GiB, used=3D147.83GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D5.00GiB, used=3D3.26GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B


martin@merkaba:~> fio ssd-test.fio=20
rand-write: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3D=
sync, iodepth=3D1
fio-2.1.11
Starting 1 process
rand-write: Laying out IO file(s) (1 file(s) / 4096MB)
Jobs: 1 (f=3D1): [w(1)] [100.0% done] [0KB/84528KB/0KB /s] [0/21.2K/0 i=
ops] [eta 00m:00s]
rand-write: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D9987: Sun Dec 28 1=
3:14:32 2014
  write: io=3D4096.0MB, bw=3D155304KB/s, iops=3D38826, runt=3D 27007mse=
c
    clat (usec): min=3D5, max=3D28202, avg=3D22.03, stdev=3D240.04
     lat (usec): min=3D5, max=3D28202, avg=3D22.28, stdev=3D240.16
    clat percentiles (usec):
     |  1.00th=3D[    6],  5.00th=3D[    7], 10.00th=3D[    7], 20.00th=
=3D[    8],
     | 30.00th=3D[   10], 40.00th=3D[   11], 50.00th=3D[   12], 60.00th=
=3D[   13],
     | 70.00th=3D[   14], 80.00th=3D[   15], 90.00th=3D[   17], 95.00th=
=3D[   23],
     | 99.00th=3D[   93], 99.50th=3D[  175], 99.90th=3D[ 2096], 99.95th=
=3D[ 6816],
     | 99.99th=3D[10176]
    bw (KB  /s): min=3D76832, max=3D413616, per=3D100.00%, avg=3D156706=
.75, stdev=3D101101.26
    lat (usec) : 10=3D29.85%, 20=3D62.43%, 50=3D5.74%, 100=3D1.07%, 250=
=3D0.57%
    lat (usec) : 500=3D0.16%, 750=3D0.04%, 1000=3D0.02%
    lat (msec) : 2=3D0.02%, 4=3D0.01%, 10=3D0.08%, 20=3D0.01%, 50=3D0.0=
1%
  cpu          : usr=3D12.05%, sys=3D47.34%, ctx=3D86985, majf=3D0, min=
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
  WRITE: io=3D4096.0MB, aggrb=3D155304KB/s, minb=3D155304KB/s, maxb=3D1=
55304KB/s, mint=3D27007msec, maxt=3D27007msec



Second attempt:



merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
So 28. Dez 13:16:19 CET 2014
Label: 'home'  uuid: [some UUID]
        Total devices 2 FS bytes used 155.11GiB
        devid    1 size 170.00GiB used 162.03GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 170.00GiB used 162.03GiB path /dev/mapper/sata-=
home

Btrfs v3.17
Data, RAID1: total=3D157.00GiB, used=3D151.83GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D5.00GiB, used=3D3.27GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B



martin@merkaba:~> fio ssd-test.fio
rand-write: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3D=
sync, iodepth=3D1
fio-2.1.11
Starting 1 process
Jobs: 1 (f=3D1): [w(1)] [100.0% done] [0KB/113.5MB/0KB /s] [0/29.3K/0 i=
ops] [eta 00m:00s]
rand-write: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D10043: Sun Dec 28 =
13:17:34 2014
  write: io=3D4096.0MB, bw=3D145995KB/s, iops=3D36498, runt=3D 28729mse=
c
    clat (usec): min=3D4, max=3D143201, avg=3D23.95, stdev=3D518.47
     lat (usec): min=3D4, max=3D143201, avg=3D24.13, stdev=3D518.48
    clat percentiles (usec):
     |  1.00th=3D[    6],  5.00th=3D[    7], 10.00th=3D[    7], 20.00th=
=3D[    8],
     | 30.00th=3D[    9], 40.00th=3D[   10], 50.00th=3D[   11], 60.00th=
=3D[   12],
     | 70.00th=3D[   13], 80.00th=3D[   13], 90.00th=3D[   15], 95.00th=
=3D[   16],
     | 99.00th=3D[   33], 99.50th=3D[   70], 99.90th=3D[ 5472], 99.95th=
=3D[ 8640],
     | 99.99th=3D[20864]
    bw (KB  /s): min=3D    4, max=3D433760, per=3D100.00%, avg=3D149179=
.63, stdev=3D136784.14
    lat (usec) : 10=3D38.35%, 20=3D58.99%, 50=3D1.96%, 100=3D0.38%, 250=
=3D0.16%
    lat (usec) : 500=3D0.03%, 750=3D0.01%, 1000=3D0.01%
    lat (msec) : 2=3D0.01%, 4=3D0.01%, 10=3D0.08%, 20=3D0.02%, 50=3D0.0=
1%
    lat (msec) : 100=3D0.01%, 250=3D0.01%
  cpu          : usr=3D10.25%, sys=3D42.40%, ctx=3D42642, majf=3D0, min=
f=3D8
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
  WRITE: io=3D4096.0MB, aggrb=3D145995KB/s, minb=3D145995KB/s, maxb=3D1=
45995KB/s, mint=3D28729msec, maxt=3D28729msec



Third attempt:

merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
So 28. Dez 13:18:24 CET 2014
Label: 'home'  uuid: [some UUID]
        Total devices 2 FS bytes used 156.16GiB
        devid    1 size 170.00GiB used 160.03GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 170.00GiB used 160.03GiB path /dev/mapper/sata-=
home

Btrfs v3.17
Data, RAID1: total=3D155.00GiB, used=3D152.83GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D5.00GiB, used=3D3.34GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B


martin@merkaba:~> fio ssd-test.fio
rand-write: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3D=
sync, iodepth=3D1
fio-2.1.11
Starting 1 process
Jobs: 1 (f=3D1): [w(1)] [100.0% done] [0KB/195.7MB/0KB /s] [0/50.9K/0 i=
ops] [eta 00m:00s]
rand-write: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D10058: Sun Dec 28 =
13:18:59 2014
  write: io=3D4096.0MB, bw=3D202184KB/s, iops=3D50545, runt=3D 20745mse=
c
    clat (usec): min=3D4, max=3D28261, avg=3D15.84, stdev=3D214.59
     lat (usec): min=3D4, max=3D28261, avg=3D16.06, stdev=3D214.78
    clat percentiles (usec):
     |  1.00th=3D[    6],  5.00th=3D[    7], 10.00th=3D[    7], 20.00th=
=3D[    8],
     | 30.00th=3D[    8], 40.00th=3D[    9], 50.00th=3D[   11], 60.00th=
=3D[   12],
     | 70.00th=3D[   12], 80.00th=3D[   13], 90.00th=3D[   15], 95.00th=
=3D[   17],
     | 99.00th=3D[   52], 99.50th=3D[  105], 99.90th=3D[  426], 99.95th=
=3D[  980],
     | 99.99th=3D[12736]
    bw (KB  /s): min=3D    4, max=3D426344, per=3D100.00%, avg=3D207355=
.30, stdev=3D105104.72
    lat (usec) : 10=3D41.44%, 20=3D55.33%, 50=3D2.17%, 100=3D0.54%, 250=
=3D0.34%
    lat (usec) : 500=3D0.10%, 750=3D0.02%, 1000=3D0.01%
    lat (msec) : 2=3D0.02%, 4=3D0.01%, 10=3D0.01%, 20=3D0.02%, 50=3D0.0=
1%
  cpu          : usr=3D14.15%, sys=3D59.06%, ctx=3D81711, majf=3D0, min=
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
  WRITE: io=3D4096.0MB, aggrb=3D202183KB/s, minb=3D202183KB/s, maxb=3D2=
02183KB/s, mint=3D20745msec, maxt=3D20745msec


merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
So 28. Dez 13:19:15 CET 2014
Label: 'home'  uuid: [some UUID]
        Total devices 2 FS bytes used 155.16GiB
        devid    1 size 170.00GiB used 162.03GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 170.00GiB used 162.03GiB path /dev/mapper/sata-=
home

Btrfs v3.17
Data, RAID1: total=3D157.00GiB, used=3D151.85GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D5.00GiB, used=3D3.31GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B



So here BTRFS was fast. It is getting trouble on my /home when its
almost full. But more so than with a empty 10 GiB filesystem as I
have shown in testcase
https://bugzilla.kernel.org/show_bug.cgi?id=3D90401#c3


There I had:

merkaba:/mnt/btrfsraid1> fio ssd-test.fio
rand-write: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3D=
sync, iodepth=3D1
fio-2.1.11
Starting 1 process
rand-write: Laying out IO file(s) (1 file(s) / 4096MB)
Jobs: 1 (f=3D1): [w(1)] [100.0% done] [0KB/20924KB/0KB /s] [0/5231/0 io=
ps] [eta 00m:00s]
rand-write: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6221: Sat Dec 27 1=
5:34:14 2014
  write: io=3D2645.8MB, bw=3D22546KB/s, iops=3D5636, runt=3D120165msec
    clat (usec): min=3D4, max=3D3054.8K, avg=3D174.87, stdev=3D11455.26=

     lat (usec): min=3D4, max=3D3054.8K, avg=3D175.03, stdev=3D11455.27=

    clat percentiles (usec):
     |  1.00th=3D[    6],  5.00th=3D[    6], 10.00th=3D[    6], 20.00th=
=3D[    7],
     | 30.00th=3D[    7], 40.00th=3D[    8], 50.00th=3D[    9], 60.00th=
=3D[   10],
     | 70.00th=3D[   11], 80.00th=3D[   12], 90.00th=3D[   14], 95.00th=
=3D[   17],
     | 99.00th=3D[   30], 99.50th=3D[   40], 99.90th=3D[ 1992], 99.95th=
=3D[25984],
     | 99.99th=3D[411648]
    bw (KB  /s): min=3D  168, max=3D70703, per=3D100.00%, avg=3D27325.4=
6, stdev=3D14887.94
    lat (usec) : 10=3D55.81%, 20=3D41.12%, 50=3D2.70%, 100=3D0.14%, 250=
=3D0.06%
    lat (usec) : 500=3D0.02%, 750=3D0.01%, 1000=3D0.02%
    lat (msec) : 2=3D0.02%, 4=3D0.02%, 10=3D0.02%, 20=3D0.01%, 50=3D0.0=
1%
    lat (msec) : 100=3D0.01%, 250=3D0.01%, 500=3D0.02%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%, >=3D2000=3D0.01%
  cpu          : usr=3D1.56%, sys=3D5.57%, ctx=3D29822, majf=3D0, minf=3D=
7
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D677303/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1

Run status group 0 (all jobs):
  WRITE: io=3D2645.8MB, aggrb=3D22545KB/s, minb=3D22545KB/s, maxb=3D225=
45KB/s, mint=3D120165msec, maxt=3D120165msec



=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart2970848.2f8U433XaG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlSf/ugACgkQmRvqrKWZhMeU2QCeOx6ZdK7ivRsqnYp+JDTUDmVf
o6oAnRJndlpn3wOPcAfRr+jh53iLPU40
=cizk
-----END PGP SIGNATURE-----

--nextPart2970848.2f8U433XaG--

