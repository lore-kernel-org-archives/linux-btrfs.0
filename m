Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47949 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaEKOUC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 10:20:02 -0400
Date: Sun, 11 May 2014 15:19:57 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: laie <laie@halifax.rwth-aachen.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: destroyed disk in btrfs raid
Message-ID: <20140511141957.GC23212@carfax.org.uk>
References: <2a45648842c071a8e0d3285541d96c6f@halifax.rwth-aachen.de>
 <20140509175827.GG16185@carfax.org.uk>
 <20140509180137.GH16185@carfax.org.uk>
 <c1b636dffe4c70c4e15010000e730703@halifax.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pk6IbRAofICFmK5e"
In-Reply-To: <c1b636dffe4c70c4e15010000e730703@halifax.rwth-aachen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 13, 2014 at 10:16:59AM +0200, laie wrote:
> On 2014-05-09 20:01, Hugo Mills wrote:
> >On Fri, May 09, 2014 at 06:58:27PM +0100, Hugo Mills wrote:
> >>On Fri, May 09, 2014 at 08:02:45PM +0200, laie wrote:
> >>> Now I'm looking for a way to tell btrfs to provide me with a list of the
> >>> corrupted files and delete them afterwards. This would be great, because
> >>> otherwise it would take very long to get the data back from slow backups.
> >>
> >>   Simple solution: cat every file to /dev/null, and see which ones
> >>fail with an I/O error. With RAID-0 data, losing a device is going to
> >>damage most files, though, so don't necessarily expect much to survive.
> >
> >   Actually, you could cat just the first 256 KiB of each file to
> >/dev/null -- that should be sufficient, because with RAID-0, the
> >stripe size is 64 KiB, and 256 KiB is therefore 4 stripes, and so
> >should cover every device... :)
> 
> I was hoping for an internal tool, but I guess the matter is to specific.
> Thank you for the fast and easy solution.
> 
> Are you sure that using only 256KiB covers also huge files, even if only the
> last Part is missing?

   Aah, thinking about it harder, since you had a partial balance,
there will be some block groups that are on n-1 devices, and some that
are on n devices. This means that you could have some files with parts
on unbalanced block groups (so, probably safe) and parts on balanced
block groups (probably damaged).

   So go back to my earlier suggestion: cat every file completely.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- The trouble with you, Ibid, is you think you know everything. ---  
                                                                         

--Pk6IbRAofICFmK5e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU2+HDFheFHXiqx3kAQIRrA/+Ni/yD7WTipY/G/iLknwHbSLamnsIAlds
mu6b/hZawlFeURXW6K2bLRdPO1e1Tc3WyQTVL9iVBOHpSCGIWjrSeDunAGy8K/xG
C3yPB46v1zQpc0GMfKI1pDJJSOisKYgbk0ygxdpf2uFzZyrU3mmr7Ki//Jz+T2Wa
GeqLjtvc5BLhPX5q6eDCG5pRG5QomypfdhHR85aiB3k46/ysTqX5EQk9+VmRYms5
AE6HGj4uo5lQ0MZizT/lqI22BDMyovDBQUFe/Wgu+NCexyKW3LwL9besfPUnPGur
AgJyYde2qR+awIXVGg7WgOa1ra9ztNjLCjRUyRAw9AzSE58JvBKmrI6nJH/PCNVT
haCkMQX805MH0N93NjcksWzoivg5sSd8dOBaNA0pxfyr+ecVuTWYH8VJymI4M2+9
ZMOHjLhwFq3DEh9xQymfRx118X4fuUCYs+4au4gVflBzzymUKr7sAttSXjSI6UDz
HzM3iwyHR8k08rNM7enwurH8MFIgbfJS0BfYH7LpP5acI0IKWRHMz3HP8t9IjZ6Y
KDy6oorl3QH+HFZG+uaCdfrejeiM0fR3dziH33dplHWAtXijv0TKJ6ZF0IyWKhqH
v+etYeLKvX18D817gT3LHjT/qqfAlSSGmoWl7EPNy3KpYSSlKtEj82ufUav75yU6
+MTSAtB/kkc=
=9ttc
-----END PGP SIGNATURE-----

--Pk6IbRAofICFmK5e--
