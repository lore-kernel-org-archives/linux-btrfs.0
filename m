Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:36801 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755544AbdETIib (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 May 2017 04:38:31 -0400
Received: by mail-it0-f53.google.com with SMTP id o5so130126136ith.1
        for <linux-btrfs@vger.kernel.org>; Sat, 20 May 2017 01:38:31 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id s96sm4931183ioi.14.2017.05.20.01.38.30
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 May 2017 01:38:30 -0700 (PDT)
Date: Sat, 20 May 2017 08:38:28 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/8] BtrFS: QGroups uapi improvements
Message-ID: <20170520083826.GA4176@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset contains some improvements to qgroups. It changes the
semantics around how qgroups are dealt with when subvolumes are
deleted, and it also adds two new ioctls for qgroup deletion
and addition.

The new semantic around qgroup removal is that when the qgroup_nokeep
mount flag is set, it when a subvolume is deleted, the associated
level-0 qgroup will also be removed. This does not trickle up to
high level qgroups.

In addition, it adds two new ioctls for qgroup addition and removal
which have flags to protect against creating qgroups for non-existent
volumes, and in addition flags to prevent the deletion of qgroups
that are associated with volumes.

Sargun Dhillon (8):
  btrfs: Split up btrfs_remove_qgroup, no logic changes
  btrfs: Fail on removing qgroup if del_qgroup_item fails
  btrfs: Split up btrfs_create_qgroup, no logic changes
  btrfs: autoremove qgroup by default, and add a mount flag to override
  btrfs: qgroup.h whitespace change
  btrfs: Add code to check if a qgroup's subvol exists
  btrfs: Add code to prevent qgroup creation for a non-existent subvol
  btrfs: Add new ioctl uapis for qgroup creation / removal

 fs/btrfs/ctree.h           |   1 +
 fs/btrfs/ioctl.c           | 116 ++++++++++++++++++++++++++++++++++++-
 fs/btrfs/qgroup.c          | 140 ++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/qgroup.h          |   6 +-
 fs/btrfs/super.c           |  16 +++++-
 include/uapi/linux/btrfs.h |  23 ++++++++
 6 files changed, 264 insertions(+), 38 deletions(-)

-- 
2.9.3

