Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B59DFC46475
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 03:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 692F52075D
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 03:10:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 692F52075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbeJXLg4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 07:36:56 -0400
Received: from mout.gmx.net ([212.227.17.21]:39615 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbeJXLgz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 07:36:55 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MF9WR-1gPEJG0GWx-00GIcF; Wed, 24
 Oct 2018 02:28:18 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MF9WR-1gPEJG0GWx-00GIcF; Wed, 24
 Oct 2018 02:28:18 +0200
Subject: Re: [PATCH 08/13] btrfs-progs: Revert "btrfs-progs: Add repair and
 report function for orphan file extent."
To:     Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Cc:     Su Yanjun <suyj.fnst@cn.fujitsu.com>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-9-suy.fnst@cn.fujitsu.com>
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
Message-ID: <83c8ff64-1536-944a-71c4-f91706ef6ebf@gmx.com>
Date:   Wed, 24 Oct 2018 08:28:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181023094147.7906-9-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:75Eg4S4wyH1te/moDlxn00v2y63mpAHqHPMeCSpJTRibt5m48/P
 wMVEMyO5YpGM7n8ZoL2M7TJaSh8IvPe9lUf2rHCdMmC0fpPgH9ojNODKnVvncP0jlv9+l+0
 7Gf7Bu4MW7q6HDL7XvamsVvKAQfS1DDlgYTr/1H4/TX5d7CqWa1YxGBtYLbZbqjOAkJexVO
 CaSV7c8HyQxuEErpdbHsQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:/ldqPnVWTas=:BtDhDgqIP0OeVHSoEQDGrq
 OrKZnXF/SYhUMz06I1o4ox7XO/wjhvv1PLWhOedfpNF5wYtbAvaTqnZa8ruvAACkAHlt+k0/L
 ZQxAjeysbOVGmx20X+ehqQFUjPvq0r7uGk9vSvNkZ4BsjH4qnQ7L4KXfvmZheNeA7qb2J57fy
 nTizTqUy/gQyX3wvM9jJoXKdM9pFfmQ66Nns8b+36mABo0DqVcGNpNpeXwkQVdmOTZqSJGc6Q
 WTkzxryqCGXDDV6rKgmcYO72G8w7YNPX8l8RutYUxGL2Rhi0IicF0q/6sR///3QGr9cF4OaHK
 vhGGu/B/9MmRmeUEBbCVM2GBL0xA9L6+iMQn3uLaIDpGsLeFEnwD706wNn48Iig3apJ3JgcBd
 GwfldPdbugS5x86/mTFztcei5nXtdmYHz/xyDVRGublQrGL3RisUo2c/wIckEcF/3rf2H001d
 PNnslqqkmxLKFOOFOxiN/wi0CeBMSlVcni6UGmb5HYHMuO3SYtDHhmOxGOPpbAbPullwr+66U
 FJ0ETlkZ3OzlkcQg4Sn9vXriGdTECiVoa7+bMzfIGHHueOzfxB3NwcsJLUGJFraOwjidQv2kh
 ATS7zoCMgMaTiHwFiL3SfBIDBNioHlPb/aZC7vUbKpfbtRZhQPWJrah22v9xUccRLw467hsu+
 KbGhlC9gv94Q3XjNJDc/VXv4y+2iLbBF2LncJTLiFB6XcLH9+7vvS0WD64/o2g4SBfEOl+Mlc
 vIz5+36RfYOTom6NoivDWJkUH2fpIl9fgE7HPXOwhRoh3KCAKAclQXjOGryDzTEau/PXiAea+
 OvIIjO0EOVkkLf77P6st6BtXSFD2RjSnc0OK4jjA08DxqPz61k=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/23 下午5:41, Su Yue wrote:
> From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> 
> The reason for revert is that according to the existing situation, the
> probability of problem in the extent tree is higher than in the fs tree.

In fact we should find a place to address the priority when we
check/repair fs trees.

My initial priorities are:

1) Vital trees:
   Chunk, root

2) Data trees
   Fs, file trees

3) Supporting trees
   Extent, csum,

4) Ready to die trees.
   UUID, reloc, log

In that priority, if we found something mismatch in fs and extent tree,
we should trust fs instead of extent tree.


Any good idea on where to place such principle, David?



> So this feature should be removed.
> 
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>

Looks good to me, although the commit message needs extra explanation.

An example is needed to validate the revert.

Thanks,
Qu

