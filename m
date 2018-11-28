Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA24C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC73F2086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:33:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC73F2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbeK1Mcu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 07:32:50 -0500
Received: from mout.gmx.net ([212.227.15.15]:38059 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbeK1Mcu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 07:32:50 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LfkUs-1fdaoO26uY-00pKX0; Wed, 28
 Nov 2018 02:32:55 +0100
Subject: Re: [PATCH 8/9] btrfs: switch BTRFS_ORDERED_* to enums
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1543348078.git.dsterba@suse.com>
 <15902ae1f53ef52d36fb4371fa2ec3428ca7158a.1543348078.git.dsterba@suse.com>
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
Message-ID: <6a88667b-71e9-e31e-77b0-9880bdc15dfb@gmx.com>
Date:   Wed, 28 Nov 2018 09:32:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <15902ae1f53ef52d36fb4371fa2ec3428ca7158a.1543348078.git.dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="syTXoB2h68f1YgKYVDUqpMn77GQOTXV5F"
X-Provags-ID: V03:K1:6E2UwgGixGnpg1b2/gtCNw/ucOa7gVgv0jMUnChN5Em8E7y3Oka
 mfUSMGMD4ThvDCWNN+qNR/QQejHfkWfJM9EHLHiYasN/T6qMx0c/6njc59lEAPHfV7Fn6m4
 8eCJx5geb9Y9sB6COZnBpYSrmp9hG3dOZtcstwDme3MiWBeUrvhzwVX0ivhUVC5VWE+5ahD
 zF50RqRbe9/jh83xH398g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zDjbjY8Hz10=:WDRIVG5r8UYek64AawMMR4
 QxFbsWJXCOhwKw1fq7f+pgS5Qn4ceTzntwY65RUTxuBY5R0D412pFjDb4PQ+EJmbssoedxikk
 itN52cnXTABnbEyRd9BCT1bXhnK2Js53x5RTWtoHAIcVq02JTF4NB9zqNVjjTmNgT+9/uFX7b
 bd74SUbIThnu6v8sGeLqONVLoEnGiOzkyvjLz4UofFBv6M2XCbfOZlQ7KhqQu9mPG3dg51/oV
 ReU3cRqd+MSwgHspA4iXjeJLJ7F5RoUDBztMkKZorH83z15bJKnViLdxl2hitAdUbBg+cHenI
 sMXntWNj1gVyiwilrK4SK0//AEfSEpHFAqVUsk7ATok5OjkRF3JQEvaKA5N6g6lbem6tGXMk8
 m4hWLq0nIQeT7gJUMns5Bat9MW6ye+w1LOCr1p5vNwJ95JAqJ0vi3NOMw7WI8V2wT+Svl26lb
 fKCfOEGeMT1TJkHD4hNljQWQIw0/xiGkk5vMchf2ZZ1UA0ZJcORU9Z4JRn1VBPvGtNBS7RXJB
 RumUF7TAEolWLX4dOmL4GV8jMtoqRFUichYvw8TWnX2uZpAN8nP+ZH7nnUZglvAR1OYB9MK+P
 wGK5/EPo6DyxLS8kzTKPejpkacj54691UmFGfwBTl2/4J8VnwWtwkg/hhVTt0lpM3rWZzxaIF
 yfyOeL8hzfdPQ1Ml6h7CEWcYUUL9wfDm1AVE2Glb1aD+d6CQd7vIypduy1vZCvae+URKH0JrM
 MULYqg9nmbf2Pv2LLPrC8HctIayFsHDy2jRuPTSGjBbk1jmjs7HDdqQhTbYOKL0XsuKNqT93Y
 6Hl79NxPeV0gVKw0/JIpo0iEnjm2xfHuAzbqyat2SEQhLxg6tKTg/SaB6VpKEP+AaQqisr1uN
 GQwoCvJoEB8zzdR66q6Zlr28xtpR0vbdbX3C/1ILY=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--syTXoB2h68f1YgKYVDUqpMn77GQOTXV5F
Content-Type: multipart/mixed; boundary="ZsoHzrJi2FvU9prwtQDRCye2J7aSOoffe";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <6a88667b-71e9-e31e-77b0-9880bdc15dfb@gmx.com>
Subject: Re: [PATCH 8/9] btrfs: switch BTRFS_ORDERED_* to enums
References: <cover.1543348078.git.dsterba@suse.com>
 <15902ae1f53ef52d36fb4371fa2ec3428ca7158a.1543348078.git.dsterba@suse.com>
In-Reply-To: <15902ae1f53ef52d36fb4371fa2ec3428ca7158a.1543348078.git.dsterba@suse.com>

--ZsoHzrJi2FvU9prwtQDRCye2J7aSOoffe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/28 =E4=B8=8A=E5=8D=883:53, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> ordered extent flags.
>=20
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/ordered-data.h | 45 +++++++++++++++++++++++------------------=

>  1 file changed, 25 insertions(+), 20 deletions(-)
>=20
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index b10e6765d88f..fb9a161f0215 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -37,26 +37,31 @@ struct btrfs_ordered_sum {
>   * rbtree, just before waking any waiters.  It is used to indicate the=

>   * IO is done and any metadata is inserted into the tree.
>   */
> -#define BTRFS_ORDERED_IO_DONE 0 /* set when all the pages are written =
*/
> -
> -#define BTRFS_ORDERED_COMPLETE 1 /* set when removed from the tree */
> -
> -#define BTRFS_ORDERED_NOCOW 2 /* set when we want to write in place */=

> -
> -#define BTRFS_ORDERED_COMPRESSED 3 /* writing a zlib compressed extent=
 */
> -
> -#define BTRFS_ORDERED_PREALLOC 4 /* set when writing to preallocated e=
xtent */
> -
> -#define BTRFS_ORDERED_DIRECT 5 /* set when we're doing DIO with this e=
xtent */
> -
> -#define BTRFS_ORDERED_IOERR 6 /* We had an io error when writing this =
out */
> -
> -#define BTRFS_ORDERED_UPDATED_ISIZE 7 /* indicates whether this ordere=
d extent
> -				       * has done its due diligence in updating
> -				       * the isize. */
> -#define BTRFS_ORDERED_TRUNCATED 8 /* Set when we have to truncate an e=
xtent */
> -
> -#define BTRFS_ORDERED_REGULAR 10 /* Regular IO for COW */
> +enum {
> +	/* set when all the pages are written */
> +	BTRFS_ORDERED_IO_DONE,
> +	/* set when removed from the tree */
> +	BTRFS_ORDERED_COMPLETE,
> +	/* set when we want to write in place */
> +	BTRFS_ORDERED_NOCOW,
> +	/* writing a zlib compressed extent */
> +	BTRFS_ORDERED_COMPRESSED,
> +	/* set when writing to preallocated extent */
> +	BTRFS_ORDERED_PREALLOC,
> +	/* set when we're doing DIO with this extent */
> +	BTRFS_ORDERED_DIRECT,
> +	/* We had an io error when writing this out */
> +	BTRFS_ORDERED_IOERR,
> +	/*
> +	 * indicates whether this ordered extent has done its due diligence i=
n
> +	 * updating the isize
> +	 */
> +	BTRFS_ORDERED_UPDATED_ISIZE,
> +	/* Set when we have to truncate an extent */
> +	BTRFS_ORDERED_TRUNCATED,
> +	/* Regular IO for COW */
> +	BTRFS_ORDERED_REGULAR,
> +};
> =20
>  struct btrfs_ordered_extent {
>  	/* logical offset in the file */
>=20


--ZsoHzrJi2FvU9prwtQDRCye2J7aSOoffe--

--syTXoB2h68f1YgKYVDUqpMn77GQOTXV5F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv98EIACgkQwj2R86El
/qjGHgf/RfnzzjoSkpI4yxZojrRJu1wiDR38FMpT/rqAPp4f9Yt/8hWN8YCblon/
sW3PlwPmXkoVutbkBQnhrKJ91Lt4bT3Klp6K89e/kLG0bjYzsvZrElOKg+tUkFCi
8FnUqzq22JmpISAHxLsC7+n8iJEQvhTaN7Zi0q7QKdJjwEvmXJRZz1froADQcfhW
qDbKYO/xpyLmzumrk754CkV2c/9qDZuHOK9Ztoekz6zWV6uD1ROgoSBMDi9HGTkD
+3Cif4KFeDvzctodrjXfcra8fC2YAkmu0wIZM0i4xGlGLBjoen3atYhwpp4Nsj1T
3pGGNaDuCFdeTwqu3rfJLHFgfFUzMA==
=wy/U
-----END PGP SIGNATURE-----

--syTXoB2h68f1YgKYVDUqpMn77GQOTXV5F--
