Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:39543 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965506AbeF1OJ4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 10:09:56 -0400
Subject: Re: call trace: WARNING: at
 /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <50443c666dc4509d74f9f23d7012080845a20940.camel@scientia.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f9d51250-28aa-318e-502f-c5b3526969a0@gmx.com>
Date: Thu, 28 Jun 2018 22:09:48 +0800
MIME-Version: 1.0
In-Reply-To: <50443c666dc4509d74f9f23d7012080845a20940.camel@scientia.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nWaWsdkhznTdyz8z8sImyCx4WSme7BpVu"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nWaWsdkhznTdyz8z8sImyCx4WSme7BpVu
Content-Type: multipart/mixed; boundary="v9soa3XLbNGOWy5kV6CAdXhClIqXMX1Ji";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>,
 linux-btrfs@vger.kernel.org
Message-ID: <f9d51250-28aa-318e-502f-c5b3526969a0@gmx.com>
Subject: Re: call trace: WARNING: at
 /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device
References: <50443c666dc4509d74f9f23d7012080845a20940.camel@scientia.net>
In-Reply-To: <50443c666dc4509d74f9f23d7012080845a20940.camel@scientia.net>

--v9soa3XLbNGOWy5kV6CAdXhClIqXMX1Ji
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 21:19, Christoph Anton Mitterer wr=
ote:
> Hey.
>=20
> On a 4.16.16 kernel with a RAID 1 btrfs I got the following messages
> since today.
>=20
> Data seems still to be readable (correctly)... and there are no other
> errors (like SATA errors) in the kernel log.
>=20
> Any idea what these could mean?
>=20
> Thanks,
> Chris.
>=20
>=20
> [   72.168662] WARNING: CPU: 0 PID: 242 at /build/linux-uwVqDp/linux-4.=
16.16/fs/btrfs/ctree.h:1565 btrfs_update_device+0x1b2/0x1c0It looks like =
it's the old WARN_ON() for unaligned device size.

Would you please verify if it is the case?
If so, "btrfs rescue fix-device-size" should handle it pretty well.

Thanks,
Qu


--v9soa3XLbNGOWy5kV6CAdXhClIqXMX1Ji--

--nWaWsdkhznTdyz8z8sImyCx4WSme7BpVu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls07CwACgkQwj2R86El
/qhGbAgAqKfrNFrlIi8P3ZmJV9j7amX/1FNxMgSKI55OgvmNrs0G4W2hUMorZo6R
nX0vq1Q9erNgwJtNRICWb+wi9r+4efIoTPo/6tX05kZG14qb43/rzoL3doBQEnPv
uDZvZX29QK3pXVTGkIcvlx4R5izZGfNJAYPYBBkRxmNoj/sA3K9f/VpVJep6Ee4A
39SdOHlRbI9Wpteds2NrSYbrMg3duVFO04QiGtpedsuMCiFLAYkR6Q3F8Xs3Wy5s
lDXUzlE9poqo5E5VUB0EUEspehEoE62Q/kj/TNxptXecJn8n5y2G5ovT7+xR4OYc
z02/VTDg58gI0IKbdxRbM2vlKdSSgg==
=WjMQ
-----END PGP SIGNATURE-----

--nWaWsdkhznTdyz8z8sImyCx4WSme7BpVu--
