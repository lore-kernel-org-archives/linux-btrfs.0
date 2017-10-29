Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:65134 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751221AbdJ2KDL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Oct 2017 06:03:11 -0400
Subject: Re: USB upgrade fun
To: Kai Hendry <hendry@iki.fi>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1507456690.745489.1131538472.25270157@webmail.messagingengine.com>
 <CAJCQCtRnbz5WGqZEO3b8a+3B2gDbG_zioqWEVoJz_dD0SB=6Ww@mail.gmail.com>
 <0a3e71f7-1a8e-9a4f-7470-4c5cc2fb11a0@gmail.com>
 <1507858974.1236555.1137202920.267B449B@webmail.messagingengine.com>
 <1509174195.600847.1153723936.0D8751F2@webmail.messagingengine.com>
 <8cff4fc5-6a33-e076-bfdb-d40dca8023ed@gmx.com>
 <1509247255.1470208.1154302000.6571EE79@webmail.messagingengine.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a92d6d6d-e059-63e3-ea67-6fe192291fee@gmx.com>
Date: Sun, 29 Oct 2017 18:02:56 +0800
MIME-Version: 1.0
In-Reply-To: <1509247255.1470208.1154302000.6571EE79@webmail.messagingengine.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C1J9PUsKNU3gu9ujVLuXmk2aa7XSl01o0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C1J9PUsKNU3gu9ujVLuXmk2aa7XSl01o0
Content-Type: multipart/mixed; boundary="7b8qsAOM2KDsfOUKa2ePdDS3nB1emlIMg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Kai Hendry <hendry@iki.fi>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <a92d6d6d-e059-63e3-ea67-6fe192291fee@gmx.com>
Subject: Re: USB upgrade fun
References: <1507456690.745489.1131538472.25270157@webmail.messagingengine.com>
 <CAJCQCtRnbz5WGqZEO3b8a+3B2gDbG_zioqWEVoJz_dD0SB=6Ww@mail.gmail.com>
 <0a3e71f7-1a8e-9a4f-7470-4c5cc2fb11a0@gmail.com>
 <1507858974.1236555.1137202920.267B449B@webmail.messagingengine.com>
 <1509174195.600847.1153723936.0D8751F2@webmail.messagingengine.com>
 <8cff4fc5-6a33-e076-bfdb-d40dca8023ed@gmx.com>
 <1509247255.1470208.1154302000.6571EE79@webmail.messagingengine.com>
In-Reply-To: <1509247255.1470208.1154302000.6571EE79@webmail.messagingengine.com>

--7b8qsAOM2KDsfOUKa2ePdDS3nB1emlIMg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8829=E6=97=A5 11:20, Kai Hendry wrote:
> On Sat, 28 Oct 2017, at 03:58 PM, Qu Wenruo wrote:
>> Don't get confused with the name, to use "fix-dev-size" you need to ru=
n
>> "btrfs rescue fix-dev-size"
>=20
> [hendry@nuc btrfs-progs]$ sudo ./btrfs rescue fix-device-size /dev/sdc1=

> warning, device 2 is missing
> ERROR: devid 2 is missing or not writeable
> ERROR: fixing device size needs all device(s) present and writeable
> [hendry@nuc btrfs-progs]$ lsblk -f
> NAME   FSTYPE LABEL    UUID                                 MOUNTPOINT
> sda
> =E2=94=9C=E2=94=80sda1 vfat            0C95-8576                       =
     /boot
> =E2=94=94=E2=94=80sda2 btrfs           c5f98288-5ab3-4236-b00e-f2cd15c0=
616d /
> sdb
> sdc
> =E2=94=94=E2=94=80sdc1 btrfs  extraid1 5cab2a4a-e282-4931-b178-bec4c73c=
df77
> [hendry@nuc btrfs-progs]$ lsblk -f
> NAME   FSTYPE LABEL    UUID                                 MOUNTPOINT
> sda
> =E2=94=9C=E2=94=80sda1 vfat            0C95-8576                       =
     /boot
