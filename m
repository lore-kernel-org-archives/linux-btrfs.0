Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37548 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab3BNI7d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 03:59:33 -0500
Date: Thu, 14 Feb 2013 08:59:25 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Fredrik Tolf <fredrik@dolda2000.com>, linux-btrfs@vger.kernel.org
Subject: Re: Rebalancing RAID1
Message-ID: <20130214085925.GD28997@carfax.org.uk>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com>
 <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com>
 <alpine.DEB.2.02.1302130711400.8810@shack.dolda2000.com>
 <5EEA9264-5DCA-4A3F-B305-F3E64E9A3CC5@colorremedies.com>
 <alpine.DEB.2.02.1302140733070.8810@shack.dolda2000.com>
 <17E4F30E-2945-44FE-A87F-0F475DFD794F@colorremedies.com>
 <alpine.DEB.2.02.1302140830310.8810@shack.dolda2000.com>
 <2D5AAB44-9DA8-460D-9141-3544DE6C45D7@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
In-Reply-To: <2D5AAB44-9DA8-460D-9141-3544DE6C45D7@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 01:41:04AM -0700, Chris Murphy wrote:
> 
> On Feb 14, 2013, at 12:58 AM, Fredrik Tolf <fredrik@dolda2000.com> wrote:
> > 
> > Feb 14 08:32:30 nerv kernel: [180511.760850] lost page write due to I/O error on /dev/sdd1
> 
> Well, someone else might comment on what that is exactly, I'm not getting conclusive google hits on this. Sometimes it's fixed by going to a newer kernel. Sometimes it's bad hardware. But it's apparently not a btrfs error. But it's causing subsequent errors which are btrfs errors. So whatever it is, it seems like btrfs doesn't like it.
> 
> 
> > Feb 14 08:32:30 nerv kernel: [180511.764690] btrfs: bdev /dev/sdd1 errs: wr 288650, rd 26, flush 1, corrupt 0, gen 0
> 
> So there continue to be write errors. Unsurprising as sdd1 seems to be dropping pages.
> 
> >> 
> >> Scrubbing does not balance the volume. Based on the information you supplied I don't really see the reason for a rebalance.
> > 
> > Maybe my terminology is wrong again, then, because I do see a reason to get the data properly replicated across the drives, which it doesn't seem to be now. That's what I meant by "rebalancing".
> 
> How much data was copied to the drives? I'm continuously confused by how btrfs reports data usage. What I have is this from fi show and fi df:
> 
> Data, RAID1: total=2.66TB, used=2.66TB

   This is the amount of actual useful data (i.e. what you see with du
or ls -l). Double this (because it's RAID-1) to get the number of
bytes or raw storage used.

> Total devices 2 FS bytes used 1.64TB
> devid    1 size 2.73TB used 1.64TB path /dev/sdi1
> devid    2 size 2.73TB used 2.67TB path /dev/sde1

   This is the amount of raw disk space allocated. The total of used
here should add up to twice the "total" values above (for
Data+Metadata+System).

> So I can't tell if it's ~1.64TB copied or 2.6TB.

   Looks like /dev/sdi1 isn't actually being written to -- it should
be the same allocation as /dev/sde1.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Alert status "mauve ocelot": Slight chance of brimstone. Be ---   
                   prepared to make a nice cup of tea.                   

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBURynbb9z9OVl50rAAQIH7g//XxBv3wSxeqyYIp1WQgrpGZAEYScFxxBv
w3LJYgL83KAziKNRazd3Frce1qKeN+zrHCEnJwGWAgAxXhJMYUjteK26QrWu1Cqy
taLV5+dgwgOVMtRjuNflzD30nOhXsmD/oSzzCRmV8tL97OH85s2k/N3XYUsqymWu
NClxu23jWVQYa6p4TYTQuvydxnu/8rMu8PEJRsxS7P2UsbMCsNn9+9f/pm74LGNb
1iHM+EOpBHUx3Om3LCYaSRQ8A+p65E2g9gLoWKcaxh0ghnyOnQt90HaFPWPrQ/r/
dgeXZaXNPvxnXPsReJPg8o7wWmtfmQWNL+RxttJAF7dNJ+S9Wo4NDcRblVvUl++v
dkVsWy8nCXcgLkOZ7rIkPHFUftGUlaoi4FxYVc4SKFxRqriKcERu4ByypmLR79/I
YdRYxb/bkcBLx47wJHBiH+2YTO2RmBzfXDcJHQHMSDjaJ7/74eoZMHlXnXRwWgeZ
FJOBPX4LZkxsLGIwWlJupebJGMeG/JhBgp1i5DHzhixgLrBYQaDq2CrxF97VCTyk
amxDG0kLm8E+pacaqTDyGlH3qSJCGwyQA2uNWSPQCRuxCrIeFofsbfYgogBg40rd
mRCiZmGO2jzq/rr7bDg+tengRDwhK+R2sB58zCGmXJ0v7c+4oyd76IGI9It+EBZU
jSXgVSNwof8=
=WNXO
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--
