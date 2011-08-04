From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Metadata space in BTRFS
Date: Thu, 4 Aug 2011 12:12:02 +0100
Message-ID: <20110804111202.GD28326@carfax.org.uk>
References: <20110804014234.01d9f05a@werewolf.home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wULyF7TL5taEdwHz"
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: JA Magallon <jamagallon@ono.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110804014234.01d9f05a@werewolf.home>
List-ID: <linux-btrfs.vger.kernel.org>


--wULyF7TL5taEdwHz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[cc linux-btrfs added]

On Thu, Aug 04, 2011 at 01:42:34AM +0200, JA Magallon wrote:
> Hi all...
> 
> Just a simple question.
> I'm trying to use a 16GB SDHC card formatted in btrfs, and the system
> eats about 2GB for its metadata space. When the card fills, the
> situation is like this:
> 
> werewolf:/media/home# btrfs fi df .
> Data: total=13.22GB, used=13.22GB
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=58.43MB
> Metadata: total=8.00MB, used=0.00
> 
> I lose about 2Gb wrt ext4. Is there any way to shrink this metadata
> space ?
> 
> TIA
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- But somewhere along the line, it seems / That pimp became ---    
                       cool,  and punk mainstream.                       

--wULyF7TL5taEdwHz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOOn6CIKyzvlFcI40RAqJBAJ4j/phLrq/r4Rh167FOODv7xFEjSQCghA/C
eYuH13aCXyUNyVKfIT+dcE0=
=J5X2
-----END PGP SIGNATURE-----

--wULyF7TL5taEdwHz--
