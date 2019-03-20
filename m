Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C72FC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 00:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F35320835
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 00:55:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="ew/BX1RY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfCTAzI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 20:55:08 -0400
Received: from mout.gmx.net ([212.227.15.19]:59059 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbfCTAzI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 20:55:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553043299;
        bh=Ly9xlgFQcERKf3pGl2jxrZKONP+melVt/jGNjesJvyQ=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=ew/BX1RYFDTO7kHg+D+ePqXtQw31Q4ZoEXGOb14mZGL5rbaSrVTqvq29HetwiVzlW
         IVlVAYBMpVbtjQMVXbZwDcI919fcnqjFDKkgsSC9LhInxxd6iPOJ9WsQKzgrJrfvNl
         3lR+2KPQsGn5I52dG64hgFPs+m1bhS8ylxoO3Mco=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lee2I-1gfMU82X5K-00qQlB; Wed, 20
 Mar 2019 01:54:59 +0100
Subject: Re: [PATCH 2/2] btrfs: Introduce new tree block flag,
 BTRFS_HEADER_FLAG_LOG
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190319060418.29575-1-wqu@suse.com>
 <20190319060418.29575-2-wqu@suse.com> <20190319182308.GP3516@twin.jikos.cz>
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
Message-ID: <8f1add83-36d0-b074-aa21-30b125136800@gmx.com>
Date:   Wed, 20 Mar 2019 08:54:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190319182308.GP3516@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BdpNkd5ynBB2U32yafJrVk5AIL9xRqOFn"
X-Provags-ID: V03:K1:IWge4Hhi17b69Wze782Ex4osfg1YQvSJfr0R2KeMlq34zuHoKF5
 NPZOs7fJ1y6wDCF9+TBOI9dfWHfeUuzBjN6HZThS9fDRaIQ31uWLe1CuaIhMv8zJMLjq6DU
 YvRhdJlxOPLNeQLW576WxgJuXinE/revDirNN1eCGTDimMqYgT4I6SjFv8F245ovri3A1T8
 ruvVEtiZFRzlNdyb6BKjQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:SNO0vrydisM=:oy5PZc4UhuKz/6glD37RAk
 G19mzTm507OY7QDV6PKLMsgWWC7tpuVyX5vbkOlR7FzSPssVbFrQNzUmPWK2Z9/FMWVxKb2GZ
 +iAziANjksSI5IXEBXrF6FlkePcG5eP/rfd5WSI3uTAhPQLKL0kpah3TMoh5M7vvKkn7nH1I5
 0RUzUhBMzkd3d/PEyArCb/gqLZhAA+CiWlDm9VzITgGaPDC7U5++i81Guw4HcDyjODtDhupG2
 TRurBSLHofTQ9xgMspmR4AlWN5l3g4/jBqEVgx4HzaQsMf2DAkRA3m9t73etBPuVYSJqheZL9
 mjtO2ns4imzFLUAPJFAgW/8y8HtBsAVEfeQL5dKPgNIo0WiVPMpxY9SkCS84IyZbG+LVEncmN
 KXR/XJpC7+VhlefdROzvqdWfRsGruPNinY/zQ/W18ExYrJDNWeX3rDA6nEEYK9GR+ri3dmn79
 evSFlM4STXsEaBRIgb8FC6OBxEpWtP/Sb6ahUfz1/qjgJJHSi6m0TocAx7raMo5/DAuTinuTI
 viX5ZUIwwWHVGLoOIi9E0/u0/of7c3keCSXyeFxZfENP9FTJrCDmTPd/RzhoXSPqU6r9eF4bX
 IEvbqsdxjmNQnVwI/dfn5y/gsCV2973OmSC+IRHPCHXdqan/+S2CfITmFIUVLX82pluJyuSAM
 XUQIcqvP7OVxUtrm1oSj8nxNRhFSOnjErtm9+jpHPOE7EBBxQA55KYcBe+p1C8pevfRKjkMH2
 h3nGFY7QnYjgDqwJCPI8LBPqefQbtY1mjaiedcLpJrd16FenT2jFCx5EeFAWy6MM4xc57d5Zg
 8zCwcuPqKViPe+qTx/YIRZJGehtZ+G5f37SU43iQdMsTgPJxkTM0hIZGNagVFpDB1Y9SraBDR
 SHNBl1nXjeYMAP2UEq1nlMP3wfNolhLzbJJvYGdjMx1ljeRUXPUQKg7CbUfzEY
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BdpNkd5ynBB2U32yafJrVk5AIL9xRqOFn
Content-Type: multipart/mixed; boundary="Ax5noO2nUSVVYQYUzjaLkPQGQlmMk71KM";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <8f1add83-36d0-b074-aa21-30b125136800@gmx.com>
Subject: Re: [PATCH 2/2] btrfs: Introduce new tree block flag,
 BTRFS_HEADER_FLAG_LOG
References: <20190319060418.29575-1-wqu@suse.com>
 <20190319060418.29575-2-wqu@suse.com> <20190319182308.GP3516@twin.jikos.cz>
In-Reply-To: <20190319182308.GP3516@twin.jikos.cz>

--Ax5noO2nUSVVYQYUzjaLkPQGQlmMk71KM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/20 =E4=B8=8A=E5=8D=882:23, David Sterba wrote:
> On Tue, Mar 19, 2019 at 02:04:18PM +0800, Qu Wenruo wrote:
>> This new tree block flag is to indicate the tree block belongs to a lo=
g
>> tree.
>>
>> For btrfs on-disk format, there are several different trees could use
>> the same owner number:
>> - ordinary subvolume tree
>> - log tree for ordinary subvolume
>> - reloc tree for ordinary subvolume
>>
>> It's possible to do the backref walk or use the content to determine t=
he
>> real owner of the tree block.
>> But backref walk is too expensive, content detection is not reliable.
>>
>> So adding a new flag to explicitly show the owner of log tree.
>>
>> Thankfully, tree-checker hasn't checked header flags yet, and there is=

>> no real user for this flag yet.
>> So we don't need to introduce any compatibility flag for this
>> modification.
>=20
> I think we can't simply skip the backward compatibility here, this is a=

> change of on-disk format and at least we have to understand what can go=

> wrong when the combinations of new/old kernel/fs are used.

Currently since neither new fs nor old fs cares the unused bit in extent
buffer headers, so it won't cause anything different.

But if newer fs is going to rely on this bit to do tree-checker, then we
should introduce a COMPATIBLE bit.
Without that bit, kernel do no tagging, to be backward compatible.

>=20
>> The introduction of this new flag makes tree block owner easier to
>> distinguish, making life easier for:
>> - tree checker on log tree
>>   Log tree could contain some items impossible for regular trees
>> - performance profiler
>>   Now it's much easier to distinguish log tree.
>=20
> So is this for enhanced correctness or performance helper? I'd tend to
> skip the performance part for now, it's not convincing argument for the=

> on-disk change.
>=20
> And for the correctness I'd like more details, but the idea sounds good=

> in general.

The chaos of eb->owner is, we have 3 root referring to one subvolid:
ordinary root
root->reloc_root
root->log_root

For ordinary root and reloc root, they're the completely the same
content, so tree-checker needs no modification at all.

But for log_root, its content is completely different, it can contain
things like EXTENT_CSUM.

With the ability to know if a tree block is a log tree one, we can
finally implement owner based key type checker.
E.g. if we have an EXTENT_CSUM item in subvol 256 and it's not a log
tree eb, then we know something is definitely wrong.

Thanks,
Qu


--Ax5noO2nUSVVYQYUzjaLkPQGQlmMk71KM--

--BdpNkd5ynBB2U32yafJrVk5AIL9xRqOFn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyRj10ACgkQwj2R86El
/qhUVAf6Ap9+EZMPCsBWy7gVKIGpg8zgA80KYHVkmY6yUqxNo9BJygNnP2Q17rgp
n8d6LbDdmWEQDQpFT10aqMVU0H3/GCQtBlWaEpFnmL/nGdymgfCTFDbyjKWdTPd3
rW+e/iULLmZ8q0n1RRHmeZFxwh9rewKBmIGkWIkgwbbItLua1nSH+8OzlgXgmxmd
gsAO+CDExQaOLCXWkgeOKzKsFIFBS8He8vwOAIHqlK5w3Xf/+rrrqaIp/rUuE0yh
94/9q/MwtizSKAI+cLguGYATzErpiRH3N9gmMNefToYrMNufFuuS9Kk2knDFXOxC
We62UmXBowwhuEobGqeO6GlIvmKnlA==
=R1iW
-----END PGP SIGNATURE-----

--BdpNkd5ynBB2U32yafJrVk5AIL9xRqOFn--
