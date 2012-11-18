Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33506 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab2KRVTd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Nov 2012 16:19:33 -0500
Date: Sun, 18 Nov 2012 21:19:30 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Remco Hosman - Yerf IT <remco@yerf-it.nl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Sparsify / hole punching tool
Message-ID: <20121118211930.GD11121@carfax.org.uk>
References: <97B8CC50-0F4A-42BE-959F-26C86A2C3FAD@yerf-it.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C+ts3FVlLX8+P6JN"
In-Reply-To: <97B8CC50-0F4A-42BE-959F-26C86A2C3FAD@yerf-it.nl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 18, 2012 at 10:04:29PM +0100, Remco Hosman - Yerf IT wrote:
> I wrote a little tool you can use to scan a file and punch holes, so make it sparse.
> 
> Confirmed to work on 3.7.0-rc6
> Feel free to use it in any way you like, and of course improve it. 
> 
> http://pastebin.com/8SjEsBLD

   For archival purposes, it's probably better to put the whole thing
inline in the text of your mail. This also makes it far easier to make
comments on it, should anyone feel moved to do so.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- In theory, theory and practice are the same. In ---         
                      practice,  they're different.                      

--C+ts3FVlLX8+P6JN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUKlQ4r9z9OVl50rAAQIRJA/+Pm3B6uQlQSJNUm7KFx8vqYE0hkiNbmel
AiZz6toX6pMPmzAwmdRrruRyoQoJHCJSt7YQTFhv0CfdkTbsr6QJBRfDkll11AHr
0Vhj1Hl27cooTI1rodAQdxqka6iT7XXxjRhNR2anqxyFENuv7QZrn16Pw6d1/RA6
9QfBdD4v8NeTdtrV4dbk7APw77E1efuuhnAjR14lPfp/KXKZcDuZ4e5Ex9nCA48u
udFSgwa8KXye0B8VIkW3szlvcYZxcym8fTCj3kTEFx4E3yo0cAiG6V/DEfDnLQ5X
Ow/5E0fhSzF/9X7lSLUEyEKUaVt50ExWM3Lf2J+laDJk+73gOpxD225dSU5Zu49V
iWk/qgfw++ZsLwTZaKDICY0TCUJ5krkrAof4qfHRRuP96d/ARF035efExpj5x5V9
jzKqgHEBuORYRdvA8tP9nSBhWpRcMvMCojLWvnDwa67X0Mqm7x4IEdx3EXpQicRH
kkxVGcBRuGQUdmk+fZBlfqnvDL9ZIcqLPFM2retkdblEAVZP05Ueg13G8LrO12zh
0F4QRmuD5qjQg10bxY2jdmWNlLHFK7xXeRo4EH3cRKCrX44WVqTJNpJid2IhWbEQ
ZgrOsZSgZMtX71+2A/twQ1RQ5mFb4XuaZSU3paEzKMa6o4HJTU23unyLwn37Hd6y
jJtCA+YGkt0=
=akZe
-----END PGP SIGNATURE-----

--C+ts3FVlLX8+P6JN--
