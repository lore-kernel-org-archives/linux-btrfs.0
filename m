Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:48425 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751533AbdIQWIC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 18:08:02 -0400
Received: by mail-it0-f49.google.com with SMTP id d123so6420694ith.3
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 15:08:01 -0700 (PDT)
Date: Sun, 17 Sep 2017 22:07:59 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo.btrfs@gmx.com, dsterba@suse.cz
Subject: [PATCH v2 0/1] Add qgroup_autoremove flag
Message-ID: <20170917220756.GA31512@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes it so level-0 qgroups are automatically deleted. The
flag that enables this behaviour is persisted in btrfs_qgroup_status_item.
Although, it may make sense to introduce a btrfs_qgroup_configuration_item,
it seems somewhat overkill to do that just for one simple knob that can
fit into the existing flags.

The reason why this is a sysfs knob, and not a mount option is because
qgroups have to be enabled after the first mount. Having to do a mount,
enable qgroups, flip the knob, and then remounting seems somewhat more
awkward than this single sysfs knob.

Changes since v1:
 * Move from mount option to sysfs knob
 * Persist the knob across remounts

Sargun Dhillon (1):
  btrfs: Add mechanism to configure automatic level-0 qgroup removal

 fs/btrfs/ctree.h                |  2 +-
 fs/btrfs/ioctl.c                | 14 +++++++
 fs/btrfs/sysfs.c                | 91 ++++++++++++++++++++++++++++++++++++-----
 include/uapi/linux/btrfs_tree.h |  7 ++++
 4 files changed, 103 insertions(+), 11 deletions(-)

-- 
2.11.0

