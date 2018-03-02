Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60080 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1422764AbeCBSrM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 13:47:12 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5A4FAAE87
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Mar 2018 18:47:11 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 0/8] btrfs-progs: qgroups usability [corrected]
Date: Fri,  2 Mar 2018 13:46:56 -0500
Message-Id: <20180302184704.22399-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Hi all -

The following series addresses some usability issues with the qgroups UI.

1) Adds -W option so we can wait on a rescan completing without starting one.
2) Adds qgroup information to 'btrfs subvolume show'
3) Adds a -P option to show pathnames for first-level qgroups (or member
   of nested qgroups with -v)
4) Allows exporting the qgroup table in JSON format for use by external
   programs/scripts.

-Jeff

Jeff Mahoney (8):
  btrfs-progs: quota: Add -W option to rescan to wait without starting
    rescan
  btrfs-progs: qgroups: fix misleading index check
  btrfs-progs: constify pathnames passed as arguments
  btrfs-progs: qgroups: add pathname to show output
  btrfs-progs: qgroups: introduce and use info and limit structures
  btrfs-progs: qgroups: introduce btrfs_qgroup_query
  btrfs-progs: subvolume: add quota info to btrfs sub show
  btrfs-progs: qgroups: export qgroups usage information as JSON

 Documentation/btrfs-qgroup.asciidoc |   8 +
 Documentation/btrfs-quota.asciidoc  |  10 +-
 Makefile.inc.in                     |   4 +-
 chunk-recover.c                     |   4 +-
 cmds-device.c                       |   2 +-
 cmds-fi-usage.c                     |   6 +-
 cmds-qgroup.c                       |  49 +++-
 cmds-quota.c                        |  21 +-
 cmds-rescue.c                       |   4 +-
 cmds-subvolume.c                    |  46 ++++
 configure.ac                        |   6 +
 kerncompat.h                        |   1 +
 qgroup.c                            | 526 ++++++++++++++++++++++++++++++------
 qgroup.h                            |  22 +-
 send-utils.c                        |   4 +-
 utils.c                             |  22 +-
 utils.h                             |   2 +
 17 files changed, 621 insertions(+), 116 deletions(-)

-- 
2.15.1

