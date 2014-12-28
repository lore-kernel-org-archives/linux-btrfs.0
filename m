Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54733 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaL1N4X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Dec 2014 08:56:23 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Robert White <rwhite@pobox.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again (further tests, as close as I dare, current idea)
Date: Sun, 28 Dec 2014 14:56:21 +0100
Message-ID: <2574221.IMnk8vTl9R@merkaba>
In-Reply-To: <4646600.pkiZfU6OfG@merkaba>
References: <3738341.y7uRQFcLJH@merkaba> <1930625.5Z83nuS5i9@merkaba> <4646600.pkiZfU6OfG@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2421399.6FVboQBYHY"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2421399.6FVboQBYHY
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Sonntag, 28. Dezember 2014, 14:40:32 schrieb Martin Steigerwald:
> Am Sonntag, 28. Dezember 2014, 14:00:19 schrieb Martin Steigerwald:
> > Am Samstag, 27. Dezember 2014, 14:55:58 schrieb Martin Steigerwald:=

> > > Summarized at
> > >=20
> > > Bug 90401 - btrfs kworker thread uses up 100% of a Sandybridge co=
re for minutes on random write into big file
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D90401
> > >=20
> > > see below. This is reproducable with fio, no need for Windows XP =
in
> > > Virtualbox for reproducing the issue. Next I will try to reproduc=
e with
> > > a freshly creating filesystem.
> > >=20
> > >=20
> > > Am Samstag, 27. Dezember 2014, 09:30:43 schrieb Hugo Mills:
> > > > On Sat, Dec 27, 2014 at 10:01:17AM +0100, Martin Steigerwald wr=
ote:
> > > > > Am Freitag, 26. Dezember 2014, 14:48:38 schrieb Robert White:=

> > > > > > On 12/26/2014 05:37 AM, Martin Steigerwald wrote:
> > > > > > > Hello!
> > > > > > >=20
> > > > > > > First: Have a merry christmas and enjoy a quiet time in t=
hese days.
> > > > > > >=20
> > > > > > > Second: At a time you feel like it, here is a little rant=
, but also a
> > > > > > > bug
> > > > > > > report:
> > > > > > >=20
> > > > > > > I have this on 3.18 kernel on Debian Sid with BTRFS Dual =
SSD RAID with
> > > > > > > space_cache, skinny meta data extents =E2=80=93 are these=
 a problem? =E2=80=93 and
> > > > > >=20
> > > > > > > compress=3Dlzo:
> > > > > > (there is no known problem with skinny metadata, it's actua=
lly more
> > > > > > efficient than the older format. There has been some anecdo=
tes about
> > > > > > mixing the skinny and fat metadata but nothing has ever bee=
n
> > > > > > demonstrated problematic.)
> > > > > >=20
> > > > > > > merkaba:~> btrfs fi sh /home
> > > > > > > Label: 'home'  uuid: b96c4f72-0523-45ac-a401-f7be73dd624a=

> > > > > > >=20
> > > > > > >          Total devices 2 FS bytes used 144.41GiB
> > > > > > >          devid    1 size 160.00GiB used 160.00GiB path
> > > > > > >          /dev/mapper/msata-home
> > > > > > >          devid    2 size 160.00GiB used 160.00GiB path
> > > > > > >          /dev/mapper/sata-home
> > > > > > >=20
> > > > > > > Btrfs v3.17
> > > > > > > merkaba:~> btrfs fi df /home
> > > > > > > Data, RAID1: total=3D154.97GiB, used=3D141.12GiB
> > > > > > > System, RAID1: total=3D32.00MiB, used=3D48.00KiB
> > > > > > > Metadata, RAID1: total=3D5.00GiB, used=3D3.29GiB
> > > > > > > GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
> > > > > >=20
> > > > > > This filesystem, at the allocation level, is "very full" (s=
ee below).
> > > > > >=20
> > > > > > > And I had hangs with BTRFS again. This time as I wanted t=
o install tax
> > > > > > > return software in Virtualbox=C2=B4d Windows XP VM (which=
 I use once a year
> > > > > > > cause I know no tax return software for Linux which would=
 be suitable
> > > > > > > for
> > > > > > > Germany and I frankly don=C2=B4t care about the end of se=
curity cause all
> > > > > > > surfing and other network access I will do from the Linux=
 box and I
> > > > > > > only
> > > > > > > run the VM behind a firewall).
> > > > > >=20
> > > > > > > And thus I try the balance dance again:
> > > > > > ITEM: Balance... it doesn't do what you think it does...=20=

