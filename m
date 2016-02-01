Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56528 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbcBANsf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 08:48:35 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs extent_same (dedup) ioctl fixes 
Date: Mon,  1 Feb 2016 13:48:23 +0000
Message-Id: <1454334503-7715-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

Please consider the following fixes for the extent_same ioctl. They fix
issues related to missing proper page and range locking, which lead to
invalid memory accesses and other unexpected failures (such as data
checksum validation failures, on perfectly healthy hardware, making
the ioctl fail with a non sense -ENOMEM error).
The last patch just removes a function not needed anymore after the two
fixes. I've tagged the two fixes for stable releases.
These were all previously sent to the mailing list.

Thanks.

The following changes since commit e410e34fad913dd568ec28d2a9949694324c14db:

  Revert "btrfs: synchronize incompat feature bits with sysfs files" (2016-01-29 08:19:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git extent_same_fixes

for you to fetch changes up to 30b809be1e150f91c5bbaf74d6a23bc81b37e2d9:

  Btrfs: remove no longer used function extent_read_full_page_nolock() (2016-01-30 17:54:25 +0000)

----------------------------------------------------------------
Filipe Manana (3):
      Btrfs: fix invalid page accesses in extent_same (dedup) ioctl
      Btrfs: fix page reading in extent_same ioctl leading to csum errors
      Btrfs: remove no longer used function extent_read_full_page_nolock()

 fs/btrfs/compression.c |   6 +-----
 fs/btrfs/extent_io.c   |  45 +++++++++++----------------------------------
 fs/btrfs/extent_io.h   |   3 ---
 fs/btrfs/ioctl.c       | 119 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------
 4 files changed, 109 insertions(+), 64 deletions(-)

-- 
2.7.0.rc3

