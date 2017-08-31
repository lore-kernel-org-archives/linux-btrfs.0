Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36374 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdHaSdD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 14:33:03 -0400
Date: Thu, 31 Aug 2017 18:33:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Eric Wolf <19wolf@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS critical (device sda2): corrupt leaf, bad key order:
 block=293438636032, root=1, slot=11
Message-ID: <20170831183302.GB30990@carfax.org.uk>
References: <CAJ_hD5By15sSvur7849XWQ8jkBoGj0cO5vQfY8MguVDCneMX8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
In-Reply-To: <CAJ_hD5By15sSvur7849XWQ8jkBoGj0cO5vQfY8MguVDCneMX8Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 31, 2017 at 01:53:58PM -0400, Eric Wolf wrote:
> I'm having issues with a bad block(?) on my root ssd.
> 
> dmesg is consistently outputting "BTRFS critical (device sda2):
> corrupt leaf, bad key order: block=293438636032, root=1, slot=11"
> 
> "btrfs scrub stat /" outputs "scrub status for b2c9ff7b-[snip]-48a02cc4f508
> scrub started at Wed Aug 30 11:51:49 2017 and finished after 00:02:55
> total bytes scrubbed: 53.41GiB with 2 errors
> error details: verify=2
> corrected errors: 0, uncorrectable errors: 2, unverified errors: 0"
> 
> Running "btrfs check --repair /dev/sda2" from a live system stalls
> after telling me corrupt leaf etc etc then "11 12". CPU usage hits
> 100% and disk activity remains at 0.

   This error is usually attributable to bad hardware. Typically RAM,
but might also be marginal power regulation (blown capacitor
somewhere) or a slightly broken CPU.

   Can you show us the output of "btrfs-debug-tree -b 293438636032 /dev/sda2"?

   Hugo.

-- 
Hugo Mills             | "You got very nice eyes, Deedee. Never noticed them
hugo@... carfax.org.uk | before. They real?"
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                 Don Logan, Sexy Beast

--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZqFZdAAoJEFheFHXiqx3kNnwP/RcQZLpQBfsetFPSqyxA/KTM
OF4jEX66CdA+EtToMXjysrnF9BXYYD+I3weYESTq12BedUFhCT2D7FcX9DLoZ00O
/0WDvvu4Pj5W8610fr0Z9Yk6x9QJ7PJ/1SDFprklQO1xHka1kIJzDmGyQ7rDCc0T
fZtA+TZTgV7t2MRqpaKxDg7yjKBdPBJcGgulCcaYV5jeFaT93FGrqHt5CK7bKzX/
bYdXDJUUPz8zgsLBw3XknW9JSlvKZlrWmA6YF1ow3OqwzKeaxk0AgP0+i/RJptfG
AL8BXQUiRvLFFLelS8HS2SRK8U6sLUjMR+hOyTXwPyhxZ6zeqUktL7LXisHAnasQ
kcWF9+domol9VP9oz0bGIzCOlDokDNED83xugyuSoZkwc2y9bp+IOR4jA8C/Df3u
w9nPMlISwpZBFLzZdH0XB70EucKgBVy+FsXSL1QZQJzNUlIfcwxL1Vu7HI7qyzB2
zwdgueS/c1393R2SlmEmpXa7vpLLQ726Sc+ozA8LTyt8+yh7rhOq9MS/MED7Pwim
qizjtkSI3RF6m9fz/wQTlptmUIdmKOZYCbGcuPzMRiQKA9HU+n5d+0QiuGqSjE0S
ZBGWNgmudCSBpbrR+P6BdEliyibfQlKLxNWIFESxkg0t8vR8MCvE9H2CinGZG9UP
D6kKsB9/nEmJUxsRSVcc
=q50b
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--
