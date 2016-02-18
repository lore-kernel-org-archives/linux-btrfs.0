Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51418 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030337AbcBRIHd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 03:07:33 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH RFC] Make add and device ioctls device path len consistent
Date: Thu, 18 Feb 2016 16:07:15 +0800
Message-Id: <1455782837-15630-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 Just in case if need to fix it properly, this patch helps.
 Its a bit of overkill though, on the basis of being theoretically
 correct. As discussed, this or Chris suggested to use simpler
 BTRFS_SUBVOL_NAME_MAX will fix equally from practical perspective.

 This patch is ontop the patch
   btrfs: Introduce device delete by devid
   btrfs-progs: Introduce device delete by devid
 respectively.

Thanks, Anand

Anand Jain (1):
  btrfs: make add and device ioctl args path max consistent

 fs/btrfs/ioctl.c           |  2 +-
 include/uapi/linux/btrfs.h | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

Anand Jain (1):
  btrfs-progs: make add and delete path max len consistent

 cmds-device.c |  2 +-
 ioctl.h       | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

-- 
2.7.0

