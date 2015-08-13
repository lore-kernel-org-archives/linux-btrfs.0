Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49929 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbbHMHFq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 03:05:46 -0400
Received: from thetick ([93.181.44.4]) by mail.gmx.com (mrgmx001) with ESMTPSA
 (Nemesis) id 0MPDaC-1ZUCQx2rYG-004UXs for <linux-btrfs@vger.kernel.org>; Thu,
 13 Aug 2015 09:05:43 +0200
Date: Thu, 13 Aug 2015 09:05:41 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Deleted files cause btrfs-send to fail
Message-ID: <20150813090541.77f5c821@thetick>
In-Reply-To: <20150813003419.09f13c1a@thetick>
References: <20150813003419.09f13c1a@thetick>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//Uz=eRncN=k+LV4/wdBbnhK"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_//Uz=eRncN=k+LV4/wdBbnhK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Thu, 13 Aug 2015 00:34:19 +0200
schrieb Marc Joliet <marcec@gmx.de>:

[...]
> Since this is the root file system, I haven't gotten a copy of the actual=
 output
> of "btrfs check", though I have run it from an initramfs rescue shell.  T=
he
> output I saw there was much like the following (taken from an Email by Ro=
man
> Mamedov from 2014-12-28):
>=20
> root 22730 inode 6236418 errors 2000, link count wrong unresolved ref dir=
 105512 index 586340 namelen 48 name [redacted].dat.bak filetype 0 errors 3=
, no dir item, no dir index
>=20
> Only in my case, it's "root 5" and "root 4" (I think), and the file names
> (and other file system specifics) are of course different.  I definitely =
saw
> "errors 2000" (I take it that's supposed to be an error code?).
[...]

Here's the actual output now, obtained via btrfs-progs 4.0.1 from an initra=
mfs
emergency shell:

checking extents
checking free space cache
checking fs roots
root 5 inode 8338813 errors 2000, link count wrong
        unresolved ref dir 26699 index 50500 namelen 4 name root filetype 0=
 errors 3, no dir item, no dir index
root 5 inode 8338814 errors 2000, link count wrong
        unresolved ref dir 26699 index 50502 namelen 6 name marcec filetype=
 0 errors 3, no dir item, no dir index
root 5 inode 8338815 errors 2000, link count wrong
        unresolved ref dir 26699 index 50504 namelen 6 name systab filetype=
 0 errors 3, no dir item, no dir index
root 5 inode 8710030 errors 2000, link count wrong
        unresolved ref dir 26699 index 59588 namelen 6 name marcec filetype=
 0 errors 3, no dir item, no dir index
root 5 inode 8710031 errors 2000, link count wrong
        unresolved ref dir 26699 index 59590 namelen 4 name root filetype 0=
 errors 3, no dir item, no dir index
Checking filesystem on /dev/sda1
UUID: 0267d8b3-a074-460a-832d-5d5fd36bae64
found 63467610172 bytes used err is 1
total csum bytes: 59475016
total tree bytes: 1903411200
total fs tree bytes: 1691504640
total extent tree bytes: 130322432
btree space waste bytes: 442495212
file data blocks allocated: 555097092096
 referenced 72887840768
btrfs-progs v4.0.1

Again: is this fixable?

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_//Uz=eRncN=k+LV4/wdBbnhK
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJVzEHGAAoJEL/Q5oYsiHj06REQAIx066EoG6sOEefW78GkXxLt
rbjVjDD5ebiF3Qa4nM2iWKWz++1amZ0CwMkFdKl5rSaxn8X3FzHJeD1LlzfYZvVw
Px6BAQrqmj0JqNgeuAyBB7r9pX2Te5wt2CG5lC4IKEREnh9gppQ7+KggiMUdTiuk
NYXGm/feBRFqshFk6kW27q+e+ZHTPnLZNxNffWXSvr6/JSRXEUXEo4K4D5bTmfJ9
fsGmGpTEtMfT7h5vCAWUvo9fp2U/JndVHCe+KVFfwmK46skNvI8N0oRhkhQGjFxb
g9Nvmo3lD2uDPu39txOamP9qjlPMTb4LHTY+QWOj9Um8PvYUsWFLTqmy8F9a8eQw
9G0iL4kiRPpv0K919+JNmrCWgBTjO9ED+Kf7Fts1Njq9pnFuHmNVBchXLtTZdcbj
cwpFHUwd8zkB6vzE8WdUtL8OS8C9B/QybLEWdbEfkTF940QBZn5dAvgU8qfsOAEU
exZQ1bYQlLWtBF/6dd8tYQWyMQmv0xTkXSE5LRBFh92DdcCi7nAsErRoUVxeMG15
Sfw70nZ820LGdtsmH64Ml6ypMpJLHBWlXrmH9WKDtFX4hymol0X7cIF7PaERQwDv
MEIK8OB4RaJgUrQaJbI//tBKfwzLwqv+2VIuiUrLi81+BTyLGMvmWG+jXePLddXV
luJPTflwiRRtxq9euFfj
=HYg2
-----END PGP SIGNATURE-----

--Sig_//Uz=eRncN=k+LV4/wdBbnhK--
