Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58089 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932454AbcKBJMw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Nov 2016 05:12:52 -0400
Date: Wed, 2 Nov 2016 09:12:49 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christian =?iso-8859-1?Q?V=F6lker?= <cvoelker@knebb.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Resizing BTRFS - raw partition
Message-ID: <20161102091249.GL16645@carfax.org.uk>
References: <92e3c63e-0301-7a25-7c56-56447a1948cc@knebb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ai3I8gwHc37+ASRI"
In-Reply-To: <92e3c63e-0301-7a25-7c56-56447a1948cc@knebb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ai3I8gwHc37+ASRI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 02, 2016 at 09:58:41AM +0100, Christian V=F6lker wrote:
> Hi all,
>=20
> I am using btrfs as follows:
> root@srv:/srv# btrfs filesystem show
> Label: none  uuid: c8f24351-ddc4-4866-843c-4e95fcb498d4
>         Total devices 2 FS bytes used 1005.37GB
>         devid    2 size 1.00TB used 1023.98GB path /dev/sdc
>         devid    1 size 1.46TB used 1.00TB path /dev/sdb
>=20
> Btrfs Btrfs v0.19

   That's positively antique. If your kernel is anything close to the
same age, this experience with btrfs is probably going to be extremely
painful for you.

> It is running inside a virtual machines running on VMware ESXi. I
> increased both virtual disks to 1.5TB now. I did a scsi-rescan and fdisk
> -l tells me the new size:
> Disk /dev/sdb: 1610.6 GB, 1610612736000 bytes
> Disk /dev/sdc: 1610.6 GB, 1610612736000 bytes
>=20
> There are no partitions created on the disks, just raw devices used for
> BTRFS. I found several sites where they resized a btrfs filesystem based
> on LVM and the new size was immediately recognized. But how to do on raw
> partitions?

   Than those sites are mistaken. :)

> How do I tell btrfs the devices have been resized?
> I did not find a rescan command. btrfs scan does not change anything.=20
> Do I really have to reboot?

   btrfs fi resize <devid>:max /mountpoint

   btrfs dev scan is just used to tell the kernel which devices
contain [parts of] which btrfs filesystems.

   Hugo.

--=20
Hugo Mills             | In one respect at least, the Martians are a happy
hugo@... carfax.org.uk | people: they have no lawyers
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                       John Carter, A Princess of M=
ars

--ai3I8gwHc37+ASRI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYGa4RAAoJEFheFHXiqx3kKh4QAJOS+cbFFlJEW4OELo6Tp4Qo
mn/F9orDBXVVb2vAiyk6P1DsI2WPN/8Fewla1p4tF/FDyIwDgD67OffNAjHqmiIO
JvB+lleq0Rz3MGr5/0icFLEyfw0aXFo+86XU54QJTQbsLMpQ7lyfLcEF1GiW55QI
zDTXUTWIs8BNSN5LRDRei4XTOSrUmJuU25EmX4z4M+X8WZ7ggacHyoST11iPuhvh
kZJsbv3IpBPLKT710T/MkkLAI7K0Gnsv5tQjOaurYlAMUi86AnXPL1pcroRv4p4y
GhPIU9tj3rclsmcmFvMc81CTDEoO9zDAwykvA4tXoYJzdCk+TMCoUGElgOj1Xt8b
jt9z4YZ/SerSyYJQN9uscJdF2IjAsAIeor+6mR85Sd5qyZZBJCHdlzgKW7XnposC
UmK75NCmIP7eRM1F7UKo0ZtSAYuo8OEMNoXxCEDcEYjzhyLxmAppOs1z3i7IvqXa
OxZ6nYEpSurMml9wQNqdZQHH49xwXOlrTXGaJGDnDf/LDCKSjj9yXdUH3Sre8tAo
JRO4ddJK9RItORcv5ERyWbp8c7aYYOfDDZlWIsdvpd7oQSCkP6cOF2jtQKFNQu2A
HSHzZ1V0nDgpB3HwQmoBqSBJ9Ify8yayLmup18ZmvRF7c7bHSCVr13g487cxOBuc
8BQaznhaKlUGrhzaz50B
=VykP
-----END PGP SIGNATURE-----

--ai3I8gwHc37+ASRI--
