Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45862 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3J3MnN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Oct 2013 08:43:13 -0400
Date: Wed, 30 Oct 2013 12:43:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Mike Arnautov <mla@mipmip.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Metadata reservation
Message-ID: <20131030124310.GQ14405@carfax.org.uk>
References: <5270F854.7090402@mipmip.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oDto3OTLsk6uOlQH"
In-Reply-To: <5270F854.7090402@mipmip.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--oDto3OTLsk6uOlQH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 30, 2013 at 12:15:16PM +0000, Mike Arnautov wrote:
> I have just moved some partitions on two Linux (Mageia 3) boxes to
> btrfs (call the boxes A and B). In both cases only a part of one
> physical disk can be allocated to btrfs.
> 
> On box A, the btrfs partition size is 419 GB and the resulting
> usable space is 418 GB with 1GB reserved by btrfs for metadata.
> 
> However, on box B, where the partition size is 388 GB, reserved
> metadata amounts to 128 GB (!), leaving just 266 GB for data.
> 
> I've now done box B twice. Once using btrfs-convert and once by
> reverting to ext4, and using KDE control centre to change the type
> of the partition to btrfs, restoring the data from backups. In both
> cases metadata reservation amount to 128 GB -- about 30% of the
> disk.
> 
> Any suggestions on (a) what the cause might be and (b) how to
> improve things?

(a) Probably a kernel somewhere in the range 3.7-3.8 (possibly 3.6).
   These kernels had a problem with excessively overenthusiastic chunk
   allocation. If that's the case, a newer kernel should stop it
   happening again. Alternatively, you've got lots and lots of small
   (<3k) files, and it's decided to inline them all.

(b) btrfs balance start -musage=5 /mountpoint should cleean up any
   little-used or empty chunk allocations, but on the kernels above,
   it'll probably overallocate again. You may need to bump the usage
   parameter up a bit (it's a percentage) to harvest more chunks, if
   the first run isn't sufficient.

   If you still have the problem, then send us the output of:

btrfs fi show
btrfs fi df /mountpoint
uname -a

and we can take another look at it.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- All hope abandon,  Ye who press Enter here. ---           

--oDto3OTLsk6uOlQH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUnD+3lheFHXiqx3kAQLEPw//R+szI8AKgt0t4tvuUPp2aRjIMnOKeOtP
cersVHWPWJKnrJbDEfx7z/oWDWWM4Gsv1AObDyeOWsK7eXBDwCdEz/l/jpR5ncki
VWkzT4ib78zL6CGTNvKOS+2TnxXXcQmJ2Dd8DsDRd5rvfPe4bwYh29I+RWA/I7eD
Xvx0mPqdC0YTBtjPQx0fW090BKG2SIkd4u56SgZn9Jw5xNbkMZNuNUhu2eFyoC+D
BFkq9W+cITiO2YrtG3i38WwyqTCNv8NrL4/+MlhZPbGHfZXO0guFeQI39f1osQ5m
Eu6LLWLiBRPXqXKBsdpfv2cgTwWSXlc/EDBJzQcQbTZG3SSB6yCys1t919wHe4Hu
gpdwcRTNtxkm3LSZkEefXL6CE12MWAbQ4spvgALXD3O1JNTaTjxsYfJXbi4Pc3xL
lRw/XI6XTMa4Hwx2CnL9vAf18KZReeIKS3KyO9FFdt3qbfYlgOmz5ccBVG+JYF/5
Vh4gyv+7WwSJYJEz78oLyOhx81d/2OANWYPQI5e3hAJd4XNS1v0e08X3sw17WAyE
y3m7oke6fogP0HW1rs4oyn+1BgnCQchriwBN59J/Y+OCfERnzcw8wAWkhyAWhzsf
in5aoeFhH/PjHDvu3eA8XyxO6evoR+UcqSpog/MLOfDxxRV3wknpckNeKif9/ceb
kGFKVX0vXbM=
=TKIa
-----END PGP SIGNATURE-----

--oDto3OTLsk6uOlQH--
