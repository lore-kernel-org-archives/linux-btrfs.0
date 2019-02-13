Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55BA7C282C4
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 00:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26459218D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 00:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbfBMAoM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 19:44:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:60966 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727871AbfBMAoM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 19:44:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 69C0AABB1;
        Wed, 13 Feb 2019 00:44:10 +0000 (UTC)
Subject: Re: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded
 rw mount
To:     Andrei Borzenkov <arvidjaar@gmail.com>,
        Remi Gauvin <remi@georgianit.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190212070319.30619-1-wqu@suse.com>
 <aabbd673-fdc0-77dd-7e1e-1b5d1ed12bff@georgianit.com>
 <964481b6-e761-8d0d-3ef1-cbe19dbfae9e@suse.de>
 <79f33db2-f39c-6bd6-4697-d9d9f6a704f1@georgianit.com>
 <d5ad9e15-a572-2819-c39f-43d4c0ff2832@suse.de>
 <d1093c59-f432-b2b6-ca53-e46414c945a6@gmail.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <eb285e0c-adb8-95b8-c366-2f5806116c0c@suse.de>
Date:   Wed, 13 Feb 2019 08:44:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <d1093c59-f432-b2b6-ca53-e46414c945a6@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ImBpPgUNLytd4NASEN1HCqJagGf2JganM"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ImBpPgUNLytd4NASEN1HCqJagGf2JganM
Content-Type: multipart/mixed; boundary="zOEL0bzln7fq7K27zrtFhoGKWNgwqN6PK";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Andrei Borzenkov <arvidjaar@gmail.com>, Remi Gauvin
 <remi@georgianit.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <eb285e0c-adb8-95b8-c366-2f5806116c0c@suse.de>
Subject: Re: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded
 rw mount
References: <20190212070319.30619-1-wqu@suse.com>
 <aabbd673-fdc0-77dd-7e1e-1b5d1ed12bff@georgianit.com>
 <964481b6-e761-8d0d-3ef1-cbe19dbfae9e@suse.de>
 <79f33db2-f39c-6bd6-4697-d9d9f6a704f1@georgianit.com>
 <d5ad9e15-a572-2819-c39f-43d4c0ff2832@suse.de>
 <d1093c59-f432-b2b6-ca53-e46414c945a6@gmail.com>
In-Reply-To: <d1093c59-f432-b2b6-ca53-e46414c945a6@gmail.com>

--zOEL0bzln7fq7K27zrtFhoGKWNgwqN6PK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/13 =E4=B8=8A=E5=8D=882:42, Andrei Borzenkov wrote:
> 12.02.2019 10:47, Qu Wenruo =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>
>>
>> On 2019/2/12 =E4=B8=8B=E5=8D=883:43, Remi Gauvin wrote:
>>> On 2019-02-12 2:22 a.m., Qu Wenruo wrote:
>>>
>>>>> Does this mean you would rely on scrub/CSUM to repair the missing d=
ata
>>>>> if device is restored?
>>>>
>>>> Yes, just as btrfs usually does.
>>>>
>>>
>>> I don't really understand the implications of the problems with mount=
ing
>>> fs when single/dup data chunk are allocated on raid1,
>>
>> Consider this use case:
>>
>> One btrfs with 2 devices, RAID1 for data and metadata.
>>
>> One day devid 2 got failure, and before replacement arrives, user can
>> only use devid 1 alone. (Maybe that's the root fs).
>>
>> Then new disk arrived, user replaced the missing device, caused SINGLE=

>> or DUP chunks on devid 1, and more importantly, some metadata/data is
>> already in DUP/SINGLE chunks.
>>
>> Then some days later, devid 1 get failure too, now user is unable to
>> mount the fs degraded RW any more, since SINGLE/DUP chunks are all on
>> devid 1, and no way to replace devid 1.
>>
>=20
> But if I understand what happens after your patch correctly, replacemen=
t
> device still does not contain valid data until someone does scrub.

Nope. That's incorrect.

We still go through normal device replace routine, which will copy data
from degraded chunks to new device.

Thanks,
Qu

> So in
> either case manual step is required to restore full redundancy.
>=20
> Or does "btrfs replace" restore content on replacement device automatic=
ally?
>=20
>> Thanks,
>> Qu
>>
>>> but I would think
>>> that would actually be a preferable situation than filling a drive wi=
th
>>> 'data' we know is completely bogus... converting single/dup data to r=
aid
>>> should be much faster than tripping on CSUM errors, and less prone to=

>>> missed errors?
>>>
>>>
>>
>=20
>=20


--zOEL0bzln7fq7K27zrtFhoGKWNgwqN6PK--

--ImBpPgUNLytd4NASEN1HCqJagGf2JganM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxjaFYACgkQwj2R86El
/qgSWAgAk4CI/y5I8mjOZbhh+MRGL+05TGWn0ZQnaVsuAU9zlD/WhWOZbFuZhMtj
ccE3ygs7QqCaal+W6zJ9KxUu346MbY9CaQa8FtSa3EjcWd/bjnLUThEgjnjBvdzu
Kv5YoMJ75b4/upJs2QbgDrBYW4hJwswo9JHNdrUVsL6mUYtagMHn32R+mlatFGXE
kKP2TczqJTY0MHiAFXseB14gxeZWK+/wSpZXfDQSgOiW4iYdso+Vv+cF0aP33WMg
kip4iKkTbFposnr3Rf9ljZy+DJbERHOtGiLDU2QvDy1e45bMWsyiLNKcqIZqQP5Z
ASopWhWXJyhk8TRZl2y0LPvEQ3MCXA==
=JkLH
-----END PGP SIGNATURE-----

--ImBpPgUNLytd4NASEN1HCqJagGf2JganM--
