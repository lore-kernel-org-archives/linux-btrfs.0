Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:19369 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2JSFas (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 01:30:48 -0400
Message-ID: <5080E577.3090109@oracle.com>
Date: Fri, 19 Oct 2012 13:30:31 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: MOD_LOG_KEY_REMOVE_WHILE_MOVING never change node's
 nritems
References: <1350545573-2544-1-git-send-email-bo.li.liu@oracle.com> <5080E18F.2080101@jan-o-sch.net>
In-Reply-To: <5080E18F.2080101@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/19/2012 01:13 PM, Jan Schmidt wrote:
> On Thu, October 18, 2012 at 09:32 (+0200), Liu Bo wrote:
>> Key MOD_LOG_KEY_REMOVE_WHILE_MOVING means that we're doing memmove inside
>> an extent buffer node, and the node's number of items remains unchanged,
>> so we don't need to increment node's number of items during rewinding,
>> otherwise we may get an node larger than leafsize and cause general protection
>> errors later.
> 
> This patch triggers the following bug on when running fsmark on a quota enabled
> file system:
> 
> 1153                 case MOD_LOG_KEY_REPLACE:
> 1154                         BUG_ON(tm->slot >= n);
> 
> MOD_LOG_KEY_REMOVE_WHILE_MOVING elements are added by tree_mod_log_insert_move
> when dst_slot < src_slot, thus we're reducing the number of elements in the
> buffer, thus replaying adds those elements.
> 

Hi Jan,

I doubt it.

tree_mod_log_insert_move() has only one caller tree_mod_log_eb_move(), and
tree_mod_log_eb_move() has 4 callers:
- push_node_left()
- balance_node_right()
- insert_ptr()
- del_ptr()

Among the 4 callers, only del_ptr() modifies nritems without inserting other keys,
like MOD_LOG_KEY_ADD, etc.

So IMO memmove does not modify the nritems:

| - - - 3 4 5 | => | 3 4 5 - - - |     (nritems remain unchanged)

It is other operations (MOD_LOG_KEY_ADD, MOD_LOG_KEY_REMOVE, MOD_LOG_KEY_REMOVE_WHILE_FREEING)
that modify the nritems.

I think the following patch can help us:

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6d183f6..cdd5995 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4722,7 +4722,8 @@ static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			      btrfs_node_key_ptr_offset(slot + 1),
 			      sizeof(struct btrfs_key_ptr) *
 			      (nritems - slot - 1));
-	} else if (tree_mod_log && level) {
+	}
+	if (tree_mod_log && level) {
 		ret = tree_mod_log_insert_key(root->fs_info, parent, slot,
 					      MOD_LOG_KEY_REMOVE);
 		BUG_ON(ret < 0);


thanks,
liubo
