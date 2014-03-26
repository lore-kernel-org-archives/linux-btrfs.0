Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59933 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaCZWvC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Mar 2014 18:51:02 -0400
Date: Wed, 26 Mar 2014 22:50:59 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Johannes Stemmler <jobus@hat-hill.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Inappropriate ioctl
Message-ID: <20140326225059.GI7442@carfax.org.uk>
References: <5333410F.3010000@hat-hill.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k9xkV0rc9XGsukaG"
In-Reply-To: <5333410F.3010000@hat-hill.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--k9xkV0rc9XGsukaG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 26, 2014 at 10:05:19PM +0100, Johannes Stemmler wrote:
> Sorry for reporting this issue to you, but I have not found any helpful
> information elsewhere.
> 
> I have installed a new opensuse-system 12.3 from scratch and selected an
> ext4-fs for /
> and btrfs for /home
> The installation works and the access to the /home btrfs works also.
> 
> But the btrfs-progs doesn't.
> 
> show works
> # btrfs filesystem show /dev/sda8
> Label: lx_home  uuid: 5a6857e3-b421-4a68-92f4-0c7e5f9fcb4c
>         Total devices 1 FS bytes used 74.40GiB
>         devid    1 size 262.63GiB used 77.04GiB path /dev/sda8
> 
> df does not work
> # btrfs filesystem df /dev/sda8

   ^^^ this needs to be a location of the *mounted* filesystem, not a
device. Most of the btrfs functions do this, although not all of them
-- check the man pages, or the online help, which should state either
<device> or <mountpoint>.

   Hugo.

> ERROR: couldn't get space info - Inappropriate ioctl for device
> ERROR: get_df failed Inappropriate ioctl for device
> 
> #mount
> /dev/sda6 on / type ext4 (rw,relatime,data=ordered)
> /dev/sda8 on /home type btrfs (rw,relatime,ssd,space_cache)
> 
> A reinstallation of the btrfs-progs did not help.
> Is the system bad packaged by opensuse or is my constellation forbidden?
> 
> Best regards,
> Johannes Stemmler
> 
> p.s. the btrfs is on a ssd-partition

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Well, you don't get to be a kernel hacker simply by looking ---   
                    good in Speedos. -- Rusty Russell                    

--k9xkV0rc9XGsukaG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUzNZ01heFHXiqx3kAQIXuA/+O+vdYNY0Nv+LpWSRAUvabfhJBBwWRYR0
3+7mdLSlp6HC4CEaCoxYdDRBt1JLfu/p15Et6LPPDoFsfIeKZSp3gcnqEhnc2WEm
lCDHtTT2+9cr+/1Dl6LBiakP0Kxf+/97JfGI+V8V/vkhRW3KL02DMlhBO0h8Zqlq
7Fma2o/2rWUw7pl22r06lbakSJZ6Dba+B1g1jUSozf2/G9SpwEA3+Qa2Pd2y5S4Z
CIBAQ6bJkAgkg6aArCQ7kGQFJbTOiedhIBF9SK+lAbWTcgLM+cJrkYfQBweQ4Rda
qa6EisL0N2DeiZUFeGs0DgDPRrQN4KuL1w0ryW3RGr/ex6PuUfbqgL+ZNQmWx8t8
vMdNlCUkOA3wqKxBQH6aqRCerLN1TA8F8gwG0oihtZjKZBF2MCBljYzRpI6Ei6a6
0YOocqbY4XI4ST47mwb1XXYTGK6bFG4WC4U3PelyUpRl5Yp/zl2K6EqUY4MCrGtQ
PMuNMfe5neW9QHx/vJ6se7Osf5AONojSEPNUYUjMJN3/1WHmeErNoD/wbwe5YC1i
3CsxtmDJUlRexZYM04Sh/8ut97NXwUC88Gr2CIiHQA5ETovxzjKlqlEceW6x/Kul
Gy7p9zJS0UBRAHrr0nGnUrZpepn2NLjwAt3g/4O7MvNpIUkYKW0teiNnRaRHgTU3
rt+T61DHM9g=
=H3bk
-----END PGP SIGNATURE-----

--k9xkV0rc9XGsukaG--
