Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50726 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbcDOPqP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 11:46:15 -0400
Date: Fri, 15 Apr 2016 15:45:28 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Niccol=F2?= Belli <darkbasic@linuxsystems.it>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: Uncorrectable errors after rebooting with Magic Sysrq Keys
Message-ID: <20160415154528.GG30971@carfax.org.uk>
References: <b4f09d8b-baac-4182-81b1-1ba9f5e4195b@linuxsystems.it>
 <5710B4B8.9020002@cn.fujitsu.com>
 <30940bf0-924b-4ad7-a3d8-24b980ba46f4@linuxsystems.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FUaywKC54iCcLzqT"
In-Reply-To: <30940bf0-924b-4ad7-a3d8-24b980ba46f4@linuxsystems.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FUaywKC54iCcLzqT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 15, 2016 at 05:42:21PM +0200, Niccol=F2 Belli wrote:
> Hi,
> Is it 100% safe to run a btrfs check without --repair?
> Because otherwise I will have to wait for my new external drive to
> arrive and make a backup first.

   Yes, it's safe, unless there's some underlying hardware problem
that would cause the hardware to break even more by exercising it.

   For added peace of mind, use --readonly, which does nothing itself,
but conflicts with all of the options that might change things.

   Hugo.

> Thanks,
> Niccol=F2
>=20
> On venerd=EC 15 aprile 2016 11:30:32 CEST, Qu Wenruo wrote:
> >Would you please run "btrfs check --readonly <your dm0>" and paste
> >the output?
> >
> >The dmesg seems very impossible:
> >
> >>BTRFS error (device dm-0): bad tree block start 245497856 245498111
> >
> >The later one is not even aligned to 2.
> >
> >But you system still seems mountable as you succeeded in running
> >btrfs scrub.
> >
> >So I assume either the tree block is not a critical one or the
> >copy saved you.
> >
> >Thanks,
> >Qu

--=20
Hugo Mills             | What part of "gestalt" don't you understand?
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--FUaywKC54iCcLzqT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXEQyXAAoJEFheFHXiqx3kmqwP/jPaIcyizm75BpPnNXd6ZHjw
N3sIxtUxdf+/eQUIZyVX8jW0BbZ+VwIps+kT8CGPVjl2yhhrUEC2bYZvToOLl1gG
Hm5uK/yiTPXqhFPDjEmzpexUJA64bD4VaYp/zlCbM11hEzL+wLH4/BmbLV9+6q24
reumrE0S4QH4PeTXD45wO4kmOYNjPnH6UnaIs6CcMvhKd1+uWA9H0wf+iyh//JEi
9DWZFCgo95XmwMnYuu8u6NFAh4OYGAHQ0V6Tt+SNr3kwIDtEcYlMyWnA0OZuV27o
5K4IlNbpjHFZfG1a8roTCqE2bW7oNAyqYCLCiG4636oXTIiaS5oO9gdl7Seda1C/
QtXoc/T4CpzoUQLcoiF7kluz/8oW2MHM9JvLYfXCBrNWztF2AYQ32sdHBkpifR6u
UtNf2vKuoNIJbvyCaM7DGuR3Ps4JLjzWfZn8LYYFpbLrMJuoLfoxFj/JwxdUqe9Z
aVjth3zS5jFzFy4WX5qS8tRRyCvuE2DslxDe3SHqqJjqpoqqNZq0IsJrwLLseFaV
gUDev4aDLyhq1s8g2IPX3xZYlM3gU3bBuWFn1wXm9aeZWUSaui/2tRT1omyKl0jY
jQ143Osm0UjebEMdfAsVNSLNRGkrvqdhrd9ZNOco2TSsIncH+37VwxfhEoRiKZPK
sLlPaeb/rq5MdrovpYFp
=UWCb
-----END PGP SIGNATURE-----

--FUaywKC54iCcLzqT--
