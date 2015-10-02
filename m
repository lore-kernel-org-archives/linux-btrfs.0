Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51327 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbbJBJot (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 05:44:49 -0400
Date: Fri, 2 Oct 2015 09:44:48 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: - <robert86@mail.uni-paderborn.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Deduplication and redundancy questions
Message-ID: <20151002094448.GM25907@carfax.org.uk>
References: <560E2CE9.6020500@mail.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EOHJn1TVIJfeVXv2"
In-Reply-To: <560E2CE9.6020500@mail.uni-paderborn.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--EOHJn1TVIJfeVXv2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 02, 2015 at 09:06:17AM +0200, - wrote:
> hey everybody.
> 
> 1. Deduplication
> "When given a list of files it will hash their contents on a block
> by block basis" - are those static blocks or is the length of a
> block defined by its content? (that would be more resilient
> regarding inserts of data and the shift of the following data caused
> by it)

   "Block" generally refers to a 4 KiB piece of data. In btrfs,
contiguous blocks form extents, and a file may be made up of none or
more extents stored in different places on the disk.

> Do I understand correctly, that I better use bedup to deduplicate on
> a file-level before using duperomve to deduplicate on a block-level?

   If you really do block-level dedup, then that would make little
sense to do file-level dedup afterwards. As I understand it,
duperemove actually works on an extent level, rather than a block
level. (Note that block-level deduplication is likely to lead to truly
appalling performance, due to large amounts of seeking).

> 2. Redundany
> "Background scrub process for finding and fixing errors on files
> with redundant copies "
> So fixing is only available with full redundancy?! No parity-based
> methods or other ECC-based approaches?!

   Correct. The checksums used for this are (currently) 32 bits for
each 4 KiB block. There's simply not enough information there to do
anything other than detect (most) errors. If you want parity-based
repair of errors, use RAID-5 storage.

> thanks for answers

-- 
Hugo Mills             | IMPROVE YOUR ORGANISMS!!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                            Subject line of spam email

--EOHJn1TVIJfeVXv2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWDlIQAAoJEFheFHXiqx3kE9cQAJrSAmcZK9ACF2SN/pYhLI8O
Fl+SfOX7FyMIx0d6DDamSQMVYo42Uv2TMs9Eqs73ggGHEtJqcTy+qZaC6xatp+cX
ydx+eCSTm/Y/rhuv3V6bKCws9xQeq64e4GnPaUdNa+WDEs+tbI7NToggisXe94oN
NVk2t6YVtcPjyW+jZIkgYHGGApiDx+f/n+hCEoBM9OOKh8htvp/tiLgyA4D3wCa4
ZwKASFCWlNwFbC6GjhK9zKOTvk37fztdgw5Pg+srJ85BrdBubT3AVjBd2sn9bMMs
NonQBmPaB4OYcCaCGidYgiDGB3OmQGnZBxhkwyaH0SqKdJf5lt7YMpxRjsm+FqJV
agaFynkoo1x9CUDFfSjFpzRcC4xFfAAq7TNZJfepifHjaUHN9uNF9ZN7Fwfyg1my
7F8DPQK2i6+0NaPTAQx8t3O4O6z2sRPxfZkYClurl8VVT6Sl1TzwVpBJBkZUQICL
VetcyrtWENJwhVCxTFuz0BHbC+jVRON17v1B2QZ806bsrGSKShYKhJ6FW7ssl8kh
cn7gXKFEH+L/l9+vB25z8sAKXdX8wtL4llRp5F2eI3Zp+OOmdRPsik9UtlENLbEX
Hy020KGYA9jSim+lH/wtVBDRdRXihU2lkuUNiIlCBbxt4wv4z2E+xYnq7u9V5WZx
18Oh1Tqlk0GGBzMaMLme
=WtrJ
-----END PGP SIGNATURE-----

--EOHJn1TVIJfeVXv2--
