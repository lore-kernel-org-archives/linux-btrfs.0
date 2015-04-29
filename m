Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53606 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbbD2WYl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Apr 2015 18:24:41 -0400
Date: Wed, 29 Apr 2015 22:24:38 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dave@jikos.cz>
Subject: progs bug(ish?) report
Message-ID: <20150429222438.GG18480@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GUPx2O/K0ibUojHx"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--GUPx2O/K0ibUojHx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Dave,

   Not sure if it really counts as a bug, mostly just an
inconvenience, but ./configure completes happily, and then make fails
with:

btrfs-convert.c:27:21: fatal error: sys/acl.h: No such file or directory

so I guess it needs an additional check for libacl1. I can't see a
pkg-config entry for it on my system. OTOH, I don't see where there's
any linkage with libacl in the makefile, and it's clearly finding the
include files successfully.

   Maybe something like this?

AC_CHECK_LIB([acl1], [acl_init], [], 
             [AC_MSG_ERROR([cannot find acl1 library])])

   Hugo.

-- 
Hugo Mills             | The Creature from the Black Logon
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--GUPx2O/K0ibUojHx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVQVomAAoJEFheFHXiqx3kD6EP/jUgXbDgb4W63M5WUp4PQMFy
twT0X1UUHkJWckOVhWAg1zW2PWVgU8x7r2ljfgiqs6wFd5f4cHEEODU6f+X0yu3+
tmQ8mK04ekXZ5Ta0gWOOBa2ly50jKJwtCKw+wqFWHBfT3nom6SK/VAy27q+0fjLC
QqtXhah4xTAUkllxG13HlaRMLLSknfFhZVnpJHFyUP/QngAg9iD6OjeU2YKhzUWG
6mYXZ3elgGlKKJNYnYhixtLg/UCn4JWhrh553+mumbBP4V9HfUrTxi/sAWdHpI3Z
kH+zprvBVJzfa6qWUPhuTgdsNK4PjtJK5wb9rR6pqpI2sufDNtdrcCiwQVytDKyQ
CZfJlCt84Xlf4dFkeuv5dafkqQCLXZUhxTz0caK37cTQ37D8SDxAR44ORG/nV2ej
UZ+rL9e9L4xdFrMepC9gdBCU8T5KWTjaWuuPARRcTuDQTwHkcQesGkaJj4mA/vg5
/QAfPwaUrlsNJpkRqy2pQW03giYX81B9zcH2sYVZR/xtftivDP7J6oc7TwI/eNYW
Vgn7y/4YHeawXzJb5lU6hCf4CnSzbQqNxk4YMALGI3foXPbxks8ARBPEu4DS1g8q
Vw7nUdV/Z0tCVcRCYAwpBeWyBZp2qpzLLwreb5ReSOqG3HeaULWV9JR1Iz+ySta/
CMel+zvNst3CNLgCG9b4
=yCjl
-----END PGP SIGNATURE-----

--GUPx2O/K0ibUojHx--
