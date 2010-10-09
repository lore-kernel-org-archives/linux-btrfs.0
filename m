From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: "Some devices missing" behaviour
Date: Sat, 9 Oct 2010 17:03:18 +0100
Message-ID: <20101009160318.GB2291@selene>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   I've just encountered some odd behaviour with regard to removed
devices. Brief summary:

 - It's hard (in some sense) to tell a btrfs filesystem that a device
   has been removed permanently, and seems to require an
   unmount/remount, or resize to do so.

 - Removed devices break btrfs dev scan

   Details follow:

# mkfs.btrfs -d raid10 -m raid10 -L btest /dev/primary/btrtest{1,2,3,4,5}
# mount /dev/primary/btrtest1 /mnt
# sudo btrfs fi show btest
failed to read /dev/sr0
Label: 'btest'  uuid: 908f87d7-23d8-453e-ab04-ae1426306e0f
	Total devices 5 FS bytes used 28.00KB
	devid    1 size 1.00GB used 276.00MB path /dev/dm-21
	devid    2 size 1.00GB used 136.00MB path /dev/dm-22
	devid    3 size 1.00GB used 136.00MB path /dev/dm-23
	devid    4 size 1.00GB used 264.00MB path /dev/dm-24
	devid    5 size 1.00GB used 264.00MB path /dev/dm-25

Btrfs v0.19-35-g1b444cd

   All well and good so far.

# btrfs dev del /dev/primary/btrtest4 /mnt
# btrfs fi show btest
failed to read /dev/sr0
Label: 'btest'  uuid: 908f87d7-23d8-453e-ab04-ae1426306e0f
	Total devices 5 FS bytes used 100.13MB
	devid    1 size 1.00GB used 190.38MB path /dev/dm-21
	devid    2 size 1.00GB used 170.38MB path /dev/dm-22
	devid    3 size 1.00GB used 170.38MB path /dev/dm-23
	devid    5 size 1.00GB used 170.38MB path /dev/dm-25
	*** Some devices missing

Btrfs v0.19-35-g1b444cd

   Now, it's claiming that some devices are missing, but what if I
wanted to make this a permanent change? Say, the additional device was
one added temporarily to the array as part of a migration to new
hardware?

   On IRC, it was suggested that a rescan would fix it:

# btrfs dev scan
Scanning for Btrfs filesystems
failed to read /dev/sr0
# btrfs fi show btest
failed to read /dev/sr0
Label: 'btest'  uuid: 908f87d7-23d8-453e-ab04-ae1426306e0f
	Total devices 5 FS bytes used 100.13MB
	devid    1 size 1.00GB used 190.38MB path /dev/dm-21
	devid    2 size 1.00GB used 170.38MB path /dev/dm-22
	devid    3 size 1.00GB used 170.38MB path /dev/dm-23
	devid    5 size 1.00GB used 170.38MB path /dev/dm-25
	*** Some devices missing

Btrfs v0.19-35-g1b444cd

   Nope. What about explicitly scanning the devices?

# btrfs dev scan /dev/primary/btrtest*
Scanning for Btrfs filesystems in '/dev/primary/btrtest1'
Scanning for Btrfs filesystems in '/dev/primary/btrtest2'
Scanning for Btrfs filesystems in '/dev/primary/btrtest3'
Scanning for Btrfs filesystems in '/dev/primary/btrtest4'
ERROR: unable to scan the device '/dev/primary/btrtest4'

   Note that it's stopped the scan immediately on encountering the
removed device, so btrtest5 hasn't been picked up. Maybe it's
something left in the device?

# dd if=/dev/zero of=/dev/primary/btrtest4
# btrfs dev scan /dev/primary/btrtest*
Scanning for Btrfs filesystems in '/dev/primary/btrtest1'
Scanning for Btrfs filesystems in '/dev/primary/btrtest2'
Scanning for Btrfs filesystems in '/dev/primary/btrtest3'
Scanning for Btrfs filesystems in '/dev/primary/btrtest4'
ERROR: unable to scan the device '/dev/primary/btrtest4'
# btrfs fi show btest
failed to read /dev/sr0
Label: 'btest'  uuid: 908f87d7-23d8-453e-ab04-ae1426306e0f
	Total devices 5 FS bytes used 100.13MB
	devid    1 size 1.00GB used 190.38MB path /dev/dm-21
	devid    2 size 1.00GB used 170.38MB path /dev/dm-22
	devid    3 size 1.00GB used 170.38MB path /dev/dm-23
	devid    5 size 1.00GB used 170.38MB path /dev/dm-25
	*** Some devices missing

Btrfs v0.19-35-g1b444cd

   Zeroing the device has no effect. However, unmounting it does work,
partially:

# umount /mnt
# btrfs dev scan
Scanning for Btrfs filesystems
failed to read /dev/sr0
# btrfs dev scan /dev/primary/btrtest*
Scanning for Btrfs filesystems in '/dev/primary/btrtest1'
Scanning for Btrfs filesystems in '/dev/primary/btrtest2'
Scanning for Btrfs filesystems in '/dev/primary/btrtest3'
Scanning for Btrfs filesystems in '/dev/primary/btrtest4'
ERROR: unable to scan the device '/dev/primary/btrtest4'
# btrfs fi show btest
failed to read /dev/sr0
Label: 'btest'  uuid: 908f87d7-23d8-453e-ab04-ae1426306e0f
	Total devices 4 FS bytes used 100.13MB
	devid    1 size 1.00GB used 190.38MB path /dev/dm-21
	devid    2 size 1.00GB used 170.38MB path /dev/dm-22
	devid    3 size 1.00GB used 170.38MB path /dev/dm-23
	devid    5 size 1.00GB used 170.38MB path /dev/dm-25

Btrfs v0.19-35-g1b444cd

   So, you need to unmount/remount the FS to make it believe that the
device removal is permanent. (As an aside, I also found that resizing
down by 1M then back to max has the same effect, if you don't want to
unmount). However, the explicit scan of the block devices is still
broken by the removed device, even after all data on it has been
zeroed.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I hate housework. You make the beds, you wash the dishes, and ---  
           six months later you have to start all over again.            

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFMsJJFIKyzvlFcI40RAvCRAJoCo+cVvdGy9Coie3to5JQ+c+bM1wCdFto4
/jm0qQZ9WNFIHmvqTnumi/U=
=UVlM
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
