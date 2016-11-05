Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39065 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbcKEVbp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Nov 2016 17:31:45 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1c38Yv-00049R-Ga
        for linux-btrfs@vger.kernel.org; Sat, 05 Nov 2016 21:31:41 +0000
Date: Sat, 5 Nov 2016 21:31:41 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Transid verify failure after unexpected reboot (4.7, RAID-1)
Message-ID: <20161105213141.GN16645@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BtmVPk+Smchi6n7w"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--BtmVPk+Smchi6n7w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Not sure if there's anything I can do about this or not. I suspect
not, but if anyone's got any good ideas about fixing it, please let me
know...

   My server crashed earlier this evening -- an OOM tried to kill
qemu, and kvm took exception to it.

   After rebooting, my 6-device RAID-1 btrfs array wouldn't mount.
Specifically:

Nov  5 20:29:59 s_src@amelia kernel: BTRFS info (device sda2): disk space caching is enabled
Nov  5 20:29:59 s_src@amelia kernel: BTRFS info (device sda2): bdev /dev/sda2 errs: wr 0, rd 50, flush 0, corrupt 4, gen 0
Nov  5 20:29:59 s_src@amelia kernel: BTRFS info (device sda2): bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 6, gen 0
Nov  5 20:29:59 s_src@amelia kernel: BTRFS info (device sda2): bdev /dev/sdd2 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
Nov  5 20:29:59 s_src@amelia kernel: BTRFS info (device sda2): bdev /dev/sdh2 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
Nov  5 20:29:59 s_src@amelia kernel: BTRFS error (device sda2): parent transid verify failed on 24536996052992 wanted 2001332 found 2000162
Nov  5 20:29:59 s_src@amelia kernel: BTRFS error (device sda2): parent transid verify failed on 24536996052992 wanted 2001332 found 2000162
Nov  5 20:29:59 s_src@amelia kernel: BTRFS error (device sda2): failed to read block groups: -5
Nov  5 20:29:59 s_src@amelia kernel: BTRFS: open_ctree failed
 
hrm@amelia:~ $ sudo btrfs fi show
Label: 'system'  uuid: 96f4bf17-2531-4643-9384-cdf58c713140
        Total devices 2 FS bytes used 75.44GiB
        devid    1 size 111.79GiB used 91.79GiB path /dev/sde1
        devid    2 size 111.79GiB used 91.79GiB path /dev/sdf1
 
Label: 'amelia'  uuid: 1da97c6f-5467-4591-ad79-5d283db800d4
        Total devices 6 FS bytes used 7.44TiB
        devid    4 size 3.63TiB used 2.93TiB path /dev/sda2
        devid    7 size 1.36TiB used 670.00GiB path /dev/sdd2
        devid    9 size 1.81TiB used 1.11TiB path /dev/sdb2
        devid   12 size 3.63TiB used 2.92TiB path /dev/sdh2
        devid   13 size 3.63TiB used 2.83TiB path /dev/sdc2
        devid   14 size 5.46TiB used 4.75TiB path /dev/sdg2
 
btrfs-progs v4.0
 
hrm@amelia:~ $ uname -a
Linux amelia 4.7.0-dirty #153 SMP Mon Jul 25 04:22:08 BST 2016 x86_64 GNU/Linux

