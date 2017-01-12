Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35099 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbdALOA5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:00:57 -0500
Received: by mail-lf0-f65.google.com with SMTP id v186so1935420lfa.2
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 06:00:56 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 00/24] tree-log inode vs btrfs_inode cleanups
Date: Thu, 12 Jan 2017 16:00:26 +0200
Message-Id: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


So here is a new set of patches cleaning up tree-log function 
w.r.t inode vs btrfs_inode. There are still some which remain 
but I didn't find compelling arguments to cleaning them up, so 
I've left them unchanged. This time there are some size shrinkage:

   text	   data	    bss	    dec	    hex	filename
   2530598	 174661	  28288	2733547	 29b5eb	fs/btrfs/btrfs.ko - upstream master

 	text	   data	    bss	    dec	    hex	filename
 	2530774	 174661	  28288	2733723	 29b69b	fs/btrfs/btrfs.ko - before tree-log cleanup

    text	   data	    bss	    dec	    hex	filename
	2530163	 174661	  28288	2733112	 29b438	fs/btrfs/btrfs.ko - both series applied 

So the net result of the 2 series is 435 bytes and I assume there 
will be further reduction in size once further cleanups are made 

Nikolay Borisov (24):
  btrfs: Make btrfs_must_commit_transaction take btrfs_inode
  btrfs: Make btrfs_record_unlink_dir take btrfs_inode
  btrfs: Make btrfs_record_snapshot_destroy take btrfs_inode
  btrfs: Make btrfs_inode_in_log take btrfs_inode
  btrfs: Make btrfs_log_new_name take btrfs_inode
  btrfs: Make btrfs_del_dir_entries_in_log take btrfs_inode
  btrfs: Make btrfs_del_inode_ref take btrfs_inode
  btrfs: Make logged_inode_size take btrfs_inode
  btrfs: Make btrfs_check_ref_name_override take btrfs_inode
  btrfs: Make copy_items take btrfs_inode
  btrfs: Make btrfs_log_all_xattrs take btrfs_inode
  btrfs: Make btrfs_log_trailing_hole take btrfs_inode
  btrfs: Make btrfs_get_logged_extents take btrfs_inode
  btrfs: Make btrfs_log_changed_extents take btrfs_inode
  btrfs: Make log_dir_items take btrfs_inode
  btrfs: Make log_directory_changes take btrfs_inode
  btrfs: Make log_new_dir_dentries take btrfs_inode
  btrfs: Make btrfs_unlink_inode take btrfs_inode
  btrfs: Make drop_one_dir_item take btrfs_inode
  btrfs: Make __add_inode_ref take btrfs_inode
  btrfs: Make log_inode_item take btrfs_inode
  btrfs: Make btrfs_log_inode take btrfs_inode
  btrfs: Make count_inode_extrefs take btrfs_inode
  btrfs: Make count_inode_refs take btrfs_inode

 fs/btrfs/btrfs_inode.h  |  16 ++-
 fs/btrfs/ctree.h        |   2 +-
 fs/btrfs/file.c         |   2 +-
 fs/btrfs/inode.c        |  90 ++++++++-------
 fs/btrfs/ioctl.c        |   2 +-
 fs/btrfs/ordered-data.c |   4 +-
 fs/btrfs/ordered-data.h |   2 +-
 fs/btrfs/tree-log.c     | 288 +++++++++++++++++++++++-------------------------
 fs/btrfs/tree-log.h     |  10 +-
 9 files changed, 201 insertions(+), 215 deletions(-)

-- 
2.7.4

