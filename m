Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54143 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751924AbeBFIEK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Feb 2018 03:04:10 -0500
Subject: Re: segmentation fault in btrfs tool v4.15
To: Ralph Gauges <ralphgauges@googlemail.com>, linux-btrfs@vger.kernel.org
References: <10214501-3b8e-7f9b-11d6-14fb75da07a5@googlemail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bda6e11b-c978-ce90-70d0-2ac1f7210e3d@gmx.com>
Date: Tue, 6 Feb 2018 16:04:05 +0800
MIME-Version: 1.0
In-Reply-To: <10214501-3b8e-7f9b-11d6-14fb75da07a5@googlemail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ykS43fz8lFhlzzBl8yx6TLffB5JzD37ng"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ykS43fz8lFhlzzBl8yx6TLffB5JzD37ng
Content-Type: multipart/mixed; boundary="i1PJ1orpzRv9vDRTGyRrtsHPj9CBwvf7s";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Ralph Gauges <ralphgauges@googlemail.com>, linux-btrfs@vger.kernel.org
Message-ID: <bda6e11b-c978-ce90-70d0-2ac1f7210e3d@gmx.com>
Subject: Re: segmentation fault in btrfs tool v4.15
References: <10214501-3b8e-7f9b-11d6-14fb75da07a5@googlemail.com>
In-Reply-To: <10214501-3b8e-7f9b-11d6-14fb75da07a5@googlemail.com>

--i1PJ1orpzRv9vDRTGyRrtsHPj9CBwvf7s
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8806=E6=97=A5 15:56, Ralph Gauges wrote:
> Hi,
>=20
> I recently started using the btrfs file system on my backup disk and
> until a power failure during a backup everything seemed to work well.
> Due a power failure however, the file systems seems to have become
> corrupted and all trials to check or repair it so far have lead to a
> segmentation fault.
>=20
> Normally I am using Ubuntu 17.10 and the btrfs version that goes along
> with it, but for testing purposes, I compiled my own version
> (btrfs-progs v4.15).
> Unfortunately the segmentation fault is also present in this latest
> version. At the end of this email, you can see the output from btrfs
> when I try to check the partition as well as the backtrace from gdb. I
> hope that helps.
>=20
> My system is running kernel 4.13.0-32-generic on x86_64.
>=20
> If you need any additional information please contace me directly since=

> I don't subscribe to the mailing list.
>=20
> Sincerily
>=20
> Ralph Gauges
>=20
>=20
>=20
>=20
>=20
>=20
> (gdb) set args check /dev/sdf1
> (gdb) run
> Starting program: /home/gauges/Applications/bin/btrfs check /dev/sdf1
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.=
1".
> parent transid verify failed on 266195058688 wanted 1857 found 1864
> parent transid verify failed on 266195058688 wanted 1857 found 1864
> parent transid verify failed on 266195058688 wanted 1857 found 1864
> parent transid verify failed on 266195058688 wanted 1857 found 1864
> Ignoring transid failure
> Checking filesystem on /dev/sdf1
> UUID: 9ccb1eaa-a9ae-46f3-8885-fba4799d6e85
> parent transid verify failed on 266196516864 wanted 1858 found 1864
> parent transid verify failed on 266196516864 wanted 1858 found 1864
> parent transid verify failed on 266196516864 wanted 1858 found 1864
> parent transid verify failed on 266196516864 wanted 1858 found 1864
> Ignoring transid failure
> parent transid verify failed on 266196205568 wanted 1858 found 1864
> parent transid verify failed on 266196205568 wanted 1858 found 1864
> parent transid verify failed on 266196205568 wanted 1858 found 1864
> parent transid verify failed on 266196205568 wanted 1858 found 1864
> Ignoring transid failure
>=20
> Program received signal SIGSEGV, Segmentation fault.
> 0x00005555555bf7a7 in btrfs_extent_flags (s=3D0xcc344065,
> eb=3D0x5555584acce0) at ctree.h:1694
> 1694=C2=A0=C2=A0=C2=A0 BTRFS_SETGET_FUNCS(extent_flags, struct btrfs_ex=
tent_item,
> flags, 64);
> (gdb) bt
> #0=C2=A0 0x00005555555bf7a7 in btrfs_extent_flags (s=3D0xcc344065,
> eb=3D0x5555584acce0) at ctree.h:1694
> #1=C2=A0 build_roots_info_cache (info=3D0x555555821a00) at cmds-check.c=
:14285

Would you please show the value of eb->start?

And possible function call of btrfs_print_tree(info->extent_root, eb, 1)
and its result.

Thanks,
Qu

> #2=C2=A0 repair_root_items (info=3D0x555555821a00) at cmds-check.c:1445=
0
> #3=C2=A0 cmd_check (argc=3D<optimized out>, argv=3D<optimized out>) at
> cmds-check.c:14965
> #4=C2=A0 0x0000555555566320 in main (argc=3D2, argv=3D0x7fffffffde30) a=
t btrfs.c:302
> (gdb)
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--i1PJ1orpzRv9vDRTGyRrtsHPj9CBwvf7s--

--ykS43fz8lFhlzzBl8yx6TLffB5JzD37ng
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlp5YXUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgSKwf/TrHbc6gTuZsyqXH1jVO0aj4r
OSDXmFTji2UsC8tsYGx0j/WcDUeDbxJL7mz50cz6xLnFTJp1UQPUv8w0TxDX1r38
eU0wfDMj/RpZXsjvww350KRhNP1JZ3bWwjg3EtYiXlRk1G38orayym2GtTY5cit/
bZ0qwf0Ekwrmq5904+RcLt0zWnPnXly5MgduzdxiTSa7CIuEX3jNAWdc9beGmF2w
cMSC3dqbBw1fuDTS6K3B2TTa5iHtftkcZLIoCGlJVOO5UkL0u3LUdB/agojqwiNh
aBlOTLUTOdf4BV77d6nLfCtiOaV/oNNSwL8yJvOYxPpRjg4vZqaMHvuQQbMd3Q==
=cIW8
-----END PGP SIGNATURE-----

--ykS43fz8lFhlzzBl8yx6TLffB5JzD37ng--
