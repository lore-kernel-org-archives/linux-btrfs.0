Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45980 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751428AbaJAPtb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Oct 2014 11:49:31 -0400
Date: Wed, 1 Oct 2014 11:49:24 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs-progs: Check the consistence between the parent
 node and child node/leaf.
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1412178564.9583.1@mail.thefacebook.com>
In-Reply-To: <1411716995-22537-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1411716995-22537-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 26, 2014 at 3:36 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> 
wrote:
> When btrfs-progs walk down the tree, it does not check whether the 
> child
> node/leaf is valid.
> In fact, there is some corrupted image whose csum is all valid but
> parent node points to a invalid leaf.
> 
> In my case, the parent node in fs tree point to a invalid leaf(gen 
> 11),
> whose generation(15) and first key(EXTENT_TREE ROOT_ITEM 0) is
> completely invalid, and will cause BUG_ON in process_inode_item().
> 
> Unfortunately, we are unable to fix when it happens.
> So we can only output meaningful error message and avoid the insane
> node/leaf, which is still much better than the original BUG_ON().
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  cmds-check.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index d479361..9471709 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -1302,6 +1302,52 @@ static void reada_walk_down(struct btrfs_root 
> *root,
>  	}
>  }
> 
> +/*
> + * Check the child node/leaf by the following condition:
> + * 1. the first item key of the node/leaf should be the same with 
> the one
> + *    in parent.
> + * 2. block in parent node should match the child node/leaf.
> + * 3. generation of parent node and child's header should be 
> consistent.
> + *
> + * Or the child node/leaf pointed by the key in parent is not valid.
> + *
> + * We hope to check leaf owner too, but since subvol may share 
> leaves,
> + * which makes leaf owner check not so strong, key check should be
> + * sufficient enough for that case.
> + */
> +static int check_child_node(struct btrfs_root *root,
> +			    struct extent_buffer *parent, int slot,
> +			    struct extent_buffer *child)
> +{
> +	struct btrfs_key parent_key;
> +	struct btrfs_key child_key;
> +	int ret = 0;
> +
> +	btrfs_item_key_to_cpu(parent, &parent_key, slot);

Dave mentioned he was getting a bunch of Wrong key of child node 
messages from his current tree.  I should have spotted it sooner, but 
this call should be btrfs_node_key_to_cpu(), since the parent is always 
a node.

> 
> +	btrfs_item_key_to_cpu(child, &child_key, 0);

This should check the level and only use btrfs_item_key_to_cpu on the 
leaves.

Thanks!

-chris


