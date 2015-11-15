Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57015 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbbKOGaN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Nov 2015 01:30:13 -0500
Received: from thetick.localnet ([93.181.44.4]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0MUZKF-1ZpuRl42xn-00RKaK for
 <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2015 07:30:11 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Using Btrfs on single drives
Date: Sun, 15 Nov 2015 07:30:08 +0100
Message-ID: <1900961.ItTdAumaJ1@thetick>
In-Reply-To: <pan$eeab5$356873bd$675c810f$20fe76ea@cox.net>
References: <CA+LE0jwrdpjmJhwmG9Yv5HjqZh28-yp3Man8NSmXqCoB=JJ=Ew@mail.gmail.com> <CA+LE0jyvd8f=z8GR7V2=cLzV3Khfn1YpEHka5-6k0JiSPa5-+Q@mail.gmail.com> <pan$eeab5$356873bd$675c810f$20fe76ea@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart10804018.YfkSl782Ae"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart10804018.YfkSl782Ae
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Sunday 15 November 2015 04:01:57 Duncan wrote:
>audio muze posted on Sun, 15 Nov 2015 05:27:00 +0200 as excerpted:
>> I've gone ahead and created a single drive Btrfs filesystem on a 3TB=

>> drive and started copying content from a raid5 array to the Btrfs
>> volume.  Initially copy speeds were very good sustained at ~145MB/s =
and
>> I left it to run overnight.  This morning I ran btrfs fi usage
>> /mnt/btrfs and it reported around 700GB free.  I selected another fo=
lder
>> containing 204GB and started a copy operation, again from the raid5
>> array to the Btrfs volume.  Copying is now materially slower and slo=
wing
>> further...it started at ~105MB/s and after 141GB has slowed to aroun=
d
>> 97MB/s.  Is this to be expected with Btrfs of have I come across a b=
ug
>> of some sort?
>
>That looks to /me/ like native drive limitations.
>
[Snip nice explanation]

I'll just add that I see this with my 3TB USB3 HDD, too, but also with =
my=20
internal HDDs.  Old drives (the oldest I had were about 10 years old) a=
lso had=20
this problem, only scaled appropriately (the worst was something like 4=
0/60=20
GB/s min./max.).

You can also see this very nicely with scrub runs (I use dstat for this=
): =20
they start out at the max., but gradually slow down as they progress.

HTH
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart10804018.YfkSl782Ae
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWSCZxAAoJEL/Q5oYsiHj0cLEP/0io/RHhJnhGYOP45IVCZuXH
lgRiWD2tFGwYDMdAx14ZHMSAMIW8hYoD7skZmgNmLm5ebUSbiYUUUL+nfFurQe7n
d65ECM1Uv8KgxVvCTYwPKVqB0DcgPlsYxTVfz2kc26DpHaTIbKofvKsrR3eejkWh
KwlBItK16/cDfu9toX43gyj+ALfkQu+j6VIE2QYv5AGZ73T6eQesDp8+vI4sQgRq
oFUYulJNsbmdVmBX4cOtr+qFuKh08wmJM1mm6JXGziRejiyXQCoNaZKY697eaW9W
zJ+qJnhd6Af0m1EiV9XPF+xYsnKVPgmLJKJ72YaTzz+B3FfrNeH9betUSDk/v2rF
jeIPQxZwKycYl/5DejSFVG64O8TiGZXE+ouHdYSL4N/Y3aTQSW6E5RdQHVZqVeEp
JmVjAbU0i75Q5qjKQZIpsn4j8QwYxhoTe93a9m7WsDZXVgCRML4mYG9jDy7LwQnO
D1bzK3ZCpNd2VnD49FlvXxyTIsos+u4U4NGf5uD1pA3yJfXTkLkmbdNvruCZm4xq
pr0+McvxJBnZDYd4u7PQrJUse4pUylPoDTqzTlIut6EQLcUC8GF9OlmcbunL6xK9
rYeNkp3QR4gFCYbY3lsyq8OnsgkIZHG28Ocd4AHUuYbMmSOnAp27uddWYCUXavuc
J4E1hD9HNxzFWvz/d3TY
=z2gs
-----END PGP SIGNATURE-----

--nextPart10804018.YfkSl782Ae--

