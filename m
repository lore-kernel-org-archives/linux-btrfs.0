Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:58914 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3HaKNE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Aug 2013 06:13:04 -0400
Received: by mail-we0-f179.google.com with SMTP id t58so2331912wes.38
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Aug 2013 03:13:02 -0700 (PDT)
Message-ID: <1377943975.5426.17.camel@pc-steven.LAN>
Subject: Device delete returns "unable to go below four devices on raid10"
 on 5 drive setup
From: Steven Post <redalert.commander@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: Sat, 31 Aug 2013 12:12:55 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Q0/df1D7TGILse15O/FH"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-Q0/df1D7TGILse15O/FH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello list,

I have a 5 drive raid10 setup (6th sata port malfunctions, all drives
are 3TB in size).
I want to remove a single drive, yet the 'btrfs device delete' command
gives me the "unable to go below four devices on raid10" error.

This is the result after first deleting a device, after a check, it
didn't seem to be removed, then issuing the command again results in the
error.

Before:
# btrfs filesystem show /dev/sda3
Label: 'maindrivearray'  uuid: f58976ab-2ce1-4a1c-bc82-22df7d3393b4
	Total devices 5 FS bytes used 2.67TB
	devid    4 size 2.73TB used 1.09TB path /dev/sde3
	devid    3 size 2.73TB used 1.09TB path /dev/sdd3
	devid    2 size 2.73TB used 1.09TB path /dev/sdc3
	devid    6 size 2.73TB used 1.09TB path /dev/sdb3
	devid    5 size 2.73TB used 1.09TB path /dev/sda3

Btrfs Btrfs v0.19

After issuing the command
# btrfs device delete /dev/sde3 /mnt

I get this:
# btrfs filesystem show /dev/sda3
Label: 'maindrivearray'  uuid: f58976ab-2ce1-4a1c-bc82-22df7d3393b4
	Total devices 5 FS bytes used 2.67TB
	devid    4 size 2.73TB used 1.09TB path /dev/sde3
	devid    3 size 2.73TB used 1.24TB path /dev/sdd3
	devid    2 size 2.73TB used 1.24TB path /dev/sdc3
	devid    6 size 2.73TB used 1.24TB path /dev/sdb3
	devid    5 size 2.73TB used 1.24TB path /dev/sda3

Btrfs Btrfs v0.19

When issuing the delete command again, the error pops up, also after
reboot. The first remove did take a long time to complete and according
to syslog and the 'filesystem show' command a lot of data was moved to
the other drives (as expected).

The system is running Debian Wheezy (kernel 3.2.0-4-amd64 #1 SMP Debian
3.2.46-1 x86_64).

Is this something known (and possibly resolved in a later version), or
should I open a bug report about it? Could it be that the device removal
was completed, but still shows as part of the array for some reason?

The reason for the remove is actually that I want to (gradually) replace
the 3TB drives with 1 TB ones, and somewhere in the middle move some of
the data of the array, to another machine, that currently has the 1 TB
drives which I intend to replace with the 3TB ones.

Best regards,
Steven

--=-Q0/df1D7TGILse15O/FH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAABAgAGBQJSIcGnAAoJEEvSpS1Vyfkxn7EIAKm1Nrwhx48vFnRN9ajaJRQC
mXzcJmjdzfjr7WHIuse730tuxmnEni0hPaGK+ZcNJg5nKkfXcoVXF1SNd4Q+QsbX
PZbXlkG5DDyWvhftHaZq5oMF74SB4mHfdgMVGRpKITkoGqofUMtJNkiiRkXsvbC4
Yeq498lQQ80ZTVruvrSCDqaaDFZxWBypHNPGO7Sx2vJOl2AF1gzjwWAcbpz7Uzdv
btX0bUJwbXXs2009Wy40Nelkw/bf+AAIrh1a2fAaiWsi+ciHtbAW+re5lTnrp1aZ
4Y6oSL1vfKxm+dr94Y4eFCcoVl4gswxWxY0EezEfeJbR4ePGy2gI8y5RMOr2n5U=
=+sAe
-----END PGP SIGNATURE-----

--=-Q0/df1D7TGILse15O/FH--

