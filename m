Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40202 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751893AbdFOMwq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 08:52:46 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B1E59AC08
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 12:52:44 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, jeffm@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/2] Ensure size values are rounded down
Date: Thu, 15 Jun 2017 15:52:33 +0300
Message-Id: <1497531155-9703-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We got an internal report about a file system not wanting to mount 
following 99e3ecfcb9f4 ("Btrfs: add more validation checks for superblock"). 

BTRFS error (device sdb1): super_total_bytes 1000203816960 mismatch with
fs_devices total_rw_bytes 1000203820544

Substracting the numbers we get a difference of less than a 4kb. Upon closer 
inspection it became apparent that mkfs actually rounds down the size of the 
device to a multiple of sector size. However, the same cannot be said for 
various functions which modify the total size and are called from btrfs_balanace
as well as when adding a new device. 

The first patch in the series re-implements the btrfs_device_total_bytes
getter/setters manually so that we can add a WARN_ON to catch future offenders. 
I haven't implemented all 4 function that the macros do since we only ever use
the getter and setter. 

The second patch ensures that all the values passed to the setter are rounded 
down to a multiple of sectorsize. I also have an xfstest patch which passes
after this series is applied. 


Nikolay Borisov (2):
  btrfs: Manually implement device_total_bytes getter/setter
  btrfs: Round up values which are written for total_bytes_size

 fs/btrfs/ctree.h   | 19 ++++++++++++++++++-
 fs/btrfs/volumes.c | 18 +++++++++++++-----
 2 files changed, 31 insertions(+), 6 deletions(-)

-- 
2.7.4

