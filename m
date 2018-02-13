Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:41882 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934974AbeBMM1A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 07:27:00 -0500
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        John Ettedgui <john.ettedgui@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
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
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <5fc99565-b46a-a52a-b1d4-b3ce3e10c830@applied-asynchrony.com>
Date: Tue, 13 Feb 2018 13:26:56 +0100
MIME-Version: 1.0
In-Reply-To: <a27b619e-6e39-20e6-413e-c9d5c7a90b6f@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="iiFlpjhtfq5MVNRHsU35YqDfLjX38XXCf"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iiFlpjhtfq5MVNRHsU35YqDfLjX38XXCf
Content-Type: multipart/mixed; boundary="Cf96xS65fTyJAU8wJ71w8ATtNl1CZ3Zes";
 protected-headers="v1"
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
 John Ettedgui <john.ettedgui@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
 Austin S Hemmelgarn <ahferroin7@gmail.com>,
 btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <5fc99565-b46a-a52a-b1d4-b3ce3e10c830@applied-asynchrony.com>
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
In-Reply-To: <a27b619e-6e39-20e6-413e-c9d5c7a90b6f@gmx.com>

--Cf96xS65fTyJAU8wJ71w8ATtNl1CZ3Zes
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 02/13/18 12:40, Qu Wenruo wrote:
>>> The problem is not about how much space it takes, but how many extent=
s
>>> are here in the filesystem.

I have no idea why btrfs' mount even needs to touch all block groups to
get going (which seems to be the root of the problem), but here's a
not so crazy idea for more "mechanical sympathy". Feel free to mock
me if this is terribly wrong or not possible. ;)

Mounting of even large filesystems (with many extents) seems to be fine
on SSDS, but not so fine on rotational storage. We've heard that from
several people with large (multi-TB) filesystems, and obviously it's
even more terrible on 5400RPM drives because their seeks are sooo sloow.

If the problem is that the bgs are touched/iterated in "tree order",
would it then not be possible to sort the block groups in physical order
before trying to load whatever mount needs to load? That way the entire
process would involve less seeking (no backward seeks for one) and the
drive could very likely get more done during a rotation before stepping
further.

cheers,
Holger


--Cf96xS65fTyJAU8wJ71w8ATtNl1CZ3Zes--

--iiFlpjhtfq5MVNRHsU35YqDfLjX38XXCf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHwEARECADwWIQSvMMXkF4alyejNm0QPgTQJ2NzuzQUCWoLZkB4caG9sZ2VyQGFw
cGxpZWQtYXN5bmNocm9ueS5jb20ACgkQD4E0Cdjc7s0ioQCfdBPI0iuPfUs6Vg4x
X0JQ2viDSZkAn2rw2UN1Bi2KodMDNGUt2vVCyMdh
=5x3g
-----END PGP SIGNATURE-----

--iiFlpjhtfq5MVNRHsU35YqDfLjX38XXCf--
