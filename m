Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:39723 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149Ab2IRObE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 10:31:04 -0400
Message-ID: <50588599.40900@oracle.com>
Date: Tue, 18 Sep 2012 22:30:49 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Yuanhan Liu <yuanhan.liu@intel.com>, kernel-janitors@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [josef-btrfs:master 66/68] fs/btrfs/inode.c:2185:6: warning:
 passing argument 2 of 'btrfs_drop_extents' from incompatible pointer type
References: <20120918140502.GA16816@localhost>
In-Reply-To: <20120918140502.GA16816@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/18/2012 10:05 PM, Fengguang Wu wrote:
> Hi Liu,
> 
> FYI, there are new compile warnings show up in
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git master
> head:   6a47d2266699f2d7903d26f178ed135dd9a109cf
> commit: 434728b4678badfad6e8a35df26034a081014254 [66/68] Btrfs: snapshot-aware defrag
> config: x86_64-randconfig-s345 (attached as .config)
> 

Thanks for the report :)

thanks,
liubo

> All error/warnings:
> 
> fs/btrfs/inode.c: In function 'relink_extent_backref':
> fs/btrfs/inode.c:2185:6: warning: passing argument 2 of 'btrfs_drop_extents' from incompatible pointer type [enabled by default]
> In file included from fs/btrfs/inode.c:43:0:
> fs/btrfs/ctree.h:3340:5: note: expected 'struct btrfs_root *' but argument is of type 'struct inode *'
> fs/btrfs/inode.c:2185:6: warning: passing argument 3 of 'btrfs_drop_extents' makes pointer from integer without a cast [enabled by default]
> In file included from fs/btrfs/inode.c:43:0:
> fs/btrfs/ctree.h:3340:5: note: expected 'struct inode *' but argument is of type 'u64'
> fs/btrfs/inode.c:2185:6: warning: passing argument 5 of 'btrfs_drop_extents' makes integer from pointer without a cast [enabled by default]
> In file included from fs/btrfs/inode.c:43:0:
> fs/btrfs/ctree.h:3340:5: note: expected 'u64' but argument is of type 'u64 *'
> 
> vim +2185 fs/btrfs/inode.c
>   2175		start = backref->file_pos;
>   2176		if (backref->extent_offset < old->extent_offset + old->offset)
>   2177			start += old->extent_offset + old->offset -
>   2178				 backref->extent_offset;
>   2179	
>   2180		len = min(backref->extent_offset + backref->num_bytes,
>   2181			  old->extent_offset + old->offset + old->len);
>   2182		len -= max(backref->extent_offset, old->extent_offset + old->offset);
>   2183	
>   2184		ret = btrfs_drop_extents(trans, inode, start,
>> 2185					 start + len, &hint_byte, 1);
>   2186		if (ret)
>   2187			goto out_free_path;
>   2188	again:
>   2189		key.objectid = btrfs_ino(inode);
>   2190		key.type = BTRFS_EXTENT_DATA_KEY;
>   2191		key.offset = start;
>   2192	
>   2193		if (merge) {
>   2194			struct btrfs_file_extent_item *fi;
>   2195			u64 extent_len;
> 
> ---
> 0-DAY kernel build testing backend         Open Source Technology Centre
> Fengguang Wu, Yuanhan Liu                              Intel Corporation
> 

