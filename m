From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Damaged super block / fs root
Date: Mon, 30 May 2011 17:12:16 +0100
Message-ID: <20110530161216.GA8002@carfax.org.uk>
References: <4DE3BEFA.7080106@ftml.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Dennis Bergmann <d.bergmann@ftml.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DE3BEFA.7080106@ftml.net>
List-ID: <linux-btrfs.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 30, 2011 at 05:59:54PM +0200, Dennis Bergmann wrote:
> I have accidently damaged the first block(s) of a btrfs partition
> and can't mount it anymore.
> 
> I can see that my data is still intact by running a command like:
> 
> cat /dev/sda5 | hexdump -C | more
> 
> Do any (experimental) tools exist which would allow me to recover the files?

   There's btrfs-select-super, which is in the git repo for btrfs
tools, in the next or tmp branches. That should allow you to select an
alternative superblock to use, which (I think) will help you. If it is
just your superblock that's damaged, that should help.

   You can check whether it's likely to be of use by running "btrfsck
-s 1" on your filesystem. If it passes OK, then btrfs-select-super
should be useful.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- Attempted murder, now honestly, what is that?  Do they give a ---  
                  Nobel Prize for attempted chemistry?                   

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN48HgIKyzvlFcI40RAihBAJ0eXGZTtbIuiV18oyI2dOJRVztfLQCgoRlX
SjAIZegjz+buyafRcLw1tzo=
=bDPZ
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
