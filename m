Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57761 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbbFPQ6e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 12:58:34 -0400
Date: Tue, 16 Jun 2015 16:58:32 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Arnaud Kapp <kapp.arno@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Replacing a drive from a RAID 1 array
Message-ID: <20150616165832.GN9850@carfax.org.uk>
References: <CAOQP4cG2344VZYT8eZ4=MJzi_KsdzH7pxFJ+ZpOTXtdDOrXRyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="31zvzas5NXT9fief"
In-Reply-To: <CAOQP4cG2344VZYT8eZ4=MJzi_KsdzH7pxFJ+ZpOTXtdDOrXRyQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--31zvzas5NXT9fief
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 16, 2015 at 06:43:23PM +0200, Arnaud Kapp wrote:
> Hello,
> 
> Consider the following situation: I have a RAID 1 array with 4 drives.
> I want to replace one the drive by a new one, with greater capacity.
> 
> However, let's say I only have 4 HDD slots so I cannot plug the new
> drive, add it to the array then remove the other one.
> If there a *safe* way to change drives in this situation? I'd bet that
> booting with 3drives, adding the new one then removing the old, non
> connected one would work. However, is there something that could go
> wrong in this situation?

   The main thing that could go wrong with that is a disk failure. If
you have the SATA ports available, I'd consider operating the machine
with the case open and one of the drives bare and resting on something
stable and insulating for the time it takes to do a "btrfs replace"
operation.

   If that's not an option, then a good-quality external USB case with
a short cable directly attached to one of the USB ports on the
motherboard would be a reasonable solution (with the proviso that some
USB connections are just plain unstable and throw errors, which can
cause problems with the filesystem code, typically requiring a reboot,
and a restart of the process).

   You might also consider using either NBD or iSCSI to present one of
the disks (I'd probably use the outgoing one) over the network from
another machine with more slots in it, but that's going to end up with
horrible performance during the migration.

   In my big disk array at home, I have two 4-slot enclosures, and I
leave one of them empty specifically for this reason. It's a less
attractive proposition with only 4 slots in total, though.

   Hugo.

-- 
Hugo Mills             | "What are we going to do tonight?"
hugo@... carfax.org.uk | "The same thing we do every night, Pinky. Try to
http://carfax.org.uk/  | take over the world!"
PGP: E2AB1DE4          |

--31zvzas5NXT9fief
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVgFW4AAoJEFheFHXiqx3kOMUP/A7awdJGsMjWXfvJJ2z8+oC6
IuUVCMA4VXVSfEi/WlfkcLL2Rqj5yfVPo8meyUa+2BrU3OFj8mA1H+p4+SoDx6YA
LCdCnBz1NJ9Pi5uNcdSVMatCA8SneoqlmkjBkUuZnEZ0yR0HR+vaWmznljA+Pv9B
J/tq7Fj8BC4Qw3kxw/L1aCvfprkB2ty++giVF5oXKEeo1vLlJQ1PZDTRM8o44Hdk
5rjoxcWqZpRQp7I5hAY1yslYW5JTRbU1nXR2tnJ4PpQJVBP4SzATDIT3MvqfT5ki
W5Xf9HIEhfQpizAGX4Byf8dzuwz8HrzS0n6cH878GwGUNFji9sfk8Vp5NcoUWXJb
LeOfmmoImbSMC3MdwGyY7reZfgDRzPJbw7ICnaOVKlTdDxRxqTQt7TcQMUpj64Ci
w52vcS5wodwJ4RIoJWxaIIv36xhXrqrtVZvWdYni61zD/no4z0GzQXhZUoJHUp2O
mIOyri1t/Mi1vutiGnTd6j+6UpoIMTAMtlR3+JFEuJW9CB/I/ZBnmzr2AhlMo9hn
PBY8i8xgKn+vGnOZEKHwlxpLR44qTxMpWu1U9RIdT1PmRWEndFdCoqNs7u0pBLdU
i6pOuK6ZmOorACJekfwOVTyRCbbRatNTbNj1YteSIS4r5wYlZvwm1gF1QAOIvmZT
uySONo2nM7L6Y8AOwQHL
=pt+k
-----END PGP SIGNATURE-----

--31zvzas5NXT9fief--
