Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:46034 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754521AbbFCQHU (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Wed, 3 Jun 2015 12:07:20 -0400
From: Filipe Manana <fdmanana@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Send fixes for 4.2
Date: Wed,  3 Jun 2015 04:15:17 +0100
Message-Id: <1433301319-515-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Please pull 2 fixes for the send feature from my branch send_fixes_4.2.
Both have been around in the mailing list/patchwork before the 4.1 merge
window opened but were not picked for 4.1. They both have tests merged
in xfstests (btrfs/087 and btrfs/092), which as expected, fail without
this fixes applied and pass with them applied.

The following changes since commit c65b99f046843d2455aa231747b5a07a999a9f3d:

  Linux 4.1-rc6 (2015-05-31 19:01:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git send_fixes_4.2

for you to fetch changes up to 8b191a684968e24b34c9894024b37532c68e6ae8:

  Btrfs: incremental send, check if orphanized dir inode needs delayed rename (2015-06-03 03:10:40 +0100)

----------------------------------------------------------------
Filipe Manana (2):
      Btrfs: incremental send, don't delay directory renames unnecessarily
      Btrfs: incremental send, check if orphanized dir inode needs delayed rename

 fs/btrfs/send.c | 104 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 83 insertions(+), 21 deletions(-)

-- 
2.1.3

