Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32851 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab3A1EE0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Jan 2013 23:04:26 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 00/10 v3] add show sub-command for btrfs subvol cli
Date: Mon, 28 Jan 2013 12:10:18 +0800
Message-Id: <1359346228-24804-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>

Here is the v3 of this patch-set, kindly review and accept.

v2->v3:
 . Accepts review comments from Eric.

Anand Jain (10):
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

 Makefile         |   4 +-
 btrfs-list.c     | 192 +++++++++++++++++++++++++++++++++++--------------------
 btrfs-list.h     |  58 ++++++++++++++++-
 btrfsctl.c       |   7 +-
 cmds-balance.c   |   1 +
 cmds-inspect.c   |   1 +
 cmds-qgroup.c    |   1 +
 cmds-quota.c     |   1 +
 cmds-send.c      |  12 ++--
 cmds-subvolume.c | 179 +++++++++++++++++++++++++++++++++++++++++++++++++--
 commands.h       |   7 +-
 common.c         |  46 -------------
 man/btrfs.8.in   |   6 ++
 utils.c          |  30 ++++++++-
 utils.h          |   5 +-
 15 files changed, 408 insertions(+), 142 deletions(-)
 delete mode 100644 common.c

-- 
1.8.1.227.g44fe835

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
