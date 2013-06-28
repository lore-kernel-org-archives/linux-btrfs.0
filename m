Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58662 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab3F1PjR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Jun 2013 11:39:17 -0400
Date: Fri, 28 Jun 2013 16:39:10 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Martin <m_btrfs@ml1.co.uk>, linux-btrfs@vger.kernel.org
Subject: Re: raid1 inefficient unbalanced filesystem reads
Message-ID: <20130628153910.GM14601@carfax.org.uk>
References: <kqk4sc$t5d$1@ger.gmane.org>
 <20130628153418.GW4288@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dp9QYJgVRVEW2bsm"
In-Reply-To: <20130628153418.GW4288@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--dp9QYJgVRVEW2bsm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 28, 2013 at 11:34:18AM -0400, Josef Bacik wrote:
> On Fri, Jun 28, 2013 at 02:59:45PM +0100, Martin wrote:
> > On kernel 3.8.13:
> > 
> > Using two equal performance SATAII HDDs, formatted for btrfs raid1 for
> > both data and metadata and:
> > 
> > The second disk appears to suffer about x8 the read activity of the
> > first disk. This causes the second disk to quickly get maxed out whilst
> > the first disk remains almost idle.
> > 
> > Total writes to the two disks is equal.
> > 
> > This is noticeable for example when running "emerge --sync" or running
> > compiles on Gentoo.
> > 
> > 
> > Is this a known feature/problem or worth looking/checking further?
> 
> So we balance based on pids, so if you have one process that's doing a lot of
> work it will tend to be stuck on one disk, which is why you are seeing that kind
> of imbalance.  Thanks,

   The other scenario is if the sequence of processes executed to do
each compilation step happens to be an even number, then the
heavy-duty file-reading parts will always hit the same parity of PID
number. If each tool has, say, a small wrapper around it, then the
wrappers will all run as (say) odd PIDs, and the tools themselves will
run as even pids...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- Startle, startle, little twink.  How I wonder what you think. ---  

--dp9QYJgVRVEW2bsm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUc2uHlheFHXiqx3kAQLHGhAAtldrM1rgi/6H5RNFkrt0GFY1/DI0uQEH
I5mGmiXsiTUFWCU7DmKz8pLM4sy2qCD+xlAc+5jrio0pU6w9pDXJ300mTxNuhVSA
NNtb/srsgG+162CeGa1xCHZ/Kpel1LcXcCh9cbs6/jVJPgVIIGoPBq8aEb8epVYl
rKGrsD225kh5C5Z3rCGKGbZdvmNsWxBXwvfHjibNVOMaFMgaQ3dFTgFwFUvhGiP7
FGF+AJaOTu5l3LYKJ2AHbpZoyow1X5Gs46qbFZoxKnvB3w3Vj2BRzu5nAclp8TwK
u1Z5Guvsoi58eHvonmcmTGkAAWlOGR019UICZPIEQ8f58ac/KHVWuGqxfkNPvwW4
3qayutmLQLfOv59Qtap+S67X66/Pj8lm8UBPcYpqSo66tQ6IictaJ0Sm+x7zXWgw
x/R2Sf85ZLhzJpBWVg6aB4wXtxFFF7IVCwzRsWlL8h3hXOkXRPULFeEEzs+TweUy
i7Uj9o+4DKgTVfwjK2vbHUh62xyj6m1U+acEC0D2yIeYSJSTeOjyxr0KeyKyFX/C
COZYotS4ieer99Vbj8tNJTgMjZ/aWdc5RTPAUKO0UVCJFOlmTT9mSpfjXd1q5bHP
mNMnJmAYmLjpm9R51UHS0S1Zqi0j2pdk70V+AFcQUvQnbwWzk+EEN4q5UBd15bdT
tIUPjvKy+y8=
=Bw1X
-----END PGP SIGNATURE-----

--dp9QYJgVRVEW2bsm--
