Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42081 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbbL1CBp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 21:01:45 -0500
Date: Mon, 28 Dec 2015 02:01:43 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: james harvey <jamespharvey20@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: corrupt lead, bad key order & no csum found for inode & csum
 failed ino & input/output error
Message-ID: <20151228020143.GN1586@carfax.org.uk>
References: <CA+X5Wn43URhRg12G48bCPEaZeohA1z_q4Yu5T6CosWfBL9Ui1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRo3kt64Wi40AlcO"
In-Reply-To: <CA+X5Wn43URhRg12G48bCPEaZeohA1z_q4Yu5T6CosWfBL9Ui1Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--QRo3kt64Wi40AlcO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 27, 2015 at 08:03:16PM -0500, james harvey wrote:
> Have gotten about 300 (mostly duplicate) BTRFS errors in the last
> hours.  No signs of disk problem.  Non-SSD SATA.  Was able to dd the
> drive into an image file on another drive without errors.  Smartctl
> reports no issues.  It is a single disk though.
> 
> Been running btrfs fine since 7/9/15, installing arch linux with linux
> 4.0.7-2 and btrfs-progs 4.1-1.
> 
> Now running linux 4.2.5-1 (installed 10/27, 4.3 isn't in arch core
> repo yet) and btrfs-progs 4.3.1-2 (installed 11/24.)
> 
> corrupt leaf, bad key order

   You have bad RAM. You need to run a memtest, find the bad hardware,
and replace it.

   After that, btrfs check may be able to fix this -- there was
certainly a patch to do so, and I think David was going to apply it.
Not sure where that's got to, though.

   Hugo.

> ====================
> 
> 219 of these lines.  All duplicates.
> 
> [ 836.639911] BTRFS critical (device sda2): corrupt leaf, bad key
> order: block=241468833792,root=1, slot=292
> 
> no csum found / csum failed
> =====================
> 
> After two of those corrupt lead criticals, have gotten 82 of these
> lines.  More of the corrupt leaf criticals between these.  Mostly
> duplicates, 5 unique inodes given.  All of these files happen to be
> .cache/chromium/Default/Cache/data_* files and
> .local/share/baloo/index, which makes sense because that's mostly what
> this machine is used for.
> 
> [ 836.640132] BTRFS info (device sda2): no csum found for inode
> 1809716 start 8011776
> [ 836.644547] BTRFS warning (device sda2): csum failed ino 1809716 off
> 8011776 csum 571345089 expected csum 0
> 
> Input/output error
> =============
> 
> Started to run a "btrfs scrub start -B -r /dev/sda2" (didn't see the
> messages above on the list recently, so wasn't going to write changes
> until I had made a dd disk image on another drive.  Got:
> 
> ERROR: scrubbing /dev/sda2 failed for device id 1: ret=-1, errno=5
> (Input/output error)
> scrub canceled for 535e3d41-989e-4c14-a837-536d79e4ff51
> scrub started at Sun Dec 27 18:33:31 2015 and was aborted after 00:18:22
> total bytes scrubbed: 156.31GiB with 0 errors
> 
> dmesg doesn't show any entries saying something like input/output
> error, just the corrupt leaf bad key order, no csum found csum failed
> errors.
> 
> sda2 is what I'm booted off of, and I'm still running the system
> without rebooting, typing this email on it, so the drive didn't stop
> being usable after btrfs scrub reported an Input/output error, and
> isn't giving more issues besides the above errors.
> 
> 
> Obviously looking for comments on all of this, but most interested in
> if the corrupt leaf, bad key order message risks a bunch of files or
> not.  Familiar with leafs as a computing term, but don't even know
> what they are in the context of btrfs.  If it's a single file, how do
> I use the corrupt leaf, bad key order block number to see what it
> corresponds to, like I did with btrfs inspect-internal with the
> inodes?

-- 
Hugo Mills             | Talking about music is like dancing about
hugo@... carfax.org.uk | architecture
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                           Frank Zappa

--QRo3kt64Wi40AlcO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWgJgHAAoJEFheFHXiqx3kbwIP/1i+T1U8EvVsMXNdjYGiJv7f
SdiswD9ifdtej0Qeq256ZGThEOQsUCN7Nf1b8kryXRADqPDroGfQszk/Ertn0+3i
l+IWc9kLPb5xWxuNsaNkrYLiL1/kFcwX0B+zwle5ip1oOn1dmdUWNyhj2HD5/Zn4
cZxrR6bwokLDjtKgjLLgqNH+C61y1feW0F43TB500hEr4AkXzZbBBmZKJhE1K/Yd
pez8YnC4LXoILuab/6qatnYVIBr6I2mDZz2OSzcPqzJzVLI5Lddp0fIcpfv/Yg78
1mXW3ncWQNoAwTTIsPhnphUuHHAB8z3XdAWxAlhSRt6KoNCXZ3Fy7x+zT9F5bVAw
EssroChxLhCvVKHxN/+lH3KxYX8CmphJ6pRc8rxUQCtUt/ZOoPmjUfIQqioL52H0
U7HIG5TaDBe7HoMoNdzcVtvMvCu06gThl5NG2IuTrA2ut/1Msa5lIhndA+EnFoBy
LftSsdPHH3wFFFXyGzthUCPv7RUHK/RxzdIQ72shTpFygpn4uZLgAbjsBSa2Tsxd
XZ815auPkAZghFm1dyYkT+B7YJ4xFGM69BiWIzRwrVxYBSxZUOdg91NEvvGh2k59
ChXfLrFfgVc0MPJJVHHjHhYDRIHDmFIWRzyUa2rxV5D6ryfaX6u01XyVjJY4gdxm
wRmpNt4SLw5TJNVOoBLC
=8TYV
-----END PGP SIGNATURE-----

--QRo3kt64Wi40AlcO--
