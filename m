Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51400 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbbDGLDz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 07:03:55 -0400
Date: Tue, 7 Apr 2015 11:03:54 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: arnaud gaboury <arnaud.gaboury@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs subvolume & default subvolume
Message-ID: <20150407110354.GH13864@carfax.org.uk>
References: <CAK1hC9skBYrM7nPyU-2mCuey6VkFOGMUCi0umYduX3ePNJ2mpg@mail.gmail.com>
 <CAK1hC9tBAvqOhGLGcX=1Ls2QwtaB6fe6Wzf89vH4=Y+kvxHR_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bpVaumkpfGNUagdU"
In-Reply-To: <CAK1hC9tBAvqOhGLGcX=1Ls2QwtaB6fe6Wzf89vH4=Y+kvxHR_Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--bpVaumkpfGNUagdU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 07, 2015 at 12:58:28PM +0200, arnaud gaboury wrote:
> On Tue, Apr 7, 2015 at 11:57 AM, arnaud gaboury
> <arnaud.gaboury@gmail.com> wrote:
> >
> > I plan to install my OS on a btrfs partition, with some subvolumes.
> > Once the partition has been btrfs formated, I mounted it somewhere, cd
> > and then run <btrfs subvolume create>.
> >
> > I did these two subvolumes for now:
> > # btrfs subvolume list .
> > ID 256 gen 6 top level 5 path var
> > ID 257 gen 7 top level 5 path home
> >
> > Now I am wondering if I need to create the root filesystem partition
> > (/)? If yes, is this correct:
> > # btrfs subvolume create root
> 
> 
> After more reading, it seems to me creating a top root subvolume is
> the right thing to do:
> # btrfs subvolume create root
> # btrfs subvolume create root/var
> # btrfs subvolume create root/home
> 
> Am I right?

   Not how I'd recommend doing it. I'd say:

# btrfs sub crea root
# btrfs sub crea var
# btrfs sub crea home

   Then fstab:

LABEL=myfs    /      btrfs    subvol=root         0 0
LABEL=myfs    /var   btrfs    subvol=var          0 0
LABEL=myfs    /home  btrfs    subvol=home         0 0

   And finally, add this to your kernel command line in the bootloader
to specify how to mount root:

rootflags=subvol=root

   Hugo.

-- 
Hugo Mills             | The trouble with you, Ibid, is you think you know
hugo@... carfax.org.uk | everything.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--bpVaumkpfGNUagdU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVI7mZAAoJEFheFHXiqx3kJ8kP/jrOH5sk8dH9oSdkdBH8bynN
i540DN/bE7wNGQrRSDFIIzvbvClr+wC5Y2h/ytdUMiMx5TTPIviH5YFG86J9eaDW
VJBZW2RE11Y0IEHzox40Cku+a0kfi1NO9cKWUD+x3+ajbGmEQShEI6+gfMrxNtDa
0RXM0o+SkCDnswxM0z3SWKbShATUXFZ6R8ZuR4AhbR/l2hDIr6KcGZaQe3i1za8a
gpUAGkDCQA14wlw4c77r84smMXdzNSah63SdUOp8haUPv9VASU+lx4azdYb8m1CN
L0iUhgk+SVmzQdSvqB3sPkQYmC5J+XWd4+PdeQFNNwA5u1bu0ameX7UIc6ctLASy
11v3FNqWxO6RiouwLT1VgKwyShWq4M6kdbRfbnUn1EpKhw2Z9YmurN/OZI5352iD
1MudcW0J/9QfIIZi5zGQmVma6V9WjSfEbnJeW2aks6ShiEFkRfFpehr/jYuRG3DR
au31OZPBfYYgoMdH2/DumknU9GpNUejsaaZ2U2dxSuUCPGS0ti6OY4EV1PK8PCch
fUZTuplaptVQQM0dcUL3XA0x/fFIYfUxgxQTqORLoGXC8IZeZE6K1OpcjACjdQcj
LfQ5MvwccMKkr/9G0CGwFA8Lhh4LtZT+vaoLYGne7K0kWTELXbK0bf/kXGqrXd80
5AI0WV8Sea76I0iK6xEb
=Vp0G
-----END PGP SIGNATURE-----

--bpVaumkpfGNUagdU--
