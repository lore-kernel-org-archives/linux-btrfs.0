Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44162 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754151AbcHXMqR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 08:46:17 -0400
Date: Wed, 24 Aug 2016 14:44:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: check: skip shared node or leaf check for
 low_memory mode
Message-ID: <20160824124431.GQ16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160819095946.31917-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160819095946.31917-1-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 19, 2016 at 05:59:46PM +0800, Wang Xiaoguang wrote:
> The basic idea is simple. Assume a middle tree node A is shared and
> its referenceing fs/file tree root ids are 5, 258 and 260, then we
> only check node A in the tree who has the smallest root id. That means
> in this case, when checking root tree(5), we check inode A, for root
> tree 258 and 260, we can just skip it.
> 
> Notice even with this patch, we still may visit a shared node or leaf
> multiple times. This happens when a inode metadata occupies multiple
> leaves.
> 
>                  leaf_A     leaf_B
> When checking inode item in leaf_A, assume inode[512] have file extents
> in leaf_B, and leaf_B is shared. In the case, for inode[512], we must
> visit leaf_B to have inode item check. After finishing inode[512] check,
> here we walk down tree root to leaf_B to check whether node or leaf
> is shared, if some node or leaf is shared, we can just skip it and below
> nodes or leaf's check.
> 
> I also fill a disk partition with linux source codes and create 3 snapshots
> in it. Before this patch, it averagely took 46s to finish one btrfsck
> execution, with this patch, it averagely took 15s.
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Can you please refresh the patch on top of current devel branch? I get
too many conflicts to resolve.

> @@ -2001,6 +2081,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
>  				       path->nodes[*level]->start,
>  				       *level, 1, &refs, NULL);
>  		if (ret < 0) {
> +			fprintf(stderr, "zhaoyan\n");

Probably a debugging leftover
