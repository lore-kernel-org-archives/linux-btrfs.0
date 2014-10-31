Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54788 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaKAM7n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Nov 2014 08:59:43 -0400
Date: Fri, 31 Oct 2014 11:32:33 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Lakshmi_Narayanan_Du@Dell.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: request for info on the list of parameters to tweak for PCIe SSDs
Message-ID: <20141031113233.GF907@carfax.org.uk>
References: <6891C2FAE3B0F342A5B80AFBDCFB579713AACD334A@BLRX7MCDC204.AMER.DELL.COM>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TeJTyD9hb8KJN2Jy"
In-Reply-To: <6891C2FAE3B0F342A5B80AFBDCFB579713AACD334A@BLRX7MCDC204.AMER.DELL.COM>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--TeJTyD9hb8KJN2Jy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 31, 2014 at 03:56:15AM -0700, Lakshmi_Narayanan_Du@Dell.com wrote:
> Hi,
> 
> Could you kindly help us with the list of all the btrfs  file system parameters , that can be tweaked for the best performance of the PCIe based SSDs ?

   It should detect the ssd option automatically, but it doesn't hurt
to specify explicitly. You can use the discard option, but I would
only recommend it if the SSD supports queued TRIM -- the older
unqueued TRIM can cause massive performance problems.

   You may want to use autodefrag, which has less of an effect than it
would on a rotational disk, but will still help to keep the number of
extents down. That will reduce the metadata overhead.

   That's about all there is for btrfs-specific options, I think.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                      --- make bzImage, not war ---                      

--TeJTyD9hb8KJN2Jy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUU3NRAAoJEFheFHXiqx3kqZ0QAIOHXPnPxfN0E6HS6VeWjvj6
0J/NS8VI65TK/myD5vxkaeplj3/Dcyk9ehmLX36f+vTWfRHqi2aeNoJvOaK7J7UR
N94aU8Ejf/jLdC/EuMnQw1rmaA+f/JcsLGwPMMdYzylhB/DdpHHhlDpDvqkYM/U9
GqQdqR4U4Tsyiy7VWS7EHtAXoNDg35+QTbeg0toOmbOMSEwJxPB76F1n+MAil3kk
j9rJ6FI7RoLBen2k8tthhAVRC/8xn82yjutbWtqDxMo/QTFNnoLj5/aB8NEMVZ7b
f7b/U6V7ny7XHiGZyNR6Mk6o6enS0hAwx1XAhnknx1FYACepMAkXh1Scn4xiLuRO
93weKUT9oy/NcCnxCXvdTtK1y4vitmLiVdSNJh1+/O7KldKs9avPMreo/Vc0/S1Z
epSBLulUg17eUZlGubYUvx0pw+5Ay0ducMOmZd38FtDRjK/nY4471hQjJc7tSOLR
v+LV1dd7VWZl+edwlgZTNXmoaD85+KFdl/E0m/yt6WQ25aCSJ4HDpPSUgXXxYjUg
R/woGGQzeZy7MBuIjtxFR+efyJShvOQgQfn6EOsBcWGwRMT3Sewph4Y4C2L/ti2K
D1PJmJdXlxCqJKFVtL98tPIcq8EWhXIB0KOqt5PloGInVaSuP0ETK8mB6fRQ68gh
yTuFtqeEcQ/kqTa9BIDS
=S8D4
-----END PGP SIGNATURE-----

--TeJTyD9hb8KJN2Jy--
