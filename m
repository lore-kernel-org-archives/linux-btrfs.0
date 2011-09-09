From: jeffm@suse.com
Subject: [patch v3 00/23] More error handling fixes
Date: Thu, 08 Sep 2011 20:22:40 -0400
Message-ID: <20110909002240.141223014@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: btrfs list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all -

The following 23 patches add more error handling to the btrfs code:

 - Add btrfs_panic
 - Catch locking failures in {set,clear}_extent_bit
 - Push up set_extent_bit errors to callers
 - Push up lock_extent errors to callers
 - Push up clear_extent_bit errors to callers
 - Push up unlock_extent errors to callers
 - Make pin_down_extent return void
 - Push up btrfs_pin_extent errors to callers
 - Push up non-looped btrfs_transaction_start errors to callers

 New in this version:
 - Make functions with no return value return void (11 patches)
 - Simplify btrfs_submit_bio_hook
 - Simplify tree_merge_hook by adding a merge_bio helper
 - Push up submit_bio_hook failures

Changes since last submission:
- Refreshed against 3.1-rc3.

-Jeff

-- 
Jeff Mahoney
SuSE Labs

