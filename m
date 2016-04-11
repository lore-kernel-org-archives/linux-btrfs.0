Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbcDKSIG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 14:08:06 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E25A1ABB4
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2016 18:08:03 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2] Stack usage reduction
Date: Mon, 11 Apr 2016 20:04:29 +0200
Message-Id: <cover.1460397148.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

using the gcc option -fstack-usage I measured the stack usage and tried to get
rid of the worst offenders. The best improvement was in create_subvol where we
stored a 400B+ structure on stack, but otherwise it's not always clear why the
stack usage is that high. Most functions consume less than 300 bytes, and this
number can account for inlined functions or other invisible compiler
optimization magic.

A few samples of what's left:

scrub.c:3056:31:scrub_stripe                                         568  static
volumes.c:3984:12:btrfs_uuid_scan_kthread                            536  static
scrub.c:2834:31:scrub_raid56_parity                                  384  static
ioctl.c:5225:12:btrfs_ioctl_set_fslabel                              304  static
ioctl.c:1261:5:btrfs_defrag_file                                     304  static
tree-log.c:3593:21:copy_items                                        288  dynamic,bounded
ioctl.c:5202:12:btrfs_ioctl_get_fslabel                              288  static
ioctl.c:3457:12:btrfs_clone                                          288  static
extent_io.c:2873:12:__do_readpage                                    288  static
file.c:691:5:__btrfs_drop_extents                                    272  static
file.c:2646:13:btrfs_fallocate                                       272  static
extent-tree.c:2469:21:__btrfs_run_delayed_refs                       272  static
extent_io.c:3779:5:btree_write_cache_pages                           272  static
extent_io.c:1730:6:extent_clear_unlock_delalloc                      272  static
tree-log.c:4432:12:btrfs_log_inode                                   264  dynamic,bounded
tree-log.c:578:21:replay_one_extent                                  256  static
transaction.c:1322:21:create_pending_snapshot                        256  static
ioctl.c:434:21:create_subvol                                         256  static
inode.c:1221:21:run_delalloc_nocow                                   256  static
extent_io.c:4145:5:extent_readpages                                  256  static
tree-log.c:4126:12:btrfs_log_changed_extents                         248  dynamic,bounded
relocation.c:680:22:build_backref_tree                               248  static
inode.c:4287:5:btrfs_truncate_inode_items                            248  static
extent_io.c:3312:31:__extent_writepage_io                            248  static
volumes.c:2948:12:insert_balance_item                                240  static
relocation.c:1762:5:replace_path                                     240  static
...

More detailed info would be needed to decide whether it's worth to reshuffle
the stack variables, from what I've seen it would make the code readability
worse, so I've stopped.

----------------------------------------------------------------
The following changes since commit bb7ab3b92e46da06b580c6f83abe7894dc449cca:

  btrfs: Fix misspellings in comments. (2016-03-14 15:05:02 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/stack-reduce

for you to fetch changes up to 355ef15a6eafc0cafd49b049d7173040adb44f61:

  btrfs: reuse existing variable in scrub_stripe, reduce stack usage (2016-03-24 18:06:34 +0100)

----------------------------------------------------------------
David Sterba (2):
      btrfs: use dynamic allocation for root item in create_subvol
      btrfs: reuse existing variable in scrub_stripe, reduce stack usage

 fs/btrfs/ioctl.c | 49 ++++++++++++++++++++++++++-----------------------
 fs/btrfs/scrub.c | 19 +++++++++----------
 2 files changed, 35 insertions(+), 33 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