> > > > > >=20
> > > > > > "Balancing" is something you should almost never need to do=
. It is only
> > > > > > for cases of changing geometry (adding disks, switching RAI=
D levels,
> > > > > > etc.) of for cases when you've radically changed allocation=
 behaviors
> > > > > > (like you decided to remove all your VM's or you've decided=
 to remove a
> > > > > > mail spool directory full of thousands of tiny files).
> > > > > >=20
> > > > > > People run balance all the time because they think they sho=
uld. They are
> > > > > > _usually_ incorrect in that belief.
> > > > >=20
> > > > > I only see the lockups of BTRFS is the trees *occupy* all spa=
ce on the
> > > > > device.
> > > >    No, "the trees" occupy 3.29 GiB of your 5 GiB of mirrored me=
tadata
> > > > space. What's more, balance does *not* balance the metadata tre=
es. The
> > > > remaining space -- 154.97 GiB -- is unstructured storage for fi=
le
> > > > data, and you have some 13 GiB of that available for use.
> > > >=20
> > > >    Now, since you're seeing lockups when the space on your disk=
s is
> > > > all allocated I'd say that's a bug. However, you're the *only* =
person
> > > > who's reported this as a regular occurrence. Does this happen w=
ith all
> > > > filesystems you have, or just this one?
> > > >=20
> > > > > I *never* so far saw it lockup if there is still space BTRFS =
can allocate
> > > > > from to *extend* a tree.
> > > >=20
> > > >    It's not a tree. It's simply space allocation. It's not even=
 space
> > > > *usage* you're talking about here -- it's just allocation (i.e.=
 the FS
> > > > saying "I'm going to use this piece of disk for this purpose").=

> > > >=20
> > > > > This may be a bug, but this is what I see.
> > > > >=20
> > > > > And no amount of "you should not balance a BTRFS" will make t=
hat
> > > > > perception go away.
> > > > >=20
> > > > > See, I see the sun coming out on a morning and you tell me "n=
o, it
> > > > > doesn=C2=B4t". Simply that is not going to match my perceptio=
n.
> > > >=20
> > > >    Duncan's assertion is correct in its detail. Looking at your=
 space
> > >=20
> > > Robert's=20
> > >=20
> > > > usage, I would not suggest that running a balance is something =
you
> > > > need to do. Now, since you have these lockups that seem quite
> > > > repeatable, there's probably a lurking bug in there, but hackin=
g
> > > > around with balance every time you hit it isn't going to get th=
e
> > > > problem solved properly.
> > > >=20
> > > >    I think I would suggest the following:
> > > >=20
> > > >  - make sure you have some way of logging your dmesg permanentl=
y (use
> > > >    a different filesystem for /var/log, or a serial console, or=
 a
> > > >    netconsole)
> > > >=20
> > > >  - when the lockup happens, hit Alt-SysRq-t a few times
> > > >=20
> > > >  - send the dmesg output here, or post to bugzilla.kernel.org
> > > >=20
> > > >    That's probably going to give enough information to the deve=
lopers
> > > > to work out where the lockup is happening, and is clearly the w=
ay
> > > > forward here.
> > >=20
> > > And I got it reproduced. *Perfectly* reproduced, I=C2=B4d say.
> > >=20
> > > But let me run the whole story:
> > >=20
> > > 1) I downsized my /home BTRFS from dual 170 GiB to dual 160 GiB a=
gain.
> >=20
> > [=E2=80=A6 story of trying to reproduce with Windows XP defragmenti=
ng which was
> > unsuccessful as BTRFS still had free device space to allocate new c=
hunks
> > from =E2=80=A6]
> >=20
> > > But finally I got to:
> > >=20
> > > merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
> > > Sa 27. Dez 13:26:39 CET 2014
> > > Label: 'home'  uuid: [some UUID]
> > >         Total devices 2 FS bytes used 152.83GiB
> > >         devid    1 size 160.00GiB used 160.00GiB path /dev/mapper=
/msata-home
> > >         devid    2 size 160.00GiB used 160.00GiB path /dev/mapper=
/sata-home
> > >=20
> > > Btrfs v3.17
> > > Data, RAID1: total=3D154.97GiB, used=3D149.58GiB
> > > System, RAID1: total=3D32.00MiB, used=3D48.00KiB
> > > Metadata, RAID1: total=3D5.00GiB, used=3D3.26GiB
> > > GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
> > >=20
> > >=20
> > >=20
> > > So I did, if Virtualbox can write randomly in a file, I can too.
> > >=20
> > > So I did:
> > >=20
> > >=20
> > > martin@merkaba:~> cat ssd-test.fio=20
> > > [global]
> > > bs=3D4k
> > > #ioengine=3Dlibaio
> > > #iodepth=3D4
> > > size=3D4g
> > > #direct=3D1
> > > runtime=3D120
> > > filename=3Dssd.test.file
> > >=20
> > > [seq-write]
> > > rw=3Dwrite
> > > stonewall
> > >=20
> > > [rand-write]
> > > rw=3Drandwrite
> > > stonewall
> > >=20
> > >=20
> > >=20
> > > And got:
> > >=20
> > > ATOP - merkaba                          2014/12/27  13:41:02     =
                     -----------                           10s elapsed
