Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54995 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935154AbeBMMyY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 07:54:24 -0500
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        John Ettedgui <john.ettedgui@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <CAJ3TwYTnMPVwkrZEU-=Q_Nq+9Bn0vM3z+EFC8RP=RTyaufSoqw@mail.gmail.com>
 <5cc93522-1bd2-bdc1-d5da-a11d5e4816a7@cn.fujitsu.com>
 <CAJ3TwYRpc_R-wVur0T6+Uy_aPVXTGpvp_ag1Ar9K2HoB0H1ySQ@mail.gmail.com>
 <799054c4-b4f5-2dc0-4f70-4345159d9078@cn.fujitsu.com>
 <CAJ3TwYRH8JVkuv2Hu7FYb+BSwKGrq1spx079zwOF_FO1y=9NFA@mail.gmail.com>
 <e51aaa6e-a4b9-c187-84fa-c57799865b0e@cn.fujitsu.com>
 <CAJ3TwYS6UTkWf=PNku3RG7hPrXMKz3yhk2WqCRLix4v_VwgrmA@mail.gmail.com>
 <36291cd0-64bc-8708-9e23-0aac30539785@cn.fujitsu.com>
 <CAJ3TwYQ47SVpbO1Pb-TWjhaTCCpMFFmijwTgmV8=7+1_a6_3Ww@mail.gmail.com>
 <e8d681cb-aa1b-6395-f968-38e8425ed8fb@cn.fujitsu.com>
 <CAJ3TwYRgHfCNxKwWnfWXr=w_mBo2B2AuSDeE+PgYEtn7kyAx7w@mail.gmail.com>
 <87975474-0cb9-13d7-f623-c0622b31f437@gmx.com>
 <CAJ3TwYQ-GgZCCoD07AgQ0EDtpOknt3Ta1=WNAH7sSvXO3R-u8w@mail.gmail.com>
 <a27b619e-6e39-20e6-413e-c9d5c7a90b6f@gmx.com>
 <5fc99565-b46a-a52a-b1d4-b3ce3e10c830@applied-asynchrony.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <900c77fc-6ad0-624c-6831-b8e5da636fb4@gmx.com>
Date: Tue, 13 Feb 2018 20:54:13 +0800
MIME-Version: 1.0
In-Reply-To: <5fc99565-b46a-a52a-b1d4-b3ce3e10c830@applied-asynchrony.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gkuE4NB29ABJtjHOJQ71Xl6iVgV6xeWn1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gkuE4NB29ABJtjHOJQ71Xl6iVgV6xeWn1
Content-Type: multipart/mixed; boundary="Sgw7ebCyPbSIfBYYnrBE27ijKLkWtGsbC";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
 John Ettedgui <john.ettedgui@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
 Austin S Hemmelgarn <ahferroin7@gmail.com>,
 btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <900c77fc-6ad0-624c-6831-b8e5da636fb4@gmx.com>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <CAJ3TwYSTnQfj=qmBLtnmtXQKexMMD4x=9Gk3p3anf4uF+G26kw@mail.gmail.com>
 <CAJ3TwYTnMPVwkrZEU-=Q_Nq+9Bn0vM3z+EFC8RP=RTyaufSoqw@mail.gmail.com>
 <5cc93522-1bd2-bdc1-d5da-a11d5e4816a7@cn.fujitsu.com>
 <CAJ3TwYRpc_R-wVur0T6+Uy_aPVXTGpvp_ag1Ar9K2HoB0H1ySQ@mail.gmail.com>
 <799054c4-b4f5-2dc0-4f70-4345159d9078@cn.fujitsu.com>
 <CAJ3TwYRH8JVkuv2Hu7FYb+BSwKGrq1spx079zwOF_FO1y=9NFA@mail.gmail.com>
 <e51aaa6e-a4b9-c187-84fa-c57799865b0e@cn.fujitsu.com>
 <CAJ3TwYS6UTkWf=PNku3RG7hPrXMKz3yhk2WqCRLix4v_VwgrmA@mail.gmail.com>
 <36291cd0-64bc-8708-9e23-0aac30539785@cn.fujitsu.com>
 <CAJ3TwYQ47SVpbO1Pb-TWjhaTCCpMFFmijwTgmV8=7+1_a6_3Ww@mail.gmail.com>
 <e8d681cb-aa1b-6395-f968-38e8425ed8fb@cn.fujitsu.com>
 <CAJ3TwYRgHfCNxKwWnfWXr=w_mBo2B2AuSDeE+PgYEtn7kyAx7w@mail.gmail.com>
 <87975474-0cb9-13d7-f623-c0622b31f437@gmx.com>
 <CAJ3TwYQ-GgZCCoD07AgQ0EDtpOknt3Ta1=WNAH7sSvXO3R-u8w@mail.gmail.com>
 <a27b619e-6e39-20e6-413e-c9d5c7a90b6f@gmx.com>
 <5fc99565-b46a-a52a-b1d4-b3ce3e10c830@applied-asynchrony.com>
