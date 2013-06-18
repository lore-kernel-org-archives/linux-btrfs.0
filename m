Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51169 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050Ab3FRQ7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Jun 2013 12:59:55 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id DEBFF9A06B0
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2013 10:59:54 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, Sage Weil <sage@inktank.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130618163706.GC19183@localhost.localdomain>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net>
 <20130618163706.GC19183@localhost.localdomain>
Message-ID: <20130618165952.9494.8953@localhost.localdomain>
Subject: Re: hang on 3.9, 3.10-rc5
Date: Tue, 18 Jun 2013 12:59:52 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Josef Bacik (2013-06-18 12:37:06)
> On Tue, Jun 11, 2013 at 11:43:30AM -0400, Sage Weil wrote:
> > I'm also seeing this hang regularly with both 3.9 and 3.10-rc5.  Is this 
> > is a known problem?  In this case there is no powercycling; just a regular 
> > ceph-osd workload.
> > 
> 
> Have you gotten sysrq+w?  Can you tell me where

He attached it last week.

> 
> log_one_extent.isra.22+0x485
> 
> is on your box?  Thanks,

It's very suspect that both of the times he logged this
log_one_extent popped up.  That should be: 

                wait_event(ordered->wait, ordered->csum_bytes_left == 0);

But Sage it would definitely help if you could confirm.

If we follow log_one_extent all the way up to btrfs_log_inode:

               } else if (test_and_clear_bit(BTRFS_INODE_COPY_EVERYTHING,
                                              &BTRFS_I(inode)->runtime_flags)) { 
                        if (inode_only == LOG_INODE_ALL)
                                fast_search = true;
                        max_key.type = BTRFS_XATTR_ITEM_KEY;
                        ret = drop_objectid_items(trans, log, path, ino,
                                                  max_key.type);

Now fast_search is true, but we don't jump directly to logging the
extent.  The while loop runs, we hit the first break.  ins_nr is zero.

Then we:
       if (fast_search) {
                btrfs_release_path(dst_path);
                ret = btrfs_log_changed_extents(trans, root, inode, dst_path);
                if (ret) {
                        err = ret;
                        goto out_unlock;
                }


Very long way of saying I think we're one release_path short.  Sage, I
haven't tested this at all yet, I was hoping to trigger it first.

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c276ac9..c1954b3 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3730,6 +3730,7 @@ next_slot:
 log_extents:
 	if (fast_search) {
 		btrfs_release_path(dst_path);
+		btrfs_release_path(path);
 		ret = btrfs_log_changed_extents(trans, root, inode, dst_path);
 		if (ret) {
 			err = ret;
