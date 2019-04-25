Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D11CC43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A14920717
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:16:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Lrz7+wG3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbfDYOQq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 10:16:46 -0400
Received: from mout.gmx.net ([212.227.15.19]:35855 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbfDYOQq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 10:16:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556201802;
        bh=35Hc9P/zYXel44wCiWCuOC5a1MJdtWD1EDERAVjWZRs=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Lrz7+wG3cqcRspfEGRDBkflqhti/bO0TYQx/BvO8cIE9BksiEs1o8G2uspE4hyEQs
         ez7Ke2RkXOP+aSRVovoUctM7KqPMgPxFHlvlku4OeOS+mz3OR7mTvseJLstolce9wl
         abolzVICCSCuF97tf0hM5tWVjz9vRDEzeMNzemHI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MfEMs-1h9Am233UY-00Olcp; Thu, 25
 Apr 2019 16:16:41 +0200
Subject: Re: fallocate does not prevent ENOSPC on write
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
 <20190425132526.wjtcipkpm7fmbzyc@macbook-pro-91.dhcp.thefacebook.com>
 <6ce51e68-c120-ee5d-1ca3-4a6ae0727670@gmx.com>
 <20190425140957.oajm7seece2wfniz@macbook-pro-91.dhcp.thefacebook.com>
 <45eb63d3-affc-b4c1-d2ca-aad0ab55661c@gmx.com>
 <20190425141357.yajfqg4pfuz5y63b@macbook-pro-91.dhcp.thefacebook.com>
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
Message-ID: <d5b11933-2cf3-5264-5378-1abf1c220296@gmx.com>
Date:   Thu, 25 Apr 2019 22:16:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190425141357.yajfqg4pfuz5y63b@macbook-pro-91.dhcp.thefacebook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZYd71mhLIVa6puROeZk3XveMQpd2loUod"
X-Provags-ID: V03:K1:/3C8aNE/6Emnps7o6WdfoWW61Nxfc8sFBGjLdf9l5TxarDj09t+
 T2uwQo93tq1+y7jZG2YLXLsiDOPbWH4J+SOVxNawMzmsJ9WLVlWqZyHordacobf4eZxRiLE
 TXxQakdSaM5B48zqSVXr7qgxW86WbS9mOhbEoVrGuqWj5eS6vhWanbemdXGLt5jIKdDkBtS
 ZRF7Nj2FdOmBCePmwGHAw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZJLWk8fCqgg=:L7o9xucQ0OX9Ez70klLeUC
 WZx/N6UrCHe3lWaJAzpP2S/z8cenYWZ39E6W0h29ORpyA6CmrBERhcaTFXNxknK4BAHGeO14O
 +yE+vChrB34B9ZSI7TRLhnfO/Pr8AHzAfeISJKfE4KRCzoz6iGYiktr6XVqYJOvZoJ4UyPw7g
 82DJbceveiZa7xVuB9F8r5oeZ5YmhscPLP7/SRmo8+ekU9Johci6dPvoO3LNRpex2/0Fqu5W6
 Zw0RaURkLWZ34WyXbZnG2MCbWBGUBjhUhJYyE6MA0AXUx99+nZKCMhPHlbs1xIkov4FLwcXix
 MyxMzVigtwongYTzQm6bPADcx+bE5GIFIOM9l+ixGZBw218YtS7neqKme3c7D+13VtuGQAFcY
 jCdhnKf8bEX1YtA8gfgI+9EBzPNQDTBHYiWvlJ3KQOqpHxkRem2TGqUa+numxlNJPcYseCohl
 T9xl6ucCmIVB5IB1fjAaOl03MDuAa9Pm9d1f3GCChJ8SAh3QIoWIYa1SIpseS9xJz3smB9/Mj
 wmHGQDT8a4FSg+bCw46CI8Tnuy6STCQPtn7lwF1Uj15CD9YOcxf+DypA9Hjtu28VRexSGPqU4
 LX5b+2stfSmKNdPvt+SIS2P5aZywW5Yct06IA+8anVhMZfwvuYl7FKjmTcsNtpy5ImL7cZJr5
 m3LzTGAfyf+96gc6YxCkAWsgzDyyJjb6UBOlTeTSO5oToNFPB4gT2cTQ9jJt4f7u6DPE1wXQb
 kNKWyGtmhDbK3Aig1TbTYHh86CGIkfLC6LzkcLGla6sGYikw/dZCFYrOKV1qTV+ZW1l7Wka1w
 jjcQMCZ9YJ16wP3dPNRF5hzHtIMinkKHSD563whAoeWEGq3ZiFfPtpHUuFTY1n7T5MvZD2wJI
 5bdPmva0trMTeNLJeeXOuuJ5Stf7VEJnz1z8/FBWnNDisQ1RbzfhvlcMEXB10w
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZYd71mhLIVa6puROeZk3XveMQpd2loUod
Content-Type: multipart/mixed; boundary="6YRqHVOq1sUwwWzz8zl9pMiWZPjBMYn8b";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <d5b11933-2cf3-5264-5378-1abf1c220296@gmx.com>
Subject: Re: fallocate does not prevent ENOSPC on write
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
 <20190425132526.wjtcipkpm7fmbzyc@macbook-pro-91.dhcp.thefacebook.com>
 <6ce51e68-c120-ee5d-1ca3-4a6ae0727670@gmx.com>
 <20190425140957.oajm7seece2wfniz@macbook-pro-91.dhcp.thefacebook.com>
 <45eb63d3-affc-b4c1-d2ca-aad0ab55661c@gmx.com>
 <20190425141357.yajfqg4pfuz5y63b@macbook-pro-91.dhcp.thefacebook.com>
In-Reply-To: <20190425141357.yajfqg4pfuz5y63b@macbook-pro-91.dhcp.thefacebook.com>

--6YRqHVOq1sUwwWzz8zl9pMiWZPjBMYn8b
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/25 =E4=B8=8B=E5=8D=8810:13, Josef Bacik wrote:
> On Thu, Apr 25, 2019 at 10:11:41PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/4/25 =E4=B8=8B=E5=8D=8810:09, Josef Bacik wrote:
>>> On Thu, Apr 25, 2019 at 09:50:25PM +0800, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2019/4/25 =E4=B8=8B=E5=8D=889:25, Josef Bacik wrote:
>>>> [snip]
>>>>>>>
>>>>>>> What if the commit is reverted, if the problem is otherwise hard =
to fix?
>>>>>>> This seems to break the semantics of fallocate so the performance=
 should
>>>>>>> not the main concern here.
>>>>>>
>>>>>
>>>>> Are we sure the ENOSPC is coming from the data reservation?  That c=
hange makes
>>>>> us fall back on the old behavior, which means we should still succe=
ed at making
>>>>> the data reservation.
>>>>>
>>>>> However it fallocate() _does not_ guarantee you won't fail the meta=
data
>>>>> reservation, I suspect that may be what you are running into.
>>>>
>>>> For this script, we only needs 4 file extents at most.
>>>> Even the initial 8M metadata should be pretty enough, thus I don't t=
hink
>>>> it's metadata causing the problem.
>>>> ---
>>>> #!/bin/bash
>>>>
>>>> dev=3D/dev/test/test
>>>> mnt=3D/mnt/btrfs
>>>>
>>>> mkfs.btrfs -f $dev -b 512M
>>>>
>>>> mount $dev $mnt
>>>>
>>>> fallocate -l 384M $mnt/file1
>>>> echo "fallocate success"
>>>> sync
>>>> dd if=3D/dev/zero bs=3D512K  oflag=3Ddirect conv=3Dnotrunc count=3D7=
68 of=3D$mnt/file2
>>>>
>>>
>>> Wellll we don't do the nocow check _at all_ for O_DIRECT, so mystery =
solved
>>> there.
>>
>> Oh, wrong flag, remove that oflag and we still get the same problem.
>>
>> fallocate success
>> dd: error writing '/mnt/btrfs/file2': No space left on device
>> 95+0 records in
>> 94+0 records out
>> 49283072 bytes (49 MB, 47 MiB) copied, 0.0807034 s, 611 MB/s
>>
>=20
> Hmph, then I'm not sure, and I've already exceeded my allowed btrfs/thi=
ngs I
> enjoy time for this month.  If we really are getting enospc from the da=
ta
> reservation then it must mean that the nocow check is failing when it s=
houldn't.
> It shouldn't be hard for you to narrow down what's going wrong.  Thanks=
,

Yep, no need to bother, I'll pin down the problem.

And thanks again for your idea on the bytes_may_use fix.

Thanks,
Qu

>=20
> Josef
>=20


--6YRqHVOq1sUwwWzz8zl9pMiWZPjBMYn8b--

--ZYd71mhLIVa6puROeZk3XveMQpd2loUod
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlzBwUIACgkQwj2R86El
/qjLHAf+P5dNtfGE1Z/aq55YXF6Son43GhIxx9S72i7tTXg6WBTWREWDm+kiOpyZ
bRa829r9HYMGxAEkngSw1D3ikJkrpYkSAVN+JAC5a/ddPZ8ITCnHJEapGFCM6h1L
8oL90RQ+n3Qcd50jO3nTeczBXf9SLypRFgn8+Nu2YbvU/KEnMO2jffuLrhWQJSTl
AfWxr6GoI6S2mxEqs92TRx/aeXuHwnPkW4TkvP5jtkT5wTSdPHXOAKavfAUoPG7u
d00vo93T8XX6QVxeCV78FomWe6uURsqLVCNDqrOQLHM6uffNfxkIXkvGP/VoShUZ
8krBbSPHV/XKsO5MSThaWmyNyoCdOg==
=CFeR
-----END PGP SIGNATURE-----

--ZYd71mhLIVa6puROeZk3XveMQpd2loUod--
