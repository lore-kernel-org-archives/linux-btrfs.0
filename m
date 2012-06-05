Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33592 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab2FEQAY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 12:00:24 -0400
Date: Tue, 5 Jun 2012 17:00:19 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Jim <jim@webstarts.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: delete disk proceedure
Message-ID: <20120605160019.GI15986@carfax.org.uk>
References: <4FCE19D3.4090908@webstarts.com>
 <20120605154737.GH15986@carfax.org.uk>
 <4FCE2B70.9020107@webstarts.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q59ABw34pTSIagmi"
In-Reply-To: <4FCE2B70.9020107@webstarts.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Q59ABw34pTSIagmi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[Please keep replies on the list]

On Tue, Jun 05, 2012 at 11:53:20AM -0400, Jim wrote:
> Thanks for the response.  When I say mounts don't work I mean that
> when I try to mount an exported directory on an older os (most of my
> machines are centos 5.7) with a non btrfs kernel I get an "unknown
> filesystem" error.  If we can get around this I would be very happy.

   On my NFS exports, I found that I have to set the fsid to something
unique for each subvolume I export. In my case, this prevents all of
the exported filesystems being the same, but it might also help with
your problem.

/media/video			  *(ro,async,fsid=0x13570,no_subtree_check)

   Hugo.

> 
> On 06/05/2012 11:47 AM, Hugo Mills wrote:
> >On Tue, Jun 05, 2012 at 10:38:11AM -0400, Jim wrote:
> >>Good morning btrfs list,
> >>I had written about 2 weeks ago about using extra btrfs space in an
> >>nfs file system setup.  Nfs seems to export the files but the mounts
> >>don't work on older machines without btrfs kernels.
> >    "The mounts don't work" -- can you be more specific here?
> >
> >    It would seem that if we can get to the bottom of that problem, you
> >won't have to muck around with your current set-up at all.
> >
> >    Hugo.
> >
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I am an opera lover from planet Zog.  Take me to your lieder. ---  

--Q59ABw34pTSIagmi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFPzi0TIKyzvlFcI40RAiBLAJ9nC04lyQYCwn5VMqeF7KzNLvD8hQCgv0VR
++uMFeehs+VHY0fIjSFcmHg=
=aYuZ
-----END PGP SIGNATURE-----

--Q59ABw34pTSIagmi--
