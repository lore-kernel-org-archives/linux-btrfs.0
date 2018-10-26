Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2284BC6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8CDE2084D
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:04:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8CDE2084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbeJZUlg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 16:41:36 -0400
Received: from mout.gmx.net ([212.227.15.15]:45383 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727491AbeJZUlg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 16:41:36 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MGjfl-1gKBr917jt-00DayR; Fri, 26
 Oct 2018 14:04:43 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MGjfl-1gKBr917jt-00DayR; Fri, 26
 Oct 2018 14:04:43 +0200
Subject: Re: [PATCH 1/5] btrfs: Ensure at least 1g is free for balance
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
 <1540554201-11305-2-git-send-email-nborisov@suse.com>
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
Message-ID: <efa4b7ed-118a-62cb-2726-7e4c534a8c5b@gmx.com>
Date:   Fri, 26 Oct 2018 20:04:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1540554201-11305-2-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:V0uWklUxmrjlkJveHxqxgc3N718M+MIfaJiUJbnkD1rSbWPX9XX
 ghYwdFczcQrmwis4KVjDT4cgdUsOOxZe3OKVbqbpfAYyEMdQlTfYO2xegJUQRFAIcDUhMfq
 QGJEB1jOaIddiBOgkTEtXo3tYRoNPzalyunKKaYE9O+SxN0mzYIsiDTREJrYgKj1UiX0BgH
 X+aJIijG+6DNi6zwscWAA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:LIxqBEc0LDM=:IHP/GyId/sFhFty4iayFUx
 WpbvnWrmqI0AgmVZRr2I2Nu2h1Fo8EMKAGFAwJVJrjPbQth/pC3I93xVfLN3d5P6+2+2Y2Tkx
 P4pkcCcOOaQJAMNLhgTuZOOl93zimc9118Hk5240vbfAK2+DmYKSQKA8gzWGuQHag0YhjNlVl
 PS1/biTGtNgwRFLPDXC7PDff0SF2z+EBvPNYdttiZ4jfOV3RNp72no9VDQ+RKzeZHwC6bFxZ/
 Bi1hqxeIKRSe/W9IyDIKh4lRHdZr2GFLQEELW4O0w9XE5xkBFCUfpCK3ikL5bVPdXaK3dM+El
 /phunF5JQcduCx3fE+W7G7YRu9e6zcLfNWCylhdhN+So+rBscIXokdXeTkCcUCqPAjru3c0vP
 B9jsKfGEJkaWA7xKVqioFBUlRnAmiBk+l9Frx9k3/DSTD2hoefLUdpOKdWay5hjyRgAsjb8eG
 LKiXVBqEqAV+D0MizzqH0cvnuilREOg03rXccEzx/2AaXCJtUVhJOKpf9rrTUJG3d3LoKDLvd
 m5Qab2ZTC2upOL1y9Rlx96MpPU/YTtCvBNqBQGbTFCinSVqD52qOpqBhnEVlSi37hzTH8cQvQ
 nya9t0SCqV7qIZfNzBC7izkuQg1JsBfgavspgDZYjuqt25plzVSe3DfYNNobvZrUWGlbKsc/Q
 TmhVd8RwIqmZwEQjUpoePW940wUwf/Qt8+/YtLhaZlwNWK0lmOaXz/1JJD+O3Kgiihv3SEm6n
 9yfU4NkAgiQ95Qtk8XSFkrZI+eV+s+zRWtJPt6ABCFc+31xdycGC0dzick8PEBa+eOv9g5Ray
 0kT35qkCDY/DMmxuxvr2IIcFFx6tIoYEg58acKMGunmenI3v8A=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/26 下午7:43, Nikolay Borisov wrote:
> The first part of balance operation is to shrink every constituting
> device to ensure there is free space for chunk allocation. However, the code
> has been buggy ever since its introduction since calculating the space to shrink
> the device by was bounded by 1 mb. Most likely the original intention was to
> have an upper bound of 1g and not 1m, since the largest chunk size is 1g.

Minor nitpick, largest chunk size -> largest chunk stripe size.

As for data chunk, it's possible to get a 10G chunk, but still only 1G
stripe up limit.

> This 
> means the first stage in __btrfs_balance so far has been a null op since it
> effectively freed just a single megabyte.
> 
> Fix this by setting an upper bound of size_to_free of 1g. 

One question come to me naturally, what if we failed to shrink the device?

In fact if btrfs_shrink_device() returns ENOSPC we just skip to
relocation part, so it doesn't look like to cause regression.

If this can be mentioned in the commit message, it would save reviewer
minutes to read the code.



BTW, I think for that (ret == ENOSPC) after btrfs_shrink_device(), we
should continue other than break, to get more chance to secure
unallocated space.

Thanks,
Qu

> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f435d397019e..8b0fd7bf3447 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3467,7 +3467,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
>  	list_for_each_entry(device, devices, dev_list) {
>  		old_size = btrfs_device_get_total_bytes(device);
>  		size_to_free = div_factor(old_size, 1);
> -		size_to_free = min_t(u64, size_to_free, SZ_1M);
> +		size_to_free = min_t(u64, size_to_free, SZ_1G);
>  		if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) ||
>  		    btrfs_device_get_total_bytes(device) -
>  		    btrfs_device_get_bytes_used(device) > size_to_free ||
> 
