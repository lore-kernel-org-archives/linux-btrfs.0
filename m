Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09928C67863
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 03:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C81822075D
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 03:16:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C81822075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbeJXLmT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 07:42:19 -0400
Received: from mout.gmx.net ([212.227.17.22]:48751 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbeJXLmT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 07:42:19 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MTvUT-1g64jZ3BDd-00Qlum; Wed, 24
 Oct 2018 02:34:17 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MTvUT-1g64jZ3BDd-00Qlum; Wed, 24
 Oct 2018 02:34:17 +0200
Subject: Re: [PATCH 10/13] btrfs-progs: check: fix bug in
 find_possible_backrefs
To:     Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc:     Su Yanjun <suyj.fnst@cn.fujitsu.com>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-11-suy.fnst@cn.fujitsu.com>
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
Message-ID: <ebe648fe-e947-e874-9a88-7d34f942c746@gmx.com>
Date:   Wed, 24 Oct 2018 08:34:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181023094147.7906-11-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:HLctCwfguN9ZnGz5rqyxLHfW8uXYxqwC53JZUx600fvvaG9/cZk
 BKDExyzp7JROhKpequoein18+koz49VeYqTmiwXiAIklJuTZlOu1pnJVej/HmYQKAAkv9w+
 TM89JSxQwEesppSS6ZsrpoD7lUneTdiL80d0kYqMZcYvq2KmL640/paHer2UKWOCPDcKRHE
 eaJh9CzfbF7jY9NVGAASA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:iP9LalPCvio=:IA8xdc9znyPISckJP1brsO
 htorVSC7yuiJ7VKPy/2E9zn0b5IazCcVy6ZxeAusHumtAVCmpg89yhiHxKL6nleJR+LUMQsFr
 BbZcRFlScxtIS6fOGzpDaXYwSLfaJu0k19N0IRtwYumGjdUGzST5oPO1C1w7Xt7pWocFEr9vE
 JmMrOM80UO3jaW9BwNUgBu+ICl64a41NLuRRePJvWMAxKgEBMMw8thZMkAgIokNCx0+kVdAbU
 0SMHGFYjVmtBEyLnHOSDoAjaBEMzZdV5Kbl3yALx2HDcA5lfPAYjir4Gi0iR8H+4/AgY2tgio
 FU13Lc2Zh/iPYAzLzZ5bpiBZUDjCWGIJNCgP5jS7+6FLCrCDMhgyb7ZVrBP6r+SyoHHLD0K43
 AvFUf7yuNOp3M053Vxs/JHKOgWAijT7QvfCGsyVlqT9axS0+ZEs8sIxGDi/2KdC9Qbh63i576
 nkUR00j5Tc309xNzEW6r+ilQmDPmD1+ZYwOMjc7WfiUtSI/XytMtuHDz+X3zie2RxVLejfy/t
 Gg+H6+0jHWDXOhCukj2HATaOLPDQhJsZXynr5SuxCqrciiqQ5FRDujkVi+0j4svC/9ykM9D7T
 0Fn5OmHLWO+Ba3W4rQuIqUUyOpINshUgvhSR14OL1O/2X6lQoSU2qwUXltdafWV9cfmN6650L
 jki9hxGG1sYvo3nMnJjNAkKUy+fcCQ6jwjcwukwnJnoDeN5gFsX0ePnNVE7qV+GFTfnn+uyyf
 G1Qd1U59Liloh4EaA25zFSB0ZzAqswLm2cwNo/sKQouFh04Fr8bOBouRyzvyrmWZnDRyLNxrD
 UKI4qw4ePDE1gecQ+6KwasyFOaJ5u42CNsQO98hNZLCl75zYTY=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/23 下午5:41, Su Yue wrote:
> From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> 
> It may cost more time to search all extent data of correspond files but
> should not influence total speed too much cause that only corrupted
> extent items are participated in.

Sorry, I didn't really get the point of the modification from the commit
message.

Would you please explain the purpose of this patch first?

Thanks,
Qu

> 
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> ---
>  check/main.c | 110 ++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 92 insertions(+), 18 deletions(-)
> 
> diff --git a/check/main.c b/check/main.c
> index bd1f322e0f12..90d9fd570287 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -7015,6 +7015,89 @@ out:
>  	return ret ? ret : nr_del;
>  }
>  
> +/*
> + * Based extent backref item, we find all file extent items in the fs tree. By
> + * the info we can rebuild the extent backref item
> + */
> +static int __find_possible_backrefs(struct btrfs_root *root,
> +		u64 owner, u64 offset, u64 bytenr, u64 *refs_ret,
> +		u64 *bytes_ret)
> +{
> +	int ret = 0;
> +	struct btrfs_path path;
> +	struct btrfs_key key;
> +	struct btrfs_key found_key;
> +	struct btrfs_file_extent_item *fi;
> +	struct extent_buffer *leaf;
> +	u64 backref_offset, disk_bytenr;
> +	int slot;
> +
> +	btrfs_init_path(&path);
> +
> +	key.objectid = owner;
> +	key.type = BTRFS_INODE_ITEM_KEY;
> +	key.offset = 0;
> +
> +	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> +	if (ret > 0)
> +		ret = -ENOENT;
> +	if (ret) {
> +		btrfs_release_path(&path);
> +		return ret;
> +	}
> +
> +	btrfs_release_path(&path);
> +
> +	key.objectid = owner;
> +	key.type = BTRFS_EXTENT_DATA_KEY;
> +	key.offset = 0;
> +
> +	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> +	if (ret < 0) {
> +		btrfs_release_path(&path);
> +		return ret;
> +	}
> +
> +	while (1) {
> +		leaf = path.nodes[0];
> +		slot = path.slots[0];
> +
> +		if (slot >= btrfs_header_nritems(leaf)) {
> +			ret = btrfs_next_leaf(root, &path);
> +			if (ret) {
> +				if (ret > 0)
> +					ret = 0;
> +				break;
> +			}
> +
> +			leaf = path.nodes[0];
> +			slot = path.slots[0];
> +		}
> +
> +		btrfs_item_key_to_cpu(leaf, &found_key, slot);
> +		if ((found_key.objectid != owner) ||
> +			(found_key.type != BTRFS_EXTENT_DATA_KEY))
> +			break;
> +
> +		fi = btrfs_item_ptr(leaf, slot,
> +				struct btrfs_file_extent_item);
> +
> +		backref_offset = found_key.offset -
> +			btrfs_file_extent_offset(leaf, fi);
> +		disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
> +		*bytes_ret = btrfs_file_extent_disk_num_bytes(leaf,
> +								fi);
> +		if ((disk_bytenr == bytenr) &&
> +			(backref_offset == offset)) {
> +			(*refs_ret)++;
> +		}
> +		path.slots[0]++;
> +	}
> +
> +	btrfs_release_path(&path);
> +	return ret;
> +}
> +
>  static int find_possible_backrefs(struct btrfs_fs_info *info,
>  				  struct btrfs_path *path,
>  				  struct cache_tree *extent_cache,
> @@ -7024,9 +7107,9 @@ static int find_possible_backrefs(struct btrfs_fs_info *info,
>  	struct extent_backref *back, *tmp;
>  	struct data_backref *dback;
>  	struct cache_extent *cache;
> -	struct btrfs_file_extent_item *fi;
>  	struct btrfs_key key;
>  	u64 bytenr, bytes;
> +	u64 refs;
>  	int ret;
>  
>  	rbtree_postorder_for_each_entry_safe(back, tmp,
> @@ -7054,24 +7137,15 @@ static int find_possible_backrefs(struct btrfs_fs_info *info,
>  		if (IS_ERR(root))
>  			return PTR_ERR(root);
>  
> -		key.objectid = dback->owner;
> -		key.type = BTRFS_EXTENT_DATA_KEY;
> -		key.offset = dback->offset;
> -		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> -		if (ret) {
> -			btrfs_release_path(path);
> -			if (ret < 0)
> -				return ret;
> -			/* Didn't find it, we can carry on */
> -			ret = 0;
> +		refs = 0;
> +		bytes = 0;
> +		ret = __find_possible_backrefs(root, dback->owner,
> +				dback->offset, rec->start, &refs, &bytes);
> +		if (ret)
>  			continue;
> -		}
>  
> -		fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
> -				    struct btrfs_file_extent_item);
> -		bytenr = btrfs_file_extent_disk_bytenr(path->nodes[0], fi);
> -		bytes = btrfs_file_extent_disk_num_bytes(path->nodes[0], fi);
> -		btrfs_release_path(path);
> +		bytenr = rec->start;
> +
>  		cache = lookup_cache_extent(extent_cache, bytenr, 1);
>  		if (cache) {
>  			struct extent_record *tmp;
> @@ -7090,7 +7164,7 @@ static int find_possible_backrefs(struct btrfs_fs_info *info,
>  				continue;
>  		}
>  
> -		dback->found_ref += 1;
> +		dback->found_ref += refs;
>  		dback->disk_bytenr = bytenr;
>  		dback->bytes = bytes;
>  
> 
