Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9BBC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 07:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A233C20838
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 07:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732386AbfBOHTB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 02:19:01 -0500
Received: from mout.gmx.net ([212.227.17.20]:49447 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbfBOHTB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 02:19:01 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LiTrM-1hUyyo1ZGe-00ckUC; Fri, 15
 Feb 2019 08:18:31 +0100
Subject: Re: [PATCH v4 04/12] btrfs: extent_io: Move the BUG_ON() in
 flush_write_bio() one level up
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190125050925.30754-1-wqu@suse.com>
 <20190125050925.30754-5-wqu@suse.com> <20190130151914.GU2900@twin.jikos.cz>
 <3893155e-d3c3-5fd0-6f61-ae067d341d81@gmx.com>
 <20190131143637.GF2900@twin.jikos.cz>
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
Message-ID: <b61c2d29-888f-5fa3-bd64-59de8feabd10@gmx.com>
Date:   Fri, 15 Feb 2019 15:18:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190131143637.GF2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="os45etS1G8Zgd7mFnlCPz15pNgnUmIaPR"
X-Provags-ID: V03:K1:3ERQOb2+OoKAFKnlCW5wiCNq+cRs6J1molRuFTFs2MiB1pkQJxZ
 HuUB+0UrjCTHwBrFKzhUS1StBoPF5t/+4il2B+vE3S8lG5qA9yOU7NFbX1vUxwo4VgX7aTz
 k+u5GBcIEysNa1K1iG18DSImEKVy+Ni5OtCo1AxsuH6VLHDRBRNe/IHQcMaOhNT9BS8K3dY
 iLU0pL6rQS8VpSJOVWLwg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:7d9YMnK6cjU=:6CIjOeuW5KGeF66XLBVgTM
 OwLBpXUjhMvqLMhvMaq2jc2n53uiES4Fws4sg/leeLkMvnBSGKHQYGeK2zTV9v0DFb0pBdeKL
 wfzJ1h9GgT/NnhE5xPw1e4SgH+CDAk/2pW9zFo3O9UXEXg7INNxtPD9ZTBbckbwlYckLqQmYV
 QdviBo+qu5H0n2BOJfAMGddU1ol+fbIrrTFjt1HhEMmqAJawCIwDMSSQk6PYfZTQ02qljURNl
 pTOollGsdc7io7H13+792NtemJ4gRzar+6R/A/XHDNX6QzxSvDroz0GyAIihI9/PT1sPU43vZ
 HkFtRSnvjlk9gR4kmBJG7aN798yFag7BvIv+7okt4vJIIp4j8vrmB8Rkpzq/om+c0uB4UhgCc
 eZPjA/2Ee0VXDR2x7rcvbzbsD+l/y19DzoyyYmoJki4N8t9TeV9C4xRJ+eyiJdrnGh6DuNTkd
 X9DISL5do80sudlpc/KdKrei4w+E3tMubmx3/JHChjl5xtvGVJnNBCOKlrPKjA+ko370N3S7G
 T7RSK/zvg0JahkoiAiz6b6WJHImXjtZwxKP97i80ac52iRFE+QH4yRxIrVbiNtXeSxMx8pfil
 uOh8/CjNVMUeOWmqFRyO9hp04lZpZwahMbH7/2Q6rvoXZutOLZ9N6EGVfcNfUyii5m5fPWEcl
 XV2TxUnC36NCpe80XP5/DeODr7G4A5Dp8p2EkkKpG1kCy5r8L/LEFmmG9sjP58ODZDPJTYji+
 uxW97r2rdNEvbPgEJA1nyHcQxukmD37c8/6LKtyingyRzq1XXbab3+fPbacQzVznnI638wtf3
 0Ar8Dd4bFhIqX5irpnEr9sBcDsr8CX1OFjmOrxBQLRhkHFmP2/mw+GHBCYWugkHTLAmcyMXhq
 x/k1ycnBSoshTy+/tOcvlynYZ+0Mjkm4Bi/A6v8n1MmXYQ8D8Ry3k5LIf6b9LM
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--os45etS1G8Zgd7mFnlCPz15pNgnUmIaPR
Content-Type: multipart/mixed; boundary="379uqfBFk35ghDyL5aZSYOTpO6ZFWRrHy";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <b61c2d29-888f-5fa3-bd64-59de8feabd10@gmx.com>
Subject: Re: [PATCH v4 04/12] btrfs: extent_io: Move the BUG_ON() in
 flush_write_bio() one level up
References: <20190125050925.30754-1-wqu@suse.com>
 <20190125050925.30754-5-wqu@suse.com> <20190130151914.GU2900@twin.jikos.cz>
 <3893155e-d3c3-5fd0-6f61-ae067d341d81@gmx.com>
 <20190131143637.GF2900@twin.jikos.cz>
In-Reply-To: <20190131143637.GF2900@twin.jikos.cz>

--379uqfBFk35ghDyL5aZSYOTpO6ZFWRrHy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/31 =E4=B8=8B=E5=8D=8810:36, David Sterba wrote:
> On Thu, Jan 31, 2019 at 08:45:42AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/1/30 =E4=B8=8B=E5=8D=8811:19, David Sterba wrote:
>>> On Fri, Jan 25, 2019 at 01:09:17PM +0800, Qu Wenruo wrote:
>>>> +static int __must_check flush_write_bio(struct extent_page_data *ep=
d)
>>>>  {
>>>> -	if (epd->bio) {
>>>> -		int ret;
>>>> +	int ret =3D 0;
>>>> =20
>>>> +	if (epd->bio) {
>>>>  		ret =3D submit_one_bio(epd->bio, 0, 0);
>>>> -		BUG_ON(ret < 0); /* -ENOMEM */
>>>>  		epd->bio =3D NULL;
>>>
>>> I'm not sure if resetting epd->bio to NULL is all that needs to be do=
ne
>>> here. With the BUG_ON the error case never happens so if all goes fin=
e
>>> it's also ok to set it to NULL and continue. But the callers might ne=
ed
>>> to send the flush again.
>>
>> If flush_write_bio() get called again on the failed one, it will just
>> get skipped as  epd->bio is NULL, submit_one_bio() will not be trigger=
ed.
>=20
> Yes that's clear, but what is the state of the bio that went to
> flush_write_bio and submit_one_bio failed?
>=20

You got me.

In fact current simple "epd->bio =3D NULL" on failure will just leak epd-=
>bio.

We need to at least call "bio_put(epd->bio);" before setting "epd->bio =3D=

NULL;"

Thanks for pointing this problem out,
Qu


--379uqfBFk35ghDyL5aZSYOTpO6ZFWRrHy--

--os45etS1G8Zgd7mFnlCPz15pNgnUmIaPR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxmZ7sACgkQwj2R86El
/qj7fQf/SoRShlEcR/05ZwRaYcGhwvsPt9jkjCuAnOWHipgSSpvVTAFrZEfgU8ly
ge5nRG8jzQ110qLLxQWqXwtyQbf+5TDEcYA0kum5C8LZ5/OrNTChoNsnbrMhnd3z
bzMyzB1kYF45wsT+yrj3tvdOqGSLBlHBu+0T/BGWEsmYcH5mBRpPUPhOa+MzuKWw
wtgY2AVFu7Jnq+8aNdZi/zhHq9jS+4bTb+xi9FZXryXLLKzycYCUuCwylPuq/Pdh
Htub1WRd1FhwmzOhU7wxoP4YOzpOWe/pmzJI6mdmvkU+ClpnLtWOO1xTCvl2ane4
GJ1sbhAO01Cc0r1fNBMfbblrLJkxLg==
=Tn6N
-----END PGP SIGNATURE-----

--os45etS1G8Zgd7mFnlCPz15pNgnUmIaPR--
