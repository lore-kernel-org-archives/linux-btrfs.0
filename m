Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59396 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2GOLaS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jul 2012 07:30:18 -0400
Date: Sun, 15 Jul 2012 12:30:14 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Skylar Burtenshaw <DaninFuchs@Gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can't mount, power failure - recoverable?
Message-ID: <20120715113014.GL28701@carfax.org.uk>
References: <loom.20120317T051243-551@post.gmane.org>
 <201207131423.54019.Martin@lichtvoll.de>
 <20120713122839.GJ28701@carfax.org.uk>
 <201207131638.34771.Martin@lichtvoll.de>
 <loom.20120714T025232-591@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rfwNdt5cNUUjB/69"
In-Reply-To: <loom.20120714T025232-591@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rfwNdt5cNUUjB/69
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 14, 2012 at 01:01:04AM +0000, Skylar Burtenshaw wrote:
> I noticed there've been some recent (since I last looked at least) updates
> including fsck and such, however I haven't run anything git-based since the
> last time I pulled the btrfs tools, and I had to dig for ages to find info
> on how to get the RECENT stuff from the CORRECT source. I can find a dozen
> Google results that seem relevant, but can someone give me a definitive 
> answer on which tree to pull down (and how) to test the new tools on my mess?

   This is the definitive source on where to get things:

   https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories

   You will need the official -progs repository, as that's most up to
date right now.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great oxymorons of the world, no. 4: Future Perfect ---       

--rfwNdt5cNUUjB/69
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQAqnGIKyzvlFcI40RAoLVAKDJOKzp5r98ZAFzijnqZKWu32c0UQCeNCUM
sqSI4ryu/67Ao2vY1sePcE0=
=Rj1N
-----END PGP SIGNATURE-----

--rfwNdt5cNUUjB/69--
