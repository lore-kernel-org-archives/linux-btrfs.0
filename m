Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BF6C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 12:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F02F62084D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 12:45:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="hgRgZSiV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfDLMpP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 08:45:15 -0400
Received: from mout.gmx.net ([212.227.17.21]:58695 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbfDLMpO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 08:45:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555073110;
        bh=W1cF3NAPDda6x93+vzoX8X4RNTDSpPkdWxO9IqZwIp0=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=hgRgZSiV/yEGY15UeErdWPTemDDv8W7GiWD+V7gvw25bjbZBJs82ZL/c0mQf/Wo6Z
         2aEeCPvTgZ9BPYWfDJPe7VWKzKsLcEASoYYgzqsLxxim/EQti7VGUUKvZoQMYJFSYm
         gIZ9CkzO+e/9cLcN9UNkHUfLn6VabFI2g38aAemk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Ldspr-1gXeis2KI7-00j13g; Fri, 12
 Apr 2019 14:45:10 +0200
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     "Nik." <btrfs@avgustinov.eu>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a75981da-86f7-e0fb-d1dc-a2576b09c668@gmx.com>
 <039ec3eb-c44e-35e9-cf1b-f9f75849d873@avgustinov.eu>
 <c69778f5-a015-8b77-3fab-e41e49a0e0db@gmx.com>
 <51021dd7-b21b-b001-c3f9-9bc31205738b@avgustinov.eu>
 <00e3ddf1-cbd7-a65a-dee3-ca720cecc77d@gmx.com>
 <a6917f39-eeb4-5548-f346-a78972c7c3fe@avgustinov.eu>
 <6a592ffa-4a5a-81af-baef-8f1681accc87@gmx.com>
 <2c786019-646a-486f-1306-25a3df36e6b3@avgustinov.eu>
 <52b23bd7-108b-63f3-b958-2a5959c7ca6e@gmx.com>
 <f2b33d93-aa37-9fd3-6036-44e1e3f065eb@avgustinov.eu>
 <a9135dba-26fe-777f-048b-87052d5cbd14@gmx.com>
 <21ff2435-af15-573c-e897-05ceb4f42e0b@avgustinov.eu>
 <CAJCQCtQJkJwEyouCUzcV1MzPkcxhvtqxkWqmrwnB9txV=MUTXA@mail.gmail.com>
 <3f1f66d3-e04e-de16-e9a4-7c8a6238d5b8@gmx.com>
 <246c2330-acb6-3205-0468-051bacbfaeb5@avgustinov.eu>
 <24ab8eed-a790-bff2-cdad-0b091f7d0fe9@avgustinov.eu>
 <917e0530-7f68-a801-d87b-d00bb4e10287@gmx.com>
 <fea90c59-9aad-e997-8763-6c9221652acc@avgustinov.eu>
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
Message-ID: <a6948885-53ab-4e8f-b147-1a57d82a3022@gmx.com>
Date:   Fri, 12 Apr 2019 20:45:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <fea90c59-9aad-e997-8763-6c9221652acc@avgustinov.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Uxql1LKAeqzJRTAGQn3uDTfUX1SMc1Quv"
X-Provags-ID: V03:K1:8xD9frqf4ViSbU1GhLnmNeMaDcZLpkf8OiaiizyfiiE6ZlJJUCs
 bCc1fUOmyqTO4WJyNrLN7QsUIulP2hxDm1iN4aJD/SBGoggwYmZL49DlASrVcgbPQCYEz50
 D+PgcDae4ffTRv9kNs97s+YpSgtovswkD2L8tTSvabQAk1IKa5ipVY34TI1YA3LlcWfeiiR
 53/FqrxaTZimNqHTfCfqw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:0IEWW/dFrhk=:ZAhELeR6gZ3DbdNQaPA/Vd
 cqMChUAXde+2XgmbrRMJ4BFe2ju9JEtER5gPIVpnd6SQThdWJGm3VdPaKs912KKHcl/WMi/nX
 ynDBRLf3c/JmUVOWSOstKjBjtSBoLaL82iL5N4leVtV+5GLNVPbOqdIEK3Acqu3JzZg92gqON
 dKNQp+PErnyrRKDbZQg9WHS49i9+6E+5R3qUhs0fyrR+uND3B2HscxZMes21m5Ec9BmABK6hw
 lubbsGtYCXSZfS2v7ViuNA8976T5a03ptHeKj4QpNdr6Yqg/4Nu+KazhfnTQnfOCQdZVEscuw
 J9vp+hNFItjPfBIdUFha1bYdLoyFQ9Kj9WnHK5hQApjwgP/etNrRRi5jplmEdyib/ZZjB2eRb
 31v+6XRWv0nztHu9fGylT0mAnV7g4ezXKGdAU0b+TuCjRo3RVr1/26KXS5zJAq+qj61D9CchC
 UAWnUeHz/9sgtXK9NJ0Loa/IcbpjmS+/Jv9vJP1JKuHk9LbxrLqOxE7gPP/2X9MePZEpI4sgF
 rpPXs6Ao3duNQZM3RxDVmzTXWqzUYDvCmpae5J9jJd0VzNO8AXSt9rXAReJr56UErb4C1QNtk
 qCNp701pbrOY53ivSnvjVm28dqq7kHMhpzEfh2Mxyj3cHjyZ+JUBfOn6YJ7uCzi7xbJvzQDzX
 aufjlSUaGzu+BrfJtNCw3mwYwJehI+JLN3cSp3c4cvmo5pLFBieNyPR3IvEubC7QuPOGYrBgY
 DLHbnzkH6lCeHicK1WSt7VDsIUJm2Nk47IRDanCPaU1czDoShjWBws1jZHNSYYZ0ZSwiSf++0
 iwYLT0UoFWcYWfEBSnMR7T3SPpfFsk4B87XfKncWttjaEYBKTlJCaeGj6o/lccrQ/kr4Adqtq
 sRjNB5tav9FynYHxuTo+ZHrqGCe8IvkiEf/yiOb3JcDKSbUBYOz3g1yN8lgl0A
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Uxql1LKAeqzJRTAGQn3uDTfUX1SMc1Quv
Content-Type: multipart/mixed; boundary="pdb1508Ao38ETw370HNmLdUi2grKokiPE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Nik." <btrfs@avgustinov.eu>, Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <a6948885-53ab-4e8f-b147-1a57d82a3022@gmx.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu>
 <a75981da-86f7-e0fb-d1dc-a2576b09c668@gmx.com>
 <039ec3eb-c44e-35e9-cf1b-f9f75849d873@avgustinov.eu>
 <c69778f5-a015-8b77-3fab-e41e49a0e0db@gmx.com>
 <51021dd7-b21b-b001-c3f9-9bc31205738b@avgustinov.eu>
 <00e3ddf1-cbd7-a65a-dee3-ca720cecc77d@gmx.com>
 <a6917f39-eeb4-5548-f346-a78972c7c3fe@avgustinov.eu>
 <6a592ffa-4a5a-81af-baef-8f1681accc87@gmx.com>
 <2c786019-646a-486f-1306-25a3df36e6b3@avgustinov.eu>
 <52b23bd7-108b-63f3-b958-2a5959c7ca6e@gmx.com>
 <f2b33d93-aa37-9fd3-6036-44e1e3f065eb@avgustinov.eu>
 <a9135dba-26fe-777f-048b-87052d5cbd14@gmx.com>
 <21ff2435-af15-573c-e897-05ceb4f42e0b@avgustinov.eu>
 <CAJCQCtQJkJwEyouCUzcV1MzPkcxhvtqxkWqmrwnB9txV=MUTXA@mail.gmail.com>
 <3f1f66d3-e04e-de16-e9a4-7c8a6238d5b8@gmx.com>
 <246c2330-acb6-3205-0468-051bacbfaeb5@avgustinov.eu>
 <24ab8eed-a790-bff2-cdad-0b091f7d0fe9@avgustinov.eu>
 <917e0530-7f68-a801-d87b-d00bb4e10287@gmx.com>
 <fea90c59-9aad-e997-8763-6c9221652acc@avgustinov.eu>
In-Reply-To: <fea90c59-9aad-e997-8763-6c9221652acc@avgustinov.eu>

--pdb1508Ao38ETw370HNmLdUi2grKokiPE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/12 =E4=B8=8B=E5=8D=887:38, Nik. wrote:
>=20
>=20
> 2019-04-12 12:50, Qu Wenruo:
>>
>>
>> On 2019/4/12 =E4=B8=8B=E5=8D=886:44, Nik. wrote:
>>>
>>> 2019-04-08 23:22, Nik.:
>>>>
>>>>
>>>> 2019-04-08 15:09, Qu Wenruo:
>>>>> Unfortunately, I didn't receive the last mail from Nik.
>>>>>
>>>>> So I'm using the content from lore.kernel.org.
>>>>>
>>>>> [122293.101782] BTRFS critical (device md0): corrupt leaf: root=3D1=

>>>>> block=3D1894009225216 slot=3D82, bad key order, prev (2034321682432=
 168
>>>>> 262144) current (2034318143488 168 962560)
>>>>>
>>>>> Root=3D1 means it's root tree, 168 means EXTENT_ITEM, which should =
only
>>>>> occur in extent tree, not in root tree.
>>>>>
>>>>> This means either the leaf owner, or some tree blocks get totally
>>>>> screwed up.
>>>>>
>>>>> This is not easy to fix, if possible.
>>>>>
>>>>> Would you please try this kernel branch and mount it with
>>>>> "rescue=3Dskip_bg,ro"?
>>>>> https://github.com/adam900710/linux/tree/rescue_options
>>>>>
>>>>> I think that's the last method. Before that, you could try
>>>>> btrfs-restore, which is purely user-space and should be easier to
>>>>> setup
>>>>> than custom kernel.
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>
>>>> Tried "btrfs restore -vsxmi ..." (it did not work before my first
>>>> email), it is processing for at least 6 hours until now. It seems th=
at
>>>> despite many error messages files are getting restored. As soon as i=
t
>>>> finishes will check what is the result and give feedback. Will also
>>>> test the mentioned kernel branch.
>>>>
>>> After almost four days only about 120 GB of my initially 3.7TB of fre=
e
>>> space remain free, and the restore is still working (how about
>>> introducing a "progress" switch?)... I guess that due to the option "=
-s"
>>> and the lack of deduplication the snapshots are going to fill all the=

>>> space without reaching the "end" of the file restoring system.
>>>
>>> Until now I still did not have chance (and time) to compare the resto=
red
>>> with backups, but at this point I would like to ask you: what else wo=
uld
>>> you like to know|try|do? Should I try the mentioned above kernel and =
its
>>> rescue options?
>>
>> That's the only remaining thing you need.
>=20
> Ok, the "git clone ..." just finished, but in your earlier mail you
> spoke about kernel 5.1/5.2, and the readme of the above repository is
> talking about "Linux kernel release 4.x"? Since building the kernel is
> not a "minute" task (especially when building on atom processor), I
> would like to double check the steps to be done.

It's based on v4.20 kernel I think.

I should refresh the patchset on latest branch before re-sending it to
the mail list.

> Until now:
> $ git clone https://github.com/adam900710/linux.git
> $ git checkout --track origin/rescue_options
>=20
> What next? No autogen, no configure. ... The Readme refers to
> "Documentation/process/changes.rst", so am I going to follow its sectio=
n
> "Configuring the kernel"?

Oh, that's will be problem.

Kernel config is done by "make menuconfig", but if you're not familiar
with that, you can easily get a kernel which can't even boot.

So just forget this, it's not risky, but very time consuming for end
users, too many things need to be learned.

Thanks,
Qu

> If there is another description of the steps to be taken somewhere -
> please provide a link.
>=20
> Best,
> Nik.
>=20
>> In fact, I didn't consider the size of the fs, and for that large fs,
>> rescue mount option should be the first choice before btrfs-restore.
>>
>> Thanks,
>> Qu
>>
>>> Something else, which is risky and should not be tried
>>> on a production system?
>>>
>>> Kind regards,
>>>
>>> Nik.
>>>
>>> --=C2=A0
>>>
>>> [snip]
>>>
>>


--pdb1508Ao38ETw370HNmLdUi2grKokiPE--

--Uxql1LKAeqzJRTAGQn3uDTfUX1SMc1Quv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlywiFEACgkQwj2R86El
/qh73gf/Wwn94dhiTrZV6UCjDO/FqIbxhoJmOtvjc2vWIk2LPuJZ1tkydy+tA7oU
7pgAHBsoCk0gUMOkEotmnVjL3HDPYoCesxNO5AVZrX9RCRPyBN5rk+VJ2mzz8A9v
lVOuJ0uzm44cVDVERvW6ORbHnS3jvra/bFWxX2Gms39pPCgczLGUIkuoINbQk8nd
UAz3/OM3+bkTi6+38xDEYkLg5x9lOZ8IkfLJonn4HaxM3+pz4Ak1o/12BoiLhYlo
DVcqYPjhfgVA9rc+vZt4v1ISgFLchA6eQHF/zQllsYL0ea9NqAUTlHkEvLx43TFj
fy8JTAMBzXElqsVQzqnhcyrm6la8iQ==
=0d2l
-----END PGP SIGNATURE-----

--Uxql1LKAeqzJRTAGQn3uDTfUX1SMc1Quv--
