Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94046C67879
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 01:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 502742075C
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 01:14:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 502742075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbeJII2q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 04:28:46 -0400
Received: from mout.gmx.net ([212.227.17.21]:57075 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbeJII2q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 04:28:46 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LrevR-1fgW5o3QNB-013OZs; Tue, 09
 Oct 2018 03:14:14 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LrevR-1fgW5o3QNB-013OZs; Tue, 09
 Oct 2018 03:14:14 +0200
Subject: Re: [PATCH v3 4/6] btrfs-progs: lowmem check: Add dev_item check for
 used bytes and total bytes
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20181008123044.13413-1-wqu@suse.com>
 <20181008123044.13413-5-wqu@suse.com>
 <cd511cfa-baa2-6a13-2802-6eac1f47d8bb@mendix.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <116d578f-8c21-366c-8eb8-84f2ca23c486@gmx.com>
Date:   Tue, 9 Oct 2018 09:14:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <cd511cfa-baa2-6a13-2802-6eac1f47d8bb@mendix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7rfzG6h1pVShvvO4Z8nCHqUHgVScAYg3c"
X-Provags-ID: V03:K1:YDMpeLkEBX5B7J+Gwr4TF+Hy2yxQe4vh8/LW4KFt6kFJxgjLxdt
 krtH19RJjX02pt9pTog8FSyEa34ZZGduAwXCBUKNUga26vlvmCunuTtRIBgL+0t08cI9HIL
 HHOEPEdSNWmy3arEUYCwN4VIljiq3Ctn81ChxMsEiCA4GgoShZiHCb79cZYc7um5Cc63EBN
 ua+Y8a6QxoHOgwU7XlFBg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:X3KpjXKr1kE=:x+fvoVg5qwcI6vV+5J3Xku
 QdB55TzrC7pU+XFw1qd5nO0XDtibUOk+E3vwOsUCDN3/vULurDYqweb/wT955AfICxNwoQ4zz
 5dilxzwHwlSBeClJHP5OER3fqVq5mjsAb6TCPr+rCFGBUSTPfc//KTsyTUbhavhEQum5hXwRF
 dbDGZR0FkyUYwi3BbV0lxXRI92rptyYoy3FkMfaOTq01yfeAjIPFMMz5vYJQ46gof8YpCCqGY
 WG3dWBDTgwSC0p2NaAaRcVk8phiUiAGB0TpjmtnGw+XWoTson1LFxF4q0GM7Wd9jFMAIv8iGf
 RVUfBP/0XgxRF39YkPlLUNISRTP6t/MC+E28ECFezh/oclfOiudE9CFH1tpeMG8vpph/DimCi
 MValesAHXaSZDS4uPHfFTDF0aRT0nrkIGv3EajIxscj0ULxgR9RkPhkDavqMfmWp5dL2uqGVn
 7YFgner++gJL1FYIEcoXSHY4YA+tCWqpqzfaF8y4nkZ2MHiZ8A0LzpBqSgaPufpeSrSt0jkTb
 nQKg+lCf/Sp8CQpaHuqZSSmO9fLYfDDtobjMhG3JKTMbusA1cBLNs1lVq6HaWn3FyAjTvOc+k
 F1/xQ9WlBnKbLRWemiqhMHlwog+Jvc4Jm2BMbs6lU7G1HKSwtVF9HaodtpzUWxgH/IXQq8kdN
 ZkgDYiAO/xUvv0/SD+NdGYUhvQ8behYCyM4LiDd4n2Y2e5VVtScR3tbuoVy/twna477Xz6n0T
 c1zhzHvl2lYanM1MmVzkLfkpXpB59fU+ll9wL7AuGCo623kev4xiYjnHcaE8IFftAMGu1jJCR
 i2bq55Fytidn7SlhpwAodgkDpoC3Q==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7rfzG6h1pVShvvO4Z8nCHqUHgVScAYg3c
Content-Type: multipart/mixed; boundary="hLrxXN03D3g9hphVjFg7IH4T8EJngoCxF";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
 Qu Wenruo <wqu@suse.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <116d578f-8c21-366c-8eb8-84f2ca23c486@gmx.com>
Subject: Re: [PATCH v3 4/6] btrfs-progs: lowmem check: Add dev_item check for
 used bytes and total bytes
References: <20181008123044.13413-1-wqu@suse.com>
 <20181008123044.13413-5-wqu@suse.com>
 <cd511cfa-baa2-6a13-2802-6eac1f47d8bb@mendix.com>
In-Reply-To: <cd511cfa-baa2-6a13-2802-6eac1f47d8bb@mendix.com>

--hLrxXN03D3g9hphVjFg7IH4T8EJngoCxF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/9 =E4=B8=8A=E5=8D=886:20, Hans van Kranenburg wrote:
> On 10/08/2018 02:30 PM, Qu Wenruo wrote:
>> Obviously, used bytes can't be larger than total bytes.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  check/mode-lowmem.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
>> index 07c03cad77af..1173b963b8f3 100644
>> --- a/check/mode-lowmem.c
>> +++ b/check/mode-lowmem.c
>> @@ -4074,6 +4074,11 @@ static int check_dev_item(struct btrfs_fs_info =
*fs_info,
>>  	used =3D btrfs_device_bytes_used(eb, dev_item);
>>  	total_bytes =3D btrfs_device_total_bytes(eb, dev_item);
>> =20
>> +	if (used > total_bytes) {
>> +		error("device %llu has incorrect used bytes %llu > total bytes %llu=
",
>> +			dev_id, used, total_bytes);
>> +		return ACCOUNTING_MISMATCH;
>=20
> The message and return code point at an error in accounting logic.

One of the biggest problem in lowmem is we don't always have the error
code we really want.

And that's the case for this error message.
It's indeed not an accounting error, as in that case (just like that
test case image) the used bytes is correct accounted.

The good news is, the return value is never really used to classify the
error.
So as long as the error message makes sense, it's not a big problem.

Thanks,
Qu

>=20
> However, if you have a fully allocated device and a DUP chunk ending
> beyond device, then having used > total_bytes is expected...
>=20
> So maybe there's two possibilities... There's an error in the accountin=
g
> logic, or there's an "over-allocation", which is another type of issue
> which produces used > total with correct accounting logic.
>=20
>> +	}
>>  	key.objectid =3D dev_id;
>>  	key.type =3D BTRFS_DEV_EXTENT_KEY;
>>  	key.offset =3D 0;
>>
>=20
>=20


--hLrxXN03D3g9hphVjFg7IH4T8EJngoCxF--

--7rfzG6h1pVShvvO4Z8nCHqUHgVScAYg3c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu8AOEACgkQwj2R86El
/qggzQgAslhirzQGfuRvzapvby8L9J7W7rjoedRm2JvLldNotkvW2LvE1uKJAN3N
nMVeFKhkpOFwfb5LCskjgg5LAF3LH8dcWzjnubv2ISXPBNZ+iBvV8gw9eicFFV0K
kl7emNR0baFHqLZdtFsLYGm8YEJDfhlN7YGpH8cOUyV1Iz4T23Gj4O8h6nHpAG/N
jV7d8IWqQB6xH3mZe2OlnpjCCFI1cu/z/aC16lWRHwO/bfuNRFozM/RTono46zy1
8ThgXyDj1d5r3EKJ5+0yl3aMNzAu00jTdwWGLi0/NMgYc3adz1LJ5u+yqXBBS7XD
5gD7TsRwCwNi5k57g2WI/q5crXWRgw==
=fJTa
-----END PGP SIGNATURE-----

--7rfzG6h1pVShvvO4Z8nCHqUHgVScAYg3c--
