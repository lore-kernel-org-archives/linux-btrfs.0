Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47048 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab2GITZF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2012 15:25:05 -0400
Date: Mon, 9 Jul 2012 20:25:00 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Jan Engelhardt <jengelh@inai.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs fi df won't show total=
Message-ID: <20120709192500.GG28701@carfax.org.uk>
References: <alpine.LNX.2.01.1207092111360.16359@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I3tAPq1Rm2pUxvsp"
In-Reply-To: <alpine.LNX.2.01.1207092111360.16359@frira.zrqbmnf.qr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--I3tAPq1Rm2pUxvsp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 09, 2012 at 09:14:03PM +0200, Jan Engelhardt wrote:
> 
> On openSUSE_12.1 with Btrfs v0.19+20120406, the following can be
> observed: after a change of the profiles, total=,used= is no
> longer shown:
> 
> 
> 20:49 mmsrv1:~ # btrfs fi df /top.srv/
> Data, RAID10: total=152.00GiB, used=121.07GiB
> System, RAID1: total=40.00MiB, used=44.00KiB
> System: total=4.00MiB, used=0.00
> Metadata, RAID1: total=112.00GiB, used=1.30GiB
> Metadata: total=8.00MiB, used=0.00
> 20:50 mmsrv1:~ # btrfs fi bal start -mconvert=raid10 -sconvert=raid10 
> /top.srv/
> Refusing to explicitly operate on system chunks.
> Pass --force if you really want to do that.
> 20:52 mmsrv1:~ # btrfs fi bal start -mconvert=raid10 -sconvert=raid10 
> --force /top.srv/
> ...
> 21:10 mmsrv1:~ # btrfs fi df /top.srv/
> Data, RAID10: total=156.00GiB, used=124.35GiB
> System, RAID10: total=128.00MiB, used=48.00KiB
> System: total=4.00MiB, used=0.00
> Metadata, RAID10: total=112.00GiB, used=1.38GiB

   What's the problem here? You no longer have any RAID1 chunks, so
it's not showing them.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- IMPROVE YOUR ORGANISMS!!  -- Subject line of spam email ---     

--I3tAPq1Rm2pUxvsp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFP+zAMIKyzvlFcI40RAl3tAJ4yZSzc9eIKzMNE5rQ3o90RlX7UMwCff4v9
6PEp6zLS/egSHY1dFYviu6k=
=1EnK
-----END PGP SIGNATURE-----

--I3tAPq1Rm2pUxvsp--
