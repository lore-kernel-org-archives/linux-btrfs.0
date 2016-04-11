Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbcDKRfG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 13:35:06 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 81931AC73
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2016 17:35:02 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/6] Add more vmalloc fallbacks to memory allocations
Date: Mon, 11 Apr 2016 19:31:27 +0200
Message-Id: <cover.1460394967.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

inspired by a recent fix where we tried to kmalloc a 64k nodesize buffer,
without the vmalloc fallback, and failed. This series add the "kmalloc-first
and vmalloc-fallback" logic to more places, namely to the buffers used during
send.  If the memory is not fragmented, kmalloc succeeds and does not take the
resources required for the mappings.

----------------------------------------------------------------
The following changes since commit 56f23fdbb600e6087db7b009775b95ce07cc3195:

  Btrfs: fix file/data loss caused by fsync after rename and new inode (2016-04-06 17:01:44 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/kvalloc

for you to fetch changes up to c3e3930516c4d14ed1d6d70964fbc4f3faa36844:

  btrfs: clone: use vmalloc only as fallback for nodesize bufer (2016-04-11 19:06:39 +0200)

----------------------------------------------------------------
David Sterba (6):
      btrfs: send: use vmalloc only as fallback for send_buf
      btrfs: send: use vmalloc only as fallback for read_buf
      btrfs: send: use temporary variable to store allocation size
      btrfs: send: use vmalloc only as fallback for clone_roots
      btrfs: send: use vmalloc only as fallback for clone_sources_tmp
      btrfs: clone: use vmalloc only as fallback for nodesize bufer

 fs/btrfs/ioctl.c | 13 ++++++++-----
 fs/btrfs/send.c  | 56 +++++++++++++++++++++++++++++++++++---------------------
 2 files changed, 43 insertions(+), 26 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
