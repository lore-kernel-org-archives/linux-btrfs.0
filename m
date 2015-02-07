Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:55848 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752483AbbBGS5y (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Sat, 7 Feb 2015 13:57:54 -0500
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v3] Btrfs: fix fsync race leading to ordered extent memory leaks
Date: Sat,  7 Feb 2015 18:57:09 +0000
Message-Id: <1423335429-24953-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1423226048-23351-1-git-send-email-fdmanana@suse.com>
References: <1423226048-23351-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can have two concurrent fsync operations against the same file,
in which case both fsyncs can collect the same ordered extents.
This allows for a time window where a race can lead to those ordered
extents never getting their reference count decremented to 0, leading
to memory leaks, getting referenced by multiple lists and resulting in
inode leaks too (an iput for the ordered extent's inode is scheduled
only when the ordered extent's refcount drops to 0). The following
sequence diagram explains this race:

         CPU 1                                    CPU 2

btrfs_sync_file()                          btrfs_sync_file()

  mutex_lock(inode->i_mutex)
  btrfs_log_inode()
    btrfs_get_logged_extents()
      --> collects ordered extent X
      --> increments ordered
          extent X's refcount
    btrfs_submit_logged_extents()
  mutex_unlock(inode->i_mutex)

  btrfs_sync_log()
    --> blocks on
        mutex_lock(root->log_mutex)

                                           mutex_lock(inode->i_mutex)
                                             btrfs_log_inode()
                                               btrfs_get_logged_extents()
                                                 --> collects ordered extent X
                                                     as well
                                                 --> increments ordered extent
                                                     X's refcount
                                                 --> ordered extent X is now
                                                     referenced by 2 different
                                                     lists, due to use of
                                                     list_add() and not list_move()
                                               btrfs_submit_logged_extents()
                                           mutex_unlock(inode->i_mutex)

   --> mutex root->log_mutex became
       free and task is unblocked

     btrfs_wait_logged_extents()
       --> sets bit BTRFS_ORDERED_LOGGED
           on ordered extent X's flags
           and adds it to trans->ordered
  btrfs_sync_log() finishes

                                           btrfs_sync_log()
                                             --> Same log_transid as task at CPU 1
                                             --> root->log_commit[log_transid % 2] > 0
                                             wait_log_commit()
                                             return ctx->log_ret
                                             --> The increment on ordered extent
                                                 X's refcount done before by the
                                                 task at CPU 2 will never have a
                                                 matching decrement

Fix this by using the flag BTRFS_ORDERED_LOGGED differently. Use it to
mean that an ordered extent is already being processed by an fsync call,
which prevents it from ever being collected by multiple concurrent
fsync operations against the same inode.

This race was introduced with the following change (added in 3.19 and
backported to stable 3.18 and 3.17):

  Btrfs: make sure logged extents complete in the current transaction V3
  commit 50d9aa99bd35c77200e0e3dd7a72274f8304701f

CC: <stable@vger.kernel.org> # 3.19, 3.18 and 3.17
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: No code changes, re-worded commit message and diagram.
    CC'ed stable too.

V3: No code changes, only adjusted commit message and its
    diagram to be more accurate.

 fs/btrfs/ordered-data.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 534544e..87c8976 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -454,7 +454,7 @@ void btrfs_get_logged_extents(struct inode *inode,
 			break;
 		if (!list_empty(&ordered->log_list))
 			continue;
-		if (test_bit(BTRFS_ORDERED_LOGGED, &ordered->flags))
+		if (test_and_set_bit(BTRFS_ORDERED_LOGGED, &ordered->flags))
 			continue;
 		list_add(&ordered->log_list, logged_list);
 		atomic_inc(&ordered->refs);
@@ -470,6 +470,7 @@ void btrfs_put_logged_extents(struct list_head *logged_list)
 		ordered = list_first_entry(logged_list,
 					   struct btrfs_ordered_extent,
 					   log_list);
+		clear_bit(BTRFS_ORDERED_LOGGED, &ordered->flags);
 		list_del_init(&ordered->log_list);
 		btrfs_put_ordered_extent(ordered);
 	}
@@ -511,8 +512,7 @@ void btrfs_wait_logged_extents(struct btrfs_trans_handle *trans,
 		wait_event(ordered->wait, test_bit(BTRFS_ORDERED_IO_DONE,
 						   &ordered->flags));
 
-		if (!test_and_set_bit(BTRFS_ORDERED_LOGGED, &ordered->flags))
-			list_add_tail(&ordered->trans_list, &trans->ordered);
+		list_add_tail(&ordered->trans_list, &trans->ordered);
 		spin_lock_irq(&log->log_extents_lock[index]);
 	}
 	spin_unlock_irq(&log->log_extents_lock[index]);
-- 
2.1.3

