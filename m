Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbaENOnH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 10:43:07 -0400
Message-ID: <1400078533.15603.175.camel@rh>
Subject: Re: [PATCH] mkfs.btrfs: allow UUID specification at mkfs time
From: James Shubin <purpleidea@redhat.com>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, jshubin@redhat.com
Date: Wed, 14 May 2014 10:42:13 -0400
In-Reply-To: <537360B2.50107@swiftspirit.co.za>
References: <5372C457.3000706@redhat.com> <53731BE3.5010604@cn.fujitsu.com>
	 <537360B2.50107@swiftspirit.co.za>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-mUl07/b7dfnsutxY9eAg"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-mUl07/b7dfnsutxY9eAg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-05-14 at 14:25 +0200, Brendan Hide wrote:
> On 14/05/14 09:31, Wang Shilong wrote:
> > On 05/14/2014 09:18 AM, Eric Sandeen wrote:
> >> Allow the specification of the filesystem UUID at mkfs time.
> >>
> >> (Implemented only for mkfs.btrfs, not btrfs-convert).
> > Just out of curiosity, this option is used for what kind of use case?
> > I notice Ext4 also has this option.:-)
> Personally I can't think of any "average" or "normal" use case. The=20
> simplest case however is in using predictable/predetermined UUIDs.
>=20
> Certain things, such as testing or perhaps even large-scale automation,=
=20
> are likely simpler to implement with a predictable UUID.
>=20
Exactly this! My use case is actually for storage automation. By using
an internally generated UUID, it's one easy way to "track" which
filesystem your automation code made.

Example:

https://github.com/purpleidea/puppet-gluster/blob/master/manifests/brick.pp=
#L469

HTH,
James


--=-mUl07/b7dfnsutxY9eAg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTc4DFAAoJEF9gnLdaSQBg3SYP/1HnrhgkQUyW8bYbwBpjfAXP
xFHhTy9nkU8qUxbWpBS/g7Cu4Ke4FWAr042Fu7Dh/x9BUEUuGGDCpo608EyTXb/r
8ZJJ7dT5ft4DVkar/BR6jfuT1o827E7siRRXTnjZfWQsdeRo6eRl4tsXAM4jYEgR
/F/yaRT6xnhYX1q5q/dGT9qChkPALZKXpTb8iMgKXlVqobHGB9pGr9UOLavzdt5u
rbS8M6GrvKYsIahvKSWpSliCAnjZPQjo1q3ACK3hiDiX/JoFHGXWUfDa2/iQP07w
7G9gBdyk8a+ZzJo8X2e4idV0YFvjoW4qPw6mp0xgzszFj3czQRFw7jU8t5BJgIqo
qfPjFu09F2UaD4buuR1P9ivOot9NtZUoJg5R8fYImHOB0lqHQj0PkBr2sIS1x5db
u2jqRsS1Ou/ws9OAlGfBsEBoII71X0RPEBN1KlhpgNVZ2PQOVwgXDvQE5X7OHhbH
2x1IGRgA6C0aqrXxZa/KUH3Asjl8LazDOv7UxPuslsxj3MixwqTTEypdNl/23Rvp
DYGk8UIo0+QicpBFoV9PjdYBdPXqqssMUcwHWAzRIfmrNheFwvTnKqEquQMP/tqr
CylBQhnNCI/DwQvECnEhO7wI84ToQyoT5Rg1KZACM4RkJqZFtkt/XiMr2XPjOi/o
a2gkjo9OTF0ul60HysfA
=wC/N
-----END PGP SIGNATURE-----

--=-mUl07/b7dfnsutxY9eAg--

