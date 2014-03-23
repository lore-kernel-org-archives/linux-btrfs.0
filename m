Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59906 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaCWReM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 13:34:12 -0400
Date: Sun, 23 Mar 2014 17:34:09 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org, Duncan <1i5t5.duncan@cox.net>
Subject: Re: ERROR: error during balancing '.' - No space left on device
Message-ID: <20140323173409.GG25400@carfax.org.uk>
References: <pan$a5998$152d4a82$370a3453$dc1d788e@cox.net>
 <20140323114712.GC25400@carfax.org.uk>
 <20140323162000.GK12833@merlins.org>
 <20140323162825.GF25400@carfax.org.uk>
 <20140323170314.GM12833@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E69HUUNAyIJqGpVn"
In-Reply-To: <20140323170314.GM12833@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--E69HUUNAyIJqGpVn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 23, 2014 at 10:03:14AM -0700, Marc MERLIN wrote:
> On Sun, Mar 23, 2014 at 04:28:25PM +0000, Hugo Mills wrote:
> >    Before you do this, can you take a btrfs-image of your metadata,
> > and add a report to bugzilla.kernel.org? You're not the only person
> > who's had this problem recently, and I suspect there's something
> > still lurking in there that needs attention.
> > 
> > > Hopefully this will be handled better in later code.
> > 
> >    With the info you can provide from a btrfs-image... let's hope so. :)
> 
> Mmmh, this may not be good :-/
> 
> legolas:/mnt/btrfs_pool2# btrfs-image -c 9 -t 6 /dev/mapper/disk2 /tmp/pool2.image
> parent transid verify failed on 295965446144 wanted 51493 found 51495
> parent transid verify failed on 295965446144 wanted 51493 found 51495
> parent transid verify failed on 295965446144 wanted 51493 found 51495
> parent transid verify failed on 295965446144 wanted 51493 found 51495
> Ignoring transid failure
> leaf parent key incorrect 295965446144
> parent transid verify failed on 106205184 wanted 51468 found 51528
> parent transid verify failed on 106205184 wanted 51468 found 51528
> parent transid verify failed on 106205184 wanted 51468 found 51528
> parent transid verify failed on 106205184 wanted 51468 found 51528
[snip]
> Segmentation fault
> 
> Is it a bug in the tool, or do I have real corruption?
> 
> Are there magic options I can give it to make it work around this?

   xaba on IRC has just pointed out that it looks like you're running
this on a mounted filesystem -- it needs to be unmounted for
btrfs-image to work reliably.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Unix: For controlling fungal diseases in crops. ---         

--E69HUUNAyIJqGpVn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUy8bEFheFHXiqx3kAQJ2pA//aiJJkxKSlOTJUYw/pEXZBv2JDCpr5Hj+
AOUK+2Uo+do8ryfRE8inS5/uAmxS0akf/SA4zvH79RtIQaL/F64iMxg/dpxWeMMQ
vClDL7b2NPR4uNbVV7j655iV7k28y4QFiJKzAfC0zFEAuxFQpfiy2Yerh3niNzxM
1Frl3KqMMJAU51jbJUQ5abtG30JPqNL2GbQx8qjh9CVVcR5OjpCN+ShuFdp9WaPh
VMcm9QjyXiuufyYR7ahAKXoQbLrD76iB97qf2yfgVMrrX/9qkhTavqLGlOAHVLTp
rwxYqHroiFhAx1P23+sQVM3v7x9fsfvfdYZnyo356yKIPHUTCv27hZ21bXJbMxZ7
otazCpqHpeFB+/pxc8D1JTP8AnyRPPEfExtAQlWXUBuymaOuzHoMVCA6WUuon/dd
Cwe+DzVcUdbvW6YfgwgINWNIFYFbPME3hAqzlbDOO/oj8ooeheDemvsCyID0vJIG
MrQDSKabmdQqPwuKU8uFmqehZhP7gMcE3Oo1yZ6hFiLwVglI3CFAlfmb7ENakc/z
rVf1i1/EEKClnRNqHo4fsTHD54z6zt7LEqIVaSVARy/7NnLc3NwiOVToNKPMV/FU
TnlumJphcnrruHOoHG51GLxwCvm4BSbgGUtJsOGn+ZMVu6shiUxQ4CyM1JQNidBR
wXqAmFZSbss=
=ZXc7
-----END PGP SIGNATURE-----

--E69HUUNAyIJqGpVn--
