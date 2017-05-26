Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:35637 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944930AbdEZUoU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 16:44:20 -0400
Received: by mail-it0-f41.google.com with SMTP id c15so2978752ith.0
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 13:44:19 -0700 (PDT)
From: Sargun Dhillon <sargun@sargun.me>
Date: Fri, 26 May 2017 20:44:17 +0000
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, mkh@rqc.ru
Subject: [PATCH v2 0/4] Qgroup uapi improvements
Message-ID: <20170526204414.GA18176@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset has several improvements around the qgroups user-facing
API. It introduces two new ioctls for creating, and removing qgroups.
These ioctls have a new args structure that allows passing flags, and
some reserved fields for future expansion. The ioctls prevent some
operations around level-0 qgroups as well.

The create operation prevents the creation of level-0 qgroups for
subvolumes that do not exist. The delete operations prevents the
deletion of level-0 qgroups that reference active volumes.

In adddition, it adds a mount option "qgroup_auto_cleanup".
When this mount option is specified, qgroups will automatically
be cleaned up at volume deletion time. The reason this is a mount
option over a default behaviour is to avoid breaking old scripts
that rely on the behaviour of the existing APIs. Users can opt
into the new behaviour, as opposed it being an automated
trigger on newly created qgroups. Later on, we can introduce
a flag to subvol / qgroup create that marks the qgroup as
automatically created, and delete the qgroup as automatically
as well.

Changes since v1:
  * Remove creation of level-0 qgroups without subvol
  * Add deprecation message for old API

Sargun Dhillon (4):
  btrfs: Fail on removing qgroup if del_qgroup_item fails
  btrfs: Add new ioctl uapis for qgroup creation / removal
  btrfs: Warn the user when the legacy btrfs_qgroup_create API is used
  btrfs: Add qgroup_auto_cleanup mount flag to automatically cleanup
    qgroups

 fs/btrfs/ctree.h           |   1 +
 fs/btrfs/ioctl.c           | 117 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/qgroup.c          |  79 ++++++++++++++++++++++++++++--
 fs/btrfs/qgroup.h          |   6 ++-
 fs/btrfs/super.c           |  15 +++++-
 include/uapi/linux/btrfs.h |  22 +++++++++
 6 files changed, 230 insertions(+), 10 deletions(-)

-- 
2.9.3

