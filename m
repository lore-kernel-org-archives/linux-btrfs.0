Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64273 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbaGSU6V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jul 2014 16:58:21 -0400
Received: from marcec ([77.22.138.176]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0M2nfO-1WI9iH1vGA-00sgZ8 for
 <linux-btrfs@vger.kernel.org>; Sat, 19 Jul 2014 22:58:19 +0200
Date: Sat, 19 Jul 2014 22:58:10 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC errors during balance
Message-ID: <20140719225810.7a28d13b@marcec>
In-Reply-To: <20140719221051.57378a41@marcec>
References: <20140719221051.57378a41@marcec>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Y++r+mtarFXkqfOW7JEjLfl"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Y++r+mtarFXkqfOW7JEjLfl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Sat, 19 Jul 2014 22:10:51 +0200
schrieb Marc Joliet <marcec@gmx.de>:

[...]
> Another random idea:  the number of errors decreased the second time I ran
> balance (from 4 to 2), I could run another full balance and see if it kee=
ps
> decreasing.

Well, this time there were still 2 ENOSPC errors.  But I can show the df ou=
tput
after such an ENOSPC error, to illustrate what I meant with the sudden surge
in total usage:

# btrfs filesystem df /run/media/marcec/MARCEC_BACKUP=20
Data, single: total=3D236.00GiB, used=3D229.04GiB
System, DUP: total=3D32.00MiB, used=3D36.00KiB
Metadata, DUP: total=3D4.00GiB, used=3D3.20GiB
unknown, single: total=3D512.00MiB, used=3D0.00

And then after running a balance and (almost) immediately cancelling:

# btrfs filesystem df /run/media/marcec/MARCEC_BACKUP=20
Data, single: total=3D230.00GiB, used=3D229.04GiB
System, DUP: total=3D32.00MiB, used=3D36.00KiB
Metadata, DUP: total=3D4.00GiB, used=3D3.20GiB
unknown, single: total=3D512.00MiB, used=3D0.00

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/Y++r+mtarFXkqfOW7JEjLfl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTytvqAAoJEL/Q5oYsiHj0LYUP/3Ng05erAaRlAgwU2L742qV/
8lWiOiCg1gJ4uPXXSR7i1FiAE4RH2ZJ390Zl+rHrWf50WR+v8tNcHBKYVVgzwnMe
fm3+SwAYwk3Kdr9UPVuKRXYO+PITR/7noMvA6U1Z+kOjx4Tfh0FMbioPMp9V5GJh
4hSFR/QRVUnMnMvA4BJcNAWziWwkqL3Bw0lyKRiHTGABHwlyeN0liOboBrO86MbN
8YLuNRkYzWxa7BGEVJl9g7hAnAiTQ6PZ5O+rELsinyUAHIT6f0KelccaYWPt49wI
Hds00jtJR7ofVfcFlTaS0Q31YAc9IF+cY1B/N2vo/+tqVE1lgHSbQErq+RUTDoH3
4D8hhZx5rOUDpqrAWaOyDR7ow3QgAkvebVlAIAGXE+G+3SjUWsklRna5F98lZcuM
Ftx1XQRga2S8UpVt/5QWdm8hfX/p4JVpgt7fiNqKK9NDXDhlcN3gF1U8Qr5mgf36
N9U9aoOrogpgZPu1HkSmNNGOa2/OE9g1JVyPsyK/DF6+fjY7bPLa/hxS7yUB8DD1
/lslrFswCLlyhsKb+vWqCOF+rXHFKtR/guO6KxosbaraLtr6JvgUfMOx3jIesZAP
Nu//0oZq0g+UnQBf2QM/4qlzR8kQoUmIi/D0VmtDTaBDlWVNFmkvyrPdkwcQlG3o
MtO3T+Gig8tchSASdeQ+
=a/Al
-----END PGP SIGNATURE-----

--Sig_/Y++r+mtarFXkqfOW7JEjLfl--
