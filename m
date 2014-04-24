Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38320 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbaDXQ3e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 12:29:34 -0400
Date: Thu, 24 Apr 2014 17:29:29 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send receive, clone
Message-ID: <20140424162929.GH2391@carfax.org.uk>
References: <35B44B63-D139-4E0E-AD6F-2320B79D19B1@colorremedies.com>
 <20140424155510.GG2391@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZYOWEO2dMm2Af3e3"
In-Reply-To: <20140424155510.GG2391@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ZYOWEO2dMm2Af3e3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 24, 2014 at 04:55:10PM +0100, Hugo Mills wrote:
>    I'm trying to think of a case where -c is useful that doesn't
> involve someone having done cp --reflink=always between subvolumes,
> but I can't.

   OK, you can use -c if you don't have a record of the relationships
between the subvolumes you want to send, but know that they're related
in some way. As above, you send the first subvol "bare", and then
supply a -c for each one that you've already sent.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- echo "killall cat" > ~/curiosity.sh ---               

--ZYOWEO2dMm2Af3e3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU1k76VheFHXiqx3kAQLlrxAAn9JIBJvh8a3NnAHWe92zzCbxRE/jcvda
gDWrp3+AZFMrzfwdPMBu3G8YtUACpM0+ZZvqmF/QYSdOgo0v/Xh2oLW+txjIJAxx
qw/6A2IO9rBIt9mVll9zJl0WajCnVLIf6qkEHdVw/L1FzK6XT79C49TlsruJMhdS
Qup1qXcUjLiDEAlBlFjC4EO9YBoVu+cEqPpQOoaEDauz/UQlHQ7kyJNPFJ1iM5CW
YszfkNdWHADon1j3oii9l87wuAgOeUogFSz+qh9mfWojvbr/kQsK9//HHXH6T5Y9
FGcegO6VN2MwQid+IMEO4mvD8QL8m4vqAi/JGlyqNl947HEasiJSV87zg39dumyZ
PJsrl6qdAnmX5lAyKd3fDrSzUy1B1pDcOIHTLN9x/uPvJ3H3pp3TdT+GrUk2e5H7
/gWuoq50jTeuFghkdTqmwldFUF68/40bIspUnwmOxp8/iyNJBzU2DU8Ud6WECt5u
TVFXnLQvQokn7JMHCbXSZacoRxBDtL0yk73dZ4NoKdnxIQuXyShavCjbQQz3Vknw
VXVjtsQzbkojm5VxLzTEMatbDdYzizXOggwRGMmZvOicMcQt7XTBwpZptgpmLPWd
W/LdN1993SnISa4kKQDgGPdTdJZtpF3MrCxuHzv7UyiItmh/qlFW04g+6xa5BaEU
d/y668frIdo=
=o60/
-----END PGP SIGNATURE-----

--ZYOWEO2dMm2Af3e3--
