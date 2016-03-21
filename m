Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbcCUTxq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 15:53:46 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs, misc for 4.6
Date: Mon, 21 Mar 2016 19:42:09 +0100
Message-Id: <cover.1458585064.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a few low-risk patches that appeared after I sent my main pull for 4.6. I think
they still apply to 4.6, the freezer patches help the livepatch to clean up the
mis-use of the freezer API, the rest makes sure we don't miss an error during
writing checksums.

I've removed Liu Bo's patch fixing the writeback_index, IMO needs moe review
and can be merged in some later rc.

----------------------------------------------------------------
The following changes since commit 5e33a2bd7ca7fa687fb0965869196eea6815d1f3:

  Btrfs: do not collect ordered extents when logging that inode exists (2016-03-01 08:23:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.6

for you to fetch changes up to 45147cbef21305b512a5b263e9e52f832a0df7b2:

  btrfs: transaction_kthread() is not freezable (2016-03-21 19:02:34 +0100)

----------------------------------------------------------------
Alex Lyakas (2):
      btrfs: csum_tree_block: return proper errno value
      btrfs: do not write corrupted metadata blocks to disk

Jiri Kosina (2):
      btrfs: cleaner_kthread() doesn't need explicit freeze
      btrfs: transaction_kthread() is not freezable

 fs/btrfs/disk-io.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)
