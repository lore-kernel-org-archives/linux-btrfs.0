Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6D1C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2459D2082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:25:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2459D2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbeK1MZN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 07:25:13 -0500
Received: from mout.gmx.net ([212.227.15.18]:58183 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbeK1MZN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 07:25:13 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MOwbP-1gMbOr0kch-006Kmp; Wed, 28
 Nov 2018 02:25:21 +0100
Subject: Re: [PATCH 6/9] btrfs: switch EXTENT_FLAG_* to enums
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1543348078.git.dsterba@suse.com>
 <782a5658022cf91415f8ef168d57616ebab276f0.1543348078.git.dsterba@suse.com>
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
Message-ID: <aa8ab1aa-c909-374c-8e94-1fa00427e818@gmx.com>
Date:   Wed, 28 Nov 2018 09:25:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <782a5658022cf91415f8ef168d57616ebab276f0.1543348078.git.dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TZwgJe6kwkXFAOxGN4N0zcW8a9IO8gTOy"
X-Provags-ID: V03:K1:/8c4Vd+hw8pN/UXP96zIVun1HZrSUnb8XEUQdcGQpZvy/djWclP
 6BF4852upB3D2ivbF8EsCSHKK4OUPvUf4UTVZ9TXVraQ1T5cDFb49ErXAYuz4hvenWWPr9H
 JEPoS+foRjWwAYE0A5CDLH41sFdh/D9MVOv/gzvp4p2IlRqI1JvgwhSsItGlX7DNmL7G+e6
 4b/Q179E23WnlI6t3pevA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:N5oCa8zEIVk=:OLwfI2/8ls6IOUUWLTpNiW
 fcX4Wb7yYaea+iLhXSXZgdS1FbxqiwV39AQcwfNyr90M1oJ22AEvunQaufwo5jQEHX+CYNDJC
 woNna4XTy2mV19V3Dxr1MZG0CDXgx7lOkdxCf7aMKYIXfgpmq2sUzoDMit55q0SEmgGJjcZwa
 ILGalm+3BsKAELP8bTDGrG4BqBC9Roujmy34gsuTei+HfHjDPYS5yQqJZpFffKVgdizmvBpCS
 ao0zVBvmn4QzVmR4siaa2UZKknWVrHHzY+iF6IFfpu7wmfPCIhZ68Y73PhDmyMgTIlmhHKbH7
 EDxWdOwx8NG6YSwrmTFbj4JaZUwyKjKVryHIPw7rhJRXlp0lgWSAyW4j/nUHTBIfhuInSy8uy
 y8jCX0RU7nAePrvGXdQS3ayhwA8NOOU1uKlGCbgHHbFLcdH7Bb4/KDRDYhGIdloJ5phK1/3v9
 v467aBYlqDHmmizlYOLChZeJObD732xtAFFQVzFdgvU2eDkZAf0DLikwEEjwRP7bcd78nfsDU
 Pg30IuNpwtUzqInLZbzyMs3HJml8trLkpCdCJ7+7OfLmttXl7DTYIWtLHh8yxI2MhchWT6G+e
 YVJnKHxKmAgb/i4yygAwleaNJirGNs3s7mkgzArDX1wqlT5Wq4tPuq/ljiGRhzt9yYToINdQ7
 pSC4/2uplQisETgAwuKafR+YrwVvcQ/+TOX5g5aAvGihZPq3sAPImaEK4e3Ph1VhC4ANZz+YN
 yvYH/pU72T2NVLV/nAVCCc67NvTbGwR6gs8BQFM1rrv0NBHCbyqRIVigkhgfZMytTLI7xzQAT
 hsyb+GHaJdab+BJs3i9VTCetSALlVN6QfQ8+0mekYFWmhWrYlkTJPfOZ8evWDL2A0TnZGOTVM
 MyJRpJF6aue9W6oUUSL1kZUZ8y1NYmzqlzosFAwT83nvvgM3fDaapa28uLNZ5c
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TZwgJe6kwkXFAOxGN4N0zcW8a9IO8gTOy
Content-Type: multipart/mixed; boundary="ILd9elqUmaqPzDQA7uLyni6NWX0xxHK2E";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <aa8ab1aa-c909-374c-8e94-1fa00427e818@gmx.com>
Subject: Re: [PATCH 6/9] btrfs: switch EXTENT_FLAG_* to enums
References: <cover.1543348078.git.dsterba@suse.com>
 <782a5658022cf91415f8ef168d57616ebab276f0.1543348078.git.dsterba@suse.com>
In-Reply-To: <782a5658022cf91415f8ef168d57616ebab276f0.1543348078.git.dsterba@suse.com>

--ILd9elqUmaqPzDQA7uLyni6NWX0xxHK2E
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/28 =E4=B8=8A=E5=8D=883:53, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> extent map flags.
>=20
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/extent_map.h | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
> index 31977ffd6190..ef05a0121652 100644
> --- a/fs/btrfs/extent_map.h
> +++ b/fs/btrfs/extent_map.h
> @@ -11,13 +11,20 @@
>  #define EXTENT_MAP_INLINE ((u64)-2)
>  #define EXTENT_MAP_DELALLOC ((u64)-1)
> =20
> -/* bits for the flags field */
> -#define EXTENT_FLAG_PINNED 0 /* this entry not yet on disk, don't free=
 it */
> -#define EXTENT_FLAG_COMPRESSED 1
> -#define EXTENT_FLAG_PREALLOC 3 /* pre-allocated extent */
> -#define EXTENT_FLAG_LOGGING 4 /* Logging this extent */
> -#define EXTENT_FLAG_FILLING 5 /* Filling in a preallocated extent */
> -#define EXTENT_FLAG_FS_MAPPING 6 /* filesystem extent mapping type */
> +/* bits for the extent_map::flags field */
> +enum {
> +	/* this entry not yet on disk, don't free it */
> +	EXTENT_FLAG_PINNED,
> +	EXTENT_FLAG_COMPRESSED,
> +	/* pre-allocated extent */
> +	EXTENT_FLAG_PREALLOC,
> +	/* Logging this extent */
> +	EXTENT_FLAG_LOGGING,
> +	/* Filling in a preallocated extent */
> +	EXTENT_FLAG_FILLING,
> +	/* filesystem extent mapping type */
> +	EXTENT_FLAG_FS_MAPPING,
> +};
> =20
>  struct extent_map {
>  	struct rb_node rb_node;
>=20


--ILd9elqUmaqPzDQA7uLyni6NWX0xxHK2E--

--TZwgJe6kwkXFAOxGN4N0zcW8a9IO8gTOy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv97nkACgkQwj2R86El
/qjlJQf+MmffrUsapnSuScRBrutfC5pYZWtRR9Z8l+VhBbFXQHpLns9kl9Xps14z
RJMz0V8/abLFOGuKEGdSNaZN30RfSBUHWnv7ncZqASaPEvH6ywo5yy+x3U2lWuLr
J0ljegbvaGxHVDQgU++/meE5vgq6cBZjbkYKrXjo3NIKCjsD77qPWldlTLuzFQTE
UkL7ytX3DMbLgmBK+BU1lx8SmMdbpuURkKNXkZtyyAWNacOAI60hhcTx6vFyHQYI
gigBD/MCV2KY7HWJdeX0p7d2JkwgS7h9eHNqzCZ/LfYO1aYfZ88lQ6qSDb4TGN/E
pvzo8RrE8RS/EYiylm4VkApNK/Il3A==
=VaNe
-----END PGP SIGNATURE-----

--TZwgJe6kwkXFAOxGN4N0zcW8a9IO8gTOy--
