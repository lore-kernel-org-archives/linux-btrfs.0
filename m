Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:43155 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab3AXXqr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 18:46:47 -0500
Date: Thu, 24 Jan 2013 18:46:42 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix potential null pointer dereference bug
Message-ID: <20130124234642.GA29022@gmail.com>
References: <1358609265-347-1-git-send-email-dinggnu@gmail.com>
 <20130124153420.GC2349@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130124153420.GC2349@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 24, 2013 at 10:34:20AM -0500, Josef Bacik wrote:
> On Sat, Jan 19, 2013 at 08:27:45AM -0700, Cong Ding wrote:
> > The bug happens when rb_node == NULL. It causes variable node to be NULL and
> > then the NULL pointer is dereferenced this line:
> > 	BUG_ON((struct btrfs_root *)node->data != root);
> > 
> > Based on my analysis, function tree_search should not return NULL to variable
> > rb_node in this case (otherwise here has to be something unknown thing wrong),
> > so I replace "if (rb_node)" with UG_ON(!rb_node).
> > 
> > Signed-off-by: Cong Ding <dinggnu@gmail.com>
> 
> I don't want to add more BUG_ON()'s, just return an error.
But rb_node really has no chance to be 0, so I think we should use BUG_ON
rather than return an error. If we return an error number here, its caller
should check the returned value and call BUG_ON(ret) - it makes no difference.

The file system doesn't have any way to handle this kind of error (and I think
if it happens, there must be some hardware error or some other program
directly operates on the file system bypassing linux system call).  If you
don't want to add more BUG_ON, I suggest to check variable "node" in the
existing BUG_ON as the following code.
-	BUG_ON((struct btrfs_root *)node->data != root);
+	BUG_ON(!node || (struct btrfs_root *)node->data != root);

What's your opinion, or do you have a better solution?

Thanks,
- cong

>From 3a5b4df67dd177b7cbc61c555349fd7e87ef6b54 Mon Sep 17 00:00:00 2001
From: Cong Ding <dinggnu@gmail.com>
Date: Thu, 24 Jan 2013 18:30:45 -0500
Subject: [PATCH] btrfs: fix potential null pointer dereference bug

The bug happens when rb_node == NULL. It causes variable node to be NULL and
then the NULL pointer is dereferenced this line:
        BUG_ON((struct btrfs_root *)node->data != root);

So we check node before the dereference.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 fs/btrfs/relocation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 17c306b..938b037 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1269,7 +1269,7 @@ static int __update_reloc_root(struct btrfs_root *root, int del)
 	}
 	spin_unlock(&rc->reloc_root_tree.lock);
 
-	BUG_ON((struct btrfs_root *)node->data != root);
+	BUG_ON(!node || (struct btrfs_root *)node->data != root);
 
 	if (!del) {
 		spin_lock(&rc->reloc_root_tree.lock);
-- 
1.7.10.4

