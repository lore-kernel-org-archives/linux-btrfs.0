Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35293 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab3KHTO7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2013 14:14:59 -0500
Date: Fri, 8 Nov 2013 19:14:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: yzb3@wp.pl
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Odp: Btrfs might be gradually slowing the boot process
Message-ID: <20131108191457.GS14405@carfax.org.uk>
References: <527d370819c077.64418711@wp.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Og4V1LL7XI16KR+9"
In-Reply-To: <527d370819c077.64418711@wp.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Og4V1LL7XI16KR+9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 08, 2013 at 08:10:00PM +0100, yzb3@wp.pl wrote:
> Silly me; I am using a fully updated Arch Linux x64 (3.11.6 kernel), I have a single HDD with a root and home subvolume under the main btrfs subvolume and I am not using any "exotic" settings. This is a most regular desktop.

   Can you give exactly the mount options you are using? For a root
filesystem, these are probably in your bootloader configuration rather
than fstab: rootflags=... on your kernel command line.

   Also, just as a confirmation, the same settings from /proc/mounts
once the machine's booted.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- People are too unreliable to be replaced by machines. ---      

--Og4V1LL7XI16KR+9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUn04MVheFHXiqx3kAQJvmhAAgDaEnar7MgnyGJDBI1aBeZ17kmx5p9gs
w5g+XXnv2+l4e5Sg4VcOyfhbIU2oFsT58gVDwZcpArrQ4dmkK65b7cHK7pmESAzo
LtyOWzHPGBaxsYxKc1Ml3behJnn089lKRTfW6BKZCP2o3NEKdCc6IJZd5alEdQpZ
AGh3uSf/ehWKMi1FGKcYRAZUa+sCHv2QxEuQqvr6+AXFDInTrPsZTO5oFLT8d02U
00EzUbGzhXER7u1VHfUVlUe0P3x8sQj0woMPGuXEyFf2+Muxiex1zvXZEGPdWcVg
VYtgwxrsoco4qevuSvBh/ISPqDA2UMcISDZH35SF09DG0m7iBZ9HRvPLpgiLJoTv
BznSqBCn9uDkkqEd3teztJ6EH+7eHgMb2XbYa8wNE7/+WvuiJtMvW0E/3Q1ckOwi
gZC9VX5bRrh/yBnzLNVEFbxpcFzYX5HlAqo4MnoHRBgQXn7KnUKfSr8c7vqt9/Ru
/iY47U/aQ70M2Hf7wneYH/ncz+DMTCGMF5VrWFmVCuJ5jBkZbTWzMdT6UMPcCGQd
DSa+BDOX3msolqMgX16tt/zoRohe7Si7lcYtCfJ0xw8itzgDX8puc0zWFL8pRPVF
IHZBBGSRCMbMNvPf17hGq9UPjXSnuo1shXxPyXN5TQLK5aY5H/KlKqf3Lo0zbXzn
rKnAwg6+0po=
=8xII
-----END PGP SIGNATURE-----

--Og4V1LL7XI16KR+9--
