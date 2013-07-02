Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55340 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab3GBRsH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jul 2013 13:48:07 -0400
Date: Tue, 2 Jul 2013 18:48:00 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Peter Chant <pete@petezilla.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Hardware failure or btrfs issue?
Message-ID: <20130702174759.GB804@carfax.org.uk>
References: <51D2091E.9010800@petezilla.co.uk>
 <20130702072915.GA8170@carfax.org.uk>
 <51D30FB0.5000304@petezilla.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
In-Reply-To: <51D30FB0.5000304@petezilla.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 02, 2013 at 06:36:48PM +0100, Peter Chant wrote:
> On 07/02/2013 08:29 AM, Hugo Mills wrote:
> >This is usually an indication that you have bad hardware -- I'd
> >suggest testing RAM, PSU, CPU in that order. I'm not sure what, if
> >anything, can be done to fix the error on the disk right now.
> 
> Thanks, appreciated.
> 
> Hmm.  I've got one stick of ram out of the machine due to testing as
> I had some freezes last week.

   So the damage probably happened then, if that stick is bad.
Filesystems have this irritating habit of remembering things done to
them across reboots. :)

   Hugo.

> If it were one of the RAM, PSU and CPU then I'm unsure why this IO
> issue only surfaces on the HDD and not the SSD.  I ordered a new HDD
> last night, before reading your post.  If its not the disk I'll go
> raid1.  If it is the disk then I'll probally find out.
> 
> >>Not that I've done anything other than a cursory check but it looks
> >>like the read only data is fine.
> >    Might be a good idea to use that to refresh your backups, just in
> >case my prediction about the fixability is correct.
> 
> Well, first option is to drop in the new disk, freshly format it and
> copy the data across (not add it as a second disk).  If that fails
> last backup was wednesday.  I've not done much of note since then
> apart from try to fix the disk issues.
> 
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- The glass is neither half-full nor half-empty; it is twice as ---  
                        large as it needs to be.                         

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUdMST1heFHXiqx3kAQIRCQ/+JU8am4oRzgFTc1C08N+3g3uTvSDW+yZV
poKuRlHKdqEueFKZPPexF3kQtS50UylDNclOMzy5oehr0l48Pa0h0fLxO68Dj33K
Ggwd9SzHdz7nrTyvU7aVDvyO5T+KzfIhvzAj//dXSncFPAcj6fpbrdgcf4VVhoXH
R3Nky7/HzSQ4jaaYMDCRHhKumE3S1JBdEoaJIT0feFkyOHYQizhTcW6fGWyJ1S0H
GYsBpvpWFf9yHYCQhNV0yKZE9eBJicD9RtfHMsJj0UdBNVvsSBYrfClT7ppZSEQE
M9uTSyT2QclcEzyEMVGAv35/DXNEBng37f46TDfAskACsmEETPtEARQNe7NFwZWs
flCpMGCMwPlV8oXafit0pIOGqqN8YlxNAbaF56fqSWQjDG8JAkvt0CDXDnefwpJf
lKkPTshFUV63NiWV/E4s18tIyGX1MKcBIIQg8gIuYlRYj/mFwmw6HLStLSTCYfTm
ai6e4QBE7V0oqh1woAYNaV6wZOWvzpivxMz2sTbsvEfj+K5DwUgJlWnEHVgBge+y
45uknjxf+vrWeLOtwPA/nCTHYMHkhkDAR0RBCWCibCc6kVstNnm+Wka0ZY/Pivzj
qxpZ6Cz+PouI3Stxi3QHiT1JL1FFlL3HiVAxOAY02AAD5MB24kwnwJ/qAuVDuPAZ
qfHPJKrlUBE=
=xdU+
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
