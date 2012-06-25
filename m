Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34384 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab2FYPCj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 11:02:39 -0400
Date: Mon, 25 Jun 2012 16:02:36 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Knowing how much space is taken by each snapshot?
Message-ID: <20120625150235.GF25572@carfax.org.uk>
References: <20120625145840.GB19337@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8TaQrIeukR7mmbKf"
In-Reply-To: <20120625145840.GB19337@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--8TaQrIeukR7mmbKf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 25, 2012 at 07:58:40AM -0700, Marc MERLIN wrote:
> Howdy,
> 
> My btrfs pool looks like this:
> usr
> usr_daily_20120622_00:01:01
> usr_daily_20120623_00:18:25
> usr_daily_20120624_00:01:01
> usr_daily_20120625_00:01:01
> usr_hourly_20120625_05:00:02
> usr_hourly_20120625_06:00:01
> usr_hourly_20120625_07:00:01
> usr_weekly_20120610_00:02:01
> usr_weekly_20120617_00:02:01
> usr_weekly_20120624_00:02:01
> 
> Sometimes I run low on space and I have to start dropping snapshots. I
> realize that due to COW blocks, it's hard to say exactly how much space each
> snapshot uses, but is there some way to get an idea how much each snapshot
> will free if I delete it?

   When the relevant bit of qgroups lands, yes. Until then, not really.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Python is executable pseudocode; perl ---              
                        is executable line-noise.                        

--8TaQrIeukR7mmbKf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFP6H2LIKyzvlFcI40RAgpVAJ9N7KMcC4rzxdsZljDBLxQl1mIyHwCgn5jC
2Ru6sY4VTClfPsHqAkCV3KQ=
=4QKv
-----END PGP SIGNATURE-----

--8TaQrIeukR7mmbKf--
