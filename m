Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asuka.romanrm.net ([128.199.122.184]:45022 "EHLO
	asuka.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517AbbBIJM2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 04:12:28 -0500
Date: Mon, 9 Feb 2015 14:12:21 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: "Devon B." <devon.b@virtualcomplete.com>, linux-btrfs@vger.kernel.org
Subject: Re: Accepting discard to free space from disk images
Message-ID: <20150209141221.099d4fe5@natsu>
In-Reply-To: <20150209083941.GI28427@carfax.org.uk>
References: <54D842FD.1010806@virtualcomplete.com>
	<20150209114023.137402bf@natsu>
	<20150209083941.GI28427@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rqL.3s2NYhE9AQ+W3Qa37KC"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/rqL.3s2NYhE9AQ+W3Qa37KC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Feb 2015 08:39:41 +0000
Hugo Mills <hugo@carfax.org.uk> wrote:

> > I use KVM (QEMU) with discard pass-through from the VM guest ("discard=
=3Dunmap"
> > option), with the VM images stored on Btrfs. It works just fine, the di=
sk
> > space used for the image file does shrink when the guest OS issues disc=
ards on
> > its FS. Maybe there is a difference in how KVM and the 'loop' module su=
bmit
> > discards to Btrfs?
>=20
>    This is interesting, because I've tried exactly that setup (KVM,
> discard=3Dunmap) and it's not worked for me.

Did you use the emulated IDE interface in KVM? Others such as virtio, ahci =
and
maybe SCSI may not support discard. Did you get a successful result issuing
TRIM within the guest (e.g. fstrim -v / succeeds and doesn't -ENOSUPP)?


--=20
With respect,
Roman

--Sig_/rqL.3s2NYhE9AQ+W3Qa37KC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlTYefUACgkQTLKSvz+PZwi7sACdHj1HfR8fd/G5fH0UwyCNhLC6
sjgAnAmbRfOaiKFJGuhEElYMMgZA/p0i
=x2r6
-----END PGP SIGNATURE-----

--Sig_/rqL.3s2NYhE9AQ+W3Qa37KC--
