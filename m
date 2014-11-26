Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44507 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927AbaKZP6W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 10:58:22 -0500
Message-ID: <5475F899.7060601@fb.com>
Date: Wed, 26 Nov 2014 10:58:17 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/6] Btrfs: fix invalid block group rbtree access after
 bg is removed
References: <1417015735-8581-1-git-send-email-fdmanana@suse.com> <1417015735-8581-2-git-send-email-fdmanana@suse.com>
In-Reply-To: <1417015735-8581-2-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/26/2014 10:28 AM, Filipe Manana wrote:
> If we grab a block group, for example in btrfs_trim_fs(), we will be holding
> a reference on it but the block group can be removed after we got it (via
> btrfs_remove_block_group), which means it will no longer be part of the
> rbtree.
>
> However, btrfs_remove_block_group() was only calling rb_erase() which leaves
> the block group's rb_node left and right child pointers with the same content
> they had before calling rb_erase. This was dangerous because a call to
> next_block_group() would access the node's left and right child pointers (via
> rb_next), which can be no longer valid.
>
> Fix this by clearing a block group's node after removing it from the tree,
> and have next_block_group() do a tree search to get the next block group
> instead of using rb_next() if our block group was removed.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Josef
