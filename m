Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24439 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab3A3J6R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 04:58:17 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 00/12 v5] Btrfs-progs: add show sub-command for btrfs subvol cli
Date: Wed, 30 Jan 2013 17:56:16 +0800
Message-Id: <1359539788-10667-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>

David,

 Please find this patch-set rebased with your integration-20130130 branch.

v4->v5:
	Fix a memory leak in the original code ref Patch 12/12
	Fix the compiler warning in the patch 9/12

Anand Jain (11):
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
  Btrfs-progs: Fix a small memory leak in managing the btrfs list filter

Wang Shilong (1):
  Btrfs-progs: filter the deleted subvolumes when listing snapshots

 btrfs-list.c     | 239 ++++++++++++++++++++++++++++++++++++-------------------
 btrfs-list.h     |  58 +++++++++++++-
 cmds-send.c      |  12 +--
 cmds-subvolume.c | 235 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 commands.h       |   4 +
 man/btrfs.8.in   |   6 ++
 6 files changed, 443 insertions(+), 111 deletions(-)

-- 
1.8.1.227.g44fe835

