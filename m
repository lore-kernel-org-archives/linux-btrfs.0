Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60572 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935152AbeCHClC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 21:41:02 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B11F5AE67
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 02:41:00 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH v2 00/20] btrfs-progs: qgroups usability
Date: Wed,  7 Mar 2018 21:40:27 -0500
Message-Id: <20180308024047.10104-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Thanks to Qu Wenruo, Nikolay Borisov, and Tomohiro Misono for taking
the time to review my previous patchset.  I've incorporated your
suggestions into this version.

Obviously this one is quite a bit longer than the first version.  After
I posted it, Dave and I talked offline about whether it would make sense
to add the ability to output in JSON to other commands.  If it does,
and we agreed that it did, it would make sense for the choice of format
to be a global option.  In order to do that, I've had to rework some of
how we handle command definition and execution.  Mostly that is around
how to pass format flags and how to inform the user about which output
formats are available for each command.

So, here's the updated series:

* btrfs-progs: quota: Add -W option to rescan to wait without starting
  rescan
  - unchanged

* btrfs-progs: qgroups: fix misleading index check
  - unchanged

* btrfs-progs: constify pathnames passed as arguments
  - removed stray formatting change in send-utils.c

* btrfs-progs: btrfs-list: add rb_entry helpers for root_info
  - new patch, accessors for root_info rb_nodes

* btrfs-progs: btrfs-list: add btrfs_cleanup_root_info
  - new patch, adds a helper to clean up strings attached to root_info

* btrfs-progs: qgroups: add pathname to show output
  - Fixed help text to be more accurate
  - Fixed coding style issues
  - Added checks for NULL pathname
  - Free root_info strings after looking up pathname
  - Free pathname during teardown

* btrfs-progs: qgroups: introduce and use info and limit structures
  - edited to 80 columns

* btrfs-progs: qgroups: introduce btrfs_qgroup_query
  - Fixed issue with ENOENT vs ENOTTY
  - Added filter for search results
  - Use temporary key for search header
  - Cache passed search key for comparison since the loop modifies it

* btrfs-progs: subvolume: add quota info to btrfs sub show
  - Fixed/improved error reporting

* btrfs-progs: help: convert ints used as bools to bool
  - new patch

* btrfs-progs: reorder placement of help declarations for send/receive
  - new patch, required to remove usage declarations from commands.h

* btrfs-progs: filesystem balance: split out special handling
  - new patch, stop directly aliasing 'filesystem balance' to
    'balance' -- it still does the right thing for normal execution
    but help says "go read the balance help instead"

* btrfs-progs: use cmd_struct as command entry point
  - new patch, removes most command callback and usage declarations
  - replaces with cmd_struct declarations that are used in command
    group arrays directly, similar to how sysfs attributes are
    defined

* btrfs-progs: pass cmd_struct to command callback function
  - new patch, required to pass flags and have access to usage array

* btrfs-progs: pass cmd_struct to clean_args_no_options{,_relaxed}
  - new patch, required to pass cmd_struct to usage()

* btrfs-progs: pass cmd_struct to usage()
  - new patch, required to dynamically print what output formats
    are available based on flags defined in command

* btrfs-progs: add support for output formats
  - new patch, adds infrastructure for output formats, including passing
    caller context to commands

* btrfs-progs: add generic support for json output
  - new patch, split out JSON library detection from qgroups patch

* btrfs-progs: handle command groups directly for common case
  - new patch, remove most simple command group callbacks

* btrfs-progs: qgroups: add json output for usage command
  - remove -j and --compat-json options in favor of global --format json
    or --format json:compat
  - added macro for qgroupid format buffer length
  - handle NULL pathnames better

-Jeff

Jeff Mahoney (20):
  btrfs-progs: quota: Add -W option to rescan to wait without starting
    rescan
  btrfs-progs: qgroups: fix misleading index check
  btrfs-progs: constify pathnames passed as arguments
  btrfs-progs: btrfs-list: add rb_entry helpers for root_info
  btrfs-progs: btrfs-list: add btrfs_cleanup_root_info
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
  btrfs-progs: add generic support for json output
  btrfs-progs: qgroups: add json output for usage command
  btrfs-progs: handle command groups directly for common case

 Documentation/btrfs-qgroup.asciidoc |   7 +
 Documentation/btrfs-quota.asciidoc  |  10 +-
 Makefile.inc.in                     |   4 +-
 btrfs-calc-size.c                   |   5 +-
 btrfs-debug-tree.c                  |   6 +-
 btrfs-list.c                        |  48 ++-
 btrfs-list.h                        |   1 +
 btrfs-show-super.c                  |   6 +-
 btrfs.c                             | 174 ++++++++---
 check/main.c                        |  10 +-
 chunk-recover.c                     |   4 +-
 cmds-balance.c                      |  74 +++--
 cmds-device.c                       |  96 +++---
 cmds-fi-du.c                        |  11 +-
 cmds-fi-usage.c                     |  17 +-
 cmds-filesystem.c                   | 113 ++++---
 cmds-inspect-dump-super.c           |  11 +-
 cmds-inspect-dump-tree.c            |  11 +-
 cmds-inspect-tree-stats.c           |  11 +-
 cmds-inspect.c                      |  78 ++---
 cmds-property.c                     |  55 ++--
 cmds-qgroup.c                       | 125 +++++---
 cmds-quota.c                        |  63 ++--
 cmds-receive.c                      |  70 +++--
 cmds-replace.c                      |  45 +--
 cmds-rescue.c                       |  60 ++--
 cmds-restore.c                      |  12 +-
 cmds-scrub.c                        |  64 ++--
 cmds-send.c                         |  74 ++---
 cmds-subvolume.c                    | 167 +++++++---
 commands.h                          | 165 ++++++----
 configure.ac                        |   6 +
 help.c                              | 121 +++++---
 help.h                              |  15 +-
 kerncompat.h                        |   1 +
 qgroup.c                            | 601 ++++++++++++++++++++++++++++++------
 qgroup.h                            |  25 +-
 utils.c                             |  23 +-
 utils.h                             |   2 +
 39 files changed, 1647 insertions(+), 744 deletions(-)

-- 
2.12.3

