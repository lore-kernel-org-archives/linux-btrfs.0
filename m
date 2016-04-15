Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50172 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbcDOMtM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 08:49:12 -0400
Date: Fri, 15 Apr 2016 12:49:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: sri <toyours_sridhar@yahoo.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-image and btrfs send related queries
Message-ID: <20160415124910.GD30971@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fWddYNRDgTk9wQGZ"
In-Reply-To: <loom.20160415T142724-462@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <loom.20160415T142724-462@post.gmane.org>


--fWddYNRDgTk9wQGZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 15, 2016 at 12:41:36PM +0000, sri wrote:
> Hi,
> 
> I have couple of queries related to btrfs-image, btrfs send and with 
> combination of two.
> 1)
> I would like to know if a btrfs source file system is spread across more 
> than 1 disks, does btrfs-image require same number of disks to create 
> empty file system without files content??

   I don't _think_ you need as many devices as there were originally.

> 2) would btrfs-image can be modified to keep only given subvolume foot 
> print and related meta data to bring back file system live on destination 
> disk?
> 
>    To elaborate more on this, Lets say I have 5 subvolumes on source btrfs 
> and i run btrfs-image written to destination disk say /dev/sdd. In this 
> process, can btrfs-image modified to just have only 1 subvolume and skipp 
> other 4 subvolumes and write to destination i.. /dev/sdd so that when I 
> mount /dev/sdd , I will have btrfs with only 1 subvolume with no data.

   For a first approximation, you could just drop any FS tree from the
image which wasn't the target one. After that, it turns into a
complicated accounting exercise to drop all of the back-refs to the
missing FS trees, and to drop all the extent records for the
non-shared data and the metadata for the missing FS trees.

   It's probably going to be complicated, and will basically involve
rewriting most of the image to avoid the metadata you didn't want.

> 3) If 3 can successful, can btrfs-image further changed to include data of 
> selected subvolume which gives files data also written to /dev/sdd which 
> would be kind of a backup of a subvolume taken out of a btrfs file system 
> which is having more than 1 subvolumes.

   If you're going to do all the hard work of (2), then (3) is a
reasonable logical(?) extension.

   On the other hand, what's wrong with simply using send/receive? It
gives you a data structure (a FAR-format send stream) which contains
everything you need to reconstruct a subvolume on a btrfs different
to the original.

   Hugo.

-- 
Hugo Mills             | Mary had a little lamb
hugo@... carfax.org.uk | You've heard this tale before
http://carfax.org.uk/  | But did you know she passed her plate
PGP: E2AB1DE4          | And had a little more?

--fWddYNRDgTk9wQGZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXEONFAAoJEFheFHXiqx3kcXQQAKWer80UzUVBjdLUMdhcAFKW
oFFntnErbu7EB8/kkjr/QJXS1dmMhMiQmF81IGDcFqJKzCcc+7FcOWmivD/IcTyf
o+LBnD1nlo3DZB9aF9RtjBB+iS4gpE6Lq2rxoTaRQHQWIvd0KCyJhLmdgRlwH0Mh
6llxt1B7deK1vq5BfK7C5UflqoYwcoFP7BlP935friZVu0L6Oy48zRcHTqnmZUCu
7jLtm0mrponxNh+9EKhjxBPP4XXggK9kA8qm86KmJtu2Mqj+Rval6Ozqp0lVVFL4
bgfTUkaW406l9p0LnhdNEm34uahNTNmOLfNQpcN6P8HbcenWLdyFHqeoVETTsIpc
b/RgRpsOEOtL0ACP8VehxRnd3iLorDZxdpX/+KTgsA6LoPygazkfdN8lHxXS+Gda
z2tcZ8aKMgK4g4dpOdcQRpamSKK4zLB11DxZX1brAYRixjiSGzThds2W/NPuwePC
SgwN/jOn7qAkm//+XK5rqc/+3jOM1pWZYXfoQ+eSlNsqNybSzbHIvsk4Gesj4Lg3
x5Hm0bIPWPG1LIzePoyByvAtgfb/6JzmZNyzpQ5yyP0HNeShGZT+rjGXRfhnoGFI
jWGrfkvSQQxPAnNAs4m4r2djSbwo3x7sIoazesaNpy/q4PATpUp7UzZ2lfFspTAK
F6qIQ0YjAazjAICAxoLX
=2Xf4
-----END PGP SIGNATURE-----

--fWddYNRDgTk9wQGZ--
