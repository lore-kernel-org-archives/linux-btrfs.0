Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from port-92-195-88-32.dynamic.qsc.de ([92.195.88.32]:48917 "EHLO
	richtercloud.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbbCHUAy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Mar 2015 16:00:54 -0400
Received: from [192.168.178.21] (unknown [92.195.88.32])
	by richtercloud.de (Postfix) with ESMTPSA id 3F21282894
	for <linux-btrfs@vger.kernel.org>; Sun,  8 Mar 2015 20:00:42 +0000 (UTC)
Message-ID: <54FCAA65.8090901@richtercloud.de>
Date: Sun, 08 Mar 2015 21:00:37 +0100
From: Karl-Philipp Richter <richter@richtercloud.de>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Setting `compression`  on subvolume causes `BTRFS error (device sda5):
 error inheriting props for ino [inode] (root 419): -28`
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="RGoUAoo19EWrcXSFm3xhXHQnAkIjBphJH"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RGoUAoo19EWrcXSFm3xhXHQnAkIjBphJH
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,
Setting the `compression` property on a subvolume on Linux 4.0-rc2 with
btrfs-progs 3.18.2 causes the error `BTRFS error (device sda5): error
inheriting props for ino [inode] (root 419): -28` to be logged to
`/var/log/syslog` (where `[inode]` is a number). I assume that setting
compression on a subvolume (with `btrfs property`) with a value which
differs from the parent volume is supported and that otherwise `btrfs
property` would have failed.

Any help or pointers are appreciated.

Best regards,
Kalle


--RGoUAoo19EWrcXSFm3xhXHQnAkIjBphJH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJU/KplAAoJEGadKJ8eJ7ZGLdUIAMCicSmV8kVb33QVJ6z/VT01
7dQJV106qEC74VJyw4Zdc/Tq51GfLtz8GCWNU//YcAtAyqE2FjGbKj8jfTccGgmB
1R75WJVMrkqPsMH+B/U7id5fxE6zxr44BuQylBpfJ4amK47ppBA18PKTwvfcm5bP
awyxPm613j7VRvrl8XMo/deoU5AKqEKH/EXguOoxacDrhbVht72ZXBPxYnoXjPE+
7f1gDi5riT5FLU7olvV5goGb6zHiHWa7Lppd4nyJNqZzWN8mC//270e3OB6gp8Dr
B/5Wr4jqwv42Vgdqq1cqfYkw5cc/H+T9MyIG6rxpaJbsRUfUMhSuwgNz2uUgXD0=
=9ISs
-----END PGP SIGNATURE-----

--RGoUAoo19EWrcXSFm3xhXHQnAkIjBphJH--
