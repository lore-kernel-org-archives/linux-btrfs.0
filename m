Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21957 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3A2GmA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 01:42:00 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 00/12 v4] add show sub-command for btrfs subvol cli
Date: Tue, 29 Jan 2013 14:48:49 +0800
Message-Id: <1359442141-25498-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>

Here is the v4 of this patch-set, kindly review and accept.

v3->v4:
 . Included a patch from Wang Shilong
 . Added the changes to be inline with the above patch

Anand Jain (11):
  Btrfs-progs: move open_file_or_dir() to utils.c
  Btrfs-progs: move printing subvol list outside of btrfs_list_subvols
  Btrfs-progs: add parent uuid for snapshots
  Btrfs-progs: move struct root_info to btrfs-list.h
  Btrfs-progs: add function btrfs_get_subvol to get root_info of a
    subvol
  Btrfs-progs: add method to filter snapshots by parent uuid
  Btrfs-progs: put find_mount_root() in commands.h
  Btrfs-progs: make printing subvol extensible to newer layouts
  Btrfs-progs: make get_subvol_name non cmds-send specific
  Btrfs-progs: add show subcommand to subvol cli
  Btrfs-progs: update btrfs_get_subvol to be inline with resolve_root
    ret changes

Wang Shilong (1):
  Btrfs-progs: filter the deleted subvolumes when listing snapshots

 Makefile         |   4 +-
 btrfs-list.c     | 239 ++++++++++++++++++++++++++++++++++++-------------------
 btrfs-list.h     |  58 +++++++++++++-
 btrfsctl.c       |   7 +-
 cmds-balance.c   |   1 +
 cmds-inspect.c   |   1 +
 cmds-qgroup.c    |   1 +
 cmds-quota.c     |   1 +
 cmds-send.c      |  12 +--
 cmds-subvolume.c | 179 ++++++++++++++++++++++++++++++++++++++++-
 commands.h       |   7 +-
 common.c         |  46 -----------
 man/btrfs.8.in   |   6 ++
 utils.c          |  30 ++++++-
 utils.h          |   5 +-
 15 files changed, 445 insertions(+), 152 deletions(-)
 delete mode 100644 common.c

-- 
1.8.1.227.g44fe835

