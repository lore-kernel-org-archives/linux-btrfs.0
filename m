Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50848 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab2LRMNP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 07:13:15 -0500
Date: Tue, 18 Dec 2012 12:13:11 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: Sebastien Luttringer <sebastien.luttringer@smartjog.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Feeback on RAID1 feature of Btrfs
Message-ID: <20121218121311.GL19051@carfax.org.uk>
References: <kanf24$o8e$1@news.dmz-ext.fr.lan>
 <20121217162350.GJ19051@carfax.org.uk>
 <50D05174.4060109@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y+Z5jE7Arku/2GrR"
In-Reply-To: <50D05174.4060109@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Y+Z5jE7Arku/2GrR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 18, 2012 at 01:20:20PM +0200, Brendan Hide wrote:
> On 2012/12/17 06:23 PM, Hugo Mills wrote:
> >On Mon, Dec 17, 2012 at 04:51:33PM +0100, Sebastien Luttringer wrote:
> >>Hello,
> snip
> >>I get the feeling that RAID1 only allow one disk removing. Which is more
> >>a RAID5 feature.
> >    The RAID-1 support in btrfs makes exactly two copies of each item
> >of data, so you can lose at most one disk from the array safely. Lose
> >any more, and you're likely to have lost data, as you've found out.
> >>I'm afraid Btrfs raid1 will not be working before the end of the world.
> >    It does work (as you demonstrated with the first disk being
> >removed) -- but just not as you thought it should. Now, you can argue
> >that "RAID-1" isn't a good name to use here, but there's no good name
> >in RAID terminology to describe what we actually have here.
> Technically, btrfs's "RAID1" implementation is much closer to RAID1E
> than traditional RAID1. See
> http://en.wikipedia.org/wiki/Non-standard_RAID_levels#RAID_1E or http://pic.dhe.ibm.com/infocenter/director/v5r2/index.jsp?topic=/serveraid_9.00/fqy0_craid1e.html
> 
> Perhaps a new name, as with ZFS, might be appropriate. RAID-Z and
> RAID-Z2, for example, could not adequately be described by any
> existing RAID terminology and, technically, RAID-Z still isn't a
> RAID in the classical sense.

   Yeah, we did have a naming scheme proposed, with combinations of
nCmSpP, where n is the number of copies held, m the number of stripes,
and p the number of parity stripes. So btrfs RAID-1 is 2C, RAID-5 on 5
disks would be 4S1P, and RAID-10 on 4 disks would be 2C2S. I'd prefer
to see that than some non-"standard" RAID-18KTHXBYE formulation.

   Plenty of room for shed-painting here, though.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- I believe that it's closely correlated with ---           
                       the aeroswine coefficient.                        

--Y+Z5jE7Arku/2GrR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUNBd179z9OVl50rAAQK1/Q//SEYkT42rjPI3hjrtbk7oG4gEE6aPMxjK
3AJBuUoQmP3a14GXwhV9y/bstfhmztPGsJ2X09duFSLrX6DKa9vmSzYmWBUv6dc8
S4yyRmsdpYZDse2pUveg/a6fywasMJGyocGZEtOkLZ6JqiAhKnVvoZ/98sNKIdDa
hHtaYBpERAmA7TYhHCEykC9b7LqtBeaH1dRPZ3LXsC2/jNAD+ZvwUzF+5S+ZDCUC
KTdAf3MQeyZV8WJlOj3T1cInqw2NTgxVVmDfzj+Vy8Z7ZAqpp1RcmvDqISatby46
IAuNRag8Yjx82p9/CVkJGFTK7uocHbyv9FQUpVgR4I+i0XBuMU5ZJClfNlxqX2u+
dT7k2CG/AHAUn0reYWS9uJfQJU2WfM2JzwXlIxvcegNvf/Iv8Kw5Zwvmo8itNw7I
jVMFxJYfoe+g2k0MFy/5PgSQmLhhfbDLdbAi0IuZquFpQFVV/cROCsrFaNlk0VFJ
Ke+EXqIG9iiDkHbTsRAGUiFLujb/bFsl7nEcFkSWrOLROufgj7LO4VTO2Jvc25cE
SbLrnSm/GX0llHDV9VesS0Uqk7vrPrdByc+bTgyjUh/7Zb4Bwzi8MnJAHCLgMLW0
jdsenk2Xn5Fxktmdb37uZ+99W3OARzvPVlBiY95HONh0xfbg0xdKlUvHwPn+QL7/
6YVECcAXvpE=
=8VwB
-----END PGP SIGNATURE-----

--Y+Z5jE7Arku/2GrR--
