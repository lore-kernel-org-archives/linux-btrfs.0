Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28577 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752227AbdHMDzw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 23:55:52 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/4] misc compression tracing related patches
Date: Sun, 13 Aug 2017 12:02:40 +0800
Message-Id: <20170813040244.18841-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain (4):
  btrfs: remove unused BTRFS_COMPRESS_LAST
  btrfs: convert enum btrfs_compression_type to define
  btrfs: decode compress type for tracing
  btrfs: add compression trace points

 fs/btrfs/compression.c          | 11 +++++++
 fs/btrfs/compression.h          |  8 ------
 fs/btrfs/super.c                |  2 +-
 include/trace/events/btrfs.h    | 64 +++++++++++++++++++++++++++++++++++------
 include/uapi/linux/btrfs_tree.h |  5 ++++
 5 files changed, 72 insertions(+), 18 deletions(-)

-- 
2.13.1

