Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00982C6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4AC720868
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:41:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4AC720868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbeJZVSA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 17:18:00 -0400
Received: from mout.gmx.net ([212.227.15.15]:53087 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727582AbeJZVSA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 17:18:00 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lrviw-1fb0cx1iww-013fpJ; Fri, 26
 Oct 2018 14:40:58 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lrviw-1fb0cx1iww-013fpJ; Fri, 26
 Oct 2018 14:40:58 +0200
Subject: Re: [PATCH 3/5] btrfs: Remove superfluous check form
 btrfs_remove_chunk
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
 <1540554201-11305-4-git-send-email-nborisov@suse.com>
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
Message-ID: <6cd57401-4177-5c6a-0f27-bad3856438c0@gmx.com>
Date:   Fri, 26 Oct 2018 20:40:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1540554201-11305-4-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:LFv8Ltw5hm30dROB/T2T3Rg0DTE5gTHpOmo+7OeG4kKhe02/68W
 4k2V7MBfdjl+lIwHZwBm426oLy02v01SN0hrRGuXY+kf+Tmyh6AmdOBmtWtlIuJHfKpIaV6
 RVAxGDIcittpsmV8oSMe+Vyu098e4Ylvc6l/iArB0Xh0SkDp2ScaNOqSx4GK1twF62fkl8m
 x55AnnVrRzxHkP+p2aLGw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:SNW/P1h0Fb8=:01dzWYpYCsiuTsFss9J2/m
 8V45fFHfF1yHX0WaOPWOyytE9WAdSLNaZ1lERSDcD8sDz/RhfspcXjPJAZFzB7uBVYdc5BwfD
 ao3nUIldip5xfzfNNJDOrg7NxdTgz1rwDIE7rIm2j/9hSHez1Q2vY3hc+DXRnUnz07q9uBQdP
 mzhLhJKgxhbC4QcjAsPyvXuulqt54fXIr3gz6qopZrITVS9hPKT3xIsGHVaz2zrJAD9pfBUpJ
 /CrEpzQFoZOUuUmFVcbTdls6TOF4P0DvxYPs2ja0oHpAIgL+ppEuB654nC+jo4Q7WPx26foWL
 pvnUyo/qIX7o/QPBsDKsBjerrpTFTVxV8enMU5j9b9vFCCcwx1qtDa51Y7FxDwdXrnFJs6/3M
 mQbBfH7mHQRr4ziur+x/JoExvbIRuLiLSW/m/E/3giKCIPcEbIqiiQiw5Mlli4tg6IYb5skHv
 mZD7M9HirT8t6k+P2swBb1kPC5aIILAcArLRZ0CBoY8mCLJ5HsWT1l1hk3L13tGsNeRR9JGUi
 dLxPDJw9pOuKehanEYnxGJe/3nq4q+6oEUXFY9UIN0+TY+r/AlbnBAdjemmOR22dbox5OTtB4
 wjLav8liauLrXpYds3m/uN71UF2IZV/0jOWACDJKZaBTIv9phXynfm68epiZO9t97QIWIoNq1
 oYbWSEqLUYvv0dbzEcajEpivy7sIlcZlrgATRi64jM8g2vJVw+PXQ9LOir3Lr489LeIUwaa+A
 MMGUPivNlDHnpI2SnPA7rBuba2V+w213HEbeNxrDZceKnmMFsNrNQlYv0WNZ2qcMEGNuZA5Pq
 VadfyCF6rFw1IbTVp/M0TNcC6XGokHJLMoUlUTKVK4Sn7UBqWc=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/26 下午7:43, Nikolay Borisov wrote:
> It's unnecessary to check map->stripes[i].dev for NULL given its value
> is already set and dereferenced above the the check. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/volumes.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index dc53d94a62aa..f0db43d08456 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2797,13 +2797,11 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans, u64 chunk_offset)
>  			mutex_unlock(&fs_info->chunk_mutex);
>  		}
>  
> -		if (map->stripes[i].dev) {
> -			ret = btrfs_update_device(trans, map->stripes[i].dev);
> -			if (ret) {
> -				mutex_unlock(&fs_devices->device_list_mutex);
> -				btrfs_abort_transaction(trans, ret);
> -				goto out;
> -			}
> +		ret = btrfs_update_device(trans, device);
> +		if (ret) {
> +			mutex_unlock(&fs_devices->device_list_mutex);
> +			btrfs_abort_transaction(trans, ret);
> +			goto out;
>  		}
>  	}
>  	mutex_unlock(&fs_devices->device_list_mutex);
> 
