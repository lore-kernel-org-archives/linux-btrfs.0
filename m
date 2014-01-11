Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51290 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaAKPE4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 10:04:56 -0500
Date: Sat, 11 Jan 2014 15:04:54 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: MegaBrutal <megabrutal@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS over LVM remounts read-only
Message-ID: <20140111150454.GV15634@carfax.org.uk>
References: <CAE8gLh=drhPtUXSbT7zHDSh7pipxuZpVhfuRQ7QOFV+HP4wHPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jozmn01XJZjDjM3N"
In-Reply-To: <CAE8gLh=drhPtUXSbT7zHDSh7pipxuZpVhfuRQ7QOFV+HP4wHPQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jozmn01XJZjDjM3N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 11, 2014 at 03:32:26PM +0100, MegaBrutal wrote:
> Hello,
> 
> I'm using BTRFS over LVM and after some time of usage (days or hours),
> it just remounts itself, and I don't see the reason why, while it is
> said to be fault-tolerant.
> 
> It is possible that I have bad sectors on the disk, though I don't
> find it likely. Even then, I don't think bad sectors should cause that
> much of a problem that the FS needs to be remounted because of it. Is
> there a way to make BTRFS to detect and mark bad sectors like any
> other file system does?
> 
> Here are the /etc/fstab entries those concern my BTRFS file system:
> /dev/mapper/vmhost--vg-vmhost--rootfs /               btrfs
> defaults,subvol=@ 0       1
> /dev/mapper/vmhost--vg-vmhost--rootfs /home           btrfs
> defaults,subvol=@home 0       2
> /dev/mapper/vmhost--vg-vmhost--rootfs /media/btrfs    btrfs   noauto
>          0       3
> 
> I've attached a dmesg output that may help developers to see what's the problem.
> 
> Do you have any ideas what causes the problem?

[60631.481913] attempt to access beyond end of device
[60631.481935] dm-1: rw=1073, want=42917896, limit=42917888
[60631.481941] btrfs_dev_stat_print_on_error: 34 callbacks suppressed
[60631.481949] btrfs: bdev /dev/mapper/vmhost--vg-vmhost--rootfs errs: wr 311347, rd 0, flush 0, corrupt 0, gen 0

   This is the problem.

   It looks like you've shrunk the LV without first shrinking the
filesystem. Depending on how much you shrunk it by, the odds are
fairly good that significant chunks of the FS are now toast.

   Hugo.

> Also, if the disaster happens and the FS gets remounted read-only, is
> there a way to force remount it in read-write mode? I've tried "mount
> -o remount,rw" and "mount -o force,remount,rw" too, but it doesn't
> work. Also I can't mount the BTRFS root or any subvolumes elsewhere
> until I restart the system.
> 
> Probably my description of the problem wasn't detailed enough, but
> since I'm totally clueless about the problem (not counting the
> possible bad sectors), I can't tell more right now. But you can ask
> more details and I'll try to answer.
> 
> 
> MegaBrutal



-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Gomez, darling, don't torture yourself.  That's my job. ---     

--jozmn01XJZjDjM3N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUtFdllheFHXiqx3kAQKCPA//ZLhxSUN0zatBOqHYWcY0izkvq55IXBJQ
i/AVJIUKpBg214r9q+83H41tS9XRkv6M7TqD/g2v8bs17ocCz0EctbeltSd75MNx
f3jbfm0N43oEfKozUPk35X4eNmFcdGXZ/v9BvwZJqirCpuIEihUSKgVDRugNYxHe
cJFjJ0GmkUjg6AFmFbwVkc86iscCmKJkU/a7cL8oyW/Aznx0rHpxVJsJYJkA4/5g
jsI/BvoeM/lzVAtKUah6hHlM94VBoqbq1m5cNKZW24RRRYhjllWwRLILusIuScPt
bfnuNlw/7KfjpSUSALgzxtOJ02LgjwzzQ4y8/GLC/HsT/Tf0OqE47tYc1D30pYPY
OVA6cM8+v8ilf1c5kVm/jfsc5WDKRyo0VxDow9f9HOF4ruCT8yX/PWTY9ZoiURPh
vMaqwoNnyKW2EglMhd2gO0rWUdCqnScs5ZR4jtdE9Cg8J/wWOgFTWquZ5hB7z8gb
sGA+sYXKpAD+021UhtH6xu1BkG8ekdEKcoRgiTLD52hOp7fphtUNIYAIxSXe8rJL
JDQMtWSiQWM0GtZDOFmOXAaNCgN9iDxKkLHUZ7ItlDNP1UFutNU394rU4r6Yn0ka
QZYcZTmD4xzLjo7soIHd/LzZBHseo3f7cGWqA9ftBvKDExNSRwIjMljAdPxrFTE5
VUmpqzlVqGA=
=FF+a
-----END PGP SIGNATURE-----

--jozmn01XJZjDjM3N--
