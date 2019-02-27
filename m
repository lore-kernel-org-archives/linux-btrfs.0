Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397EAC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 13:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 081CA2133D
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 13:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbfB0Nks (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 08:40:48 -0500
Received: from mout.gmx.net ([212.227.15.19]:47345 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730264AbfB0Nks (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 08:40:48 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M2c1V-1hFhNk0hPB-00sP5K; Wed, 27
 Feb 2019 14:40:18 +0100
Subject: Re: [PATCH v5.1 00/12] btrfs: Enhancement to tree block validation
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190218052753.24138-1-wqu@suse.com>
 <20190222151832.GG9874@twin.jikos.cz>
 <29397247-a244-ea7c-3c34-8e65642b927c@gmx.com>
 <20190227122235.GE24609@twin.jikos.cz>
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
Message-ID: <88d6815c-1e15-4f89-54f4-bcb6cd2177e6@gmx.com>
Date:   Wed, 27 Feb 2019 21:40:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190227122235.GE24609@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DCNaCruKAKRvTiFRjgbvcWryM8EFWA5u9"
X-Provags-ID: V03:K1:DXI45MRGclxuwzu426KFzf8pOF1YbUFkbbtUBmHbbvZmYyEN3Q+
 //LhaTD/d6mm8MRDve5LyvcihOMRR2OZhY3UwL/NLvIeCzPDLWagAOn/94I5qnLGrWNlnxd
 KsasfyCP1TpD6o4ehnoG+k55sfMKkUDkjpUF/DLm/GaMd3Z5hBY+5wRpBa7F3dU5hVS/e1i
 E9JsQWkttJ8Bmw4V32rjQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:oEnolbV6rFo=:r6z3s/0mkgan8XcKJN9Y+D
 34p6a866M/Scm8Y50Y6SugLj3pxYqKogWChNfqNL5SPRhUDZuBT6P5SdawLTQK4oDx28LaRWc
 /PAnQPrFIJgwRRW7XqmFiG0ZQoAsHGZCe82hcDjP2ENroh9sDiJe8jpDcUsdbu31L0aI5G26N
 v0mlTn6XU8hqr394xL96GasnnyfT/+SpWcOkBPrhNTr/7V2PceRsf+hoWviDhfwojs7X96byp
 sokzHVpUcCTZLAt+7t31yt4umdx08jW0xqpjyqg1kJQ1agwEG3k5pxpPzzeCL0mcwrfCXyAix
 k8wONNOzC5WDjvIqtkxEwKjBuTLL5ECOpX11r8wj9TN9vc1lfyCGDnJ4siMiVzMSZc2+bnmq8
 qQ/8lH8ip68BoGGwikzt5FnIwbFUpRMt1Fa7EqCvK99byq5E5EYhj9bgm9uvdN6mpvJInkHLe
 4bbx0UC8XpLNFKk3y+j5nJjgA30HdOT3w1EmRXm9aZBNWJKxREoXb65SvoBZigp2XJbruKu2r
 hJnbPonNcytV7MywSXNZq/4seDfRsBT+V3HcbQXnsxTb1eHKjYwQNwXSaIh/OTqtaGqm7K244
 AMz4pYPjUoHzpgg4L6Un1wkJX7D8ECXYkaD2Xc+mUuqkXCEmRt5cZx689se79w8mv/NEKMdxI
 WggJjNdOqlOPjJyEju/4a/PnxhoRbFVII5lMcY+Fht8zJb/OpjoPh4p/AVSDIxbdtzOXmg8+a
 lWepyLSApRLXykMTywMCuSlJaOe6QBmrqLX18G1269taVTY5jeUOwMV6L4l2up8nr6eXxlwc+
 RpmyPVE2lAzNgr1FcZ8uP93zX/Sl3LvVNpTw6H/wNXUZ64D9FxnrqFiyiCvjC2inDt1/CgX+P
 xngzsrv6z6/dpktUObl4+GRKEa3fKpPLIq/BCLLQiPUBgz2DTAyAaQq8HLzNmH
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DCNaCruKAKRvTiFRjgbvcWryM8EFWA5u9
Content-Type: multipart/mixed; boundary="258ajH5wsrySC5ef85UEOIEpuQv36NQdp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <88d6815c-1e15-4f89-54f4-bcb6cd2177e6@gmx.com>
Subject: Re: [PATCH v5.1 00/12] btrfs: Enhancement to tree block validation
References: <20190218052753.24138-1-wqu@suse.com>
 <20190222151832.GG9874@twin.jikos.cz>
 <29397247-a244-ea7c-3c34-8e65642b927c@gmx.com>
 <20190227122235.GE24609@twin.jikos.cz>
In-Reply-To: <20190227122235.GE24609@twin.jikos.cz>

--258ajH5wsrySC5ef85UEOIEpuQv36NQdp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/27 =E4=B8=8B=E5=8D=888:22, David Sterba wrote:
> On Sat, Feb 23, 2019 at 08:47:09AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/2/22 =E4=B8=8B=E5=8D=8811:18, David Sterba wrote:
>>> On Mon, Feb 18, 2019 at 01:27:41PM +0800, Qu Wenruo wrote:
>>>> v5.1:
>>>> - Add "block=3D%llu " output for write/read time error line.
>>>> - Also output read time error message for fsid/start/level check.
>>>
>>> I see reports from tests btrfs/124 and btrfs/125,
>>
>> That two tests are RAID1 reconstruction.
>> It's known to trigger read error on missing devices.
>>
>> Especially for bytenr mismatch, as all read from missing device will
>> result 0 filled page.
>>
>> I could change the read time error message to skip bytenr/csum mismatc=
h
>> to avoid such report.
>=20
> Yeah the output needs some tuning. See the example below.
>>
[snip]
>>> [ 2860.244462] BTRFS error (device vdb): bad tree block start, want 3=
1703040 have 0
>>> [ 2860.248013] BTRFS error (device vdb): block=3D31703040 read time t=
ree block corruption detected
>>> [ 2860.284017] BTRFS error (device vdb): block=3D31719424 read time t=
ree block corruption detected
>>> [ 2860.315705] BTRFS error (device vdb): block=3D31735808 read time t=
ree block corruption detected
>>> [ 2860.336001] BTRFS error (device vdb): block=3D31752192 read time t=
ree block corruption detected
>=20
> Block 31752192 does not have any previous message about a specific erro=
r
> (unlike the 'bad tree block' messages of other blocks). I don't think
> it's good to print just the 'read time' message.

The first is caused by the bytenr mismatch.
But for the remaining 3, they can be caused by read error from missing
device. EXTENT_BUFFER_READ_ERR would cause no detailed error report here.=


>=20
>>> [ 2860.336054] BTRFS error (device vdb): block=3D31768576 read time t=
ree block corruption detected
>>> [ 2860.339786] BTRFS error (device vdb): block=3D31784960 read time t=
ree block corruption detected
>>> [ 2860.366693] BTRFS error (device vdb): block=3D31768576 read time t=
ree block corruption detected
>>> [ 2860.389495] BTRFS error (device vdb): block=3D31784960 read time t=
ree block corruption detected
>>> [ 2860.418551] BTRFS error (device vdb): block=3D31866880 read time t=
ree block corruption detected
>>> [ 2860.418713] BTRFS error (device vdb): block=3D31883264 read time t=
ree block corruption detected
>>> [ 2860.418721] BTRFS error (device vdb): block=3D31916032 read time t=
ree block corruption detected
>>> [ 2860.418736] BTRFS error (device vdb): block=3D31932416 read time t=
ree block corruption detected
>>> [ 2860.418744] BTRFS error (device vdb): block=3D31948800 read time t=
ree block corruption detected
>>> [ 2860.419721] BTRFS error (device vdb): block=3D31899648 read time t=
ree block corruption detected
>>> [ 2860.462401] BTRFS error (device vdb): block=3D31866880 read time t=
ree block corruption detected
>>> [ 2860.490821] BTRFS error (device vdb): block=3D31932416 read time t=
ree block corruption detected
>>> [ 2860.506718] BTRFS error (device vdb): block=3D31899648 read time t=
ree block corruption detected
>>> [ 2860.535013] BTRFS error (device vdb): block=3D31916032 read time t=
ree block corruption detected
>>> [ 2860.568602] BTRFS error (device vdb): block=3D31948800 read time t=
ree block corruption detected
>>> [ 2860.590434] BTRFS error (device vdb): block=3D31965184 read time t=
ree block corruption detected
>>> [ 2860.590532] BTRFS error (device vdb): block=3D31981568 read time t=
ree block corruption detected
>>> [ 2860.590677] BTRFS error (device vdb): block=3D31997952 read time t=
ree block corruption detected
>>> [ 2860.590688] BTRFS error (device vdb): block=3D32014336 read time t=
ree block corruption detected
>>>
>>> [ 2860.590697] BTRFS error (device vdb): block=3D32030720 read time t=
ree block corruption detected
>>> [ 2860.590705] BTRFS error (device vdb): block=3D32047104 read time t=
ree block corruption detected
>>> [ 2860.625834] BTRFS error (device vdb): block=3D31965184 read time t=
ree block corruption detected
>>> [ 2860.658723] BTRFS error (device vdb): block=3D31981568 read time t=
ree block corruption detected
>>> [ 2860.696644] BTRFS error (device vdb): block=3D32014336 read time t=
ree block corruption detected
>>> [ 2860.735014] BTRFS error (device vdb): block=3D32030720 read time t=
ree block corruption detected
>>> [ 2860.743240] BTRFS error (device vdb): block=3D32096256 read time t=
ree block corruption detected
>>> [ 2860.780296] BTRFS error (device vdb): block=3D32047104 read time t=
ree block corruption detected
>>> [ 2860.807073] BTRFS error (device vdb): block=3D32063488 read time t=
ree block corruption detected
>>> [ 2860.807173] BTRFS error (device vdb): block=3D32079872 read time t=
ree block corruption detected
>>> [ 2860.841582] BTRFS error (device vdb): block=3D32079872 read time t=
ree block corruption detected
>=20
> This long sequence of messages lacks details about what happen, and
> there are duplicates (block 32079872). If this is caused by reads from
> missing device, this can potentially flood the logs.

Not only from missing device, but also from stale old device.

Anyway, since I have reverted the behavior to the original one, which
only output the "read time" error message for tree checker error, it
should no longer flood the kernel message.

Thanks,
Qu

>=20


--258ajH5wsrySC5ef85UEOIEpuQv36NQdp--

--DCNaCruKAKRvTiFRjgbvcWryM8EFWA5u9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx2kzwACgkQwj2R86El
/qg1rwf/f/ZEAsPNo+xQSvDdViCBUsFc1/g8tl/CxxAiHuvS7Kwj1+PW2vhYoK40
U2OV/+kwD0sXNT5sAnTQJh7W5rtS5jH775bDQ4qCmQE0rn2noVcYWxjNIYWuWSp1
oI+7qKfCXs7+Jj2GHABlb0U4bJxW9NgePVNA8NQeJR42Z5sH634f0ZC1Kl9CJ3V4
CHKI3U3d4bEyqnui8Mo05QvnYvCdKKfOCm3uho9Fkj+oPxjdwHcFV7P7+kLOJifz
E/qGKCSisoWNCqsXOS0oyB9z4FJhaF1UtHxjxXQW4Pnau5naYlr46bxO1yfeoxEX
Jj+V0lvioLUbTsMco5dLhgbD/s/kJg==
=3Dkw
-----END PGP SIGNATURE-----

--DCNaCruKAKRvTiFRjgbvcWryM8EFWA5u9--
