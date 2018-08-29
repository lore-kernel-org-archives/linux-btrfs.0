Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40492 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727204AbeH2McE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 08:32:04 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 35626AF3B
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 08:36:16 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/2] FSID change kernel support
Date: Wed, 29 Aug 2018 11:36:12 +0300
Message-Id: <1535531774-29830-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is the kernel support for another level of indirection when dealing with 
FSID. I've taken inspiration from XFS so if people are familiar how FSID is 
changed there it's identical in BTRFS. In short, another field is introduced
which will record the original fsid (which is stamped into every metadata block
on-disk) if the user chooses to change it. This enables filesytems to have 
arbitrary user-visible UUIDS but immutable on-disk UUIDs. 

The first patch adjusts the kernel code to cope with this by adding an incompat
flag and introducing a new field to the on-disk super block. This means old
kernels will not be able to mount fsid-changed filesystems. Additionally, 
the device scanning logic is modified so that now devices are being 
matched for fsid && metadata_uuid when added to the system. This handles 
scenarios where two filesystems with identical on-disk metadata uuids (but 
different user-visible fsids) exist on the same machine. 

The second patch just removes some duplication of the fsid/metadata_uuid fields
since they were copied in both btrfs_fs_info and btrfs_fs_devices structs. 

Those patches survived multiple xfstest runs so I think they should be pretty 
solid. Please review and give them a spin. 

Nikolay Borisov (2):
  btrfs: Introduce support for FSID change without metadata rewrite
  btrfs: Remove fsid/metadata_fsid fields from btrfs_info

 fs/btrfs/check-integrity.c   |  2 +-
 fs/btrfs/ctree.c             |  5 +--
 fs/btrfs/ctree.h             | 10 +++---
 fs/btrfs/disk-io.c           | 39 ++++++++++++++++++-----
 fs/btrfs/extent-tree.c       |  2 +-
 fs/btrfs/ioctl.c             |  2 +-
 fs/btrfs/super.c             |  2 +-
 fs/btrfs/volumes.c           | 74 ++++++++++++++++++++++++++++++++++----------
 fs/btrfs/volumes.h           |  1 +
 include/trace/events/btrfs.h |  2 +-
 include/uapi/linux/btrfs.h   |  1 +
 11 files changed, 104 insertions(+), 36 deletions(-)

-- 
2.7.4
