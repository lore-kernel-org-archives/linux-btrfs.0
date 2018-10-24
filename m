Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CA2C46475
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 03:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19D77206B5
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 03:28:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19D77206B5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbeJXLyO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 07:54:14 -0400
Received: from mout.gmx.net ([212.227.17.22]:34033 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725896AbeJXLyO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 07:54:14 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M9fLX-1gJqG10LaZ-00D12B; Wed, 24
 Oct 2018 02:45:43 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M9fLX-1gJqG10LaZ-00D12B; Wed, 24
 Oct 2018 02:45:43 +0200
Subject: Re: [PATCH 11/13] btrfs-progs: check: Delete file extent item with
 unaligned extent backref
To:     Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc:     Su Yanjun <suyj.fnst@cn.fujitsu.com>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-12-suy.fnst@cn.fujitsu.com>
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
Message-ID: <18e31f91-74ef-1416-8b87-32a108700269@gmx.com>
Date:   Wed, 24 Oct 2018 08:45:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181023094147.7906-12-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:8wVuKvS07DIzxpfCD6u4/A2ChzPhewWtvh3a10MN9heKi0JSgQy
 6fOsTz/W2sLZDGzWPgv1vM9HQkv9j/P3YNFgBNIwBv0CSGb14N3AVHxG+nDKg8XUil7s+mZ
 D6biPq6OiQynIqsMTN/vIq05XM7snBHuHjWAF7wJHin3rvdANzdddXpA7x/VVnQhf+8gSsC
 SWczBkSXtAuqWhJSfopfw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:3BVdR1ikvEs=:qJWMSPHE1SXWcBm/uUjGii
 0QQwNYhjXN0pEDQDbmwVy5CS1wxYCTyuVO6OOQ2k1Etw7flG/fHrmQgiXxpXbrNwWctiHKYw1
 A+W4YnURVHWtCNwNv6WPDPcF6oFEAutyw5Pj++JbALLozICZzPDHnvC13iSAcn5o6niCr6F+S
 DY4e8Mlecg/SsqLVaXTpiIuQjXB7TowuHDxmtMXOIyQlffgYZjUAflbw+tWkv1vX1fojAY2QG
 /z/5K5fCdxwFVKlcvcm0nT5jvesVfWV0OOu1huGa1G9kcbZYKnUXjjOJ2K1eZ4IwUDmK7eVWo
 HFh530anmRSKSxucc4PHuul6MJkUSzGM6xkul8EmkkwfAZ/nXcZcVaAq8FnIsms6ouU3689l6
 BkbW8oqDko3uEnZjU3xrx90ZcZeT2qfNHA0em7T4vLUQUaAzwo6cgx5qfwwhbYTFUXHBQiG0B
 zmFozoyF0XJnN819YpXeGR6laySYghhJHMBnjMOJCoMf0iyhVeDaQPVcDVNSCyne6sl3TfLSh
 WB2hIYe3bpg//6R7GVlDHX13URYVBYoL9VjqMz6MY3qaD3kiRruwaFiVrPBYP3WPPwvood8CL
 x4GYhnimugSvAa6R5snnffyyGT6F+YXVnw+P78qL2pMVtRkeDXCYRAXef4IfcLPFvN2HPSS5o
 SOXUaVPHjT/+XRNdxJAB+THToRAxM7MxIl3Tcdtu2pRmXA9zv7SN+cQY7BXOFB1PXgZX7G6+B
 sLpWd/RXC7ptsfpMDKkFQHLMeT5yIZTNBqKviKWYb5Lhn832GGnc9a/MAiDQiZ89loFOPbkOF
 WWmla/3hCQkd0BkLskPuC8aabt2kOxx8QIReadubEvYMsc+epA=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/23 下午5:41, Su Yue wrote:
> From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> 
> In original mode, if some file extent item has unaligned extent backref,
> fixup_extent_refs can't repair it. This patch will check extent alignment
> then delete file extent with unaligned extent backref.

This looks a little strange to me.

You mean, an unaligned FILE EXTENT has an unaligned EXTENT_ITEM?

Then why not just delete the EXTENT_ITEM directly? No need to go back
checking if it has a corresponding EXTENT_DATA since unaligned one is
definitely corrupted.

For corrupted EXTENT_DATA, it should get deleted when we check fs tree.

This would save you a lot of codes.

Thanks,
Qu

> 
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> ---
>  check/main.c          | 278 +++++++++++++++++++++++++++++++++++++++++-
>  check/mode-original.h |  13 ++
>  ctree.h               |   2 +
>  disk-io.c             |   1 +
>  4 files changed, 293 insertions(+), 1 deletion(-)
> 
> diff --git a/check/main.c b/check/main.c
> index 90d9fd570287..b5e68b3241e5 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -460,6 +460,8 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
>  	struct inode_backref *backref;
>  	struct inode_backref *orig;
>  	struct inode_backref *tmp;
> +	struct unaligned_extent_rec_t *src;
> +	struct unaligned_extent_rec_t *dst;
>  	struct rb_node *rb;
>  	size_t size;
>  	int ret;
> @@ -470,6 +472,7 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
>  	memcpy(rec, orig_rec, sizeof(*rec));
>  	rec->refs = 1;
>  	INIT_LIST_HEAD(&rec->backrefs);
> +	INIT_LIST_HEAD(&rec->unaligned_extent_recs);
>  	rec->holes = RB_ROOT;
>  
>  	list_for_each_entry(orig, &orig_rec->backrefs, list) {
> @@ -483,6 +486,17 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
>  		list_add_tail(&backref->list, &rec->backrefs);
>  	}
>  
> +	list_for_each_entry(src, &orig_rec->unaligned_extent_recs, list) {
> +		size = sizeof(*src);
> +		dst = malloc(size);
> +		if (!dst) {
> +			ret = -ENOMEM;
> +			goto cleanup;
> +		}
> +		memcpy(dst, src, size);
> +		list_add_tail(&dst->list, &rec->unaligned_extent_recs);
> +	}
> +
>  	ret = copy_file_extent_holes(&rec->holes, &orig_rec->holes);
>  	if (ret < 0)
>  		goto cleanup_rb;
> @@ -506,6 +520,13 @@ cleanup:
>  			free(orig);
>  		}
>  
> +	if (!list_empty(&rec->unaligned_extent_recs))
> +		list_for_each_entry_safe(src, dst, &rec->unaligned_extent_recs,
> +				list) {
> +			list_del(&src->list);
> +			free(src);
> +		}
> +
>  	free(rec);
>  
>  	return ERR_PTR(ret);
> @@ -643,6 +664,7 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
>  		rec->extent_start = (u64)-1;
>  		rec->refs = 1;
>  		INIT_LIST_HEAD(&rec->backrefs);
> +		INIT_LIST_HEAD(&rec->unaligned_extent_recs);
>  		rec->holes = RB_ROOT;
>  
>  		node = malloc(sizeof(*node));
> @@ -664,6 +686,18 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
>  	return rec;
>  }
>  
> +static void free_unaligned_extent_recs(struct list_head *unaligned_extent_recs)
> +{
> +	struct unaligned_extent_rec_t *urec;
> +
> +	while (!list_empty(unaligned_extent_recs)) {
> +		urec = list_entry(unaligned_extent_recs->next,
> +				struct unaligned_extent_rec_t, list);
> +		list_del(&urec->list);
> +		free(urec);
> +	}
> +}
> +
>  static void free_inode_rec(struct inode_record *rec)
>  {
>  	struct inode_backref *backref;
> @@ -676,6 +710,7 @@ static void free_inode_rec(struct inode_record *rec)
>  		list_del(&backref->list);
>  		free(backref);
>  	}
> +	free_unaligned_extent_recs(&rec->unaligned_extent_recs);
>  	free_file_extent_holes(&rec->holes);
>  	free(rec);
>  }
> @@ -2474,18 +2509,154 @@ out:
>  	return ret;
>  }
>  
> +static int btrfs_delete_item(struct btrfs_trans_handle *trans,
> +		struct btrfs_root *root, struct btrfs_key *key)
> +{
> +	struct btrfs_path path;
> +	int ret = 0;
> +
> +	btrfs_init_path(&path);
> +
> +	ret = btrfs_search_slot(trans, root, key, &path, -1, 1);
> +	if (ret) {
> +		if (ret > 0)
> +			ret = -ENOENT;
> +
> +		btrfs_release_path(&path);
> +		return ret;
> +	}
> +
> +	ret = btrfs_del_item(trans, root, &path);
> +
> +	btrfs_release_path(&path);
> +	return ret;
> +}
> +
> +static int find_file_extent_offset_by_bytenr(struct btrfs_root *root,
> +		u64 owner, u64 bytenr, u64 *offset_ret)
> +{
> +	int ret = 0;
> +	struct btrfs_path path;
> +	struct btrfs_key key;
> +	struct btrfs_key found_key;
> +	struct btrfs_file_extent_item *fi;
> +	struct extent_buffer *leaf;
> +	u64 disk_bytenr;
> +	int slot;
> +
> +	btrfs_init_path(&path);
> +
> +	key.objectid = owner;
> +	key.type = BTRFS_INODE_ITEM_KEY;
> +	key.offset = 0;
> +
> +	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> +	if (ret) {
> +		if (ret > 0)
> +			ret = -ENOENT;
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
> +		disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
> +		if (disk_bytenr == bytenr) {
> +			*offset_ret = found_key.offset;
> +			ret = 0;
> +			break;
> +		}
> +		path.slots[0]++;
> +	}
> +
> +	btrfs_release_path(&path);
> +	return ret;
> +}
> +
> +static int repair_unaligned_extent_recs(struct btrfs_trans_handle *trans,
> +				struct btrfs_root *root,
> +				struct btrfs_path *path,
> +				struct inode_record *rec)
> +{
> +	int ret = 0;
> +	struct btrfs_key key;
> +	struct unaligned_extent_rec_t *urec;
> +	struct unaligned_extent_rec_t *tmp;
> +
> +	list_for_each_entry_safe(urec, tmp, &rec->unaligned_extent_recs, list) {
> +
> +		key.objectid = urec->owner;
> +		key.type = BTRFS_EXTENT_DATA_KEY;
> +		key.offset = urec->offset;
> +		fprintf(stderr, "delete file extent item [%llu,%llu]\n",
> +					urec->owner, urec->offset);
> +		ret = btrfs_delete_item(trans, root, &key);
> +		if (ret)
> +			return ret;
> +
> +		list_del(&urec->list);
> +		free(urec);
> +	}
> +	rec->errors &= ~I_ERR_UNALIGNED_EXTENT_REC;
> +
> +	return ret;
> +}
> +
>  static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
>  {
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_path path;
>  	int ret = 0;
>  
> +	/*
> +	 * unaligned extent recs always lead to csum missing error, clean it
> +	 */
> +	if ((rec->errors & I_ERR_SOME_CSUM_MISSING) &&
> +			(rec->errors & I_ERR_UNALIGNED_EXTENT_REC))
> +		rec->errors &= ~I_ERR_SOME_CSUM_MISSING;
> +
> +
>  	if (!(rec->errors & (I_ERR_DIR_ISIZE_WRONG |
>  			     I_ERR_NO_ORPHAN_ITEM |
>  			     I_ERR_LINK_COUNT_WRONG |
>  			     I_ERR_NO_INODE_ITEM |
>  			     I_ERR_FILE_EXTENT_DISCOUNT |
>  			     I_ERR_FILE_NBYTES_WRONG |
> +			     I_ERR_UNALIGNED_EXTENT_REC |
>  			     I_ERR_INLINE_RAM_BYTES_WRONG)))
>  		return rec->errors;
>  
> @@ -2515,6 +2686,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
>  		ret = repair_inode_nbytes(trans, root, &path, rec);
>  	if (!ret && rec->errors & I_ERR_INLINE_RAM_BYTES_WRONG)
>  		ret = repair_inline_ram_bytes(trans, root, &path, rec);
> +	if (!ret && rec->errors & I_ERR_UNALIGNED_EXTENT_REC)
> +		ret = repair_unaligned_extent_recs(trans, root, &path, rec);
>  	btrfs_commit_transaction(trans, root);
>  	btrfs_release_path(&path);
>  	return ret;
> @@ -3128,6 +3301,8 @@ static int check_fs_root(struct btrfs_root *root,
>  	struct cache_tree corrupt_blocks;
>  	enum btrfs_tree_block_status status;
>  	struct node_refs nrefs;
> +	struct unaligned_extent_rec_t *urec;
> +	struct unaligned_extent_rec_t *tmp;
>  
>  	/*
>  	 * Reuse the corrupt_block cache tree to record corrupted tree block
> @@ -3151,6 +3326,30 @@ static int check_fs_root(struct btrfs_root *root,
>  	cache_tree_init(&root_node.inode_cache);
>  	memset(&nrefs, 0, sizeof(nrefs));
>  
> +	/*
> +	 * Mode unaligned extent recs to corresponding inode record
> +	 */
> +	list_for_each_entry_safe(urec, tmp,
> +			&root->unaligned_extent_recs, list) {
> +		struct inode_record *inode;
> +
> +		inode = get_inode_rec(&root_node.inode_cache, urec->owner, 1);
> +
> +		if (IS_ERR_OR_NULL(inode)) {
> +			fprintf(stderr,
> +				"fail to get inode rec on [%llu,%llu]\n",
> +				urec->objectid, urec->owner);
> +
> +			list_del(&urec->list);
> +			free(urec);
> +
> +			continue;
> +		}
> +
> +		inode->errors |= I_ERR_UNALIGNED_EXTENT_REC;
> +		list_move(&urec->list, &inode->unaligned_extent_recs);
> +	}
> +
>  	level = btrfs_header_level(root->node);
>  	memset(wc->nodes, 0, sizeof(wc->nodes));
>  	wc->nodes[level] = &root_node;
> @@ -7425,6 +7624,68 @@ static int prune_corrupt_blocks(struct btrfs_fs_info *info)
>  	return 0;
>  }
>  
> +static int record_unaligned_extent_rec(struct btrfs_fs_info *fs_info,
> +					struct extent_record *rec)
> +{
> +
> +	struct extent_backref *back, *tmp;
> +	struct data_backref *dback;
> +	struct btrfs_root *dest_root;
> +	struct btrfs_key key;
> +	struct unaligned_extent_rec_t *urec;
> +	LIST_HEAD(entries);
> +	int ret = 0;
> +
> +	fprintf(stderr, "record unaligned extent record on %llu %llu\n",
> +			rec->start, rec->nr);
> +
> +	/*
> +	 * Metadata is easy and the backrefs should always agree on bytenr and
> +	 * size, if not we've got bigger issues.
> +	 */
> +	if (rec->metadata)
> +		return 0;
> +
> +	rbtree_postorder_for_each_entry_safe(back, tmp,
> +					     &rec->backref_tree, node) {
> +		if (back->full_backref || !back->is_data)
> +			continue;
> +
> +		dback = to_data_backref(back);
> +
> +		key.objectid = dback->root;
> +		key.type = BTRFS_ROOT_ITEM_KEY;
> +		key.offset = (u64)-1;
> +
> +		dest_root = btrfs_read_fs_root(fs_info, &key);
> +
> +		/*
> +		 * For non-exist root we just skip it
> +		 */
> +		if (IS_ERR_OR_NULL(dest_root))
> +			continue;
> +
> +		urec = malloc(sizeof(struct unaligned_extent_rec_t));
> +		if (!urec)
> +			return -ENOMEM;
> +
> +		INIT_LIST_HEAD(&urec->list);
> +		urec->objectid = dest_root->objectid;
> +		urec->owner = dback->owner;
> +		urec->offset = 0;
> +		urec->bytenr = rec->start;
> +		ret = find_file_extent_offset_by_bytenr(dest_root,
> +				dback->owner, rec->start, &urec->offset);
> +		if (ret) {
> +			free(urec);
> +			return ret;
> +		}
> +		list_add(&urec->list, &dest_root->unaligned_extent_recs);
> +	}
> +
> +	return ret;
> +}
> +
>  static int check_extent_refs(struct btrfs_root *root,
>  			     struct cache_tree *extent_cache)
>  {
> @@ -7522,6 +7783,21 @@ static int check_extent_refs(struct btrfs_root *root,
>  			fix = 1;
>  			cur_err = 1;
>  		}
> +
> +		if (!IS_ALIGNED(rec->start, root->fs_info->sectorsize)) {
> +			fprintf(stderr, "unaligned extent rec on [%llu %llu]\n",
> +				(unsigned long long)rec->start,
> +				(unsigned long long)rec->nr);
> +			ret = record_unaligned_extent_rec(root->fs_info, rec);
> +			if (ret)
> +				goto repair_abort;
> +
> +			/*
> +			 * free extent record
> +			 */
> +			goto next;
> +		}
> +
>  		if (all_backpointers_checked(rec, 1)) {
>  			fprintf(stderr, "backpointer mismatch on [%llu %llu]\n",
>  				(unsigned long long)rec->start,
> @@ -7574,7 +7850,7 @@ static int check_extent_refs(struct btrfs_root *root,
>  				rec->start, rec->start + rec->max_size);
>  			cur_err = 1;
>  		}
> -
> +next:
>  		err = cur_err;
>  		remove_cache_extent(extent_cache, cache);
>  		free_all_extent_backrefs(rec);
> diff --git a/check/mode-original.h b/check/mode-original.h
> index ed995931fcd5..b23594863199 100644
> --- a/check/mode-original.h
> +++ b/check/mode-original.h
> @@ -155,6 +155,16 @@ struct file_extent_hole {
>  	u64 len;
>  };
>  
> +struct unaligned_extent_rec_t {
> +	struct list_head list;
> +
> +	u64 objectid;
> +	u64 owner;
> +	u64 offset;
> +
> +	u64 bytenr;
> +};
> +
>  #define I_ERR_NO_INODE_ITEM		(1 << 0)
>  #define I_ERR_NO_ORPHAN_ITEM		(1 << 1)
>  #define I_ERR_DUP_INODE_ITEM		(1 << 2)
> @@ -169,6 +179,7 @@ struct file_extent_hole {
>  #define I_ERR_ODD_CSUM_ITEM		(1 << 11)
>  #define I_ERR_SOME_CSUM_MISSING		(1 << 12)
>  #define I_ERR_LINK_COUNT_WRONG		(1 << 13)
> +#define I_ERR_UNALIGNED_EXTENT_REC	(1 << 14)
>  #define I_ERR_FILE_EXTENT_TOO_LARGE	(1 << 15)
>  #define I_ERR_ODD_INODE_FLAGS		(1 << 16)
>  #define I_ERR_INLINE_RAM_BYTES_WRONG	(1 << 17)
> @@ -185,6 +196,8 @@ struct inode_record {
>  	unsigned int nodatasum:1;
>  	int errors;
>  
> +	struct list_head unaligned_extent_recs;
> +
>  	u64 ino;
>  	u32 nlink;
>  	u32 imode;
> diff --git a/ctree.h b/ctree.h
> index 2e0896390434..d0f441587f9f 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -1177,6 +1177,8 @@ struct btrfs_root {
>  	u32 type;
>  	u64 last_inode_alloc;
>  
> +	struct list_head unaligned_extent_recs;
> +
>  	/* the dirty list is only used by non-reference counted roots */
>  	struct list_head dirty_list;
>  	struct rb_node rb_node;
> diff --git a/disk-io.c b/disk-io.c
> index 992f4b870e9f..0dfd51ed87bf 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -480,6 +480,7 @@ void btrfs_setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
>  	root->last_inode_alloc = 0;
>  
>  	INIT_LIST_HEAD(&root->dirty_list);
> +	INIT_LIST_HEAD(&root->unaligned_extent_recs);
>  	memset(&root->root_key, 0, sizeof(root->root_key));
>  	memset(&root->root_item, 0, sizeof(root->root_item));
>  	root->root_key.objectid = objectid;
> 
