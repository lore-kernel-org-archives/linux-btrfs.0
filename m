Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE5BC282CE
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 01:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 684892171F
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 01:19:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="aIEQBXWq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfDFBHn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 21:07:43 -0400
Received: from mout.gmx.net ([212.227.15.15]:52087 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbfDFBHm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 21:07:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554512851;
        bh=nJJi1d43J9RGozz1d3D+wHLIX8hh4M04a+JD2mm3nYY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=aIEQBXWqVIpoEn4skCMc4wkp6WAYMEavooppDHimaYh8IpB3UVG5Q4VCfRMZMWSv8
         fJPlQdMYngpUsNdIV3p7vj9PjiJ5RZUC+CpHf7rnxlWdP9Wp4dSf+9NHwDudHjL4yI
         CBQPTT53TBphOEWzuEt/zwi4tE7Ysow3+TBaZiZc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MU1MP-1hKzqt39UH-00QiJf; Sat, 06
 Apr 2019 03:07:31 +0200
Subject: Re: [PATCh v2 5/9] btrfs: tree-checker: Verify dev item
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-6-wqu@suse.com>
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
Message-ID: <f0fb0d7e-4397-2489-042f-af46b1af0716@gmx.com>
Date:   Sat, 6 Apr 2019 09:07:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190320063717.31770-6-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:mOiAdMBLMEqLKii6RGvQNe3ZsZmGzUjqTsqlG8fpX4oJZlpPCMo
 EA6snQlIhoZV7TOmCAfBJJfcz9cXS0VGgW9M+4i34mYGQUg+/xEBWHPVCB2xtcYB+aODMGm
 jZJ/YM9cbQpoc6Mh5klT3wOIK/bpGMLFDFdyLBuyTtgLeIXKdii1SHRWTwj5HMXPl2rExcT
 /OchN1C5tjkW7lgUidx+Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gJ5fXviAZ+Y=:QWIVz+yaEHT7T+CIRpjTV8
 c6Sby478snCyNI3PMkO/EpmmtTNrHQ7RXJ8qv3rlebYNdrlrrNaBJtOrb31kdMRHBLBHI8L6E
 9aXLfIyGvX7OVIs8m4q5zFZXCpP/p6smgDxk/rK8xKWlpYeEr2W+wtyA+jM+aUrlay4S32RET
 irMrUevscfiN8dDDSD/sPbrJPSnUYCrKoDR6/zo2DeTXqP5IXTLyz+AqQnGzkAtvkp2UtSp42
 TRmH5UN7pH+jOksKRWE1uHvav08h24tBQ2OwDPwLuC7wd/p/NE/yGNBvJHIL/R5pSVKHG9ZVo
 QIH41+Hj6LoyUf3yKyAU/vj7/WvS75QauAmy10kLFDd0aPl2Z9AsjWV1iFysurvnqz7yGDaoO
 oFEZQj49Urb8g1NHefNBrGtMzPM/3g+/duMdq3ppEpa/MR851SIJ9crS34+ego5W3dK6V7b2y
 4sZy8VZae6AYiE4RYaNQw4ZdAGYgkAOd5kqz/Tx6hyhvki+m5xnURv4CdlBwFHoMSfiQhFADX
 uBB810bxGHOaSsPN+gq5HGTfCNMPIHoNh19T08lRLoum/wfAq3oitsPPe7VdxgA2qcrEd0P3r
 lHIwEqLjBepQ30FbrMbpih5VgV8vk0fIxFjISrsEGKInv7Eufx7CleNnHHDcNqLWFbDJwBkfT
 5IN2RbuJEFHfDcL9stjWXsMWSAr0Xyn6rV7eVfBC04pFQOfQODTPqu1a75z7BNs2DuG7dXrQ5
 1h6V7Uzzso2dWANCug5REPprmrcM5W0R7n/wELf6shXzHWG3Ev3krFTsgVgGlTqLm1whrrz3L
 5Zv5KqL7tak1NU8qN3aeTiwC7bTj5cIDrsC65URGLjfRPhmLiRTbjrE8vex7qvKFxVoMemaax
 UyIoUjDLxnHo7yNmM5oLLSgGwn+C0ZZ18Kht945VtJ5Q9Qj6OEvnoT7ah4wyAeEq2Zs0dWuPz
 jGu/3psFhYQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/20 =E4=B8=8B=E5=8D=882:37, Qu Wenruo wrote:
[snip]
> +
> +	/*
> +	 * Since btrfs device add doesn't check device size at all, we could
> +	 * have device item whose size is smaller than 1M which is useless, bu=
t
> +	 * still valid.
> +	 * So here we can only check the obviously wrong case.
> +	 */
> +	if (btrfs_device_total_bytes(leaf, ditem) =3D=3D 0) {
> +		dev_item_err(fs_info, leaf, slot,
> +			     "invalid total bytes: have 0");
> +		goto error;
> +	}


Hi David,

Please remove this patch from misc-next queue.

Under the following call trace, we could create device with total_bytes
=3D=3D 0;

btrfs_rm_device()
|- btrfs_shrink_device()
|  |- btrfs_device_set_total_bytes(device, 0)
|  |- btrfs_update_device()
|  |- btrfs_commit_transaction() #1
|- btrfs_rm_dev_item()

This will trigger write time tree checker warning.
And further more, this can create valid btrfs with device->total_bytes
=3D=3D 0 and triggering read time tree-checker if power loss happens after
above transaction #1 but before next transaction.

So this dev item check is too restrict.

And furthermore, the error output is misleading, its devid is extracted
from key->objectid, but it should be key->offset.

For the fuzzed image, I'd like to fix it by either enhancing the seed
device lookup procedure.

Thanks,
Qu

> +	if (btrfs_device_bytes_used(leaf, ditem) >
> +	    btrfs_device_total_bytes(leaf, ditem)) {
> +		dev_item_err(fs_info, leaf, slot,
> +			     "invalid bytes used: have %llu expect [0, %llu]",
> +			     btrfs_device_bytes_used(leaf, ditem),
> +			     btrfs_device_total_bytes(leaf, ditem));
> +		goto error;
> +	}
> +	/*
> +	 * Remaining members like io_align/type/gen/dev_group aren't really
> +	 * utilized.
> +	 * Skip them to make later usage of them easier.
> +	 */
> +	return 0;
> +error:
> +	return -EUCLEAN;
> +}
> +
>  /*
>   * Common point to switch the item-specific validation.
>   */
> @@ -632,6 +712,9 @@ static int check_leaf_item(struct btrfs_fs_info *fs_=
info,
>  		ret =3D btrfs_check_chunk_valid(fs_info, leaf, chunk,
>  					      key->offset);
>  		break;
> +	case BTRFS_DEV_ITEM_KEY:
> +		ret =3D check_dev_item(fs_info, leaf, key, slot);
> +		break;
>  	}
>  	return ret;
>  }
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 645ffc9c47b0..7510272408e8 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4958,15 +4958,6 @@ static void check_raid56_incompat_flag(struct btr=
fs_fs_info *info, u64 type)
>  	btrfs_set_fs_incompat(info, RAID56);
>  }
>
> -#define BTRFS_MAX_DEVS(info) ((BTRFS_MAX_ITEM_SIZE(info)	\
> -			- sizeof(struct btrfs_chunk))		\
> -			/ sizeof(struct btrfs_stripe) + 1)
> -
> -#define BTRFS_MAX_DEVS_SYS_CHUNK ((BTRFS_SYSTEM_CHUNK_ARRAY_SIZE	\
> -				- 2 * sizeof(struct btrfs_disk_key)	\
> -				- 2 * sizeof(struct btrfs_chunk))	\
> -				/ sizeof(struct btrfs_stripe) + 1)
> -
>  static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  			       u64 start, u64 type)
>  {
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 3ad9d58d1b66..38ed94b77202 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -258,6 +258,15 @@ struct btrfs_fs_devices {
>
>  #define BTRFS_BIO_INLINE_CSUM_SIZE	64
>
> +#define BTRFS_MAX_DEVS(info) ((BTRFS_MAX_ITEM_SIZE(info)	\
> +			- sizeof(struct btrfs_chunk))		\
> +			/ sizeof(struct btrfs_stripe) + 1)
> +
> +#define BTRFS_MAX_DEVS_SYS_CHUNK ((BTRFS_SYSTEM_CHUNK_ARRAY_SIZE	\
> +				- 2 * sizeof(struct btrfs_disk_key)	\
> +				- 2 * sizeof(struct btrfs_chunk))	\
> +				/ sizeof(struct btrfs_stripe) + 1)
> +
>  /*
>   * we need the mirror number and stripe index to be passed around
>   * the call chain while we are processing end_io (especially errors).
>
