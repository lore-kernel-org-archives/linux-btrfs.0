Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from efeu.mur.at ([89.106.208.66]:36630 "EHLO efeu.mur.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab3IPLHB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 07:07:01 -0400
Received: from localhost (localhost [127.0.0.1])
	by efeu.mur.at (Postfix) with ESMTP id 0FEE822073
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Sep 2013 12:57:49 +0200 (CEST)
Received: from efeu.mur.at ([127.0.0.1])
	by localhost (efeu.mur.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id YgiZPCa1xDKU for <linux-btrfs@vger.kernel.org>;
	Mon, 16 Sep 2013 12:57:48 +0200 (CEST)
Received: from [192.168.2.21] (85-126-169-193.work.xdsl-line.inode.at [85.126.169.193])
	by efeu.mur.at (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Sep 2013 12:57:48 +0200 (CEST)
Message-ID: <5236E1FF.4080900@mur.at>
Date: Mon, 16 Sep 2013 12:48:31 +0200
From: =?UTF-8?B?Sm9naSBIb2Ztw7xsbGVy?= <jogi@mur.at>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: rootfs crash
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig18705ADC84212B3F9D769A22"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig18705ADC84212B3F9D769A22
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Dear all,

Yesterday the rootfs on my laptop crashed.  So far all attempts to fix
it have failed;  hence I am looking for some help (if possible).

I was creating a copy of a virtual machine (kvm) on my laptop and
started modifying the machine from the inside (installing new packages),
when the laptop froze.  Rebooting failed because /dev/sda3 (the rootfs)
could not be mounted anymore.

Some of the errors were

btrfs: failed to read log tree
btrfs: open_ctree failed

Recovery using a Debian/Testing boot stick (kernel 3.10.2, btrfs-tools
v0.20-rc1) were unsuccessful so far.  After btrfs-zero-log the device
was still not mountable.  Mount attempts fail with i/o erros now.

btrfs restore manages to restore some files from /boot/grub but then
fails with

failed to inflate: -6
and
failed to inflate: -8
and
*** Error in `btrfs': free(): invalid next size
(normal):0x0000000000c0e650 ***

The filesystem is setup as raid1 on devices sda3 and sdb3 using lzo
compression.  There are subvolumes for /home and /var.

Images created with btrfs-image are available from before and after
btrfs-zero-log was run.  I can make them available if needed.

Any hints appreciated!

Regards,
--=20
j.hofm=C3=BCller                                http://users.mur.at/thesi=
x/


--------------enig18705ADC84212B3F9D769A22
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREIAAYFAlI24kIACgkQkaXhaapqItmqsgEA1VyCMLvimIX0Lki3l/uekO45
zSnsSmimE9vdqu+e7g4A/0z0+e0Ub+NeBIxXzQYgwkCEGx3ddh6HKNzRrFL+tj1u
=Z9gf
-----END PGP SIGNATURE-----

--------------enig18705ADC84212B3F9D769A22--
