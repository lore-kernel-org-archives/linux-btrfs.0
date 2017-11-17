Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49518 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756684AbdKQFRc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 00:17:32 -0500
Subject: Re: btrfs check: add_missing_dir_index: BUG_ON `ret` triggered, value
 -17
To: Marc MERLIN <marc@merlins.org>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
References: <20171117022615.GO10969@merlins.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3e4de2ce-28c8-23c0-c25d-70659a378865@gmx.com>
Date: Fri, 17 Nov 2017 13:17:19 +0800
MIME-Version: 1.0
In-Reply-To: <20171117022615.GO10969@merlins.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VWG9apD9bsf10GtXsKmtnShciWg02C22g"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VWG9apD9bsf10GtXsKmtnShciWg02C22g
Content-Type: multipart/mixed; boundary="6dHJ3mh6A7MB0of5XrUsligWhb5Gej1v4";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Marc MERLIN <marc@merlins.org>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Message-ID: <3e4de2ce-28c8-23c0-c25d-70659a378865@gmx.com>
Subject: Re: btrfs check: add_missing_dir_index: BUG_ON `ret` triggered, value
 -17
References: <20171117022615.GO10969@merlins.org>
In-Reply-To: <20171117022615.GO10969@merlins.org>

--6dHJ3mh6A7MB0of5XrUsligWhb5Gej1v4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8817=E6=97=A5 10:26, Marc MERLIN wrote:
> Howdy,
>=20
> Up to date git pull from btrfs-progs:
>=20
> gargamel:~# btrfs check --repair /dev/mapper/raid0d1
> enabling repair mode
> Checking filesystem on /dev/mapper/raid0d1
> UUID: 01334b81-c0db-4e80-92e4-cac4da867651
> checking extents
> corrupt extent record: key 203003699200 168 40960
> corrupt extent record: key 203003764736 168 172032
> ref mismatch on [203003699200 40960] extent item 0, found 1
> Data backref 203003699200 root 258 owner 1933897829 offset 0 num_refs 0=
 not found in extent tree
> Incorrect local backref count on 203003699200 root 258 owner 1933897829=
 offset 0 found 1 wanted 0 back 0x5596988c2130
> backpointer mismatch on [203003699200 40960]
> repair deleting extent record: key 203003699200 168 40960
> adding new data backref on 203003699200 root 258 owner 1933897829 offse=
t 0 found 1
> Repaired extent references for 203003699200
> Data backref 203003764736 root 258 owner 1932315368 offset 0 num_refs 0=
 not found in extent tree
> Incorrect local backref count on 203003764736 root 258 owner 1932315368=
 offset 0 found 1 wanted 0 back 0x5596dde358f0
> backpointer mismatch on [203003764736 172032]
> repair deleting extent record: key 203003764736 168 172032
> adding new data backref on 203003764736 root 258 owner 1932315368 offse=
t 0 found 1
> Repaired extent references for 203003764736
> Fixed 0 roots.
> checking free space cache
> cache and super generation don't match, space cache will be invalidated=

> checking fs roots
> invalid location in dir item 0
> Deleting bad dir index [1919785864,96,1958] root 258
> Deleting bad dir index [1919785864,96,1957] root 258
> repairing missing dir index item for inode 1919805647
> cmds-check.c:2614: add_missing_dir_index: BUG_ON `ret` triggered, value=
 -17

-EEXIST. Btrfs check --repair is trying to re-insert some key which
exists already.

Would you please provide the output of "btrfs-debug-tree -t 258 | grep
1919805647" to help the debugging?

Thanks,
Qu

> btrfs(+0x52207)[0x55966a6fa207]
> btrfs(+0x5225a)[0x55966a6fa25a]
> btrfs(+0x5cef3)[0x55966a704ef3]
> btrfs(cmd_check+0x2e10)[0x55966a70ea35]
> btrfs(main+0x85)[0x55966a6b9dc3]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f794aadf2b1]=

> btrfs(_start+0x2a)[0x55966a6b993a]
> Aborted
>=20


--6dHJ3mh6A7MB0of5XrUsligWhb5Gej1v4--

--VWG9apD9bsf10GtXsKmtnShciWg02C22g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloOcN8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhRHwf+Jct2TT12FIKiExTilh2sIH66
1+HoHDc0JozGuaBtcBCMaP1QkBRutEVOAErs4Q/VJN+CcJioLyawptIs/CmhEmVO
XQ1JpLb9bqrLYGvWLr0LTSga1NMROOITrnXkkaNWxEX0WRIGzr0JyhuQ0rtQ24eH
SMLAeq5yFGn60ufbcK/rfD1WnatrtMPoQxPppeDoslyO5fSIkjsrjuRz0vO2N73G
uWPuZJoc6+biG3Lg/4lupaKVR1oQUeiyD0dDLgry9f+162kZXQXVmTyoUnpjzEOE
ZcEuZ4njt4/xivvWvHLIUzzcRV352VaQys6SeYFEvUMFzaErPBAZR4hB19SqMg==
=JEJy
-----END PGP SIGNATURE-----

--VWG9apD9bsf10GtXsKmtnShciWg02C22g--
