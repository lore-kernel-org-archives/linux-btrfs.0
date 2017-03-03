Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57484 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751545AbdCCL4I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 06:56:08 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0Me8ws-1cwKZ11eFa-00Psjp for
 <linux-btrfs@vger.kernel.org>; Fri, 03 Mar 2017 12:54:13 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already exists
Date: Fri, 03 Mar 2017 12:54:07 +0100
Message-ID: <12726616.JRxLSmG3MF@thetick>
In-Reply-To: <905fd8af-b3b5-343a-09b1-c2f569e8dd19@cn.fujitsu.com>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de> <1714469.dJ89oe0hXx@thetick> <905fd8af-b3b5-343a-09b1-c2f569e8dd19@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2424428.HGbY5iTYG0"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2424428.HGbY5iTYG0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Friday 03 March 2017 09:00:10 Qu Wenruo wrote:
> > FWIW, as per my later messages, after mounting with clear_cache and=

> > letting
> > btrfs-cleaner finish, btrfs-check did *not* print out those errors =
after
> > running again.  It's now about two weeks later that the file system=
 is
> > showing problems again.
>=20
> If btrfs-check didn't print out *any* error, then it should be mostly=
=20
> fine. (Unless there is some case we don't expose yet)
>=20
> The problem should be caused by kernel AFAIK.

So you think it could be a regression in 4.9?  Should I try 4.10?  Or i=
s it=20
more likely just an undiscovered bug?

> > Oh, and just in case it's relevant, the file system was created wit=
h
> > btrfs-
> > convert (a long time, maybe 1.5 years ago, though; it was originall=
y
> > ext4).
>=20
> Not sure if it's related.
> But at least for that old convert, it's chunk layout is somewhat rare=
=20
> and sometimes even bug-prone.
>=20
> Did you balance the btrfs after convert? If so, it should be more lik=
e a=20
> traditional btrfs then.

Yes, I'm fairly certain I did that, as that is what the btrfs wiki reco=
mmends.

> Personally speaking I don't think it is relative for your bug, but mu=
ch=20
> like a normal extent tree corruption seen in mail list.

OK, so is there anything else I can do?

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart2424428.HGbY5iTYG0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEax7Ya5gDQFOJHKGQv9DmhiyIePQFAli5WV8ACgkQv9DmhiyI
ePQzwRAAqCm3x1WuHmS12MpVPMQEWTTW2GtLQfaLlhcjiQ20B3ewS7vkv3TPZkfp
veVI9hXLdSRPtAwj4dAp8ePmQ3NgYIQb6Fd7lRJkSqPDQkuEkw776/oJNy3PY4Z4
AVIjouP8G5q3F2SqF2pX1x35gmr72jel+V+kndHYBj/rXLMvCiDf2QKEShQr7UsU
1xTATkX4rDvj2X73cSHTuUqjPsDgpldJbuNYhy8bSLtw7ZJZ0vMUEvBiTYVT/Nak
Vz2LMuQfGQasfrxn1mDGlb04k7FXaMUlFVlrpXh1AsRai8wiHQMmV+zVVszCkvP/
V76otnFQAus3VWkTWKVnaEbpwusFwegFFsFcMCUCeNqJrolcRMFrokap+/h5NFrE
juvuIj2S7p3rffz716yBnQx4K/hA5a9Xm0VaoVzXw4ZWmC8DKbXD6gE+U9Gqyjq9
HtWq1cRFSKNx3xqBszOi2F0wk0Ij9+Jz/cW1EqzpipPYrO1KDKfht0bSclc1ypRz
QDCaK8saxAGiICn6C3b9OgEw8JXS/gWb9JKgn0IYlnQ2m4F6+zB0hr7tHuMpctcB
hC3Kvv3yMSFGEwK/0jdkj70s3ZzNrBNOsX7m/0uoNKMARtiCan0GE0EPPWmkJ2Mr
7UtbnSqbCrYApdrs+rX9RWxd0BUHYcelw8WrAibR2ncwUHUztwc=
=I8m1
-----END PGP SIGNATURE-----

--nextPart2424428.HGbY5iTYG0--