hrm@amelia:~ $ sudo btrfs check --readonly /dev/sda2
parent transid verify failed on 24536996052992 wanted 2001332 found 2000162
parent transid verify failed on 24536996052992 wanted 2001332 found 2000162
parent transid verify failed on 24536996052992 wanted 2001332 found 2000162
parent transid verify failed on 24536996052992 wanted 2001332 found 2000162
Ignoring transid failure
leaf parent key incorrect 24536996052992
Checking filesystem on /dev/sda2
UUID: 1da97c6f-5467-4591-ad79-5d283db800d4
checking extents
parent transid verify failed on 24536995299328 wanted 2001332 found 2000162
parent transid verify failed on 24536995299328 wanted 2001332 found 2000162
parent transid verify failed on 24536995299328 wanted 2001332 found 2000162
parent transid verify failed on 24536995299328 wanted 2001332 found 2000162
Ignoring transid failure
leaf parent key incorrect 24536995299328
bad block 24536995299328
Errors found in extent allocation tree or chunk allocation
parent transid verify failed on 24536995299328 wanted 2001332 found 2000162
Ignoring transid failure
parent transid verify failed on 24536995954688 wanted 2001332 found 2000160
parent transid verify failed on 24536995954688 wanted 2001332 found 2000160
parent transid verify failed on 24536995954688 wanted 2001332 found 2000160
parent transid verify failed on 24536995954688 wanted 2001332 found 2000160
Ignoring transid failure
parent transid verify failed on 24536996052992 wanted 2001332 found 2000162
Ignoring transid failure
parent transid verify failed on 24536996413440 wanted 2001332 found 2000160
parent transid verify failed on 24536996413440 wanted 2001332 found 2000160
parent transid verify failed on 24536996413440 wanted 2001332 found 2000160
parent transid verify failed on 24536996413440 wanted 2001332 found 2000160
Ignoring transid failure
parent transid verify failed on 24536996577280 wanted 2001332 found 2000162
parent transid verify failed on 24536996577280 wanted 2001332 found 2000162
parent transid verify failed on 24536996577280 wanted 2001332 found 2000162
parent transid verify failed on 24536996577280 wanted 2001332 found 2000162
Ignoring transid failure
checking free space cache
parent transid verify failed on 24536995299328 wanted 2001332 found 2000162
Ignoring transid failure
There is no free space entry for 30211683549184-30212033085440
cache appears valid but isnt 30210959343616
parent transid verify failed on 24536995954688 wanted 2001332 found 2000160
Ignoring transid failure
There is no free space entry for 30214130446336-30214180569088
cache appears valid but isnt 30213106827264
parent transid verify failed on 24536996052992 wanted 2001332 found 2000162
Ignoring transid failure
There is no free space entry for 30240800890880-30241024114688
cache appears valid but isnt 30239950372864
found 503122865529 bytes used err is -22
total csum bytes: 0
total tree bytes: 20381696
total fs tree bytes: 0
total extent tree bytes: 16023552
btree space waste bytes: 5113541
file data blocks allocated: 1976303616
 referenced 1976303616
btrfs-progs v4.0

   I make that five corrupt blocks in total, all about 1170
generations earlier than they should be, which is quite a big
distance. The hardware setup is a first-gen HP Microserver. Four of
the devices are internal, and the remaining two are in an eSATA
port-multiplier enclosure. I don't have any indication that any of
that hardware had problems around the time of the crash, other than
the hard reset I made when I found the machine was unresponsive.

   I'm currently in the process of using btrfs-restore to retrieve the
data on it which hasn't been backed up yet -- that's a small but
non-zero fraction of the total.

   Other than killing this thing with fire and restoring from backup
(which will take a few weeks), does anyone else have any suggestions
for recovery?

   Hugo.

-- 
Hugo Mills             | "Can I offer you anything? Tea? Seedcake? Glass of
hugo@... carfax.org.uk | Amontillado?"
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                           Mrs Gillyflower, Doctor Who

--BtmVPk+Smchi6n7w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYHk+9AAoJEFheFHXiqx3kbcAQAI8VaHbMs/chaH9upFOFEy46
Asnww3gcp/B9ilOAqOuf5V322SxOTb3z2tntAomW0unYEZ6rXhBq4Cu/luhejCSL
VFidW7X7aZI3ShazWeCFwSKZOeCoQyyT7J/pXLpaw+JECv4QRU4pKacGIk/rUmhd
tw8zG55g69WJM5tfgCIcvSakt4RynF6lgxd/3hjzlwD3blCwhqtfxck3BpQLHZXr
sGvowvXA2oCjS1q4n8aDPNNvJzebTz2kBmvTrMiEi+SIzn+lXUb78c/hyvGcTTGO
tJAeDgpUmaxdBp5hp7I8pRqePUYRGbnhBNcRagcStHK+54BPq/tobcC3kUPc4PMs
3ljD9Z7uZQ97Dd/dl7PqUj3agpO9fi7Ks4SMcfx/Hxz0Ir5Rm2h1Ftm5OcDzTckN
Sr3bvuseptyXUVDEGa9ITkv/KbWVAwjH2BCzCvZ/7hKPs3/QKfpjsDz9mNNCFjvV
YMuVDB5hVhwEPmau5aQndOWkk+1A5cFEoERGdJuZIAfefXle9IkZERm8E1u9MJzr
ZQRWLUQBs3Lb8W+/PBkb7syaUbAZ6FJLoDhOTpJtzqWmq2rxyK5x/5hq52tJz31/
ciX/F0eSXNcH1KHxc7lOxurgbXcX3CKTtdv5r/lubrgV/lX7j5n29o8JquqOaz38
QdrHmH6omi60WqD4VPCt
=qZwv
-----END PGP SIGNATURE-----

--BtmVPk+Smchi6n7w--
