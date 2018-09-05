Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:46103 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbeIEFxK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Sep 2018 01:53:10 -0400
Subject: Re: RAID1 & BTRFS critical (device sda2): corrupt leaf, bad key order
To: Chris Murphy <lists@colorremedies.com>,
        Etienne Champetier <champetier.etienne@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAOdf3gp5RLHxSqhFjjOtNaGpDPvK+UO9eGh+UmmnPxXNa+v-Qg@mail.gmail.com>
 <3374b776-071f-ec7f-f5ad-58d0e7dc3059@gmx.com>
 <CAOdf3goVwcAwKXhNDcO0va-PJFu0mAWbBUeu-yQWkb-2SNPnxQ@mail.gmail.com>
 <43e5b6dc-a963-6d67-732f-c13c2f5abc78@gmx.com>
 <CAOdf3gqtbGJD29sYCOgL4+RC3a5ypvUbXP=F4r+pVDa_D+bCjg@mail.gmail.com>
 <CAJCQCtR_UmeksUjVKx3SeDJEttg=QHtW6oeAjp0W1Ov8XUsbvg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <af2f5b6a-f0f5-1223-700f-98c479ddb073@gmx.com>
Date: Wed, 5 Sep 2018 09:25:11 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR_UmeksUjVKx3SeDJEttg=QHtW6oeAjp0W1Ov8XUsbvg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qfCEUUVmttLm3U7OwBo2lJyiDWOZbLyIQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qfCEUUVmttLm3U7OwBo2lJyiDWOZbLyIQ
Content-Type: multipart/mixed; boundary="x9uW2a65fGXswBjm6WaFMfgP96u5nsaxn";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>,
 Etienne Champetier <champetier.etienne@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <af2f5b6a-f0f5-1223-700f-98c479ddb073@gmx.com>
Subject: Re: RAID1 & BTRFS critical (device sda2): corrupt leaf, bad key order
References: <CAOdf3gp5RLHxSqhFjjOtNaGpDPvK+UO9eGh+UmmnPxXNa+v-Qg@mail.gmail.com>
 <3374b776-071f-ec7f-f5ad-58d0e7dc3059@gmx.com>
 <CAOdf3goVwcAwKXhNDcO0va-PJFu0mAWbBUeu-yQWkb-2SNPnxQ@mail.gmail.com>
 <43e5b6dc-a963-6d67-732f-c13c2f5abc78@gmx.com>
 <CAOdf3gqtbGJD29sYCOgL4+RC3a5ypvUbXP=F4r+pVDa_D+bCjg@mail.gmail.com>
 <CAJCQCtR_UmeksUjVKx3SeDJEttg=QHtW6oeAjp0W1Ov8XUsbvg@mail.gmail.com>
In-Reply-To: <CAJCQCtR_UmeksUjVKx3SeDJEttg=QHtW6oeAjp0W1Ov8XUsbvg@mail.gmail.com>

--x9uW2a65fGXswBjm6WaFMfgP96u5nsaxn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/5 =E4=B8=8A=E5=8D=884:37, Chris Murphy wrote:
> On Tue, Sep 4, 2018 at 10:22 AM, Etienne Champetier
> <champetier.etienne@gmail.com> wrote:
>=20
>> Do you have a procedure to copy all subvolumes & skip error ? (I have
>> ~200 snapshots)
>=20
> If they're already read-only snapshots, then script an iteration of
> btrfs send receive to a new volume.

Doesn't simple "cp -r" work here?
(If the important thing is data, not the subvolume layout).

Thanks,
Qu

>=20
> Btrfs seed-sprout would be ideal, however in this case I don't think
> can help because a.) it's temporarily one file system, which could
> mean the corruption is inherited; and b.) I'm not sure it's multiple
> device aware, so either the btrfs-tune -S1 might fail on 2+ device
> Btrfs volumes, or possibly it insists on a two device sprout in order
> to replicate a two device seed.
>=20
> If they're not already read-only, it's tricky because it sounds like
> mounting rw is possibly risky, and taking read only snapshots might
> fail anyway. There is no way to make read only snapshots unless the
> volume can be written to; and no way to force a rw subvolume to be
> treated as if it were read only even if the volume is mounted read
> only. And it takes a read only subvolume for send to work.
>=20
>=20


--x9uW2a65fGXswBjm6WaFMfgP96u5nsaxn--

--qfCEUUVmttLm3U7OwBo2lJyiDWOZbLyIQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluPMHcACgkQwj2R86El
/qgc9gf9GFHBFmF9qVu1gSRNAHz/BpEvFDpX0PndMUDLdJvXrrx63AghXP17OMe6
+BmFQ5HC3BdfoZbfZxorkuZh+ayDx6/pQnBa1QNIgzLiV6FAKO5UmrAEhDjrCw5n
wZTeLvKp5UrTXVWuVvpeMm3YSnnMiZrP3RCULLRfuNPcQkPwbyFIB3NSIWnnL7oU
X83B7f0qB+IUFGOX5XBQs5SsEBg++2/gVnEk0FHCwz5K3+mFtd16lgLIfWmVFsSd
TQtjtf76gnAvXCRKBFvBspIj11dhM9JXV89dbdozzxq2Q7RCjzK3ceR2nO39bgtb
CWsP79uCvPbR4uXQ4DENHQrChepFPw==
=RM19
-----END PGP SIGNATURE-----

--qfCEUUVmttLm3U7OwBo2lJyiDWOZbLyIQ--
