Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39912 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2H3ShL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Aug 2012 14:37:11 -0400
Date: Thu, 30 Aug 2012 19:37:06 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: kreijack@inwind.it
Cc: M G Berberich <btrfs@oss.m-berberich.de>, linux-btrfs@vger.kernel.org,
        Hubert Kario <kario@wit.edu.pl>
Subject: Re: =?utf-8?B?4oCcQnVn4oCdLXJlcG9ydA==?= =?utf-8?Q?=3A?=
 inconsistency kernel <-> tools
Message-ID: <20120830183706.GB21990@carfax.org.uk>
References: <20120828195244.GA15021@invalid>
 <503FAFF5.80204@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
In-Reply-To: <503FAFF5.80204@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 30, 2012 at 08:24:53PM +0200, Goffredo Baroncelli wrote:
> On 08/28/2012 09:52 PM, M G Berberich wrote:
> >(7) reinserted disk (and rebooted)
> >     At some point before reboot the first 10 sectors of one disk
> >     were zeroed to test if the disk gets removed from the btrfs.
> 
> IIRC the superblock is not placed at the beginning of the disk. On
> the basis of [1] it should be near the 64KB (around the sector #128)

   Just for the record, the first is at 64KiB; each subsequent one is
shifted 12 bits left (256MiB, 1TiB, 4EiB, 16ZiB, 64YiB).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- This chap Anon is writing some perfectly lovely stuff ---      
                             at the moment.                              

--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQP7LSIKyzvlFcI40RAonmAJ9K3B2s/HIMq/6ii97acudHgzF2HwCgly2h
d3oXWBE0AY0JvuAsMMBvyAM=
=v6P5
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
