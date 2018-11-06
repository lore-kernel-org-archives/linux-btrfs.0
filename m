Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59BEFC32789
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 14:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2029B20685
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 14:53:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2029B20685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388951AbeKGATC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 19:19:02 -0500
Received: from mout.gmx.net ([212.227.17.21]:46569 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388813AbeKGATB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Nov 2018 19:19:01 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MZlEg-1g6M7t04Y2-00LYHu; Tue, 06
 Nov 2018 15:53:20 +0100
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MZlEg-1g6M7t04Y2-00LYHu; Tue, 06
 Nov 2018 15:53:20 +0100
Subject: Re: [PATCH] btrfs: Always try all copies when reading extent buffers
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc:     wqu@suse.com, josef@toxicpanda.com
References: <20181106144020.3446-1-nborisov@suse.com>
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
Message-ID: <a9c486f8-f8ae-7463-205a-8ba60e011842@gmx.com>
Date:   Tue, 6 Nov 2018 22:53:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181106144020.3446-1-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Q9aq0MKMt85gzI2axAIvjnD9uFZC3A020A2r8iEbY9WWcMv8FUF
 cw4p/a7Ool0L2gIy8tzb8BRmspKop14ObNfmZ3e+6ZoaGDUz9YoADs8v4L6Bd7ZFnQxQ6S5
 1MA48qeZYtnC5blPB2TTeKNxGNj3Bkr0x8eQ0zDLMnYeCrexXVi4o2uYsmJtf1N0HSPATIW
 oNVq3SY9xQhPJxYblGHuQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:pL7oroaGk3E=:NGUos2j+XhaYhtoR7rOHFW
 kpPv5NE5HhJ2iv7rfL+DwZ2RU9F6RbWOFAzCqmDcZ49SRytudpavq3l85FaUSfDopj0exRGow
 XAt4LLmago48jIgDAEX5qvgmLsy82Y4EXcrUsTU9ABjzAf3AZoRG6yR0niBLGBMPodupuF00a
 l36H0uyP1ARFoGH7EYY73xCeMVPkieBhEsivtC5mQYGpthKCOe6kjIeLWskpyPdeTSkmWHP90
 AwIW3TbPOg9lG7nMcfzWK/wRFRztBBa4iUr4AAAK+oihYAYZisf+8lCrUW9srRTyzHc2p6S+j
 EJAOFF/adN2FshZrH/wqxDg0WORrIMu8UFzGKduwpsTrvPvImh3w+PAiWSLSpep/z1CdTLE9n
 RPrcev1GPbhM30/BLl6MZuaWh5nyrmm50JAQUppVdpeasE1MVHGkSv+bmrUg0Jp/2cokARK7d
 P1ScYJhPfZeJ4vdXDIWnTT4PTPWOeiaPBCPgbcW87mwR6KLPdxBQIRhsRePbVKliTm4GsbkzR
 LWd2LWVGlxcFMQA+holYEeoN+HW5F6+DjVkLiUEI2YngRZsYo+Epv6XPD4xBlrcUbJkLZ/bzF
 nkRt3E4tmbsPBu1E1joyJ3copxzWu4xt5GmwDdJ0fQskIaC4tXh8GM6Fvg81VeW1eTg4qwx9T
 ivX1pEXt4AGQiFUCUsBrTqk0CggmhKVgFN34JB7zeYF+/Qy/o3nr2Ww5jRSTkI6wooOyKG7Vc
 7kfpaO32Ay1a61dGbUwUgu3A0IUOwP8ETz4Y1MB/Di76e9xi+AWdNWnXF3tn1UQfc6cUyCGqB
 Yd4XX4gAKXxaevrgjzslKJ05bpTPsAB4Vi2DxaGlTGrl/6uUdg=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/6 下午10:40, Nikolay Borisov wrote:
> When a metadata read is served the endio routine btree_readpage_end_io_hook
> is called which eventually runs the tree-checker. If tree-checker fails
> to validate the read eb then it sets EXTENT_BUFFER_CORRUPT flag. This
> leads to btree_read_extent_buffer_pages wrongly assuming that all
> available copies of this extent buffer are wrong and failing prematurely.
> Fix this modify btree_read_extent_buffer_pages to read all copies of
> the data.
> 
> This failure was exhibitted in xfstests btrfs/124 which would
> spuriously fail its balance operations. The reason was that when balance
> was run following re-introduction of the missing raid1 disk
> __btrfs_map_block would map the read request to stripe 0, which
> corresponded to devid 2 (the disk which is being removed in the test):
> 
>     item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 3553624064) itemoff 15975 itemsize 112
> 	length 1073741824 owner 2 stripe_len 65536 type DATA|RAID1
> 	io_align 65536 io_width 65536 sector_size 4096
> 	num_stripes 2 sub_stripes 1
> 		stripe 0 devid 2 offset 2156920832
> 		dev_uuid 8466c350-ed0c-4c3b-b17d-6379b445d5c8
> 		stripe 1 devid 1 offset 3553624064
> 		dev_uuid 1265d8db-5596-477e-af03-df08eb38d2ca
> 
> This caused read requests for a checksum item that to be routed to the
> stale disk which triggered the aforementioned logic involving
> EXTENT_BUFFER_CORRUPT flag. This then triggered cascading failures of
> the balance operation.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Suggested-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

However there is still a tiny piece missing.

Tree checker is done after some basic checks, including:
1) bytenr
2) level
3) fsid
4) csum

1~2) can be easily skipped just by pure luck.

But 3) and especially 4) are not that easy to hit.
Not to mention meeting both 3) and 4), since csum range covers fsid.

So I must say you're a really super lucky guy!

Thanks,
Qu


> Fixes: a826d6dcb32d ("Btrfs: check items for correctness as we search")
> ---
>  fs/btrfs/disk-io.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 00ee5e37e989..279c6dbcc736 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -477,9 +477,9 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
>  	int mirror_num = 0;
>  	int failed_mirror = 0;
>  
> -	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
>  	io_tree = &BTRFS_I(fs_info->btree_inode)->io_tree;
>  	while (1) {
> +		clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
>  		ret = read_extent_buffer_pages(io_tree, eb, WAIT_COMPLETE,
>  					       mirror_num);
>  		if (!ret) {
> @@ -493,15 +493,6 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
>  				break;
>  		}
>  
> -		/*
> -		 * This buffer's crc is fine, but its contents are corrupted, so
> -		 * there is no reason to read the other copies, they won't be
> -		 * any less wrong.
> -		 */
> -		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags) ||
> -		    ret == -EUCLEAN)
> -			break;
> -
>  		num_copies = btrfs_num_copies(fs_info,
>  					      eb->start, eb->len);
>  		if (num_copies == 1)
> 
