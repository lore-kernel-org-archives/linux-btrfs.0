Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49771 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932160AbcIKTqf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 15:46:35 -0400
Date: Sun, 11 Sep 2016 19:46:32 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Small fs
Message-ID: <20160911194632.GF7138@carfax.org.uk>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
 <5440522.9CHaGU5Wjs@merkaba>
 <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net>
 <14309857.N6fGUh6qoJ@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3Pql8miugIZX0722"
In-Reply-To: <14309857.N6fGUh6qoJ@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3Pql8miugIZX0722
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 11, 2016 at 09:13:28PM +0200, Martin Steigerwald wrote:
> Am Sonntag, 11. September 2016, 16:44:23 CEST schrieb Duncan:
> > * Metadata, and thus mixed-bg, defaults to DUP mode on a single-device=
=20
> > filesystem (except on ssd where I actually still use it myself, and=20
> > recommend it except for ssds that do firmware dedupe).  In mixed-mode=
=20
> > this means two copies of data as well, which halves the usable space.
> >=20
> > IOW, when using mixed-mode, which is recommended under a gig, and dup=
=20
> > replication which is then the single-device default, effective usable=
=20
> > space is **HALVED**, so 256 MiB btrfs size becomes 128 MiB usable. (!!)
>=20
> I don=B4t get this part. That is just *metadata* being duplicated, not th=
e=20
> actual *data* inside the files. Or am I missing something here?

   In mixed mode, there's no distinction: Data and metadata both use
the same chunks. If those chunks are DUP, then both data and metadata
are duplicated, and you get half the space available.

   Hugo.

--=20
Hugo Mills             | Questions are a burden, and answers a prison for
hugo@... carfax.org.uk | oneself
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                          The Priso=
ner

--3Pql8miugIZX0722
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJX1bSYAAoJEFheFHXiqx3kt/QQAKJ2cgBNHRBlSjlte732aHlX
7yhMaqttbVDjTAS10vRwFBBPTTW2HI9TA6ZueEmoKrARlydhbRJ6zvZ+hB85mgnn
Z3ooSzVmmQtXWjI9vvepp7fYS8YEPFuJBEKX3+hNZR8ogs8+dJLdYjOlK11j0yFZ
0qLRpVr1iz/UDEflUHrLsctrkCY/sbadM+XsjiwivszJCjr6wWf1K/vaLP48l71T
1hPhg1EMRUK2TK3krm8QVnJKj/qy9tNY5SKzS8FAioFH8sxlHCfKv7BbeSUViBCf
QAzW3gr1H4XrpORm9ih6BKTAn3EtDf0uxpH8/MPCk1fRePduXZoWQlHyqNzd7PgF
vO3a1I/ledudPxVosACg3GeoFdBz1NI7N8w1YJ3kC94reeUg7Zq2+BvInJ9iPrw+
OMB3Zv9mlU2InrIwQa+M7nIBQY9e1hhwGLub/6goUHRdKiwQ4QMmuD4sp3HIG7Sx
i4YEGHhSR2DUhUEZKLHlJrvBt7YgONhcobAIOmoawOV07YB3piVXt6CWUGGjPJ9v
oaGqStdUbjgODd7m5H5e8D/EDR7x5gspymQlI+PLfenFDu5ZIYO8tlln1bheRCqD
cNx6vSTZHoAejn1FWAaEZPyfMsm6XP2hCpF+GosHZ//cfyEUrTgoHvUM/7Wqt6Ju
q7X4JsYQnlAEt6mVwLoC
=1fg6
-----END PGP SIGNATURE-----

--3Pql8miugIZX0722--
