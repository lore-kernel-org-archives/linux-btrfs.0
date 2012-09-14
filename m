Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:57679 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab2INNJl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 09:09:41 -0400
Date: Fri, 14 Sep 2012 15:09:33 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] Btrfs: kill obsolete arguments in
 btrfs_wait_ordered_extents
Message-ID: <20120914130933.GJ17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
 <1347613087-3489-5-git-send-email-bo.li.liu@oracle.com>
 <20120914124516.GK12994@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120914124516.GK12994@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 08:45:16AM -0400, Josef Bacik wrote:
> On Fri, Sep 14, 2012 at 02:58:07AM -0600, Liu Bo wrote:
> > nocow_only is now an obsolete argument.
> > 
> 
> Why is it obsolete, it looks like it's being used to me?  Thanks,

It's always 0 so the removed code never executes.

I'm tracking where it started, pretty long ago:

commit 7ea394f1192bee1af67ea4762c88ef4b7b0487a8
Author: Yan Zheng <zheng.yan@oracle.com>
Date:   Tue Aug 5 13:05:02 2008 -0400

without any explanations what it fixes, so I'd be rather cautious here.

I found this hunk from

commit 24bbcf0442ee04660a5a030efdbb6d03f1c275cb
Author: Yan, Zheng <zheng.yan@oracle.com>
Date:   Thu Nov 12 09:36:34 2009 +0000
Subject: Btrfs: Add delayed iput

does something suspicious:

@@ -991,11 +994,11 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
                mutex_unlock(&root->fs_info->trans_mutex);

                if (flush_on_commit) {
-                       btrfs_start_delalloc_inodes(root);
-                       ret = btrfs_wait_ordered_extents(root, 0);
+                       btrfs_start_delalloc_inodes(root, 1);
+                       ret = btrfs_wait_ordered_extents(root, 0, 1);
                        BUG_ON(ret);
                } else if (snap_pending) {
-                       ret = btrfs_wait_ordered_extents(root, 1);
+                       ret = btrfs_wait_ordered_extents(root, 0, 1);
                        BUG_ON(ret);
                }
---

The purpose was to add the dealy_iput argument to the end of the list,
but why does it change the nocow from 1 -> 0 in the if(snap_pending) branch?

The code was last touched by Sage in commit

commit 0bdb1db297ab36865a63ee722d35ff0a1f0ae522
Author: Sage Weil <sage@newdream.net>
Date:   Fri Feb 19 14:13:50 2010 -0800
Subject: Btrfs: flush data on snapshot creation

    Flush any delalloc extents when we create a snapshot, so that recently
    written file data is always included in the snapshot.

    A later commit will add the ability to snapshot without the flush, but
    most people expect flushing.

    Signed-off-by: Sage Weil <sage@newdream.net>
    Signed-off-by: Chris Mason <chris.mason@oracle.com>

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2a36e23..2d654c1 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -997,13 +997,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,

                mutex_unlock(&root->fs_info->trans_mutex);

-               if (flush_on_commit) {
+               if (flush_on_commit || snap_pending) {
                        btrfs_start_delalloc_inodes(root, 1);
                        ret = btrfs_wait_ordered_extents(root, 0, 1);
                        BUG_ON(ret);
-               } else if (snap_pending) {
-                       ret = btrfs_wait_ordered_extents(root, 0, 1);
-                       BUG_ON(ret);
                }
---

the calls to btrfs_wait_ordered_extents were same and thus mergeable.
