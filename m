Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbbJKRv0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 13:51:26 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PULL][PATCH 0/6] Barriers around waitqueue_active (V2)
Date: Sun, 11 Oct 2015 19:50:17 +0200
Message-Id: <cover.1444579885.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've updated the main patch according to your comments in
https://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg42551.html

though with one exception, the barrier in btrfs_bio_counter_sub which seems
to be in performance sensitive context but I did not find a good way how
determine that dev-replace is running. It's protected by the shared
satus of 'mutually_exclusive_operation_running' and we'd have to do some
other checks that would also imply some performance drop. I hope it's ok
to skipt that one for now, the remaining new barriers look safe and the rest
is documenting the existing ones.

Please consider pulling this for the 4.4 cycle. Thanks.

----------------------------------------------------------------
The following changes since commit 9ffecb10283508260936b96022d4ee43a7798b4c:

  Linux 4.3-rc3 (2015-09-27 07:50:08 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git fix/waitqueue-barriers

for you to fetch changes up to ee86395458072760d62e66aad10a5e9e8902b8cf:

  btrfs: comment the rest of implicit barriers before waitqueue_active (2015-10-10 18:42:00 +0200)

----------------------------------------------------------------
David Sterba (6):
      btrfs: remove waitqueue_active check from btrfs_rm_dev_replace_unblocked
      btrfs: add barrier for waitqueue_active in clear_btree_io_tree
      btrfs: comment waitqueue_active implied by locks
      btrfs: add comments to barriers before waitqueue_active
      btrfs: remove extra barrier before waitqueue_active
      btrfs: comment the rest of implicit barriers before waitqueue_active

 fs/btrfs/compression.c   |  3 +++
 fs/btrfs/delayed-inode.c |  4 ++++
 fs/btrfs/dev-replace.c   |  3 +--
 fs/btrfs/disk-io.c       |  3 +++
 fs/btrfs/extent-tree.c   |  3 +--
 fs/btrfs/inode.c         |  3 +++
 fs/btrfs/locking.c       | 12 ++++++++++++
 fs/btrfs/ordered-data.c  |  6 ++++++
 fs/btrfs/raid56.c        |  6 +++++-
 fs/btrfs/transaction.c   |  9 +++++++++
 fs/btrfs/tree-log.c      | 14 ++++++++++++--
 fs/btrfs/volumes.c       |  3 +++
 12 files changed, 62 insertions(+), 7 deletions(-)
