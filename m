Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56121 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752009AbcLQKA6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Dec 2016 05:00:58 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MGRhs-1cMdmQ2z9U-00DEjy for
 <linux-btrfs@vger.kernel.org>; Sat, 17 Dec 2016 11:00:54 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-check finds file extent holes
Date: Sat, 17 Dec 2016 11:00:45 +0100
Message-ID: <33683110.atfvbHhatF@thetick>
In-Reply-To: <6935146.pedKUuRHNK@thetick>
References: <6935146.pedKUuRHNK@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart15767626.HL8XO2IteI"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart15767626.HL8XO2IteI
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Saturday 17 December 2016 00:18:13 Marc Joliet wrote:
> Is this something that btrfs-check can safely repair, or that is perh=
aps
> even  harmless?

Never mind, I just found that this has been repairable since btrfs-prog=
s 3.19.

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart15767626.HL8XO2IteI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYVQzNAAoJEL/Q5oYsiHj0NCYP/R2hDbmqkbDnlllCiHDk52hZ
Swh48dnrB6++SVeSaXF4f7OVPlP9nzwMQIeYclFnQTaQVx3mbQTojcOCJ0QEqvmB
WrGkqkZ65YFPPifF8TmMqyEjx+x/R0yTTlAQ4c05ADvvw1QDENDl7KPq22Cxzw32
bZka3Va2V3mybOTrbMl5km9/WiQg9roZF2y7o+NSFLmSBlWs8xS2NeRdyC718W0F
DTdkUmBAbQkAO3QbOcquolR/LRtAltehoPg09p/2/Zc+RGyIeHbSjH9fbRgY5gtS
Dxv77Tkut9QtChDrlADdBr0uRArlqtH+KqWa+uKKhpOWibSKM/GAbeUxH2G/MkHW
hXpWYTy3JcX9Af2aDpuDsfiJmV8gYCd962LUpw7YLesr4p2vK/RmUfBVv9y/Itxz
JsoisB9Lesxm/bTpRUR3DLfpxF2sYaBH53pwz5Za2hQGE8L4IisxInNlgTYwdhHc
zwy5SUztRqj+vbi+0A038SNfeEWFAly6Q5EcTmsUos0CMAE1YM9WAqJ/c5nh2wyD
3Q9RIpxWpbOSt07TedjZRnJziK9QBNvnhbBK+yTsukSE4/FqhmHg3dNU5eOSuvkI
iKB+J1x6mVKn5ALZevC1O8pE3ZSuRpbgxOVPj5mHtgN7v7Zymbm7cogR191QFPPD
9KZQmLN6Igwd38GonioA
=oAAy
-----END PGP SIGNATURE-----

--nextPart15767626.HL8XO2IteI--

