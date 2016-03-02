Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rho.voidptr.de ([84.200.43.138]:59248 "EHLO rho.voidptr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545AbcCBV60 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Mar 2016 16:58:26 -0500
Subject: Re: "WARNING: device 0 not present" during scrub?
To: Patrik Lundquist <patrik.lundquist@gmail.com>,
        Christian Pernegger <pernegger@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CAKbQEqE0w5fewMw9YwooFXaEVT2ecfGf6ZCVvUmQg8SjGx2Zsw@mail.gmail.com>
 <CAA7pwKNH=HkfCLYtxaFSte7eg2vdwumyzddD9WPwn28i9xmuqA@mail.gmail.com>
From: Nils Steinger <nst@voidptr.de>
Message-ID: <56D76039.2020009@voidptr.de>
Date: Wed, 2 Mar 2016 22:50:49 +0100
MIME-Version: 1.0
In-Reply-To: <CAA7pwKNH=HkfCLYtxaFSte7eg2vdwumyzddD9WPwn28i9xmuqA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="kBaLS51mOAlE3T8UPiX0HrwoH6xBo2X1h"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kBaLS51mOAlE3T8UPiX0HrwoH6xBo2X1h
Content-Type: multipart/mixed; boundary="fBJTV7OO25OHVHterqpx4uahXVlNUhglW"
From: Nils Steinger <nst@voidptr.de>
To: Patrik Lundquist <patrik.lundquist@gmail.com>,
 Christian Pernegger <pernegger@gmail.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <56D76039.2020009@voidptr.de>
Subject: Re: "WARNING: device 0 not present" during scrub?
References: <CAKbQEqE0w5fewMw9YwooFXaEVT2ecfGf6ZCVvUmQg8SjGx2Zsw@mail.gmail.com>
 <CAA7pwKNH=HkfCLYtxaFSte7eg2vdwumyzddD9WPwn28i9xmuqA@mail.gmail.com>
In-Reply-To: <CAA7pwKNH=HkfCLYtxaFSte7eg2vdwumyzddD9WPwn28i9xmuqA@mail.gmail.com>

--fBJTV7OO25OHVHterqpx4uahXVlNUhglW
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01.02.2016 11:23, Patrik Lundquist wrote:
> apt-get install -t jessie-backports linux-image-4.3.0-0.bpo.1-amd64
>=20
> Or something like that for the image name. Unfortunately there's no
> stable backport of btrfs-tools (as they call btrfs-progs).

There is now: 4.4-1~bpo8+1

Upgrading from btrfs-tools 3.17 to 4.4 fixed the scrub aborts for me.

Oddly, `btrfs scrub start -B /dev/mapper/foo` terminates with exit code
0 when it aborts due to the "device 0" problem.
That's not supposed to happen, is it?
> EXIT STATUS
>       btrfs scrub returns a zero exit status if it succeeds. Non zero
>       is returned in case of failure.

Regards,
Nils Steinger


--fBJTV7OO25OHVHterqpx4uahXVlNUhglW--

--kBaLS51mOAlE3T8UPiX0HrwoH6xBo2X1h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJW12A9AAoJEO7L9/pIVYboThoH/jBJ6ooeCqcBf7aIVBEdWoZU
faKviulL0w5UJbs+aU4KBhWcFUBu4SWmtFY8d2036HjfGtEy/ADq7DC5g5utb5yB
DvRr3bL8Nx62OWlCvHx74jWn67dFmeh1NR/JoM5f1xQMSbW+XAKWlojsPtbSwjtI
6XaS//nhzX4nCrIGXNs135qPtO3Q+HFt6okVK822xIWPW8Ie6Xj0WSgsJGxK5507
ziQfAG1mV1kCWGRdXAXq0evy421Dqm3VbEYbVriqd5xz8r7iX6bHQ52HpQwB3ofJ
kEn5uFH/GiRG50cEkgLLymRpjAdDicY2qvHN+hwFUco374+yWHVvRdXHK7vGHrg=
=JTFI
-----END PGP SIGNATURE-----

--kBaLS51mOAlE3T8UPiX0HrwoH6xBo2X1h--
