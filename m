Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.automatix.de ([213.131.255.221]:56473 "EHLO
	mail.automatix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934107AbcDLOdk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 10:33:40 -0400
Received: from [192.168.11.16] (vpn1 [213.131.255.219])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: jojo@automatix.de)
	by mail.automatix.de (Postfix) with ESMTPSA id B1387601FF
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Apr 2016 16:24:37 +0200 (CEST)
Reply-To: service@automatix.de
To: linux-btrfs@vger.kernel.org
From: Juergen Sauer <juergen.sauer@automatix.de>
Subject: Btrfs fails desatrerous on fuzzy tests
Message-ID: <570D0520.2090107@automatix.de>
Date: Tue, 12 Apr 2016 16:24:32 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="r4kGxhLXf4TTxXOlBC1MIDk4lsUE4GcaQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r4kGxhLXf4TTxXOlBC1MIDk4lsUE4GcaQ
Content-Type: multipart/mixed; boundary="vrti3eHM82OJFuBLu49pw7Vxt0dLXN3VE"
From: Juergen Sauer <juergen.sauer@automatix.de>
Reply-To: service@automatix.de
To: linux-btrfs@vger.kernel.org
Message-ID: <570D0520.2090107@automatix.de>
Subject: Btrfs fails desatrerous on fuzzy tests

--vrti3eHM82OJFuBLu49pw7Vxt0dLXN3VE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi!
do you know this paper ?

http://events.linuxfoundation.org/sites/events/files/slides/AFL%20filesys=
tem%20fuzzing%2C%20Vault%202016.pdf

It was rushing through the Linux press sites in Germany, see also [german=
]:

http://www.pro-linux.de/news/1/23449/fuzzy-test-f%C3%BCr-dateisysteme-vor=
gestellt.html

mit freundlichen Gr=C3=BC=C3=9Fen
J=C3=BCrgen Sauer
--=20
J=C3=BCrgen Sauer - automatiX GmbH,
+49-4209-4699, juergen.sauer@automatix.de
Gesch=C3=A4ftsf=C3=BChrer: J=C3=BCrgen Sauer,
Gerichtstand: Amtsgericht Walsrode =E2=80=A2 HRB 120986
Ust-Id: DE191468481 =E2=80=A2 St.Nr.: 36/211/08000
GPG Public Key zur Signaturpr=C3=BCfung:
http://www.automatix.de/juergen_sauer_publickey.gpg


--vrti3eHM82OJFuBLu49pw7Vxt0dLXN3VE--

--r4kGxhLXf4TTxXOlBC1MIDk4lsUE4GcaQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlcNBSUACgkQW7UKI9EqarHeiQCfbpDas7twcswx6jWPTsYC2NTR
puwAniNexl91OFWoq1W2MJZUigOxvQa+
=LR0p
-----END PGP SIGNATURE-----

--r4kGxhLXf4TTxXOlBC1MIDk4lsUE4GcaQ--
