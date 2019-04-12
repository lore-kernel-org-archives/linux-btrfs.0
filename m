Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2477AC10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 10:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3CD32084D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 10:50:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Phyp4Ej/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfDLKuo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 06:50:44 -0400
Received: from mout.gmx.net ([212.227.17.20]:38135 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbfDLKuo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 06:50:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555066238;
        bh=1QSffo0qH0rJSatRcycBHmME1+dOe3ZlJK+C2Eo2cZo=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=Phyp4Ej/pvSDPCSIYnGPrMkWRm60Alru5+Ldo7/Uj2FCn06u3XAcnz6Zk+2qySyIw
         qccM4pmKlF0uthWljQvMoy7b8I9myHJYh+4hBDh8FHW1iTsKvNhY462yFKSlHECpfX
         xsC+WBmqwkZlq0GUHqEiO7eYjAnR7+T9CiHKy1Hg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MQ6oB-1hBLG32mxP-005FcQ; Fri, 12
 Apr 2019 12:50:38 +0200
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     "Nik." <btrfs@avgustinov.eu>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
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
Message-ID: <917e0530-7f68-a801-d87b-d00bb4e10287@gmx.com>
Date:   Fri, 12 Apr 2019 18:50:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <24ab8eed-a790-bff2-cdad-0b091f7d0fe9@avgustinov.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Tzklw4qfTG1r7UaOPTCgmpMvqDWWIOivL"
X-Provags-ID: V03:K1:Zqi2fF4pCVMrmLfloCeH9aoo4P1dHGUiTgi5Po22DR9CeBOF9+N
 vtd8hNNnjQdYnwNZt8mljkwEwZEt4l2Q2xreyMVAnLIcrT24Jhhps8McgpAH2I8cm81Tt90
 8VPpoOFpp0swZJW0TxR+fQNvhqPsAHmI0Gf+lvQSfVP/bi8L/7Xgb/MDo9eYx6sQ1tf6yMA
 HmPVy/5FXDSAptg7Et/xg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zpIr5Gd2Ve4=:XD/ZARRA2Iwpk9fDGa5C75
 4/z8NPMYmREGaCp5iBP0x/zABFF1AWg+NQeDVZOVVtTuudjBS9guWaoxzu9NFq5Nh7/1k7SKY
 ntlgQIuIcZNE2cOrx5Q9Ru7yZYD30RH3ecBL09zo4UxFW1D/Cg2penxJWu3O7D2l4LU9fr81l
 Jfi8R8ay4GLTZubhM1m7iAxAZM7mCg+Z6zV4Fl+DZ9e7zF7QRdr1hU86yLqslBOkpwgj0yNHT
 wlZlBS5yeIps9yvYyg3m0OazNU/3gL7x2gpmkpEgBdbjgY5Ku804tZ6GIg6rNujICyRQVenkG
 hLgN+smzigPzCoHrpG+uQoHags/k6zvIBynS41YAc6mnBC0aQHxw3Tgpe0QkaxwVkbyDH4FVB
 VI2KwMhV4/Vz0o8BqRRZ4a5XpQDbuOmjhYXsL0soWc6dWCWdrw/Jc5fD9b/enEOjfR2T7Rvpp
 MIy5YRJVE6I760+BzY8dIIoodEysZf57e6PLAprCAe/9htC192i78K+qcsDCWiukFbvIBXPmv
 Er1WRPsQuHO2FrB9k1BtX1ugE35PZNnAhsNWZct+u0fHGe2Mjwdz1vu8AraH/tUGM/IosTQdY
 yz1pR2GkdDzyfLI2l4oTwwOItnvEFeac7faplIrqCLseRWHkSjCAKJfokTnBL3k0cYY31odmc
 Fdpx/u95j0/YzOrYdmNP3Jd5lLVOC6uyqFBRNtxiIwRFCs+BFaotBSqWLUM9UGK6RvYJdLTg+
 5LNBFrkgRDype5KVqU/Gjr/TvA5jFwQX8hwyYGabAQyJXiB2I8OFN6zUSsdBjUJ+oLCOq8OWA
 77gOUl9Fe/57MHFZsPYXXOCrbAEAmpaTBD06/Ks2oI9tdjWyT7GoJgoAh6YdiBU4HfK05/SzT
 x9+I/wvckBfQURwiFcrJp8x9d6eyYrUtxf6NwchOsI1Uy4B5DjHGxXj4V+q/sE
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Tzklw4qfTG1r7UaOPTCgmpMvqDWWIOivL
Content-Type: multipart/mixed; boundary="tRet9c5jKlsw8ZjL8Nz73k2GMmCDws8fu";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Nik." <btrfs@avgustinov.eu>, Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <917e0530-7f68-a801-d87b-d00bb4e10287@gmx.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu>
 <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
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
In-Reply-To: <24ab8eed-a790-bff2-cdad-0b091f7d0fe9@avgustinov.eu>

--tRet9c5jKlsw8ZjL8Nz73k2GMmCDws8fu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/12 =E4=B8=8B=E5=8D=886:44, Nik. wrote:
>=20
> 2019-04-08 23:22, Nik.:
>>
>>
>> 2019-04-08 15:09, Qu Wenruo:
>>> Unfortunately, I didn't receive the last mail from Nik.
>>>
>>> So I'm using the content from lore.kernel.org.
>>>
>>> [122293.101782] BTRFS critical (device md0): corrupt leaf: root=3D1
>>> block=3D1894009225216 slot=3D82, bad key order, prev (2034321682432 1=
68
>>> 262144) current (2034318143488 168 962560)
>>>
>>> Root=3D1 means it's root tree, 168 means EXTENT_ITEM, which should on=
ly
>>> occur in extent tree, not in root tree.
>>>
>>> This means either the leaf owner, or some tree blocks get totally
>>> screwed up.
>>>
>>> This is not easy to fix, if possible.
>>>
>>> Would you please try this kernel branch and mount it with
>>> "rescue=3Dskip_bg,ro"?
>>> https://github.com/adam900710/linux/tree/rescue_options
>>>
>>> I think that's the last method. Before that, you could try
>>> btrfs-restore, which is purely user-space and should be easier to set=
up
>>> than custom kernel.
>>>
>>> Thanks,
>>> Qu
>>
>> Tried "btrfs restore -vsxmi ..." (it did not work before my first
>> email), it is processing for at least 6 hours until now. It seems that=

>> despite many error messages files are getting restored. As soon as it
>> finishes will check what is the result and give feedback. Will also
>> test the mentioned kernel branch.
>>
> After almost four days only about 120 GB of my initially 3.7TB of free
> space remain free, and the restore is still working (how about
> introducing a "progress" switch?)... I guess that due to the option "-s=
"
> and the lack of deduplication the snapshots are going to fill all the
> space without reaching the "end" of the file restoring system.
>=20
> Until now I still did not have chance (and time) to compare the restore=
d
> with backups, but at this point I would like to ask you: what else woul=
d
> you like to know|try|do? Should I try the mentioned above kernel and it=
s
> rescue options?

That's the only remaining thing you need.

In fact, I didn't consider the size of the fs, and for that large fs,
rescue mount option should be the first choice before btrfs-restore.

Thanks,
Qu

> Something else, which is risky and should not be tried
> on a production system?
>=20
> Kind regards,
>=20
> Nik.
>=20
> --=20
>=20
> [snip]
>=20


--tRet9c5jKlsw8ZjL8Nz73k2GMmCDws8fu--

--Tzklw4qfTG1r7UaOPTCgmpMvqDWWIOivL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlywbXkACgkQwj2R86El
/qhj/Af7BwJYbBP+iBwvTRKuHNQM2Ga3TVVfgDRVZ5n2Qz+pki6JCF5RGrSN7Ahy
wTmSI4zCRu61Zi1JFYMCHEHWaf8KB4nTlBVU4C2y64L2DZGd87+LLbZedso7RC0A
cInrfQpM5cHx1o8bpKYf9An5Z4JFZW8lyoifW8AYMYtu163UiHxwHYRzxDmSHLC1
fS3gv6ouhMu9c4+i6qVK/I3wLMAxUpd/AXMILddlYKCIq2E7MGaEAwptj//Y/sW0
/YDfiFlMJ5V87/SZs4DMm+sMtA5Cj3/REyuAWYcWIsdqN49HLT6oTMgy93T/cQhc
xhnKtN//Kqb5JlUdFCFCs+//8Sf3qA==
=PqAB
-----END PGP SIGNATURE-----

--Tzklw4qfTG1r7UaOPTCgmpMvqDWWIOivL--
