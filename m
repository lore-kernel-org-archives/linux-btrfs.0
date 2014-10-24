Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36905 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754960AbaJXWPf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 18:15:35 -0400
Date: Fri, 24 Oct 2014 18:15:33 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Check tree block failed, want=17716610236416, have=0 [RESOLVED]
Message-ID: <20141024221533.GH17395@hungrycats.org>
References: <20141023231622.GC17395@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jHkwA2TBA/ec6v+"
In-Reply-To: <20141023231622.GC17395@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--9jHkwA2TBA/ec6v+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2014 at 07:16:22PM -0400, Zygo Blaxell wrote:
> I attempted to run btrfs check --repair, but it got stuck spinning
> in what appeared to be an infinite loop.  strace and ltrace revealed
> nothing, and gdb wasn't particularly helpful, so I rebuilt btrfs with
> debug symbols and tried again.
>=20
> Now I get this from btrfs check:
>=20
> 	Couldn't map the block 17716610236416
> 	No mapping for 17716610236416-17716610252800
> 	Couldn't map the block 17716610236416
> 	Check tree block failed, want=3D17716610236416, have=3D0
> 	read block failed check_tree_block
> 	Couldn't read chunk root

'btrfs rescue chunk-recover -v' seems to have fixed this.  It ran in total
silence for 15 hours (apparently it really does read all 13TB of
filesystem!), then it asked a 141,000-line question about repairing three
bad chunk tree segments.  Good thing I was logging the terminal output.
:-)

Now I'm back to btrfs (3.17) check on this filesystem, so we'll see how that
goes.


--9jHkwA2TBA/ec6v+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRKz4UACgkQgfmLGlazG5z3dQCfbAtO4vn2KAJ/jjTqKoi4dnP0
c28An3Zo050l9D9Sgu/9BZ5W5uYM2aQa
=LbW5
-----END PGP SIGNATURE-----

--9jHkwA2TBA/ec6v+--
