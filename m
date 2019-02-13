Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DDE9C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 10:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BFBA21920
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 10:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389663AbfBMKoc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 05:44:32 -0500
Received: from mout.gmx.net ([212.227.15.19]:52469 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbfBMKoc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 05:44:32 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MMkDH-1h0jWL0ZIt-008YjH; Wed, 13
 Feb 2019 11:44:23 +0100
Subject: Re: [PATCH] fstests: fix fssum to actually ignore file holes when
 supposed to
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
References: <20181029094340.18154-1-fdmanana@kernel.org>
 <5e65b105-64ec-bf99-ea4d-b20622ad12a9@gmx.com>
 <CAL3q7H4xbqEdr2PGFZ34oBgYF1z-VCdt0UunF-uX9SjMZO5OUQ@mail.gmail.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <9c380e51-2406-b455-5834-2f69caf2137c@gmx.com>
Date:   Wed, 13 Feb 2019 18:44:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4xbqEdr2PGFZ34oBgYF1z-VCdt0UunF-uX9SjMZO5OUQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5TkDh87noRpD5ODlEj4dliSDOwup2wMfT"
X-Provags-ID: V03:K1:KwJCNlrWjRM95cOxUwCgYLFIfHaCWtWxGOHT1ivFM4yIHOz6bJP
 uJ86YYGylL6VNkweaD5UF3/HSZ5Dh0h3IjdUY9DNTgBVvzDFxnY1WXGpXODkKYmcegJ2liF
 y0N9Iji4UXvfL6PPELWQmY8Lx9RLrO2cgdhnil29OfV2bdbLZFKV2lUnUh0wEFL3ZHhu8Ls
 kzB4hHXLbOIcnhfo+yCig==
X-UI-Out-Filterresults: notjunk:1;V03:K0:k5glhFFguL4=://135ZllGLtwAiGrWniP1K
 QDN40IVj+KcnwSW+cnKv02PSwT56ly36UKEk/zUFzUwOKtcS1xP8NJfzitgUZqrSxKpdaz1SJ
 M1zegW/BH6R1gVV4k8GFEhR83dMg3lBIv27JZ7seu8kOdSAq0T3DqVoH59zRWlb8c5L6mYA8b
 oYscYjrFgPNMZJVgwATMCOMPge2QpN+NlXCOK93tcXE1+jp0ft8sv6Z8TSWOc3wB0X7aIM0BE
 GdxnyrbvUATniYBptQAwg2kMm+oday2AHzTDzUCcWJka5L1S3HCWsdkPmId/GPxsY/w/qEBcG
 igOl4vt6Cec8MJEBmsp+Y4W7wPGRZhFJO+Ue3QgLqiop1OE6p1SVxWJOXUB4c/+jHtgy5BAFz
 YxHxO1MpMtR2krOqvFqvzsOccbu4fnUDqepwzleMPnXGpkDK3mN25aKBwPkguaurf/KIarG3i
 jjXdfrUE/NEHmwnLb2+0rkp9UK6cHKsWZhRc73R0JYvryMDKaWR23OVZgoYorW/QyWXmI+jh0
 Z3w16VJlSgteh6gBTScNBeNxQXuPkASGbf2QJEcapERmZNBpBDTygxjMSQNmvM4FupGEfulww
 eYHoCZ3G4KfL+e23kTxRZc5O7zDK8QpiPl6daRCQUcNJim8nnnQbIl5+76brmavooNfEfMnw7
 GlmzdNqnfxQIRrVv3qtNvkJJ1uTK9lYM1SrMD8uIthO3yWmFs65WUaBBS8WbJb2uu46rYHugf
 GcV8kVZWKn71R2tZKCHTsDg3SX+vcDEuw7U0S2hwyMsegV54apcG6nzRTzX9zaLwG9I8qSKim
 tx/EenOm1oeKKssNU1BAsXCB31w7qIPKsnTiL6A99dP6Z2nZ8K41nsOxl3bGGl7WpkaGsqRyK
 O4wbV+3/6VnHKML+Ef5wMHkumE3KLkmctnplRwWpSj+n67NJU/Uj+eBTYot9HA
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5TkDh87noRpD5ODlEj4dliSDOwup2wMfT
Content-Type: multipart/mixed; boundary="jdPu9krAnu3sCu6zTEu0xRK9B3RUEmyNR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: fstests <fstests@vger.kernel.org>,
 linux-btrfs <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Message-ID: <9c380e51-2406-b455-5834-2f69caf2137c@gmx.com>
Subject: Re: [PATCH] fstests: fix fssum to actually ignore file holes when
 supposed to
References: <20181029094340.18154-1-fdmanana@kernel.org>
 <5e65b105-64ec-bf99-ea4d-b20622ad12a9@gmx.com>
 <CAL3q7H4xbqEdr2PGFZ34oBgYF1z-VCdt0UunF-uX9SjMZO5OUQ@mail.gmail.com>
In-Reply-To: <CAL3q7H4xbqEdr2PGFZ34oBgYF1z-VCdt0UunF-uX9SjMZO5OUQ@mail.gmail.com>

--jdPu9krAnu3sCu6zTEu0xRK9B3RUEmyNR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/13 =E4=B8=8B=E5=8D=886:21, Filipe Manana wrote:
> On Wed, Feb 13, 2019 at 5:44 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrot=
e:
>>
>>
>>
>> On 2018/10/29 =E4=B8=8B=E5=8D=885:43, fdmanana@kernel.org wrote:
>>> From: Filipe Manana <fdmanana@suse.com>
>>>
>>> Unless the '-s' option is passed to fssum, it should not detect file =
holes
>>> and have their existence influence the computed checksum for a file. =
This
>>> tool was added to test btrfs' send/receive feature, so that it checks=
 for
>>> any metadata and data differences between the original filesystem and=
 the
>>> filesystem that receives send streams.
>>>
>>> For a long time the test btrfs/007, which tests btrfs' send/receive w=
ith
>>> fsstress, fails sporadically reporting data differences between files=
=2E
>>> However the md5sum/sha1sum from the reported files in the original an=
d
>>> new filesystems are the same. The reason why fssum fails is because e=
ven
>>> in normal mode it still accounts for number of holes that exist in th=
e
>>> file and their respective lengths. This is done using the SEEK_DATA m=
ode
>>> of lseek. The btrfs send feature does not preserve holes nor prealloc=

>>> extents (not supported by the current protocol), so whenever a hole o=
r
>>> prealloc (unwritten) extent is detected in the source filesystem, it
>>> issues a write command full of zeroes, which will translate to a regu=
lar
>>> (written) extent in the destination filesystem. This is why fssum rep=
orts
>>> a different checksum. A prealloc extent also counts as hole when usin=
g
>>> lseek.
>>>
>>> For example when passing a seed of 1540592967 to fsstress in btrfs/00=
7,
>>> the test fails, as file p0/d0/f7 has a prealloc extent in the origina=
l
>>> filesystem (in the incr snapshot).
>>>
>>> Fix this by making fssum just read the hole file and feed its data to=
 the
>>> digest calculation function when option '-s' is not given. If we ever=
 get
>>> btrfs' send/receive to support holes and fallocate, we can just chang=
e
>>> the test and pass the '-s' option to all fssum calls.
>>
>> However this is causing more problem here.
>>
>> Now since fssum doesn't skip holes, for a super large sparse file, fss=
um
>> will try to fill all the holes with zero and spend tons of CPU time
>> calculating the result.
>=20
> Yes. So will md5sum for example and many other things.
>=20
> The problem is well known and it's due to the addition of the splice
> operation to fsstress:
>=20
> https://www.spinics.net/lists/fstests/msg11257.html
>=20
> It was also making other tests slower.
> This got fixed recently in the last Sunday's update by:
>=20
> https://www.spinics.net/lists/fstests/msg11266.html
>=20
>>
>> E.g. when seed =3D 1550703281.
>> We will have a PiB level file:
>> $ ls /mnt/scratch/base/p0/f3 -alh
>> -rw-rw-rw- 1 1441 2774 666P Feb 13 13:39 /mnt/scratch/base/p0/f3
>>
>> (well, 666, no wonder this will fail)
>>
>> But it only takes aroud 1M:
>> $ du /mnt/scratch/base/p0/f3
>> 1044    /mnt/scratch/base/p0/f3
>>
>> This is even more annoying than test failure.
>>
>> Can't we just filter out the fallocate/hole punching part in the test
>> itself?
>=20
> No. Removing fallocate and hole punching operations from btrfs/007, or
> any other test, limits coverage.
> There were bugs in the past uncovered by that test exactly because
> fsstress exercises those operations.
>=20
> Further, that would not prevent creation of sparse files. Operations
> like pwrite, dwrite, clone, etc also cause sparse files.

Although fsstress get fixed, I'm considering zero page detector for
fssum. Check hole first, then check all zero page.

Then we could handle large sparse file along with zero filled receive.

Thanks,
Qu

>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>> ---
>>>  src/fssum.c | 65 +++++----------------------------------------------=
----------
>>>  1 file changed, 5 insertions(+), 60 deletions(-)
>>>
>>> diff --git a/src/fssum.c b/src/fssum.c
>>> index 5da39abf..f1da72fb 100644
>>> --- a/src/fssum.c
>>> +++ b/src/fssum.c
>>> @@ -224,71 +224,16 @@ int
>>>  sum_file_data_permissive(int fd, sum_t *dst)
>>>  {
>>>       int ret;
>>> -     off_t pos;
>>> -     off_t old;
>>> -     int i;
>>> -     uint64_t zeros =3D 0;
>>> -
>>> -     pos =3D lseek(fd, 0, SEEK_CUR);
>>> -     if (pos =3D=3D (off_t)-1)
>>> -             return errno =3D=3D ENXIO ? 0 : -2;
>>>
>>>       while (1) {
>>> -             old =3D pos;
>>> -             pos =3D lseek(fd, pos, SEEK_DATA);
>>> -             if (pos =3D=3D (off_t)-1) {
>>> -                     if (errno =3D=3D ENXIO) {
>>> -                             ret =3D 0;
>>> -                             pos =3D lseek(fd, 0, SEEK_END);
>>> -                             if (pos !=3D (off_t)-1)
>>> -                                     zeros +=3D pos - old;
>>> -                     } else {
>>> -                             ret =3D -2;
>>> -                     }
>>> -                     break;
>>> -             }
>>>               ret =3D read(fd, buf, sizeof(buf));
>>> -             assert(ret); /* eof found by lseek */
>>> -             if (ret <=3D 0)
>>> +             if (ret < 0)
>>> +                     return -errno;
>>> +             sum_add(dst, buf, ret);
>>> +             if (ret < sizeof(buf))
>>>                       break;
>>> -             if (old < pos) /* hole */
>>> -                     zeros +=3D pos - old;
>>> -             for (i =3D 0; i < ret; ++i) {
>>> -                     for (old =3D i; buf[i] =3D=3D 0 && i < ret; ++i=
)
>>> -                             ;
>>> -                     if (old < i) /* code like a hole */
>>> -                             zeros +=3D i - old;
>>> -                     if (i =3D=3D ret)
>>> -                             break;
>>> -                     if (zeros) {
>>> -                             if (verbose >=3D 2)
>>> -                                     fprintf(stderr,
>>> -                                             "adding %llu zeros to s=
um\n",
>>> -                                             (unsigned long long)zer=
os);
>>> -                             sum_add_u64(dst, 0);
>>> -                             sum_add_u64(dst, zeros);
>>> -                             zeros =3D 0;
>>> -                     }
>>> -                     for (old =3D i; buf[i] !=3D 0 && i < ret; ++i)
>>> -                             ;
>>> -                     if (verbose >=3D 2)
>>> -                             fprintf(stderr, "adding %u non-zeros to=
 sum\n",
>>> -                                     i - (int)old);
>>> -                     sum_add(dst, buf + old, i - old);
>>> -             }
>>> -             pos +=3D ret;
>>>       }
>>> -
>>> -     if (zeros) {
>>> -             if (verbose >=3D 2)
>>> -                     fprintf(stderr,
>>> -                             "adding %llu zeros to sum (finishing)\n=
",
>>> -                             (unsigned long long)zeros);
>>> -             sum_add_u64(dst, 0);
>>> -             sum_add_u64(dst, zeros);
>>> -     }
>>> -
>>> -     return ret;
>>> +     return 0;
>>>  }
>>>
>>>  int
>>>
>>


--jdPu9krAnu3sCu6zTEu0xRK9B3RUEmyNR--

--5TkDh87noRpD5ODlEj4dliSDOwup2wMfT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxj9PsACgkQwj2R86El
/qj2yQgAiqQX8H07V65zNy8+C3sGn7r1TvC8hnLCKGvgHKjstz5NhcQEHNhvivmb
vnGd5w2L5RBR27XbV0GAKTtVT7rQn3BPIIoYhBx/suVzHD/z2wI+YSDT8S5/kKyn
ri3FZ5VST9WFmwk+q6dayGJ3bMrPx35isMzkrQqWYkzqBtNP+ZxwWHsYGjR83XMD
HsaNJRFUIm40DaCqDdty+qNi8UBZpdHzk7/ve9Sety3ms5P/Et+ggxakQqPutUO/
RK1gqEo0qU/H5uJrG53+bKCo8XqXiWSgrgglIzFQ4jq+8EiD436x/kTR/KMlfW76
i/NlnoblBEeFhwLJxDFOcrsGzM3FBQ==
=eT3+
-----END PGP SIGNATURE-----

--5TkDh87noRpD5ODlEj4dliSDOwup2wMfT--
