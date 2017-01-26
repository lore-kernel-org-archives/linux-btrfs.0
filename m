Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:35620 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752061AbdAZBHU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 20:07:20 -0500
Received: by mail-pg0-f47.google.com with SMTP id 194so68679469pgd.2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 17:07:20 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Murphy <lists@colorremedies.com>,
        Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 0/3] Btrfs: disable xattr operations on subvolume directories
Date: Wed, 25 Jan 2017 17:06:37 -0800
Message-Id: <cover.1485392101.git.osandov@fb.com>
In-Reply-To: <c96f9f4d14c7a40913a39856ca8f065d37113372.1485311744.git.osandov@fb.com>
References: <c96f9f4d14c7a40913a39856ca8f065d37113372.1485311744.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

This series is based on v4.10-rc4. It should probably go in for v4.10
and to stable for v4.9.x.

Changes from v1:

- Added patch 1 to remove an obsolete place where we use
  btrfs_dir_ro_inode_operations since the fix in patch 2 concerns
  btrfs_dir_ro_inode_operations.
- Added patch 3. It's mostly a cleanup, but I can't convince myself that
  there aren't any in-kernel callers that will change ACLs directly.
  Let's get this in just to be safe.

There are some more followup cleanups to do here, but let's get this fix
in first.

Omar Sandoval (3):
  Btrfs: remove old tree_root case in btrfs_read_locked_inode()
  Btrfs: disable xattr operations on subvolume directories
  Btrfs: remove ->{get,set}_acl() from btrfs_dir_ro_inode_operations

 fs/btrfs/inode.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

-- 
2.11.0

