Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48331 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbbJOOzL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 10:55:11 -0400
Date: Thu, 15 Oct 2015 14:55:09 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Dmitry Katsubo <dmitry.katsubo@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Recover btrfs volume which can only be mounded in read-only mode
Message-ID: <20151015145509.GS25907@carfax.org.uk>
References: <CAOGcOQE3_ROtk=2kQkjTUkGE1tz=HEzbeZnrWUOPziW=kNNXBQ@mail.gmail.com>
 <561E6969.40500@oracle.com>
 <561EBAB1.6030600@gmail.com>
 <pan$21730$7c1e6fa7$932b1831$daf2c6bb@cox.net>
 <CAOGcOQGnHaZeiyuqm+rSX=MBNSFnE-JwSmnhTWZVU42FnSgXmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yOm7aJZpkJT4p9Qu"
In-Reply-To: <CAOGcOQGnHaZeiyuqm+rSX=MBNSFnE-JwSmnhTWZVU42FnSgXmA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yOm7aJZpkJT4p9Qu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2015 at 04:10:13PM +0200, Dmitry Katsubo wrote:
[snip]
> If I may ask:
>=20
> Provided that btrfs allowed to mount a volume in read-only mode =E2=80=93=
 does
> it mean that add data blocks are present (e.g. it has assured that add
> files / directories can be read)?
>=20
> Do you have any ideas why "btrfs balance" has pulled all data to two
> drives (and not balanced between three)?

   If you're using a non-striped RAID level (single, 1), btrfs will
start by filling up the largest devices first: balance attempts to
make the free space equal across the devices, not to make the used
space equal.

   If you're using a striped RAID level (0, 5, 6), then the FS will
fill up the devices equally, until one is full, and then switch to
using the remaining devices (until one is full, etc).

> Does btrfs has the following optimization for mirrored data: if drive
> is non-rotational, then prefer reads from it? Or it simply schedules
> the read to the drive that performs faster (irrelative to rotational
> status)?

   No, it'll read arbitrarily from the available devices at the moment.

   Hugo.

--=20
Hugo Mills             | People are too unreliable to be replaced by
hugo@... carfax.org.uk | machines.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                              Nathan Spring, Star C=
ops

--yOm7aJZpkJT4p9Qu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWH75NAAoJEFheFHXiqx3kg8AP/igtCHOQBOiIwbvdhy7bgAA5
8P7qetXcu4txL62kRASwSwj4+KMna3JqMepRfTrTlnmnyVqoPXSkQBFYIy0oRJA3
Qo2m2cjq9dOlK8ixsmGfzvzUKSFO0u+C35wrtp+3VwwuMtl3FSh1ozMHIpFGpW8A
z0Kegn7mJbonhlPBLXm4AvaBFi7/gAQ0HSrhDSn8O2oVX1YmHdOHkMpnti9caeFt
FjggBDZoxyPnJ/3VvMnI/2jJ3alCAFO12S9MppUAYg4GQib4DtLnIpZeWuK9R0g0
WkU+dymYbxmWwRjY8H4tnMlX8cyMDSHTSBQXwrZaopu02PTDtjLrkQQylbH6oG2Y
Ovre/kf+KSafHP6AwKBBYKz0R768vb5slsnrrqxfkFsCca0FGwttIWvWqjBh8Ggq
sTtKXKx4ANBhLe2ofeYaGX3uK2/faV2zDgocwD2wBpnPVS8rlblV7+aIiOtSBE17
UQIHpyp7XQNvQZQlGgxxq0I7Ur2HOvewR7Bi5NWcDuS00w/y6L6/Zg41iIchYx8X
HC6Z8cenOkkqVwcebcUo3b/cI66/nookE2vK0TVIOjq5qddnYnRyWRKzZO27g9HW
KEFhbjVDG+3vdtpJ40xd99dlWx27K0ax93ip/XTD5DSV+Pcq3z0PjeURUmXLn17x
6uyuIgcsniqoFnQdEvhP
=xldP
-----END PGP SIGNATURE-----

--yOm7aJZpkJT4p9Qu--
