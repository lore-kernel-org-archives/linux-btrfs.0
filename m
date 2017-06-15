Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56888 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751459AbdFOQu0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 12:50:26 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2F99CAB9D
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 16:50:25 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/5] Preallocate flush bio, sysfs tunable
Date: Thu, 15 Jun 2017 18:49:20 +0200
Message-Id: <cover.1497544265.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset follows the updates in the write_dev_flush function. The flush
bio can be preallocated at the device creation time, so we avoid repeated
alloc/free.

Next, there's a new sysfs tunable to enable forced dev flushes for devices that
do not support the barriers. This helps to test the new code but is not meant
for any non-debugging use.

I've tested lightly with some workloads and toggled the sysfs knob during that,
all fine.

David Sterba (5):
  btrfs: preallocate device flush bio
  btrfs: account as waiting for IO, while waiting fot the flush bio
    completion
  btrfs: move dev stats accounting out of wait_dev_flush
  btrfs: add fs flag to force device flushing
  btrfs: sysfs: export the force_dev_flush flag

 fs/btrfs/ctree.h   |  1 +
 fs/btrfs/disk-io.c | 41 +++++++++++++----------------------------
 fs/btrfs/sysfs.c   | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c | 12 ++++++++++++
 fs/btrfs/volumes.h |  1 +
 5 files changed, 74 insertions(+), 28 deletions(-)

-- 
2.13.0

