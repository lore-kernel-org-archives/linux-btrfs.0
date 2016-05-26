Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbcEZJ1m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 05:27:42 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs for 4.7, part 2
Date: Thu, 26 May 2016 11:27:06 +0200
Message-Id: <cover.1464254502.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please pull a few more patches that did not go to pull #1 for 4.7, minor
cleanups and fixes. Thanks.


The following changes since commit c315ef8d9db7f1a0ebd023a395ebdfde1c68057e:

  Merge branch 'for-chris-4.7' of git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux into for-linus-4.7 (2016-05-17 14:43:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris

for you to fetch changes up to 4c6143dd497901e3537dc4324dc203dfda442009:

  Merge branch 'dev/comp-workspaces' into for-chris-4.7-20160525 (2016-05-25 22:51:04 +0200)

----------------------------------------------------------------
David Sterba (17):
  btrfs: rename and document compression workspace members
  btrfs: preallocate compression workspaces
  btrfs: make find_workspace always succeed
  btrfs: make find_workspace warn if there are no workspaces
  btrfs: sink gfp parameter to set_extent_bits
  btrfs: sink gfp parameter to clear_extent_bits
  btrfs: sink gfp parameter to clear_record_extent_bits
  btrfs: sink gfp parameter to clear_extent_dirty
  btrfs: sink gfp parameter to set_extent_delalloc
  btrfs: sink gfp parameter to set_extent_defrag
  btrfs: sink gfp parameter to set_extent_new
  btrfs: sink gfp parameter to set_record_extent_bits
  btrfs: untangle gotos a bit in __set_extent_bit
  btrfs: untangle gotos a bit in __clear_extent_bit
  btrfs: untangle gotos a bit in convert_extent_bit
  btrfs: make state preallocation more speculative in __set_extent_bit
  btrfs: sink gfp parameter to convert_extent_bit

Liu Bo (2):
  Btrfs: free sys_array eb as soon as possible
  Btrfs: fix unexpected return value of fiemap

Nicholas D Steeves (1):
  btrfs: fix string and comment grammatical issues and typos

Zhao Lei (1):
  btrfs: scrub: Set bbio to NULL before calling btrfs_map_block

