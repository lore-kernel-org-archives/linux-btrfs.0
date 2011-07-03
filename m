From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH 2/3] add btrfs-list.o as a seperate target
Date: Sun, 3 Jul 2011 19:43:52 +0100
Message-ID: <20110703184352.GA4325@carfax.org.uk>
References: <cover.1309560079.git.philipp.andreas@gmail.com>
 <a440a5ce963dd17cadf70cae05c9ceb661615f02.1309560079.git.philipp.andreas@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Cc: linux-btrfs@vger.kernel.org
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a440a5ce963dd17cadf70cae05c9ceb661615f02.1309560079.git.philipp.andreas@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 02, 2011 at 12:44:37AM +0200, Andreas Philipp wrote:
> By adding btrfs-list.o as a seperate target which depends additionally
                              separate

> on version we can fix the following build error when invoking 'make
> btrfs'.
> 
> btrfs-list.c:37:21: error: version.h: No such file or directory
> make: *** [btrfs-list.o] Error 1
> 
> Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
> ---
>  Makefile |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 3a1e308..c60f9af 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -27,6 +27,10 @@ else
>  	check=ls
>  endif
>  
> +btrfs-list.o: version
> +	$(check) btrfs-list.c
> +	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c btrfs-list.c
> +
>  .c.o:
>  	$(check) $<
>  	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<

   This breaks the use of simple "make", as it just makes btrfs-list.o
and nothing else. This new target should probably be put somewhere
near the bottom of the file, not above the "all" target, where it
becomes the default:

hrm@ruthven:btrfs-progs-unstable $ make
bash version.sh
ls btrfs-list.c
btrfs-list.c
gcc -Wp,-MMD,./.btrfs-list.o.d,-MT,btrfs-list.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c btrfs-list.c
hrm@ruthven:btrfs-progs-unstable $ 

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "You know,  the British have always been nice to mad people." ---  

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOELhnIKyzvlFcI40RAs/pAJ9x3yHfDXxHr2rOAPcHBkD/+D3RKgCfZn2m
Kd7vr+88/yrGqwfnEgjfFhw=
=sKKq
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
