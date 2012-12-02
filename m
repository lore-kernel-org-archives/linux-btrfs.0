Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41532 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2LBWqj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Dec 2012 17:46:39 -0500
Date: Sun, 2 Dec 2012 22:46:35 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Aastha Mehta <aasthakm@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: basic questions regarding some btrfs features
Message-ID: <20121202224635.GA7289@carfax.org.uk>
References: <CAEx9m478rbpHCSSNsSv4yyOk3-yrAuSk0DQQ23X+iFWMocAhzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
In-Reply-To: <CAEx9m478rbpHCSSNsSv4yyOk3-yrAuSk0DQQ23X+iFWMocAhzg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 02, 2012 at 11:17:26PM +0100, Aastha Mehta wrote:
> I am looking at btrfs to understand some of its features. One of them
> is the snapshot feature. Please tell me if my following understanding
> about snapshots in btrfs is correct or not.
> 
> Btrfs supports both readonly and writeable snapshots. Writeable
> snapshots are like clone volumes (or subvolumes as in btrfs). We get a
> point in time copy of the subvolume in both case.
> 
> I looked through the kernel code and it seems that creating a
> subvolume and taking a snapshot (readonly and writeable) all have a
> common ioctl interface.
> 
> What I am not completely clear about is whether snapshots get same
> fsid as the source subvolume fsid or different.

   Yes, it's the same UUID, because they're all part of the same
filesystem.

> Also, I do not understand what does it mean to be able to take
> snapshot of a snapshot.

   Snapshots are completely equal partners with their original
subvolumes. This is not the case in, say, LVM.

> What are benefits compared to say, being able to take snapshots only
> of the active subvolume and not of the snapshots?

   Let's say you take a snapshot (B) of your root filesystem (A). Then
you decide to "roll back" to using the old version, so you mount B as
root instead of A. Later that night, your backup process starts up and
tries to take a temporary read-only snapshot (C) of your root
filesystem (which is now B) so that it can make a stable backup.
That's a snapshot of a snapshot.

> Probably before that, I need to get some clarity on why does a
> subvolume always belong in the directory of some parent subvolume. Is
> it possible to have more than one root subvolumes or more than one
> subvolumes in the same parent subvolume directory?

   No, there's precisely one top-level subvolume (subvolid=5).
Everything else in the filesystem lives within that. However, you can
have as many subvolumes as you like below that, and in whatever
directories or subvolumes you want.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- Quidquid latine dictum sit,  altum videtur. ---           

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBULvaS79z9OVl50rAAQLMlQ//VF7o4RTbpl/8iJWXAUY1VRIgy2EVNg38
RS5pUPJKFscA+GpOQ3eIZ4ZlTZLFs0p7EaeoLcvZa5aXdyLh6FjSp1RHrF/6+t2Z
vxQ4DyqTMC9NgsLn3h9KhNiaijB5ROL8A1aX8q7V30KdNX/Li7L50D/RbXq/Wp99
g17Jiz2A78qcBggCYWrG5wvQowwMfT2NIfmy15fk+SX0boEzUy2VknJLzv3u/vRv
TPywe9+tLjzXOuqfGNuHZWHcy5mZXDId4kRX8Yjmb5vQ0Ie95mxU2O5S5wiecYU0
mxpcFN+KJlt+GqY6h8N3wnMYI92kqakaFWW2K7e/R5xCLvYNgKr9kAh8vNIOnevT
s5J7ICAQfnGjFwO7VUYC5eBdwk5YT0FiJlvrAZflPZ4LAF0eI0XBK6i07crS8br9
wUDpc+omrQtfFgrKyV9KDVogk8wNX9XIUNMQwzCnxWuXXSLZVFv4m3qe5ZReFEd0
fEeFL7npe+evRvJyjvz4bHPZb2uNTl6c9C61gFeiopcThgD1w4BY47vVAr4zrjs7
VcU6lwJLhb5EYGrYqmaY6Ouo5ERqMm+aDDRQrfV0e50C8hSwwXR5rk6JJPpH8Nz3
E0anAVZh3T5rnSz6eP2BYpnP6jNyxBMH3MdE7cELVIQCY2L7WeyMQqqZvVWrjPB3
yT/Qxy/yOWs=
=BnvY
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
