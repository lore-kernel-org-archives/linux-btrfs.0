Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD098C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 12:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 681632087F
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 12:25:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 681632087F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbeLDMZA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 07:25:00 -0500
Received: from mout.gmx.net ([212.227.17.21]:58773 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbeLDMZA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 07:25:00 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MNf1y-1gaCAE0vTm-007At9; Tue, 04
 Dec 2018 13:24:49 +0100
Subject: Re: [PATCH v1.1 9/9] btrfs-progs: Cleanup warning reported by
 -Wmissing-prototypes
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181116075426.4142-10-wqu@suse.com>
 <20181116080451.6306-1-wqu@suse.com> <20181204122207.GM17773@twin.jikos.cz>
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
Message-ID: <b319920a-b315-f07f-5410-c0798632d2db@gmx.com>
Date:   Tue, 4 Dec 2018 20:24:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181204122207.GM17773@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="64Jo7GeH5rSdfty0IlLsSyAN3ncIGJ915"
X-Provags-ID: V03:K1:Org32Q+7tLfGf87AiU4h3PR1SDVphHha2sgMwIUYuW9YDJNhw6P
 rLKyG8nirpjG19CQSaMsjh3KKwhAkKvE735FaoyMFdBBkViCJjmx65eIwPN5XaLFpZ05JVw
 Hr220JlTjKfwKTrS3Y2JywMinGsiVu8cveJyvdMcPNm+xZP0fuqAQwr0CdrO20TUBS6b9OO
 RupMZvS236ZaYCIM73oJQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:uHeyOm9/G18=:WvR/TP5QJDR0xQy9anS1n2
 wrpD3SEw7k9ozHLLHcEFTAJWhNfFBSXcMxLONijO+meWOItnEI5bsg/IQIxNiFC73kxHuIPiI
 O3JSHxPboW+kXur8SelL2s9Nfygn/dSSzcEFO5te+pxJG3JDYcp74NItB8Qg8GW8JC48ZEERP
 anHUPBv4P4hqYDq96pOOF3U6qr+DpAv+K4SqD526MzfTlFEvUSV/iXYlTCB0wUMzVFNpW3s3l
 JwRoIppLVmRaJKjVa2ihV2QIrke/6/+UwOWYC4ZfMDl05/DMeerYLk7xqQNldDXo4fNB5kEmw
 dePfau5HjyCc0/s4dj8sjnrXMDs6+RfVtarER5XXiseVauFRP763zf6UnK23ljPypy0kRXTLL
 0JnGlj8BLyLgLR0ENqgVh0dJBr+pEZ0ePjIXDjooH7xx9yyxiEhZyPb3uqCvPFBsJ5jJz1jci
 Pun1qudwSLEu5F9RibakejJWYeLFBsjYOYissIQJ7MstHbp1dyXo/OqM8kxnilNLpNr0Gg2LP
 OEd8ij0uDRya+IAwAavyXNLHw5Ry/oJA+YutyAiiugOK1CMQHel3Mck/+DFKCzt84AfUJU88+
 xheqGyyo2sMPkogQv5pUQ4LhURn8Igq0JzhVVCiaBzNhez6n3tAabVxdeWgvZZywNZsdqsblt
 QhK8trdUCPmPY6VOg7g7DWwtxSFdvIRKDfI+X/TkZd4V1ffG/4CmI77mxD7aOCS8FlSu+KPhl
 SEQVofR1PR3LfPZpJIQGpUKmIddzsMGGGroPlEyUYw8xN6YW6buL7QX9jJAj/Su4YE/j6Z7sJ
 lvmczKF6y16vLdx4M6mspy4brRJ5/woPLV1lJ9aleYtLM5apRUuBwIcprrS+X1cPxFfIGfd7j
 yRoCCd9OvDy1Ze182WLlaYa6dBCLvjmDrJkOw466H2brMOFIDIpvQ3SvgfuTyH
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--64Jo7GeH5rSdfty0IlLsSyAN3ncIGJ915
Content-Type: multipart/mixed; boundary="GAIQji4Y8E3nDZywgvpjoVxTa9HI4qiLP";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <b319920a-b315-f07f-5410-c0798632d2db@gmx.com>
Subject: Re: [PATCH v1.1 9/9] btrfs-progs: Cleanup warning reported by
 -Wmissing-prototypes
References: <20181116075426.4142-10-wqu@suse.com>
 <20181116080451.6306-1-wqu@suse.com> <20181204122207.GM17773@twin.jikos.cz>
In-Reply-To: <20181204122207.GM17773@twin.jikos.cz>

--GAIQji4Y8E3nDZywgvpjoVxTa9HI4qiLP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/4 =E4=B8=8B=E5=8D=888:22, David Sterba wrote:
> On Fri, Nov 16, 2018 at 04:04:51PM +0800, Qu Wenruo wrote:
>> The following missing prototypes will be fixed:
>> 1)  btrfs.c::handle_special_globals()
>> 2)  check/mode-lowmem.c::repair_ternary_lowmem()
>> 3)  extent-tree.c::btrfs_search_overlap_extent()
>>     Above 3 can be fixed by making them static
>>
>> 4)  utils.c::btrfs_check_nodesize()
>>     Fixed by moving it to fsfeatures.c
>>
>> 5)  chunk-recover.c::btrfs_recover_chunk_tree()
>> 6)  super-recover.c::btrfs_recover_superblocks()
>>     Fixed by moving the declaration from cmds-rescue.c to rescue.h
>>
>> 7)  utils-lib.c::arg_strtou64()
>> 8)  utils-lib.c::lookup_path_rootid()
>>     Fixed by include "utils.h"
>>
>> 9)  free-space-tree.c::set_free_space_tree_thresholds()
>>     Fixed by deleting it, as there is no user.
>>
>> 10) free-space-tree.c::convert_free_space_to_bitmaps()
>> 11) free-space-tree.c::convert_free_space_to_extents()
>> 12) free-space-tree.c::__remove_from_free_space_tree()
>> 13) free-space-tree.c::__add_to_free_space_tree()
>> 14) free-space-tree.c::btrfs_create_tree()
>>     Fixed by making them static.
>=20
> Please split this to more patches grouped by the type of change.

