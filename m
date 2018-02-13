Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51037 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935077AbeBMMqX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 07:46:23 -0500
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: John Ettedgui <john.ettedgui@gmail.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
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
 <CAJ3TwYTAhOc1eRUC_FoUFjpC=Ys_DRbHBp9NW6EdVSXArqiMww@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <00946e24-cf79-92c0-9e70-5425b4b06b7c@gmx.com>
Date: Tue, 13 Feb 2018 20:46:17 +0800
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYTAhOc1eRUC_FoUFjpC=Ys_DRbHBp9NW6EdVSXArqiMww@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bJRrFfYFjBvVhueZnUKay3nRHu6VUeq2Q"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bJRrFfYFjBvVhueZnUKay3nRHu6VUeq2Q
Content-Type: multipart/mixed; boundary="GhIdWyUB1fg9cXtlPoUQlqP741wtWOcLK";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: John Ettedgui <john.ettedgui@gmail.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
 btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <00946e24-cf79-92c0-9e70-5425b4b06b7c@gmx.com>
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
 <CAJ3TwYTAhOc1eRUC_FoUFjpC=Ys_DRbHBp9NW6EdVSXArqiMww@mail.gmail.com>
In-Reply-To: <CAJ3TwYTAhOc1eRUC_FoUFjpC=Ys_DRbHBp9NW6EdVSXArqiMww@mail.gmail.com>

--GhIdWyUB1fg9cXtlPoUQlqP741wtWOcLK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8813=E6=97=A5 20:06, John Ettedgui wrote:
>>>>
>>> That's fairly straightforward to do, though it should be quite slow s=
o
>>> I'd hope not to have to do that too often.
>>
>> Then it could be tried on the most frequently updated files then.
>=20
> That's an interesting idea.
> More than 3/4 of the data is just storage, so that should be very ok.

BTW, how the initial data is created?

If the initial data is all written once and doesn't get modified later,
then the problem may not be fragments.

>=20
>>
>> And since you don't use snapshot, locate such files and then "chattr +=
C"
>> would make them nodatacow, reducing later fragments.
>=20
> I don't understand, why would that reduce later fragments?

Later overwrite will not create new extent, but overwrite existing extent=
s.
Other than CoW and cause new extents (fragments)

Although expand write will still cause new extent, but that's
unavoidable anyway.

Thanks,
Qu

>=20
>>
>>>>    This should acts much better than traditional defrag, although it=
's
>>>>    time-consuming and makes snapshot completely meaningless.
>>>>    (and since you're already hitting ENOSPC, I don't think the idea =
is
>>>>     really working for you)
>>>>
>>>> And since you're already hitting ENOSPC, either it's caused by
>>>> unbalanced meta/data usage, or it's really going hit the limit, I wo=
uld
>>>> recommend to enlarge the fs or delete some files to see if it helps.=

>>>>
>>> Yup, I usually either slowly ramp up the {d,m}usage to pass it, or
>>> when that does not work I free some space, then balance will finish.
>>> Or did you mean to free some space to see about mount speed?
>>
>> Kind of, just do such freeing in advance, and try to make btrfs always=

>> have unallocated space in case.
>>
>=20
> I actually have very little free space on those partitions, usually
> under 90Gb, maybe that's part of my problem.
>=20
>> And finally, use latest kernel if possible.
>> IIRC old kernel doesn't have empty block group auto remove, which make=
s
>> user need to manually balance to free some space.
>>
>> Thanks,
>> Qu
>>
>=20
> I am on 4.15 so no problem there.
>=20
> So manual defrag and new FS to try.
>=20
> Thank you!
>=20


--GhIdWyUB1fg9cXtlPoUQlqP741wtWOcLK--

--bJRrFfYFjBvVhueZnUKay3nRHu6VUeq2Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqC3hkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjWrAgAmyevudvf7Yb/mu1BcK6VXyON
obspBqDM+fd8ZWYgJkygrtf2Ccw5LsSdV+ZW35GlEJK8vMZ7D7TFt/g62pLgvDMi
IzUQs443cccZSJSeEnnVMbNDJmpeeC7NiELpagzGzcTENzb5vjst/vvyV9aOeGOk
nvemoABC263jlgMXF2Tn8fAA5Q8N1UMDUaLpdd7rEenGbhmcU51gNpFhAecxzjOk
ni21BKBUk3eXypVWygkZ6OUGwUmOOmyOKOt1t0WsEN80lPmmcpj+Gt/ve2cZwadq
zvdtwja6GHkGwsdCp1G/KNSqvvs6CdODZI55J+KkMXQhA6HRdo21Okqm1xLPyg==
=Q5Xq
-----END PGP SIGNATURE-----

--bJRrFfYFjBvVhueZnUKay3nRHu6VUeq2Q--