> =E2=94=94=E2=94=80sda2 btrfs           c5f98288-5ab3-4236-b00e-f2cd15c0=
616d /
> sdb
> =E2=94=94=E2=94=80sdb1 btrfs  extraid1 5cab2a4a-e282-4931-b178-bec4c73c=
df77
> sdc
> =E2=94=94=E2=94=80sdc1 btrfs  extraid1 5cab2a4a-e282-4931-b178-bec4c73c=
df77
> [hendry@nuc btrfs-progs]$ sudo ./btrfs rescue fix-device-size /dev/sdc1=

> Couldn't setup extent tree
> Couldn't setup device tree
> ERROR: could not open btrfs
> [hendry@nuc btrfs-progs]$ sudo ./btrfs rescue fix-device-size /dev/sdb1=

> leaf parent key incorrect 1320477425664
> ERROR: could not open btrfs

Maybe superblocks of both devices have something wrong.

> [hendry@nuc btrfs-progs]$ sudo mount -o degraded /dev/sdb1 /mnt/raid1/
> mount: /mnt/raid1: wrong fs type, bad option, bad superblock on
> /dev/sdb1, missing codepage or helper program, or other error.
>=20
>=20
> Still unable to mount. Damn. Maybe I'm chasing a red herring? Here are
> the relevant kernel logs:
>=20
> Oct 29 10:56:45 nuc kernel: sd 2:0:0:0: [sdb] Attached SCSI disk
> Oct 29 10:57:32 nuc kernel: BTRFS info (device sdc1): allowing degraded=

> mounts
> Oct 29 10:57:32 nuc kernel: BTRFS info (device sdc1): disk space cachin=
g
> is enabled
> Oct 29 10:57:32 nuc kernel: BTRFS info (device sdc1): has skinny extent=
s
> Oct 29 10:57:33 nuc kernel: BTRFS error (device sdc1): super_total_byte=
s
> 4000795746304 mismatch with fs_devices total_rw_bytes 4000795749888
> Oct 29 10:57:33 nuc kernel: BTRFS error (device sdc1): failed to read
> chunk tree: -22
> Oct 29 10:57:33 nuc kernel: BTRFS error (device sdc1): open_ctree faile=
d
>=20
>=20
> Nonetheless if I reboot to 4.4, I can still mount. However my root is
> bizarrely out of space or inodes so journalctl et al is unusable.

Can 4.4 mount it rw?
If so, mount it, do minimal write like creating an empty file, to update
both superblock copies, and then try fix-device-size.

Thanks,
Qu

>=20
>=20
> Kind regards,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--7b8qsAOM2KDsfOUKa2ePdDS3nB1emlIMg--

--C1J9PUsKNU3gu9ujVLuXmk2aa7XSl01o0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln1p1AXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg5aQgAigTGgpkKSWE4/65H9RKp1VrT
wrfSU6R9VCyLjh5Ct1J/FCkzU5vg57pKLebRkowljLENWHSCmPwekpdkZXWz60kb
B4b9gZ9tEfyYlr4Ho01P6Ko2oheckWLMT6E2EzbFE8SBlUNDG9fb1TMJQhzrm5Rq
yNcsMop5xfZEAP0s0ZdaT77tCzJ/f/EEgJnLj4lwuF5qxSy2prRuh/zfW1eqXvZI
JFljoRJCugu6ZBBVFvqzsIpsNa1PagHt1Qah3r8+/EKiWUhuJopvlHxpGq9x0+/X
FztQQ8+o7xab/+7Hk5tWph30La7sRRIYDsa0ii1UIJ9QdfLaH2QlaZZAoGqFJQ==
=yWf7
-----END PGP SIGNATURE-----

--C1J9PUsKNU3gu9ujVLuXmk2aa7XSl01o0--
