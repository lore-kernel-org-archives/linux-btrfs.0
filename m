Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:42476 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933927AbeBMQYk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 11:24:40 -0500
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        John Ettedgui <john.ettedgui@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
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
 <900c77fc-6ad0-624c-6831-b8e5da636fb4@gmx.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <c05528ee-41e0-c0a7-b53b-be9cf7d9d799@applied-asynchrony.com>
Date: Tue, 13 Feb 2018 17:24:37 +0100
MIME-Version: 1.0
In-Reply-To: <900c77fc-6ad0-624c-6831-b8e5da636fb4@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="TIs6FDMU68RbAH6vMY2kG2lGAXOq8TEy5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TIs6FDMU68RbAH6vMY2kG2lGAXOq8TEy5
Content-Type: multipart/mixed; boundary="wmLuskFdD3xTdTlvFKQGPj41Ryqet4KRT";
 protected-headers="v1"
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
 John Ettedgui <john.ettedgui@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
 Austin S Hemmelgarn <ahferroin7@gmail.com>,
 btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <c05528ee-41e0-c0a7-b53b-be9cf7d9d799@applied-asynchrony.com>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
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
 <900c77fc-6ad0-624c-6831-b8e5da636fb4@gmx.com>
In-Reply-To: <900c77fc-6ad0-624c-6831-b8e5da636fb4@gmx.com>

--wmLuskFdD3xTdTlvFKQGPj41Ryqet4KRT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 02/13/18 13:54, Qu Wenruo wrote:
> On 2018=E5=B9=B402=E6=9C=8813=E6=97=A5 20:26, Holger Hoffst=C3=A4tte wr=
ote:
>> On 02/13/18 12:40, Qu Wenruo wrote:
>>>>> The problem is not about how much space it takes, but how many exte=
nts
>>>>> are here in the filesystem.
>>
>> I have no idea why btrfs' mount even needs to touch all block groups t=
o
>> get going (which seems to be the root of the problem), but here's a
>> not so crazy idea for more "mechanical sympathy". Feel free to mock
>> me if this is terribly wrong or not possible. ;)
>>
>> Mounting of even large filesystems (with many extents) seems to be fin=
e
>> on SSDS, but not so fine on rotational storage. We've heard that from
>> several people with large (multi-TB) filesystems, and obviously it's
>> even more terrible on 5400RPM drives because their seeks are sooo sloo=
w.
>>
>> If the problem is that the bgs are touched/iterated in "tree order",
>> would it then not be possible to sort the block groups in physical ord=
er
>> before trying to load whatever mount needs to load?
>=20
> This is in fact a good idea.
> Make block group into its own tree.

Well, that's not what I was thinking about at all..yet. :)
(keep in mind I'm not really that familiar with the internals).

Out of curiosity I ran a bit of perf on my own mount process, which is
fast (~700 ms) despite being a ~1.1TB fs, mixture of lots of large and
small files. Unfortunately it's also very fresh since I recreated it just=

this weekend, so everything is neatly packed together and fast.

In contrast a friend's fs is ~800 GB, but has 11 GB metadata and is prett=
y
old and fragmented (but running an up-to-date kernel). His fs mounts in ~=
5s.

My perf run shows that the only interesting part responsible for mount ti=
me
is the nested loop in btrfs_read_block_groups calling find_first_block_gr=
oup
(which got inlined & is not in the perf callgraph) over and over again,
accounting for 75% of time spent.

I now understand your comment why the real solution to this problem
is to move bgs into their own tree, and agree: both kitchens and database=
s
have figured out a long time ago that the key to fast scan and lookup
performance is to not put different things in the same storage container;=

in the case of analytical DBMS this is columnar storage. :)

But what I originally meant was something much simpler and more
brute-force-ish. I see that btrfs_read_block_groups adds readahead
(is that actually effective?) but what I was looking for was the equivale=
nt
of a DBMS' sequential scan. Right now finding (and loading) a bg seems to=

involve a nested loop of tree lookups. It seems easier to rip through the=

entire tree in nice 8MB chunks and discard what you don't need instead
of seeking around trying to find all the right bits in scattered order.

Could we alleviate cold mounts by starting more readaheads in
btrfs_read_block_groups, so that the extent tree is scanned more linearly=
?

cheers,
Holger


--wmLuskFdD3xTdTlvFKQGPj41Ryqet4KRT--

--TIs6FDMU68RbAH6vMY2kG2lGAXOq8TEy5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHwEARECADwWIQSvMMXkF4alyejNm0QPgTQJ2NzuzQUCWoMRRR4caG9sZ2VyQGFw
cGxpZWQtYXN5bmNocm9ueS5jb20ACgkQD4E0Cdjc7s1LVgCgtD3+PZm3D/svga7W
H5hTNFOsdEQAn01dwSwSunov6ss8pkUXZ76P4N+9
=tnQ9
-----END PGP SIGNATURE-----

--TIs6FDMU68RbAH6vMY2kG2lGAXOq8TEy5--
