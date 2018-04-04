Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56763 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753080AbeDDChs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 22:37:48 -0400
Subject: Re: System freezes a lot - btrfs trace in dmesg - symptom or cause?
To: kernelorg-djthmw7n9w@central-intelligence.agency,
        linux-btrfs@vger.kernel.org
References: <ad1a25fd-0dce-eb5f-c4ca-1aa4fdb5c63b@central-intelligence.agency>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ef39ff53-bdf2-baba-e91e-c69eb3bbafdc@gmx.com>
Date: Wed, 4 Apr 2018 10:37:42 +0800
MIME-Version: 1.0
In-Reply-To: <ad1a25fd-0dce-eb5f-c4ca-1aa4fdb5c63b@central-intelligence.agency>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="yspEsiraGEwaoFolLg8PmhWusAKmhy6yW"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--yspEsiraGEwaoFolLg8PmhWusAKmhy6yW
Content-Type: multipart/mixed; boundary="5nIlSFOnz2O5xNvuQ51FmIKVGCJh8p33A";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: kernelorg-djthmw7n9w@central-intelligence.agency,
 linux-btrfs@vger.kernel.org
Message-ID: <ef39ff53-bdf2-baba-e91e-c69eb3bbafdc@gmx.com>
Subject: Re: System freezes a lot - btrfs trace in dmesg - symptom or cause?
References: <ad1a25fd-0dce-eb5f-c4ca-1aa4fdb5c63b@central-intelligence.agency>
In-Reply-To: <ad1a25fd-0dce-eb5f-c4ca-1aa4fdb5c63b@central-intelligence.agency>

--5nIlSFOnz2O5xNvuQ51FmIKVGCJh8p33A
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8804=E6=97=A5 05:35, Richard Schwab wrote:
> Hi there,
>=20
> I'm currently having some issues with my system freezing a lot, from a
> few seconds up to a few minutes. I haven't figured out yet what might b=
e
> causing this, however, coincidentally some btrfs notices appeared in my=

> dmesg after I had a freeze for about 5 minutes. I'm wondering whether
> this is just another symptom of my system having some weird issues or
> whether this might actually be the cause of the freezes I've been
> experiencing.
>=20
> $ uname -a
> Linux mypc 4.15.14-1-ARCH #1 SMP PREEMPT Wed Mar 28 17:34:29 UTC 2018
> x86_64 GNU/Linux
>=20
> $ btrfs --version
> btrfs-progs v4.15.1
>=20
> $ btrfs fi show
> Label: none=C2=A0 uuid: uuid1
> =C2=A0=C2=A0=C2=A0 Total devices 1 FS bytes used 226.60GiB
> =C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 size 237.37GiB used 237.31=
GiB path /dev/mapper/cryptroot256g
>=20
> Label: none=C2=A0 uuid: uuid2
> =C2=A0=C2=A0=C2=A0 Total devices 1 FS bytes used 116.61MiB
> =C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 size 1.00GiB used 460.00Mi=
B path /dev/sdb2
>=20
> $ btrfs fi df /
> Data, single: total=3D231.28GiB, used=3D223.66GiB
> System, single: total=3D32.00MiB, used=3D48.00KiB
> Metadata, single: total=3D6.00GiB, used=3D2.93GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> Partial dmesg is attached as file. Please tell me if you need more than=

> this, however, before these lines it only contained the startup process=

> (up until 87s).

[10691.693202] btrfs-transacti D    0   447      2 0x80000000
[10691.693207] Call Trace:
[10691.693221]  ? __schedule+0x24b/0x8c0
[10691.693229]  ? enqueue_entity+0x59b/0xc70
[10691.693234]  schedule+0x32/0x90
[10691.693239]  io_schedule+0x12/0x40
[10691.693247]  __lock_page+0xf8/0x130
[10691.693252]  ? add_to_page_cache_lru+0xe0/0xe0
[10691.693309]  read_extent_buffer_pages+0xf0/0x2f0 [btrfs]
[10691.693337]  ? btrfs_alloc_root+0x30/0x30 [btrfs]
[10691.693365]  btree_read_extent_buffer_pages+0x94/0xf0 [btrfs]
[10691.693389]  read_block_for_search.isra.14+0x15a/0x2f0 [btrfs]

This means the tree block pages btrfs trying to read is being locked by
other guy.

And considering later operations also waiting on the same page, it looks
like a deadlock.

Not sure if it's something serious or just bad luck.
But looks like there is something wrong with btrfs tree locks.

Is it reproducible and what's the workload?

And if it's just bad luck, reboot the system and run "btrfs check" on
the fs is highly recommended.

Thanks,
Qu

>=20
> Sincerely
> Richard Schwab
>=20


--5nIlSFOnz2O5xNvuQ51FmIKVGCJh8p33A--

--yspEsiraGEwaoFolLg8PmhWusAKmhy6yW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrEOnYACgkQwj2R86El
/qgkHgf/fFNnkQQCoiZY8aj5SYeQTCpIiR9d2zhDllszdeb00QWl0mT58dzT9UyW
25unnAOZCR9VrMnrpYCOklU+f4f0wzR8Gq/GLQXImvCpzv7oz+bS+EqMfQM9VvgT
wUe3DIRiVm6Yoc9EUgiLXBjRYw2l72I6eM1JltECUpaMkjMkQcGKWizcfsleoJSQ
s18m/ttUPqfET/n3dOAf1r8+88GHgwZHJ/SBlu3Ozoy8j8kt4KPCO8GXh+VEGGy7
gxAWakpTrER8K6XimxeDmBvRStB+CcSVvEnD4MZNSwE5r6kn1Fv0kxjaZRUKF4+o
9egydg+wtN8rkCRLmsGRjEpBhDfOnQ==
=6DJz
-----END PGP SIGNATURE-----

--yspEsiraGEwaoFolLg8PmhWusAKmhy6yW--
