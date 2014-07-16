Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53756 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaGPViG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 17:38:06 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: viro@zeniv.linux.org.uk, clm@fb.com, jbacik@fb.com
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffm@suse.com, fdmanana@suse.com,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v2 0/2] vfs / btrfs: add support for ustat()
Date: Wed, 16 Jul 2014 14:37:56 -0700
Message-Id: <1405546678-7846-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This makes the implementation simpler by stuffing the struct on
the driver and just letting the driver iinsert it and remove it
onto the sb list. This avoids the kzalloc() completely.

Luis R. Rodriguez (2):
  fs/super.c: add new super block sub devices super_block_dev
  btrfs: use the new VFS super_block_dev

 fs/btrfs/ctree.h   |  7 ++----
 fs/btrfs/disk-io.c |  6 ++---
 fs/btrfs/inode.c   |  2 +-
 fs/super.c         | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h | 10 ++++++++
 5 files changed, 81 insertions(+), 12 deletions(-)

-- 
2.0.1

