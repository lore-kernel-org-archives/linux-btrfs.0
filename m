Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37452 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbcLFEkF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 23:40:05 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] Misc fixes mostly cleanup
Date: Tue,  6 Dec 2016 12:43:06 +0800
Message-Id: <20161206044309.3450-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A set of unrelated miscellaneous cleanup patches.

Anand Jain (3):
  btrfs: use BTRFS_COMPRESS_NONE to specify no compression
  btrfs: cow_file_range() num_bytes and disk_num_bytes are same
  btrfs: consolidate auto defrag kick off policies

 fs/btrfs/inode.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

-- 
2.10.0

