Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:42010 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaBIJUE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Feb 2014 04:20:04 -0500
Date: Sun, 9 Feb 2014 15:20:00 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Provide a better free space estimate on RAID1
Message-ID: <20140209152000.209756de@natsu>
In-Reply-To: <pan$e196e$601e36f4$65c8817c$b6141c66@cox.net>
References: <20140206021516.304732cd@natsu>
	<52F3EED4.7030603@fb.com>
	<agsfsa-mks.ln1@hurikhan77.spdns.de>
	<20140208173310.1f90af3b@natsu>
	<20140208114634.GH6490@carfax.org.uk>
	<cikisa-qf7.ln1@hurikhan77.spdns.de>
	<20140209041050.529ff6f9@natsu>
	<pan$e196e$601e36f4$65c8817c$b6141c66@cox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UdCZoBC64Oa/_lg/OoopJ/_"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/UdCZoBC64Oa/_lg/OoopJ/_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 9 Feb 2014 06:38:53 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> RAID or multi-device filesystems aren't 1970s features and break 1970s=20
> behavior and the assumptions associated with it.  If you're not prepared=
=20
> to deal with those broken assumptions, don't.  Use mdraid or dmraid or lv=
m=20
> or whatever to combine your multiple devices into one logical devices as=
=20
> presented, and put your filesystem (either traditional filesystem, or=20
> even btrfs using traditional single-device functionality) on top of the=20
> single device the layer beneath the filesystem presents.  Problem solved!=
=20
> =3D:^)
>=20
> Note that df only lists a single device as well, not the multiple=20
> component devices of the filesystem.  That's broken functionality by your=
=20
> definition, too, and again, using some other layer like lvm or mdraid to=
=20
> present multiple devices as a single virtual device, with a traditional=20
> single-device filesystem layout on top of that single device... solves=20
> the problem!

No reason BTRFS can't work well in a similar simplistic usage scenario.

You seem to insist there is no way around it being "too flexible for its own
good", but all those advanced features absolutely don't *have* to get in the
way of everyday usage for users who don't require them.

> Meanwhile, what I've done here is use one of df's commandline options to=
=20
> set its block size to 2 MiB, and further used bash's alias functionality=
=20
> to setup an alias accordingly:
>=20
> alias df=3D'df -B2M'
>=20
> $ df /h
> Filesystem     2M-blocks  Used Available Use% Mounted on
> /dev/sda6          20480 12186      7909  61% /h
>=20
> $ sudo btrfs fi show /h
> Label: hm0238gcnx+35l0  uuid: ce23242a-b0a9-423f-a9c3-7db2729f48d6
>         Total devices 2 FS bytes used 11.90GiB
>         devid    1 size 20.00GiB used 14.78GiB path /dev/sda6
>         devid    2 size 20.00GiB used 14.78GiB path /dev/sdb6
>=20
> $ sudo btrfs fi df /h
> Data, RAID1: total=3D14.00GiB, used=3D11.49GiB
> System, RAID1: total=3D32.00MiB, used=3D16.00KiB
> Metadata, RAID1: total=3D768.00MiB, used=3D414.94MiB
>=20
>=20
> On btrfs such as the above I can read the 2M blocks as 1M and be happy.
>
> On btrfs such as my /boot, which aren't raid1 (I have two separate=20
> /boots, one on each device, with grub2 configured separately for each to=
=20
> provide a backup), or if I df my media partitions still on reiserfs on=20
> the old spinning rust, I can either double the figures DF gives me, or=20
> add a second -B option at the CLI, overriding the aliased option.

Congratulations, you broke your df readings on all other filesystems to fix
them on btrfs.

> If I wanted something fully automated, it'd be easy enough to setup a=20
> script that checked what filesystem I was df-ing, matched that against a=
=20
> table of filesystems to preferred df block sizes, and supplied the=20
> appropriate -BxX option accordingly.

I am not sure this would work well in the network share scenario described
earlier, with clients which in the real world are largely Windows-based.

--=20
With respect,
Roman

--Sig_/UdCZoBC64Oa/_lg/OoopJ/_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlL3SEAACgkQTLKSvz+PZwhOoQCfSVmANkaK4ChPX0Bo2RSiOepr
OecAnA6yMlYRWdDNMX9GtD15b03/aW2f
=jRWk
-----END PGP SIGNATURE-----

--Sig_/UdCZoBC64Oa/_lg/OoopJ/_--
