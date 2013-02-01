Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29799 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab3BAH6V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Feb 2013 02:58:21 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 00/13 v6] Btrfs-progs: add show sub-command for btrfs subvol cli
Date: Fri,  1 Feb 2013 15:56:19 +0800
Message-Id: <1359705392-7485-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David,

 Please find this v6 show patch-set for your integration-20130130 branch.

v5->v6:
	added
	[PATCH 13/13] Btrfs-progs: add subvol flags to print

Anand Jain (12):
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
  Btrfs-progs: add subvol flags to print

Wang Shilong (1):
  Btrfs-progs: filter the deleted subvolumes when listing snapshots

 btrfs-list.c     | 239 +++++++++++++++++++++++++++++++++++-------------------
 btrfs-list.h     |  58 +++++++++++++-
 cmds-send.c      |  12 +--
 cmds-subvolume.c | 240 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 commands.h       |   4 +
 man/btrfs.8.in   |   6 ++
 6 files changed, 448 insertions(+), 111 deletions(-)

-- 
1.8.1.227.g44fe835

