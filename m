Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:32940 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754010AbbETSEB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 14:04:01 -0400
Date: Wed, 20 May 2015 14:04:00 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs and integration with GNU ++
Message-ID: <20150520180400.GA15531@hungrycats.org>
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>
 <pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net>
 <1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net>
 <CAJCQCtTedu8HXqCbW-S-JV1euvZA3i404RYPP15Ym-Y6boRdtQ@mail.gmail.com>
 <6079A80F-4A26-4D34-AF20-C3161E895FB0@coker.com.au>
 <CAJCQCtSnM9hjCRGFBawOpEuvsOxyoB6vCwCVP5KFWwVqMD_g5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
In-Reply-To: <CAJCQCtSnM9hjCRGFBawOpEuvsOxyoB6vCwCVP5KFWwVqMD_g5g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2015 at 12:02:31PM -0600, Chris Murphy wrote:
> On Tue, May 19, 2015 at 1:24 AM, Russell Coker <russell@coker.com.au> wro=
te:
> > Do you have a reference for fsck on a ro mounted ext4 filesystem being =
dangerous? The standard behavior of Linux systems has been to fsck a ro mou=
nted ext* root filesystem since long before an initrd was invented.
>=20
> Actually, slight confusion. XFS has a repair dangerously mode
> explicitly for repairing ro mounted XFS file systems. The man page for
> e2fsck says it's unsafe to fsck a mounted fs. It doesn't explicitly
> distinguish between ro and rw mounts, but from this list I've learned
> ro mounts aren't guaranteed to be ro, even if they should be ro. The
> e2fsck man page says even if it's safe, it's unreliable.
>=20
> Anyway, it seems worse to me to have a system where you have to ro
> mount a file system that you suspect might be inconsistent so that the
> fsck binary can be read and then operated on that same file system.
> Ancient madness.

The ancient method was to run fsck on a RO mounted root filesystem,
and if fsck corrected errors, immediately reboot to avoid corruption.
Hopefully the second boot gets past the root filesystem, which is
theoretically now clean.  This fails badly if the fsck needs to touch
metadata required for the fsck or reboot, leading to failure of the
init scripts (there is no systemd in the ancient method) followed by
potentially massive root filesystem corruption.  That sounds bad, but in
practical terms there were so many failure modes in the ancient method
that there's no point in choosing just one to get upset over.  ;)

These days we have initramfs, which can treat the root filesystem like
any other filesystem, and check it fully offline before mounting it.
Put dropbear on the initramfs and the filesystem can be interactively
repaired over the network before mounting it too.

Alas, I don't know of any distros that handle root mounts correctly.
I always have to roll my own initramfs to get it right.  >:-/

>=20
> --=20
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlVczJAACgkQgfmLGlazG5y+HACcCjgOrGRk5hvK2wwcCFvvGEcL
99MAniiLpxGU/XgnSFjFP9YsN5uiuayi
=lL10
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
