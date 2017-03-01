Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:65098 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752010AbdCAIka (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Mar 2017 03:40:30 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LoJDJ-1c7kzo2DYv-00gF4X for
 <linux-btrfs@vger.kernel.org>; Wed, 01 Mar 2017 09:24:01 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already exists
Date: Wed, 01 Mar 2017 09:23:52 +0100
Message-ID: <1975016.KbFk7ASZDg@thetick>
In-Reply-To: <21888099.8VRa6s2ieu@thetick>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de> <20170217091915.066488ef@jupiter.sol.kaishome.de> <21888099.8VRa6s2ieu@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7675624.aP76tQxyNN"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart7675624.aP76tQxyNN
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday 28 February 2017 23:14:54 Marc Joliet wrote:
> I think I'm at that point now myself, unless anybody has any other id=
eas.

For example, could the --init-extent-tree option to btrfs-check help, g=
iven=20
that I needed to pass -w to btrfs-image?

Also, the image is complete, so I only need to find somewhere where I c=
an=20
upload a 9.4 GB file.

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart7675624.aP76tQxyNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYtoUYAAoJEL/Q5oYsiHj0whUP/0yBwaXuBlGndm0xPtXkITqT
QkswRLZdJZMgFrJEf2G79gQ+LgOR3HVZnahh4zkrior5EEUK0uCOtRl0PrChCNN4
UmN5J3M8U+YMjyrXZDhj+oaYCna1QdcxZGPWlZgeDeXjt/Piz0MXSgUWrfmlE+dC
7N6hZdjOSdtT7yhOdgory7TFjID31TNsnmffHuzeDRnIW/7dUXbAh2QqN4Q+NMsh
l6ewdpkFJaOmXL0xmk5nPoR4V2xCjoUs4Q72TqMGFl3biAlfcVZqE18+kS7U3j29
81xvLkqIhjoHFHbQV7C6RGyl/y0ETTRINkC+3PgfkNyzzofFs0E2NnfQxfIhL4ui
3Z+Wr2eYuwespYkZnKBl+XYD58pqTPQ0x9+7KjBp6yR6ixvho1Dpb4JWgztUA0yp
elnvq+1bX03y31OWRXHA31O2dJffoMgSEaZJM/NM8UjfqjY+sAygqhN46/nZwYBy
NsCJlXxtvgMlu7q2Q9NIgkUHAv3VjyKRQsRjbu1RZubrDusWOZYcOWngzmM8888E
SXCBTSmCmtZ6QUYx2pluizpxPD4ahOghKrwEN9HQVB8rFofpVkWZzB9i3YnTF74y
8EtC9RSF/RZgpNa+43e9467oPtJ+D/kqgghdZrAUyMJJNWwNXNbDRNddRXJSe0yi
hCI5AOawzAXSEmhZFrHe
=3iOw
-----END PGP SIGNATURE-----

--nextPart7675624.aP76tQxyNN--

