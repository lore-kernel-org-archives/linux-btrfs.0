From: Michal Hrusecky <mhrusecky@suse.cz>
Subject: Segfault when transid verify fails
Date: Fri, 4 Dec 2009 13:28:03 +0100
Message-ID: <20091204122802.GA1644@misibook.miska.isageek.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I'm trying to use btrfs on my other Linux installation as a root
filesystem. Somehow I cannot boot any longer and I've got dmesg full of
repeating error lines. So I booted up my other Linux system and tried to
run btrfsck, but it segfaults after producing similar error message:

# btrfsck /dev/disk/by-label/suse
parent transid verify failed on 67510272 wanted 352 found 394
Segmentation fault

I tried both btrfs-progs 0.19 and current git of btrfs-progs. I'm
running 2.6.32 vanilla kernel. I can provide strace and probably try to
obtain some backtrace, but I guess as I cannot boot system with this
rootfs that the error will be somewhere deeper...

Best Regards,
	Michal HRUSECKY

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAksZAFIACgkQJkqfF/7WVvZDmgCdFJWBsBUmDKcCu0rpvH3e4IOu
1pkAnjJUp+Dx9fV+rVKpzhqTkVIw2Wsu
=t+a5
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
