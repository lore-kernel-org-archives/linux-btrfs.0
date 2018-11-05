Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5EA7C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 14:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B57020685
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 14:43:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B57020685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729449AbeKFADF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 19:03:05 -0500
Received: from mout.gmx.net ([212.227.17.22]:52159 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbeKFADF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 19:03:05 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M9KR0-1gElSv1iIg-00CgLA; Mon, 05
 Nov 2018 15:42:44 +0100
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M9KR0-1gElSv1iIg-00CgLA; Mon, 05
 Nov 2018 15:42:44 +0100
Subject: Re: [PATCH] btrfs: tree-checker: Fix misleading group system
 information
To:     Zhangshaokun <zhangshaokun@hisilicon.com>,
        linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
References: <1541414949-16300-1-git-send-email-zhangshaokun@hisilicon.com>
 <425b8a43-ec24-82f7-0627-82edc81e329d@gmx.com>
 <044651c8-b5b7-2ec2-bf22-bdd967e24eb6@hisilicon.com>
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
Message-ID: <5477c8b2-8b0f-58ff-d4c6-ea95521049f4@gmx.com>
Date:   Mon, 5 Nov 2018 22:42:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <044651c8-b5b7-2ec2-bf22-bdd967e24eb6@hisilicon.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SIbkklz47qg7CWlUx2mPMgoSbe2QDh2f8"
X-Provags-ID: V03:K1:0KAyKdpjw7mEI4ijdgxdSzieRQEmz71Jshb8ujJzQtgrZPrBI4B
 7UbBgFpviQQ9kznRsaDhwt7RYfV3gyq8BWvOJV0F5YvFryOnthmzT+G2MofbcIoYb1gCzEd
 G9fBDiPAhyr4A61VVgtruzSY9bEPr6qapwd/cwyLOyGm1O4mWjoo9TU45y+zsc8lUrWtJOP
 vZV3ra4aCm3xJv1edNbzg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:8SAeERrvgB4=:m630OMBXPIvFQ29zBKTjjT
 QSDXfOMWFMKUZ31a80oo3+04lMZHLABTYlSoIzEg4EFYHzLfiejSF19+pJf1tn76fY3VZBkuf
 PzN9XzNE75BWKdOa7feQJ2BfTAodYcICY3BjrV3jqWZBTZd1v4bFqPgn/IBUtBpTD5MW5ZlL0
 vgZKQNiGNQlydpDyufHR5B7GP2LtRwjZShfMaK5JxmIqxul19KykDvDR7d0aTO7JD5FitwrzP
 3r+BcSMLvnIK/fHNMUAdDJxCPzqhV7WR2COSfZeghuzWzzQbT2i0sLOCZFT1CXvj9SYhjImqP
 tHIoZe8937iaPpb7MdKgZaJyFFi8tp37JUNYA10xFPufnlnD4ry0FVGweAYSjQco65gI7FFDp
 mcQKg5jG2pdGQb8/hS3jEJZzvX4w98N37Gaqxnc97qVuAhUVV/Cx/TrXd8TNoLOz1OwRYCEEH
 9DXSpiuIPXsYwWfAWPWbNQFVcrbG9TLXOYozXx5AaD9ZLwrBctBkJAsLTcIXSpp2NTD/zFevn
 cb0X2ijSPJxm9gkVoNLFgK9KUq5Xdvlu9GWedZ7oHTkaoPr+6UkCL2WxlPvg5cKbi+ArXIIJd
 DhhDrYTMuDndzn/TxuTmRwQc0e1yO1Rf4X9k3ly7qYrONFD6bBPXZrG+LrrhWgFl+7J0Cpzd8
 U7oF/OXiFTIwdiv+c1WQg9MY7cT1ifed6+M++zCI5udxnUPDw3VAEV6IvBPe4iLFVATHklxyg
 4Jr7U3aN8Dsoe5EabdVM/ThODOt/LW5J372J9sCXAtDQRnTSu4p2i5hZbvcyBlJGmFhPeXyPZ
 B1swsEWCvi8zU0r1bGDGB9dsw6VfQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SIbkklz47qg7CWlUx2mPMgoSbe2QDh2f8
Content-Type: multipart/mixed; boundary="nKRssJmWAzmVZ9prYYqFy3Hq6qOgzpnSv";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Zhangshaokun <zhangshaokun@hisilicon.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>
Message-ID: <5477c8b2-8b0f-58ff-d4c6-ea95521049f4@gmx.com>
Subject: Re: [PATCH] btrfs: tree-checker: Fix misleading group system
 information
References: <1541414949-16300-1-git-send-email-zhangshaokun@hisilicon.com>
 <425b8a43-ec24-82f7-0627-82edc81e329d@gmx.com>
 <044651c8-b5b7-2ec2-bf22-bdd967e24eb6@hisilicon.com>
In-Reply-To: <044651c8-b5b7-2ec2-bf22-bdd967e24eb6@hisilicon.com>

--nKRssJmWAzmVZ9prYYqFy3Hq6qOgzpnSv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/5 =E4=B8=8B=E5=8D=887:33, Zhangshaokun wrote:
> Hi Qu,
>=20
> On 2018/11/5 19:03, Qu Wenruo wrote:
>>
>>
>> On 2018/11/5 =E4=B8=8B=E5=8D=886:49, Shaokun Zhang wrote:
>>> block_group_err shows the group system as a decimal value with a '0x'=

>>> prefix, which is somewhat misleading.
>>>
>>> Fix it to print hexadecimal, as was intended.
>>>
>>> Cc: David Sterba <dsterba@suse.com>=20
>>> Cc: Chris Mason <clm@fb.com>
>>> Cc: Josef Bacik <josef@toxicpanda.com>=20
>>> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
>>
>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>>
>> BTW, did you catch it with some real world case or just by looking int=
o
>> the code?
>=20
> I made a mistake (0x%d) when debugged my code, so I grep the similar fo=
rmat
> for the kernel code and came across this typo, a trivial patch.

Ok, that's fine.

Just a small tip for your further involvement in kernel, for such small
fix, there is really no need to bother all the maintainers.

You could just use "git blame" to find who is causing the problem, in
this case it's me unfortunately :( , and Cc that guy.

Furthermore, you could add a "fixes:" tag.
About these common tags, you could refer to 'Describe your changes'
section of 'Documentation/process/submitting-patches.rst'.

Thanks,
Qu

>=20
> Thanks,
> Shaokun
>=20
>>
>> Thanks,
>> Qu
>>
>>> ---
>>>  fs/btrfs/tree-checker.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>>> index cab0b1f..efcf89a 100644
>>> --- a/fs/btrfs/tree-checker.c
>>> +++ b/fs/btrfs/tree-checker.c
>>> @@ -440,7 +440,7 @@ static int check_block_group_item(struct btrfs_fs=
_info *fs_info,
>>>  	    type !=3D (BTRFS_BLOCK_GROUP_METADATA |
>>>  			   BTRFS_BLOCK_GROUP_DATA)) {
>>>  		block_group_err(fs_info, leaf, slot,
>>> -"invalid type, have 0x%llx (%lu bits set) expect either 0x%llx, 0x%l=
lx, 0x%llu or 0x%llx",
>>> +"invalid type, have 0x%llx (%lu bits set) expect either 0x%llx, 0x%l=
lx, 0x%llx or 0x%llx",
>>>  			type, hweight64(type),
>>>  			BTRFS_BLOCK_GROUP_DATA, BTRFS_BLOCK_GROUP_METADATA,
>>>  			BTRFS_BLOCK_GROUP_SYSTEM,
>>>
>>
>=20


--nKRssJmWAzmVZ9prYYqFy3Hq6qOgzpnSv--

--SIbkklz47qg7CWlUx2mPMgoSbe2QDh2f8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvgVt0ACgkQwj2R86El
/qgOQAf+JMNT3Ot5edqEXquw+FfAzwPHJ4Pc5VbBr/oJBWFeKH9ugY69rUhpHwwP
g3uOLtDbZOuaFzV0AQIPsKgT+qO30Pl91FmC8aiRrdHsKYtmhXb7adVOyj8mR8No
TbUAaxc1+3pW+eQ0YWuudS7mxc3i/o5d6RJTIPjLa+GZebogyrTTthw08kL7p6yt
597S6qNnx7x9gb5btRczXhrO9lchi9o5Zli8KgWR2Y8OcN3Kjm9Cf1YV6VMupPnS
murWYFd3M8i/TfJ1cuTpIXDLwM2ii2bfjWqPG0mjg3sI6GvwtAXE7qiT/Glsxptw
FLKFJq2WtAHafMIbmdYCak3KOtR+5g==
=rYjB
-----END PGP SIGNATURE-----

--SIbkklz47qg7CWlUx2mPMgoSbe2QDh2f8--
