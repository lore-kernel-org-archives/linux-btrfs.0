Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15316 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728079AbeGPKFQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 06:05:16 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <anand.jain@oracle.com>
Subject: [PATCH v5 0/2] btrfs: do some parameters optimization
Date: Mon, 16 Jul 2018 17:34:16 +0800
Message-ID: <1531733656-23806-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do parameters optimization for function btrfs_parse_early_options
and btrfs_scan_one_device.

Gu Jinxiang (2):
  btrfs: make fs_devices to be a local variable
  btrfs: get device pointer from btrfs_scan_one_device

 fs/btrfs/super.c   | 38 ++++++++++++++++++++++++--------------
 fs/btrfs/volumes.c | 22 ++++++++--------------
 fs/btrfs/volumes.h |  4 ++--
 3 files changed, 34 insertions(+), 30 deletions(-)

-- 
2.17.1



