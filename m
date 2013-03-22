Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:48778 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab3CVGOD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 02:14:03 -0400
Date: Fri, 22 Mar 2013 12:13:56 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
Message-ID: <20130322121356.237e57e8@natsu>
In-Reply-To: <514B62A4.1030201@profihost.ag>
References: <514ABEB8.3090104@profihost.ag>
	<20130321180020.30044.84729@localhost.localdomain>
	<967ED686-7E9C-4158-80A0-D58D18818BA2@profihost.ag>
	<20130321190249.30044.79438@localhost.localdomain>
	<514B62A4.1030201@profihost.ag>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YEFXcvCfwkIe4O+WCKqVI88"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/YEFXcvCfwkIe4O+WCKqVI88
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 21 Mar 2013 20:42:28 +0100
Stefan Priebe <s.priebe@profihost.ag> wrote:

I might be wrong here, but doesn't this

> rsync: rename=20
> "/mnt/.software/kernel/linux-3.9-rc3/drivers/infiniband/hw/amso1100/.c2_a=
e.h.WEhLGP"=20
> ->=20
> ".software/kernel/linux-3.9-rc3/drivers/infiniband/hw/amso1100/c2_ae.h":=
=20

...try to move a file from=20

  "/mnt/.software/"

to

  ".software/"

(relative to current dir)??

Maybe you end up trying to rsync your array to a small root partition or
something?

> No space left on device (28)
>=20
> # btrfs filesystem df /mnt/
> Data: total=3D18.14TB, used=3D15.05TB
> System, DUP: total=3D8.00MB, used=3D1.94MB
> System: total=3D4.00MB, used=3D0.00
> Metadata, DUP: total=3D23.98GB, used=3D17.98GB
> Metadata: total=3D8.00MB, used=3D0.00
>=20
> Stefan
>=20
> Am 21.03.2013 20:02, schrieb Chris Mason:
> > Quoting Stefan Priebe - Profihost AG (2013-03-21 14:35:59)
> >> Hi Chris,
> >>
> >> Am 21.03.2013 um 19:00 schrieb Chris Mason <chris.mason@fusionio.com>:
> >>
> >>> Quoting Stefan Priebe - Profihost AG (2013-03-21 04:03:04)
> >>>> Hi,
> >>>>
> >>>> while copying a 15GB file to my btrfs volume i'm getting "No space l=
eft
> >>>> on device".
> >>>>
> >>>> Some information:
> >>>>
> >>>> # btrfs filesystem df /mnt/
> >>>> Data: total=3D18.14TB, used=3D15.05TB
> >>>> System, DUP: total=3D8.00MB, used=3D1.94MB
> >>>> System: total=3D4.00MB, used=3D0.00
> >>>> Metadata, DUP: total=3D23.98GB, used=3D17.97GB
> >>>> Metadata: total=3D8.00MB, used=3D0.00
> >>>>
> >>>> # df -h
> >>>> Filesystem             Size  Used Avail Use% Mounted on
> >>>> /dev/mapper/raid54tb1   19T   16T  3,1T  84% /mnt
> >>>>
> >>>> # btrfs fi show
> >>>> Label: none  uuid: fc23c4a8-a351-4c91-96a2-ee6abeffe59a
> >>>>         Total devices 1 FS bytes used 15.07TB
> >>>>         devid    1 size 18.19TB used 18.19TB path /dev/dm-3
> >>>>
> >>>> # btrfs fi balance start -dusage=3D5 /mnt/
> >>>> Done, had to relocate 0 out of 18604 chunks
> >>>>
> >>>> What wrong here? What is about the last 3TB?
> >>>
> >>> Which kernel are you running?
> >>>
> >>> -chris
> >>
> >> vanilla 3.8.3.
> >
> > Ok, with the 3.9 merge window Josef changed how we do the reservations.
> > Are you able to try a slightly more experimental kernel?
> >
> > -chris
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
With respect,
Roman

--Sig_/YEFXcvCfwkIe4O+WCKqVI88
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFL9qQACgkQTLKSvz+PZwjm4ACgkJesJiaVnB69mxMOTj4n8tBj
IwYAnjYvVSvp72z06v8zbcMBK8XOzCWC
=SG3s
-----END PGP SIGNATURE-----

--Sig_/YEFXcvCfwkIe4O+WCKqVI88--