> > > PRC |  sys   10.14s |  user   0.38s |  #proc    332  | #trun     =
 2  |  #tslpi   548 |  #tslpu     0 |  #zombie    0  | no  procacct  |
> > > CPU |  sys     102% |  user      4% |  irq       0%  | idle    29=
5%  |  wait      0% |  guest     0% |  curf 3.10GHz  | curscal  96%  |
> > > cpu |  sys      76% |  user      0% |  irq       0%  | idle     2=
4%  |  cpu001 w  0% |  guest     0% |  curf 3.20GHz  | curscal  99%  |
> > > cpu |  sys      24% |  user      1% |  irq       0%  | idle     7=
5%  |  cpu000 w  0% |  guest     0% |  curf 3.19GHz  | curscal  99%  |
> > > cpu |  sys       1% |  user      1% |  irq       0%  | idle     9=
8%  |  cpu002 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > > cpu |  sys       1% |  user      1% |  irq       0%  | idle     9=
8%  |  cpu003 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > > CPL |  avg1    0.82 |  avg5    0.78 |  avg15   0.99  |           =
    |  csw     6233 |  intr   12023 |                | numcpu     4  |
> > > MEM |  tot    15.5G |  free    4.0G |  cache   9.7G  | buff    0.=
0M  |  slab  333.1M |  shmem 206.6M |  vmbal   0.0M  | hptot   0.0M  |
> > > SWP |  tot    12.0G |  free   11.7G |                |           =
    |               |               |  vmcom   3.4G  | vmlim  19.7G  |
> > > LVM |     sata-home |  busy      0% |  read       8  | write     =
 0  |  KiB/w      0 |  MBr/s   0.00 |  MBw/s   0.00  | avio 0.12 ms  |
> > > DSK |           sda |  busy      0% |  read       8  | write     =
 0  |  KiB/w      0 |  MBr/s   0.00 |  MBw/s   0.00  | avio 0.12 ms  |
> > > NET |  transport    |  tcpi      16 |  tcpo      16  | udpi      =
 0  |  udpo       0 |  tcpao      1 |  tcppo      1  | tcprs      0  |
> > > NET |  network      |  ipi       16 |  ipo       16  | ipfrw     =
 0  |  deliv     16 |               |  icmpi      0  | icmpo      0  |
> > > NET |  lo      ---- |  pcki      16 |  pcko      16  | si    2 Kb=
ps  |  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
> > >=20
> > >   PID    TID   RUID      EUID        THR  SYSCPU   USRCPU   VGROW=
    RGROW   RDDSK    WRDSK  ST   EXC  S   CPUNR   CPU   CMD        1/2
> > > 18079      -   martin    martin        2   9.99s    0.00s      0K=
       0K      0K      16K  --     -  R       1  100%   fio
> > >  4746      -   martin    martin        2   0.01s    0.14s      0K=
       0K      0K       0K  --     -  S       2    2%   konsole
> > >  3291      -   martin    martin        4   0.01s    0.11s      0K=
       0K      0K       0K  --     -  S       0    1%   plasma-desktop
