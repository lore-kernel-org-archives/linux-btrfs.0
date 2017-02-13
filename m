Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37617 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750975AbdBMNue (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 08:50:34 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org, clm@fb.com
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] More GFP_NOFS removals
Date: Mon, 13 Feb 2017 14:50:04 +0100
Message-Id: <cover.1486993643.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A few more conversions to less strict allocation flags, calls originating from
an ioctl and with no chance of getting back with a lock already held. For 4.11.


The following changes since commit 2e94257a41fece589dc4bd737c70dc770e9040ef:

  btrfs: Better csum error message for data csum mismatch (2017-02-10 18:04:51 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/less-nofs

for you to fetch changes up to 8d310939a7d232fc71524fdf83f5a8fdbd5eb31c:

  btrfs: use GFP_KERNEL in btrfs_add/del_qgroup_relation (2017-02-13 13:11:29 +0100)

----------------------------------------------------------------
David Sterba (4):
      btrfs: use GFP_KERNEL in create_snapshot
      btrfs: use GFP_KERNEL in btrfs_read_qgroup_config
      btrfs: use GFP_KERNEL in btrfs_quota_enable
      btrfs: use GFP_KERNEL in btrfs_add/del_qgroup_relation

 fs/btrfs/ioctl.c  | 4 ++--
 fs/btrfs/qgroup.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)
