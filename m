Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49179 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3AWIGw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 03:06:52 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 00/10] add show sub-command for btrfs subvol cli
Date: Wed, 23 Jan 2013 16:12:41 +0800
Message-Id: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David, Gene

Please accept this patch set which is on top of
  git://repo.or.cz/btrfs-progs-unstable/devel.git for-chris

to add 'show' sub-command feature for the btrfs subvol cli
as in an example below..

eg:
btrfs su list /mnt
ID 256 gen 54 top level 5 path sv1
ID 278 gen 56 top level 5 path sv1/snap1
ID 279 gen 54 top level 5 path sv2
ID 280 gen 41 top level 5 path sv2/snap1

btrfs su show /mnt/sv1
/mnt/sv1
	Name: 			sv1
	uuid: 			3a914db2-8a40-1e49-9382-126c595e9abf
	Parent uuid: 		-
	Creation time: 		2013-01-10 12:16:18
	Object ID: 		256
	Generation (Gen): 	54
	Gen at creation: 	5
	Parent: 		5
	Top Level: 		5
	Snapshot(s):
				snap1
				<FS_TREE>/sv2/snap_sv1

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
 btrfs-list.c     | 190 +++++++++++++++++++++++++++++++++-------------------
 btrfs-list.h     |  58 +++++++++++++++-
 btrfsctl.c       |   7 +-
 cmds-balance.c   |   1 +
 cmds-inspect.c   |   1 +
 cmds-qgroup.c    |   1 +
 cmds-quota.c     |   1 +
 cmds-send.c      |  12 ++--
 cmds-subvolume.c | 200 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 commands.h       |   7 +-
 common.c         |  46 -------------
 man/btrfs.8.in   |   6 ++
 utils.c          |  30 ++++++++-
 utils.h          |   3 +
 15 files changed, 428 insertions(+), 139 deletions(-)
 delete mode 100644 common.c

-- 
1.8.1.227.g44fe835

