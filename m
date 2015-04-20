Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47644 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbbDTIT4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 04:19:56 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, m_btrfs@ml1.co.uk
Subject: [PATCH] device delete by devid
Date: Mon, 20 Apr 2015 18:29:13 +0800
Message-Id: <1429525756-2727-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current method to identify and verify the user provided device_path
needs device SB to be accessible. In situations where SB isn't accessible
or read fails. Using devid will help.

Anand Jain (1):
  Btrfs: device delete by devid

 fs/btrfs/ioctl.c           | 50 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c         | 33 +++++++++++++++++++++---------
 fs/btrfs/volumes.h         |  2 +-
 include/uapi/linux/btrfs.h |  8 ++++++++
 4 files changed, 82 insertions(+), 11 deletions(-)

Anand Jain (2):
  btrfs-progs: move is_numerical to utils-lib.h and make it non static
  btrfs-progs: device delete to accept devid

 Documentation/btrfs-device.txt |  2 +-
 cmds-device.c                  | 47 ++++++++++++++++++++++++++++++++----------
 cmds-replace.c                 | 11 ----------
 ioctl.h                        |  8 +++++++
 utils-lib.c                    | 11 ++++++++++
 utils.h                        |  1 +
 6 files changed, 57 insertions(+), 23 deletions(-)

-- 
2.0.0.153.g79dcccc

