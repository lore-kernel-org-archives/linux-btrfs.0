Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58539 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2ITRRr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 13:17:47 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1TEkNn-0007SO-8p
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2012 10:17:47 -0700
Date: Thu, 20 Sep 2012 10:17:47 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: 3.5.3: kernel BUG at fs/btrfs/ctree.c:3451!
Message-ID: <20120920171747.GG26105@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had a btrfs built on top of 5 drives (dmcrypt devices).

The drive then died while I was writing to the filesystem and my system
crashed and rebooted:

[384555.534020] sd 10:0:0:0: rejecting I/O to offline device                    
[384555.535057] sd 10:0:0:0: rejecting I/O to offline device                    
[384556.666885] ------------[ cut here ]------------                            
[384556.667909] sd 10:0:0:0: [sdj] Synchronizing SCSI cache                     
[384556.677509] kernel BUG at fs/btrfs/ctree.c:3451!                            
[384556.682551] invalid opcode: 0000 [#1] PREEMPT SMP                           
[384556.687878] CPU 2                                                           

	/* push data from right to left */
	copy_extent_buffer(left, right,
			   btrfs_item_nr_offset(btrfs_header_nritems(left)),
			   btrfs_item_nr_offset(0),
			   push_items * sizeof(struct btrfs_item));

	push_space = BTRFS_LEAF_DATA_SIZE(root) -
		     btrfs_item_offset_nr(right, push_items - 1);

	copy_extent_buffer(left, right, btrfs_leaf_data(left) +
		     leaf_data_end(root, left) - push_space,
		     btrfs_leaf_data(right) +
		     btrfs_item_offset_nr(right, push_items - 1),
		     push_space);
	old_left_nritems = btrfs_header_nritems(left);
	BUG_ON(old_left_nritems <= 0);  <<<<<<< 3451

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
