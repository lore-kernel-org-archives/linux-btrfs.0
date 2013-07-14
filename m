Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51371 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3GNSNt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jul 2013 14:13:49 -0400
Date: Sun, 14 Jul 2013 19:13:46 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: super block crcs don't match, older mkfs detected
Message-ID: <20130714181346.GE29644@carfax.org.uk>
References: <E2D2617A-BB44-4850-A071-407237F84ACA@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="maH1Gajj2nflutpK"
In-Reply-To: <E2D2617A-BB44-4850-A071-407237F84ACA@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--maH1Gajj2nflutpK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 14, 2013 at 12:11:04PM -0600, Chris Murphy wrote:
> On Fedora 19 with all updates, when I mkfs.btrfs and then mount the volume, I'm getting this in dmesg:
> 
> [  280.534868] Btrfs loaded
> [  280.581799] device fsid 94ed05cb-89a9-4d6b-a1e2-5312687b59f5 devid 1 transid 4 /dev/mapper/vg1-brick1
> [  280.590140] btrfs: super block crcs don't match, older mkfs detected
> [  280.597746] btrfs: disk space caching is enabled
> [  280.661204] SELinux: initialized (dev dm-4, type btrfs), uses xattr
> 
> btrfs-progs-0.20.rc1.20130308git704a08c-1.fc19.x86_64
> kernel-3.10.0-1.fc20.x86_64
> 
> Is this expected? Benign?

   Yes, I believe it's harmless and will go away after the first
mount.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I gave up smoking, drinking and sex once. It was the scariest ---  
                         20 minutes of my life.                          

--maH1Gajj2nflutpK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUeLqWlheFHXiqx3kAQISSg/+PcvajP9vAsdlj2CxKDYe/k+yCCThb6G+
qlLlTRp84bCpgXfmJMKq4SY/QDMXqzn13ZqHsxhxex5PcFFZAqWLxSd0vStnxOh0
DQqZPuv2oB5HqdqBX2NxB6uY9d6/LJ+0czdp8lCfsePZ02DU16FB+LmK3GGuydGB
mIqOenV3Z6HhcDU/v3Gbey2xiJEc2oBkQhKGVsXrgi57xCPLpl+SryhwLXa0kuv7
ygzh+E8TCisYfxEnotr3SNeHAXVXjiu48Pl8Rl2IZZW5k+grkl89sNY16zECw8vP
RexvoHWgXBKyQRO9hFiNO/9/7xRHVxun4ve2/4EpYnZYttQMPoABvtxvFwB4DNOP
e5MTxVpvlNNfnO3Fiu6HCmB9rk3n4bljjudFqlc9+smnmZqhR3jHxiiKfme2iQGq
ONk7sprJ451aYdinHKT1eNh8bhgbfOyGNmW0MERrV/hV2ki49ni1r5pCOS/461bX
IHLRTAbhSGvj5ZtHnUEERF6FngCBKEK91TmhZmroOSPXAHCrX4LbKtYEGrKgj1XK
GokSXmeenkiqnLoBWKroO7wEDDSUJHnTi5NuoIjU5j1OszgbIwpN+kB87KnBbLxJ
nmFjkzerpzT0WzvGlP0Nit3PHmqmy1RId6wz4AKtfKbX1BXuzvpf/bgaYErIiHjl
KozlQGyNQ7w=
=pF+f
-----END PGP SIGNATURE-----

--maH1Gajj2nflutpK--
