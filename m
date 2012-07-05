Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43705 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab2GEUGR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 16:06:17 -0400
Date: Thu, 5 Jul 2012 21:06:14 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs branch updated
Message-ID: <20120705200614.GD28701@carfax.org.uk>
References: <20120705200122.GE7159@shiny>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1sNVjLsmu1MXqwQ/"
In-Reply-To: <20120705200122.GE7159@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1sNVjLsmu1MXqwQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 04:01:22PM -0400, Chris Mason wrote:
> Hi everyone,
> 
> I've updated the master branch with the pending stable btrfs-progs
> commit that should make the 0.20 release.
> 
> Thanks to Hugh for helping to queue up a few of them.  We'll have more
               ^ that's an o, not an h. :)

> frequent releases from here as we pull in the major new features going
> into progs (raid5/6, send/receive, quotas, fsck improvements).

   I've still got a stack of new feature patches sitting here that
mostly apply OK to integration. I'll try to filter out the ones
already applied and put together another stack in approximately
kernel-feature order.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Nothing right in my left brain. Nothing left in ---         
                             my right brain.                             

--1sNVjLsmu1MXqwQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFP9fO2IKyzvlFcI40RApGBAJ0aaZcbwHBNVX9oafaQw12OXjbG1wCfX83O
NwpqDGI9DP/Z+CNDg6VIIDY=
=y2vF
-----END PGP SIGNATURE-----

--1sNVjLsmu1MXqwQ/--
