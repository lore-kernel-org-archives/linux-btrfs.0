From: "Mr. Tux" <tuxoholic@hotmail.de>
Subject: BTRFS raid fails to write with 4096 blocksize
Date: Thu, 18 Feb 2010 15:21:49 +0100
Message-ID: <BLU120-W29851D6F70157154E6A47AD8470@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Hi list

I tried to copy data from btrfs raid1 to another btrfs raid1 array. To =
increase the input/output blocksize from 512k to something bigger (4096=
k) I used dd_rescue.

zeros.bin input file is a 1GB size clone of /dev/zero:=A0 dd_rescue -vw=
dDm1G /dev/zero /mnt/xxx/zeros.bin

now the actual copying process from /mnt/xxx to /mnt/yyy :

dd_rescue -vwdDm1 /mnt/xxx/zeros.bin /mnt/yyy/zeros.bin

resulting in this error message and no data written into /mnt/yyy :

dd_rescue: (warning): O_DIRECT requires hardbs of at least 4096!
dd_rescue: (warning): We don't handle misalignment of last block w/ O_D=
IRECT!
dd_rescue: (info): about to transfer 0.0 kBytes from /mnt/xxx/zeros.bin=
 to /mnt/yyy/zeros.bin
dd_rescue: (info): blocksizes: soft 65536, hard 4096
dd_rescue: (info): starting positions: in 0.0k, out 0.0k
dd_rescue: (info): Logfile: (none), Maxerr: 0
dd_rescue: (info): Reverse: no , Trunc: no , interactive: no=20
dd_rescue: (info): abort on Write errs: yes, spArse write: if err
dd_rescue: (info): ipos:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k, opos:=A0=A0=A0=A0=
=A0=A0=A0=A0 0.0k, xferd:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 errs:=A0=A0=A0=A0=
=A0 0, errxfer:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k, succxfer:=A0=A0=A0=A0=A0=A0=
=A0=A0 0.0k
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 +curr.rate:=A0=A0=A0=A0=A0=A0=A0 0=
kB/s, avg.rate:=A0=A0=A0=A0=A0=A0=A0 0kB/s, avg.load:=A0 0.0%
dd_rescue: (info): problems at ipos 0.0k: Invalid argument=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fall back to smaller b=
locksize=20
dd_rescue: (info): ipos:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k, opos:=A0=A0=A0=A0=
=A0=A0=A0=A0 0.0k, xferd:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=A0 errs:=A0=A0=A0=A0=A0=
 0, errxfer:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k, succxfer:=A0=A0=A0=A0=A0=A0=A0=
=A0 0.0k
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 +curr.rate:=A0=A0=A0=A0=A0=A0=A0 0=
kB/s, avg.rate:=A0=A0=A0=A0=A0=A0=A0 0kB/s, avg.load:=A0 0.0%
dd_rescue: (warning): /mnt/xxx/zeros.bin (0.0k): Invalid argument!



Bad block: 0
dd_rescue: (info): ipos 0.0k promote to large bs again!=20



Summary for /mnt/xxx/zeros.bin -> /mnt/yyy/zeros.bin:
dd_rescue: (info): ipos:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k, opos:=A0=A0=A0=A0=
=A0=A0=A0=A0 0.0k, xferd:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 errs:=A0=A0=A0=A0=
=A0 1, errxfer:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k, succxfer:=A0=A0=A0=A0=A0=A0=
=A0=A0 0.0k
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 +curr.rate:=A0=A0=A0=A0=A0=A0 10kB=
/s, avg.rate:=A0=A0=A0=A0=A0=A0=A0 0kB/s, avg.load:=A0 0.0%

----------------

If I don't use "dD" option it runs fine with a 512k blocksize

* OS in use is debian/squeeze
* kernel: 2.6.32-trunk-686 (linux-image-2.6.32-trunk-686)
* apt-cache policy btrfs-tools
=A0 btrfs-tools:
=A0 installed: 0.19-8
=A0 candidate: 0.19-8

Raids where created like this:

mkfs.btrfs -d raid1 -m raid1 /dev/sdb1 /dev/sdc1
mkfs.btrfs -d raid1 -m raid1 /dev/sdb2 /dev/sdc2

cat /proc/mounts | grep btrfs
/dev/sdb1 /mnt/xxx btrfs rw,relatime 0 0
/dev/sdb2 /mnt/yyy btrfs rw,relatime 0 0

I believe this is a bug - feel free to share your thoughts
 		 	   		 =20
_________________________________________________________________
http://redirect.gimas.net/?n=3DM1002xHMValentin2
Herzig: Verschicke fertige Liebesgr=FC=DFe als E-Mail! --
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
