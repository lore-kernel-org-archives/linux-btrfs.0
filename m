Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48919 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751573AbdFIT5U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jun 2017 15:57:20 -0400
Date: Fri, 9 Jun 2017 19:57:18 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Filesystem won't mount (open_ctree failed) or repair (BUG_ON)
Message-ID: <20170609195718.GC30723@carfax.org.uk>
References: <oherub$g5a$1@blaine.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1SQmhf2mF2YjsYvc"
In-Reply-To: <oherub$g5a$1@blaine.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1SQmhf2mF2YjsYvc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 09, 2017 at 09:12:16PM +0200, Koen Kooi wrote:
> Hi,
> 
> Today the kernel got wedged during shutdown (4.11.x tends to do that, haven't
> debugged) and I pressed the reset button. The next boot btrfs won't mount:
> 
> [Fri Jun  9 20:46:07 2017] BTRFS error (device md0): parent transid verify failed on 5840011722752 wanted 170755 found 170832
> [Fri Jun  9 20:46:07 2017] BTRFS error (device md0): parent transid verify failed on 5840011722752 wanted 170755 found 170832
> [Fri Jun  9 20:46:07 2017] BTRFS error (device md0): failed to read block groups: -5
> [Fri Jun  9 20:46:08 2017] BTRFS error (device md0): open_ctree failed

   With a transid failure on mount, about the only thing that's likely
to work is mounting with -o usebackuproot. If that doesn't work, then
a rebuild of the FS is almost certainly needed.

   Hugo.

> I tried repair, but that didn't work either:
> 
> # btrfsck --repair /dev/md0
> enabling repair mode
> couldn't open RDWR because of unsupported option features (3).
> ERROR: cannot open file system
> enabling repair mode
> 
> Googling around it was suggested clearing the v2 space cache:
> 
> # btrfsck --mode=lowmem --clear-space-cache v2 /dev/md0
> parent transid verify failed on 5840011722752 wanted 170755 found 170832
> parent transid verify failed on 5840011722752 wanted 170755 found 170832
> parent transid verify failed on 5840011722752 wanted 170755 found 170832
> parent transid verify failed on 5840011722752 wanted 170755 found 170832
> Ignoring transid failure
> leaf parent key incorrect 5840011722752
> parent transid verify failed on 5367057465344 wanted 170755 found 170828
> parent transid verify failed on 5367057465344 wanted 170755 found 170828
> parent transid verify failed on 5367057465344 wanted 170755 found 170828
> parent transid verify failed on 5367057465344 wanted 170755 found 170828
> Ignoring transid failure
> leaf parent key incorrect 72105984
> btrfs unable to find ref byte nr 4628577484800 parent 0 root 10  owner 0 offset 1
> parent transid verify failed on 5366993256448 wanted 170755 found 170827
> parent transid verify failed on 5366993256448 wanted 170755 found 170827
> parent transid verify failed on 5366993256448 wanted 170755 found 170827
> parent transid verify failed on 5366993256448 wanted 170755 found 170827
> Ignoring transid failure
> leaf parent key incorrect 41287680
> ERROR: failed to clear free space cache v2: -1
> transaction.h:41: btrfs_start_transaction: BUG_ON `root->commit_root` triggered, value 22938400
> btrfs check[0x411674]
> btrfs check(close_ctree_fs_info+0x125)[0x41368c]
> btrfs check(cmd_check+0x36d8)[0x45e8e8]
> btrfs check(main+0x15d)[0x40ac5c]
> /lib/libc.so.6(__libc_start_main+0xf0)[0x7f9b4cb060d0]
> btrfs check[0x40a729]
> Clear free space cache v2
> 
> The underlying md0 (raid6) doesn't report any errors, trying different kernels makes no difference, 4.10.17, 4.11.4 and 4.12.0-rc4 all give the same errors. Everything above was
> done with btrfs-progs 4.11.
> 
> Any hints on how I can fix the errors in the filesystem? I don't mind loosing todays changes, but I would like to keep all the older data :)
> 
> regards,
> 
> Koen
> 

-- 
Hugo Mills             | Close enough for government work.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--1SQmhf2mF2YjsYvc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZOv2eAAoJEFheFHXiqx3kmKgP/0zbO9klBwl7qrXos4nT79mI
nSUHfrPict3aT2tSqY5MbRGKq5Gkm1fmi5eV5jOwvciYk8Mv4Sy5CdwbgvDw8gjM
/AGHK2J9E/n+NREBwgFDI5/HSOFmtGDGBPUVcQTinNtykGwoSHUqcYtgIq8iFdkC
iZJIbgaglDZj1LdZzFcWlMLHFDL6cTgsy+P8q1s9PQEg0bMadM3Hu8QHFmhO/FLT
2KoR6cw5V+Mg5jNT18zPN9EbclJoEHebHcTbuvCyc/dX4BJmGMHzLn/1lxDKYzLm
5Xh1rIXItsvdDCSonSEPDizo4EvEpiv0O4JHag7PEo8q2dAJsesZCxBLOIwMMcR7
57s9YsAN/a2JlpQYBCEpeRhMsgiO43ZBtH8J2YW/BGRTAZJ1OhBETnRsu2MDovmf
cDRthKTjNM7m2veTjATF2h2rJ9IyTzpLHgXdzwfsk9iXPHl8McW4pnmROxchPZKE
Rdi2Em5D36SXAEhgdcYOcadNVSD+cAVI6X0I5/GUjGkb38xlf5zwg0mYGbRG6vpW
xraPpi79xANtWb+RpODpa7Ycqyp2GY5Wjq4e1TF1pg8fFHp2eXxHscikn0W7i+wv
k8Qe36/P9YMqcjKwhtV9L3TFVY9aBja0eGpRN9oVgRxWPRiLymYDwqZMvy88Qkto
SpQ9fjAMuuC6gPTtf+og
=q6EV
-----END PGP SIGNATURE-----

--1SQmhf2mF2YjsYvc--
