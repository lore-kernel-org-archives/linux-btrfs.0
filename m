From: Li Dongyang <lidongyang@novell.com>
Subject: [PATCH V4 0/4] Btrfs: batched discard support for btrfs
Date: Thu, 24 Mar 2011 18:24:24 +0800
Message-ID: <1300962268-12774-1-git-send-email-lidongyang@novell.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Dear list,
This is V4 of batched discard support, now we will get full mapping of
the free space on each device for RAID0/1/10/DUP instead of just a single
stripe length, and tested with xfsstests 251, Thanks.
Changelog V4:
    *make btrfs_map_block() return full mapping.
Changelog V3:
    *fix style problems.
    *rebase to 2.6.38-rc7.
Changelog V2:
    *Check if we have devices support trim before trying to trim the fs, also adjust
      minlen according to the discard_granularity.
    *Update reserved extent calculations in btrfs_trim_block_group().
    *Call cond_resched() without checking need_resched()
    *Use bitmap_clear_bits() and unlink_free_space() instead of btrfs_remove_free_space(),
      so we won't search the same extent for twice.
    *Try harder in btrfs_discard_extent(), now we won't report errors
     if it's not a EOPNOTSUPP.
    *make sure the block group is cached before trimming it,or we'll see an empty caching
     tree if the block group is not cached.
    *Minor return value fix in btrfs_discard_block_group().
