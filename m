Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:55145 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaGSV05 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jul 2014 17:26:57 -0400
Received: from moh2-ve1.go2.pl (moh2-ve1.go2.pl [193.17.41.186])
	by tur.go2.pl (Postfix) with ESMTP id 28F0E699F3F
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Jul 2014 23:07:01 +0200 (CEST)
Received: from moh2-ve1.go2.pl (unknown [10.0.0.186])
	by moh2-ve1.go2.pl (Postfix) with ESMTP id 8A52944CF2C
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Jul 2014 23:06:14 +0200 (CEST)
Received: from unknown (unknown [10.0.0.142])
	by moh2-ve1.go2.pl (Postfix) with SMTP
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Jul 2014 23:06:14 +0200 (CEST)
Date: Sat, 19 Jul 2014 23:06:11 +0200
From: Piotr Szymaniak <szarpaj@grubelek.pl>
To: Chris Murphy <lists@colorremedies.com>
Cc: Marc Joliet <marcec@gmx.de>, linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC errors during balance
Message-ID: <20140719210609.GR8330@wloczykij>
References: <20140719172605.445e8445@marcec>
 <39E33553-3073-483E-9A2A-088212B40D0B@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GYaKytDE8aa4+VVK"
In-Reply-To: <39E33553-3073-483E-9A2A-088212B40D0B@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--GYaKytDE8aa4+VVK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2014 at 11:38:08AM -0600, Chris Murphy wrote:
> [96241.882138] ata2.00: exception Emask 0x1 SAct 0x7ffe0fff SErr 0x0 acti=
on 0x6 frozen
> [96241.882139] ata2.00: Ata error. fis:0x21
> [96241.882142] ata2.00: failed command: READ FPDMA QUEUED
> [96241.882148] ata2.00: cmd 60/08:00:68:0a:2d/00:00:18:00:00/40 tag 0 ncq=
 4096 in
>          res 41/00:58:40:5c:2c/00:00:18:00:00/40 Emask 0x1 (device error)

Afair those are somehow related to NCQ.


Piotr Szymaniak.
--=20
Komnata  audiencyjna  zlotego  Bruna  przerastala  wszystko,  co  dotad
widzialem.  Musial  zatrudnic  dziesiatki  programistow i kreatorow, by
stworzyc tak wyuzdane i wysmakowane  wnetrze.  Dzwieki, barwy, ksztalty
i zapachy wywolywaly erekcje.
  -- Marcin Przybylek, "Gamedec: Syndrom Adelheima"

--GYaKytDE8aa4+VVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTyt3BAAoJEEMpAov1cw9lUhAP/jGPPNY92gmI3YhwAmYFDGU6
p4XO2jI5yXO50Is64Xx/52jpKnbwg9yDiPA7vPcP5Hz2UahH+2MtE5KM3MpKbPYM
C7h/igpt+jrpNk2rf41JWdvDWjU6S+j/8/1VRhKyPbiaU4Er5L4KzBFPjQhVFihR
9SEJhaLEhwh7krZ2gL9UZqEa5Tng4AocGRsOUJsbq29O9JsyE+HrcVa3OrbLjcMh
vjzqgmdwiKdapCFWMce+NNRFmmP5dCNX9Mib+QHpWAOLnMysYFFDIiV05TAhRr0r
IL2cUgwHVCcQbHmSfW99KrZ7MJ2twHMUafmFLaWFduMfynUsoX5RVGJxST5LRwFy
Cs6VbNU63fLuzrwp3Onc4aKapNeoUytZfqewZLiN/lodDYR9G9CPu+WcVtgbVhFy
Z/cfeIGQz9dFlJ+0alP2YemYOQRWNM/Q1kVhbeWPE5O3EAPr4kdxqul1NHJORwCY
7D/doNVu/VaarZjQBc+GGeKn3yDl5N/9HqhfWQHjkK4GiPeAySbItr0Rfxlw7gvF
VVIgYb2FI+NLnsIkHfDQWPV2yhEpM9I5XrCM/ouxjd4YDcM5xsH0MUB+goDnzGPn
gdC/lAgNG+tRDIgPGxCLHQwsIDdjQ/1p41lQviuo3iKxSonaEnQ6ruxgwML/5F65
c2nmk38sneCssrMP/yZh
=rxx/
-----END PGP SIGNATURE-----

--GYaKytDE8aa4+VVK--
