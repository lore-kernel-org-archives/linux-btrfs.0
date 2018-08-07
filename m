Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:44677 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727224AbeHGJQ2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 05:16:28 -0400
Subject: Re: [PATCH v2 00/12] mkfs: Quota support through -R|--runtime quota
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20171107084259.22367-1-wqu@suse.com>
 <c3643f3f-da0b-0e4c-3bb5-35c09962f409@gmx.com>
 <ef21c72b-c0ca-ee15-e245-5598401817ea@gmx.com>
 <10cc122a-9bee-fd49-f030-ca5ad65bb330@gmx.com>
 <20180807070203.GA3288@fnst.localdomain>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2ebb1fcf-2bda-8f17-94f4-589753cd7609@gmx.com>
Date: Tue, 7 Aug 2018 15:03:16 +0800
MIME-Version: 1.0
In-Reply-To: <20180807070203.GA3288@fnst.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7TldyNN1HeVouKgSykLTn0OYqKh05MMUe"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7TldyNN1HeVouKgSykLTn0OYqKh05MMUe
Content-Type: multipart/mixed; boundary="QKQAhrMmHiOY2XGU6SlpslKkhROG07CvD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <2ebb1fcf-2bda-8f17-94f4-589753cd7609@gmx.com>
Subject: Re: [PATCH v2 00/12] mkfs: Quota support through -R|--runtime quota
References: <20171107084259.22367-1-wqu@suse.com>
 <c3643f3f-da0b-0e4c-3bb5-35c09962f409@gmx.com>
 <ef21c72b-c0ca-ee15-e245-5598401817ea@gmx.com>
 <10cc122a-9bee-fd49-f030-ca5ad65bb330@gmx.com>
 <20180807070203.GA3288@fnst.localdomain>
In-Reply-To: <20180807070203.GA3288@fnst.localdomain>

--QKQAhrMmHiOY2XGU6SlpslKkhROG07CvD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8807=E6=97=A5 15:02, Lu Fengqi wrote:
> On Mon, Jul 30, 2018 at 01:03:00PM +0800, Qu Wenruo wrote:
>> Ping the 3rd time?
>>
>> Or should I just rebase the patchset?
>=20
> Hi Qu
>=20
> Could you rebase this patchset? Because I want to test existing test ca=
ses
> with enabled quota, mkfs_qgroup seems to ease my workload.
>=20
No problem at all.

Rebasing now.

Thanks,
Qu


--QKQAhrMmHiOY2XGU6SlpslKkhROG07CvD--

--7TldyNN1HeVouKgSykLTn0OYqKh05MMUe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltpRDUACgkQwj2R86El
/qhXlgf+M+AL6Zi5kH41XbRN7TVxs07qTWI0G1XeuwdiFnUwguG0g6zf/hm42UNa
qRpBtgaHxDm8MCO8RAawMQQKeXKSjg/BLhHL6A/vW27NR5TvQbRpYhooo6hTkp5e
z/7B9Rzf0TFzV3vQh51JXPPsSAi6iFM/ERGlTxfGrFvwUMvIdxMC2hw3DMF1woZJ
5/MGCppCrRA1JorP4YHH8MF2tE0AvF8TrB+zrGBS5zEfZ69j/rjlFGGVjuMlwPrA
4wEdNBCaun2bjnUqhmvGVU2PSTKQuhuD/KTxXT6cTIm6P3H1jMY60bEvboiigN0v
RkPLqG8/kPrwLqe1PQMeCM+/YJZ2CQ==
=F4xB
-----END PGP SIGNATURE-----

--7TldyNN1HeVouKgSykLTn0OYqKh05MMUe--
