Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:50532 "EHLO demfloro.ru"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754451AbeDWIk3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 04:40:29 -0400
Date: Mon, 23 Apr 2018 11:40:16 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: 4.17-rc1 FS went read-only during balance
Message-ID: <20180423114016.3cdc0ac1@job>
In-Reply-To: <d935c0e0-c2c8-a0ec-bb07-5c3879dd1be0@gmx.com>
References: <20180421175548.4b07dffc@demfloro.ru>
        <5775f38a-5f17-1f6d-a6cd-289e18188a26@gmx.com>
        <20180423080745.5a9dc6be@demfloro.ru>
        <3d2443c8-0b34-2eea-3adc-2f33570f75b1@gmx.com>
        <20180423105543.43f13e3a@job>
        <d935c0e0-c2c8-a0ec-bb07-5c3879dd1be0@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/X+gOnbNuHXHSn/0/aS_Laas"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/X+gOnbNuHXHSn/0/aS_Laas
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> >>>>> TL;DR It seems as regression in 4.17, but I managed to find a
> >>>>> workaround to make filesystem rw mountable again.
> >>>>>
> >>>>> Kernel built from tag v4.17-rc1
> >>>>> btrfs-progs 4.16
> >>>>>
> >>>>> Tonight two my machines (PC (ECC RAM) and laptop(non-ECC RAM)) were
> >>>>> doing usual weekly balance with this command via cron:
> >>>>> btrfs balance start -musage=3D50 -dusage=3D50 <mountpoint>
> >>>>> Both machines run same kernel version.=20
> >>>>>
> >>>>> On PC that caused root and "data" filesystems to go readonly. Root
> >>>>> is on an SSD with data single and metadata DUP, "data" filesystem
> >>>>> is on 2 HDDs with RAID1 for data and metadata.
> >>>>>
> >>>>> On laptop only /home went ro, it's on NVMe SSD with data single and
> >>>>> metadata DUP.=20
> >>>>>
> >>>>> Btrfs check of PC rootfs was without any errors in both modes, I did
> >>>>> them once each before reboot on readonly filesystem with --force
> >>>>> flag and then from live usb. Same output without any errors.
> >>>>>
> >>>>> After reboot kernel refused rw mount rootfs with the same error as
> >>>>> during cron balance, ro mount was accepted, error during rw mount:
> >>>>> BTRFS: error (device dm-17) in merge_reloc_roots:2465: errno=3D-117=
     =20
> >>>    =20
> >>>> 117 means EUCLEAN, which could be caused by the newly introduced
> >>>> first_key and level check.   =20
> >>>    =20
> >>>> Please apply this hotfix to fix it.
> >>>> btrfs: Only check first key for committed tree blocks
> >>>> (Which is included in latest pull request)   =20
> >>>    =20
> >>>> Also, please consider enable CONFIG_BTRFS_DEBUG to provide extra
> >>>> debug info.   =20
> >>>    =20
> >>>> Thanks,
> >>>> Qu   =20
> >>>
> >>> I tried 4.17-rc2 (as the pull request was pulled) with
> >>> CONFIG_BTRFS_DEBUG on LVM snapshot of laptop home partition (/dev/vdb)
> >>> in a VM (VM kernel sees only snapshot so no UUID collisions). Dmesg
> >>> attached.   =20
> >>
> >> Thanks for the info and your previous btrfs-image.
> >>
> >> The image itself shows nothing wrong, so it should be runtime problem.
> >> Would you please apply these two debug patches?
> >> https://patchwork.kernel.org/patch/10335133/
> >> https://patchwork.kernel.org/patch/10335135/
> >>
> >> And the attached diff file?
> >>
> >> My guess is the parent node is not initialized correctly in this case.
> >>
> >> Thanks,
> >> Qu =20
> >=20
> > Dmesg from kernel with all three patches applied attached.
> >  =20
> Thanks for the debug info, it really helps a lot!
>=20
> It turns out that I'm just a super idiot, a typo in replace_path()
> caused this, and it could not be trigger unless we enter it from
> relocation recovery.
>=20
> Please try the attached patch to see if it solves the problem.
>=20
> Thanks,
> Qu
Glad to help, the patch solved the problem,=20
rw mount is successful and balance finished, no errors or debug output,
btrfs check is clean in both modes.

[    2.842718] BTRFS: device label home devid 1 transid 277952 /dev/vdb
[    2.924965] BTRFS: device label root devid 1 transid 84092 /dev/vda2
[    3.072271] BTRFS info (device vda2): use lzo compression, level 0
[    3.072897] BTRFS info (device vda2): enabling auto defrag
[    3.073476] BTRFS info (device vda2): using free space tree
[    3.074049] BTRFS info (device vda2): has skinny extents
[    5.411821] BTRFS info (device vda2): using free space tree
[   24.925293] BTRFS info (device vdb): using free space tree
[   24.925324] BTRFS info (device vdb): has skinny extents
[   31.711868] BTRFS info (device vdb): continuing balance
[   31.721658] BTRFS info (device vdb): checking UUID tree
[   31.822920] BTRFS info (device vdb): relocating block group 69889687552f=
lags data=20
[   33.730399] BTRFS info (device vdb): found 12 extents
[   36.950699] BTRFS info (device vdb): found 12 extents
[   37.030813] BTRFS info (device vdb): relocating block group 67742203904f=
lags metadata|dup=20
[   37.104174] BTRFS info (device vdb): relocating block group 67708649472 =
flags system|dup=20
[   37.189843] BTRFS info (device vdb): found 1 extents


--Sig_/X+gOnbNuHXHSn/0/aS_Laas
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEaxJP+1DpEM+EyRU12K4MF+bMXxoFAlrdm/EACgkQ2K4MF+bM
Xxr2iAgAmvRnCdCAkoZmTrHFh6YvAyLNMfa46273tXm0Kkx2vuDXfAZwVEcci50M
/Of3ohh/MIybJ02S9DmiQZBu/2zFjZFgEpUE54k7wQu6IR9+ZiAY/MhnJUeaFlXs
D0G5qCOvfKEM3KYAh272/GRRyq2ASBQtC/vTZCUbKAab3PP1mymTRkc8M5iat58p
X+jbQ2VheT0B7VDulGAic92GRBf7X4BZ0ZHhuv3jfBQKKHX0u29VO6YF5C94J/qm
BocqWbB9lBBuHM4e7B2CSgZZBJU6A4rBpQttfIE6d90+T0moN5Y16aFEimzfHxwy
FZ/5/fv7bqiY1Ix2uZGjbOA4v/t2ww==
=7Wev
-----END PGP SIGNATURE-----

--Sig_/X+gOnbNuHXHSn/0/aS_Laas--