No problem, just as the numbering is already grouped.

Thanks,
Qu
>=20
>> --- /dev/null
>> +++ b/rescue.h
>> @@ -0,0 +1,14 @@
>> +/*
>> + * Copyright (C) 2018 SUSE.  All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public
>> + * License v2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>=20
> Missing ifdef to prevent multiple inclusion
>=20
>> +int btrfs_recover_superblocks(const char *path, int verbose, int yes)=
;
>> +int btrfs_recover_chunk_tree(const char *path, int verbose, int yes);=



--GAIQji4Y8E3nDZywgvpjoVxTa9HI4qiLP--

--64Jo7GeH5rSdfty0IlLsSyAN3ncIGJ915
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwGcgYACgkQwj2R86El
/qhdQggAjuY7FiktDQAhVpD3RB7U+yvZiB+TdPonB/ABmzoV07NjQA61we+z2z8m
+S6hJ/QlLb8UGt/KQT8thq5UKsVAOs8Ufg95ZUsjfDIwlTO3E2ENMnQDXQ3Cuj4L
RhEANiCVr925DdpRku+aHmzQ5g+X6ApSrf/vSdCvXIQFx1bUU0iVC/zy92GIwwhG
lyI8D95mFcx1Cnnv9gYCKLz8fbiCdeeHYNeuCkmrp4kEejIUJfpPB4qAduD5Wh1Z
Dikm2WjBrQXJyywLTVqzs/6Q1wrVsMe6idB9J9rf0pnD6PbjpAt40ncY5H7pL50X
i9udvR/0Y/fRX2Ktr2/WNlXV9tvSIA==
=a6IJ
-----END PGP SIGNATURE-----

--64Jo7GeH5rSdfty0IlLsSyAN3ncIGJ915--
