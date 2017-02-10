Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60387 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750910AbdBJWUw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 17:20:52 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LjIBr-1bzfYd2qeV-00dWEv for
 <linux-btrfs@vger.kernel.org>; Fri, 10 Feb 2017 23:20:48 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already exists
Date: Fri, 10 Feb 2017 23:15:03 +0100
Message-ID: <2314132.jQCgNOg6dG@thetick>
In-Reply-To: <20170203234410.7ef21de7@jupiter.sol.kaishome.de>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de> <11009787.rdtfuSitqF@thetick> <20170203234410.7ef21de7@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart51273246.7GWCsCyigd"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart51273246.7GWCsCyigd
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Sorry for the late reply, see below for why :) .

On Friday 03 February 2017 23:44:10 Kai Krakow wrote:
> Am Thu, 02 Feb 2017 13:01:03 +0100
>=20
> schrieb Marc Joliet <marcec@gmx.de>:
[...]
> > > Btrfs --repair refused to repair the filesystem telling me someth=
ing
> > > about compressed extents and an unsupported case, wanting me to
> > > take an image and send it to the devs. *sigh*
> >=20
> > I haven't tried a repair yet; it's a big file system, and btrfs-che=
ck
> > is still running:
> >=20
> > # btrfs check -p /dev/sdd2
> > Checking filesystem on /dev/sdd2
> > UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
> > parent transid verify failed on 3829276291072 wanted 224274 found
> > 283858 parent transid verify failed on 3829276291072 wanted 224274
> > found 283858 parent transid verify failed on 3829276291072 wanted
> > 224274 found 283858 parent transid verify failed on 3829276291072
> > wanted 224274 found 283858 Ignoring transid failure
> > leaf parent key incorrect 3829276291072
> > bad block 3829276291072
> >=20
> > ERROR: errors found in extent allocation tree or chunk allocation
> > block group 4722282987520 has wrong amount of free space
> > failed to load free space cache for block group 4722282987520
> > checking free space cache [O]
> > root 32018 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32089 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32091 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32092 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32107 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32189 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32190 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32191 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32265 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32266 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32409 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32410 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32411 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32412 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32413 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32631 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32632 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32633 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32634 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32635 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32636 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32718 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32732 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > checking fs roots [o]
> >=20
> > I know that the "file extend discount" errors are fixable from my
> > previous email to this ML, but what about the rest?  From looking
> > through the ML archives it seems that --repair won't be able to fix=

> > the transid failures.  It seems that one person had success with th=
e
> > "usebackuproot" mount option, which I haven't tried yet.

Well, it turns out that the problem fixed itself.  After check finished=
, I=20
tried mounting the FS normally, which succeeded.  Shortly after, btrfs-=
cleaner=20
started removing deleted snapshots.  About 40 minutes later I got the e=
rror=20
again:

Feb 02 22:49:14 thetick kernel: BTRFS: device label MARCEC_BACKUP devid=
 1=20
transid 283903 /dev/sdd2
Feb 02 22:49:19 thetick kernel: EXT4-fs (sdd1): mounted filesystem with=
=20
ordered data mode. Opts: (null)
Feb 03 00:18:52 thetick kernel: BTRFS info (device sdd2): use zlib comp=
ression
Feb 03 00:18:52 thetick kernel: BTRFS info (device sdd2): disk space ca=
ching=20
is enabled
Feb 03 00:18:52 thetick kernel: BTRFS info (device sdd2): has skinny ex=
tents
Feb 03 00:20:09 thetick kernel: BTRFS info (device sdd2): The free spac=
e cache=20
file (3967375376384) is invalid. skip it
Feb 03 01:05:58 thetick kernel: ------------[ cut here ]------------
Feb 03 01:05:58 thetick kernel: WARNING: CPU: 1 PID: 26544 at fs/btrfs/=
extent-
tree.c:2967 btrfs_run_delayed_refs+0x26c/0x290
Feb 03 01:05:58 thetick kernel: BTRFS: Transaction aborted (error -17)
Feb 03 01:05:58 thetick kernel: Modules linked in: dummy iptable_filter=
=20
ip_tables x_tables joydev hid_logitech_hidpp hid_logitech_dj=20
snd_hda_codec_hdmi snd_hda_codec_analog snd_hda_codec_generic uvcvideo=20=

videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core sn
Feb 03 01:05:58 thetick kernel:  ehci_pci ohci_hcd ehci_hcd
Feb 03 01:05:58 thetick kernel: CPU: 1 PID: 26544 Comm: btrfs-cleaner N=
ot=20
tainted 4.9.7-gentoo #1
Feb 03 01:05:58 thetick kernel: Hardware name: System manufacturer Syst=
em=20
Product Name/M2N-E, BIOS ASUS M2N-E ACPI BIOS Revision 1701 10/30/2008
Feb 03 01:05:58 thetick kernel:  0000000000000000 ffffffff8137af83=20
ffffc90000a4fd30 0000000000000000
Feb 03 01:05:58 thetick kernel:  ffffffff810537ad ffff880138b2ec80=20
ffffc90000a4fd80 ffff880138b4e850
Feb 03 01:05:58 thetick kernel:  00000000ffffffef 00000000000000f2=20
ffff880138b2ec80 ffffffff8105381a
Feb 03 01:05:58 thetick kernel: Call Trace:
Feb 03 01:05:58 thetick kernel:  [<ffffffff8137af83>] ? dump_stack+0x46=
/0x63
Feb 03 01:05:58 thetick kernel:  [<ffffffff810537ad>] ? __warn+0xed/0x1=
10
Feb 03 01:05:58 thetick kernel:  [<ffffffff8105381a>] ?=20
warn_slowpath_fmt+0x4a/0x50
Feb 03 01:05:58 thetick kernel:  [<ffffffff81286f7a>] ?=20
__btrfs_run_delayed_refs+0x11ba/0x1390
Feb 03 01:05:58 thetick kernel:  [<ffffffff8128a2ec>] ?=20
btrfs_run_delayed_refs+0x26c/0x290
Feb 03 01:05:58 thetick kernel:  [<ffffffff81287fbe>] ?=20
walk_up_tree+0xde/0x1d0
Feb 03 01:05:58 thetick kernel:  [<ffffffff8129f6d5>] ?=20
btrfs_should_end_transaction+0x45/0x80
Feb 03 01:05:58 thetick kernel:  [<ffffffff81288851>] ?=20
btrfs_drop_snapshot+0x401/0x7a0
Feb 03 01:05:58 thetick kernel:  [<ffffffff812a09f6>] ?=20
btrfs_clean_one_deleted_snapshot+0xb6/0xf0
Feb 03 01:05:58 thetick kernel:  [<ffffffff8129757f>] ?=20
cleaner_kthread+0x13f/0x1b0
Feb 03 01:05:58 thetick kernel:  [<ffffffff81297440>] ?=20
btrfs_destroy_pinned_extent+0xc0/0xc0
Feb 03 01:05:58 thetick kernel:  [<ffffffff81070ee9>] ? kthread+0xb9/0x=
d0
Feb 03 01:05:58 thetick kernel:  [<ffffffff81070e30>] ? kthread_park+0x=
70/0x70
Feb 03 01:05:58 thetick kernel:  [<ffffffff8160dfd2>] ?=20
ret_from_fork+0x22/0x30
Feb 03 01:05:58 thetick kernel: ---[ end trace 9b83fb0ab757cd99 ]---
Feb 03 01:05:58 thetick kernel: BTRFS: error (device sdd2) in=20
btrfs_run_delayed_refs:2967: errno=3D-17 Object already exists
Feb 03 01:05:58 thetick kernel: BTRFS info (device sdd2): forced readon=
ly
Feb 03 01:26:39 thetick kernel: BTRFS error (device sdd2): cleaner tran=
saction=20
attach returned -30
Feb 03 01:26:59 thetick kernel: BTRFS info (device sdd2): use zlib comp=
ression
Feb 03 01:26:59 thetick kernel: BTRFS info (device sdd2): disk space ca=
ching=20
is enabled
Feb 03 01:26:59 thetick kernel: BTRFS info (device sdd2): has skinny ex=
tents
Feb 03 01:27:44 thetick kernel: BTRFS info (device sdd2): The free spac=
e cache=20
file (4690842484736) is invalid. skip it

I then mounted it again, after which btrfs-cleaner resumed its task:

Feb 03 09:54:05 thetick kernel: BTRFS info (device sdd2): use zlib comp=
ression
Feb 03 09:54:05 thetick kernel: BTRFS info (device sdd2): disk space ca=
ching=20
is enabled
Feb 03 09:54:05 thetick kernel: BTRFS info (device sdd2): has skinny ex=
tents

This time it finished successfully, after that there are no more messag=
es=20
pertaining to that file system in dmesg.

I then ran btrfs-check again, which didn't find the transid errors any =
more:

# btrfs check -p /dev/sdd2
Checking filesystem on /dev/sdd2
UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
checking extents [o]
block group 4722282987520 has wrong amount of free space
failed to load free space cache for block group 4722282987520
checking free space cache [o]
root 32018 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32089 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32091 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32092 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32107 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32189 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32190 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32191 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32265 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32266 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32409 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32410 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32411 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32412 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32413 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32631 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32632 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32633 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32634 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32635 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32636 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32718 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32732 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32830 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32832 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32833 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32834 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32903 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 32961 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
root 33002 inode 95066 errors 100, file extent discount
Found file extent holes:
        start: 413696, len: 4096
