From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH 1/2][BTRFS-PROGS] add the "--force" switch to the
 mkfs.btrfs command
Date: Mon, 31 Oct 2011 00:11:08 +0000
Message-ID: <20111031001108.GS29548@carfax.org.uk>
References: <CAKcLGm8nBmFZOgs4cxAz7qBfyWZne-VX7rhSxA6c0yd4eDTERA@mail.gmail.com>
 <7496499.QeRia36pgE@venice>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qOEfHYdX8LquYLAx"
Cc: linux-btrfs@vger.kernel.org,
	Mitch Harder <mitch.harder@sabayonlinux.org>
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7496499.QeRia36pgE@venice>
List-ID: <linux-btrfs.vger.kernel.org>


--qOEfHYdX8LquYLAx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Goffredo,

On Tue, Oct 18, 2011 at 06:45:13PM +0200, Goffredo Baroncelli wrote:
> As requested by Mitch, I resend the patch related to the "--force" option for 
> the mkfs.btrfs command.
> 
> This patch allow to bypass the check which ensure that you are formatting a 
> not mounted partition/disk.
> Sometime (eg in a chrooted environment where the /proc filesystem is not 
> mounted ) you don't have all the information, and the check fails even if the 
> device is not mounted.
> 
> Passing the --force|-f flag to the mkfs.btrfs command you bypass this check.
> 
> This patch update the mkfs.c program.

   Could I have your signed-off-by for these two patches, please?
(This one and the subsequent one that does the man pages). I'm also
missing your S-o-B on the man page patch series -- no need to respin
the patches, just supply the relevant S-o-B line that I can put in.

   Thanks,
   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- That's not rain,  that's a lake with slots in it. ---        

--qOEfHYdX8LquYLAx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOreecIKyzvlFcI40RAs/+AJ9/PocJVx4U7qqON4moxpdE60igAwCdGtn8
Nvm+WL2bwhsB1fT4t18TWKM=
=5n6q
-----END PGP SIGNATURE-----

--qOEfHYdX8LquYLAx--
