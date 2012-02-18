From: Chris Samuel <chris@csamuel.org>
Subject: Re: btrfs open_ctree failed (after recent Ubuntu update)
Date: Sun, 19 Feb 2012 10:00:27 +1100
Message-ID: <201202191000.34819.chris@csamuel.org>
References: <455D7450-3946-478A-9021-6B01A4D7FB9B@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3151165.5maGbWLSPI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Curtis Jones <curtis.jones@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <455D7450-3946-478A-9021-6B01A4D7FB9B@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3151165.5maGbWLSPI
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sunday 19 February 2012 07:34:22 Curtis Jones wrote:

> Any help would be appreciated. Thank you. Please CC me on any
> replies.
>
> Linux veriton 3.0.0-16-generic-pae #28-Ubuntu SMP Fri Jan 27
> 19:24:01 UTC 2012 i686 i686 i386 GNU/Linux

That's a fairly old kernel in btrfs terms, you may want to try the=20
latest 3.2.x kernel from the Ubuntu Mainline Kernel PPA here:

http://kernel.ubuntu.com/~kernel-ppa/mainline/

If that doesn't work out you can try the latest 3.3 RC there too.

I'm running the 64-bit 3.2.5 kernel from there on Kubuntu 11.10 and it=20
is fine (modulo boot time complaints about the apparmour stuff).

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart3151165.5maGbWLSPI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUAT0AtjI1yjaOTJg85AQKCKAgAjBymXgGocFNXU3+bKW4v3y8Gk/HkpxvJ
w3IP4P5nhLZtdkBGPkvcHL6XZcspTU6VOyU6eaquHEOpCLm4W6EK40BXG3/Epb/x
5p7koiscDP4kvH6jf1UIJcNjpW5JxY7BHvum2egH9R3b/2yUE22f9N/P4XoDnCrw
w8/klNsstDitdJeasq0Pvt6HURN/U2U9dvJzXqAVA3z8sLj7u38n96ZHrPB7oH3i
l9UhIqyImYjApzM08MAu6EThl96BKU8KlUAMdFw9DJWwAtBflyOkh1Tsm7wJn57m
APHvTvIEDU5uSRtA77HHBRBFs5BSP+Lr16sjgnbdddcyvLCqkfjCYA==
=IhdV
-----END PGP SIGNATURE-----

--nextPart3151165.5maGbWLSPI--
