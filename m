Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58370 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759503AbcAKQBS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 11:01:18 -0500
Date: Mon, 11 Jan 2016 16:01:06 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Sanidhya Solanki <jpage.lkml@gmail.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, David Sterba <dsterba@suse.cz>,
        jbacik@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20160111160106.GB422@carfax.org.uk>
References: <1451360528.7094.7.camel@scientia.net>
 <20151228190336.59a3f440@gmail.com>
 <1451363188.7094.23.camel@scientia.net>
 <20151229180643.GD4227@twin.jikos.cz>
 <20160102065207.4eec760a@gmail.com>
 <56887B40.10105@gmx.com>
 <20160109221105.6b18fb8e@gmail.com>
 <1452527015.7801.1.camel@scientia.net>
 <20160111064956.573ec21b@gmail.com>
 <1452527868.7801.2.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
In-Reply-To: <1452527868.7801.2.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 11, 2016 at 04:57:48PM +0100, Christoph Anton Mitterer wrote:
> On Mon, 2016-01-11 at 06:49 -0500, Sanidhya Solanki wrote:
> > I considered that, but, if you read the specification of modern HDDs
> > carefully, it states that they are 4K or 512e sector size compatible,
> > hence the concession. Also, older drive users may find this
> > preferable.
> But these are powers of 2,... why does one need=A0768, 3072, 6144, etc.?

   If you're going to align with erase blocks on SSDs, some SSDs have
the erase block size as 3*2^n. (I don't know if that would be useful,
but it might be.)

   Hugo.

--=20
Hugo Mills             | Unix: For controlling fungal diseases in crops
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWk9HCAAoJEFheFHXiqx3kEmIQAK4jKXNO7V6Iz0vubjwMqvX4
jQbjvvZy2q0Bc98/aKsNBaRLJEywvvjymMH1XPpV6ig3T5sOIuqy2pDIKNTPXqrM
0p7QI8WGREjEIcz3VqyxxBrdxqCYLbyZrs2a/itlmEAbniX5YOxRPmDjWPxZaJB/
NghqGBQ1DPKnBFn1M6Z1YBMVbfM1uo8Q3lX1Aq2/9xN5TWJBzUMvhgQukroEkUUr
UP9EOReeaPU0HYd0dh2+haP2QNiw3kyaC5pNfyrWmf8D9wqmufmRkVCq53+Gotk3
LT8dD6f3+RGgoVlZjTiQ2cVFjH+FMopK/pJrWXDo2+X4WYmx6mzDc/Qm6OayRMEP
wX2xlecOJEizT1HMzRkjgmNfLRRm9g4GLMXzS6PDIyEKcmAIWcsRvZR1WlhPGh0j
fl/rhH5CsY5EI1tTgDDL1mF75Hthwayi0JFXft6B21O7WjAVTflpyoR1WsF5l/k+
ikBxZUSbIV9rfhPdbDQ9vE7krs85hhFyCegYGdHc5EkjSPm24uDMjYiu46efCuuj
NCZwvbAnfEtZbLJZ7bHCRwdupWyeuXOyQuIx9IkoVQ+xilOydOQxk5QAhQAR/0TJ
EUwZFtI6zLVcHKhdhbVRXXz3nkcqfsUv5EGhwUQSMu+9fFtnMqDxgJH61Ws0CAxA
Lfjtvvh4meZb6g7KiAUp
=Dp3g
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
