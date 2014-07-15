Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:40684 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaGOXHL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 19:07:11 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: viro@zeniv.linux.org.uk, clm@fb.com, jbacik@fb.com
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffm@suse.com, fdmanana@suse.com,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC 0/2] vfs / btrfs: add support for ustat()
Date: Tue, 15 Jul 2014 16:07:03 -0700
Message-Id: <1405465625-1122-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

ustat() does not work for btrfs, the reason is the VFS layer
cannot get to the super block from the anonymous bdevs. The
way these are used within btrfs though are to actually use a
series of them per superblock. This modifies the way the
VFS exposes these bdevs by pegging them onto the super
block on a linked list. This should also allow us to grow
the subdevices on the super block with any other information
that might be better suited underneath so that the VFS
layer is aware. If this approach is reasonable then perhaps
we should next remove the exported symbol for get_anon_bdev()
as btrfs was the only user.

Luis R. Rodriguez (2):
  fs/super.c: add new super block sub devices super_block_dev
  btrfs: use the new VFS super_block_dev

 fs/btrfs/ctree.h   |  7 ++---
 fs/btrfs/disk-io.c | 10 +++---
 fs/btrfs/inode.c   |  2 +-
 fs/super.c         | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h | 10 ++++++
 5 files changed, 106 insertions(+), 13 deletions(-)

-- 
2.0.1

