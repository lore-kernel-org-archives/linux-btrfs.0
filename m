From: Eric Anopolsky <erpo41@gmail.com>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 14:54:11 -0600
Message-ID: <1224622451.7412.1.camel@telesto>
References: <20081021132322.271ad728.skraw@ithnet.com>
	 <1224597580.27474.93.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZpBH8mhjtQfQ5UVOqk+P"
Cc: Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224597580.27474.93.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-ZpBH8mhjtQfQ5UVOqk+P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 09:59 -0400, Chris Mason wrote:
> >     - power loss at any time must not corrupt the fs (atomic fs modific=
ation)
> >       (new-data loss is acceptable)
>=20
> Done.  Btrfs already uses barriers as required for sata drives.

Aren't there situations in which write barriers don't do what they're
supposed to do?

Cheers,
Eric


--=-ZpBH8mhjtQfQ5UVOqk+P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASP5BcganbLzqVaVfAQKOzggAibiwKeMY/9CI/p9Cw9lgNB54zukaj0jL
y6eQk5KGIdxw/MIfr2TNjbklQDHmwvuqmwbbJY/EwsfVa8E6Oe1zanekoy0LL4Z4
MRX1ExmZt6KLyhMMhJPR6iS1ODi+LteO5Ho0wGyBkunjuYb3MrT7RjMB/KkPUTWA
1gShvDfCER5PK74Vukz/2Rwg30iLzt21Y4Wr9x3QabY4FId2f1yzzKBfL8PN7V4M
3QR8okTe2Hk46hJCmLjA9M7kDI18aZE3GwxNDJjt5F1FPDxa7URpz+q4C83pgSZf
g+0IFqP6tfmST4XkR7tO2U5HHjvSMNvtwYLL8P+PcTeoO0IbyPbbYQ==
=h6a9
-----END PGP SIGNATURE-----

--=-ZpBH8mhjtQfQ5UVOqk+P--

