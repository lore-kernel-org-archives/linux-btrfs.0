Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39921 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab2FFTgC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2012 15:36:02 -0400
Date: Wed, 6 Jun 2012 20:35:59 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Jim Meyering <jim@meyering.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCHv2 4/4] mkfs: avoid heap-buffer-read-underrun for
 zero-length "size" arg
Message-ID: <20120606193558.GT15986@carfax.org.uk>
References: <1334950046-24147-1-git-send-email-jim@meyering.net>
 <1334950046-24147-5-git-send-email-jim@meyering.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u+FGODhbLwgAeSOU"
In-Reply-To: <1334950046-24147-5-git-send-email-jim@meyering.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--u+FGODhbLwgAeSOU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 20, 2012 at 09:27:26PM +0200, Jim Meyering wrote:
> From: Jim Meyering <meyering@redhat.com>
> 
> * mkfs.c (parse_size): ./mkfs.btrfs -A '' would read and possibly
> write the byte before beginning of strdup'd heap buffer.  All other
> size-accepting options were similarly affected.
> 
> Reviewed-by: Josef Bacik <josef@redhat.com>
> ---
>  cmds-subvolume.c |    2 +-
>  mkfs.c           |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index fc749f1..a01c830 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -380,7 +380,7 @@ static int cmd_snapshot(int argc, char **argv)
> 
>  	args.fd = fd;
>  	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
                                                     ^ +1

> -	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
> +	args.name[BTRFS_SUBVOL_NAME_MAX-1] = 0;
 
   args.name[BTRFS_SUBVOL_NAME_MAX] = 0;

>  	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
>  	e = errno;
> 
> diff --git a/mkfs.c b/mkfs.c
> index 03239fb..4aff2fd 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -63,7 +63,7 @@ static u64 parse_size(char *s)
> 
>  	s = strdup(s);
> 
> -	if (!isdigit(s[len - 1])) {
> +	if (len && !isdigit(s[len - 1])) {

   I think I'd prefer that len is a size_t, not an int here. (Or that
len is tested to be >0).

>  		c = tolower(s[len - 1]);
>  		switch (c) {
>  		case 'g':

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Your problem is that you've got too much taste to be ---       
                            a web developer.                             

--u+FGODhbLwgAeSOU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFPz7EeIKyzvlFcI40RAvSRAKCXwqPznEmwgvHSwPFN4mF6ddgFfgCdFjOd
lnkT+cPI32pVTgdST9svn0I=
=xmFT
-----END PGP SIGNATURE-----

--u+FGODhbLwgAeSOU--
