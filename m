Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F92C282CE
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 23:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F67820700
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 23:48:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="TR7JURQI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbfDEXsJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 19:48:09 -0400
Received: from mout.gmx.net ([212.227.17.20]:55513 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbfDEXsI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 19:48:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554508079;
        bh=yRnMfPpyt7IhxscaEWdiCaVqzYlLQPvauY5loLTy+DY=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=TR7JURQIQWmy6tdp/qmHaRCYL30Pj/cF0g7/o/ttPcUlkcOeo14XiRmGLSHXhel1Q
         VCTfsfRdYjf0IlG8cUnlNriDoOsKb1/UD8yPityeBJacq1OfVr1m/cck5pyK3+EaeR
         Zpcw8rtI+0XgIrx5dBVKrHXLsICFrthIF4a5+1EY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M2tKM-1gt6ng0f8o-00seDx; Sat, 06
 Apr 2019 01:47:59 +0200
Subject: Re: [PATCH v3.1 1/9] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190404064537.4031-1-wqu@suse.com>
 <20190404064537.4031-2-wqu@suse.com> <20190405120950.GW29086@twin.jikos.cz>
 <c5a74629-3a44-0cde-aa64-9b3b8b8cbce9@gmx.com>
 <20190405155109.GY29086@twin.jikos.cz>
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
Message-ID: <eebc9aa3-c166-8168-2ab5-06d62f4ba788@gmx.com>
Date:   Sat, 6 Apr 2019 07:47:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190405155109.GY29086@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="m0cu8KD4qEO9szc6t3Xw8VnDNZAwQlDHU"
X-Provags-ID: V03:K1:AJUtJxcQ6vgzak/Ob2I+KP9zZc2kKMs+CSYaOPdP+FvN4O4/beC
 PCWTP4215K2B4ohsrMtgNuo9lpsK19Lfr2DdXojhN27P1FFPDu/K+TMDHVmxG3v+aN48A+M
 jTZ5xkAvOBMsvx+H2evKq7WiQv7dM+ajNT4IbB0ags4xcN1ntPG9kCb9eJxBLzU2A01N5G4
 2SqVrbzi5EEAeglYB/Hiw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:X8C/rVEojtw=:NGFn/XcCbvgMEBAtx9pGq9
 XnH/Ejux+svryFlXSqgMZ6wpPBYHqwNIoua2OVNebchWPoqEKWvpk9NLklSzGu9Jm1JR4Idzi
 LQqph5mkxbfDi7eVIvFDxHKYoHCLeM6drQFynGoDH1D73XXwR37RYN6OAqT9A+uGPoSktoSub
 zL0UlCsNqaSrkfkNSj1XVTjzCuCro2L+HjxO1ciEwcxG/9brN+c7hkJXq//YENRoJWeN85F8L
 REU87hSwLfdp94OkRPE69wsYt8plLfRoYgp2ht13PIqvrHcPnNmKK2U+ywhqJzlPeTQnetxU9
 9+vujjb+BWIhvH2cuMQPD8M5hFQSUGmT1N4C+N3a3VrFiKxHvA/g8NqlXvWuvVJw+QbWlhWfC
 84+UBz8+oxJJdcBIf6m2bD9Qkz+K8Br5b6ITJ1w6au8gFQd0EBmrsIJqK+tcZhrK34uhBUF/T
 S/5OvEoYEsmiyGwLub+wUZ4oqH5XWGQYId/NQGnuQ1k+juf9SmF1hMBNfBT2za9Ll/AH7WQHa
 wLjNJ8hoh+p14ClyDuitDZCzcTDho6ooY8dvgLGoUC3OnMZIALKBPEdkU1XZOGDQTycAKt8ps
 506EMtYqez6ZOBGMYmkijBAJf+fZWzLuARjb11+4YsldgCwokwlVmSlhcRgVgL+TTkcyfMzKO
 7CrmGLmKrKODLBgXjbLuX3kdiL378m5O1crmMwhbnKKNIjbRRB3e/T2QJySo/pilZXNBvEuMv
 sjXs3LxS0yaVk/X5yGbcNfnh/dFpMlOYbc4SUfzYeMCcDkGomRNH6lNIWs4gdwfKjJPU/StkU
 zIgLt8HRUU4iLuMmLHv7ptblLiHc/6yKe8fzFP9NZSLr2gnifYjxUKLXqL+o3tH4RXj4gJdyf
 1hzrTPYRZ+G3aX8swmvfBAmf1kx5Es4WanFCrVJHoBwH+8/wWl4726CyA2eN4A
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--m0cu8KD4qEO9szc6t3Xw8VnDNZAwQlDHU
Content-Type: multipart/mixed; boundary="mrqsAaIuUliGO6cxfWYQM4DRjExptcFnR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <eebc9aa3-c166-8168-2ab5-06d62f4ba788@gmx.com>
Subject: Re: [PATCH v3.1 1/9] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
References: <20190404064537.4031-1-wqu@suse.com>
 <20190404064537.4031-2-wqu@suse.com> <20190405120950.GW29086@twin.jikos.cz>
 <c5a74629-3a44-0cde-aa64-9b3b8b8cbce9@gmx.com>
 <20190405155109.GY29086@twin.jikos.cz>
In-Reply-To: <20190405155109.GY29086@twin.jikos.cz>

--mrqsAaIuUliGO6cxfWYQM4DRjExptcFnR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


>>>> +	/* For non-skinny metadata, no special member needed */
>>>> +};
>>>> +
>>>> +struct btrfs_ref {
>>>
>>> The structure name sounds a bit generic, but I think we can keep it
>>> short. There are no other btrfs-specific references that could be
>>> confused, there are 'backrefs', 'delayed-refs' all refering to the
>>> b-tree references.
>>>
>>>> +	enum btrfs_ref_type type;
>>>> +	int action;
>>>> +
>>>> +	/*
>>>> +	 * Only use parent pointers as backref (SHARED_BLOCK_REF or
>>>> +	 * SHARED_DATA_REF) for this extent and its children.
>>>> +	 * Set for reloc trees.
>>>> +	 */
>>>> +	bool only_backreferences:1;
>>>
>>> No bool bitfields please, wasn't this mentioned last time?
>>>
>> Oh, I forgot that one.
>>
>> Do I need to resend or just edit that commit in my github branch?
>=20
> No need to resend, I'll edit that as it's a trivial change. I'll have
> another look at the whole structure if the layout could be optimized,
> eg. the enum takes 4 bytes but we'd be fine with a byte.
>=20
Maybe I have already said this before, but I still really hope either we
have some external tool to do that for us, or some attribute to do it.

Thanks,
Qu


--mrqsAaIuUliGO6cxfWYQM4DRjExptcFnR--

--m0cu8KD4qEO9szc6t3Xw8VnDNZAwQlDHU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyn6ScACgkQwj2R86El
/qjJdAf+IHcdOwUCYLnUCSr24Cb4FPYtmA3e3lDvX8jaxlkXtArsHfTrc25Y0w31
j49kIDPZdUJ5DlZBxKYbLBWWhLQppqrNUR0cIJmfYUgwxTFbI4o745uy2ja9M0n/
42vUlSqfLSFXj+6EoorWhXo/cIlyUxAp/z3psMs7OrdgBNAy2QTyTzIwo2uBZT5z
QAYn5HlWfaq0cuBeYiiyuHFLTHC1+jdTryVFFX6vJl5OVqT7PRSSvo5g438tmpSw
nb9E7+QrWgrC9PRzKUPmLeRMaPQ92ED2YQ8xChf0jWiyNiXC9RbDObnckwWbN28H
1Bqb/3segkrjBS0wKVt49a/Vg0c4LQ==
=x+Zz
-----END PGP SIGNATURE-----

--m0cu8KD4qEO9szc6t3Xw8VnDNZAwQlDHU--
