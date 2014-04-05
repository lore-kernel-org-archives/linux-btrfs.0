Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57664 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbaDEWVx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Apr 2014 18:21:53 -0400
Date: Sat, 5 Apr 2014 15:21:49 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, cwillu <cwillu@cwillu.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 24/27] btrfs-progs: Convert man page for btrfs-zero-log
Message-ID: <20140405222149.GD13857@merlins.org>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com> <1396427378-10487-25-git-send-email-quwenruo@cn.fujitsu.com> <20140404184620.GA12124@merlins.org> <CAE5mzvhTZ1bO_uoyz-ixsn29iznXRjzFkM5UfDBcFUdX0ov7RQ@mail.gmail.com> <20140405220203.GB13857@merlins.org> <20140405220346.GV7442@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
In-Reply-To: <20140405220346.GV7442@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 05, 2014 at 11:03:46PM +0100, Hugo Mills wrote:
>    As far as I recall, -orecovery is read-write. -oro,recovery is
> read-only.

Yes, we both corrected my Email at the same time :)

Actually it's better/worse than that. From my notes at
http://marc.merlins.org/perso/btrfs/2014-03.html#Btrfs-Tips_-Btrfs-Scrub-an=
d-Btrfs-Filesystem-Repair

mount -o recovery,ro (for when regular mount isn't working). Note, you have=
 to use ro or it will give you a misleading error:
root@polgara:~# mount -o recovery /dev/mapper/crypt /mnt/mnt8
mount: /dev/mapper/crypt already mounted or /mnt/mnt8 busy
root@polgara:~# mount -o recovery,ro /dev/mapper/crypt /mnt/mnt8
root@polgara:~#

In other words, for me -o recovery has never worked unless I added ,ro.
I'm not saying -o recovery cannot work, but when I needed it, it didn't work
because likely it failed to replay the log as you say, and adding ro fixed
that problem.

That said, returning
mount: /dev/mapper/crypt already mounted or /mnt/mnt8 busy                 =
                                                              =20
is not ideal :)

Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQCVAwUBU0CB/X4xUKZ2O+kBAQIvmgP/QOYzoZa7Q2C9Znf2LzdWGySCDWZDW5zV
m7H3FH3mi7EVZ7owoD8tPArn8gFAYXJCbwIxESrKSxVODKn/X/RG/ptY1Zl/X5BU
JOJOmG0khJEIbxrm8sL/47Be0tUzlwh8UzW/nAsJ2FxC+uHFhB6XpW5rklxfS8/Z
rPaUASML5Qc=
=YwMP
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
