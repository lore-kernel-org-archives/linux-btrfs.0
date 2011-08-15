From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch v2 0/9] btrfs: More error handling patches
Date: Mon, 15 Aug 2011 15:50:42 -0400
Message-ID: <20110815195042.559654068@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all -

The following 9 patches add more error handling to the btrfs code:

 - Add btrfs_panic
 - Catch locking failures in {set,clear}_extent_bit
 - Push up set_extent_bit errors to callers
 - Push up lock_extent errors to callers
 - Push up clear_extent_bit errors to callers
 - Push up unlock_extent errors to callers
 - Make pin_down_extent return void
 - Push up btrfs_pin_extent errors to callers
 - Push up non-looped btrfs_transaction_start errors to callers

Changes since version 1:
- Changed BUG_ON(ret) to BUG_ON(ret < 0) in set_extent_bit push up patch
- Added missing chunk to set_extent_bit push up patch
- Added handling for btrfs_drop_snapshot return values to
  btrfs_transaction_start patch <Tsutomu Itoh>

-Jeff

--
Jeff Mahoney
SUSE Labs


