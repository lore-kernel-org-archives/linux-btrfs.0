Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:41363 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966385AbeF1O6I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 10:58:08 -0400
Subject: Re: call trace: WARNING: at
 /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <50443c666dc4509d74f9f23d7012080845a20940.camel@scientia.net>
 <f9d51250-28aa-318e-502f-c5b3526969a0@gmx.com>
 <f86948875cb746c6a8c74526913017052153d1bf.camel@scientia.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <43a3fb8f-d8a8-7e2f-a143-207bd3ba8c74@gmx.com>
Date: Thu, 28 Jun 2018 22:58:01 +0800
MIME-Version: 1.0
In-Reply-To: <f86948875cb746c6a8c74526913017052153d1bf.camel@scientia.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0EZ0jTBFC6gVC6GeNsU7qU5vsTn0lWuil"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0EZ0jTBFC6gVC6GeNsU7qU5vsTn0lWuil
Content-Type: multipart/mixed; boundary="Vy5SmcnY7aREMHRT6IOW7vz0fbwD8KihK";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>,
 linux-btrfs@vger.kernel.org
Message-ID: <43a3fb8f-d8a8-7e2f-a143-207bd3ba8c74@gmx.com>
Subject: Re: call trace: WARNING: at
 /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device
References: <50443c666dc4509d74f9f23d7012080845a20940.camel@scientia.net>
 <f9d51250-28aa-318e-502f-c5b3526969a0@gmx.com>
 <f86948875cb746c6a8c74526913017052153d1bf.camel@scientia.net>
In-Reply-To: <f86948875cb746c6a8c74526913017052153d1bf.camel@scientia.net>

--Vy5SmcnY7aREMHRT6IOW7vz0fbwD8KihK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 22:17, Christoph Anton Mitterer wr=
ote:
> On Thu, 2018-06-28 at 22:09 +0800, Qu Wenruo wrote:
>>> [   72.168662] WARNING: CPU: 0 PID: 242 at /build/linux-
>>> uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565
>>> btrfs_update_device+0x1b2/0x1c0It
>> looks like it's the old WARN_ON() for unaligned device size.
>> Would you please verify if it is the case?
>=20
> # blockdev --getsize64 /dev/sdb2 /dev/sda2
> 999131127296
> 999131127296
>=20
>=20
> Since getsize64 returns bytes and not sectors, I suppose it would need
> to be aligned to 1024 by the least?
>=20
> 999131127296 / 1024 =3D 975713991,5
>=20
> So it's not.

So it's the case.

>=20
>=20
>> If so, "btrfs rescue fix-device-size" should handle it pretty well.
>=20
> I guess this needs to be done with the fs unmounted?

Yep.

> Anything to consider since I have RAID1 (except from running it on both=

> devices)?

Nothing special. Btrfs-progs will handle it pretty well.

>=20
>=20
> Also, it's a bit strange that this error occurred never before (though
> the btrfs-restore manpage says the kernel would check for this since
> 4.11).

Because the WARN_ON() is newly added.

>=20
> It would further be nice if btrfs-check would warn about this.

Yep, latest will warn about it, and --repair can also fix it too.

Thanks,
Qu

>=20
>=20
> Thanks,
> Chris.
>=20


--Vy5SmcnY7aREMHRT6IOW7vz0fbwD8KihK--

--0EZ0jTBFC6gVC6GeNsU7qU5vsTn0lWuil
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls093kACgkQwj2R86El
/qibhAgAgN7fuyH0ICcjNvUHq6mbrx7JSUK1hXISfjE2ngTHQdUvuMEvEVEcgyz5
Hznwc50iIbKXb5pGrw3mIpWMI854cm575DNwmw81dqiwsZBxNq0u4oHyjMc88Y6P
jEdxFB22uRgBSn2940bnSrWJOUNTiSOqtwxy1zktw7hYuA+RkrLs9rNUerYBY95K
97966jqwLjVAWGLmI4BeeFOgRk0UNcwdveGfRZkJc9nTxoM7pKPpEaro3TXzI3wT
tDT37Mfy4SvTcKVptwLMNx98LlMzvVpPowrYOcl6AgAzesiNgGCOPa5FXF7fwVQT
C7kSsaiA3fxqIDafwhzES0fKg61w7g==
=z6wZ
-----END PGP SIGNATURE-----

--0EZ0jTBFC6gVC6GeNsU7qU5vsTn0lWuil--
