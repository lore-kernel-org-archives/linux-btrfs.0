Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56049 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaJQIRk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 04:17:40 -0400
Date: Fri, 17 Oct 2014 08:17:37 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
Subject: Re: unexplainable corruptions 3.17.0
Message-ID: <20141017081737.GC29594@carfax.org.uk>
References: <20141016091726.GA582640@mother.pipebreaker.pl>
 <20141017080202.GA3604@localhost.localdomain>
 <20141017081009.GC582640@mother.pipebreaker.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
In-Reply-To: <20141017081009.GC582640@mother.pipebreaker.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 17, 2014 at 10:10:09AM +0200, Tomasz Torcz wrote:
> On Fri, Oct 17, 2014 at 04:02:03PM +0800, Liu Bo wrote:
> > >   Recently I've observed some corruptions to systemd's journal
> > > files which are somewhat puzzling. This is especially worrying
> > > as this is btrfs raid1 setup and I expected auto-healing.
> > > 
> > >   System details: 3.17.0-301.fc21.x86_64
> > > btrfs: raid1 over 2x dm-crypted 6TB HDDs.
> > > mount opts: rw,relatime,seclabel,compress=lzo,space_cache
> > >   Reads with cat, hexdump fails with:
> > > read(4, 0x1001000, 65536)               = -1 EIO (Input/output error)
> > > 
> > Does scrub work for you?
> 
>   As there seem to be no way to scrub individual files, I've started
> scrub of full volume.  It will take some hours to finish.
> 
>   Meanwhile, could you satisfy my curiosity what would scrub do that
> wouldn't be done by just reading the whole file?

   It checks both copies. Reading the file will only read one of the
copies of any given block (so if that's good and the other copy is
bad, it won't fix anything).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- The future isn't what it used to be. ---               

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUQNChAAoJEFheFHXiqx3kwLIP/34azRMbgGvUu6wLfQh+ZrwG
qq4D2czWYtQkRxsqBxUMc85I7HtxoF0INcCOv8MxwGzRriW/6SAQ07rRC2quKIjU
JDa/ELTnc8xFaaEEOkcN6yK4TOTRfCJg8QDHsYcJQ/xuMAAZgv5EL7QX4rOGqLJk
FX7G2E0K1G1p6Ly1dNiTV854G+FU7bOwCrl+j9QOIxs2ZdMdgG4uM2xaz4GP3uQZ
rAOfhtI2JkCgkRVhN8Ridh4P2DSKBgYIlaLr3LKjx5Cj9ryFLH7ClyiQAo0c5o4a
OoMZna3I0risMvmpRbevQdAataq/0dbGeWLrpXQnecwAa/uNrCEs1UoBSYPX9gZl
tnEIFU4Io+PPlEKiS9KQJFFSrDZctbnCfBQj52i3w5vNgJrdI5zPYLxakkx97Je0
5iLCUm5GFxx91h1a0+J4oe0LBhkzdAuKeOJEytcJoToiwTyCHgrl9ivgYXmxzK0F
leqRmfZqN7nv8FjDFPOolAL/4oj2bRdeM7kBHRZEmRozH+3eAiC8ATElOAQiA1FV
ai22gjH3yfZTaoONXomekrg98skTdipQbP7yIE1GrV1nMzKo2+h64CS5LMwUkdcC
UL16YUdxXmz5tRFB3gEkD+UYvQUKOxCoVMhJkrhWm5996FDG4DyWAgYuXzUtEZ5S
cTLzHq2phcEwgiAC6Syc
=MUlp
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
