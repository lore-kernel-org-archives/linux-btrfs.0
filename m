From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH] [btrfs-progs integration] incorrect argument checking
 for "btrfs sub snap -r"
Date: Thu, 30 Jun 2011 14:07:39 +0100
Message-ID: <20110630130739.GE11170@carfax.org.uk>
References: <chaz20110630123438.GE28702@seebyte.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EXKGNeO8l0xGFBjy"
Cc: linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110630123438.GE28702@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>


--EXKGNeO8l0xGFBjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 30, 2011 at 01:34:38PM +0100, Stephane Chazelas wrote:
> Looks like this was missing in integration-20110626 for the
> readonly snapshot patch:
> 
> diff --git a/btrfs.c b/btrfs.c
> index e117172..be6ece5 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -49,7 +49,7 @@ static struct Command commands[] = {
>  	/*
>  		avoid short commands different for the case only
>  	*/
> -	{ do_clone, 2,
> +	{ do_clone, -1,
>  	  "subvolume snapshot", "[-r] <source> [<dest>/]<name>\n"
>  		"Create a writable/readonly snapshot of the subvolume <source> with\n"
>  		"the name <name> in the <dest> directory.",
> 
> Without that, "btrfs sub snap -r x y" would fail as it's not *2*
> arguments.

   Thanks. Added to the queue.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "How deep will this sub go?" "Oh,  she'll go all the way to ---   
                    the bottom if we don't stop her."                    

--EXKGNeO8l0xGFBjy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFODHUbIKyzvlFcI40RAr+fAJ412Up1zd5Pnzwl5lOZbikjQszGaQCgtKbz
sRjYZ+HMZ1Hl2OBUtfQ2FI8=
=XH8a
-----END PGP SIGNATURE-----

--EXKGNeO8l0xGFBjy--
