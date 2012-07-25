Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45801 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932818Ab2GYIgs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 04:36:48 -0400
Date: Wed, 25 Jul 2012 09:36:44 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Marios Titas <redneb8888@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: No/bad auto-detection of fs type for small volumes (related to
 mixed metadata/data?)
Message-ID: <20120725083644.GC30007@carfax.org.uk>
References: <CAAdM644Xs1Vq-Sw4ZacGz_gBrURHzEhhs4drXJC+dMtP0DhSiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z4+8/lEcDcG5Ke9S"
In-Reply-To: <CAAdM644Xs1Vq-Sw4ZacGz_gBrURHzEhhs4drXJC+dMtP0DhSiw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 24, 2012 at 08:39:36PM -0400, Marios Titas wrote:
> When I create a btrfs volume of size strictly less than 256 MiB then if I do
>     mount /dev/sdb1 /mnt/test
> the kernel tries unsuccessfully to do the mount with many other file systems
> before successfully trying with btrfs. For volumes of size larger than
> or equal to
> 256 MiB it just mounts the volume without doing that. Why is this discrepancy?

   Are you using the --mixed option when creating the filesystem? If
not, you should do with something that small.

   Hugo.

> Another possibly related symptom is that the volume does not appear in
> /dev/disk/by-label and /dev/disk/by-uuid at all. This means that it is
> impossible
> to mount the volume by uuid or label.
> 
> To make sure that this isn't a udev bug, I booted my system with init=/bin/bash
> in the kernel command line, and then I tried again to mount the
> volume. This time
> it would not mount it at all unless I explicitly specified the fs
> type. On the other
> hand, it could mount larger volumes without any issues.
> 
> All the experiments were done in an initially zeroed out disk. I am
> using 3.4.6 kernel
> with btrfs from 3.5 and the latest btrfs-progs from git.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- In theory, theory and practice are the same. In ---         
                      practice,  they're different.                      

--z4+8/lEcDcG5Ke9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQD7AcIKyzvlFcI40RAtXBAJ9UIg141NnccXKZyYbustrGCUu6LwCgrjAE
3mVWaAqISHXjWUgoupeKj0E=
=ic6G
-----END PGP SIGNATURE-----

--z4+8/lEcDcG5Ke9S--
