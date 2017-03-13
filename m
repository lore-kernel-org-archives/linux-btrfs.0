Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49371 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdCMHhk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 03:37:40 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, quwenruo@cn.fujitsu.com
Subject: [PATCH 0/4] cleanup barrier_all_devices()
Date: Mon, 13 Mar 2017 15:42:10 +0800
Message-Id: <20170313074214.24123-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These patches provide cleanup of the function barrier_all_devices().

Anand Jain (4):
  btrfs: REQ_PREFLUSH does not use btrfs_end_bio() completion callback
  btrfs: Communicate back ENOMEM when it occurs
  btrfs: cleanup barrier_all_devices() unify dev error count
  btrfs: cleanup barrier_all_devices() to check dev stat flush error

-- 
2.10.0

