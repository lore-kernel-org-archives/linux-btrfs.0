Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47489 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab3C0JS1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 05:18:27 -0400
Date: Wed, 27 Mar 2013 09:18:22 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "No space left on device" although df reports only 55% in use
Message-ID: <20130327091822.GC9290@carfax.org.uk>
References: <CAFvQSYS4o8iGTKYahX8zL3ng4Qre=uYDT7iOB0NTP+inUijQJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H8ygTp4AXg6deix2"
In-Reply-To: <CAFvQSYS4o8iGTKYahX8zL3ng4Qre=uYDT7iOB0NTP+inUijQJQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 27, 2013 at 12:28:23AM +0100, Clemens Eisserer wrote:
> I am using a btrfs loopback mounted file with lzo-compression on
> Linux-3.7.9, and I ran into "No space left on device" messages,
> although df reports only 55% of space is used:
> 
> # touch testfile
> touch: cannot touch `testfile': No space left on device
> 
> # df
> Filesystem     1K-blocks      Used Available Use% Mounted on
> /dev/loop0      32768000  17383924  14649172  55% /home/ce/anditest
> 
> # btrfs filesystem df .
> Data: total=28.22GB, used=14.25GB
> System, DUP: total=8.00MB, used=12.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.50GB, used=1.16GB

   Your metadata is close to full -- we need quite a lot of working
space to CoW into. You (probably) have the full disk allocated to
chunks, and too much is allocated to data; not enough to metadata. You
need o balance, with a filter for the unused data chunks. See the
section in the FAQ on the wiki about full filesystems. (Sorry for not
finding the link, I'm on a restricted connection right now)

   Hugo.

> Metadata: total=8.00MB, used=0.00
> 
> Any ideas what is going wrong here?
> 
> Thank you in advance, Clemens

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Gentlemen!  You can't fight here! This is the War Room! ---     

--H8ygTp4AXg6deix2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUVK5XVheFHXiqx3kAQIStBAAtGIw8tfwQ3s1BPTvUscsAvCucnjHNJzE
AgV4yK8Xx9R0cV/iOgI9xyIOVSHSWinrXr6g5xgWyx+WfOHAfzJfVI9BCwKvTJzD
V0dMplebQ8w3n38idos994nJTAHzltxZE24Xa07tp1strlRabwCCVUOdaeD8IVC1
X+RHvk8BBBoaIUnoDvReY7OEBu5cYfkd7Yu0yAQBYWaQw3Q8L2NavaWoOv4iz82N
bNyTeKfIEwqzf28wmCVPbajDwES83yd87LGX0kcz2nyUisGNTtHbwqXf10PpmyFJ
5OfBxf2JBnIQbvTdUIsdgtJN0Uggep6yOJ8epXn9J4MZp9dUXFVEipaRjpJ5gkb1
M8JlX/CEDMA3U8pbqk2UT84s+jx35xEfdLGECh6epISTfusS7Cfb+uB6ciCmM/NI
yxWrJMWCp/I7bLMVD7Bds0W+CHoosu+nyx+djvsSX/DLcoVLn1t6441s9pXHPA6R
TDWauWzOl9HEjBP0i80n5S0PCvd7AcxUxUSMK+2XTTJnW47r+irTc4t9h6TpETtR
9+rBcf0aIjSJBJ5q6PjHHIlGC9YaTIP+ysl4u1wl9wZ2G5rpliLhWrsxOx8ka9bT
r6uJWE98YESHp3MSW+1yV8ZdOog/70h8lxNUapokabQctiymZkyUB01bFYDPxj0K
w3E7GXhouxk=
=YUzx
-----END PGP SIGNATURE-----

--H8ygTp4AXg6deix2--
