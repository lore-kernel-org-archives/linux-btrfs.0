Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36149 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab3FBRoE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Jun 2013 13:44:04 -0400
Date: Sun, 2 Jun 2013 18:43:59 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Tim Eggleston <lists@timeggleston.co.uk>, linux-btrfs@vger.kernel.org
Subject: Re: RAID10 total capacity incorrect
Message-ID: <20130602174359.GI20133@carfax.org.uk>
References: <7b97469e82e675814317efef48cc3d71@mail.39.gs>
 <099CD4A1-A70D-4446-8C55-843D21BE4E7F@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9iyR+p8Z2cn535Lj"
In-Reply-To: <099CD4A1-A70D-4446-8C55-843D21BE4E7F@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--9iyR+p8Z2cn535Lj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 02, 2013 at 12:52:40PM -0400, Chris Murphy wrote:
> 
> On Jun 2, 2013, at 12:17 PM, Tim Eggleston <lists@timeggleston.co.uk> wrote:
> > 
> > root@mckinley:/# btrfs fi df /mnt/shares/btrfsvol0
> > Data, RAID10: total=2.06TB, used=2.06TB
> > System, RAID10: total=64.00MB, used=188.00KB
> > System: total=4.00MB, used=0.00
> > Metadata, RAID10: total=3.00GB, used=2.29GB
> > 
> > 
> > Am I being an idiot and missing something here? 

> No, it's confusing. btrfs fi df doesn't show free space. The first
> value is what space the fs has allocated for the data usage type,
> and the 2nd value is how much of that allocation is actually being
> used. I personally think the allocated value is useless for mortal
> users. I'd rather have some idea of what free space I have left, and
> the regular df command presents this in an annoying way also because
> it shows the total volume size, not accounting for the double
> consumption of raid1. So no matter how you slice it, it's confusing.

   It's the nature of the beast, unfortunately. So far, nobody's
managed to come up with a simple method of showing free space and
space usage that isn't going to be misleading somehow.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- If you're not part of the solution, you're part ---         
                           of the precipiate.                            

--9iyR+p8Z2cn535Lj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUauEX1heFHXiqx3kAQI3gQ//YkI05spa3RtZI4xjyuK4DECo2J7fNjzo
8zMKcIo4coSmB/G3Z48cbC06/jqkXCJ9nAuhYSKUNGYvJ0GDfwqZFFI5CNRpNFVP
yCAhCmKLf94QaixODOIz46liEhTukgdIeUHPOa1sV6KkM3kla4Ahnw4cmEgc9p6x
XgRHgEyg6GFuaO54I/LGReiEHZkxyF66zb8fjVVPW7auTbAa2JPeYL09LLWODcC4
PqqXjN8DcVy9COnt7yh721t49SlojfIMRwX/SQ3bE9Qwo82s/LceyOH110oBiLQD
84gkTmM7HtoXEBCSRJ7t1nH2uoJC1LU5y6WXlpBtqwR6SpcULMplVfaEP7VyLd7m
iiURnbiZ/eprOwsEPpb1l9R+GRSh1+HI+b1I/OTFb8FsoZk3kNq1dZaJ8/qj9bXw
jUbZIIWwbQv1m31F3/nwEm7FxSvXTOWUbvEyPTBTvokDo7rRRxoMNuXemJo84Y1V
fhvuEMgnc9i3ZIz3M8In8PHPgd02kiKaX+Zq9CHRU5xJpCDzMIFuGh7GapUglbz0
cqJG3RL6hNVyqf+og+4OJbsEnPzkDcpm3NLJdVNgEVyHPglhi2c8tfJhOnPndv4n
o+btxVUYCtJrAS3GCeUxc+/XRGR+vn6JYizNA4bQ1CP3n4pwe3DGvG36r5MWVDjD
MXNSig9+fKk=
=iMUr
-----END PGP SIGNATURE-----

--9iyR+p8Z2cn535Lj--
