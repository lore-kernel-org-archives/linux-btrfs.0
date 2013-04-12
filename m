Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19459 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab3DLIf5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Apr 2013 04:35:57 -0400
Message-ID: <5167C85B.50106@cn.fujitsu.com>
Date: Fri, 12 Apr 2013 16:39:55 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 3/4] Btrfs-progs: add more subvol fields to btrfs-list
In-Reply-To: <140ca9fdec9d22e8841bc0309ba2e70fff7539bd.1365754038.git.sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <140ca9fdec9d22e8841bc0309ba2e70fff7539bd.1365754038.git.sbehrens@giantdisaster.de>

Hello Stefan,

[snip]

..
> -static int update_root(struct root_lookup *root_lookup,
> -		       u64 root_id, u64 ref_tree, u64 root_offset, u64 flags,
> -		       u64 dir_id, char *name, int name_len, u64 ogen, u64 gen,
> -		       time_t ot, void *uuid, void *puuid)
> +static int set_root_info(struct root_info *rinfo, u64 ref_tree, u64 root_offset,
> +			 u64 dir_id, char *name, int name_len,
> +			 struct btrfs_root_item *ritem, u32 ritem_len)
>  {
> -	struct root_info *ri;
> +	int is_v0 = (ritem_len <= sizeof(struct btrfs_root_item_v0));
>  
> -	ri = root_tree_search(root_lookup, root_id);
> -	if (!ri || ri->root_id != root_id)
> -		return -ENOENT;
> -	if (name && name_len > 0) {
> -		if (ri->name)
> -			free(ri->name);
> +	if (root_offset)
> +		rinfo->root_offset = root_offset;
> +	if (ref_tree)
> +		rinfo->ref_tree = ref_tree;
> +	if (dir_id)
> +		rinfo->dir_id = dir_id;
> +
> +	if (ritem) {
> +		rinfo->gen = btrfs_root_generation(ritem);
> +		rinfo->flags = btrfs_root_flags(ritem);
> +	}
>  
> -		ri->name = malloc(name_len + 1);
> -		if (!ri->name) {
> +	if (ritem && !is_v0) {
> +		rinfo->cgen = btrfs_root_ctransid(ritem);
> +		rinfo->ogen = btrfs_root_otransid(ritem);
> +		rinfo->sgen = btrfs_root_stransid(ritem);
> +		rinfo->rgen = btrfs_root_rtransid(ritem);
> +		rinfo->ctime = btrfs_stack_timespec_sec(&ritem->ctime);
> +		rinfo->otime = btrfs_stack_timespec_sec(&ritem->otime);
> +		rinfo->stime = btrfs_stack_timespec_sec(&ritem->stime);
> +		rinfo->rtime = btrfs_stack_timespec_sec(&ritem->rtime);
> +		memcpy(rinfo->uuid, ritem->uuid, BTRFS_UUID_SIZE);
> +		memcpy(rinfo->puuid, ritem->parent_uuid, BTRFS_UUID_SIZE);
> +		memcpy(rinfo->ruuid, ritem->received_uuid, BTRFS_UUID_SIZE);

> +	} else if (ritem && is_v0 && root_offset) {
> +		/*
> +		 * old style (v0) root items don't contain an otransid field.
> +		 * But for snapshots, root_offset equals to its original
> +		 * generation.
> +		 */
> +		rinfo->ogen = root_offset;
> +	}


	We set it rinfo->ogen = root_offset only if:
	1> for root_item_v0
	2> it is a snapshot.

	Besides for a snapshot it's root_offset is always none zero.
	so we do not need (is_v0 && root_offset) both.
	Actually, Patch V2 doses the correct thing.

Thanks,
Wang

> +
> +	if (name && name_len > 0) {
> +		rinfo->name = malloc(name_len + 1);
> +		if (!rinfo->name) {
>  			fprintf(stderr, "memory allocation failed\n");
> -			exit(1);
> +			return -1;
>  		}
> -		strncpy(ri->name, name, name_len);
> -		ri->name[name_len] = 0;
> +		strncpy(rinfo->name, name, name_len);
> +		rinfo->name[name_len] = 0;
>  	}
> -	if (ref_tree)
> -		ri->ref_tree = ref_tree;
> -	if (root_offset)
> -		ri->root_offset = root_offset;
> -	if (flags)
> -		ri->flags = flags;
> -	if (dir_id)
> -		ri->dir_id = dir_id;
> -	if (gen)
> -		ri->gen = gen;
> -	if (ogen)
> -		ri->ogen = ogen;
> -	if (!ri->ogen && root_offset)
> -		ri->ogen = root_offset;
> -	if (ot)
> -		ri->otime = ot;
> -	if (uuid)
> -		memcpy(&ri->uuid, uuid, BTRFS_UUID_SIZE);
> -	if (puuid)
> -		memcpy(&ri->puuid, puuid, BTRFS_UUID_SIZE);
>  
>  	return 0;
>  }
>  

[snpi]
....


