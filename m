Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F70C6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 131BD20824
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:36:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 131BD20824
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbeJZVMz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 17:12:55 -0400
Received: from mout.gmx.net ([212.227.15.15]:37081 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727639AbeJZVMy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 17:12:54 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M9s2y-1gR2tC3hyC-00B1XL; Fri, 26
 Oct 2018 14:35:51 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M9s2y-1gR2tC3hyC-00B1XL; Fri, 26
 Oct 2018 14:35:51 +0200
Subject: Re: [PATCH 2/5] btrfs: Refactor btrfs_can_relocate
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
 <1540554201-11305-3-git-send-email-nborisov@suse.com>
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
Message-ID: <26cc39d7-09ce-7702-0924-9328c8733fec@gmx.com>
Date:   Fri, 26 Oct 2018 20:35:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1540554201-11305-3-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:NadgYreh/vXPAp+4Q4T4L6p1OrB461MkrbJu4fLwxQOP23SkF/1
 RIgpIwJf6Jnpmin29WPRs+O2nSWdMFCaD9hbj9nFssMNkiOzBebzo/oH6uEc+JgI8IPl57q
 aGlJ2yhRt64eNw0D+aBlH1vcIoSbFxMHELjbXyQMkyv8a1eK2T15OCQzfNMpgqcxdsXfFtX
 7VmI3MFzHHGrcVRTuZ62w==
X-UI-Out-Filterresults: notjunk:1;V01:K0:cXYhZ+NzJqg=:eF5FZgfrmUFUSa1gJYYiIC
 dHH+cey6CGgZpGVnHy8qqAvpmHRJnVbzU8RuY4lTj6GvoAqKJ8S6kyGM/655RWpKvbqrC5Ps3
 JI2KBxr1gPWcqbdBC3NVcVGysydUDbUXB3rlYjvlp7v2lrz7XgvSjEylHMmKgeaLk95LKHZXb
 3dxHEJYJ8Y7QYdU6JlT/sC1G7/qf2L7dTAouJ9FB4f8dids1wL9NPAh4NYFQ6kweAbXDvilt6
 jhKL7MYfzm31yGb4XBxjXTQafadZbU2JEdrUqpQh2/Br3+ZnBVFOVjQ0HZcUNqj5Kgy7VNvG2
 CAem5veTFu/b2BsVd45ov3VPFVcAdaggNXjVX42DfWwUkl3qzV63UlXjryfNMAjhxPBQob4lR
 2ZATnE7s9/3lxBF14lcYlEgmJIWoTbCMrUhBeQjM1zGD7dxXeZN3Wt6evpTAWQgAWZSDcjDVd
 yJHpzskbr18ELBHjNnVPp/cDZDXeMIuvi+VVXgCUGDAkDUjK7UAHnj2O2bB7Gf3cSu7zrG+DF
 cvTs3cfpisNHJMWDK1QK5qtCgIqFMm0inXJoW3GIDQ6lJduM1xKZMSsa3QYTymaQDc9vQ7UwV
 Rkn4h5FHAMcfYE19erx+WF6E3tJcvl/bThgww6Xobqw9K6vXPHDbtJ5mW2Czb9YYQn2zV2jZK
 Bwv5rHBJzc8osMNECnJr96f4y+/dXRehF715uZ+BAKPWjFo6UkylhLC3psLZWnsbPTV3WSmnj
 J2Os+cjHsB1aYRP3PiP0hxDnkET+o6Sn6N9ztvvJT/Y54KfTIGJn5KGwfvOizEYiANo7TsnKf
 GE7p1SJUp8zba0djCLTC2rAuEPgAA+b5V/ZGrC+TZJ7wTQod3c=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/26 下午7:43, Nikolay Borisov wrote:
> btrfs_can_relocate returns 0 when it concludes the given chunk can be
> relocated and -1 otherwise. Since this function is used as a predicated
> and it return a binary value it makes no sense to have it's return
> value as an int so change it to bool. Furthermore, remove a stale
> leftover comment from e6ec716f0ddb ("Btrfs: make raid attr array more
> readable").
> 
> Finally make the logic in the list_for_each_entry loop a bit more obvious. Up
> until now the fact that we are returning success (0) was a bit masked by the
> fact that the 0 is re-used from the return value of find_free_dev_extent.
> Instead, now just increment dev_nr if we find a suitable extent and explicitly
> set can_reloc to true if enough devices with unallocated space are present.
> No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/ctree.h       |  2 +-
>  fs/btrfs/extent-tree.c | 39 ++++++++++++++-------------------------
>  fs/btrfs/volumes.c     |  3 +--
>  3 files changed, 16 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 68ca41dbbef3..06edc4f9ceb2 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2680,7 +2680,7 @@ int btrfs_setup_space_cache(struct btrfs_trans_handle *trans,
>  int btrfs_extent_readonly(struct btrfs_fs_info *fs_info, u64 bytenr);
>  int btrfs_free_block_groups(struct btrfs_fs_info *info);
>  int btrfs_read_block_groups(struct btrfs_fs_info *info);
> -int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr);
> +bool btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr);
>  int btrfs_make_block_group(struct btrfs_trans_handle *trans,
>  			   u64 bytes_used, u64 type, u64 chunk_offset,
>  			   u64 size);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a1febf155747..816bca482358 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9423,10 +9423,10 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group_cache *cache)
>  /*
>   * checks to see if its even possible to relocate this block group.
>   *
> - * @return - -1 if it's not a good idea to relocate this block group, 0 if its
> - * ok to go ahead and try.
> + * @return - false if not enough space can be found for relocation, true
> + * otherwise
>   */
> -int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
> +bool btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>  {
>  	struct btrfs_root *root = fs_info->extent_root;
>  	struct btrfs_block_group_cache *block_group;
> @@ -9441,7 +9441,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>  	int debug;
>  	int index;
>  	int full = 0;
> -	int ret = 0;
> +	bool can_reloc = true;
>  
>  	debug = btrfs_test_opt(fs_info, ENOSPC_DEBUG);
>  
> @@ -9453,7 +9453,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>  			btrfs_warn(fs_info,
>  				   "can't find block group for bytenr %llu",
>  				   bytenr);
> -		return -1;
> +		return false;
>  	}
>  
>  	min_free = btrfs_block_group_used(&block_group->item);
> @@ -9489,16 +9489,8 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>  	 * group is going to be restriped, run checks against the target
>  	 * profile instead of the current one.
>  	 */
> -	ret = -1;
> +	can_reloc = false;
>  
> -	/*
> -	 * index:
> -	 *      0: raid10
> -	 *      1: raid1
> -	 *      2: dup
> -	 *      3: raid0
> -	 *      4: single
> -	 */
>  	target = get_restripe_target(fs_info, block_group->flags);
>  	if (target) {
>  		index = btrfs_bg_flags_to_raid_index(extended_to_chunk(target));
> @@ -9534,10 +9526,8 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>  
>  	/* We need to do this so that we can look at pending chunks */
>  	trans = btrfs_join_transaction(root);
> -	if (IS_ERR(trans)) {
> -		ret = PTR_ERR(trans);
> +	if (IS_ERR(trans))
>  		goto out;
> -	}
>  
>  	mutex_lock(&fs_info->chunk_mutex);
>  	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
> @@ -9549,18 +9539,17 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>  		 */
>  		if (device->total_bytes > device->bytes_used + min_free &&
>  		    !test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
> -			ret = find_free_dev_extent(trans, device, min_free,
> -						   &dev_offset, NULL);
> -			if (!ret)
> +			if (!find_free_dev_extent(trans, device, min_free,
> +						   &dev_offset, NULL))
>  				dev_nr++;
>  
> -			if (dev_nr >= dev_min)
> +			if (dev_nr >= dev_min) {
> +				can_reloc = true;
>  				break;
> -
> -			ret = -1;
> +			}
>  		}
>  	}
> -	if (debug && ret == -1)
> +	if (debug && !can_reloc)
>  		btrfs_warn(fs_info,
>  			   "no space to allocate a new chunk for block group %llu",
>  			   block_group->key.objectid);
> @@ -9568,7 +9557,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>  	btrfs_end_transaction(trans);
>  out:
>  	btrfs_put_block_group(block_group);
> -	return ret;
> +	return can_reloc;
>  }
>  
>  static int find_first_block_group(struct btrfs_fs_info *fs_info,
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8b0fd7bf3447..dc53d94a62aa 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2856,8 +2856,7 @@ static int btrfs_relocate_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
>  	 */
>  	lockdep_assert_held(&fs_info->delete_unused_bgs_mutex);
>  
> -	ret = btrfs_can_relocate(fs_info, chunk_offset);
> -	if (ret)
> +	if (!btrfs_can_relocate(fs_info, chunk_offset))
>  		return -ENOSPC;
>  
>  	/* step one, relocate all the extents inside this chunk */
> 
