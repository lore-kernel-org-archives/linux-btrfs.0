Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nala.villavu.com ([188.165.243.101]:49437 "EHLO
	nala.villavu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbbEBQmv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 May 2015 12:42:51 -0400
Received: from a82-161-36-93.adsl.xs4all.nl ([82.161.36.93] helo=[192.168.178.31])
	by nala.villavu.com with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80.1)
	(envelope-from <merlijn@wizzup.org>)
	id 1YoaA6-0004qa-4A
	for linux-btrfs@vger.kernel.org; Sat, 02 May 2015 18:21:06 +0200
Message-ID: <5544F965.9040703@wizzup.org>
Date: Sat, 02 May 2015 18:20:53 +0200
From: Merlijn Wajer <merlijn@wizzup.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Linux v4.1-rc1: Unable to handle kernel NULL pointer dereference
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="aJXtVc35olaPeKQpsBOND93anCFB9Xxwr"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aJXtVc35olaPeKQpsBOND93anCFB9Xxwr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

btrfs fails to work on my rootfs, with a NULL pointer dereference:
http://sprunge.us/aIWe resulting in a panic on boot. This has also been
happening with linux-next-2015042* at least.

It works on 3.8 and 3.18 kernels. The reason the FS is mounted rather
late is because I drop to a shell from inside my initramfs and then
mount it manually to get a trace; the rootfs is encrypted. Initially
mounting the btrfs seems to work, but when actually accessing content it
fails.

My kernel is "dirty" because I applied a single line patch to my device
tree (ARM device): I have no local btrfs changes.

Cheers,
Merlijn


--aJXtVc35olaPeKQpsBOND93anCFB9Xxwr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJVRPlrAAoJEFgU4HQpHjKDzLIP/2piKI6ZpKPR5FN6NGpsv9wm
VJVZMT3e6UNUXHmpRcC8kkC6sOEv+opdT3Zg+zMiSR1ARq+oVk0xwbR32AEPVWlD
HZCv1mNZEoLXv8e5xpIq8oE+kqodzwqL4fG3OwZo+Qcjs18NubM1LchLycOm2Vq9
axScYAi1jTAuFpKPUnxC9D38+8NI092F8I9+BkWH7+N5Ye/tIBqejqhxeEUTP4LC
b+FlQhTASDdFfnFCHIYjkxGtgYJ85oFfWb57k9tvGy+fQTRT1dbXhBfykiuCB1oh
IPCuX0lvuE7LZBGE3ntHZTlMQ5OqxvRghsf8CWcoGtlHxXv/L9kpjjFR9Youn16l
7Gi1BJRnhpgOP6CAUAvxPwWpj6yLFm8+pciScNJlfAqad9ox6enoCNpJnis3KOs7
1Ej2czi1TcZtVhdW7Uky0xSRXzH+x8ydmRrPsaJrk7LuzBG7lCMDEQkB6AqsTcEv
uRddvPbGFekTAsnwuM6+rowr7r83gz+blDcgWKW2WRf6wuwjq2MdvWuoBhH4+Hbd
O4JplovBlKdgGfXeEBKQnqIVRz7s3PqAcQYQW+FVqYsTjVwmb6qaPhiMNAWXF0OZ
iqeq+qUIonYJb/68p3PBHVIjQttaPGd0sUBzR5CXxveO905JfFU6pwP6mtmlG4WV
L7rhqqXF1xx0B0sMmpqd
=Kobz
-----END PGP SIGNATURE-----

--aJXtVc35olaPeKQpsBOND93anCFB9Xxwr--
