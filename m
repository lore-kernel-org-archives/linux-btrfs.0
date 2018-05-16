Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52641 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751132AbeEPVjD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 17:39:03 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E32BAAF3E
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 21:39:01 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH v3 00/18] btrfs-progs: qgroups-usability
Date: Wed, 16 May 2018 17:38:33 -0400
Message-Id: <20180516213851.10196-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Changes since v2:
- Updated Reviewed-by tags were provided.
- Fixed the typoed commands that I commented on in the previous posting.
- Dropped the btrfs_cleanup_root_info since it's unnecessary with the
  switch to libbtrfsutil.
- Updated the qgroups pathname patch to use libbtrfsutil
- Added a mini-filter to skip dead qgroups in 'qgroup show' output
  unless -v is specified.

The most notable change is that this posting doesn't include the JSON
format patches since there was still some open discussion there.  The
plumbing for passing global options around to commands is there, so we
really just need to decide on how we want to handle alternative formats.
For some commands, the formatting library that coreutils uses will
probably work but for qgroups show to represent nested groups, it's
unsuitable.

I've also posted this as a pull request to the devel branch:

https://github.com/kdave/btrfs-progs/pull/139

Jeff Mahoney (18):
  btrfs-progs: quota: Add -W option to rescan to wait without starting
    rescan
  btrfs-progs: qgroups: fix misleading index check
  btrfs-progs: constify pathnames passed as arguments
  btrfs-progs: btrfs-list: add rb_entry helpers for root_info
  btrfs-progs: qgroups: add pathname to show output
  btrfs-progs: qgroups: introduce and use info and limit structures
  btrfs-progs: qgroups: introduce btrfs_qgroup_query
  btrfs-progs: subvolume: add quota info to btrfs sub show
  btrfs-progs: help: convert ints used as bools to bool
  btrfs-progs: reorder placement of help declarations for send/receive
  btrfs-progs: filesystem balance: split out special handling
  btrfs-progs: use cmd_struct as command entry point
  btrfs-progs: pass cmd_struct to command callback function
  btrfs-progs: pass cmd_struct to clean_args_no_options{,_relaxed}
  btrfs-progs: pass cmd_struct to usage()
  btrfs-progs: add support for output formats
  btrfs-progs: handle command groups directly for common case
  btrfs-progs: qgroups: don't print dead qgroups

 Documentation/btrfs-qgroup.asciidoc |   4 +
 Documentation/btrfs-quota.asciidoc  |  10 +-
 btrfs-list.c                        |  30 ++-
 btrfs.c                             | 174 +++++++++++-----
 check/main.c                        |  10 +-
 chunk-recover.c                     |   4 +-
 cmds-balance.c                      |  74 ++++---
 cmds-device.c                       |  96 +++++----
 cmds-fi-du.c                        |  11 +-
 cmds-fi-usage.c                     |  17 +-
 cmds-filesystem.c                   | 113 +++++++----
 cmds-inspect-dump-super.c           |  11 +-
 cmds-inspect-dump-tree.c            |  11 +-
 cmds-inspect-tree-stats.c           |  11 +-
 cmds-inspect.c                      |  78 ++++----
 cmds-property.c                     |  55 +++---
 cmds-qgroup.c                       | 107 ++++++----
 cmds-quota.c                        |  63 +++---
 cmds-receive.c                      |  70 +++----
 cmds-replace.c                      |  45 +++--
 cmds-rescue.c                       |  60 +++---
 cmds-restore.c                      |  12 +-
 cmds-scrub.c                        |  64 +++---
 cmds-send.c                         |  74 +++----
 cmds-subvolume.c                    | 163 ++++++++++-----
 commands.h                          | 152 ++++++++------
 help.c                              |  98 ++++++---
 help.h                              |  14 +-
 kerncompat.h                        |   1 +
 qgroup.c                            | 384 +++++++++++++++++++++++++++---------
 qgroup.h                            |  19 +-
 31 files changed, 1325 insertions(+), 710 deletions(-)

-- 
2.15.1