> > >  1488      -   root      root          1   0.03s    0.04s      0K=
       0K      0K       0K  --     -  S       0    1%   Xorg
> > > 10036      -   root      root          1   0.04s    0.02s      0K=
       0K      0K       0K  --     -  R       2    1%   atop
> > >=20
> > > while fio was just *laying* out the 4 GiB file. Yes, thats 100% s=
ystem CPU
> > > for 10 seconds while allocatiing a 4 GiB file on a filesystem lik=
e:
> > >=20
> > > martin@merkaba:~> LANG=3DC df -hT /home
> > > Filesystem             Type   Size  Used Avail Use% Mounted on
> > > /dev/mapper/msata-home btrfs  170G  156G   17G  91% /home
> > >=20
> > > where a 4 GiB file should easily fit, no? (And this output is wit=
h the 4
> > > GiB file. So it was even 4 GiB more free before.)
> > >=20
> > >=20
> > > But it gets even more visible:
> > >=20
> > > martin@merkaba:~> fio ssd-test.fio
> > > seq-write: (g=3D0): rw=3Dwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3D=
sync, iodepth=3D1
> > > rand-write: (g=3D1): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioen=
gine=3Dsync, iodepth=3D1
> > > fio-2.1.11
> > > Starting 2 processes
> > > Jobs: 1 (f=3D1): [_(1),w(1)] [19.3% done] [0KB/0KB/0KB /s] [0/0/0=
 iops] [eta 01m:57s]      =20
> > > 0$ zsh  1$ zsh  2$ zsh  3-$ zsh  4$ zsh  5$* zsh                 =
                 =20
> > >=20
> > >=20
> > > yes, thats 0 IOPS.
> > >=20
> > > 0 IOPS and in zero IOPS. For minutes.
> > >=20
> > >=20
> > >=20
> > > And here is why:
> > >=20
> > > ATOP - merkaba                          2014/12/27  13:46:52     =
                     -----------                           10s elapsed
> > > PRC |  sys   10.77s |  user   0.31s |  #proc    334  | #trun     =
 2  |  #tslpi   548 |  #tslpu     3 |  #zombie    0  | no  procacct  |
> > > CPU |  sys     108% |  user      3% |  irq       0%  | idle    28=
6%  |  wait      2% |  guest     0% |  curf 3.08GHz  | curscal  96%  |
> > > cpu |  sys      72% |  user      1% |  irq       0%  | idle     2=
8%  |  cpu000 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > > cpu |  sys      19% |  user      0% |  irq       0%  | idle     8=
1%  |  cpu001 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > > cpu |  sys      11% |  user      1% |  irq       0%  | idle     8=
7%  |  cpu003 w  1% |  guest     0% |  curf 3.19GHz  | curscal  99%  |
> > > cpu |  sys       6% |  user      1% |  irq       0%  | idle     9=
1%  |  cpu002 w  1% |  guest     0% |  curf 3.11GHz  | curscal  97%  |
> > > CPL |  avg1    2.78 |  avg5    1.34 |  avg15   1.12  |           =
    |  csw    50192 |  intr   32379 |                | numcpu     4  |
> > > MEM |  tot    15.5G |  free    5.0G |  cache   8.7G  | buff    0.=
0M  |  slab  332.6M |  shmem 207.2M |  vmbal   0.0M  | hptot   0.0M  |
> > > SWP |  tot    12.0G |  free   11.7G |                |           =
    |               |               |  vmcom   3.4G  | vmlim  19.7G  |
> > > LVM |     sata-home |  busy      5% |  read     160  | write  111=
77  |  KiB/w      3 |  MBr/s   0.06 |  MBw/s   4.36  | avio 0.05 ms  |
> > > LVM |    msata-home |  busy      4% |  read      28  | write  111=
77  |  KiB/w      3 |  MBr/s   0.01 |  MBw/s   4.36  | avio 0.04 ms  |
> > > LVM |   sata-debian |  busy      0% |  read       0  | write    8=
44  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.33  | avio 0.02 ms  |
> > > LVM |  msata-debian |  busy      0% |  read       0  | write    8=
44  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.33  | avio 0.02 ms  |
> > > DSK |           sda |  busy      5% |  read     160  | write  102=
00  |  KiB/w      4 |  MBr/s   0.06 |  MBw/s   4.69  | avio 0.05 ms  |
> > > DSK |           sdb |  busy      4% |  read      28  | write  105=
58  |  KiB/w      4 |  MBr/s   0.01 |  MBw/s   4.69  | avio 0.04 ms  |
> > > NET |  transport    |  tcpi      35 |  tcpo      33  | udpi      =
 3  |  udpo       3 |  tcpao      2 |  tcppo      1  | tcprs      0  |
