Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:44161 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbaEYSdD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 May 2014 14:33:03 -0400
Received: from compute6.internal (compute6.nyi.mail.srv.osa [10.202.2.46])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 2FFC824
	for <linux-btrfs@vger.kernel.org>; Sun, 25 May 2014 14:24:26 -0400 (EDT)
Received: from avolt.net (unknown [83.142.149.227])
	by mail.messagingengine.com (Postfix) with ESMTPA id 9B21A6800FD
	for <linux-btrfs@vger.kernel.org>; Sun, 25 May 2014 14:24:25 -0400 (EDT)
Date: Sun, 25 May 2014 20:26:01 +0200
From: Andrei Volt <andrei@avolt.net>
To: linux-btrfs@vger.kernel.org
Subject: mount fails with "double free or corruption" after failed
Message-ID: <20140525182601.GA7642@dmt>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

resize operation
Reply-To:=20

Hello all,

Someone on #archlinux suggested I post this problem I'm having on this
mailing list. Apologies if this is off-topic, although I believe it's not.

After a failed resize operation (shrink of 30 GB, waited 8 hours, iotop
reporting 50 M/s writes, no reads), my btrfs partition wouldn't mount,
complaining about "double free or corruption". I finally managed to
mount the filesystem after a btrfs-zero-log and reboot.

I've run an additional backup, a bit more up to date then my previous one,
but obviously the error message worries me a bit.

How can I make sure the data is intact? What kind of corruption could
occur? (what's the worse that could happen? so far I'm not seeing anything
unusual). I didn't do anything else apart from the resize operation, a
few btrfsck(s) which failed immediately, and the btrfs-zero-log operation.

I should mention that on the second to last reboot the mount failed
again, and it only mounted again correctly after zero-log + reboot.
(same error, "double free or corruption", after a bunch of output that
got cleared from the scrollback buffer.

I've made a backup via rsync but when I try to du -sc the backup and the
original, the original reports "infinity" (although this is not new),
and the backup errors out on some files (which is why I'd rather not go
=66rom the restore from backup option, until I'm sure the backup is correct)

What should I do to:

1. (ideally) repair the FS. Right now it _seems_ to be failing on
every other boot, and I have to run btrfs-zero-log to mount, and even
then it only mounts successfully on reboot.

2. check for data integrity

3. check that my backup is correct?

Here's the output of the commands suggested on the wiki:

Linux 3.13.9-1-ck #1 SMP PREEMPT Fri Apr 18 23:21:44 CEST 2014 x86_64 GNU/L=
inux

Btrfs v3.14.1

Data, single: total=3D188.99GiB, used=3D143.17GiB
Label: 'root'  uuid: 0c2bfb0a-a549-4170-92a5-c4f218c023eb
	Total devices 1 FS bytes used 25.20GiB
	devid    1 size 37.97GiB used 37.97GiB path /dev/sda3

Label: 'home'  uuid: ea64435d-b24f-453b-8f0a-af7e18726c86
	Total devices 1 FS bytes used 145.96GiB
	devid    1 size 200.00GiB used 193.00GiB path /dev/sda2

System, single: total=3D4.00MiB, used=3D28.00KiB
Metadata, single: total=3D4.01GiB, used=3D2.79GiB

I've also ran a btrfs scrub which reported 4 uncorrectable errors.

Cheers,
Andrei

--=20
Andrei Volt

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJTgjW5AAoJEGC4J/i2HiAknzcIAIrSZTFrilsAivFcCoxw/rkO
w9NWGBlyAGffjaSEIa7e2lWlJfpzkFFprGw6lxfEylMYE94XLSfzAe33O79C+Bch
O09zc/mKiJgWjMCz2Bol6q6yFV/mGKLUutNUoIl3sRZfV8b+qVOjWjcLerHSSsQe
QeRcKVAtIUVwFdchXWbdq1c9JxDzQqVnPu/z02Mu5q7PKWpUMkCrRek4N9pCsjfm
DDYNHcykgNQKrF1wvBITirlqQtHWuDvn/hSHunKKwGPHKS20IIjuzFD+NoJXJEdb
pcMOBCHZJ08Q+rlO4g7ci0/iaKFp0IFKf40etUEvU2ezWUyUM50n14KAsj64nho=
=K/gb
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
