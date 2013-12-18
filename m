Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38285 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab3LRMqy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 07:46:54 -0500
Date: Wed, 18 Dec 2013 12:46:52 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: no space left, metadata usage almost full?
Message-ID: <20131218124652.GL11281@carfax.org.uk>
References: <20131218213728.07d47dd5@virtall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UK1lfQXsnwKrySH9"
In-Reply-To: <20131218213728.07d47dd5@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--UK1lfQXsnwKrySH9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 18, 2013 at 09:37:28PM +0900, Tomasz Chmielewski wrote:
> I have a btrfs filesystem which has plenty of free space left, yet it's
> hitting out of space regularly.
> 
> Here is how it looks like:
> 
> # btrfs fi df /home
> Data, RAID1: total=2.51TiB, used=1.58TiB
> System, RAID1: total=32.00MiB, used=372.00KiB
> Metadata, RAID1: total=48.00GiB, used=47.23GiB
> 
> 
> What I read from it, is we're almost full on metadata usage, and that
> might be causing out of space issues.

   This is highly likely.

> Reading past posts on this group, I can see it's recommended to run
> this if I hit out of space and the fs is low on metadata space:
> 
> # btrfs fi balance start -dusage=5 /home
> 
> Is it really the only workaround? Shouldn't the filesystem be more
> intelligent and be able to grab some more metadata space if it's
> running low?

   Currently, yes, it is the only approach.

   The automatic reclamation of unused chunks (or barely-used chunks)
is on the projects list. Nobody's got round to implementing it yet.

> I'd appreciate some clarifications on this (FYI, it was running
> 3.11.4, upgraded to the latest rc now).

   Hope the above helps,
   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- If it's December 1941 in Casablanca,  what time is it ---      
                              in New York?                               

--UK1lfQXsnwKrySH9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUrGZPFheFHXiqx3kAQLHFBAAiF4iAoyTxeML9el4i4RPCwEtrlhpLDsG
+l0WP9e8BuVYbvlY1QCl6lbI5uHU01Cro0ja16r9BrMswwJKdSKFAOwqGmOA9PDT
nNpBroAQPmI2zjbb60+LaGbMG2ZXyXTMrjntU0SixzYtWLKeipzOEIutjjMFDl/i
ft9zWOU8ShiHB7My+jC2aXsLNdNNsojNAuDUY0RTqkhU5PmERcKilUwCex+8awpe
5nzn8Dkddi7UwQj+ZBt0z1cap9VoNPxU52lQFiQIfAR2Xgyc9aXgS4tX7xU/vZaB
+okoh4qwj5ZrnA+FvAKM2SDwaM4j/a6GjidqX4k/0j+H8BQiSVBd/KIBBMnlg1qO
GQfVuAcieyhjCwxktVvkwl8ac6+jxjGbslokb2SB/TOiYawIAT6Wczs5tkYv7taQ
f1oBB3FhW9mgxr2aaOeDEytwSvCE4lvzQH8TI1IRltsNpneTULrr0eulZT4ayYHe
+Wnv8Mlk7PsPJfhFjscg7YgoT+5geaGR8yHe98CgqOnOOV9qegOjid7i2fSRBrg7
227xJaZamSnMM4F97GLmCHR4eGnIdYsaSIaZ+H3imlzqRa1kGAgexB+4kt9qvxxE
O7z6MLeT+iJyuN/L/WjmRGeg5UwTMokl25VuIvCjxQpZHVPyDIOAGfJO9e5cDV77
qP2g9j8a9WQ=
=C01T
-----END PGP SIGNATURE-----

--UK1lfQXsnwKrySH9--
