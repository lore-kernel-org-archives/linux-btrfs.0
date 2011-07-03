From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH 3/3] some style/layout changes
Date: Sun, 3 Jul 2011 19:45:01 +0100
Message-ID: <20110703184501.GC4325@carfax.org.uk>
References: <cover.1309560079.git.philipp.andreas@gmail.com>
 <3cf741192c0f5f0b92c0fc1dceba986130eca134.1309560079.git.philipp.andreas@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Cc: linux-btrfs@vger.kernel.org
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3cf741192c0f5f0b92c0fc1dceba986130eca134.1309560079.git.philipp.andreas@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 02, 2011 at 12:44:38AM +0200, Andreas Philipp wrote:
> Just do a few simple style/layout changes to make the makefile look
> better.
> 
> Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
> ---
>  Makefile |   18 ++++++++----------
>  1 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index c60f9af..4298323 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,4 +1,4 @@
> -CC=gcc
> +CC = gcc
>  AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2
>  CFLAGS = -g -Werror -Os
>  objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
> @@ -6,25 +6,23 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
>  	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
>  	  volumes.o utils.o btrfs-list.o btrfslabel.o
>  
> -#
> -CHECKFLAGS=-D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
> -		-Wuninitialized -Wshadow -Wundef
> +CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
> +	    -Wuninitialized -Wshadow -Wundef
>  DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
>  
> -INSTALL= install
> +INSTALL = install
>  prefix ?= /usr/local
>  bindir = $(prefix)/bin
> -LIBS=-luuid
> +LIBS = -luuid
>  
>  progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
> -	btrfs \
> -	btrfs-map-logical
> +	btrfs btrfs-map-logical
>  
>  # make C=1 to enable sparse
>  ifdef C
> -	check=sparse $(CHECKFLAGS)
> +	check = sparse $(CHECKFLAGS)
>  else
> -	check=ls
> +	check = ls
>  endif
>  
>  btrfs-list.o: version

   Added to the integration stack.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "You know,  the British have always been nice to mad people." ---  

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOELitIKyzvlFcI40RAnD5AJ0RcUyximRzqHGyfffDr96HMSIL/wCgnrnr
z8Hw243yvBC+Lp37ivePAr4=
=8tAS
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--