> ---
>  check/main.c | 103 +--------------------------------------------------
>  1 file changed, 1 insertion(+), 102 deletions(-)
> 
> diff --git a/check/main.c b/check/main.c
> index 9c0e75c19ebc..268de5dd5f26 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -460,8 +460,6 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
>  	struct inode_backref *backref;
>  	struct inode_backref *orig;
>  	struct inode_backref *tmp;
> -	struct orphan_data_extent *src_orphan;
> -	struct orphan_data_extent *dst_orphan;
>  	struct rb_node *rb;
>  	size_t size;
>  	int ret;
> @@ -472,7 +470,6 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
>  	memcpy(rec, orig_rec, sizeof(*rec));
>  	rec->refs = 1;
>  	INIT_LIST_HEAD(&rec->backrefs);
> -	INIT_LIST_HEAD(&rec->orphan_extents);
>  	rec->holes = RB_ROOT;
>  
>  	list_for_each_entry(orig, &orig_rec->backrefs, list) {
> @@ -485,15 +482,7 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
>  		memcpy(backref, orig, size);
>  		list_add_tail(&backref->list, &rec->backrefs);
>  	}
> -	list_for_each_entry(src_orphan, &orig_rec->orphan_extents, list) {
> -		dst_orphan = malloc(sizeof(*dst_orphan));
> -		if (!dst_orphan) {
> -			ret = -ENOMEM;
> -			goto cleanup;
> -		}
> -		memcpy(dst_orphan, src_orphan, sizeof(*src_orphan));
> -		list_add_tail(&dst_orphan->list, &rec->orphan_extents);
> -	}
> +
>  	ret = copy_file_extent_holes(&rec->holes, &orig_rec->holes);
>  	if (ret < 0)
>  		goto cleanup_rb;
> @@ -517,12 +506,6 @@ cleanup:
>  			free(orig);
>  		}
>  
> -	if (!list_empty(&rec->orphan_extents))
> -		list_for_each_entry_safe(orig, tmp, &rec->orphan_extents, list) {
> -			list_del(&orig->list);
> -			free(orig);
> -		}
> -
>  	free(rec);
>  
>  	return ERR_PTR(ret);
> @@ -590,8 +573,6 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
>  		fprintf(stderr, ", some csum missing");
>  	if (errors & I_ERR_LINK_COUNT_WRONG)
>  		fprintf(stderr, ", link count wrong");
> -	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
> -		fprintf(stderr, ", orphan file extent");
>  	if (errors & I_ERR_ODD_INODE_FLAGS)
>  		fprintf(stderr, ", odd inode flags");
>  	if (errors & I_ERR_INLINE_RAM_BYTES_WRONG)
> @@ -681,7 +662,6 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
>  		rec->extent_start = (u64)-1;
>  		rec->refs = 1;
>  		INIT_LIST_HEAD(&rec->backrefs);
> -		INIT_LIST_HEAD(&rec->orphan_extents);
>  		rec->holes = RB_ROOT;
>  
>  		node = malloc(sizeof(*node));
> @@ -2420,9 +2400,6 @@ static int repair_inode_no_item(struct btrfs_trans_handle *trans,
>  		} else if (rec->found_dir_item) {
>  			type_recovered = 1;
>  			filetype = BTRFS_FT_DIR;
> -		} else if (!list_empty(&rec->orphan_extents)) {
> -			type_recovered = 1;
> -			filetype = BTRFS_FT_REG_FILE;
>  		} else{
>  			printf("Can't determine the filetype for inode %llu, assume it is a normal file\n",
>  			       rec->ino);
> @@ -2453,67 +2430,6 @@ out:
>  	return ret;
>  }
>  
> -static int repair_inode_orphan_extent(struct btrfs_trans_handle *trans,
> -				      struct btrfs_root *root,
> -				      struct btrfs_path *path,
> -				      struct inode_record *rec)
> -{
> -	struct orphan_data_extent *orphan;
> -	struct orphan_data_extent *tmp;
> -	int ret = 0;
> -
> -	list_for_each_entry_safe(orphan, tmp, &rec->orphan_extents, list) {
> -		/*
> -		 * Check for conflicting file extents
> -		 *
> -		 * Here we don't know whether the extents is compressed or not,
> -		 * so we can only assume it not compressed nor data offset,
> -		 * and use its disk_len as extent length.
> -		 */
> -		ret = btrfs_get_extent(NULL, root, path, orphan->objectid,
> -				       orphan->offset, orphan->disk_len, 0);
> -		btrfs_release_path(path);
> -		if (ret < 0)
> -			goto out;
> -		if (!ret) {
> -			fprintf(stderr,
> -				"orphan extent (%llu, %llu) conflicts, delete the orphan\n",
> -				orphan->disk_bytenr, orphan->disk_len);
> -			ret = btrfs_free_extent(trans,
> -					root->fs_info->extent_root,
> -					orphan->disk_bytenr, orphan->disk_len,
> -					0, root->objectid, orphan->objectid,
> -					orphan->offset);
> -			if (ret < 0)
> -				goto out;
> -		}
> -		ret = btrfs_insert_file_extent(trans, root, orphan->objectid,
> -				orphan->offset, orphan->disk_bytenr,
> -				orphan->disk_len, orphan->disk_len);
> -		if (ret < 0)
> -			goto out;
> -
> -		/* Update file size info */
> -		rec->found_size += orphan->disk_len;
> -		if (rec->found_size == rec->nbytes)
> -			rec->errors &= ~I_ERR_FILE_NBYTES_WRONG;
> -
> -		/* Update the file extent hole info too */
> -		ret = del_file_extent_hole(&rec->holes, orphan->offset,
> -					   orphan->disk_len);
> -		if (ret < 0)
> -			goto out;
> -		if (RB_EMPTY_ROOT(&rec->holes))
> -			rec->errors &= ~I_ERR_FILE_EXTENT_DISCOUNT;
> -
> -		list_del(&orphan->list);
> -		free(orphan);
> -	}
> -	rec->errors &= ~I_ERR_FILE_EXTENT_ORPHAN;
> -out:
> -	return ret;
> -}
> -
>  static int repair_inode_discount_extent(struct btrfs_trans_handle *trans,
>  					struct btrfs_root *root,
>  					struct btrfs_path *path,
> @@ -2600,7 +2516,6 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
>  			     I_ERR_NO_ORPHAN_ITEM |
>  			     I_ERR_LINK_COUNT_WRONG |
>  			     I_ERR_NO_INODE_ITEM |
> -			     I_ERR_FILE_EXTENT_ORPHAN |
>  			     I_ERR_FILE_EXTENT_DISCOUNT |
>  			     I_ERR_FILE_NBYTES_WRONG |
>  			     I_ERR_INLINE_RAM_BYTES_WRONG)))
> @@ -2620,8 +2535,6 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
>  	btrfs_init_path(&path);
>  	if (rec->errors & I_ERR_NO_INODE_ITEM)
>  		ret = repair_inode_no_item(trans, root, &path, rec);
> -	if (!ret && rec->errors & I_ERR_FILE_EXTENT_ORPHAN)
> -		ret = repair_inode_orphan_extent(trans, root, &path, rec);
>  	if (!ret && rec->errors & I_ERR_FILE_EXTENT_DISCOUNT)
>  		ret = repair_inode_discount_extent(trans, root, &path, rec);
>  	if (!ret && rec->errors & I_ERR_DIR_ISIZE_WRONG)
> @@ -3245,8 +3158,6 @@ static int check_fs_root(struct btrfs_root *root,
>  	struct root_record *rec;
>  	struct btrfs_root_item *root_item = &root->root_item;
>  	struct cache_tree corrupt_blocks;
> -	struct orphan_data_extent *orphan;
> -	struct orphan_data_extent *tmp;
>  	enum btrfs_tree_block_status status;
>  	struct node_refs nrefs;
>  
> @@ -3272,18 +3183,6 @@ static int check_fs_root(struct btrfs_root *root,
>  	cache_tree_init(&root_node.inode_cache);
>  	memset(&nrefs, 0, sizeof(nrefs));
>  
> -	/* Move the orphan extent record to corresponding inode_record */
> -	list_for_each_entry_safe(orphan, tmp,
> -				 &root->orphan_data_extents, list) {
> -		struct inode_record *inode;
> -
> -		inode = get_inode_rec(&root_node.inode_cache, orphan->objectid,
> -				      1);
> -		BUG_ON(IS_ERR(inode));
> -		inode->errors |= I_ERR_FILE_EXTENT_ORPHAN;
> -		list_move(&orphan->list, &inode->orphan_extents);
> -	}
> -
>  	level = btrfs_header_level(root->node);
>  	memset(wc->nodes, 0, sizeof(wc->nodes));
>  	wc->nodes[level] = &root_node;
> 
