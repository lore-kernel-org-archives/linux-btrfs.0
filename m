Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57908 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbaJTICE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 04:02:04 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Chris Samuel <chris@csamuel.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unexplainable corruptions 3.17.0
Date: Mon, 20 Oct 2014 10:01:56 +0200
Message-ID: <12404322.5f6czpaAWj@fb07-iapwap2>
In-Reply-To: <1798492.UPHDTB8iYW@quad>
References: <20141017085448.GA1050018@mother.pipebreaker.pl> <CAGfcS_muumP4VQTUkTTGqg=RpjWrU1A5cC+g4=dKMbdMoQvmXg@mail.gmail.com> <1798492.UPHDTB8iYW@quad>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2297754.omE7CDF5Pz"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2297754.omE7CDF5Pz
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Am Samstag, 18. Oktober 2014, 18:32:49 schrieb Chris Samuel:
> On Fri, 17 Oct 2014 02:09:30 PM Rich Freeman wrote:
> > Just for clarity - when can we expect to see these in the kernel?
>=20
> The stable kernel rules say:
>=20
> https://www.kernel.org/doc/Documentation/stable_kernel_rules.txt
>=20
> #  - It or an equivalent fix must already exist in Linus' tree (upstr=
eam).
>=20
> So until Linus merges the revert into the mainline kernel it cannot g=
o into
> a stable release, and he's not merged it yet.

it also says a few lines below:

=2D To have the patch automatically included in the stable tree, add the =
tag
     Cc: stable@vger.kernel.org
   in the sign-off area. Once the patch is merged it will be applied to=

   the stable tree without anything else needing to be done by the auth=
or
   or subsystem maintainer.

so fixes would be tagged earlier this way and merged automaticly.

Marc

--nextPart2297754.omE7CDF5Pz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABAgAGBQJURMF0AAoJEKyeR39HFBtoQvMH/iKN5bd3JyWzgIO9KeAbZtjK
pgeBeu+N6FqSdeCxnGn6mb7x2zMcaE4kw3kfjef5dA3tuvzZWP24egj68subpCW+
xSBG8B8lWh+3k6niwz/uHwIWaRtTrcjPEw5R4G0g2rmolFeBOF87Yk3f+B6Vvu1g
CsRIOHKnSAnjxU6Je0+h5eCv3LhN9NBSm7engIIXYpO+Y1Mgm97cx6+YprqDzwGj
4R7dH1ZCXwbETQ5fxPjWelHAxLK5FrEswta1XNvXRWI8lkmg1YHJAQ1+xY/dY9Rg
oBpLmKer2L1wXaqpi37iFkGA0okKO79/2m1ooYI8dSKfPYTbffn2O574LF+oTBA=
=b4Wc
-----END PGP SIGNATURE-----

--nextPart2297754.omE7CDF5Pz--

