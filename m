Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:36573 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbdEKVRE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 17:17:04 -0400
Received: by mail-it0-f44.google.com with SMTP id o5so590421ith.1
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 14:17:03 -0700 (PDT)
Date: Thu, 11 May 2017 21:17:01 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, quwenruo@cn.fujitsu.com
Subject: [PATCH v2 0/2] btrfs: allow mechanism to override quota
Message-ID: <20170511211658.GA8401@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset makes it so that on a per-filesystem basis one can disable
quota enforcement for users with cap_sys_resource. This patchset can
likely later be extended to per-qgroup, or a per-volume basis. I'm
thinking of extending the sysfs interface to list the qgroups and
this same interface for the qgroups themselves.

Changes since v1:
  -Rather than a separate member of btrfs_fs_info, use the existing
   flags field

Sargun Dhillon (2):
  btrfs: add quota override flag to enable quota override for
    sys_resource
  btrfs: Add quota_override knob into sysfs

 fs/btrfs/ctree.h  |  2 ++
 fs/btrfs/qgroup.c |  5 +++++
 fs/btrfs/sysfs.c  | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

-- 
2.9.3

