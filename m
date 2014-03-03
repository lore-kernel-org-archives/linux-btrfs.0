Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34686 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaCCSjO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Mar 2014 13:39:14 -0500
Date: Mon, 3 Mar 2014 18:39:11 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Mike Russo <mike@PaperSolve.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: ENOSPC errors during raid1 rebalance
Message-ID: <20140303183911.GL13899@carfax.org.uk>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="umrsQkkrw7viUWFs"
In-Reply-To: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--umrsQkkrw7viUWFs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 03, 2014 at 05:23:43PM +0000, Mike Russo wrote:
> Hi guys -
> I'm trying to convert a disk from single (/dev/sdc1) to RAID1 (dev/sdd1), and the filesystem was previously ext4 but the conversion seemed to go just fine, and I have no snapshots. System and metadata convert, and almost all my data converts, but there are 70 stubborn GB (14 blocks of 5GB each) that refuse to convert and I get ENOSPC errors when trying to reallocate them.

   This is just a guess, but you might have some large (>1GB) extents
in there that span across multiple chunks. I'd suggest running a btrfs
defrag on any particularly big files and see if that helps the situation.

   Hugo.

> Here's my vital stats: (on kernel 3.14-rc4):
> 
> root@ossy:/usr/src/btrfs-progs# /usr/src/btrfs-progs/btrfs fi show
> Label: MyBook  uuid: c99cbefb-6a56-41e2-8f99-19f8b5f67884
>         Total devices 2 FS bytes used 1.09TiB
>         devid    1 size 1.82TiB used 1.12TiB path /dev/sdc1
>         devid    2 size 1.82TiB used 1.05TiB path /dev/sdd1
> 
> Btrfs v3.12
> root@ossy:/usr/src/btrfs-progs# /usr/src/btrfs-progs/btrfs fi df /mymedia
> Data, RAID1: total=1.04TiB, used=1.03TiB
> Data, single: total=70.00GiB, used=64.98GiB
> System, RAID1: total=32.00MiB, used=160.00KiB
> Metadata, RAID1: total=2.00GiB, used=1.33GiB
> 
> 
> I've already done a -dusage=0 and -dusage=5 balance and that cleans up anything that gets left around when these 14 blocks fail get moved.    When mounting with enospc_debug I get messages like this for each block with the problem:
> 
> 
> Mar  3 11:58:16 ossy kernel: [52724.423024] BTRFS: block group 935262683136 has 5368709120 bytes, 5321801728 used 0 pinned 0 reserved [readonly]
> Mar  3 11:58:16 ossy kernel: [52724.423025] BTRFS info (device sdd1): block group has cluster?: no
> Mar  3 11:58:16 ossy kernel: [52724.423026] BTRFS info (device sdd1): 0 blocks of free space at or bigger than bytes is
> Mar  3 11:58:16 ossy kernel: [52724.423027] BTRFS: block group 942778875904 has 5368709120 bytes, 5309296640 used 0 pinned 0 reserved [readonly]
> Mar  3 11:58:16 ossy kernel: [52724.423028] BTRFS info (device sdd1): block group has cluster?: no
> Mar  3 11:58:16 ossy kernel: [52724.423029] BTRFS info (device sdd1): 0 blocks of free space at or bigger than bytes is
> 
> I don't have the space to reformat and if this is a genuine bug I'm sure you guys want to fix it too. What else can I do to resolve or help? 
> 
> 
> Sincerely,
> 
> Michael Russo, Systems Engineer
> PaperSolve, Inc.
> 268 Watchogue Road
> Staten Island, NY 10314
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Nothing wrong with being written in Perl... Some of my best ---   
                      friends are written in Perl.                       

--umrsQkkrw7viUWFs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUxTMT1heFHXiqx3kAQKpnA/+OoVcOLTDjOfvnwLoTIEosNWfMLWAw5ah
rTfPPHnd4LTyKpVyzYsJhngULJxlMQAmfeCu5tneob3zHqT0yj1R9dAg8f/i7BLs
Ejm1WdhZmQuuGyAQms33Z+wjrnVnmkeuzWfnheEzajLayt8ArAmmVee8b7rBaMBV
QUHaM1K7pdS6sppt1M0gwiEetS+RLMZi//lafUe5z8Iuz2MeKtyAnySfXq9LulMX
ltdD4p6XhNzg0aWZiOaZ+urdnjmAZSlew0h0EsGhrOIy2GsjAu5DiLRc0yO65PfX
1xkdVyhRM5ai9jOcXV+nsI0tpk7EWZAgz0+JSFwIiM1xM4pGA6/N+UvDSQFWAA/w
XJXZgsI2dSZRmSpv4hABF1oKwdGaQw8KYg5mZmku19rkW3EefBLnBrqsgdTP6e6/
22p174s2BmzN5N3Z4sMzWGe+BWWO5J3Bc681ZF2IADKkW9Zs74tHtiWOaD+3/evf
u7BXFtticJUbjSLGkl3zDoL2TRRGCgrIAguRB3wQ/+LJsbI8uR5+XJl86ahkKJWV
7gy2bWQyWoGE2ZeLr6N4mRvwS6BAYqw5Dm3fYzem4zsmECSfP8GaERa9sPp5clC2
7C5XXpCmkTCsh/4PF/bPsTeEjTpDpI13/JhPkN1SuM1p3zaP8E/JK5HpqC5fmW1E
VVbDnYPmTwo=
=ohaX
-----END PGP SIGNATURE-----

--umrsQkkrw7viUWFs--
