Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39536 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331Ab2J2MrR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 08:47:17 -0400
Date: Mon, 29 Oct 2012 12:47:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
Subject: Re: Old (almost 2 years) btrfs failed fs. Parent transid failure.
 Can it be fixed ?
Message-ID: <20121029124712.GF5042@carfax.org.uk>
References: <CAM4M9rQZbsmiC_xmjAtt+syEmp5_ABMTmSVK0KAoVJwc2yqTwg@mail.gmail.com>
 <20121029123313.GA19012@mother.jarsat.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aPdhxNJGSeOG9wFI"
In-Reply-To: <20121029123313.GA19012@mother.jarsat.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--aPdhxNJGSeOG9wFI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 29, 2012 at 01:33:13PM +0100, Tomasz Torcz wrote:
> On Mon, Oct 29, 2012 at 01:22:59PM +0100, Tommy Jonsson wrote:
> > Hi, i have an old btrfs file-system that crashed on a power-failure
> > for about 2 years ago.
> > 
> > i have clone the
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> > (at 2012-10-29) and compiled the tools.
> 
>   I think you need to get branch "dangerdonoteveruse" to get real fsck code.

   That's a very outdated piece of advice. That code is now in
mainline btrfs-progs, and has been since March. Tommy has the correct
and up-to-date version of the progs.

> > sudo mount -t btrfs /dev/sda /mnt/disk/
> 
>  Could you try with "-o recovery"?

   That's worth a try as a first step.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- The last man on Earth sat in a room.  Suddenly, there was a ---   
                           knock at the door.                            

--aPdhxNJGSeOG9wFI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUI56z79z9OVl50rAAQLfVxAAmXz65X9GgpAD7yCO3+b3CqGrD9csfbLR
AN276APyavu0dfb7BU33AHS7D7oOYwtITK4nRDVmsnydD3Cb3ulfdMYKsx6zzAQe
w3EbC7eF2rxSMtDtS5S8IfE/I0sPW/xpAfcL6rHdwZYASo+0M7q3aydQZhxUb/xm
8vlCDlnoRYXgdBIFMM5pq98AtQ6i0a2K+9aYcPnk8/jtzPnT2vjnHi7vaf1+EbeP
rBj97eY5uvvsPkpRUplMgtTZovC935KveG1bPMZDsQzyJJ8CPYTNlCSnVbYfOtpH
bLLQ5GrOfnJRwW7NRizboqWoSYLfyQR5MTO5CIdOracoJO7pwxSeN/OF6pif4ayC
9EQrKwcEKMFFXJ5gBI6DJbey6Jso2cCBsyCxThTz1AGfB6sYGi7zzYh0GCob9vUX
q5EdAdBmGetexBujkD6C9pbaQ0oBSkxGESluNCl8eNwfnqDH3fny7o7EsPDjG13R
49VXa/vCVDwWVXKAHretv/IFMD44n+c3YG8YmtQlo8grESLgWmhxLjpBD1BXhlDb
LntDxon/fZDHnDp31SHKxQSgtIyohP3HBlfovj8d1hICWMBQACPzIUCsQUx59BqC
buj9VkIm6ZqCNZHrYNJ+aI5uqzvHQgnfCLBuHUxG4jjwbSXCER/TMZvqjSmY6ySe
Wl5SjrFg76c=
=tjLa
-----END PGP SIGNATURE-----

--aPdhxNJGSeOG9wFI--
