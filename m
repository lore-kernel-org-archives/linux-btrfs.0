Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A125C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 13:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 503CF20828
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 13:53:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Suo2/3NT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfCSNxZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 09:53:25 -0400
Received: from mout.gmx.net ([212.227.15.19]:35237 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbfCSNxZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 09:53:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553003578;
        bh=IosD3vXYkUzrj5MPxIc+uXguqT+XMcdjdmFGoopyaLI=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=Suo2/3NTTVYtwTiGyztAjTaeqEJhPO2nfvKLkGznGd0Ba16P0CL7DisUtn9cCNDyk
         uwfgeO6NIJJ95pFRJKkYxlj58VsHKj9KZdD1CDjAX1bW91SwAnoI/7GGKI5TKs+HLu
         kq3a/MsxFZCL61nIm/tylqwp7qxXjYTrO8/wETyw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LtJAR-1h0F062O2V-012t9f; Tue, 19
 Mar 2019 14:52:58 +0100
Subject: Re: [PATCH 2/2] btrfs: Introduce new tree block flag,
 BTRFS_HEADER_FLAG_LOG
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190319060418.29575-1-wqu@suse.com>
 <20190319060418.29575-2-wqu@suse.com>
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
Message-ID: <73d2e090-822f-8484-ff3f-e374cf6fab28@gmx.com>
Date:   Tue, 19 Mar 2019 21:52:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190319060418.29575-2-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fj75teU3yrSCJnHkILYFAmpAK6kGU24zk"
X-Provags-ID: V03:K1:/tf771ft/VJ5R9ji370Lxp+v8JGs8vuCcgpnsGchTVudgzCLJtX
 2yy/2AoNwftW41tKxb0QXNVPZVwnWFZtPH4KnKhreJ1kmgU6QI3a7ckIbL2xES/rs1nv09R
 fp/GSIPYrVSXx+O6onbMokG+5EYMqmtP1R4Xk1bjGjGRA5NWZbeDMU50tlw3YFOtlA1GXmb
 ht7W68ZQIyO1Iw1e1Hpvg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:luUTzWmXJl0=:CKtANmAG5/QDuAue2M2YNd
 eaP2EQQsM4pDP27apprQYcRzmEN9UB9aqP2lmTk4PRNWExPXCNtuBxzf7qAOHpR63vUAjQ4Wz
 aa+KzoKe6vC4FeF+72KyvDCCPqZ3pQfUAAsVqv7v63XN/N9niulryagc2fmXqKcuqx2s/pNbZ
 go7tAj0ASAdI4VJSVIk7RElIJOP7q1NyVN0rkt1PmBZ96XaycP+L+Cr5mc5k7yFCPa3ioAEWu
 irxMP1Jt6VdARSSVBPnbAW4mxA0R84qiInYh8/MiZEKb8l9bOtpLKGI2KwV1QgeovN8o1X0XF
 Xa+27VNg72VTglgSr/jm0SZGBYuin0bClsXrpKNGNnlLMNMLfrGLGt+5tZtK67ss2VANNYP6P
 udj5jin9s+I58qUqh7OQhfiPp0D+qT8vHp0cPmvXHaUAOjsLAUkKUCgwzuzSKF9ERcGRMx0ZL
 +GXLAixUP8tOpC+VXoQAsf7rQQeQ57LMKxCNlDSQbOYuCftrxWLE5MLaGh8b6a4XmQi2U42a8
 /+cgg3guAZTrQuE5O/TmMJtipxVOQzptxOZ4N4j1V0B7JV9GWbFv2GZKPrVh8uHN2sMwFcKsi
 wnq1oYf9CPRG08wUlica15fn5fiVi0VscwLZ3Qf714Li6cRV3Z59QontBhhdi8Na8NcMVQ1Pw
 0NaggutOdnwr3aCGL3Vv/NjtuO5mgdljgj5O9EA2gA7CCkqq4JsLlBiDXcfMAMurBkvg/bXKP
 11HBKbTdpIfNHtYTx7TLYbFVT5q7Glrq/K0YY+JQD1zccmhYzVYZsbqTJnN1Wmul2zNPNVMmL
 4nppsLaXxsSEmjHbE6K/D0wYFt/EY7lI0p35Zt3UndaG9p5V/fz+uIy7hR3w1BeLBNna+jK7R
 E4BqWFT/cipMdesywO3uz+LiN42x0cd6Z5p+A4psVPyxvk8aEXIJ7ANgwNmizG
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fj75teU3yrSCJnHkILYFAmpAK6kGU24zk
Content-Type: multipart/mixed; boundary="ki1fW7RF1bPPINbiImABTulJL7l3235ZU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <73d2e090-822f-8484-ff3f-e374cf6fab28@gmx.com>
Subject: Re: [PATCH 2/2] btrfs: Introduce new tree block flag,
 BTRFS_HEADER_FLAG_LOG
References: <20190319060418.29575-1-wqu@suse.com>
 <20190319060418.29575-2-wqu@suse.com>
In-Reply-To: <20190319060418.29575-2-wqu@suse.com>

--ki1fW7RF1bPPINbiImABTulJL7l3235ZU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/19 =E4=B8=8B=E5=8D=882:04, Qu Wenruo wrote:
> This new tree block flag is to indicate the tree block belongs to a log=

> tree.
>=20
> For btrfs on-disk format, there are several different trees could use
> the same owner number:
> - ordinary subvolume tree
> - log tree for ordinary subvolume
> - reloc tree for ordinary subvolume
>=20
> It's possible to do the backref walk or use the content to determine th=
e
> real owner of the tree block.
> But backref walk is too expensive, content detection is not reliable.
>=20
> So adding a new flag to explicitly show the owner of log tree.
>=20
> Thankfully, tree-checker hasn't checked header flags yet, and there is
> no real user for this flag yet.
> So we don't need to introduce any compatibility flag for this
> modification.
>=20
> The introduction of this new flag makes tree block owner easier to
> distinguish, making life easier for:
> - tree checker on log tree
>   Log tree could contain some items impossible for regular trees
> - performance profiler
>   Now it's much easier to distinguish log tree.
>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Please discard this patch, it lacks header flags inherit part.

E.g. when splitting tree block, the higher level and brother tree block
doesn't inherit the header bit.

I'll address the problem in next version.

Thanks,
Qu

> ---
>  fs/btrfs/disk-io.c              | 1 +
>  include/uapi/linux/btrfs_tree.h | 6 ++++++
>  2 files changed, 7 insertions(+)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 6fe9197f6ee4..8cffdb7789d8 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1362,6 +1362,7 @@ static struct btrfs_root *alloc_log_tree(struct b=
trfs_trans_handle *trans,
>  		return ERR_CAST(leaf);
>  	}
> =20
> +	btrfs_set_header_flag(leaf, BTRFS_HEADER_FLAG_LOG);
>  	root->node =3D leaf;
> =20
>  	btrfs_mark_buffer_dirty(root->node);
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs=
_tree.h
> index e974f4bb5378..d4ef80b702a0 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -447,9 +447,15 @@ struct btrfs_free_space_header {
>  	__le64 num_bitmaps;
>  } __attribute__ ((__packed__));
> =20
> +/* Tree/super has written to disk */
>  #define BTRFS_HEADER_FLAG_WRITTEN	(1ULL << 0)
> +
> +/* Tree block which gets relocated */
>  #define BTRFS_HEADER_FLAG_RELOC		(1ULL << 1)
> =20
> +/* Tree block which belows to log tree */
> +#define BTRFS_HEADER_FLAG_LOG		(1ULL << 2)
> +
>  /* Super block flags */
>  /* Errors detected */
>  #define BTRFS_SUPER_FLAG_ERROR		(1ULL << 2)
>=20


--ki1fW7RF1bPPINbiImABTulJL7l3235ZU--

--fj75teU3yrSCJnHkILYFAmpAK6kGU24zk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyQ9DQACgkQwj2R86El
/qhbqQgAkWqj+KS4lh+Z2rjSB0aKDCqEy8wDKrFFapnIsEijhOyrJxumBSfrdRHY
1DFM/RThQ07vkfBkBWgBPECmm6iAqrtxji1oU9KYBlwxXk0N3lPcAZpq2ZX9AqVH
IBxB7cptCneO5rRQQrlK7bk+zwbbMzEhTXmDmzAgjLPCYAck3OibjGwgv0v+IUeb
lp6LP27U+KQRiz2M0am4lZu7juXQ3iwWnw06OF9afQw7iJxCSSu1xMf8pDIomI5O
WA9uD4LlIL5iaKkX/65Sp3xrtNtxer7+ldxtisRnVtaawdw5L2ESyYycAjZlxOyO
VUxEM5sY44v8bUi0c1DIfZwXHz0zqg==
=hhND
-----END PGP SIGNATURE-----

--fj75teU3yrSCJnHkILYFAmpAK6kGU24zk--
