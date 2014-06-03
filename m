Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mylinuxtime.de ([148.251.109.235]:42675 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaFCSEa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jun 2014 14:04:30 -0400
Date: Tue, 3 Jun 2014 20:04:11 +0200
From: Christian Hesse <mail@eworm.de>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: fix compiler warning
Message-ID: <20140603200411.6202ee70@leda.localdomain>
In-Reply-To: <20140603165225.GR22324@twin.jikos.cz>
References: <1401794959-25907-1-git-send-email-mail@eworm.de>
	<20140603165225.GR22324@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/SDRf.V1qBZRsi6bu.XGhvL/"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/SDRf.V1qBZRsi6bu.XGhvL/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

David Sterba <dsterba@suse.cz> on Tue, 2014/06/03 18:52:
> On Tue, Jun 03, 2014 at 01:29:19PM +0200, Christian Hesse wrote:
> > gcc 4.9.0 gives a warning: array subscript is above array bounds
> >=20
> > Checking for "greater or equal" instead of just "equal" fixes this.
>=20
> That fixes the warning, but I don't see the code path that leads to
>  level >=3D BTRFS_MAX_LEVEL
>=20
> On the first pass, when level =3D 1 and the first while() reaches at most
> BTRFS_MAX_LEVEL, the equality test is enough. So it has to go through
> the second while() where level is decremented and in the range
> [1..BTRFS_MAX_LEVEL-1] before 'goto again' jumps to the first while
> again.

I suppose gcc does not know how much level can be increased within
function next_leaf(). level > BTRFS_MAX_LEVEL is never met at runtime, but
this way gcc knows that level can never be bigger than BTRFS_MAX_LEVEL.

Any better way to fix this?
--=20
Schoene Gruesse
Chris
                         O< ascii ribbon campaign
                   stop html mail - www.asciiribbon.org

--Sig_/SDRf.V1qBZRsi6bu.XGhvL/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjg4rAAoJEFTtyRYJvJGDPskP/2lJCWMZPBPyxRAz3SXHJZK9
icM92u/yzIEh5CE1qtg1U8tdwJLiAk2FNFMojh3DKAZGKff7SSHvlmJ8bTDVi5J8
ZHLVd1On7fczu0gYDc5tnL0IVljrVfIiDgHCUphoOiL9yv+8HAkvZuPD3tF75Qa5
GCgyk+i3bIATdehQfoEVlPnzCtsuxCpM83IQquM4caur6YMnfIfe3Ijy73+HPNXR
C6v2KC41UCyUELokwLUkZwk6mbDB4s0cnMn+BIJ2xS8EeEjaCKzJxoJgbAUQtl7y
toviVnNswUXpkza4AsurpqnFfJ2ns5YdQK/eH6J8UzPzKET6cXpltbRXlKlUdxO2
tYvpnmZRHZXDA/Fyu6mZI4GG+8vf3hm0ooQR6ZS0ghCtWQ5npsZuqpWc9onK22Kz
351PRp4nnFc+CZ0ypjkCmGJ+o9O0VD9rQXjlkVk6erFdIHKviInE/b3Yg5D6GUf5
YibtHmhVThDajWu4LU37L3nvShjPEbdW18nhm1cyAxaxxu4PxL5wmXbkfXJobAFD
ZH9mgMTnUtjwvSUtUkph96Yql/hyMn1luDm/S3cjtKqcQgSlSY6taqwdwAki5VU8
z05c4e0fwbuG+wk7s0sYQJecr5AyEogeF/tGmn3MnakdrO+K0y8qVy47XimNcOpx
3eWhPG1BieCDEFPV5qCB
=qTzT
-----END PGP SIGNATURE-----

--Sig_/SDRf.V1qBZRsi6bu.XGhvL/--
