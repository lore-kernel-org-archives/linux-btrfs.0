Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EDABC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 09:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C45D21924
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 09:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405438AbfBOJ6o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 04:58:44 -0500
Received: from mout.gmx.net ([212.227.15.19]:50297 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbfBOJ6o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 04:58:44 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MD9q8-1grK5T3Kvs-00GWxe; Fri, 15
 Feb 2019 10:58:32 +0100
Subject: Re: [PATCH v4 04/12] btrfs: extent_io: Move the BUG_ON() in
 flush_write_bio() one level up
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190125050925.30754-1-wqu@suse.com>
 <20190125050925.30754-5-wqu@suse.com> <20190130151914.GU2900@twin.jikos.cz>
 <3893155e-d3c3-5fd0-6f61-ae067d341d81@gmx.com>
 <20190131143637.GF2900@twin.jikos.cz>
 <b61c2d29-888f-5fa3-bd64-59de8feabd10@gmx.com>
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
Message-ID: <58b95afa-d627-6aa8-17a3-8e19d7eccafe@gmx.com>
Date:   Fri, 15 Feb 2019 17:58:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <b61c2d29-888f-5fa3-bd64-59de8feabd10@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1vcLowf7xC0353BwxDhbzmkOT71jGxwAi"
X-Provags-ID: V03:K1:xxok3AY6RmkCnQ5VZdN7h6rifQCCaQ2f7TZDcyCavCVxiER8FJB
 yc33loXhCDPNNsCpuQpPTxYcqKKWhbYOsyqlb4OQHZopI+TgmwH9Itb5f/dOJCCyJrQkJWC
 ymP+2pgQl/7OgfGZEcAuFU1SV0oiy8mpONaHRjbadE3KoqakQDl2+svEUL1pRAadHgOMi7f
 zTKvJGpfya0IMfFQxiraw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:EKfgFSCp0q4=:XyVIKBk60Hpx0KsSdMfU2q
 kRelaFHHYYaya+2kW7IZrGwn5+CC35/Jo2BQ3W0nENpZnmJcFEYCOb4MCaHZuTcdHfkGuLAKb
 79Sn3W08s4O50nbtlYf0fpNRuDSn31s3Gjxv4K2vVWFwgK48NGzB7Sr/95tV4OhnOS6ESTAdf
 KY7Ui7iXCymaqZc6rZzCmfiEDMx5qO60dILH8bg8Uj6m2jaXu0oZE8qPzQYQcOgVYAQgo2q1P
 VvCNC9rwraSXGb9AweQ4DXoAB7JrzI47PU6BuBF8G26fC/tfQ+izvQ/O9uBkk5HKGpqu2Z7Ex
 BJ35co5aJuNtmTqox3h1zEn0uc3FAphnJzkNGETgGv9LDKLaVad3CrDHni2gu12LBIeM3LnOl
 IKLTzB5kuOp0W/nwkHSNeKN7sDMj325plp909HR86aq2z7VhlvjIOcZhvW2YI9kLEPrDrRzQ+
 BlUZZpTURjzWJUB+4UGOlbYHOZS9MfXdjACg+4DrvoHWSO2bn04ovSsNOxAYWHk/a0SGmfeQT
 kuwtA3eoMOEKUMOzFHN57iaZuVcZmzLTMLCevePJC6XBDum2r0b+IPHDoROU1fTAhr8dWiu/x
 X2VYrPEGo8X992nJCq+gYrivfBwRyMaEQUC9zMtcOjtn+o0KKMxPfiBHXbbbVRelQSPM6uHZJ
 u2WvU2VH7RjT9cj/XCMxJ0bZ0SDd6A2AaNtuSaIC/VAZNhSERi63xTwITTQixooJt2sjY0rzl
 9xuSQBqToxjDtwKeePDAtFEZiWJJLDdGCrN1YD9ePWO2VVMcjIWES+/yXm7c6e5OlNDPKOAh4
 y2mnTYFh0aQ6MIKl6gSg7FBfHp8kL0htX1mGz+gy+D02nrChOgEhJ0cJXyCg/iOBdFY5mcz+U
 HbGEwwYWs33KhlYaOPNTKGBythADgqV5b6mHMrcQqRry2Y56h0BUth5cTQZGFG
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1vcLowf7xC0353BwxDhbzmkOT71jGxwAi
Content-Type: multipart/mixed; boundary="RPPaDlEQNLRQFmKwfDEfqDxXwqU6nNcMP";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <58b95afa-d627-6aa8-17a3-8e19d7eccafe@gmx.com>
Subject: Re: [PATCH v4 04/12] btrfs: extent_io: Move the BUG_ON() in
 flush_write_bio() one level up
References: <20190125050925.30754-1-wqu@suse.com>
 <20190125050925.30754-5-wqu@suse.com> <20190130151914.GU2900@twin.jikos.cz>
 <3893155e-d3c3-5fd0-6f61-ae067d341d81@gmx.com>
 <20190131143637.GF2900@twin.jikos.cz>
 <b61c2d29-888f-5fa3-bd64-59de8feabd10@gmx.com>
In-Reply-To: <b61c2d29-888f-5fa3-bd64-59de8feabd10@gmx.com>

--RPPaDlEQNLRQFmKwfDEfqDxXwqU6nNcMP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/15 =E4=B8=8B=E5=8D=883:18, Qu Wenruo wrote:
>=20
>=20
> On 2019/1/31 =E4=B8=8B=E5=8D=8810:36, David Sterba wrote:
>> On Thu, Jan 31, 2019 at 08:45:42AM +0800, Qu Wenruo wrote:
>>>
>>>
>>> On 2019/1/30 =E4=B8=8B=E5=8D=8811:19, David Sterba wrote:
>>>> On Fri, Jan 25, 2019 at 01:09:17PM +0800, Qu Wenruo wrote:
>>>>> +static int __must_check flush_write_bio(struct extent_page_data *e=
pd)
>>>>>  {
>>>>> -	if (epd->bio) {
>>>>> -		int ret;
>>>>> +	int ret =3D 0;
>>>>> =20
>>>>> +	if (epd->bio) {
>>>>>  		ret =3D submit_one_bio(epd->bio, 0, 0);
>>>>> -		BUG_ON(ret < 0); /* -ENOMEM */
>>>>>  		epd->bio =3D NULL;
>>>>
>>>> I'm not sure if resetting epd->bio to NULL is all that needs to be d=
one
>>>> here. With the BUG_ON the error case never happens so if all goes fi=
ne
>>>> it's also ok to set it to NULL and continue. But the callers might n=
eed
>>>> to send the flush again.
>>>
>>> If flush_write_bio() get called again on the failed one, it will just=

>>> get skipped as  epd->bio is NULL, submit_one_bio() will not be trigge=
red.
>>
>> Yes that's clear, but what is the state of the bio that went to
>> flush_write_bio and submit_one_bio failed?
>>
>=20
> You got me.
>=20
> In fact current simple "epd->bio =3D NULL" on failure will just leak ep=
d->bio.
>=20
> We need to at least call "bio_put(epd->bio);" before setting "epd->bio =
=3D
> NULL;"

Facepalm, I'm always too quick to draw a conclusion.

With proper test, the epd->bio is freed by its endio function.
So at flush_write_bio() call time, no matter whether submit_one_bio()
returns error or not, endio of epd->bio will be or has already been
triggered thus free the bio.

Either by successful bio submission, or by manual bio_endio(bio) call in
submit_bio_hook.

So in fact just setting "epd->bio =3D NULL" is completely fine in this
context.

Thanks,
Qu

>=20
> Thanks for pointing this problem out,
> Qu
>=20


--RPPaDlEQNLRQFmKwfDEfqDxXwqU6nNcMP--

--1vcLowf7xC0353BwxDhbzmkOT71jGxwAi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxmjUIACgkQwj2R86El
/qjv3wf+MiGHRzKleMIEKGAYU3NgFG7/FffiVu37HR3EBIWr1ewftGB2LPD4yNa/
2rLHN723+qLyX7CdW/fkk/5nPEi+VK+3L0JyvFzD1ilmxDqQYH38bqzPBIpmdvUN
9ylRGuGE3KCoo6jjpqNXUuDudxIOCHxK3EIVXjyHQ5FvH3UghRglwGTDHYsv2E5w
pcUP2zuxSIfJY65yv3gwX1tdlv35UnzZPexiZIikNGU6Wk1nLmvXdnz1ASh4fCGG
b0D6HrEvUqo+rCeQSGEhhwMKr+fnw3ijUg7yQV6KniBlp7shhNpEo3Ij/ZLrnsCR
R7XFrHq0ZRXED9K9d7sj6s5ORrPERw==
=pJWU
-----END PGP SIGNATURE-----

--1vcLowf7xC0353BwxDhbzmkOT71jGxwAi--
