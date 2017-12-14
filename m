Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59957 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751090AbdLNHqh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 02:46:37 -0500
Subject: Re: OFF-By-One Trouble? [BTRFS in Debian Stretch Kernel
 4.9.0-4-amd64]
To: service@automatix.de, linux-btrfs@vger.kernel.org
References: <3bd97912-4561-9b75-8fd7-98bc52ddcbc2@automatix.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <138ae3f6-024f-3a3b-b404-18a63925a9f7@gmx.com>
Date: Thu, 14 Dec 2017 15:46:30 +0800
MIME-Version: 1.0
In-Reply-To: <3bd97912-4561-9b75-8fd7-98bc52ddcbc2@automatix.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="k3oJ4M389bP48AD0GfSImPt697Nj63R7u"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--k3oJ4M389bP48AD0GfSImPt697Nj63R7u
Content-Type: multipart/mixed; boundary="k1vmiucvlrt4aU2FK7l1MvTUdGXMPoJtf";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: service@automatix.de, linux-btrfs@vger.kernel.org
Message-ID: <138ae3f6-024f-3a3b-b404-18a63925a9f7@gmx.com>
Subject: Re: OFF-By-One Trouble? [BTRFS in Debian Stretch Kernel
 4.9.0-4-amd64]
References: <3bd97912-4561-9b75-8fd7-98bc52ddcbc2@automatix.de>
In-Reply-To: <3bd97912-4561-9b75-8fd7-98bc52ddcbc2@automatix.de>

--k1vmiucvlrt4aU2FK7l1MvTUdGXMPoJtf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8812=E6=97=A5 18:22, Juergen Sauer wrote:
> Hi collegues,
> this morning we've got a problm with btrfs in Debian Stable.
>=20
> Yesterday we had our fs filled below 30% space usage.
> No further usage came in the usage is nearly the same, but ...
>=20
> # df -h .
> Dateisystem    Gr=C3=B6=C3=9Fe Benutzt Verf. Verw% Eingeh=C3=A4ngt auf
> /dev/vdb1      483G    483G  148K  100% /mnt
>=20
> # btrfs fi df .
> Data, single: total=3D480.97GiB, used=3D480.97GiB
> System, single: total=3D32.00MiB, used=3D96.00KiB
> Metadata, single: total=3D2.00GiB, used=3D1.29GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> # btrfs fi show .
> Label: 'AXSDaten'  uuid: fde7e31f-4127-4a9d-b7c6-774ceff8f7c1
>         Total devices 1 FS bytes used 482.26GiB
>         devid    1 size 483.00GiB used 483.00GiB path /dev/vdb1
>=20
> # btrfs --version
> btrfs-progs v4.7.3
>=20
> we found exerpt of kernel log:
> [  199.391577] attempt to access beyond end of device
> [  199.391598] vdb1: rw=3D536870984, want=3D1012922336, limit=3D1012922=
335

I doubt if it's just a off-by-one bug.

It can be that, btrfs think it's enlarged while partition table doesn't
think so, so btrfs tries to submit write beyond the partition end.

> [  199.391615] BTRFS error (device vdb1): bdev /dev/vdb1 errs: wr 301,
> rd 0, flush 0, corrupt 0, gen 0
> r
> If I interpret the log right, on the FS the kernel wants to write on
> block  1012922336, but the fs was created with max 1012922335 blocks.
>=20
> Looks to us here like a typical off-by-one error on accessing the last
> block of device.
>=20
> This error was repeating under ff. conditions:
> - shutdown the virtual server (kvm),
> - extend the physical file of the according virtual hdd by 20% (from 48=
3
> Gib to 520 GiB)
> - restart virtual server
> - fixed partion size (parted), mounted
> - called btrfs fi resize max on the corresponding mount point

The following info is needed to debug the problem.

1) Chunk tree dump of the btrfs:
   # btrfs inspect dump-tree -t 3 /dev/vdb1

2) Super dump of the btrfs:
   # btrfs inspect dump-super -f /dev/vdb1

3) Kernel version
   # uname -a
   (Well, I'm not a Debian user so I don't really know the kernel
    version just by "Debian Stable")

4) Partition info
   Better with binary output in byte unit.

Thanks,
Qu

>=20
> Error came back, nearly at once.
>=20
> Any other Idea to fix this error?
>=20
> mit freundlichen Gr=C3=BC=C3=9Fen
> J=C3=BCrgen Sauer
>=20


--k1vmiucvlrt4aU2FK7l1MvTUdGXMPoJtf--

--k3oJ4M389bP48AD0GfSImPt697Nj63R7u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloyLFYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi9wAf/c5NDxlFAft5x9B2vOpg5PZq0
98spsePkNjP5OUmUM2V5h3SDI/Wt/z9uAwCr5N1h7ahe7UOq3OoEQ5frifyVG1fk
UiTdVg55D9Hr7uogUU0qv95qLRfWfgqLtIB6boZQT2KD/cc6om08FUW/5Tt6UVNY
JlaH9Uxctu/m7fzqMsQ1clVJdoZCSDdY/w+8YYR7diqgSsrpNgG9lPbHUvALZOgC
PdcZyQQZvpvdtSsZuKtA0wI1MKi3gNjbCOUSI/U6qAibJDqXGLCGal4EZ4Ug857I
QhFAjYaGPqLfJdtsgmB9JENu6IxeQUCIHkKwhBWN43vDA/VRhGl+dgyqketw4A==
=aeow
-----END PGP SIGNATURE-----

--k3oJ4M389bP48AD0GfSImPt697Nj63R7u--
