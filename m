From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: "not enough space" with "data raid0"
Date: Sat, 17 Mar 2012 14:04:08 +0000
Message-ID: <20120317140408.GG3172@carfax.org.uk>
References: <20120317122522.GD3172@carfax.org.uk>
 <C52qGigT1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fnm8lRGFTVS/3GuM"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C52qGigT1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--Fnm8lRGFTVS/3GuM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 17, 2012 at 02:46:00PM +0100, Helmut Hullen wrote:
> Hallo, Hugo,
> 
> Du meintest am 17.03.12:
> 
> [no space left on device ...]
> 
> >>> Where is the problem, how can I use the full space?
> 
> >> Effectively it's missing the trigger to rebalance when the 'primary'
> >> device starts to get full, or just to randomly spread the data
> >> between the devices.
> 
> >    No, a balance isn't going to help here. RAID-0 requires a minimum
> > of 2 chunks in a block group. With two disks, you're only going to be
> > able to fill the smallest one before you run out of space.
> 
> Ok - it happens only with 2 disks/Partitions?

   Not quite. With the current RAID-0 implementation, you will lose
the difference between the largest disk and the second-largest.
There's a proposal from November that may help with that, but I
haven't had a chance to look at it yet to see what the implications
are.

> I've continued playing; added a 3rd partition/device and then balanced:
> 
> 
> # btrfs device add /dev/sdd1 /mnt/btr
> ## 73 + 146 + 146 GByte

   OK, so in this case the largest and second-largest devices are the
same, so you will lose no space.

[snip]

> Looks as desired, the 3-disks-system contains more than 3 times the  
> smallest disk.
> 
> Balancing hasn't redistributed the contents - no problem.
> 
> By the way: you should name the prefixes in the NIST way for powers of  
> 2: KiB, MiB, GiB. Or change to decimal prefixes.

   I know. It's something I submitted patches for a long time ago, and
they never got taken up. It's on my list of things to fix.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- UNIX: Spanish manufacturer of fire extinguishers. ---        

--Fnm8lRGFTVS/3GuM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPZJnYIKyzvlFcI40RAjMFAKDIpMUBDnPWFwyaL3Fnypz3p9rqMQCgsLYB
d9EQ7xP8puU/f8v2l66sNks=
=lAA9
-----END PGP SIGNATURE-----

--Fnm8lRGFTVS/3GuM--