In-Reply-To: <5fc99565-b46a-a52a-b1d4-b3ce3e10c830@applied-asynchrony.com>

--Sgw7ebCyPbSIfBYYnrBE27ijKLkWtGsbC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8813=E6=97=A5 20:26, Holger Hoffst=C3=A4tte wrot=
e:
> On 02/13/18 12:40, Qu Wenruo wrote:
>>>> The problem is not about how much space it takes, but how many exten=
ts
>>>> are here in the filesystem.
>=20
> I have no idea why btrfs' mount even needs to touch all block groups to=

> get going (which seems to be the root of the problem), but here's a
> not so crazy idea for more "mechanical sympathy". Feel free to mock
> me if this is terribly wrong or not possible. ;)
>=20
> Mounting of even large filesystems (with many extents) seems to be fine=

> on SSDS, but not so fine on rotational storage. We've heard that from
> several people with large (multi-TB) filesystems, and obviously it's
> even more terrible on 5400RPM drives because their seeks are sooo sloow=
=2E
>=20
> If the problem is that the bgs are touched/iterated in "tree order",
> would it then not be possible to sort the block groups in physical orde=
r
> before trying to load whatever mount needs to load?

This is in fact a good idea.
Make block group into its own tree.

But it will takes a lot of work to do, since we a modifying the on-disk
format.

In that case, a leaf with default leaf size (16K) can store 678 block
group items.
And that many block groups can contain data between 169G (256M metadata
size) to 1.6T (10G for max data chunk size).

And even for tens of tegas, a level-2 tree should handle it without
problem, and searching them should be quite fast.

The only problem is, I'm not sure if there will be enough developer
interesting with this idea, and this idea may have extra problems hidden.=


Thanks,
Qu

> That way the entire
> process would involve less seeking (no backward seeks for one) and the
> drive could very likely get more done during a rotation before stepping=

> further.
>=20
> cheers,
> Holger
>=20


--Sgw7ebCyPbSIfBYYnrBE27ijKLkWtGsbC--

--gkuE4NB29ABJtjHOJQ71Xl6iVgV6xeWn1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqC3/UXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhlpAf9Hlta1VTl5ctsxqn0uLuTma2G
DU5LdpnudeCUlS2Y43y4RxaCQNId1QBVT1uC5ogZjIpm6ynPRNaSXHjuDQq/a391
vdS7koBjUMvH1QQJt5brkZvam+rJqFWySZVp+qeHkAjm6G9O+3WIyr8XqzfXmIG4
Crz2a5c2INrpjSrfURNezV4mhtWquWWrIfj/Z33b7naZEsW/p+mFAB/yi6C1ooT7
dSGUX9TRp3j8CAwVjW1xoP7gMTC5PUcc2hNxcRDkfXtrRbz6VewAfNIwof3vy2I2
UMyozxOq4LGScnvr4WyyRW44LEbRPRgxj95O5y6CD9QdEvhQO4Za72VO0QZFiQ==
=AFe2
-----END PGP SIGNATURE-----

--gkuE4NB29ABJtjHOJQ71Xl6iVgV6xeWn1--
