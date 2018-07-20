Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47416 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbeGUACs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 20:02:48 -0400
Date: Fri, 20 Jul 2018 23:12:21 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Alexander Wetzel <alexander.wetzel@web.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs filesystem corruptions with 4.18. git kernels
Message-ID: <20180720231221.GE21293@carfax.org.uk>
References: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gMR3gsNFwZpnI/Ts"
In-Reply-To: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gMR3gsNFwZpnI/Ts
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 20, 2018 at 11:28:42PM +0200, Alexander Wetzel wrote:
> Hello,
> 
> I'm running my normal workstation with git kernels from git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-testing.git
> and just got the second file system corruption in three weeks. I do
> not have issues with stable kernels, and just want to give you a
> heads up that there might be something seriously broken in current
> development kernels.
> 
> The first corruption was with a kernel based on 4.18.0-rc1
> (wt-2018-06-20) and the second one today based on 4.18.0-rc4
> (wt-2018-07-09).
> The first corruption definitely destroyed data, the second one has
> not been looked at all, yet.
> 
> After the reinstall I did run some scrubs, the last working one one
> week ago.
> 
> Of course this could be unrelated to the development kernels or even
> btrfs, but two corruptions within weeks after years without problems
> is very suspect.
> And since btrfs also allowed to read corrupted data (with a stable
> ubuntu kernel, see below for more details) it looks like this is
> indeed an issue in btrfs, correct?
> 
> A btrfs subvolume is used as the rootfs on a "Samsung SSD 850 EVO
> mSATA 1TB" and I'm running Gentoo ~amd64 on a Thinkpad W530. Discard
> is enabled as mount option and there were roughly 5 other
> subvolumes.
> 
> I'm currently backing up the full btrfs partition after the second
> corruption which announced itself with the following log entries:
> 
> [  979.223767] BTRFS critical (device sdc2): corrupt leaf: root=2
> block=1029783552 slot=1, unexpected item end, have 16161 expect
> 16250

   This means that the metadata block matches the checksum in its
header, but is internally inconsistent. This means that the error in
the block was made before the csum was computed -- i.e., it was that
way in RAM. This can happen in a couple of different ways, but the
most likely cause is bad RAM.

   In this case, it's not a single bitflip in the metadata page
itself, so it's more likely to be something writing spurious data on
the page in RAM that was holding this metadata block. This is either a
bug in the kernel, or a hardware problem.

   I would strongly recommend checking your RAM (memtest86 for a
minimum of 8 hours, preferably 24).

> [  979.223808] BTRFS: error (device sdc2) in __btrfs_cow_block:1080:
> errno=-5 IO failure
> [  979.223810] BTRFS info (device sdc2): forced readonly
> [  979.224599] BTRFS warning (device sdc2): Skipping commit of
> aborted transaction.
> [  979.224603] BTRFS: error (device sdc2) in
> cleanup_transaction:1847: errno=-5 IO failure
> 
> I'll restore the system from a backup - and stick to stable kernels
> for now - after that, but if needed I can of course also restore the
> partition backup to another disk for testing.

   It may be a kernel issue, but it's not necessarily in btrfs. It
could be a bug in some other kernel component where it does some
pointer arithmetic wrong, or uses some uninitialised data as a
pointer. My money's is on bad RAM, though (by a small margin).

   Hugo.

-- 
Hugo Mills             | Stick them with the pointy end.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                              Jon Snow

--gMR3gsNFwZpnI/Ts
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJbUmxVAAoJEFheFHXiqx3k8BoP/0MJgCOPGaYgnI6zs6LBftFQ
9zLY8YYfmcpGZ7mmCHXNc+WBRsO/zcoytbFbO+0l4/lx4sjRRZiQpb65THw/l7sl
GSAT2WdKG2g+48JeXhsoWX7DQR+ThLqeMWRDrgkl/phJ87OuX+4DCdgTJ9s49K8b
9eXEzBOScJB0UorjyfhTkOFS52s5j2LCkNbCQtrrZRY/TWOOLorGVIhh2qMoCO7z
vi0l+cNiLi/GcY9uwD1ulKnl4XAePOGzMK4aGhCznagHWmuwARxUT4846x49ShHy
TPWznEDeyWh2GsMOcHjdF0TCRF4sxlP7T3BeKHazDgKwUw8Np2NUQkwxc3Ic0+oC
hss+C+/yoUfFD2Evyh57QoJ5dR6dKx7mRH+0uOBQPmLvOag8LWFfWvLqS5z5uspn
jsJkzLuDVR+un7yH8QvS3ybJRWDL7/X0Lm/gm6vY8CH5KZGpweQyyuihZzo+XuUQ
xW+SogQ0Xru+BK7rghDjPE8iiWHVSRGwnf+uRV2rgk3VsYF++QM/5AOjuxVX5Vm7
SsB55Jro9dStyGq3VpLenxkUMQA/zL97B2Jl4gWMml8Lav268gAM3vTCCfZr08Hz
YKZsftgsuYrJ/pZ9cPA1ALqvbVq8RyziMnIE2KuH/C3gVBlhBF0QXf98o3MuOep2
eG+qKPhv89yz8Xz+J+ZH
=jAc0
-----END PGP SIGNATURE-----

--gMR3gsNFwZpnI/Ts--
