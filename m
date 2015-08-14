Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35401 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbbHNKhI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:37:08 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 0/2] Btrfs-progs: device delete to accept devid
Date: Fri, 14 Aug 2015 18:36:49 +0800
Message-Id: <1439548611-29730-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is btrfs-progs side of the patch.
Kernel patch is
   Btrfs: device delete by devid

Anand Jain (2):
  btrfs-progs: move is_numerical to utils-lib.h and make it non static
  btrfs-progs: device delete to accept devid

 Documentation/btrfs-device.asciidoc |  2 +-
 cmds-device.c                       | 45 ++++++++++++++++++++++++++++---------
 cmds-replace.c                      | 11 ---------
 ioctl.h                             |  8 +++++++
 utils-lib.c                         | 11 +++++++++
 utils.h                             |  1 +
 6 files changed, 56 insertions(+), 22 deletions(-)

-- 
2.4.1

