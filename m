Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:18195 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab3DELid (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Apr 2013 07:38:33 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] Btrfs: quota rescan for 3.10
Date: Fri,  5 Apr 2013 13:38:15 +0200
Message-Id: <1365161897-19448-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The kernel side for rescan, which is needed if you want to enable qgroup
tracking on a non-empty volume.

User space patches to come.

Jan Schmidt (2):
  Btrfs: rescan for qgroups
  Btrfs: automatic rescan after "quota enable" command

 fs/btrfs/ctree.h           |   17 ++-
 fs/btrfs/disk-io.c         |    6 +
 fs/btrfs/ioctl.c           |   83 +++++++++++--
 fs/btrfs/qgroup.c          |  281 ++++++++++++++++++++++++++++++++++++++++++--
 include/uapi/linux/btrfs.h |   11 ++-
 5 files changed, 364 insertions(+), 34 deletions(-)

