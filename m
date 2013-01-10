Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53604 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3AJIza (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 03:55:30 -0500
Date: Thu, 10 Jan 2013 08:55:23 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Russell Coker <russell+btrfs@coker.com.au>
Cc: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Subject: Re: 2 errors on scrub
Message-ID: <20130110085523.GS19051@carfax.org.uk>
References: <201301101138.45428.russell+btrfs@coker.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2EGzKU3DZJtwhC8d"
In-Reply-To: <201301101138.45428.russell+btrfs@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--2EGzKU3DZJtwhC8d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 10, 2013 at 11:38:45AM +1100, Russell Coker wrote:
> The below is from a system running the Debian kernel 3.2.0-4-amd64 on a 120G 
> Intel SSD.  What would these 2 errors be?
> 
> scrub device /dev/disk/by-uuid/7939c405-c656-4e85-a6a0-29f17be09585 (id 1) 
> done
>         scrub started at Thu Jan 10 06:00:02 2013 and finished after 295 
> seconds
>         total bytes scrubbed: 25.42GB with 2 errors
>         error details: super=2
>         corrected errors: 0, uncorrectable errors: 0, unverified errors: 0

   Looks like broken superblocks, from that message. There's probably
more information in your kernel logs.

> I know you all recommend later kernels, I'm upgrading things as fast as I can.

   Glad to hear it. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- We believe in free will because we have no choice. ---        

--2EGzKU3DZJtwhC8d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUO6B+79z9OVl50rAAQIJvhAAhlv1Qvol21agWHi9/qO8Zig1ojHOHGEW
W5VqvuO1mCw/u4DUAzt7vSM6t++9wL1NHJHRZC425HgDxo5nYsiYwZP1ZLQvN+Kd
dSCN6rUntQt+0NFfo/3cdQC/1hnYF603E/oZXzlJSAAFkmjVA4djYwsZufxBpoqw
7wi+bJFgn4j9FRkTQNnA7klq+8dqjZXzes8jc6jGLscxVFDryX2VS4PthphvUcJU
UmmKR0lsHURdCCtk06kp1p7WgiBN3kt5a7/a5X9d4aLn6ufX1PC5mD4b2ndSl+l0
r8tiTlRml5/3wNrUMghl+2MDl+vngZkJLNZV1gGgCG4BaVvBhFQXeH4cAPIBA+gj
HNVH87ovKTRu/3OsxPKYCjZous0d7WPSA91QWIpvc7vPRrTvDjZ+HdUfXjGyWCV8
Ytbr7Be/VPUzo/u9KrcXKoYVNBS7NcszjwhE6EXQY7VqBn0IXJTQFA1DITMrVxCa
Myx1h5rzU8mdJ0qpi5pYAKAM7plFAVuuxqwBtN/5+iR6qgUe1w+9K62ziOAjoB+J
VYwIDps5tZTFlUM7MtCfJuGgEZEoPihp5wkYaIWi1ZZ9Yf7nQDkSTjBbUs/p9olX
G3R8k3OqIzbaMbZiYjYXkRF6CMLA/WkmqIQ34f/LPaDy6apBEnz4aAZeaT8RG3Jk
qTc1Pnb+yzI=
=XDVq
-----END PGP SIGNATURE-----

--2EGzKU3DZJtwhC8d--
