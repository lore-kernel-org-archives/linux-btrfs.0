Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41693 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab2FTIVk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 04:21:40 -0400
Date: Wed, 20 Jun 2012 09:21:36 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Calvin Walton <calvin.walton@kepstin.ca>, linux-btrfs@vger.kernel.org
Subject: Re: Subvolumes and /proc/self/mountinfo
Message-ID: <20120620082136.GA25572@carfax.org.uk>
References: <4FDFCA43.2070407@zytor.com>
 <1340115766.3403.19.camel@cwalton-XPS-8300>
 <4FE10CDF.5050102@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
In-Reply-To: <4FE10CDF.5050102@zytor.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 19, 2012 at 04:35:59PM -0700, H. Peter Anvin wrote:
> On 06/19/2012 07:22 AM, Calvin Walton wrote:
> > 
> > All subvolumes are accessible from the volume mounted when you use -o
> > subvolid=0. (Note that 0 is not the real ID of the root volume, it's
> > just a shortcut for mounting it.)
> > 
> 
> Could you clarify this bit?  Specifically, what is the real ID of the
> root volume, then?
> 
> I found that after having set the default subvolume to something other
> than the root, and then mounting it without the -o subvol= option, then
> the subvolume name does *not* show in /proc/self/mountinfo; the same
> happens if a subvolume is mounted by -o subvolid= rather than -o subvol=.
> 
> Is this a bug?  This would seem to give the worst of both worlds in
> terms of actually knowing what the underlying filesystem path would end
> up looking like.

   Yes, it's a bug, and rather an irritating one at that. I know that
David Sterba looked at fixing it, but apparently it was trickier to
fix than was expected. (I don't recall the reason, and probably
wouldn't have understood it anyway, so I'll leave it to Dave to tell
you about it in detail).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- Doughnut furs ache me, Omar Dorlin. ---               

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFP4YgQIKyzvlFcI40RAn/NAJ9FfdedeA/XWoCtN2A362VmIauyxgCgjlAh
dGyaI6eTfll4ZQ1BTwtMs0Y=
=HMYw
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
