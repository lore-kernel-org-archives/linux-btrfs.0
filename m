Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39804 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaFMG4s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 02:56:48 -0400
Date: Fri, 13 Jun 2014 07:56:30 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gui Hecheng <guihc.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, 1i5t5.duncan@cox.net
Subject: Re: [PATCH v3] lib: add size unit t/p/e to memparse
Message-ID: <20140613065630.GH1756@carfax.org.uk>
References: <1396428877-24089-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <20140612141516.219f8c6b95f0d4f97332b8c7@linux-foundation.org>
 <539A9224.5060300@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gAUgrzRZ7tRi/Yr6"
In-Reply-To: <539A9224.5060300@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gAUgrzRZ7tRi/Yr6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2014 at 07:54:44AM +0200, Brendan Hide wrote:
> On 12/06/14 23:15, Andrew Morton wrote:
> >On Wed, 2 Apr 2014 16:54:37 +0800 Gui Hecheng <guihc.fnst@cn.fujitsu.com=
> wrote:
> >>+ *	%K (for kibibytes, or 1024 bytes),
> >>+ *	%M (for mebibytes, or 1048576 bytes),
> >>+ *	%G (for gibibytes, or 1073741824 bytes),
> >>+ *	%T (for tebibytes, or 1099511627776 bytes),
> >>+ *	%P (for pebibytes, or 1125899906842624 bytes),
> >>+ *	%E (for exbibytes, or 1152921504606846976 bytes).
> >I'm afraid I find these names quite idiotic - we all know what the
> >traditional terms mean so why go and muck with it.
> >
> >Also, kibibytes sounds like cat food.
> Hi, Andrew
>=20
> While I agree it sounds like cat food, it seemed like a good opportunity =
to
> fix a minor issue that is otherwise unlikely to be fixed for a very long
> time. Should we feel uncomfortable with the patch, as is, because of
> language/correctness friction? Pedantry included, the patch is correct. ;)

   Last night, I wrote a very grumpy reply to Andrew. I'm glad I
didn't send it, because Brendan has managed to cover at least one of
my points much more politely than I did.

   My other comment is that TB vs TiB is a 10% difference in the
magnitude of the number, and so the accumulated error is now no longer
small enough to be brushed under the carpet as we all did in days
past. By Andrew's thinking, a 4 TB disk is 3.638 TB in size. I'd say a
4 TB disk is 3.638 TiB in size, and I can be precise (=B11GB in the
latter case) with both values.

   Hugo.

PS. Let's just not talk about 1.44 "MB" floppy disks.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- 2 + 2 =3D 5,  for sufficiently large values of 2. ---        =
=20

--gAUgrzRZ7tRi/Yr6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU5qgnlheFHXiqx3kAQJHAA/8C2IEVOW62UBcWpfCbtp3ipz3SsJKywuc
qxP3j3seNdqdlhc2q1Z9lv8dlFH9OCE2wXc0fSGhWrFqf6f1/WLEt4vblFqkwn4+
qpaKfbODs53hAzS8GrryF4465qXgtJO+CO5F8vlR+zBY/2OA36G9dwbvCWnloqim
4QL0IGJdV7JZmTxqsVQWVuVxIqLD7qoxQ80rO1ipP7QGro0CdketlPC4PHjjdqhA
tpO6c+a5QXxVT6rDBjxg1gwwaCqQKEvLBdAK+oRUvoDxRgejDmJACxh2aPbI6vy1
qlMvTLbo73dhhe2RVFtbPtWLh/djkCgv+9v5mHpF4ngI6QorC+3XOqhT07PoVOHe
lq4uIadHlTg1eToVbH8EcrBsRSlowioHjSNi7yTjP8BZ2D+B+g8Xf0i5oOZpOUXR
hSbACDdYvpt9VxV4F9Qt+dE/M8NakVh/QXLC9ZVpuOfBzVFcimTanLGcItvbMdfb
PA8aZGL19aaxh/koi88pu0JOoEMKgKF8WedpePSp9J5O1VFfwd1DvGfmMgBVGbZJ
TflG9oKmYJWeqetLcwyKnyi9fpBsBwGm5VB7YFt2jVKNsf2Dg7ydQ+1UdFfKUcA6
/ji3QUSv83mc4t5Qh/TPLFSNOcGm/42OrYcyq/pdBwJ9fLds/qm2QxGScGVBgTx2
NG0Sef+cA88=
=cARp
-----END PGP SIGNATURE-----

--gAUgrzRZ7tRi/Yr6--
