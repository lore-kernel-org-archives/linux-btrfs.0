Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33138 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751560AbbBECik (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Feb 2015 21:38:40 -0500
Date: Wed, 4 Feb 2015 21:38:35 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: paused balance convert from raid1 can no longer be a writeable
 mount
Message-ID: <20150205023835.GA23108@hungrycats.org>
References: <CAJCQCtS1cTQqbsYM01baLUmqTXDNE5HZfM-uL8gx0HkHXo-a+A@mail.gmail.com>
 <CAJCQCtQUrfYhiG_Huv+M5w=6bEsvgnY1kUbreO-dANMhCrALbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
In-Reply-To: <CAJCQCtQUrfYhiG_Huv+M5w=6bEsvgnY1kUbreO-dANMhCrALbQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 04, 2015 at 01:53:09PM -0700, Chris Murphy wrote:
> This is completely reproducible with a brand new file system created
> as raid1, using kernel 3.19 and btrfs-progs 3.18.

I think you'll find it's reproducible with any kernel after 3.8-rc1
(circa October 2012).

> The conversion from raid1 to single, if paused, will apparently break
> the file system's ability to be subsequently mounted writable.=20

Only if you remove a disk (or one fails).

> And
> further, btrfs-image fails. I've updated the bug report.
> https://bugzilla.kernel.org/show_bug.cgi?id=3D92641
>=20
> First, the conversion from data/metadata raid1 should be faster than
> requiring fully reading and writing the file system. As this is a 2
> device raid1, each is already effectively data/metadata single, so I'm
> not sure why anything other than metadata needs rewriting.
>=20
> Second, either what I'm doing should be disallowed (user can't force
> conversion of a degraded array to single), or the file system
> shouldn't break like this.
>=20
> Third, the error message is confusing "too many missing devices,
> writeable mount is not allowed" the first part of that is definitely
> not true. How can there be too many missing devices when it started
> out as a 2 device volume and the remaining device isn't an ro or seed
> device?

I'd point out bug #60594, but it seems you've already been there.
I bumped into the same bug myself.

The problem is that one is more than the maximum number of missing devices
for the single profile, and you are missing one disk, so the filesystem
gives up.  It doesn't check that all the single chunks are on currently
present disks.

If you revert commit 292fd7fc39aa06668f3a8db546714e727120cb3e
you might be able to finish the balance and resume non-degraded read-write
operation.

> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlTS16sACgkQgfmLGlazG5xDzwCgjBUdgGgHQ5bYqwgrid42chUu
XR8AoJQaOoXtk+Q9K4mA88KP6T+oJf91
=1jJw
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
