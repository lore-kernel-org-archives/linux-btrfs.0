Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59230 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaLRPfq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 10:35:46 -0500
Date: Thu, 18 Dec 2014 15:35:44 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Daniele Testa <daniele.testa@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Extra info
Message-ID: <20141218153544.GB25267@carfax.org.uk>
References: <CAN6BF2LwtJkjt1qB6C-wcVxizGj4bufvojR29QX5e7JJ_h-xXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
In-Reply-To: <CAN6BF2LwtJkjt1qB6C-wcVxizGj4bufvojR29QX5e7JJ_h-xXA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 18, 2014 at 11:02:34PM +0800, Daniele Testa wrote:
> Sorry, did not read the guidelines correctly. Here comes more info:
> 
> root@s4 /opt/drives/ssd # uname -a
> Linux s4.podnix.com 3.2.0-4-amd64 #1 SMP Debian 3.2.46-1+deb7u1 x86_64 GNU/Linux

   This is your problem. I think the difficulty is that writes into
the middle of an extent didn't split the extent and allow the
overwritten area to be reclaimed, so the whole extent still takes up
space.

   IIRC, josef fixed this about 18 months ago. You should upgrade your
kernel to something that isn't written in cueniform (like 3.18, say),
and defrag the file in question. I think that should fix the problem.

> root@s4 /opt/drives/ssd # btrfs --version
> Btrfs Btrfs v0.19

   This is also an antique, and probably needs an upgrade too
(although it's less critical than the kernel).

   Hugo.

> root@s4 /opt/drives/ssd # btrfs fi show
> Label: none  uuid: 752ed11b-defc-4717-b4c9-a9e08ad64ba6
>         Total devices 1 FS bytes used 404.74GB
>         devid    1 size 410.50GB used 410.50GB path /dev/md3
> 
> Regards,
> Daniele

-- 
Hugo Mills             | Python is executable pseudocode; perl is executable
hugo@... carfax.org.uk | line-noise.
http://carfax.org.uk/  |
PGP: 65E74AC0          |                                            Ben Burton

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUkvRPAAoJEFheFHXiqx3kuocQAISnuZ5dgGMeLjK9UNa2ufRh
nYLVW26jHNv5BrQ7bKDrSrymw0MONU7mfYKiXb8o6iEjR9KguaqbZltgib23yYCX
q2mydW9ukFBzN2XpwYWJKC2vw7nSkqSBZpuEDRo/FmoBppYipcFdHhRSVreJ6C5G
zTn85YvGziX6iEoCTmJiUaboFXylJvBVT3eCSysoyaGjOtK4ZmCOX2OpZ0LZ/u9A
cNVNkXyA/K6QyozDj3IRBuMKBYqnJe2XPLWAhgaRXMckAkyEkRgeirNFFoZWsbd4
+FBfxvgccjHSCW48IOfW96JAjN+0tjqPS1rGfrVIVM+VVxyOKyiDZ0rWP/Zq/+XA
HwXjUPrwwi/WtBcR0RfWfRGqn5g7GrLGDraCJmU+i/cj+D18LS/+o4SlMSjj0ud1
y4pxqkBYVd498Fd5tPBbdPxrOWmTWwNowQdoAcm5/Xclu6pg9exlsQjRX47Iuw5F
nFORQFyfF8zj/995nyWHnC2nvSXFkvf9nDRGxW0HMP251fHsBVDV4ZNRmT3qL5fU
muELi5eVTr95MbqQ3ZD84uzWtSO3wVhAtOAk/dJ1R36WOjJR6lGh5Cn7XpLq3OIR
xUh9BUNH6pKtsFC9xW4nIRx5N5xtmWJ2JJYFEhEaFhK+6GcmDaV2M9uEgtyQJCsK
ypI01ye9Wynbbv57oyw3
=ZnaM
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
