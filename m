Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47073 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449AbaJVUme (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 16:42:34 -0400
Date: Wed, 22 Oct 2014 20:42:31 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Robert White <rwhite@pobox.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: NOCOW and Swap Files?
Message-ID: <20141022204231.GD18164@carfax.org.uk>
References: <54480ED0.9070703@pobox.com>
 <20141022202519.GC18164@carfax.org.uk>
 <5448161E.6020306@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="llIrKcgUOe3dCx0c"
In-Reply-To: <5448161E.6020306@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--llIrKcgUOe3dCx0c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 22, 2014 at 01:39:58PM -0700, Robert White wrote:
> On 10/22/2014 01:25 PM, Hugo Mills wrote:
> >    The new code is the swap-on-NFS infrastructure, which indirects
> >swapfile accesses through the filesystem code. The reason you have to
> >do that with NFS is because NFS doesn't expose a block device at all,
> >so you can't get a list of blocks on an underlying device because
> >there isn't one. Indirecting the accesses through the filesystem,
> >however, allows us to side-step btrfs's problems with part (b) above,
> >and in theory gives us swapfile capability.
> 
> I was not even aware there was "new code" on the matter.
> 
> Is there a guide or whatever to doing this? I didn't see any mention
> of it in the places Google led me.

   swap-on-NFS is still, I think, in a set of out of tree patches, and
it's not gone anywhere near btrfs yet. It's just that once it does
land in mainline, it would form the appropriate infrastructure to
develop swapfile capability for btrfs.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Great oxymorons of the world, no. 7: The Simple Truth ---      

--llIrKcgUOe3dCx0c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUSBa3AAoJEFheFHXiqx3kdB8P/jfZAZaA62RCRrhZvy+ZOEx4
2pOOYZQzjYmdoCSNZF1Mh4bOtPRadDS2qcjcafHZRQQwVYIWLEQ9kuZv5f+0oAlC
tkDhxGxLbrKNluO9qGi3NOnPqeY/igH6Vg/aMoU583JZ7Q+SnQeisznramqq8Skg
1m1OwKkJSRSBYUHYu66I3/X3sfUVc5jgLVb+NmB4ZLMW7zlSOsDjjdWapRQ1rG7Y
v+2enBS/+6J4UoARN0QHDo2OHoJZydr2BBHvCjdpuCeoOh3I3VeoZFlHNlF0HpBa
zWuVymvxKD2HMGnisAgsLy80hdfvhRUkhGWE+FpaJ7uHrhNLUQTLFNWVg4Q92YWQ
jR1gaX55559Y9HOvMKzYiecvvvas2hrtqeKxZ+HS7gy3lLo+OWs+I+1/pSmaWwq5
TK/OyPwGWOy++DU974rgvo1cGIniV7IcCgS29IdZN9SaTNxkDqJiY7Jwfs/PXfap
Ook4X2EpbwQe03L+mIwTY+EMolFNvT/WehLyRxGmy1u54ZJu3pz3s7vpPSwFG56a
jCsqNJcVPSyq3YgaQ4BZEdGsbPqFceTk20VQ4q2LnMAFRUa8AyswLUIV5BStY972
eZFpNag0g0VGMo++bBXxNDGGLSy4fl07Rg6AKDSIzU+CDlDMBipIPcZ08nbqkvx3
fjhV6wgFQ8pJIYijfA5q
=Eb0+
-----END PGP SIGNATURE-----

--llIrKcgUOe3dCx0c--
