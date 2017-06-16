Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33726 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753971AbdFPOFv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Jun 2017 10:05:51 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: anand.jain@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 0/3 v2] Preallocate flush bio
Date: Fri, 16 Jun 2017 16:04:45 +0200
Message-Id: <cover.1497621455.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset follows the updates in the write_dev_flush function. The flush
bio can be preallocated at the device creation time, so we avoid repeated
alloc/free.

v2:
- merge 'flush_bio_sent' from 4 to 1 and dropped patch 4
- dropped sysfs tunable (patch 5)
- fix typo in patch 1 changelog

David Sterba (3):
  btrfs: preallocate device flush bio
  btrfs: account as waiting for IO, while waiting fot the flush bio
    completion
  btrfs: move dev stats accounting out of wait_dev_flush

 fs/btrfs/disk-io.c | 38 +++++++++++---------------------------
 fs/btrfs/volumes.c | 12 ++++++++++++
 fs/btrfs/volumes.h |  1 +
 3 files changed, 24 insertions(+), 27 deletions(-)

-- 
2.13.0

