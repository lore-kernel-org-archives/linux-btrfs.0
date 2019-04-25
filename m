Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95102C43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 23:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A15A20717
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 23:16:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="UJziqJXS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfDYXQk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 19:16:40 -0400
Received: from mout.gmx.net ([212.227.15.15]:49997 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbfDYXQj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 19:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556234195;
        bh=wuSdJvflKXK+hsG2bS4m2V+ciEUKLKAOdfSte0W9xME=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=UJziqJXSHAsFKuoVaXKAvo7r6m4ty5XLI79ZyOznQqYs4zECoVPHLlsGe68ARE+N8
         uLOPvNzhn7XTAdboPrGqslHhwMEc5Zp417e4cPaxZOxRL4cMIOOdGO5pkhRpcCosRP
         fDw/GEr7ZXkEZu6JC2DX+cDAv3Lq2vguUmUrKwIQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N4zAs-1gd4K614iq-010sDd; Fri, 26
 Apr 2019 01:16:35 +0200
Subject: Re: fallocate does not prevent ENOSPC on write
To:     fdmanana@gmail.com
Cc:     Josef Bacik <josef@toxicpanda.com>, dsterba@suse.cz,
        Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
 <20190425132526.wjtcipkpm7fmbzyc@macbook-pro-91.dhcp.thefacebook.com>
 <6ce51e68-c120-ee5d-1ca3-4a6ae0727670@gmx.com>
 <20190425140957.oajm7seece2wfniz@macbook-pro-91.dhcp.thefacebook.com>
 <45eb63d3-affc-b4c1-d2ca-aad0ab55661c@gmx.com>
 <CAL3q7H6stfupF+npJLmukqfj8yZ0MRMf9Y4BkS1GLWjN1NPPTQ@mail.gmail.com>
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
Message-ID: <9acd2130-7aa1-c37c-d407-f4df1de5bb6c@gmx.com>
Date:   Fri, 26 Apr 2019 07:16:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6stfupF+npJLmukqfj8yZ0MRMf9Y4BkS1GLWjN1NPPTQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OMltLkQvvgWXxwj2pXdMsMU4dQzhf8vLI"
X-Provags-ID: V03:K1:kQ+Ust7s8dGTUW/BWvSUjH78AWgzAa5IINnPPaur+1GGaSaE/kU
 1ZjVQlA2ZCyJWXHQeogIRBD/ktaZmRuzRzdF1gPA/dk/1KJDFx6YBw9ddjbHPoekq5UjIkv
 FKfSEKSKORdYbaYCdJ5eYRWqwMmqOvF+679avdiWJwwhoiIeX7aFIP3AfLjh8FgjzxnH9QA
 5AoBbo+d3gDutExwNQMOA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Qk56z8dDCMM=:JCLTP/KSz6K0jIIZamcK0f
 X8JdT3QcBkAExsftCtkC0DbSM0ij4KkLVVhCoAZJV4FViUaQrn/Iheo3/ICCKIFWcR8REVxmf
 0kA6xIFyuwvCYO8GTf7ZuL55KBS7hVl5kgeUfIvfxVz9ByMmg60OI4a6EHJjPjr0AfwDMkpG2
 mW/TANV745WGkQN4rMLF0ZNRrkdw/UYwpYBUp6uVy7Ud7kSvGXo4D/QjSs+qG1yPC/B6y0QgD
 tzMZ06AFO8rqHyttMpqiqtOEn10g/N2K+Ejv+OQ0/LScj4CL6YGKCS/HVF6js56cRRYBvocqi
 U7tMv06Ae3M1ud4PVcQXiaOKaIU1mGZKNVqdRRjf8LjplsaiJmLaK55/USp6BXhxdKT5TC56E
 NOIhmekRUdK+mT7mIq+N2e5WimkSZcLGnLOJXsxwIoEOtKVdLKsQye0uSTgeaFxLyruvhM+mm
 c0OIdJH6VRd/MQVgw6Mh4H3HCB/ASQJuo66s2mC8qd+BgbjiILWtMiL3jFmo/a/GaquN8qBUl
 zZ8kkqOF2KpYHPeMtgbPWvqtczRKGrlwHTs0GnY3yl8wCMovk9XcvPaRDLcskrAFm7MbKMjFS
 6GsNjqTE49NAv8UPteWT0lYgEJ42T7X6Tbkgb0MudwcvyYXaw/37pEDzI1KRKaHv9MWwzAgBc
 eclg9lPgn1XTmxjS630TRfR9TLsdCxKHFwNH+ia5TFbkwBG/i4wh45bcFESlzC8feqbnp4wz2
 /93Hb5waoevDa2ztNvK6l3g+Tyvs9sFhiws5lo9/jEIZ5LHeNzMMQUlRI9ydGtwgG119F5Fpk
 B3Dc1z9l8h0+1gGv1j2tl5O4kF21nMulki2jiY4Ijh7cbqK0nTj5L0oWPCyyUMmxlKQUGCNcG
 ucBvhOZZFXgtTrLLQdCL8KpBeuDIg6QEd9fdzOF0PL4OOJwWUreanedUJTE0+t
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OMltLkQvvgWXxwj2pXdMsMU4dQzhf8vLI
Content-Type: multipart/mixed; boundary="UgqiaQqnHuv5zPm4a1WHlRw4aIWICkM8T";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com
Cc: Josef Bacik <josef@toxicpanda.com>, dsterba@suse.cz,
 Jakob Unterwurzacher <jakobunt@gmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <9acd2130-7aa1-c37c-d407-f4df1de5bb6c@gmx.com>
Subject: Re: fallocate does not prevent ENOSPC on write
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
 <20190425132526.wjtcipkpm7fmbzyc@macbook-pro-91.dhcp.thefacebook.com>
 <6ce51e68-c120-ee5d-1ca3-4a6ae0727670@gmx.com>
 <20190425140957.oajm7seece2wfniz@macbook-pro-91.dhcp.thefacebook.com>
 <45eb63d3-affc-b4c1-d2ca-aad0ab55661c@gmx.com>
 <CAL3q7H6stfupF+npJLmukqfj8yZ0MRMf9Y4BkS1GLWjN1NPPTQ@mail.gmail.com>
In-Reply-To: <CAL3q7H6stfupF+npJLmukqfj8yZ0MRMf9Y4BkS1GLWjN1NPPTQ@mail.gmail.com>

--UgqiaQqnHuv5zPm4a1WHlRw4aIWICkM8T
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/25 =E4=B8=8B=E5=8D=8810:43, Filipe Manana wrote:
> On Thu, Apr 25, 2019 at 3:28 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrot=
e:
>>
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
>=20
> I don't get it. Why is this unexpected error?
> You created a fs with 512Mb, fallocated 384Mb for a file named file1,
> and then tried to write 384Mb 512K * 768 to a file named file2 (i.e. a
> different file).
> Wasn't the test supposed to write to file1 instead?

My brain wasn't working last night. :(

It should write into file1, and it passes in that case.

Thanks,
Qu

>=20
>> 95+0 records in
>> 94+0 records out
>> 49283072 bytes (49 MB, 47 MiB) copied, 0.0807034 s, 611 MB/s
>>
>> Thanks,
>> Qu
>>
>>>
>>> Josef
>>>
>>
>=20
>=20


--UgqiaQqnHuv5zPm4a1WHlRw4aIWICkM8T--

--OMltLkQvvgWXxwj2pXdMsMU4dQzhf8vLI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlzCP80ACgkQwj2R86El
/qj6hggAiQL3coYggvb7Otkykm9m6rjTigZ+VTt2SZdgN218ibFr2rS+jdRDAMHN
kBzYOoCfEgWae3FzrceHtvXr7b++AXhxOYrSv3murLIh8+8yZtxwlAnumFIABTgB
seDlyRZxRMK2EMFGwnBbOCSozfShESUIO5eXr++TN28+fnWpgbBsHOCKhc74EoDt
I7fH/xQDCbrd9GF0LxHfG1umWvyI/UGxULlCDPRwdNXdiFExx+HMWjfTp0sBvoQL
EzF2pIjImfM7eGFcCxAA/dqmXzsFUDuwiqybjTBJ7sYUA+T11MmlKmiQ/ArmQ/yl
uxtTII3tZtLTDRotK2vmDjRhmmqk6A==
=Ez+R
-----END PGP SIGNATURE-----

--OMltLkQvvgWXxwj2pXdMsMU4dQzhf8vLI--
