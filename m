Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:48531 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754202AbcJML1X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 07:27:23 -0400
From: ethanwu <ethanwu@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: ethanwu <ethanwu@synology.com>
Subject: [PATCH 0/2] btrfs-progs: check: Handle drop_progress correctly for deleted subvolume
Date: Thu, 13 Oct 2016 19:09:47 +0800
Message-Id: <1476356989-23131-1-git-send-email-ethanwu@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchsets fixes 2 problems in checking deleted subvolume.

First, there are cases missing in checking drop_key, this add up the missing cases,
so the skipping flow could work correctly.

Second, the drop key is only applied to subvolume tree. This should be applied to the
corresponding relocation tree of the deleted subvolume as well.

ethanwu (2):
  btrfs-progs: check: skip keys prior to drop key in deleted subvolume
    correctly
  btrfs-progs: check: add drop key to relocation tree

 cmds-check.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 62 insertions(+), 4 deletions(-)

-- 
1.9.1

