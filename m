Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:36877 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbeGUCNJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 22:13:09 -0400
Subject: Re: btrfs filesystem corruptions with 4.18. git kernels
To: Alexander Wetzel <alexander.wetzel@web.de>, linux-btrfs@vger.kernel.org
References: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <eed6fd0d-c89e-5f3e-026e-0364b0bffda1@gmx.com>
Date: Sat, 21 Jul 2018 09:22:11 +0800
MIME-Version: 1.0
In-Reply-To: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lg1ZmRDYXjHVReIGS6By1qvlmrQZ0ZtmN"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lg1ZmRDYXjHVReIGS6By1qvlmrQZ0ZtmN
Content-Type: multipart/mixed; boundary="KczUz1OitVuc3vjFv9TYHN8fSbLuSIMtI";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Alexander Wetzel <alexander.wetzel@web.de>, linux-btrfs@vger.kernel.org
Message-ID: <eed6fd0d-c89e-5f3e-026e-0364b0bffda1@gmx.com>
Subject: Re: btrfs filesystem corruptions with 4.18. git kernels
References: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>
In-Reply-To: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>

--KczUz1OitVuc3vjFv9TYHN8fSbLuSIMtI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8821=E6=97=A5 05:28, Alexander Wetzel wrote:
> Hello,
>=20
> I'm running my normal workstation with git kernels from
> git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-testing=
=2Egit
> and just got the second file system corruption in three weeks. I do not=

> have issues with stable kernels, and just want to give you a heads up
> that there might be something seriously broken in current development
> kernels.
>=20
> The first corruption was with a kernel based on 4.18.0-rc1
> (wt-2018-06-20) and the second one today based on 4.18.0-rc4
> (wt-2018-07-09).
> The first corruption definitely destroyed data, the second one has not
> been looked at all, yet.
>=20
> After the reinstall I did run some scrubs, the last working one one wee=
k
> ago.
>=20
> Of course this could be unrelated to the development kernels or even
> btrfs, but two corruptions within weeks after years without problems is=

> very suspect.
> And since btrfs also allowed to read corrupted data (with a stable
> ubuntu kernel, see below for more details) it looks like this is indeed=

> an issue in btrfs, correct?

Not in newer kernel anymore.

Btrfs kernel module will do *restrict* check on tree blocks.
So anything unexpected (or doesn't follow btrfs on-disk format) will be
rejected by btrfs module.

To avoid further corrupting the whole btrfs.

>=20
> A btrfs subvolume is used as the rootfs on a "Samsung SSD 850 EVO mSATA=

> 1TB" and I'm running Gentoo ~amd64 on a Thinkpad W530. Discard is
> enabled as mount option and there were roughly 5 other subvolumes.
>=20
> I'm currently backing up the full btrfs partition after the second
> corruption which announced itself with the following log entries:
>=20
> [=C2=A0 979.223767] BTRFS critical (device sdc2): corrupt leaf: root=3D=
2
> block=3D1029783552 slot=3D1, unexpected item end, have 16161 expect 162=
50

This shows enough info of what's going wrong.
Items overlaps or has holes in extent tree.

Please dump the tree block by using the following command:

# btrfs inspect dump-tree -b 1029783552 /dev/sdc2

And please run "btrfs check" on the filesystem to show any other problems=
=2E
(I assume there will be more problem than our expectation)

> [=C2=A0 979.223808] BTRFS: error (device sdc2) in __btrfs_cow_block:108=
0:
> errno=3D-5 IO failure
> [=C2=A0 979.223810] BTRFS info (device sdc2): forced readonly
> [=C2=A0 979.224599] BTRFS warning (device sdc2): Skipping commit of abo=
rted
> transaction.
> [=C2=A0 979.224603] BTRFS: error (device sdc2) in cleanup_transaction:1=
847:
> errno=3D-5 IO failure
>=20
> I'll restore the system from a backup - and stick to stable kernels for=

> now - after that, but if needed I can of course also restore the
> partition backup to another disk for testing.

Since it is your fs corrupted, using older kernel ignores such problem
is not the long term solution in my opinion.

>=20
> Here what I can say from the first crash:
>=20
> On Jul 4th I discovered severe file system corruptions and when booting=

> with init=3D/bin/bash even tools like parted failed with some report ab=
out
> invalid ELF headers for some library. I started an Ubuntu 17.10 install=

> on another physical disk and copied some data from the damaged btrfs
> volume to the Ubuntu disk. And while I COULD copy the files quite many
> of the interesting ones were broken:
> e.g. the git tree I rescued from the broken btrfs disk is unusable. The=

> broken files I found all look about the correct size but contain only 0=
x01:
> $ hexdump -C .git/objects/9d/732f6506e4cecd6d2b50c5008f9d1255198c1e
> 00000000=C2=A0 01 01 01 01 01 01 01 01=C2=A0 01 01 01 01 01 01 01 01
> |................|
> *
> 00000e26
>=20
> After copying the files I tried a "btrfs check --repair" which was
> finding countless errors and I aborted after I got more than 3 million
> lines output.

--repair should never be your first try by all means.
And in fact, sometimes it could even further corrupt the fs.

Thanks,
Qu

> After the abort the complete home dir and everything
> beneath it was simple gone. I gave up on the install and set the system=

> up from scratch, starting with formating the damaged partition new.
> And exported the root subvolume with btrfs send to a fil.
>=20
> The full output from the repair attempt can be downloaded here:
> https://www.awhome.eu/index.php/s/6jXtBTEeyA2ns3d
>=20
> Kind regards,
>=20
> Alexander
>=20
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--KczUz1OitVuc3vjFv9TYHN8fSbLuSIMtI--

--lg1ZmRDYXjHVReIGS6By1qvlmrQZ0ZtmN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltSisMACgkQwj2R86El
/qiqgAf9E5x5C2Upukxg+PQWVVoQkLoapWPx/VLJ9DTv+LBBkVNw52NBwT/RLl4x
GQPJFk0S9tk80nphTRqT93/Lvr77bGdh1cAmIXpOaJXyc1JTt/u1osPOxWKl8JOj
IgyfDZKv+Vu7o7M6EVa3R4ex/DHfPiMOPCt4yQpaHqr2dNaLHy8S8zr7PYnv1874
brKdHiLkplx6oWnrfKYSQPbEJ9QX4i2+WP+eTbAS5em62/i8CiCiy1/rGWiw+Ynt
dv4Sdu5ABJ7iPIHi5A2RV7X/XQ+VfllpMeRNqnbk+Ujx7XdtWjPG4nmD05DkRNXW
lOP8fV4ayn+UNoQHl2roo15Py5k7qQ==
=qZVL
-----END PGP SIGNATURE-----

--lg1ZmRDYXjHVReIGS6By1qvlmrQZ0ZtmN--
