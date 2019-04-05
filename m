Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4645C4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 13:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6131121850
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 13:18:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="lcnsxFa8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfDENSl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 09:18:41 -0400
Received: from mout.gmx.net ([212.227.15.15]:33763 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbfDENSl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 09:18:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554470313;
        bh=ztKoVMFoOEFELjBNiLR3E65I1rkdvrKy0d1i3fBPKiM=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=lcnsxFa84O65cZLmNfutA9/I2G6y/1eSXAUNVb+zcrdskvywgR+9EL52zmTET8xDw
         nd5qMMzULV7/V00CTrCvVcX5rvIOSNGFheDqMecwh26ly2fTd2XPHA+bJMs2LapIF8
         0Ns25tbbdJMm/3mqHpwsS7V0NKcmbwf7wwTVx9QE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LiDKt-1gY8AO0frv-00nU5d; Fri, 05
 Apr 2019 15:18:32 +0200
Subject: Re: [PATCH v3.1 1/9] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190404064537.4031-1-wqu@suse.com>
 <20190404064537.4031-2-wqu@suse.com> <20190405120950.GW29086@twin.jikos.cz>
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
Message-ID: <c5a74629-3a44-0cde-aa64-9b3b8b8cbce9@gmx.com>
Date:   Fri, 5 Apr 2019 21:18:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190405120950.GW29086@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tl77Z91f3BDzz3NqHvuN5PdNF1Xdtm41F"
X-Provags-ID: V03:K1:XIOHWhJ70h+Sh+rZseJX6WkY9aY5gwePLezadgKSMCFeYA0AWkE
 1OszGJ/4P20d1VQMHcs9IjbnVJB//OnDq65q/NptTYRJnN+giwjqHaFy7fBSt+cgVt5OEjF
 Vv0SK6C3a4K0r/HiSaQgRDo18anlj8hx/WsZAudVFM3LY1wi3IqOHUJ+fmNEGPJ8cYCHqJW
 jmdJoQxik0H1PAganLu3A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:O6+vFAtmcxE=:XnoJJ+/qO4C4Sqfag7SwiM
 J+akJSej0CGHgMDLkZjgp+vcd8f8M1VgVb75ROkj71wUOSPZGJxA6FDB2IxWwCqk6oFWPqq0h
 6/qX9LJ5hvbqTx61wRgptW37EzvgT/UCDw3+5F3yBj6QyYABunnllPSHSwO/+YdMhrVMTAoNr
 SdYXiOh/0GlYfASaAzjMsRWR+GgKwFn5tmW0+Ln2Fs52Fg2Df4Ap5iNzmGWkoYMsYuV020+2e
 I+gZsJ29YNsiLAQjfwbT243T36yStE7Te+UpbQnGdHDUF1ijEw/ocrIVncwQcIHiIwNZ/9JYp
 nSX56Z31ksA6MjDDWr0YssDVycshKHrtCLNl85yNZKGEUtElj97lMpyddq9yweXt20ji5AgLQ
 hIuZRdM7v1GwAmwS0Y+9q/duowHPPljafvpOSg7RqItIY/7I4WF6WtKbC8tgn7fvM2dW3vipE
 DL/Zw3w6Ze5B2GQ8aDy7CHperHrX/8kBukRJfB6a1f/oP8RnXsfJYj6uds+uXLo8MHjx3KNZ9
 A2yz0JDfgcHQagVIRlZ3Cm75H3XNNoZurjeM2g99M9be2Q4rgi5+mFzgzrKx0whWg1KeTmBxa
 EeH/sbJmG32Kw9aCIM3mEgEcnyEjuEvSncs0Pg3/3Hz2OKj/jl8ngcHGxjCKSnSOwonQQI3O7
 LNxv7y1AEj4I3CabKDkI5Wcs6WL2U2nu/sYfEozt6hOV12ycfeY8lil7cKQCA8pB3Wx9/ecjg
 xAovDd6mofe6XCtdWWymFjcBkirHYvIRYoFb+KN62/9f54pHnyn4Se6BDfgLvQ4KRYTUjszuo
 XDff3NHOYxEAmkNI2dxBM0wnj6oZa7qIOAfFPIHdWHkwmj+7LT71CyAi6/vqgcKOlnNFWJ74S
 uJFXHVklTock3RayOQGFjCGBvdtxbtPDrM66vTdudnKV7TmDq2EFoN7GwgrPuu
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tl77Z91f3BDzz3NqHvuN5PdNF1Xdtm41F
Content-Type: multipart/mixed; boundary="564ESkpaTv3VePUZbn99qPgpWpahaLLxz";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <c5a74629-3a44-0cde-aa64-9b3b8b8cbce9@gmx.com>
Subject: Re: [PATCH v3.1 1/9] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
References: <20190404064537.4031-1-wqu@suse.com>
 <20190404064537.4031-2-wqu@suse.com> <20190405120950.GW29086@twin.jikos.cz>
In-Reply-To: <20190405120950.GW29086@twin.jikos.cz>

--564ESkpaTv3VePUZbn99qPgpWpahaLLxz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/5 =E4=B8=8B=E5=8D=888:09, David Sterba wrote:
> On Thu, Apr 04, 2019 at 02:45:29PM +0800, Qu Wenruo wrote:
>> Current delayed ref interface has several problems:
>> - Longer and longer parameter lists
>>   bytenr
>>   num_bytes
>>   parent
>>   ---------- so far so good
>>   ref_root
>>   owner
>>   offset
>>   ---------- I don't feel good now
>>
>> - Different interpretation for the same parameter
>>   Above @owner for data ref is inode number (u64),
>>   while for tree ref, it's level (int).
>>
>>   They are even in different size range.
>>   For level we only need 0~8, while for ino it's
>>   BTRFS_FIRST_FREE_OBJECTID~BTRFS_LAST_FREE_OBJECTID.
>>
>>   And @offset doesn't even makes sense for tree ref.
>>
>>   Such parameter reuse may look clever as an hidden union, but it
>>   destroys code readability.
>>
>> To solve both problems, we introduce a new structure, btrfs_ref to sol=
ve
>> them:
>>
>> - Structure instead of long parameter list
>>   This makes later expansion easier, and better documented.
>>
>> - Use btrfs_ref::type to distinguish data and tree ref
>>
>> - Use proper union to store data/tree ref specific structures.
>>
>> - Use separate functions to fill data/tree ref data, with a common gen=
eric
>>   function to fill common bytenr/num_bytes members.
>>
>> All parameters will find its place in btrfs_ref, and an extra member,
>> @real_root, inspired by ref-verify code, is newly introduced for later=

>> qgroup code, to record which tree is triggered this extent modificatio=
n.
>>
>> This patch doesn't touch any code, but provides the basis for incoming=

>> refactors.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/delayed-ref.h | 116 ++++++++++++++++++++++++++++++++++++++++=
+
>>  1 file changed, 116 insertions(+)
>>
>> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
>> index 70606da440aa..8eb5b3576759 100644
>> --- a/fs/btrfs/delayed-ref.h
>> +++ b/fs/btrfs/delayed-ref.h
>> @@ -176,6 +176,90 @@ struct btrfs_delayed_ref_root {
>>  	u64 qgroup_to_skip;
>>  };
>> =20
>> +enum btrfs_ref_type {
>> +	BTRFS_REF_NOT_SET,
>> +	BTRFS_REF_DATA,
>> +	BTRFS_REF_METADATA,
>> +	BTRFS_REF_LAST,
>> +};
>> +
>> +struct btrfs_data_ref {
>> +	/* For EXTENT_DATA_REF */
>> +
>> +	/* Root who refers to this data extent */
>> +	u64 ref_root;
>> +
>> +	/* Inode who refers to this data extent */
>> +	u64 ino;
>> +
>> +	/*
>> +	 * file_offset - extent_offset
>> +	 *
>> +	 * file_offset is the key.offset of the EXTENT_DATA key.
>> +	 * extent_offset is btrfs_file_extent_offset() of the EXTENT_DATA da=
ta.
>> +	 */
>> +	u64 offset;
>> +};
>> +
>> +struct btrfs_tree_ref {
>> +	/*
>> +	 * Level of this tree block
>> +	 *
>> +	 * Shared for skinny (TREE_BLOCK_REF) and normal tree ref.
>> +	 */
>> +	int level;
>> +
>> +	/*
>> +	 * Root who refers to this tree block.
>> +	 *
>> +	 * For TREE_BLOCK_REF (skinny metadata, either inline or keyed)
>> +	 */
>> +	u64 root;
>> +
>> +	/* For non-skinny metadata, no special member needed */
>> +};
>> +
>> +struct btrfs_ref {
>=20
> The structure name sounds a bit generic, but I think we can keep it
> short. There are no other btrfs-specific references that could be
> confused, there are 'backrefs', 'delayed-refs' all refering to the
> b-tree references.
>=20
>> +	enum btrfs_ref_type type;
>> +	int action;
>> +
>> +	/*
>> +	 * Only use parent pointers as backref (SHARED_BLOCK_REF or
>> +	 * SHARED_DATA_REF) for this extent and its children.
>> +	 * Set for reloc trees.
>> +	 */
>> +	bool only_backreferences:1;
>=20
> No bool bitfields please, wasn't this mentioned last time?
>=20
Oh, I forgot that one.

Do I need to resend or just edit that commit in my github branch?

Thanks,
Qu


--564ESkpaTv3VePUZbn99qPgpWpahaLLxz--

--tl77Z91f3BDzz3NqHvuN5PdNF1Xdtm41F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlynVaAACgkQwj2R86El
/qhI5wf/bN2aDpJmTb2Q0UOyjn/X/EAdIzwkgwh2yRQuVLgbOPu0+WNwlZ5b+2gt
FOLrPGO0IzYCRFllB/ynqiHGvneNPesrYtYoMeIm4Lckd4EiigRlSv7Gm7WX+j/o
D6gSb0+ms/M2gBgfzWNKHFaamWlqpOxQObH1OHxbC0jzWZd4n1h4UCtmdFT0vjt6
ErCAxV253K9EhTSduZpLgF7Qsw8UuVVf8NB2naAuoa04qK8UczLZ/zD+JTro2mY9
jFsdlxvaARRRxTJdcSpMXYnfGRu2jSzW3F5yLgz5HkGyeS7P46pCo8YkfmATAIec
/YB8B0zrVdTzNdYuxSiJFoG0FHnUsQ==
=ZrAp
-----END PGP SIGNATURE-----

--tl77Z91f3BDzz3NqHvuN5PdNF1Xdtm41F--
