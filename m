Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49891 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbbJONYW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 09:24:22 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org, clm@fb.com
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs fixes for 4.4 integration branch
Date: Thu, 15 Oct 2015 14:23:22 +0100
Message-Id: <1444915402-27170-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris.

Please consider the bug fixes listed below for the linux kernel 4.4 merge
window (they were all previously sent to the mailing list).

Robin Ruede found and fixed a regression in send that was introduced by a
commit added to the 4.2 kernel release (a few other people reported this
regression too).

There's also a small fix for reading a page through the extent_same ioctl
when the page belongs to a file hole.

Finally we have two data corruption/data loss fixes, one for send/receive
and the other for the clone ioctl. Both issues have been around for a long
time, since the very first commits that introduced send/receive and the
clone ioctl.

I have tagged Robin's fix and the clone ioctl fix for stable, but not the
one for the send/receive data corruption because it's quite a large change
(stable backport rules forbid such large changes).

I have sent test cases for xfstests for these corruption/data loss fixes
and the send regression (as well as for the scenario that the offending
commit fixed). They have all been merged upstream already:

  0e6ead559169260d0a2621ec22edcd0e63b84a88 btrfs/035: check for data loss
  ddb4e4cfccfa5fc36975c12e9a66a24d3b7829bd btrfs: test for cloning of inline extents
  be6122971fa08146ee531f84a7553aa15e2b63ec btrfs: test sending snapshots received from other filesystems
  a2bfff4d6cc85af4a6403371b38cf720447c8be9 btrfs: send/receive across different filesystems
  71d8215c197819bdccc3aa3658b59e09660133f9 btrfs: send with shared and compressed extents
  f1b304ab9796458a076c7e22ce983c5bef0f16f4 fstests: test btrfs send for reflinked files

Thanks.

The following changes since commit 6db4a7335dd701a0e20275440ee057d3db2a7ae3:

  Merge branch 'fix/waitqueue-barriers' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.4 (2015-10-12 16:24:40 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git integration-4.4

for you to fetch changes up to 5e6ecb362bd5950a3d8ce19c32829e4f8c7917d9:

  Btrfs: fix double range unlock of hole region when reading page (2015-10-14 04:37:00 +0100)

----------------------------------------------------------------
Filipe Manana (3):
      Btrfs: send, fix file corruption due to incorrect cloning operations
      Btrfs: fix file corruption and data loss after cloning inline extents
      Btrfs: fix double range unlock of hole region when reading page

Robin Ruede (1):
      btrfs: fix resending received snapshot with parent

 fs/btrfs/extent_io.c |   8 ++++--
 fs/btrfs/ioctl.c     | 195 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------
 fs/btrfs/send.c      | 210 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------
 3 files changed, 339 insertions(+), 74 deletions(-)

-- 
2.1.3

