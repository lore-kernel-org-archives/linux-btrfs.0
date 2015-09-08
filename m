Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49043 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbbIHTeH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 15:34:07 -0400
Date: Tue, 8 Sep 2015 19:34:05 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Ian Kumlien <ian.kumlien@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [btrfs tools] ability to fail a device...
Message-ID: <20150908193405.GN23944@carfax.org.uk>
References: <CAA85sZv5V_YGnHaYfDKJ8L9=Nmg0XNRoxK9NLZER_jKZ7TUdnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1bhFRg6vL9BT9osV"
In-Reply-To: <CAA85sZv5V_YGnHaYfDKJ8L9=Nmg0XNRoxK9NLZER_jKZ7TUdnA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1bhFRg6vL9BT9osV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 08, 2015 at 09:18:05PM +0200, Ian Kumlien wrote:
> Hi,
>=20
> Currently i have a raid1 configuration on two disks where one of them
> is failing.
>=20
> But since:
> btrfs fi df /mnt/disk/
> Data, RAID1: total=3D858.00GiB, used=3D638.16GiB
> Data, single: total=3D1.00GiB, used=3D256.00KiB
> System, RAID1: total=3D32.00MiB, used=3D132.00KiB
> Metadata, RAID1: total=3D4.00GiB, used=3D1.21GiB
> GlobalReserve, single: total=3D412.00MiB, used=3D0.00B
>=20
> There should be no problem in failing one disk... Or so i thought!
>=20
> btrfs dev delete /dev/sdb2 /mnt/disk/
> ERROR: error removing the device '/dev/sdb2' - unable to go below two
> devices on raid1

   dev delete is more like a reshaping operation in mdadm: it tries to
remove a device safely whilst retaining all of the redundancy
guarantees. You can't go down to one device with RAID-1 and still keep
the redundancy.

   dev delete is really for managed device removal under non-failure
conditions, not for error recovery.

> And i can't issue rebalance either since it will tell me about errors
> until the failing disk dies.
>=20
> Whats even more interesting is that i can't mount just the working
> disk - ie if the other disk
> *has* failed and is inaccessible... though, i haven't tried physically
> removing it...

   Physically removing it is the way to go (or disabling it using echo
offline >/sys/block/sda/device/state). Once you've done that, you can
mount the degraded FS with -odegraded, then either add a new device
and balance to restore the RAID-1, or balance with
-{d,m}convert=3Dsingle to drop the redundancy to single.

> mdam has fail and remove, I assume for this reason - perhaps it's
> something that should be added?

   I think there should be a btrfs dev drop, which is the fail-like
operation: tell the FS that a device is useless, and should be dropped
=66rom the array, so the FS doesn't keep trying to write to it. That's
not implemented yet, though.

   Hugo.

--=20
Hugo Mills             | Alert status mauve ocelot: Slight chance of
hugo@... carfax.org.uk | brimstone. Be prepared to make a nice cup of tea.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--1bhFRg6vL9BT9osV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV7zgsAAoJEFheFHXiqx3kF80P/08/QLR5Ks7cAACEsOfCxteE
kT7llbk/dB4VsflRFUrEypHz1MVzDnzU0E4/wBw61M+7Vo/EAXqiKy2stQI10bfv
XyQdOeCXKY13PIdaOymr9zOeOL5tbw/sk4Ce1GtCZGvefuD1IfY1+HsoIZ+nXEg3
V9SkOFw7YYP2S/eLOo8kQFJ+khdGCFYpgxYEKwQ7TmsBTXkBG6BUls48Pu/clB46
tenake/SryXYkdjr+kDXPS0+6hpL33PUcvFhSS2LDrN75ljV9SVUGzbVbDpKgzid
4damnC8E2d8hqMiKRsDYgZ0iDcOc+pIxB7fiPRtmF5uGpNO3PnpidfOngILQF9Oz
CnNFEbcfy2/ApXfeHl1ApKxNO3eno02EQK6g0LYOJJdR7opQw2L1GNT2KnYYslX3
azn7Si7C6N7drOX3U2MizIBIIgwGNQ+/Yvmn5OnyboYdAyDrO6AmfTCC25yNQsq9
/80GUfpdoo9a19kFNVLzP21gMI+fnmMs5+PowALavEYWAeOluEnGy3+U5r+Eed4s
8a7va/43Rn0cItwgoCyE/FCLMCpUKDOc+YHi+3KlyMiM+Uyg9TglH0bX4lqqysMG
R4gtZhhnE8vAwa1KAnxzcYMfKJfucsou2n6HxP/QQD5pSTDbb5rqSAOZ+oqedcd1
Lp57jOTvnuXrIrWs98E7
=qhAW
-----END PGP SIGNATURE-----

--1bhFRg6vL9BT9osV--