checking fs roots [O]
found 901576467411 bytes used err is 1
total csum bytes: 871524676
total tree bytes: 11151159296
total fs tree bytes: 8709533696
total extent tree bytes: 1307844608
btree space waste bytes: 2428036988
file data blocks allocated: 17604037283840
 referenced 1003776770048

So, since the error was now limited to something btrfs-check could repa=
ir, I=20
ran check with --repair:

# btrfs check -p --repair /dev/sdd2
enabling repair mode
Checking filesystem on /dev/sdd2
UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
checking extents [O]o]
Fixed 0 roots.
cache and super generation don't match, space cache will be invalidated=

Fixed discount file extents for inode: 95066 in root: 32018
Fixed discount file extents for inode: 95066 in root: 32089
Fixed discount file extents for inode: 95066 in root: 32091
Fixed discount file extents for inode: 95066 in root: 32092
Fixed discount file extents for inode: 95066 in root: 32107
Fixed discount file extents for inode: 95066 in root: 32189
Fixed discount file extents for inode: 95066 in root: 32190
Fixed discount file extents for inode: 95066 in root: 32191
Fixed discount file extents for inode: 95066 in root: 32265
Fixed discount file extents for inode: 95066 in root: 32266
Fixed discount file extents for inode: 95066 in root: 32409
Fixed discount file extents for inode: 95066 in root: 32410
Fixed discount file extents for inode: 95066 in root: 32411
Fixed discount file extents for inode: 95066 in root: 32412
Fixed discount file extents for inode: 95066 in root: 32413
Fixed discount file extents for inode: 95066 in root: 32631
Fixed discount file extents for inode: 95066 in root: 32632
Fixed discount file extents for inode: 95066 in root: 32633
Fixed discount file extents for inode: 95066 in root: 32634
Fixed discount file extents for inode: 95066 in root: 32635
Fixed discount file extents for inode: 95066 in root: 32636
Fixed discount file extents for inode: 95066 in root: 32718
Fixed discount file extents for inode: 95066 in root: 32732
Fixed discount file extents for inode: 95066 in root: 32830ts [O]
Fixed discount file extents for inode: 95066 in root: 32832
Fixed discount file extents for inode: 95066 in root: 32833
btrfs unable to find ref byte nr 4607605415936 parent 0 root 32834  own=
er 0=20
offset 1
Fixed discount file extents for inode: 95066 in root: 32834
Fixed discount file extents for inode: 95066 in root: 32903
Fixed discount file extents for inode: 95066 in root: 32961
Fixed discount file extents for inode: 95066 in root: 33002
warning line 4112 [.]

checking csums
checking root refs
found 901576467411 bytes used err is 0
total csum bytes: 871524676
total tree bytes: 11151159296
total fs tree bytes: 8709533696
total extent tree bytes: 1307844608
btree space waste bytes: 2428036988
file data blocks allocated: 17604037283840
 referenced 1003776770048

This, BTW, *just* completed a few hours ago, i.e., it took almost a ful=
l week=20
(it started on Friday, February 3rd, at about 20:53:35, and finished to=
day at=20
20:42:48).  Since it required between about 75% and 85% of the measly 4=
GB of=20
RAM my desktop has, I decided not to use it for the duration of the --r=
epair=20
run, which is why I haven't replied until now (since that's the machine=
 I use=20
for private email).  Running check without --repair, on the other hand,=
 took=20
only 9-10 hours.

Right now I have a scrub running, the status of which is, at the moment=
 of=20
writing:

# btrfs scrub status /media/MARCEC_BACKUP
scrub status for f97b3cda-15e8-418b-bb9b-235391ef2a38
        scrub started at Fri Feb 10 21:00:36 2017, running for 02:14:05=

        total bytes scrubbed: 631.51GiB with 0 errors

(which is about 2x slower than expected so far)

Otherwise, since I have the FS mounted now, I can now show this:

# btrfs filesystem show /media/MARCEC_BACKUP/
Label: 'MARCEC_BACKUP'  uuid: f97b3cda-15e8-418b-bb9b-235391ef2a38
        Total devices 1 FS bytes used 841.75GiB
        devid    1 size 976.56GiB used 878.25GiB path /dev/sdd2

