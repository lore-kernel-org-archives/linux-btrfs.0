Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:46747 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934079AbeBMLEk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 06:04:40 -0500
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: John Ettedgui <john.ettedgui@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <CAJ3TwYRXwDVVfT0TRRiM9dEw-7TvY8qG=WvMYKczZOv6wkFWAQ@mail.gmail.com>
 <fd718727-9b54-ba58-5f39-63066181d13e@cn.fujitsu.com>
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
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <87975474-0cb9-13d7-f623-c0622b31f437@gmx.com>
Date: Tue, 13 Feb 2018 19:04:29 +0800
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYRgHfCNxKwWnfWXr=w_mBo2B2AuSDeE+PgYEtn7kyAx7w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oP21qYH81Bh3Oj3V5KPy2ltTP45L24wH6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oP21qYH81Bh3Oj3V5KPy2ltTP45L24wH6
Content-Type: multipart/mixed; boundary="Bjvy9AuGjhRJeSrM3DmTt80dy123RHuHI";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: John Ettedgui <john.ettedgui@gmail.com>,
 Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
 btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <87975474-0cb9-13d7-f623-c0622b31f437@gmx.com>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <55C1F3DD.7020603@gmail.com>
 <CAJ3TwYSW+SvbBrh1u_x+c3HTRx03qSR6BoH5cj_VzCXxZYv6EA@mail.gmail.com>
 <126f9f09-4e28-3c12-5384-63032e17942f@cn.fujitsu.com>
 <CAJ3TwYRXwDVVfT0TRRiM9dEw-7TvY8qG=WvMYKczZOv6wkFWAQ@mail.gmail.com>
 <fd718727-9b54-ba58-5f39-63066181d13e@cn.fujitsu.com>
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
In-Reply-To: <CAJ3TwYRgHfCNxKwWnfWXr=w_mBo2B2AuSDeE+PgYEtn7kyAx7w@mail.gmail.com>

--Bjvy9AuGjhRJeSrM3DmTt80dy123RHuHI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8813=E6=97=A5 18:21, John Ettedgui wrote:
> On Thu, Jul 21, 2016 at 1:19 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wr=
ote:
>>
>>
>> No more.
>>
>> The dump is already good enough for me to dig for some time.
>>
>> We don't usually get such large extent tree dump from a real world use=
 case.
>>
>> It would help us in several ways, from determine how fragmented a bloc=
k
>> group is to determine if a defrag will help.
>>
>> Thanks,
>> Qu
>>
>>
>=20
>=20
> Hello there,
>=20
> have you found anything good since then?

Unfortunately, not really much to speed it up.

This reminds me of the old (and crazy) idea to skip block group build
for RO mount.
But not really helpful for it.

> With a default system, the behavior is pretty much still the same,
> though I have not recreated the partitions since.
>=20
> Defrag helps, but I think balance helps even more.
> clear_cache may help too, but I'm not really sure as I've not tried it
> on its own.
> I was actually able to get a 4TB partition on a 5400rpm HDD to mount
> in around 500ms, quite faster that even some Gb partitions I have on
> SSDs! Alas I wrote some files to it and it's taking over a second
> again, so no more magic there.

The problem is not about how much space it takes, but how many extents
are here in the filesystem.

For new fs filled with normal data, I'm pretty sure data extents will be
as large as its maximum size (256M), causing very little or even no
pressure to block group search.

>=20
> The workarounds do work, so it's still not a major issue, but they're
> slow and sometimes I have to workaround the "no space left on device"
> which then takes even more time.

And since I went to SUSE, some mail/info is lost during the procedure.

Despite that, I have several more assumption to this problem:

1) Metadata usage bumped by inline files
   If there are a lot of small files (<2K as default), and your metadata
   usage is quite high (generally speaking, it meta:data ratio should be
   way below 1:8), that may be the cause.

   If so, try mount the fs with "max_inline=3D0" mount option and then
   try to rewrite such small files.

2) SSD write amplification along with dynamic remapping
   To be honest, I'm not really buying this idea, since mount doesn't
   have anything related to write.
   But running fstrim won't harm anyway.

3) Rewrite the existing files (extreme defrag)
   In fact, defrag doesn't work well if there are subvolumes/snapshots
   /reflink involved.
   The most stupid and mindless way, is to write a small script and find
   all regular files, read them out and rewrite it back.

   This should acts much better than traditional defrag, although it's
   time-consuming and makes snapshot completely meaningless.
   (and since you're already hitting ENOSPC, I don't think the idea is
    really working for you)

And since you're already hitting ENOSPC, either it's caused by
unbalanced meta/data usage, or it's really going hit the limit, I would
recommend to enlarge the fs or delete some files to see if it helps.

Thanks,
Qu

>=20
> Thank you!
> John
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Bjvy9AuGjhRJeSrM3DmTt80dy123RHuHI--

--oP21qYH81Bh3Oj3V5KPy2ltTP45L24wH6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqCxj0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgXEwgAqsg9ecF89frqTsaw14UYPx/u
auK1h3ULqOUUqCTXoGnWPTJunfLtMSQbsSvTX2T9MTmsR7Lwe3cD63kQplW0HRzv
aw1tJe+OROBaMgxu5i8PHcFtP1hhPc3Sm0IX+SNo3j8SEsjhVY8nee0tvCg/mLec
+8RCCwe2TwmxSNfAs1xFGdS7mMZvi03H2LfDhasjY9qz3AOk3tRppaL9S+RgsvG5
jbrMu311ftyR0ozQIDnY0FuSiydCRqhxiCNEY/scD0xNM+TNbAS/McJ5oKrnFt2U
GapsUCrmm8hX5COLNstdc3k72mZj+zKVnmmFg2EI/Nhdwo3Dd24/wJ+59u2YGQ==
=4nfK
-----END PGP SIGNATURE-----

--oP21qYH81Bh3Oj3V5KPy2ltTP45L24wH6--