> > > NET |  network      |  ipi       38 |  ipo       36  | ipfrw     =
 0  |  deliv     38 |               |  icmpi      0  | icmpo      0  |
> > > NET |  eth0      0% |  pcki      22 |  pcko      20  | si    9 Kb=
ps  |  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
> > > NET |  lo      ---- |  pcki      16 |  pcko      16  | si    2 Kb=
ps  |  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
> > >=20
> > >   PID    TID   RUID      EUID        THR  SYSCPU   USRCPU   VGROW=
    RGROW   RDDSK    WRDSK  ST   EXC  S   CPUNR   CPU   CMD        1/3
> > > 14973      -   root      root          1   8.92s    0.00s      0K=
       0K      0K     144K  --     -  S       0   89%   kworker/u8:14
> > > 17450      -   root      root          1   0.86s    0.00s      0K=
       0K      0K      32K  --     -  R       3    9%   kworker/u8:5
> > >   788      -   root      root          1   0.25s    0.00s      0K=
       0K    128K   18880K  --     -  S       3    3%   btrfs-transact
> > > 12254      -   root      root          1   0.14s    0.00s      0K=
       0K     64K     576K  --     -  S       2    1%   kworker/u8:3
> > > 17332      -   root      root          1   0.11s    0.00s      0K=
       0K    112K    1348K  --     -  S       2    1%   kworker/u8:4
> > >  3291      -   martin    martin        4   0.01s    0.09s      0K=
       0K      0K       0K  --     -  S       1    1%   plasma-deskto
> > >=20
> > >=20
> > >=20
> > >=20
> > > ATOP - merkaba                          2014/12/27  13:47:12     =
                     -----------                           10s elapsed
> > > PRC |  sys   10.78s |  user   0.44s |  #proc    334  | #trun     =
 3  |  #tslpi   547 |  #tslpu     3 |  #zombie    0  | no  procacct  |
> > > CPU |  sys     106% |  user      4% |  irq       0%  | idle    28=
8%  |  wait      1% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > > cpu |  sys      93% |  user      0% |  irq       0%  | idle      =
7%  |  cpu002 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > > cpu |  sys       7% |  user      0% |  irq       0%  | idle     9=
3%  |  cpu003 w  0% |  guest     0% |  curf 3.01GHz  | curscal  94%  |
> > > cpu |  sys       3% |  user      2% |  irq       0%  | idle     9=
4%  |  cpu000 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > > cpu |  sys       3% |  user      2% |  irq       0%  | idle     9=
5%  |  cpu001 w  0% |  guest     0% |  curf 3.00GHz  | curscal  93%  |
> > > CPL |  avg1    3.33 |  avg5    1.56 |  avg15   1.20  |           =
    |  csw    38253 |  intr   23104 |                | numcpu     4  |
> > > MEM |  tot    15.5G |  free    4.9G |  cache   8.7G  | buff    0.=
0M  |  slab  336.5M |  shmem 207.2M |  vmbal   0.0M  | hptot   0.0M  |
> > > SWP |  tot    12.0G |  free   11.7G |                |           =
    |               |               |  vmcom   3.4G  | vmlim  19.7G  |
> > > LVM |    msata-home |  busy      2% |  read       0  | write   23=
37  |  KiB/w      3 |  MBr/s   0.00 |  MBw/s   0.91  | avio 0.07 ms  |
> > > LVM |     sata-home |  busy      2% |  read      36  | write   23=
37  |  KiB/w      3 |  MBr/s   0.01 |  MBw/s   0.91  | avio 0.07 ms  |
> > > LVM |  msata-debian |  busy      1% |  read       1  | write   16=
30  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.65  | avio 0.03 ms  |
> > > LVM |   sata-debian |  busy      0% |  read       0  | write   10=
19  |  KiB/w      4 |  MBr/s   0.00 |  MBw/s   0.41  | avio 0.02 ms  |
> > > DSK |           sdb |  busy      2% |  read       1  | write   25=
45  |  KiB/w      5 |  MBr/s   0.00 |  MBw/s   1.45  | avio 0.07 ms  |
> > > DSK |           sda |  busy      1% |  read      36  | write   24=
61  |  KiB/w      5 |  MBr/s   0.01 |  MBw/s   1.28  | avio 0.06 ms  |
> > > NET |  transport    |  tcpi      20 |  tcpo      20  | udpi      =
 1  |  udpo       1 |  tcpao      1 |  tcppo      1  | tcprs      0  |
