Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:62740 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653Ab3EFTPR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 15:15:17 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Btrfs: wait for quota rescan to complete
Date: Mon,  6 May 2013 21:14:16 +0200
Message-Id: <1367867657-4630-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Two small patches, one for the kernel and one for the user mode. Both
required to support waiting for quota rescan to complete.

Jan Schmidt (1):
  Btrfs: add ioctl to wait for qgroup rescan completion

 fs/btrfs/ctree.h           |    2 ++
 fs/btrfs/ioctl.c           |   12 ++++++++++++
 fs/btrfs/qgroup.c          |   21 +++++++++++++++++++++
 include/uapi/linux/btrfs.h |    1 +
 4 files changed, 36 insertions(+), 0 deletions(-)


Jan Schmidt (2):
  Btrfs-progs: fixup: add flags to struct btrfs_ioctl_quota_rescan_args
  Btrfs-progs: added "btrfs quota rescan" -w switch (wait)

 cmds-quota.c |   19 +++++++++++++++++--
 ioctl.h      |    2 ++
 2 files changed, 19 insertions(+), 2 deletions(-)
