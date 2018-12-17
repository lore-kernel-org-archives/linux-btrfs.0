Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC4C2C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 09:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8536320672
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 09:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731579AbeLQJGI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 04:06:08 -0500
Received: from mout.gmx.net ([212.227.17.22]:45821 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbeLQJGI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 04:06:08 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lv9lm-1hXte13l10-010IfX; Mon, 17
 Dec 2018 10:06:00 +0100
Subject: Re: [PATCH 1/4] btrfs: Rename found_type to extent_type
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20181217083602.10166-1-nborisov@suse.com>
 <20181217083602.10166-2-nborisov@suse.com>
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
Message-ID: <c3b516ca-52a3-6ffa-27eb-10eeec7c07f2@gmx.com>
Date:   Mon, 17 Dec 2018 17:05:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181217083602.10166-2-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:7E/0cqvXEnK+Re0HY6RhKC5HmdqRXl1UfQkwUXxW30iJ9VTXTsL
 IOqvLoBtj8aj+oGWHhXP+OX09ts9AtuEZNLgonAonjwDjf5T+JD3Mcc9H5q406ZcrW0e02H
 q+9dB2FryVL6s7K0qlEPMIVc18YLdqFi4hS72oZfwcMWPgO1SZ2nqeUh09UMYSPof1rz0+5
 RZUdsNzmhmIK04jVAz/jQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:UTwjcmA7hZo=:NfUwhUMxmnqa/C7+S8W0Wh
 V1h3kGS/gOcU0gf4OlhQZ4ULtBjDOddmVWOukSoXhZKFDrniet2Z2CVSd0TcNXv46cdQ31dPz
 Trr21QP1/deT82yCvxxe7daLSnWPKZ2JISWjVFCsfxkakEvpTFbxlgaagtWUf4PZDvEnfMy6G
 7gfQvi4dYibsgTM44dKR99FQgMxm18dUo5vsnWD3hozBsPOWeyUbk4wJIPuI297KFxaFEGKMh
 pWAWSaruK7LXGXylGHxzJBu1NaHMU2xXHmwRi6h0xjDeBBXkip8QHAYowjrn5LvtxizQ1FgO8
 Pz03FIEdrp7vmqjlqjWrC5tuzogSfNVxuYcGqV/l0bsEKAwz6+nUidK5gfZ/WrSzUya/IMlc8
 NoGeIvZIU0ZdxULA2J1nXh98Koa1vU3WWOeH0dK6HS+Mp6FRmNQrqrizNZoRqF5wemCe0AKLO
 gmqLndL1UrXanTr81/CCDnIHDN+9HJ+52KtWQ70/lfwWV7NJmVWbXIEel113vn0Dd89+eaqzc
 Gb1dD24pQ93OFtK9rieu/OvE6raKKb5/siDDjbtnfTH4PsgSatNWuJoKFelmfTC7DqS/lnvOu
 WSsOxLc3TUpwU8LO33yU3UdPd4CFMNysSomI3FrnE8liXbYqeFi6vYEXOFxIN6TM7DCO1lqKX
 vZsncUgsWyMHA3xVIdWONKZnNzzCe5BfmEn3Kr1RSLQ4xob19RV58G9QQKujG6O3l0Bwx2ABw
 DGUjloGYJuAP9lpCzyo59lQVpHTuejglHkdhaqY2sClP6xS8koJe6tSxUGJ6xtfgR8TcxCGus
 U077fcsW9MXIWmpaIjryI7yWpeygYUMiRcgi0Ngn+qnHvfQnVGLjBmOgSPGP6ad2a2uH3bc2B
 h1P3AQG4WQsSrNcm+8DngJAexNGZTPDkZt3P81MjengmfcR1xobk28FxCgfDbNkJ1TB3iGagk
 M+jMCdVdkWQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/12/17 下午4:35, Nikolay Borisov wrote:
> found_type really holds the type of extent and is guaranteed to to have
> a value between [0, 2]. The only time it can contain anything different
> is if btrfs_lookup_file_extent returned a positive value and the
> previous item is different than an extent. Avoid this situation by
> simply checking found_key.type rather than assigning the item type to
> found_type intermittently. Also make the variable an u8 to reduce stack
> usage. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Indeed, abusing u64 for u8 makes it pretty confusing.

Now looks much better.

Thanks,
Qu

> ---
>  fs/btrfs/inode.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 73ae4428d0df..fe25f66a98d9 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6746,7 +6746,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
>  	u64 extent_start = 0;
>  	u64 extent_end = 0;
>  	u64 objectid = btrfs_ino(inode);
> -	u32 found_type;
> +	u8 extent_type;
>  	struct btrfs_path *path = NULL;
>  	struct btrfs_root *root = inode->root;
>  	struct btrfs_file_extent_item *item;
> @@ -6812,11 +6812,9 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
>  	leaf = path->nodes[0];
>  	item = btrfs_item_ptr(leaf, path->slots[0],
>  			      struct btrfs_file_extent_item);
> -	/* are we inside the extent that was found? */
>  	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
> -	found_type = found_key.type;
>  	if (found_key.objectid != objectid ||
> -	    found_type != BTRFS_EXTENT_DATA_KEY) {
> +	    found_key.type != BTRFS_EXTENT_DATA_KEY) {
>  		/*
>  		 * If we backup past the first extent we want to move forward
>  		 * and see if there is an extent in front of us, otherwise we'll
> @@ -6827,16 +6825,16 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
>  		goto next;
>  	}
>  
> -	found_type = btrfs_file_extent_type(leaf, item);
> +	extent_type = btrfs_file_extent_type(leaf, item);
>  	extent_start = found_key.offset;
> -	if (found_type == BTRFS_FILE_EXTENT_REG ||
> -	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
> +	if (extent_type == BTRFS_FILE_EXTENT_REG ||
> +	    extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
>  		extent_end = extent_start +
>  		       btrfs_file_extent_num_bytes(leaf, item);
>  
>  		trace_btrfs_get_extent_show_fi_regular(inode, leaf, item,
>  						       extent_start);
> -	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
> +	} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
>  		size_t size;
>  
>  		size = btrfs_file_extent_ram_bytes(leaf, item);
> @@ -6877,10 +6875,10 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
>  	btrfs_extent_item_to_extent_map(inode, path, item,
>  			new_inline, em);
>  
> -	if (found_type == BTRFS_FILE_EXTENT_REG ||
> -	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
> +	if (extent_type == BTRFS_FILE_EXTENT_REG ||
> +	    extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
>  		goto insert;
> -	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
> +	} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
>  		unsigned long ptr;
>  		char *map;
>  		size_t size;
> 
