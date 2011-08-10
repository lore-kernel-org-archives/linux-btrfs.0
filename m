From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 0/9] btrfs: More error handling patches
Date: Wed, 10 Aug 2011 19:20:27 -0400
Message-ID: <20110810232027.129702612@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all -

The following 8 patches add more error handling to the btrfs code:

 - Add btrfs_panic
 - Catch locking failures in {set,clear}_extent_bit
 - Push up set_extent_bit errors to callers
 - Push up lock_extent errors to callers
 - Push up clear_extent_bit errors to callers
 - Push up unlock_extent errors to callers
 - Make pin_down_extent return void
 - Push up btrfs_pin_extent errors to callers
 - Push up non-looped btrfs_transaction_start errors to callers

-Jeff


