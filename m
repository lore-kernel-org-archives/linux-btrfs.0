Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moh3-ve3.go2.pl ([193.17.41.87]:35516 "EHLO moh3-ve3.go2.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751224AbdHPJ1i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 05:27:38 -0400
Received: from moh3-ve3.go2.pl (unknown [10.0.0.158])
        by moh3-ve3.go2.pl (Postfix) with ESMTP id D9DECB5A026
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 11:27:36 +0200 (CEST)
Received: from unknown (unknown [10.0.0.108])
        by moh3-ve3.go2.pl (Postfix) with SMTP
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 11:27:36 +0200 (CEST)
Date: Wed, 16 Aug 2017 11:27:34 +0200
From: Piotr Szymaniak <szarpaj@grubelek.pl>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs fi du -s gives Inappropriate ioctl for device
Message-ID: <20170816092734.GN19638@pontus.sran>
References: <20170814225740.GK19638@pontus.sran>
 <CAJCQCtR6CXOC+veFEWoC1aC+BvKgwpnAZ_ZsA2acuLRNwybkTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
In-Reply-To: <CAJCQCtR6CXOC+veFEWoC1aC+BvKgwpnAZ_ZsA2acuLRNwybkTw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 14, 2017 at 05:40:30PM -0600, Chris Murphy wrote:
> On Mon, Aug 14, 2017 at 4:57 PM, Piotr Szymaniak <szarpaj@grubelek.pl> wr=
ote:
>=20
> >
> > and... some issues:
> > ~ # btrfs fi du -s /mnt/red/\@backup/
> >      Total   Exclusive  Set shared  Filename
> > ERROR: cannot check space of '/mnt/red/@backup/': Inappropriate ioctl f=
or device
>=20
>=20
> It's a bug, but I don't know if any devs are working on a fix yet.
>=20
> The problem is that the subvolume being snapshot, contains subvolumes.
> The resulting snapshot, contains an empty directory in place of the
> nested subvolume(s), and that is the cause for the error.

Ok, but why, on the same btrfs, it works on some subvols with subvols and d=
oes
not work on other subvols with subvols? If it does not work - OK, if it wor=
ks -
OK, but that seems a bit... random?

~ # btrfs fi du -s /mnt/red/\@backup/ /mnt/red/\@backup/.snapshot/monthly_2=
017-08-01_05\:30\:01/ /mnt/red/\@svn/ /mnt/red/\@svn/.snapshot/weekly_2017-=
08-05_04\:20\:02/
     Total   Exclusive  Set shared  Filename
ERROR: cannot check space of '/mnt/red/@backup/': Inappropriate ioctl for d=
evice
ERROR: cannot check space of '/mnt/red/@backup/.snapshot/monthly_2017-08-01=
_05:30:01/': Inappropriate ioctl for device
  52.23GiB    10.57MiB     4.13GiB  /mnt/red/@svn/
   4.35GiB     1.03MiB     4.12GiB  /mnt/red/@svn/.snapshot/weekly_2017-08-=
05_04:20:02/


Best regards,
Piotr Szymaniak.

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEFSphDYLXjiCg60ZUQykCi/VzD2UFAlmUEAQACgkQQykCi/Vz
D2X/zA//TtyKMBwlvXVyoApYH+Xlm/d5qYpHrdF5Ebr03Qupm/YUB2bvbnnM7PYH
49egszPObwsSVB9bZDw5dWJqVWzLki68N33QDSrOB8XmXcKc5f7eu5JOf4WPumFL
+/GE34YJ4n4c7DFBhsznm9122Qpb8xqbxf+mV8ggpg0lecMH8+2t25rM9w5YftNC
fTRZe3TU2bdw4CEMD903McS6RfyvmPVaQX5J1vqn31opJmKoTra4TF93XRwFdaI/
ClPNf1oYVw9971KNUzsg5rnP4D2Si4IiHSLgTOj4syFiPolm99zDRHrpB8pUw38j
uH8FgvPR3tVk/IueW1SK5+da9AZUsfbc/Fxgr0uO/9b3AWkBWQ1nDA10FUzyAxI7
wg/YiKoz21dt3d+kJV+RbhsA777JW3WjszdG/CLuFUxuipMSsIZdE4m/eN0pFtK0
D66FUMq/NntxjolTN7v1FnOOWPRz2cctkbv9WbwosMu4prAL1tbfJg74SoVAPgQd
OirJzULBtIQSbynjcVK+AmO3sbqcJOB2HGFlC3Ff4r9wT1OU58A7XCG4rNyuthHw
Co544RawsdaEuP++4O11si0crwkboHn3MQSSPrkMDrltVB9lENcPTMLMUGCjvfPe
c/S59Eg7QQ2iHI31teKB7rXDeit6z81HIZ1puF5Qt+7J6Gobfnw=
=4I9u
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