# btrfs filesystem usage /media/MARCEC_BACKUP/
Overall:
    Device size:                 976.56GiB
    Device allocated:            878.25GiB
    Device unallocated:           98.31GiB
    Device missing:                  0.00B
    Used:                        852.13GiB
    Free (estimated):            117.95GiB      (min: 68.80GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.92
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:851.00GiB, Used:831.36GiB
   /dev/sdd2     851.00GiB

Metadata,single: Size:1.12GiB, Used:0.00B
   /dev/sdd2       1.12GiB

Metadata,DUP: Size:13.00GiB, Used:10.38GiB
   /dev/sdd2      26.00GiB

System,DUP: Size:64.00MiB, Used:120.00KiB
   /dev/sdd2     128.00MiB

Unallocated:
   /dev/sdd2      98.31GiB

# btrfs filesystem df /media/MARCEC_BACKUP/  =20
Data, single: total=3D851.00GiB, used=3D831.36GiB
System, DUP: total=3D64.00MiB, used=3D120.00KiB
Metadata, DUP: total=3D13.00GiB, used=3D10.38GiB
Metadata, single: total=3D1.12GiB, used=3D0.00B
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

Hmm, I take it that the single metadata is a leftover from running --re=
pair?

[...]
> > The system the drive runs on is:
> >=20
> > % uname -a
> > Linux diefledermaus 4.9.7-gentoo #1 SMP Wed Feb 1 23:52:56 CET 2017=

> > x86_64 Intel(R) Core(TM)2 CPU T5600 @ 1.83GHz GenuineIntel GNU/Linu=
x
> >=20
> > However during the crash it was running 4.9.6-gentoo.  The system
> > uses the standard CFQ scheduler, so perhaps BFQ is not at fault in
> > Kai's case.
> >=20
> > The system I am running btrfs-check on is:
> >=20
> > % uname -a
> > Linux thetick 4.9.6-gentoo #1 SMP PREEMPT Fri Jan 27 00:50:02 CET
> > 2017 x86_64 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
> > AuthenticAMD GNU/Linux
> >=20
> > Both have btrfs-progs 4.9:
> >=20
> > % /sbin/btrfs --version
> > btrfs-progs v4.9
> >=20
> > And the file system in question:
> >=20
> > % sudo /sbin/btrfs fi show /dev/sdd2
> > Label: 'MARCEC_BACKUP'  uuid:
> > f97b3cda-15e8-418b-bb9b-235391ef2a38 Total devices 1 FS bytes used
> > 842.50GiB devid    1 size 976.56GiB used 877.31GiB path /dev/sdd2
> >=20
> > The file system is mounted with
> > "noatime,compress,comment=3Dsystemd.automount".
>=20
> So our common denominator is only "compress". Well, and systemd and
> Gentoo - but that probably doesn't count.

Yeah, probably not :) .

> It looks like you're running without bcache and on a single disk.

Exactly.

> Do you use files that should maybe better be marked nocow? (chattr
> +C)... in terms like VirtualBox images or database files?

Nope.  It's used exclusively as a target for btrfs-receive and rsync (O=
K, my=20
music backups are also used by MPD on the home server it's normally att=
ached=20
to, as an alternative to leaving my desktop running just to hear music,=
 but=20
that's it).

[...]

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart51273246.7GWCsCyigd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYnjtoAAoJEL/Q5oYsiHj0dp8P/jyCb+jRnFGUg0UXqNA9WLgF
6d4BPtCiJbDwrM/wry4INzyggc5grc+w42OzbZFB6NSCMGlwdwOA51//55txfUfO
mRRpRiXvtuIlZojpaGEI6cF4FMHLZ5xouD9C0cujZuVE1t93jN8rfucLyKgcj4+7
5yEDK3n+4mICCbb2Yt7v/FJMuHr9wLKxomeZfsn2CWDHEQK8gEtI5qzRxkGUWjY9
tXGdVFruynKpr/4BKZ/VLpKTZHuqvablWnAVNnR1uSJLkFwRa45/oEK0/6sshJ+a
Ve4SbELjHoMl1GuUZ1gTyhFjkV4X/RrzCdW2n7UcPj8lTxd0JukSxc6EgA6yCn7I
RzZG5EH3DfxZuZwd1D8t7TnoTdLNprzvOQxmZIuw0SMtU1xwGtKo3XVgbKajzdLM
P+hjgVAhBAkaaTHcWBoBWZNb2CLtf2NqwgerstOHqWQudI9gUphKORf9RAQL3Keq
Nx+XlRTqDjTfzMDKqg6bSITdd7RTfk3Cxc5f9gSSrH42p0xN1FTEggpbirzmI07A
UW5pagonG4P6DmI0S0mFpbvmdn+Ar9gQqBONwVfg3oAztqBoQv1V/2J8Oite+DLw
IBCpr6x7CRt+KB2xZ4/Ju2+FoHEwMZdH6Y9kV6j3ktES/TTtbQ4xupK4JuWQC75D
EqxDytjW+TCe4UG8Ckkv
=9FIn
-----END PGP SIGNATURE-----

--nextPart51273246.7GWCsCyigd--

