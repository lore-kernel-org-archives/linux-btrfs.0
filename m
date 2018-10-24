Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D074C46475
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 02:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2ABA2082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 02:57:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2ABA2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbeJXLX1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 07:23:27 -0400
Received: from mout.gmx.net ([212.227.17.20]:58435 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbeJXLX1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 07:23:27 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MVvDo-1g8WCm2NHE-00X5IG; Wed, 24
 Oct 2018 02:15:29 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MVvDo-1g8WCm2NHE-00X5IG; Wed, 24
 Oct 2018 02:15:29 +0200
Subject: Re: [PATCH 06/13] btrfs-progs: lowmem: rename
 delete_extent_tree_item() to delete_item()
To:     Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-7-suy.fnst@cn.fujitsu.com>
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
Message-ID: <4ce4613b-c1ac-24db-e916-996e012e7e86@gmx.com>
Date:   Wed, 24 Oct 2018 08:15:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181023094147.7906-7-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:uSkhqosW+6/8xt5Nmo3S5aJUBAOu8qMZxhCiaiFjI0QyIWbIQwz
 axwDzbYM9ja29f+QpZc3wPRjJuwjtRO/d2BEnG87qmeZzwNmBKHwhbrB7GZMILre6NLbzzi
 PI243ldAl6hrgIaJ14/VsT5cL0BplLzhOB2FPhSWwyO1nllBlU3hUawy0awjyJYV9C0/XSb
 yX5WCix8k1rZeYx/0cc6w==
X-UI-Out-Filterresults: notjunk:1;V01:K0:ckZd7XwLgmg=:m3Ldb6ByRXPHLSHsbV6aS9
 Wjjk6n3GOhxkmFksfcQsEBF395hMhLfmr7N8ZDZAdkKl691DNoXR47S4K89UTIG+D6qILRqPv
 bgs0K0JffwS9pA9tG9OmjPKH45u/D/SIA6qayNj0YtOFufCZt+VSp9SUtC+wQpMTvmBnNIoT2
 xanUWSKSrm0RsiOyrUvRwiimLxMFItvwXx2JcH2G8XkdK0hc1ApORuX9iGxZHWrunVe16Bebf
 9eU71C+ro2AuTd/UdNMqM+0IA9RN+Ihmk0M+vqiXMvfehlGmD4sp3t0WZlQSEI2xoCBJHlZeX
 71JUnynHTsOh3Cs7PcgXpt/UK3li9QaezrLIfCz8fpQOPnfG0YGA/d/9jqvughnCZ5ULik22v
 JhID2qREE6/dLr6Ndiclvz4rfqeg/HAVQuX6d5qDy6hmyxNXjTuCh54McppxMWSNglS9+QI2S
 Eb//rPWgAuEcREJGGBVIcgDiZBm0AMoBqBWXiewK1jZTPrvDvZQoy/T1/vrnyMg2eX4ufvRjQ
 aRhgIjupSSNK3xkhus16TeWZxSJHTMF70/4VnWrpJhlMeHZsPWTBzURXRGZLHKrQCWy7eSIWi
 9rSnfDCGHhlfT4Vt4N/V5zb7siwOCvs9wyuZCQMZfrEpezR+WHH4LlkRKURf9WK+akABsf6ck
 1QqE9oNShFwlePvWH1E3Chvu/euj/v01AOzfHP70duTGl2HCQuJnhKboG488iN50HYANcPfUQ
 Yk6GDe66YJ2jkQBGxCJTuScBTPOCQkJtA5zDHA6NHh2KQtsuWcWMDG9Bn5k1tIRLzxVX9RCA6
 RG5wo0JXY2XFyqL1XMfUI1ASYgOr9LCz7R8lhZY5MrpK5qP86o=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/23 下午5:41, Su Yue wrote:
> The function can delete items in trees besides extent tree.
> Rename and move it for further use.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

> ---
>  check/mode-lowmem.c | 99 +++++++++++++++++++++++----------------------
>  1 file changed, 51 insertions(+), 48 deletions(-)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index e8a2e825c0f3..3c9ecff7e498 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -537,6 +537,52 @@ static int end_avoid_extents_overwrite(struct btrfs_fs_info *fs_info)
>  	return ret;
>  }
>  
> +/*
> + * Delete the item @path point to.

Although I'd prefer to add some more words about the fact it's a wrapper
for btrfs_del_item().

Thanks,
Qu

> + * If deleted, path will point to the previous item to the deleted item.
> + */
> +static int delete_item(struct btrfs_root *root, struct btrfs_path *path)
> +{
> +	struct btrfs_key key;
> +	struct btrfs_trans_handle *trans;
> +	int ret = 0;
> +
> +	ret = avoid_extents_overwrite(root->fs_info);
> +	if (ret)
> +		return ret;
> +	trans = btrfs_start_transaction(root, 1);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		error("fail to start transaction %s", strerror(-ret));
> +		goto out;
> +	}
> +	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
> +	btrfs_release_path(path);
> +	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
> +	if (ret) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	ret = btrfs_del_item(trans, root, path);
> +	if (ret)
> +		goto out;
> +
> +	if (path->slots[0] == 0)
> +		btrfs_prev_leaf(root, path);
> +	else
> +		path->slots[0]--;
> +out:
> +	btrfs_commit_transaction(trans, root);
> +	if (ret)
> +		error("failed to delete root %llu item[%llu, %u, %llu]",
> +		      root->objectid, key.objectid, key.type, key.offset);
> +	else
> +		printf("Deleted root %llu item[%llu, %u, %llu]\n",
> +		       root->objectid, key.objectid, key.type, key.offset);
> +	return ret;
> +}
> +
>  /*
>   * Wrapper function for btrfs_fix_block_accounting().
>   *
> @@ -4335,49 +4381,6 @@ static int repair_chunk_item(struct btrfs_root *chunk_root,
>  	return err;
>  }
>  
> -static int delete_extent_tree_item(struct btrfs_root *root,
> -				   struct btrfs_path *path)
> -{
> -	struct btrfs_key key;
> -	struct btrfs_trans_handle *trans;
> -	int ret = 0;
> -
> -	ret = avoid_extents_overwrite(root->fs_info);
> -	if (ret)
> -		return ret;
> -	trans = btrfs_start_transaction(root, 1);
> -	if (IS_ERR(trans)) {
> -		ret = PTR_ERR(trans);
> -		error("fail to start transaction %s", strerror(-ret));
> -		goto out;
> -	}
> -	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
> -	btrfs_release_path(path);
> -	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
> -	if (ret) {
> -		ret = -ENOENT;
> -		goto out;
> -	}
> -
> -	ret = btrfs_del_item(trans, root, path);
> -	if (ret)
> -		goto out;
> -
> -	if (path->slots[0] == 0)
> -		btrfs_prev_leaf(root, path);
> -	else
> -		path->slots[0]--;
> -out:
> -	btrfs_commit_transaction(trans, root);
> -	if (ret)
> -		error("failed to delete root %llu item[%llu, %u, %llu]",
> -		      root->objectid, key.objectid, key.type, key.offset);
> -	else
> -		printf("Deleted root %llu item[%llu, %u, %llu]\n",
> -		       root->objectid, key.objectid, key.type, key.offset);
> -	return ret;
> -}
> -
>  /*
>   * Main entry function to check known items and update related accounting info
>   */
> @@ -4419,7 +4422,7 @@ again:
>  		ret = check_block_group_item(fs_info, eb, slot);
>  		if (repair &&
>  		    ret & REFERENCER_MISSING)
> -			ret = delete_extent_tree_item(root, path);
> +			ret = delete_item(root, path);
>  		err |= ret;
>  		break;
>  	case BTRFS_DEV_ITEM_KEY:
> @@ -4450,7 +4453,7 @@ again:
>  					       key.objectid, -1);
>  		if (repair &&
>  		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
> -			ret = delete_extent_tree_item(root, path);
> +			ret = delete_item(root, path);
>  		err |= ret;
>  		break;
>  	case BTRFS_EXTENT_DATA_REF_KEY:
> @@ -4463,7 +4466,7 @@ again:
>  				btrfs_extent_data_ref_count(eb, dref));
>  		if (repair &&
>  		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
> -			ret = delete_extent_tree_item(root, path);
> +			ret = delete_item(root, path);
>  		err |= ret;
>  		break;
>  	case BTRFS_SHARED_BLOCK_REF_KEY:
> @@ -4471,7 +4474,7 @@ again:
>  						 key.objectid, -1);
>  		if (repair &&
>  		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
> -			ret = delete_extent_tree_item(root, path);
> +			ret = delete_item(root, path);
>  		err |= ret;
>  		break;
>  	case BTRFS_SHARED_DATA_REF_KEY:
> @@ -4479,7 +4482,7 @@ again:
>  						key.objectid);
>  		if (repair &&
>  		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
> -			ret = delete_extent_tree_item(root, path);
> +			ret = delete_item(root, path);
>  		err |= ret;
>  		break;
>  	default:
> 
