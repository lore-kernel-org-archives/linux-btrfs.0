Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41702 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaAIRnh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 12:43:37 -0500
Date: Thu, 9 Jan 2014 17:43:35 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: George Eleftheriou <eleftg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How does btrfs handle bad blocks in raid1?
Message-ID: <20140109174335.GL15634@carfax.org.uk>
References: <20140109170945.GK15634@carfax.org.uk>
 <CAPpBBdNKSUHCtM3fk7=ujJFZSL8LMf_iQXdZ-O-bXcTRN69c3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DXTueXWT3Da08pik"
In-Reply-To: <CAPpBBdNKSUHCtM3fk7=ujJFZSL8LMf_iQXdZ-O-bXcTRN69c3g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--DXTueXWT3Da08pik
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 09, 2014 at 06:34:23PM +0100, George Eleftheriou wrote:
> > claiming that RAID-10 (with 2-way mirroring) is guaranteed to survive
> > an arbitrary 2-device failure is incorrect.
> 
> Yes, you are right.  I didn't mean "any 2 devices". I should have
> added "from different mirrors" :)

   If you have an even number of devices and all the devices are the
same size, then:

 * the block group allocator will use all the devices each time
 * the amount of space on each device will always be the same

If the sort in the allocator is stable and resolves ties in free space
by using the device ID number, the above properties should guarantee
that the allocation is stable, so each new block group will have the
same functional chunk on the same device, and you get your wish.

   It's been a few months since I looked at that code, but I don't
recall seeing anything directly contradictory to the above
assumptions.

   Of course, if you have an odd number of devices, the allocator will
omit a different device on each block group, and you lose the ability
to survive (some) two-device failures. I suspect that the odds of
surviving a two-device failure are still non-zero, but less than if
you had an even number of devices. I'm not about to attempt an
ab-initio computation of the probabilities, but it shouldn't be too
hard to do either a monte-carlo simulation or a simple brute-force
enumeration of the possibilities for a given configuration.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- <Diablo-D3> My code is never released,  it escapes from the ---   
          git repo and kills a few beta testers on the way out           

--DXTueXWT3Da08pik
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUs7fx1heFHXiqx3kAQIhDRAApCmbUxSdrNvlHC5yIx+o0eVjYx1c+cUH
v8gx4EtiNjEcr53ULrm4xeW20+BWSOwf7w0ML+blK5BJ899xzAIiIsuXCTJdU6IB
PdF9BtbsZ9r1RjQv4n7r/1h0QIX6b4bGHFkEhpcNIXK8MFOLarm/T4ZzEXPBx1lo
OQnB2RST8aCO7iQOdmHpgVWT+LLxj9tvUJmV4R9Pdhr4+1XHBvVLLIaAFpZKH3N5
YVVbhODGTmqxx6fC9vpnIhyKw26c/SxokSoXbUrqrEdkBj6YQNhI43g6o8TBEt+D
7lrlGGkbiwoCfkpA9D+M+L6yGlQuRnxuqfOa5euEBitnpCuG3mNtT7ubMkslTcj9
Ig7Ij4r+R1qYd20PJA7o4AqILl2gY8udcXPmUVACjv3zVS8j2ScF0diuyv8Rf+8d
5t6zP7vDQy7czehwhKoIK3blSW+Uf7M2xqNis+VD85sxcoDqCc9G/WILkIvWMoXJ
Wmj1w2GRetyTFmlHn0VJhVaCYSnYEgpjNi4n0w/aDSjWLl5uftKtwnoyzCKrSWrf
FmPGIWUYbwa+5aqEHLjIFbBiA/aLwUsX5u9iZwSoPVm+qPmhn7JlXvFGdiugfny0
OKjZLmr5tySrXgCEyh+m1xGV54inUmmW92hU/McIU5sviHq/BI36muUPrYK5nNUn
rfETJfxYy7E=
=MQMK
-----END PGP SIGNATURE-----

--DXTueXWT3Da08pik--
