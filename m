Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34833 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2LVO1h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Dec 2012 09:27:37 -0500
Date: Sat, 22 Dec 2012 14:27:33 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: fsck.btrfs
Message-ID: <20121222142733.GR19051@carfax.org.uk>
References: <50D5B92D.105@czarc.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ffBYM5qgR8HH9Mta"
In-Reply-To: <50D5B92D.105@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ffBYM5qgR8HH9Mta
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 22, 2012 at 08:44:13AM -0500, Gene Czarcinski wrote:
> I am new to btrfs and have begun exploring and testing it.  One of
> these tests is to install Fedora 18 into a btrfs volume only leaving
> /boot and swap on regular partitions.  BTW, this is on
> qemu/kvm/libvirt virtuals.
> 
> I discovered an error was occurring during bootup because systemd
> was attempting to start fsck.btrfs and it was missing.
> 
> 1. Would btrfsck be the appropriate program to run at bootup?  If it
> is, with what parameters?

   No, it's not necessary to run an fs checker on every boot. You can
either turn off the checks in fstab, or symlink /sbin/fsck.btrfs to
/bin/true.

> 2.  Should there be a fsck.btrfs but it has not been written yet?
> 
> 3. Does btrfs even need a "fsck.btrfs"?

   There is a need for checking/fixing tools, but not as much as with
many other filesystems. For example, btrfs will verify checksums on
read, and everything is checksummed (including metadata); blocks
failing the checksum can be corrected if there is another copy
available (e.g. RAID-1 or DUP, in the case of default metadata). Other
forms of minor corruption (missing backrefs, etc) are dealt with by
the kernel as it finds them.

   Some more serious forms of corruption are also dealt with by the
kernel -- for example, looking for earlier tree roots with the -o
recovery mount option, which should always be your first port of call
with an unmountable filesystem.

   That said, there's things that the kernel code can't cope with
(extent tree corruption, loss of the chunk tree), and those should be
done off-line by btrfsck. We don't have chunk tree rebuild capability
yet, but it was something that Chris was working on a while ago.

   So btrfsck should not be used unless you know that there's
something fundamentally wrong and that btrfsck can fix it. It's not a
generic "catch-all" thing like many other FS's fsck tools. With btrfs,
if it mounts, it's probably OK.

> I get the distinct impression that "btrfs is not your father's
> filesystem" and thus need to be looked at very differently.

   Indeed. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- But people have always eaten people,  / what else is there to ---  
         eat?  / If the Juju had meant us not to eat people / he         
                     wouldn't have made us of meat.                      

--ffBYM5qgR8HH9Mta
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUNXDVb9z9OVl50rAAQIa9A/9GmpayJkuatSvXfZTHqVYdHkh1qUKuSNl
C2wp5+j6fuBV/CUcJW/AM+SeLEGkJIklHV93b7dw8x2GggBMP8okxqIjBACUXrXr
etgnVZuz5t6BVeYEdZuXotAv2jI5ui1r9c1nQNiu5roxzzm+H0M0vrYLAjOPZ4M6
C/On0byljCd3eEYmFJGFiqo1KDWM7labbDU9jau6yjinbjAvDOAE6HGadomjMeVt
7bUOlSJjoExDfG1cGzcnuss7qSsoZHcjwdUv22JPk/grG8PRQXHnOAD538VaqOYp
9BvmOSQM3W7OfEv/lHKlQ6f4gRNIlads1BEU2BOg0CZ1C0ewfBHZZz0Yb18MjBPU
ttyb+QquId1CstSWmKGp5qehl+DmjMlaTAIIRD4zAg0WNfXOJNv0MZt7h++HB5Bd
WSLtpN3WRl9eQO1YL6NoMnX/Qu5WUZ/i15IW9INN67FNLQbBEpqdx1W9F+dmsv1f
TiUP2Jr/U4EWA/ealtKqWmP0RSJLoPvrvlA6PwRlrOVI+C5YQUXQAWravDAfLklU
Y+QlNwLmGJe/Fl4k5sfso6dUr1efd4dxgKf/k8ulcHASjPjLVdxZnYqZW829PRrj
GR9+xUiaiLeg1Py4MTKTYsoMtbwdhh2jfN/4QUgnfoBKM2hfleyaQttCTsx4i9C4
77IVT/AaJGM=
=ppSn
-----END PGP SIGNATURE-----

--ffBYM5qgR8HH9Mta--
