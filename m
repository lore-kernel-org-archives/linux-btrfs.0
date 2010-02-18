From: Josef Bacik <josef@redhat.com>
Subject: Re: BTRFS raid fails to write with 4096 blocksize
Date: Thu, 18 Feb 2010 11:05:53 -0500
Message-ID: <20100218160553.GB15098@dhcp231-156.rdu.redhat.com>
References: <BLU120-W29851D6F70157154E6A47AD8470@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Mr. Tux" <tuxoholic@hotmail.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BLU120-W29851D6F70157154E6A47AD8470@phx.gbl>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2010 at 03:21:49PM +0100, Mr. Tux wrote:
>=20
> Hi list
>=20
> I tried to copy data from btrfs raid1 to another btrfs raid1 array. T=
o increase the input/output blocksize from 512k to something bigger (40=
96k) I used dd_rescue.
>=20
> zeros.bin input file is a 1GB size clone of /dev/zero:=A0 dd_rescue -=
vwdDm1G /dev/zero /mnt/xxx/zeros.bin
>=20
> now the actual copying process from /mnt/xxx to /mnt/yyy :
>=20
> dd_rescue -vwdDm1 /mnt/xxx/zeros.bin /mnt/yyy/zeros.bin
>=20
> resulting in this error message and no data written into /mnt/yyy :
>=20
> dd_rescue: (warning): O_DIRECT requires hardbs of at least 4096!
> dd_rescue: (warning): We don't handle misalignment of last block w/ O=
_DIRECT!
> dd_rescue: (info): about to transfer 0.0 kBytes from /mnt/xxx/zeros.b=
in to /mnt/yyy/zeros.bin
> dd_rescue: (info): blocksizes: soft 65536, hard 4096
> dd_rescue: (info): starting positions: in 0.0k, out 0.0k
> dd_rescue: (info): Logfile: (none), Maxerr: 0
> dd_rescue: (info): Reverse: no , Trunc: no , interactive: no=20
> dd_rescue: (info): abort on Write errs: yes, spArse write: if err
> dd_rescue: (info): ipos:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k, opos:=A0=A0=A0=
=A0=A0=A0=A0=A0 0.0k, xferd:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 errs:=A0=A0=A0=
=A0=A0 0, errxfer:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k, succxfer:=A0=A0=A0=A0=A0=
=A0=A0=A0 0.0k
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 +curr.rate:=A0=A0=A0=A0=A0=A0=A0=
 0kB/s, avg.rate:=A0=A0=A0=A0=A0=A0=A0 0kB/s, avg.load:=A0 0.0%
> dd_rescue: (info): problems at ipos 0.0k: Invalid argument=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fall back to smaller=
 blocksize=20
> dd_rescue: (info): ipos:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k, opos:=A0=A0=A0=
=A0=A0=A0=A0=A0 0.0k, xferd:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=A0 errs:=A0=A0=A0=A0=A0=
 0, errxfer:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k, succxfer:=A0=A0=A0=A0=A0=A0=A0=
=A0 0.0k
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 +curr.rate:=A0=A0=A0=A0=A0=A0=A0=
 0kB/s, avg.rate:=A0=A0=A0=A0=A0=A0=A0 0kB/s, avg.load:=A0 0.0%
> dd_rescue: (warning): /mnt/xxx/zeros.bin (0.0k): Invalid argument!
>=20
>=20
>=20
> Bad block: 0
> dd_rescue: (info): ipos 0.0k promote to large bs again!=20
>=20
>=20
>=20
> Summary for /mnt/xxx/zeros.bin -> /mnt/yyy/zeros.bin:
> dd_rescue: (info): ipos:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k, opos:=A0=A0=A0=
=A0=A0=A0=A0=A0 0.0k, xferd:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 errs:=A0=A0=A0=
=A0=A0 1, errxfer:=A0=A0=A0=A0=A0=A0=A0=A0 0.0k, succxfer:=A0=A0=A0=A0=A0=
=A0=A0=A0 0.0k
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 +curr.rate:=A0=A0=A0=A0=A0=A0 10=
kB/s, avg.rate:=A0=A0=A0=A0=A0=A0=A0 0kB/s, avg.load:=A0 0.0%
>=20
> ----------------
>=20
> If I don't use "dD" option it runs fine with a 512k blocksize
>=20
> * OS in use is debian/squeeze
> * kernel: 2.6.32-trunk-686 (linux-image-2.6.32-trunk-686)
> * apt-cache policy btrfs-tools
> =A0 btrfs-tools:
> =A0 installed: 0.19-8
> =A0 candidate: 0.19-8
>=20
> Raids where created like this:
>=20
> mkfs.btrfs -d raid1 -m raid1 /dev/sdb1 /dev/sdc1
> mkfs.btrfs -d raid1 -m raid1 /dev/sdb2 /dev/sdc2
>=20
> cat /proc/mounts | grep btrfs
> /dev/sdb1 /mnt/xxx btrfs rw,relatime 0 0
> /dev/sdb2 /mnt/yyy btrfs rw,relatime 0 0
>=20
> I believe this is a bug - feel free to share your thoughts
>  		 	   		 =20

O_DIRECT isn't supported on btrfs yet, which is why it fails.

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
