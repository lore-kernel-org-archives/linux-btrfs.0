Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63896 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933943AbaEFGcL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 02:32:11 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Anand Jain <Anand.Jain@oracle.com>
Subject: [RFC PATCH 0/2] Kernel space btrfs missing device detection.
Date: Tue, 6 May 2014 14:33:11 +0800
Message-ID: <1399357993-9254-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Original btrfs will not detection any missing device since there is no
notification mechanism for fs layer to detect missing device in block layer.

However we don't really need to notify fs layer upon dev remove, probing in
dev_info/rm_dev ioctl is good enough since they are the only two ioctls caring
about missing device.

This patchset will do ioctl time missing dev detection and return device missing
status in dev_info ioctl using a new member in btrfs_ioctl_dev_info_args with a
backward compatible method.

Cc: Anand Jain <Anand.Jain@oracle.com>
Qu Wenruo (2):
  btrfs: Add missing device check in dev_info/rm_dev ioctl
  btrfs: Add new member of btrfs_ioctl_dev_info_args.

 fs/btrfs/ioctl.c           |  4 ++++
 fs/btrfs/volumes.c         | 25 ++++++++++++++++++++++++-
 fs/btrfs/volumes.h         |  2 ++
 include/uapi/linux/btrfs.h |  5 ++++-
 4 files changed, 34 insertions(+), 2 deletions(-)

-- 
1.9.2