> > > NET |  network      |  ipi       21 |  ipo       21  | ipfrw     =
 0  |  deliv     21 |               |  icmpi      0  | icmpo      0  |
> > > NET |  eth0      0% |  pcki       5 |  pcko       5  | si    0 Kb=
ps  |  so    0 Kbps |  erri       0 |  erro       0  | drpo       0  |
> > > NET |  lo      ---- |  pcki      16 |  pcko      16  | si    2 Kb=
ps  |  so    2 Kbps |  erri       0 |  erro       0  | drpo       0  |
> > >=20
> > >   PID    TID   RUID      EUID        THR  SYSCPU   USRCPU   VGROW=
    RGROW   RDDSK    WRDSK  ST   EXC  S   CPUNR   CPU   CMD        1/3
> > > 17450      -   root      root          1   9.96s    0.00s      0K=
       0K      0K       0K  --     -  R       2  100%   kworker/u8:5
> > >  4746      -   martin    martin        2   0.06s    0.15s      0K=
       0K      0K       0K  --     -  S       1    2%   konsole
> > > 10508      -   root      root          1   0.13s    0.00s      0K=
       0K     96K    4048K  --     -  S       1    1%   kworker/u8:18
> > >  1488      -   root      root          1   0.06s    0.06s      0K=
       0K      0K       0K  --     -  S       0    1%   Xorg
> > > 17332      -   root      root          1   0.12s    0.00s      0K=
       0K     96K     580K  --     -  R       3    1%   kworker/u8:4
> > > 17454      -   root      root          1   0.11s    0.00s      0K=
       0K     32K    4416K  --     -  D       1    1%   kworker/u8:6
> > > 17516      -   root      root          1   0.09s    0.00s      0K=
       0K     16K     136K  --     -  S       3    1%   kworker/u8:7
> > >  3268      -   martin    martin        3   0.02s    0.05s      0K=
       0K      0K       0K  --     -  S       1    1%   kwin
> > > 10036      -   root      root          1   0.05s    0.02s      0K=
       0K      0K       0K  --     -  R       0    1%   atop
> > >=20
> > >=20
> > >=20
> > > So BTRFS is basically busy with itself and nothing else. Look at =
the SSD
> > > usage. They are *idling* around. Heck 2400 write accesses in 10 s=
econds.
> > > Thats a joke with SSDs that can do 40000 IOPS (depending on how a=
nd what
> > > you measure of course, like request size, read, write, iodepth an=
d so).
> > >=20
> > > Its kworker/u8:5 utilizing 100% of one core for minutes.
> > >=20
> > >=20
> > >=20
> > > Its the random write case it seems. Here are values from fio job:=

