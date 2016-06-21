Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34842 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbcFUEaz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 00:30:55 -0400
Date: Mon, 20 Jun 2016 23:53:24 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160621035324.GN15597@hungrycats.org>
References: <20160620034427.GK15597@hungrycats.org>
 <20160620231351.1833a341@natsu>
 <20160620191112.GL15597@hungrycats.org>
 <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org>
 <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nhAUiXSLan16V5i8"
In-Reply-To: <20160621015559.GM15597@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nhAUiXSLan16V5i8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 20, 2016 at 09:55:59PM -0400, Zygo Blaxell wrote:
> In this current case, I'm getting things like this:
>=20
> [12008.243867] BTRFS info (device vdc): csum failed ino 4420604 extent 26=
805825306624 csum 4105596028 wanted 787343232 mirror 0
[...]
> The other other weird thing here is that I can't find an example in the
> logs of an extent with an EIO that isn't compressed.  I've been looking
> up a random sample of the extent numbers, matching them up to filefrag
> output, and finding e.g. the one compressed extent in the middle of an
> otherwise uncompressed git pack file.  That's...odd.  Maybe there's a
> problem with compressed extents in particular?  I'll see if I can
> script something to check all the logs at once...

No need for a script:  this message wording appears only in
fs/btrfs/compression.c so it can only ever be emitted by reading a
compressed extent.

Maybe there's a problem specific to raid5, degraded mode, and compressed
extents?


--nhAUiXSLan16V5i8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldoujQACgkQgfmLGlazG5yqfACdE5fUAvffeTIISS86CW9s+ppI
bdkAnjLSce5S/FsBCLCadgdYYtyIzn5o
=GFnK
-----END PGP SIGNATURE-----

--nhAUiXSLan16V5i8--
