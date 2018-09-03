Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbeICOFj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Sep 2018 10:05:39 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0FFE6AF4C
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Sep 2018 09:46:17 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] cleanup couple of device-related functions' retval
Date: Mon,  3 Sep 2018 12:46:11 +0300
Message-Id: <20180903094614.2667-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs_find_device_by_path, btrfs_find_device_missing_or_by_path and 
btrfs_find_device_by_devspec are called in a chain and they all return an 
integer value to signal error and at the same time use one of their parameters
as an output. This patch set refactors those functions starting from the 
bottom, gradually making them return a pointer to btrfs_device. This is 
sufficient to convey an error when it occurs as well as return the actual 
device we are looking for. One added benefit is that the ioctl-specific positive
return value BTRFS_ERROR_DEV_MISSING_NOT_FOUND is now returned from 
btrfs_rm_device rather than from some internal function. 

Additionally I'll be sending a patch to progs, adding a test ensuring that 
BTRFS_ERROR_MISSING_NOT_FOUND is returned appropriately. 

This survived both my btrfs-progs test as well as xfstest run. No functional 
changes.


Nikolay Borisov (3):
  btrfs: Make btrfs_find_device_by_path return struct btrfs_device
  btrfs: Make btrfs_find_device_missing_or_by_path return directly a
    device
  btrfs: Make btrfs_find_device_by_devspec return btrfs_device directly

 fs/btrfs/dev-replace.c |  8 ++---
 fs/btrfs/volumes.c     | 73 ++++++++++++++++++++++--------------------
 fs/btrfs/volumes.h     |  9 ++----
 3 files changed, 45 insertions(+), 45 deletions(-)

-- 
2.17.1
