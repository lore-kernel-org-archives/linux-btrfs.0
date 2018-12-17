Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B065C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 13:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4E5820874
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 13:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732806AbeLQN24 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 08:28:56 -0500
Received: from mout.gmx.net ([212.227.15.19]:35259 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732289AbeLQN24 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 08:28:56 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MaqeA-1gsDK21fNS-00KTUw; Mon, 17
 Dec 2018 14:28:53 +0100
Subject: Re: name hash mismatch
To:     =?UTF-8?B?0J7Qu9C10LMg0JLQu9Cw0YHQvtCy?= <allsys01@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CAKKX_zOEE=N5FrTyfg6JzJ7FfrBix0dnoKK2tYvmTD2kwvEXrg@mail.gmail.com>
 <7793059d-fca6-9465-6276-de7b764c7f89@suse.com>
 <c7b5775c-9f3d-8793-1c05-66abc486d05e@gmx.com>
 <CAKKX_zMt8=zJjdK6p0bD_bVCiYsiuCbv-yRvPy9yCbrrZbwnSA@mail.gmail.com>
 <a1ca88f9-499e-0dfa-a49f-759ab37c391b@gmx.com>
 <CAKKX_zPGBpzhq=j9wT3QXed3LWbfOn5yxctrJHRK8vhYh2MKgw@mail.gmail.com>
 <15b41149-3ebc-8432-7f4b-cfe0a7520fec@gmx.com>
 <CAKKX_zNnxDsacKPg+c1wm3CkTYLMNept5v=xdXWOkWHPV7uTvw@mail.gmail.com>
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
Message-ID: <5c1926bd-3207-f254-87f7-bfc1f46f9f95@gmx.com>
Date:   Mon, 17 Dec 2018 21:28:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <CAKKX_zNnxDsacKPg+c1wm3CkTYLMNept5v=xdXWOkWHPV7uTvw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Fh6NJlNotNTa6PmAAczR1VzjWZzdIRzGf"
X-Provags-ID: V03:K1:ORI+6KOrGm39/d2FgFJh3gJs667vJTe5+DhxohL6ftjm2jIWMdS
 qm66AfsPCEfwSm9eOuaI5HcQY8KI4qCPmZVy+MsfpYBbpBXMCo+zKcDzLJe5NWx8tQHrx8h
 7cpJwQZR06N5H15S/nFsvU0hH+9SMDHogPhD9DaMG2IlhRl6Q44xZMU/nusdgPBP4KyJnhE
 els5EgoZwztU5g/BOUM7w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:nRfJIVQJGC8=:kOaqYlzZ7v7+Tku1G496Dk
 BdsGf1idjFtmt7OrJFCa9+0CPbWnN5JQzpG3V1m6vYY8UsQmEVnG1vIBxLQnILfPGpQ3cNcjl
 EopmQ8Rrs8Bmjey+DHIzobHM+abBUaj/W0iV+Q6GZbKWBgpR5pnZ+PYGNEyHtz7vlJZXcQrZq
 pWQgrH0RGs6SYpgUaSDO3b+xeekPvY45zvCXO1uahiXfaumQcjBl9X/zBlz9ASvw4uCLYufJ6
 jiuQE1UFS7G+eCQYfbpLsKLom0Ur5spBrU4pussvDYRa35zNbD59AQk0MljEoYuDZMhWJjFm7
 SvJxOKJrQFohJhZYHhon06+nHCZbTA9TDPMKTsQaUNpZqNfeMFVxRo2WXTY7h+UqYgz+6Ajw+
 +huMOFZ+uVr7Nyxy7m4UX4xpuMZ0hxZ40Ak9XKTR64YYc1EGWBFxWIKWlqOKStDXx3pTD4bxf
 JEHHVsJef++36VV/IU3VYAHLxTY6Ok9jJcIAjrSyVI8FaBDaqy5zCM8s121Ar7IVGYrjeeh3C
 ESWy9F0/0enCXe2M9xbfbdHcnCyTO5jaTJLgONwt+1M8OWj8/R840chv1Lzp92ygAGgS47u8t
 fgeP5YWqTGp3ho9SIBfocEmUYvE2eKtNJuKOq0iecLilA6zJuKeAnulax1TmBQLww9J/mOFub
 9ajR7RvnZnVpQckJTlhDJQaXoPdGgSzVp9qAJSGR9fQmjXNpgG8Pp/YX3/3pfYVd0i7AWFzFm
 cGEZbkbvnFoR+ksqcP0SGt9lI3N908+rZPBsUXR/lxcTHe4s0hPo7fjcn/9/3mT4rpFc1dTzy
 6ee+awhlHTKqFKb49+bLt8rw4kTb3Vh7iZUHyU7GfY2gk7KlPIJEzIyU02WklOILm5AQF3yCt
 v65SLc3mvJQGPPFrYpw3xpqVQUNbEHga8az57j6BihFx5bOpsq3VBE27HzScpX
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Fh6NJlNotNTa6PmAAczR1VzjWZzdIRzGf
Content-Type: multipart/mixed; boundary="neknrjeEquZlN3J7f3k8ZYCWE9viwMQOQ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?B?0J7Qu9C10LMg0JLQu9Cw0YHQvtCy?= <allsys01@gmail.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <5c1926bd-3207-f254-87f7-bfc1f46f9f95@gmx.com>
Subject: Re: name hash mismatch
References: <CAKKX_zOEE=N5FrTyfg6JzJ7FfrBix0dnoKK2tYvmTD2kwvEXrg@mail.gmail.com>
 <7793059d-fca6-9465-6276-de7b764c7f89@suse.com>
 <c7b5775c-9f3d-8793-1c05-66abc486d05e@gmx.com>
 <CAKKX_zMt8=zJjdK6p0bD_bVCiYsiuCbv-yRvPy9yCbrrZbwnSA@mail.gmail.com>
 <a1ca88f9-499e-0dfa-a49f-759ab37c391b@gmx.com>
 <CAKKX_zPGBpzhq=j9wT3QXed3LWbfOn5yxctrJHRK8vhYh2MKgw@mail.gmail.com>
 <15b41149-3ebc-8432-7f4b-cfe0a7520fec@gmx.com>
 <CAKKX_zNnxDsacKPg+c1wm3CkTYLMNept5v=xdXWOkWHPV7uTvw@mail.gmail.com>
In-Reply-To: <CAKKX_zNnxDsacKPg+c1wm3CkTYLMNept5v=xdXWOkWHPV7uTvw@mail.gmail.com>

--neknrjeEquZlN3J7f3k8ZYCWE9viwMQOQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/17 =E4=B8=8B=E5=8D=888:44, =D0=9E=D0=BB=D0=B5=D0=B3 =D0=92=D0=BB=
=D0=B0=D1=81=D0=BE=D0=B2 wrote:
> [1/7] checking root items
> [2/7] checking extents
> [3/7] checking free space cache
> [4/7] checking fs roots
> ERROR: DIR_ITEM[2531 651003133] name libLLVMAnalysis.so.=D0=85=3D namel=
en 24
> filetype 1 mismatch with its hash, wanted 651003133 have 3033451023
> root 1741 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> ERROR: DIR_ITEM[2531 651003133] name libLLVMAnalysis.so.=D0=85=3D namel=
en 24
> filetype 1 mismatch with its hash, wanted 651003133 have 3033451023
> root 2308 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> root 2309 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> root 2310 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> ERROR: DIR_ITEM[2531 651003133] name libLLVMAnalysis.so.=D0=85=3D namel=
en 24
> filetype 1 mismatch with its hash, wanted 651003133 have 3033451023
> root 2314 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> ERROR: DIR_ITEM[2531 651003133] name libLLVMAnalysis.so.=D0=85=3D namel=
en 24
> filetype 1 mismatch with its hash, wanted 651003133 have 3033451023
> root 2315 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> ERROR: DIR_ITEM[2531 651003133] name libLLVMAnalysis.so.=D0=85=3D namel=
en 24
> filetype 1 mismatch with its hash, wanted 651003133 have 3033451023
> root 2342 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> ERROR: DIR_ITEM[2531 651003133] name libLLVMAnalysis.so.=D0=85=3D namel=
en 24
> filetype 1 mismatch with its hash, wanted 651003133 have 3033451023
> root 2343 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> root 2344 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> ERROR: DIR_ITEM[2531 651003133] name libLLVMAnalysis.so.=D0=85=3D namel=
en 24
> filetype 1 mismatch with its hash, wanted 651003133 have 3033451023
> root 2345 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> root 2350 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> ERROR: DIR_ITEM[2531 651003133] name libLLVMAnalysis.so.=D0=85=3D namel=
en 24
> filetype 1 mismatch with its hash, wanted 651003133 have 3033451023
> root 2351 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> ERROR: DIR_ITEM[2531 651003133] name libLLVMAnalysis.so.=D0=85=3D namel=
en 24
> filetype 1 mismatch with its hash, wanted 651003133 have 3033451023
> root 2400 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> root 2401 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> ERROR: DIR_ITEM[2531 651003133] name libLLVMAnalysis.so.=D0=85=3D namel=
en 24
> filetype 1 mismatch with its hash, wanted 651003133 have 3033451023
> root 2402 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> root 2403 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> root 2404 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> root 2405 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> root 2406 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> root 2407 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> root 2408 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> ERROR: DIR_ITEM[2531 651003133] name libLLVMAnalysis.so.=D0=85=3D namel=
en 24
> filetype 1 mismatch with its hash, wanted 651003133 have 3033451023
> root 2409 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> root 2410 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item
> root 2411 inode 2531 errors 10, odd dir item
> unresolved ref dir 2531 index 0 namelen 24 name libLLVMAnalysis.so.=D0=85=
=3D
> filetype 1 errors 6, no dir index, no inode ref
> unresolved ref dir 2531 index 17409 namelen 24 name
> libLLVMAnalysis.so.3.8.0 filetype 1 errors 1, no dir item

So no extent tree problems, all DIR_ITEMS.

It's OK for you to use the following branch, and execute "btrfs check
--repair" to fix the fs:
https://github.com/adam900710/btrfs-progs/tree/check-next

Please note that, current upstream btrfs-progs won't fix it, only that
branch contains the fixing commits.

Thanks,
Qu
> ERROR: errors found in fs roots
> Opening filesystem to check...
> Checking filesystem on /dev/sda5
> UUID: cbc46449-fb64-4a9a-965b-b58646e9f82a
> found 280200617984 bytes used, error(s) found
> total csum bytes: 267811940
> total tree bytes: 2448752640
> total fs tree bytes: 2011480064
> total extent tree bytes: 118505472
> btree space waste bytes: 428923543
> file data blocks allocated: 1238443962368
>  referenced 323581739008
>=20
>=20
> =D1=81=D1=80, 12 =D0=B4=D0=B5=D0=BA. 2018 =D0=B3. =D0=B2 16:52, Qu Wenr=
uo <quwenruo.btrfs@gmx.com>:
>>
>>
>>
>> On 2018/12/12 =E4=B8=8B=E5=8D=889:51, =D0=9E=D0=BB=D0=B5=D0=B3 =D0=92=D0=
=BB=D0=B0=D1=81=D0=BE=D0=B2 wrote:
>>> Could you guide me ?
>>> What should I do after compile latest btrfs-progs?
>>
>> "btrfs check --readonly <device>" and paste the output.
>>
>> Thanks,
>> Qu
>>
>>>
>>> =D1=81=D1=80, 12 =D0=B4=D0=B5=D0=BA. 2018 =D0=B3., 16:47 Qu Wenruo qu=
wenruo.btrfs@gmx.com
>>> <mailto:quwenruo.btrfs@gmx.com>:
>>>
>>>
>>>
>>>     On 2018/12/12 =E4=B8=8B=E5=8D=889:36, =D0=9E=D0=BB=D0=B5=D0=B3 =D0=
=92=D0=BB=D0=B0=D1=81=D0=BE=D0=B2 wrote:
>>>     > if there any way to remove that item?
>>>
>>>     IIRC kernel can't remove it since the hash doesn't match, kernel =
won't
>>>     be able to delete it.
>>>
>>>     btrfs-progs check-next branch can handle it, but you need to ensu=
re
>>>     there is no other bugs.
>>>
>>>     So, you still need to compile the latest btrfs-progs and then the=

>>>     check-next branch.
>>>
>>>     Thanks,
>>>     Qu
>>>
>>>     > the file that belong to it is useless for me but it preventing =
to
>>>     > mount filsystem in higher kernel versions
>>>     > =D1=81=D1=80, 12 =D0=B4=D0=B5=D0=BA. 2018 =D0=B3. =D0=B2 16:26,=
 Qu Wenruo <quwenruo.btrfs@gmx.com
>>>     <mailto:quwenruo.btrfs@gmx.com>>:
>>>     >>
>>>     >>
>>>     >>
>>>     >> On 2018/12/12 =E4=B8=8B=E5=8D=889:00, Nikolay Borisov wrote:
>>>     >>>
>>>     >>>
>>>     >>> On 12.12.18 =D0=B3. 14:44 =D1=87., =D0=9E=D0=BB=D0=B5=D0=B3 =D0=
=92=D0=BB=D0=B0=D1=81=D0=BE=D0=B2 wrote:
>>>     >>>> Hello
>>>     >>>> If anyone could help with with "name hash mismatch" error at=
 btrfs.
>>>     >>>> full error is
>>>     >>>> "BTRFS critical (device sda5): corrupt leaf: root=3D2234
>>>     >>>> block=3D244700761008 slot 136 ino=3D2531, name hash mismatch=
 with key,
>>>     >>>> have 0x000000000026cd84d"
>>>     >>>> so i could not access one file neither to remove it.
>>>     >>>>
>>>     >>>> uname -a
>>>     >>>> Linux linux-wwqj 4.12.14-lp150.12.16-default #1 SMP Tue Aug =
14
>>>     >>>> 17:51:27 UTC 2018 (28574e6) x86_64 x86_64 x86_64 GNU/Linux
>>>     >>>> btrfs --version
>>>     >>>> btrfs-progs v4.15
>>>     >>>
>>>     >>> First I'd suggest to update to the latest btrfs progs. Then j=
ust run
>>>     >>> btrfs check --readonly --mode lowmem /path/to/device  and pas=
te the
>>>     >>> output. This won't do any changes to your filesystem but will=
 give a
>>>     >>> better idea of what the corruption might be.
>>>     >>
>>>     >> Yep, that's pretty much recommended.
>>>     >>
>>>     >> On the other hand this kernel warning message just means exact=
ly
>>>     what it
>>>     >> says.
>>>     >> One of your DIR_ITEM has incorrect hash.
>>>     >>
>>>     >> IIRC this is an old bug in kernel, not sure when it get fixed =
but it
>>>     >> should definitely get fixed now.
>>>     >>
>>>     >> If btrfs check --readonly shows *NO OTHER* bug, I have the che=
ck-next
>>>     >> branch which could fix it.
>>>     >>
>>>     >> But please keep in mind, don't run btrfs check --repair right =
now.
>>>     >>
>>>     >> Thanks,
>>>     >> Qu
>>>     >>
>>>     >>>
>>>     >>>>
>>>     >>>> tnx in advance
>>>     >>>>
>>>
>>


--neknrjeEquZlN3J7f3k8ZYCWE9viwMQOQ--

--Fh6NJlNotNTa6PmAAczR1VzjWZzdIRzGf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwXpJAACgkQwj2R86El
/qgPIwgAiBVaggK18/ZDtPoqy+ej+1Cay1TgnBMxJstywmRcH48BEXbWd96QumiZ
UBkVbJutJFqHHp7xq1bMFvR3or1rR7QPFaBNqxdQG5z8cU9rxfyBAM5txebxAAHA
fLaWt2dh5gOmVdcM/I8N4e7Mu5zY5YY3ItU1npLMATd+0tas9JdXgoDYAcw8a5JC
cDlxVYuqs5SSDsHGyr+xUWHTFCNcFJwRMSuhBLtRNTsPclcj78XKPyhL+L3dRMfu
rrt0F/U8E+IX5l2P/DJS2qZ1ym4WH5XO/SxXAKwSQdq2Mmu94tq8Yjm7ZUgd+wUR
d5bPvtFLr6QnhP0YdJiHr7mfOXQxoQ==
=P7gx
-----END PGP SIGNATURE-----

--Fh6NJlNotNTa6PmAAczR1VzjWZzdIRzGf--
