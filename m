Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbbLCQxj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 11:53:39 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PULL][PATCH 0/3] GFP flags adjustments
Date: Thu,  3 Dec 2015 17:51:48 +0100
Message-Id: <cover.1449160585.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Part of the planned memory allocation / error handling updates, a lightweight
start.  We don't need to use GFP_NOFS everywhere, this flag should protect
against looping back to the filesystem in certain allocation contexts. GFP_KERNEL
is safe in functions started eg. from userspace (like the ioctls) or for
mount-time allocations. For 4.5, please pull.

----------------------------------------------------------------
The following changes since commit 1ec218373b8ebda821aec00bb156a9c94fad9cd4:

  Linux 4.4-rc2 (2015-11-22 16:45:59 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/gfp-flags

for you to fetch changes up to 39a27ec1004e886f1d949bdb8f2616896d02c5c2:

  btrfs: use GFP_KERNEL for xattr and acl allocations (2015-12-03 15:03:44 +0100)

----------------------------------------------------------------
David Sterba (3):
      btrfs: use GFP_KERNEL for allocations in ioctl handlers
      btrfs: use GFP_KERNEL for allocations of workqueues
      btrfs: use GFP_KERNEL for xattr and acl allocations

 fs/btrfs/acl.c          |  4 ++--
 fs/btrfs/async-thread.c |  4 ++--
 fs/btrfs/ioctl.c        | 10 +++++-----
 fs/btrfs/xattr.c        |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)
