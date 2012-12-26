Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46605 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab2LZNzP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Dec 2012 08:55:15 -0500
Date: Wed, 26 Dec 2012 13:55:13 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Determining subvolumes
Message-ID: <20121226135513.GU19051@carfax.org.uk>
References: <50DAFDEE.3030204@czarc.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PhxIMoEr374zxJm2"
In-Reply-To: <50DAFDEE.3030204@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--PhxIMoEr374zxJm2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 26, 2012 at 08:38:54AM -0500, Gene Czarcinski wrote:
> I know that I can find out what btrfs "volumes" are on a system with
> the command:
>      btrfs  fi  show
> 
> I can also check if a partition of disk is a btrfs volume with the command:
>      blkid  -o value -s TYPE /dev/<disk|partition>
> 
> And, if I mount that btrfs volume with something like:
>      mount -t btrfs /dev/<btrfs>  /mnt/btrfs
> 
> The, I can get a list of btrfs subvolumes on that volume with the command:
>      btrfs  subvolume  list  /mnt/btrfs
> 
> My question:  Is there a way of finding out what subvolumes are
> defined on a btrfs volume without mounting the volume?

   No. (Well, in theory the code is possible, but there's nothing I'm
aware of that will do it)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Python is executable pseudocode; perl ---              
                        is executable line-noise.                        

--PhxIMoEr374zxJm2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUNsBwb9z9OVl50rAAQLU+xAAiJOXNLeaIY+RvBuzeYpCqFEWHORwsvSB
UrS9z51+1aMbutMkVpuvVvkxkNuLX2i92Aik5sOCMi9frGD8JDArAtq+s6ikRiE7
tldfXKC0jOGkw4QZwlsvNO08SiKU7dpa8HaUsXvj1VpPXvvBi+U7UFu2JzgTYroS
7NDVx50vzQr1eTHiSYcb2KphdrFmZ83/DIqL2g/+K5ddxuIuCU0VkaeCa/s0zOKV
VhI5iCQ1uObISr4hzX/a2Q1aGJEYJwsKO1xSaikZGlkbyupVSmM8qzxtdDujHeSs
JcL2p4r7658haR/kxAXGd5QsGwN9Q8NLyWyBMwVOPIScYnIffUDv6MwDRe+/fJbd
nN/lT1lPRp10l+gHEJ4mQr2RJIdlTm3PiZnKTkNt+hhvQdxdCwJsg/H27AkSiHqZ
6wgUVNu6kHXYrZFwHHnnSCaEahwdN46PGN60R0RIKnuTvWt8pu7BF+YL7CLOYZt9
cwxHpbeBaQtRlA/7Y70/PAtiXfGBi6fF9qUHwZh6vZOV5N9vwjKca5rG66Y4iouR
0A+oAXhwpeAuXX99SvHgA32zfsU1IFaW0JDNkttdhZ+wgm5LK2vRvzJfmbtg+8MT
7uMbP41Lrlu3rm14nmEpowFlYc0XacBntjiqWjhWvi7CB6URkHjtX0+fVqdNJIRR
vp31ZVEvYQ0=
=B+FB
-----END PGP SIGNATURE-----

--PhxIMoEr374zxJm2--
