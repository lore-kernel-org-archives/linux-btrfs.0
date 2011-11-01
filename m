From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Where can I find symlink's target?
Date: Tue, 1 Nov 2011 16:03:23 +0000
Message-ID: <20111101160323.GB29548@carfax.org.uk>
References: <edb53b9dd6dcf054485278225f6ee728@joachim-neu.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g3W8FGNyQaC+nhss"
Cc: linux-btrfs@vger.kernel.org
To: email@joachim-neu.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <edb53b9dd6dcf054485278225f6ee728@joachim-neu.de>
List-ID: <linux-btrfs.vger.kernel.org>


--g3W8FGNyQaC+nhss
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 01, 2011 at 02:29:50PM +0000, email@joachim-neu.de wrote:
> 
> Hello,
> 
> I'm taking a look at the B-tree level of btrfs. I have a dir item
> which is a symlink and I'm wondering where I can get the symlink's
> target from.

   I'm not 100% certain about the btrfs implementation from memory,
but doesn't a symlink simply have file contents that give the link's
target? For something as small as a symlink, this will probably be an
inline extent.

> I hope anyone can tell me? Is there a bloody technical documentation
> of btrfs somewhere out there that can answer me questions like this?

   It's all documented in some detail on the wiki[1], which is
currently down after the kernel.org hack. We're expecting it to be
back by the end of this week. (And if it's not, we're told we'll get a
dump of the database, so we can have it back up somewhere else shortly
after that).

   Hugo.

[1] http://btrfs.wiki.kernel.org/

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Is it true that "last known good" on Windows XP ---         
                            boots into CP/M?                             

--g3W8FGNyQaC+nhss
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOsBhLIKyzvlFcI40RAvC6AJ4qTVrhPnk1FSuoBKBPiwSLMY52HgCgnRyV
/+LOZPur3JzWqWiObueLFI4=
=Q4zL
-----END PGP SIGNATURE-----

--g3W8FGNyQaC+nhss--
