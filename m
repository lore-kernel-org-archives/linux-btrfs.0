Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43378 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab3GOF0H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 01:26:07 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 00/11 v2 (resend)] btrfs-progs: coalesce of patches
Date: Mon, 15 Jul 2013 13:30:46 +0800
Message-Id: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 This is the rebased patch set, rebased on top of the
 integration-20130710

 Dropped 
	btrfs-progs: obtain used_bytes in BTRFS_IOC_FS_INFO ioctl
 Introduced
	btrfs-progs: move out print in cmd_df to another function
	btrfs-progs: get string for the group profile and type

 (These changes were needed as part of show --kernel support,
 with out introducing new ioctl)

Anand Jain (11):
  btrfs-progs: btrfs_scan_for_fsid doesn't need all the arguments
  btrfs-progs: label option in btrfs filesystem show is not coded
  btrfs-progs: update device scan usage
  btrfs-progs: congregate dev scan
  btrfs-progs: btrfs_scan_one_dir not to skip links when /dev/mapper is
    provided
  btrfs-progs: scan /dev/mapper in filesystem show and device scan
  btrfs-progs: device delete to get errors from the kernel
  btrfs-progs: get_label_mounted to return label instead of print
  btrfs-progs: move out print in cmd_df to another function
  btrfs-progs: get string for the group profile and type
  btrfs-progs: introduce btrfs filesystem show --kernel

 btrfs-find-root.c |    2 +-
 cmds-device.c     |   29 +++--
 cmds-filesystem.c |  349 ++++++++++++++++++++++++++++++++++++++++-------------
 ctree.h           |   11 ++
 disk-io.c         |    2 +-
 ioctl.h           |   43 +++++++-
 man/btrfs.8.in    |   15 ++-
 utils.c           |   56 +++++++--
 utils.h           |   10 +-
 9 files changed, 395 insertions(+), 122 deletions(-)

-- 
1.7.7.6

