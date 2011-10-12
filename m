From: Hugo Mills <hugo@carfax.org.uk>
Subject: btrfs-progs: new integration branch out
Date: Wed, 12 Oct 2011 13:34:11 +0100
Message-ID: <20111012123411.GC21931@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oTHb8nViIGeoXxdp"
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   All - 

   After a long wait (sorry about that, things have been busy for me
lately), I've managed to pull together a new integration branch for
btrfs-progs. This can be pulled from:

http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ integration-20111012

   This is only compile-tested so far, so there may still be serious
problems with it. Please take care. I'm not likely to be able to do
much additional work on it before the weekend, so I thought it would
be better to get *something* out, even if it's unstable/buggy. This
_is_ the integration branch, after all...

   Fixes or updated patches for any problems you may find are
welcomed, of course.

   I've got a few additional things still to bring in -- David Sterba
did a trawl round quite a few distributions and turned up a couple of
useful-looking patches that he's sent my way; plus there's Jan
Schmidt's inspect-internal patches, which sadly clashed horribly with
Xin Zhong's subvol-get-default patch.

   I hope I'll be able to run up another version within the week with
these other parts in it, and actually do some proper review/testing on
it before it goes out.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great oxymorons of the world, no. 6: Mature Student ---       

--oTHb8nViIGeoXxdp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOlYlDIKyzvlFcI40RAtHJAJ94lgBJ9d7LFN+1WCj3hq6vW3yHwwCfW9w0
tOkWQt/GO9EODJo6THHx23g=
=QKFq
-----END PGP SIGNATURE-----

--oTHb8nViIGeoXxdp--