> > >=20
> > > martin@merkaba:~> fio ssd-test.fio
> > > seq-write: (g=3D0): rw=3Dwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3D=
sync, iodepth=3D1
> > > rand-write: (g=3D1): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioen=
gine=3Dsync, iodepth=3D1
> > > fio-2.1.11
> > > Starting 2 processes
> > > Jobs: 1 (f=3D1): [_(1),w(1)] [3.6% done] [0KB/0KB/0KB /s] [0/0/0 =
iops] [eta 01h:06m:26s]
> > > seq-write: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D19212: Sat De=
c 27 13:48:33 2014
> > >   write: io=3D4096.0MB, bw=3D343683KB/s, iops=3D85920, runt=3D 12=
204msec
> > >     clat (usec): min=3D3, max=3D38048, avg=3D10.52, stdev=3D205.2=
5
> > >      lat (usec): min=3D3, max=3D38048, avg=3D10.66, stdev=3D205.4=
3
> > >     clat percentiles (usec):
> > >      |  1.00th=3D[    4],  5.00th=3D[    4], 10.00th=3D[    4], 2=
0.00th=3D[    4],
> > >      | 30.00th=3D[    4], 40.00th=3D[    5], 50.00th=3D[    5], 6=
0.00th=3D[    5],
> > >      | 70.00th=3D[    7], 80.00th=3D[    8], 90.00th=3D[    8], 9=
5.00th=3D[    9],
> > >      | 99.00th=3D[   14], 99.50th=3D[   20], 99.90th=3D[  211], 9=
9.95th=3D[ 2128],
> > >      | 99.99th=3D[10304]
> > >     bw (KB  /s): min=3D164328, max=3D812984, per=3D100.00%, avg=3D=
345585.75, stdev=3D201695.20
> > >     lat (usec) : 4=3D0.18%, 10=3D95.31%, 20=3D4.00%, 50=3D0.18%, =
100=3D0.12%
> > >     lat (usec) : 250=3D0.12%, 500=3D0.02%, 750=3D0.01%, 1000=3D0.=
01%
> > >     lat (msec) : 2=3D0.01%, 4=3D0.01%, 10=3D0.03%, 20=3D0.01%, 50=
=3D0.01%
> > >   cpu          : usr=3D13.55%, sys=3D46.89%, ctx=3D7810, majf=3D0=
, minf=3D6
> > >   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0=
.0%, 32=3D0.0%, >=3D64=3D0.0%
> > >      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, >=3D64=3D0.0%
> > >      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, >=3D64=3D0.0%
> > >      issued    : total=3Dr=3D0/w=3D1048576/d=3D0, short=3Dr=3D0/w=
=3D0/d=3D0
> > >      latency   : target=3D0, window=3D0, percentile=3D100.00%, de=
pth=3D1
> > >=20
> > > Seems fine.
> > >=20
> > >=20
> > > But:
> > >=20
> > > rand-write: (groupid=3D1, jobs=3D1): err=3D 0: pid=3D19243: Sat D=
ec 27 13:48:33 2014
> > >   write: io=3D140336KB, bw=3D1018.4KB/s, iops=3D254, runt=3D13780=
3msec
> > >     clat (usec): min=3D4, max=3D21299K, avg=3D3708.02, stdev=3D26=
6885.61
> > >      lat (usec): min=3D4, max=3D21299K, avg=3D3708.14, stdev=3D26=
6885.61
> > >     clat percentiles (usec):
> > >      |  1.00th=3D[    4],  5.00th=3D[    5], 10.00th=3D[    5], 2=
0.00th=3D[    5],
> > >      | 30.00th=3D[    6], 40.00th=3D[    6], 50.00th=3D[    6], 6=
0.00th=3D[    6],
> > >      | 70.00th=3D[    7], 80.00th=3D[    7], 90.00th=3D[    9], 9=
5.00th=3D[   10],
> > >      | 99.00th=3D[   18], 99.50th=3D[   19], 99.90th=3D[   28], 9=
9.95th=3D[  116],
> > >      | 99.99th=3D[16711680]
> > >     bw (KB  /s): min=3D    0, max=3D 3426, per=3D100.00%, avg=3D1=
030.10, stdev=3D938.02
> > >     lat (usec) : 10=3D92.63%, 20=3D6.89%, 50=3D0.43%, 100=3D0.01%=
, 250=3D0.02%
> > >     lat (msec) : 250=3D0.01%, 500=3D0.01%, >=3D2000=3D0.02%
> > >   cpu          : usr=3D0.06%, sys=3D1.59%, ctx=3D28720, majf=3D0,=
 minf=3D7
