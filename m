Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34982 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752937AbeE1CSV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 May 2018 22:18:21 -0400
Received: by mail-io0-f194.google.com with SMTP id g1-v6so12489158iob.2
        for <linux-btrfs@vger.kernel.org>; Sun, 27 May 2018 19:18:21 -0700 (PDT)
From: Howard McLauchlan <linux@hmclauchlan.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH v2 0/6] btrfs send stream version 2
Date: Sun, 27 May 2018 22:14:29 -0400
Message-Id: <20180528021443.13923-1-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is v2 of send stream version 2. The goal is to provide proper
versioning/compatibility as new features are implemented. v1 can be found here
[1].

v2 adds BTRFS_SEND_C_WRITE_COMPRESSED to patch 1 and style fixes/logic
simplifications to patches 5,6.

v2 also updates btrfs-progs to reflect BTRFS_SEND_C_WRITE_COMPRESSED and updates
the pertinent xfstests to also test the total size command.

As of 4.17-rc7, these changes pass all "send" group xfstests

Cheers,

1: https://patchwork.kernel.org/patch/10388003/

Filipe David Borba Manana (5):
  btrfs: send, bump stream version
  btrfs: send, implement total data size command to allow for progress
    estimation
  btrfs: send, use fallocate command to punch holes
  btrfs: send, use fallocate command to allocate extents
  btrfs: add send_stream_version attribute to sysfs

Howard McLauchlan (1):
  btrfs: add chattr support for send/receive

 fs/btrfs/ctree.h           |   2 +
 fs/btrfs/ioctl.c           |   2 +-
 fs/btrfs/send.c            | 495 +++++++++++++++++++++++++++++++------
 fs/btrfs/send.h            |  27 +-
 fs/btrfs/sysfs.c           |  27 ++
 include/uapi/linux/btrfs.h |  21 +-
 6 files changed, 493 insertions(+), 81 deletions(-)

-- 
2.17.0

