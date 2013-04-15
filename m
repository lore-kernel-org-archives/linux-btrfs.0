Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50448 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab3DOGh0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:37:26 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 00/11 v2] a bunch of miscellaneous bug fixes
Date: Mon, 15 Apr 2013 14:38:06 +0800
Message-Id: <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v1->v2:
	Accepts the review comments from David
	Accepts the review comments from Stefan
	Rebase changes
	Adds the 10/11 and 11/11 which was outside this patch-set

Anand Jain (11):
  btrfs-progs: root_item generation_v2 is out of sync after btrfsck
  btrfs-progs: no pending balance is not an error
  btrfs-progs: mkfs should first check all disks before writing to a
    disk
  btrfs-progs: cmd replace should check target-dev fully
  btrfs-progs: mkfs stdout print to match chronology
  btrfs-progs: check if btrfs kernel module is loaded
  btrfs-progs: delete unused function get_mountpt
  btrfs-progs: btrfs-select-super output is confusing when it fails
  btrfs-progs: fix btrfs scrub start help
  btrfs-progs: avoid ioctl for multipath-dev with its non-multipath path
  btrfs-progs: a copy of superblock is zero may not mean btrfs is not
    there

 btrfs-select-super.c |   6 +-
 cmds-balance.c       |  16 +++-
 cmds-device.c        |  60 ++++++++++----
 cmds-replace.c       |  23 +-----
 cmds-scrub.c         |   4 +-
 disk-io.c            |   9 ++-
 mkfs.c               | 219 ++++++++++++-------------------------------------
 root-tree.c          |  13 +++
 utils.c              | 225 ++++++++++++++++++++++++++++++++++++++++++---------
 utils.h              |   3 +-
 10 files changed, 327 insertions(+), 251 deletions(-)

-- 
1.8.1.227.g44fe835

