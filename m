Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47673 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbbGINyu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 09:54:50 -0400
Date: Thu, 9 Jul 2015 13:54:48 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs subvolume clone or fork (btrfs-progs feature request)
Message-ID: <20150709135448.GH10539@carfax.org.uk>
References: <CA+X5Wn4YoAByr=OMHHmS5X86iCJos4O=AbwFuy+iH=OrKmVhNg@mail.gmail.com>
 <CAG1y0scpWEF=590bM6dxkOZLAtCMwZaPCtHRuQjTT5DMu5ATrQ@mail.gmail.com>
 <559E6411.6090109@gmail.com>
 <20150709124121.GA25033@panda>
 <559E6D80.7010607@gmail.com>
 <pan$808e5$18b28ebb$f039d1c6$8c98ba86@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rCwQ2Y43eQY6RBgR"
In-Reply-To: <pan$808e5$18b28ebb$f039d1c6$8c98ba86@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rCwQ2Y43eQY6RBgR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 09, 2015 at 01:43:53PM +0000, Duncan wrote:
> I could have sworn btrfs property -t subvolume can get/set that snapshot 
> bit.  I know I saw the discussion and I think patch for it go by, but 
> again, as I don't use them, I haven't tracked closely enough to see if it 
> ever got in.

   Are you thinking of the read-only flag? That's not the same thing
as the various UUID properties (e.g. parent) which can be used to
detemine if a subvolume was made using a snapshot.

   Hugo.

-- 
Hugo Mills             | Someone's been throwing dead sheep down my Fun Well
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                          Nick Gibbins

--rCwQ2Y43eQY6RBgR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVnn0nAAoJEFheFHXiqx3kVL8P/ArsVPZg62V69BL8gp19Zx0W
gLtrJUuR9Js0zcV/s37DMzgnUpxM0/muYheNS71CRdwIAUP6mjBzOrmEuRPXdLv0
aCO0KPemaGSclleV8fza8LxnLykwGR8Ur2zXdtsr28IV8xzyltlbMBzzMsdsIoMN
4kVcy+OxtYPOcGpBFOlqclzAmlYgccGVEKfhdDuvIesIRpgYGthJo9gDUpr1p955
k2koL68pdnfVL6lLlun3K0O8q7+3HImO8fvSKc1xFWMA4sR6DVe1JbPTNHUync/O
Ks0pIZHZ4u3nq7LLDWOxZ09qOZSMzrwafxHj5+t2ANAjKmD1Am1ehPiqgXqbVqgV
5Q1qy/R8pCPSa9yPcaAj39f+iMwIsJ2KPTXrqf0iBtGv6NesO0jUc/bap+tnMuvB
QH7t1Xufsc5kH6kykKWDd9p0dGVqsw4IMkm3eFwwaN45lte+OeZIzVvRcol6L2OE
5Sj4I72Q6hTaX4i0Fcy4pDNraYybHCflnre9xKwy0vHy9P3JDEKoO94PFV4PgT/p
pt/iV58tKAs2xyv26UY0gg12tKLR+FsfEBWCY+oUeXUhg1VUIxLxnbu+tRUXy98D
8DCgJNfG008WckJWZ+dShdbl8szPKXEPemnkuGI8KDWg/VaD7fUXvEYksjvKm133
DeR1xTHEAxfWJiP/AS1q
=MjWV
-----END PGP SIGNATURE-----

--rCwQ2Y43eQY6RBgR--
