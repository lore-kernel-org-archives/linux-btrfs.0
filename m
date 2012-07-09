Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56175 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2GIUZc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2012 16:25:32 -0400
Date: Mon, 9 Jul 2012 21:25:30 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Jan Engelhardt <jengelh@inai.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs fi df won't show total=
Message-ID: <20120709202530.GH28701@carfax.org.uk>
References: <alpine.LNX.2.01.1207092111360.16359@frira.zrqbmnf.qr>
 <20120709192500.GG28701@carfax.org.uk>
 <alpine.LNX.2.01.1207092204450.23294@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qVHblb/y9DPlgkHs"
In-Reply-To: <alpine.LNX.2.01.1207092204450.23294@frira.zrqbmnf.qr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qVHblb/y9DPlgkHs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 09, 2012 at 10:06:24PM +0200, Jan Engelhardt wrote:
> 
> On Monday 2012-07-09 21:25, Hugo Mills wrote:
> >On Mon, Jul 09, 2012 at 09:14:03PM +0200, Jan Engelhardt wrote:
> >> 
> >> On openSUSE_12.1 with Btrfs v0.19+20120406, the following can be
> >> observed: after a change of the profiles, total=,used= is no
> >> longer shown:
> >> 
> >> 20:49 mmsrv1:~ # btrfs fi df /top.srv/
> >> Data, RAID10: total=152.00GiB, used=121.07GiB
> >> System, RAID1: total=40.00MiB, used=44.00KiB
> >> System: total=4.00MiB, used=0.00
> >> Metadata, RAID1: total=112.00GiB, used=1.30GiB
> >> Metadata: total=8.00MiB, used=0.00
> >>[...]
> >> 21:10 mmsrv1:~ # btrfs fi df /top.srv/
> >> Data, RAID10: total=156.00GiB, used=124.35GiB
> >> System, RAID10: total=128.00MiB, used=48.00KiB
> >> System: total=4.00MiB, used=0.00
> >> Metadata, RAID10: total=112.00GiB, used=1.38GiB
> >
> >   What's the problem here? You no longer have any RAID1 chunks, so
> >it's not showing them.
> 
> Rather tha a 4-line output, I would have expected this 6-line output
> that I would also get when mkfs'ing a new fresh btrfs volume with
> raid10 from the start:
> 
> Data, RAID10: total=156.00GiB, used=124.35GiB
> Data: total=foo, used=bar
> System, RAID10: total=128.00MiB, used=48.00KiB
> System: total=4.00MiB, used=0.00
> Metadata, RAID10: total=112.00GiB, used=1.38GiB
> Metadata: total=foo, used=bar

   The lines without the RAID marker are there as a result of the way
that mkfs works -- it creates stub chunks which are never used, and
then upgrades to the required RAID level immediately afterwards.

   The balance (any balance, not just a conversion) processes these
chunks as well as all the other chunks in the FS, and rewrites all of
the data in them (all 0 bytes of it) somewhere else, removing the
originals.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Well, you don't get to be a kernel hacker simply by looking ---   
                    good in Speedos. -- Rusty Russell                    

--qVHblb/y9DPlgkHs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFP+z46IKyzvlFcI40RAoojAJ4zI78K9PeEdWhLQMzuVI0CS8SdZQCgmTXV
WpI742nIwfGXpf158Jo3tCE=
=5Une
-----END PGP SIGNATURE-----

--qVHblb/y9DPlgkHs--
