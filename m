From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: [patch 1/2] Balance progress monitoring.
Date: Sat, 30 Oct 2010 14:37:58 +0100
Message-ID: <20101030133758.GC9369@selene>
References: <20101030000726.286517546@carfax.org.uk>
 <20101030000741.689283553@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101030000741.689283553@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 30, 2010 at 01:07:27AM +0100, Hugo Mills wrote:
> This patch introduces a basic form of progress monitoring for balance
> operations, by counting the number of block groups remaining. The
> information is exposed to userspace by an ioctl.

   Dammit. An unrefreshed quilt patch let an error get through (see
below). Updated patch in a few moments.

   Hugo.

> Index: linux-mainline/fs/btrfs/volumes.c
> ===================================================================
> --- linux-mainline.orig/fs/btrfs/volumes.c	2010-10-26 18:03:38.000000000 +0100
> +++ linux-mainline/fs/btrfs/volumes.c	2010-10-29 17:23:40.463279287 +0100
> @@ -1902,6 +1902,7 @@
>  	struct btrfs_root *chunk_root = dev_root->fs_info->chunk_root;
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_key found_key;
> +	struct btrfs_balance_status *bal_info;

+       struct btrfs_balance_info *bal_info;


-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- <dragon> A linked list is still a binary tree. Just a ---      
                          very unbalanced one.                           

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFMzB+2IKyzvlFcI40RArrfAKDVIuUheY38h7XIuci6tuKJnx8wxgCglxRg
WwxAFEtIsS8aYgfJSauuLK4=
=cPYj
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--
