Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1241C67863
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 02:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1FA12082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 02:58:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1FA12082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbeJXLYl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 07:24:41 -0400
Received: from mout.gmx.net ([212.227.17.20]:40017 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725979AbeJXLYk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 07:24:40 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lu7ty-1fVMg91ccY-011S4P; Wed, 24
 Oct 2018 02:16:36 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lu7ty-1fVMg91ccY-011S4P; Wed, 24
 Oct 2018 02:16:36 +0200
Subject: Re: [PATCH 07/13] btrfs-progs: lowmem: delete unaligned bytes extent
 data under repair
To:     Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-8-suy.fnst@cn.fujitsu.com>
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
Message-ID: <a676d70d-07c3-8be3-ad0a-f029e23b036e@gmx.com>
Date:   Wed, 24 Oct 2018 08:16:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181023094147.7906-8-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:NK+1+6JarKhy9jxeEmlhnc3u8ljKfXhD4AK9ZlzLjDbPuybnEpK
 OIW9vE2fYnldT9Oz8JpS/+Jj9NkadXOoqspBwew2vaeHMmGfe6J34ENVaAG8R5JVU8F1Sdc
 Ed10PkYrqKT1cYv6gMxWvB9GdEBAcz2R6elNf+YNNpcgjdzSp6+7f4HRZPU1U7pNNTxPsgP
 /oHVNGL5Tti/uq/AUXEFg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:hPmMGMm9Lww=:rmZ2WCiUthmAYnGTDzubFU
 3P90rzHFhlbGc5RMbsdJ0pzM6spZ0ZMh9NQdG0k2vBImGLmRlmq/py4l/YUFvThSnsPQ6vq/2
 Xank7OtLhHbuIEcQhJynnMp9AA/OAneCuBlyfErnkm/3/QcaNCZgiTNB2IL9TFDT8+cYWwnKf
 eNxxyvK5GCU+MwpxioqC1L2t3H3P1TvDl52CWQap9qyRmyVD/lUqa1lvSyOq5nRWLvvwNHT/6
 MdnEDJZplzGuv7sq7Z+Fpr+W5GDLc8mLkYCNn2OeWfKSPBzu62K028qufKsdXU6GmiJp0V4Lf
 brF9rTUzHcDKiulImoEHdWVeIXvQKBko0J1eUeY1xqKFIFT24sCNrExwQSE8GbX7XVh5PLXtd
 V4W97VyBKZh8k/i2mEFATLSV6Izd+9ub6aWg6wGT+piNuenWwDto8dRPAkmahgWulCtmCP6rt
 lhC9oXN1RfVohS6XjOdGk9odenmJUI+9tSHi3lrd0JNWlOiDqKjp8QXv8SdQEapxdy2I3ctf6
 G8GIEjqQxRqWqSbUI3GRKxuSZ77ArpKpfIMyQrNt83llt1ZyVMjg0TU6GLfnhxNb8TqYJk3hn
 KMg0fa5lb6WhD7gvD4wXh6UriSmg9CfLxDKui5b5QNBRl6beO8AA022ZTsnaiS1FRsndyAgzM
 816MGZxxyLoP5geJ6NaSgplLaXntdW4B6hnsnyxm18uwBCP8G67bNl153Ipkojk+kaaP5eS35
 Ughbi+Hgk/LO2K0GXqZe78EJIWb159jgEnV4HtdaJtFD0ovJJ2bzveq1zzXbd5bou4EOnYE/l
 alntYr+UUb5O7buDc0F9iUqvkMSF9Te0z1V3//bNIJzweCz3Yc=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/23 下午5:41, Su Yue wrote:
> If found a extent data item has unaligned part, lowmem repair
> just deletes it.

Fair enough solution.

Much better than the unpredictable original mode solution.

> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  check/mode-lowmem.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 3c9ecff7e498..5381096fa8b2 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -2972,6 +2972,7 @@ out:
>  }
>  
>  /*
> + * If @err contains BYTES_UNALIGNED then delete the extent data item.
>   * If @err contains BACKREF_MISSING then add extent of the
>   * file_extent_data_item.
>   *
> @@ -3023,6 +3024,13 @@ static int repair_extent_data_item(struct btrfs_root *root,
>  	else
>  		parent = 0;
>  
> +	if (err & BYTES_UNALIGNED) {
> +		ret = delete_item(root, pathp);
> +		if (!ret)
> +			err = 0;
> +		goto out;
> +	}
> +
>  	/* now repair only adds backref */
>  	if ((err & BACKREF_MISSING) == 0)
>  		return err;
> 