> > >   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0=
.0%, 32=3D0.0%, >=3D64=3D0.0%
> > >      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, >=3D64=3D0.0%
> > >      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, >=3D64=3D0.0%
> > >      issued    : total=3Dr=3D0/w=3D35084/d=3D0, short=3Dr=3D0/w=3D=
0/d=3D0
> > >      latency   : target=3D0, window=3D0, percentile=3D100.00%, de=
pth=3D1
> > >=20
> > > Run status group 0 (all jobs):
> > >   WRITE: io=3D4096.0MB, aggrb=3D343682KB/s, minb=3D343682KB/s, ma=
xb=3D343682KB/s, mint=3D12204msec, maxt=3D12204msec
> > >=20
> > > Run status group 1 (all jobs):
> > >   WRITE: io=3D140336KB, aggrb=3D1018KB/s, minb=3D1018KB/s, maxb=3D=
1018KB/s, mint=3D137803msec, maxt=3D137803msec
> > >=20
> > >=20
> > > What? 254 IOPS? With a Dual SSD BTRFS RAID 1?
> > >=20
> > > What?
> > >=20
> > > Ey, *what*?
> [=E2=80=A6]=20
> > > There we go:
> > >=20
> > > Bug 90401 - btrfs kworker thread uses up 100% of a Sandybridge co=
re for minutes on random write into big file
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D90401
> >=20
> > I have done more tests.
> >=20
> > This is on the same /home after extending it to 170 GiB and balanci=
ng it to
> > btrfs balance start -dusage=3D80
> >=20
> > It has plenty of free space free. I updated the bug report and hope=
 it can
> > give an easy enough to comprehend summary. The new tests are in:
> >=20
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D90401#c6
> >=20
> >=20
> >=20
> > Pasting below for discussion on list. Summary: I easily get 38000 (=
!)
> > IOPS. It may be an idea to reduce to 160 GiB, but right now this do=
es
> > not work as it says no free space on device when trying to downsize=
 it.
> > I may try with 165 or 162GiB.
> >=20
> > So now we have three IOPS figures:
> >=20
> > - 256 IOPS in worst case scenario
> > - 4700 IOPS when trying to reproduce worst case scenario with a fre=
sh and small
> > BTRFS
> > - 38000 IOPS when /home has unused device space to allocate chunks =
from
> >=20
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D90401#c8
> >=20
> >=20
> > This is another test.
>=20
>=20
> Okay, and this is the last series of tests for today.
>=20
> Conclusion:
>=20
> I cannot manage to get it down to the knees as before, but I come nea=
r to it.
>=20
> Still its 8000 IOPS, instead of 250 IOPS, in an according to btrfs fi=
 sh
> even *worse* situation than before.
>=20
> That hints me at the need to look at the free space fragmentation, as=
 in the
> beginning the problem started appearing with:
>=20
> merkaba:~> btrfs fi sh /home
> Label: 'home'  uuid: [=E2=80=A6]
>         Total devices 2 FS bytes used 144.41GiB
>         devid    1 size 160.00GiB used 160.00GiB path /dev/mapper/msa=
ta-home
>         devid    2 size 160.00GiB used 160.00GiB path /dev/mapper/sat=
a-home
>=20
> Btrfs v3.17
> merkaba:~> btrfs fi df /home
> Data, RAID1: total=3D154.97GiB, used=3D141.12GiB
> System, RAID1: total=3D32.00MiB, used=3D48.00KiB
> Metadata, RAID1: total=3D5.00GiB, used=3D3.29GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
>=20
>=20
> Yes, thats 13 GiB of free space *within* the chunks.
>=20
> So while I can get it down in IOPS by bringing it to a situation wher=
e it
> can not reserve additional data chunks again, I cannot recreate the
> abysmal 250 IOPS figure by this. Not even with my /home filesystem.
>=20
> So there is more to it. I think its important to look into free space=

> fragmentation. It seems it needs an *aged* filesystem to recreate. At=

> it seems the balances really helped. As I am not able to recreate the=

> issue to that extent right now.
>=20
> So this shows my original idea about free device space to allocate fr=
om
> also doesn=C2=B4t explain it fully. It seems to be something thats go=
ing on
> within the chunks that explains the worst case <300 IOPS, kworker usi=
ng
> one core for minutes and desktop locked scenario.
>=20
> Is there a way to view free space fragmentation in BTRFS?

So to rephrase that:

From=20what I perceive the worst case issue happens when

1) BTRFS cannot reserve any new chunks from unused device space anymore=
.

2) The free space in the existing chunks is highly fragmented.

Only one of those conditions is not sufficient to trigger it.

Thats at least my current idea about it.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart2421399.6FVboQBYHY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlSgDAUACgkQmRvqrKWZhMepSQCeKgq3S3A4tOnDF3hbFB6DM8V5
LNwAn3GHBCaKbkVANC5vJLVNHZRNlmmc
=g7K/
-----END PGP SIGNATURE-----

--nextPart2421399.6FVboQBYHY--

