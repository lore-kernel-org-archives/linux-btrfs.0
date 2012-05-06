From: Robin Nehls <nehls@mi.fu-berlin.de>
Subject: Re: balancing metadata fails with no space left on device
Date: Sun, 6 May 2012 21:38:43 +0200
Message-ID: <20120506213843.0e925dfb@helios.lan>
References: <201205041835.39441.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kkKAevJ0ENePajdlB8IeuaY"; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201205041835.39441.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/kkKAevJ0ENePajdlB8IeuaY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am Fri, 4 May 2012 18:35:39 +0200
schrieb Martin Steigerwald <Martin@lichtvoll.de>:

> Hi!
>=20
> merkaba:~> btrfs balance start -m /
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail
> merkaba:~#19> dmesg | tail -22
> [   62.918734] CPU0: Package power limit normal
> [  525.229976] btrfs: relocating block group 20422066176 flags 1
> [  526.940452] btrfs: found 3048 extents
> [  528.803778] btrfs: found 3048 extents
> [  528.988440] btrfs: relocating block group 17746100224 flags 34
> [  529.116424] btrfs: found 1 extents
> [  529.247866] btrfs: relocating block group 17611882496 flags 36
> [  536.003596] btrfs: found 14716 extents
> [  536.170073] btrfs: relocating block group 17477664768 flags 36
> [  542.230713] btrfs: found 13170 extents
> [  542.353089] btrfs: relocating block group 17343447040 flags 36
> [  547.446369] btrfs: found 9809 extents
> [  547.663141] btrfs: 1 enospc errors during balance
> [  629.238168] btrfs: relocating block group 21894266880 flags 34
> [  629.359284] btrfs: found 1 extents
> [  629.520614] btrfs: 1 enospc errors during balance
> [  630.715766] btrfs: relocating block group 21927821312 flags 34
> [  630.749973] btrfs: found 1 extents
> [  630.899621] btrfs: 1 enospc errors during balance
> [  635.872857] btrfs: relocating block group 21961375744 flags 34
> [  635.906517] btrfs: found 1 extents
> [  636.038096] btrfs: 1 enospc errors during balance
>=20
>=20
> merkaba:~> btrfs filesystem show
> failed to read /dev/sr0
> Label: 'debian'  uuid: [=E2=80=A6]
>         Total devices 1 FS bytes used 7.89GB
>         devid    1 size 18.62GB used 17.58GB path /dev/dm-0
>=20
>=20
> Btrfs Btrfs v0.19
> merkaba:~> btrfs filesystem df /
> Data: total=3D15.52GB, used=3D7.31GB
> System, DUP: total=3D32.00MB, used=3D4.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, DUP: total=3D1.00GB, used=3D587.83MB
>=20
>=20
> This is repeatable.
>=20
> martin@merkaba:~> cat /proc/version
> Linux version 3.3.0-trunk-amd64 (Debian 3.3.4-1~experimental.1)
> (debian- kernel  AT  lists.debian.org) (gcc version 4.6.3 (Debian
> 4.6.3-1) ) #1 SMP Wed May 2 06:54:24 UTC 2012
>=20
>=20
> Which is Debian=C2=B4s variant of 3.3.4 with
>=20
> commit bfe050c8857bbc0cd6832c8bf978422573c439f5
> Author: Chris Mason <chris.mason  AT  oracle.com>
> Date:   Thu Apr 12 13:46:48 2012 -0400
>=20
>     Revert "Btrfs: increase the global block reserve estimates"
>    =20
>     commit 8e62c2de6e23e5c1fee04f59de51b54cc2868ca5 upstream.
>    =20
>     This reverts commit 5500cdbe14d7435e04f66ff3cfb8ecd8b8e44ebf.
>    =20
>     We've had a number of complaints of early enospc that bisect down
>     to this patch.  We'll hae to fix the reservations differently.
>    =20
>     Signed-off-by: Chris Mason <chris.mason  AT  oracle.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh  AT
> linuxfoundation.org>
>=20
> from 3.3.3.
>=20
> May I need to wait for a proper fix to global block reserve for the
> balance to succeed or do I see a different issue?
>=20
>=20
> Since scrubbing still works I take it that balancing was aborted=20
> gracefully and thus the filesystem is still intact. This is on a
> ThinkPad T520 with Intel SSD 320. I only wanted to reorder metadata
> trees, I do not think it makes much sense to relocate data blocks on
> a SSD. Maybe the reordering metadata blocks may not make much sense
> also, but I thought I still report this.
>=20
> Thanks,

Hi,
I think I have a similar problem, but in my case there is lots of free
space available. So this might also be a bug.

My problem: I wanted to convert the data of my btrfs from RAID0 to
single. No matter if I use soft or not, the progress always stops with
3GB RAID0 remaining. The conversion is newer completed so new files are
allways written to the RAID0 part of data. If i do a balance without
special options, data is converted back to RAID0.
This enospc error can't be correct because there is about 1 TB of space
available.

What I do:
# ./btrfs balance start -dconvert=3Dsingle,soft /mnt/btrfs/
ERROR: error during balancing '/mnt/btrfs/' - No space left on device
There may be more info in syslog - try dmesg | tail

Relevant Dmesg:
[418912.485276] btrfs: relocating block group 11165392437248 flags 9
[418914.044328] btrfs: 1 enospc errors during balance

FS Information:
# ./btrfs filesystem show
Label: none  uuid: 0251aa44-4e39-4db5-b18d-ffc8e85042ab
        Total devices 3 FS bytes used 2.24TB
        devid    1 size 1.82TB used 1.59TB path /dev/sdc1
        devid    3 size 931.51GB used 696.06GB path /dev/sdd1
        devid    2 size 931.51GB used 696.00GB path /dev/sdb1

Btrfs Btrfs v0.19-dirty

# ./btrfs filesystem df /mnt/btrfs/
Data, RAID0: total=3D3.00GB, used=3D3.00GB
Data: total=3D2.80TB, used=3D2.24TB
System, RAID1: total=3D64.00MB, used=3D328.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, RAID1: total=3D75.00GB, used=3D2.94GB

# cat /proc/version
Linux version 3.4.0-rc5-amd64 (root@hermes) (gcc version 4.6.3 (Debian
4.6.3-1) ) #1 SMP Tue May 1 23:52:34 CEST 2012

So long,
Robi

--Sig_/kkKAevJ0ENePajdlB8IeuaY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk+m00gACgkQ9WjxGOigJozyeQCg8ENXeLQ73P3uGQjsHDjA0ieh
9x0AoJi40Jc4cEZvwO1f0qVl19ZXhkQV
=ELwt
-----END PGP SIGNATURE-----

--Sig_/kkKAevJ0ENePajdlB8IeuaY--
