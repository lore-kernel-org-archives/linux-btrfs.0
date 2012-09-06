Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45341 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab2IFKsa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:48:30 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86AmTuc019711
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:48:29 +0800
Message-ID: <50487F6E.6060001@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:48:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V3 0/7 ] Btrfs-progs: enhance btrfs subvol list only to show
 read-only snapshots
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We want 'btrfs subvolume list' only to list readonly subvolumes, this patch set
introduces a new option 'r' to implement it.

You can use the command like that:

	btrfs subvolume list -r <mnt>

Changelog v2 -> v3:
- re-implement list_subvols()
- re-implement this read-only subvolume list function based on the new list_subvols()

Changelog v1 -> v2:
- address the comments from Goffredo Baroncelli
  i,   change the changelog of the patches and make them more elaborate.
  ii,  move the function declarations to a new head file.
  iii, add the introduction of the new option 'r' into the man page

We can pull the patches from the URL

	git://github.com/miaoxie/btrfs-progs.git master

This patchset is against the patches of Liu Bo, Anand Jain and mine which were sent by several
days ago. And we also can pull those patches from the above URL.

Thanks
Miao
---
Miao Xie (5):
      Btrfs-progs: fix compile warning of implicit declaration of "list_snapshots"
      Btrfs-progs: fix wrong usage of btrfs subvolume list command
      Btrfs-progs: fix wrong way to check if the root item contains otime and uuid
      Btrfs-progs: restructure list_subvolumes
      Btrfs-progs: enhance btrfs subvol list only to show read-only snapshots

Zhou Bo (2):
      Btrfs-progs: move the function declarations to a new head file
      Btrfs-progs: update the manpage entries for the btrfs subvolume list

 btrfs-list.c     |  931 ++++++++++++++++++++++++++++++------------------------
 btrfs-list.h     |   76 +++++
 cmds-inspect.c   |    6 +-
 cmds-subvolume.c |   82 ++++--
 ctree.h          |    2 +
 man/btrfs.8.in   |    5 +-
 send-utils.c     |    7 +-
 7 files changed, 669 insertions(+), 440 deletions(-)
