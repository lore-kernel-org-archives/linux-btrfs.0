Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:35369 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750832AbeBIHeW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Feb 2018 02:34:22 -0500
Subject: Re: segmentation fault in btrfs tool v4.15
To: Ralph Gauges <ralphgauges@googlemail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <10214501-3b8e-7f9b-11d6-14fb75da07a5@googlemail.com>
 <bda6e11b-c978-ce90-70d0-2ac1f7210e3d@gmx.com>
 <15274509-75d4-af47-46ea-8ac048b58ba9@googlemail.com>
 <31d87507-982c-b735-9f3a-9fbad4d247e2@gmx.com>
 <c525bb95-1a17-c01e-4c15-f89a6cc68c6e@googlemail.com>
 <6bb438c5-811d-d7b8-f551-a1a08be321c5@gmx.com>
 <b0b40b12-1130-ad31-6ff0-e0b674a71691@googlemail.com>
 <0f66e50a-520d-f565-0d2d-2411d480da05@gmx.com>
 <adbe7eae-268d-fffd-4bc4-e724e26ab584@googlemail.com>
 <bfb10542-2bd3-5926-f8ac-036eef890a29@gmx.com>
 <0e0755f1-b97e-1256-5a7f-231c2e851b1b@googlemail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <54be9660-0236-576c-87e7-f07862a02244@gmx.com>
Date: Fri, 9 Feb 2018 15:34:16 +0800
MIME-Version: 1.0
In-Reply-To: <0e0755f1-b97e-1256-5a7f-231c2e851b1b@googlemail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VlGoGuLwP2BY2ygf6pRvY0Sfa10TU6M58"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VlGoGuLwP2BY2ygf6pRvY0Sfa10TU6M58
Content-Type: multipart/mixed; boundary="zT2xXfuBDf9MCOkhCAuO4XfzzQ99hAJyD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Ralph Gauges <ralphgauges@googlemail.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <54be9660-0236-576c-87e7-f07862a02244@gmx.com>
Subject: Re: segmentation fault in btrfs tool v4.15
References: <10214501-3b8e-7f9b-11d6-14fb75da07a5@googlemail.com>
 <bda6e11b-c978-ce90-70d0-2ac1f7210e3d@gmx.com>
 <15274509-75d4-af47-46ea-8ac048b58ba9@googlemail.com>
 <31d87507-982c-b735-9f3a-9fbad4d247e2@gmx.com>
 <c525bb95-1a17-c01e-4c15-f89a6cc68c6e@googlemail.com>
 <6bb438c5-811d-d7b8-f551-a1a08be321c5@gmx.com>
 <b0b40b12-1130-ad31-6ff0-e0b674a71691@googlemail.com>
 <0f66e50a-520d-f565-0d2d-2411d480da05@gmx.com>
 <adbe7eae-268d-fffd-4bc4-e724e26ab584@googlemail.com>
 <bfb10542-2bd3-5926-f8ac-036eef890a29@gmx.com>
 <0e0755f1-b97e-1256-5a7f-231c2e851b1b@googlemail.com>
In-Reply-To: <0e0755f1-b97e-1256-5a7f-231c2e851b1b@googlemail.com>

--zT2xXfuBDf9MCOkhCAuO4XfzzQ99hAJyD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8809=E6=97=A5 15:23, Ralph Gauges wrote:
> Hi Qu,
>=20
> I applied the patch to the sources of v4.15 and ran it in gdb. This is
> the result.
>=20
> (gdb) set args check /dev/sdf1
> (gdb) run
> Starting program: /home/gauges/Applications/bin/btrfs check /dev/sdf1
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.=
1".
> parent transid verify failed on 266195058688 wanted 1857 found 1864
> parent transid verify failed on 266195058688 wanted 1857 found 1864
> parent transid verify failed on 266195058688 wanted 1857 found 1864
> parent transid verify failed on 266195058688 wanted 1857 found 1864
> Ignoring transid failure
> ERROR: child eb corrupted: parent bytenr=3D247283269632 item=3D23 paren=
t
> level=3D1 child level=3D2
> ERROR: cannot open file system
> [Inferior 1 (process 7149) exited with code 01]
>=20
>=20
> So obviously it does not crash any more. Thanks.
> Since you are an expert on the btrfs filesystem, any hints as to how I
> could fix my backup
> partition?

Guys in mail list may have better ideas, CCed to mail list.

In fact the problem all happens in extent tree, may be we could salvage
something by RO mount it?

If kernel can't mount it even RO, then "btrfs restore" may be your last
chance.

Thanks,
Qu

> This output from btrfs seems to suggest that "btrfs check"
> can't handle this error?!
> Or this this last error something else that didn't show up so far
> because of the segfault?
>=20
> Thanks
>=20
> Ralph
>=20
>=20


--zT2xXfuBDf9MCOkhCAuO4XfzzQ99hAJyD--

--VlGoGuLwP2BY2ygf6pRvY0Sfa10TU6M58
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlp9TvgXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhPyggAolX1ppx+8NFS76nSlUBlQQ4+
Fh9zMdShJmPjmoljk+LL7DhHszKOqsOVHJ0kTM2iXYAsGidlCk0d21wSAM/6bwW9
LO91TvXN87oG0CrLcZj3MY9iNXyW2OWsFZA4fjJyHjStLVnq9ZDUb8mnZPbNS9Hg
u7IzsPc+9RwVOeN2CrHmhIRuMHjjELqOG/QdHjPd1BaBGsSch3LENczW4TiWT8j0
zNjnDfzSnQgfUFIzSuMRk+eRF2PdM5Cr7cARnnzqYaLn9yj/pBDWbmgoPf/21dch
AkCSxYt+Nd4CdWn+6zGO6zKFh7VISLn2sw6ANLnPRX0zfZG8uH6kpVVDLdPs4w==
=L2G/
-----END PGP SIGNATURE-----

--VlGoGuLwP2BY2ygf6pRvY0Sfa10TU6M58--
