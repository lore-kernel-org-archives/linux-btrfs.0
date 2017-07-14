Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:37765 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754178AbdGNPMU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 11:12:20 -0400
Received: by mail-it0-f48.google.com with SMTP id m84so26713717ita.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 08:12:20 -0700 (PDT)
Date: Fri, 14 Jul 2017 15:12:06 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, quwenruo@cn.fujitsu.com
Subject: [PATCH v3 0/2] New qgroup creation / removal ioctls
Message-ID: <cover.1499941625.git.sargun@sargun.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduces two new ioctls for creating, and removing qgroups.
These ioctls have a new args structure that allows passing flags, and
some reserved fields for future expansion. The ioctls prevent some
operations around level-0 qgroups as well.


The create operation prevents the creation of level-0 qgroups for
subvolumes that do not exist. The delete operations prevents the
deletion of level-0 qgroups that reference active volumes.

There are two different ioctl for creation, and deletion to enable
filtering of the ioctls via tools like seccomp-bpf. Currently, there
is one "swiss-army" ioctl that's multiplexed for creation, and
deletion, and you need to be able to dereference user memory to determine
whether or not it's a destructive operation -- something that cannot
be done via seccomp nor LSMs.

Changes since v2:
  * Use a common datastructure for removal and creation
  * Remove deprecation message for old API
Changes since v1:
  * Remove creation of level-0 qgroups without subvol

Sargun Dhillon (2):
  btrfs: Fail on removing qgroup if del_qgroup_item fails
  btrfs: Add new ioctl uapis for qgroup creation / removal

 fs/btrfs/ioctl.c           | 100 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/qgroup.c          |  79 ++++++++++++++++++++++++++++++++---
 fs/btrfs/qgroup.h          |   6 ++-
 include/uapi/linux/btrfs.h |  16 ++++++++
 4 files changed, 192 insertions(+), 9 deletions(-)

-- 
2.9.3

