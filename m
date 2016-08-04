Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:60431 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbcHDGlK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Aug 2016 02:41:10 -0400
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>)
	id 1bVCL3-0001pp-Ph
	for linux-btrfs@vger.kernel.org; Thu, 04 Aug 2016 16:41:05 +1000
Date: Thu, 4 Aug 2016 16:41:05 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-btrfs@vger.kernel.org
Subject: [4.8] btrfs heats my room with lock contention
Message-ID: <20160804064105.GT12670@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Simple test. 8GB pmem device on a 16p machine:

# mkfs.btrfs /dev/pmem1
# mount /dev/pmem1 /mnt/scratch
# dbench -t 60 -D /mnt/scratch 16

And heat your room with the warm air rising from your CPUs. Top
half of the btrfs profile looks like:

  36.71%  [kernel]  [k] _raw_spin_unlock_irqrestore                                                                                                                    ¿
  32.29%  [kernel]  [k] native_queued_spin_lock_slowpath                                                                                                               ¿
   5.14%  [kernel]  [k] queued_write_lock_slowpath                                                                                                                     ¿
   2.46%  [kernel]  [k] _raw_spin_unlock_irq                                                                                                                           ¿
   2.15%  [kernel]  [k] queued_read_lock_slowpath                                                                                                                      ¿
   1.54%  [kernel]  [k] _find_next_bit.part.0                                                                                                                          ¿
   1.06%  [kernel]  [k] __crc32c_le                                                                                                                                    ¿
   0.82%  [kernel]  [k] btrfs_tree_lock                                                                                                                                ¿
   0.79%  [kernel]  [k] steal_from_bitmap.part.29                                                                                                                      ¿
   0.70%  [kernel]  [k] __copy_user_nocache                                                                                                                            ¿
   0.69%  [kernel]  [k] btrfs_tree_read_lock                                                                                                                           ¿
   0.69%  [kernel]  [k] delay_tsc                                                                                                                                      ¿
   0.64%  [kernel]  [k] btrfs_set_lock_blocking_rw                                                                                                                     ¿
   0.63%  [kernel]  [k] copy_user_generic_string                                                                                                                       ¿
   0.51%  [kernel]  [k] do_raw_read_unlock                                                                                                                             ¿
   0.48%  [kernel]  [k] do_raw_spin_lock                                                                                                                               ¿
   0.47%  [kernel]  [k] do_raw_read_lock                                                                                                                               ¿
   0.46%  [kernel]  [k] btrfs_clear_lock_blocking_rw                                                                                                                   ¿
   0.44%  [kernel]  [k] do_raw_write_lock                                                                                                                              ¿
   0.41%  [kernel]  [k] __do_softirq                                                                                                                                   ¿
   0.28%  [kernel]  [k] __memcpy                                                                                                                                       ¿
   0.24%  [kernel]  [k] map_private_extent_buffer                                                                                                                      ¿
   0.23%  [kernel]  [k] find_next_zero_bit                                                                                                                             ¿
   0.22%  [kernel]  [k] btrfs_tree_read_unlock                                                                                                                         ¿

Performance vs CPu usage is:

nprocs		throughput		cpu usage
1		440MB/s			 50%
2		770MB/s			100%
4		880MB/s			250%
8		690MB/s			450%
16		280MB/s			950%

In comparision, at 8-16 threads ext4 is running at ~2600MB/s and
XFS is running at ~3800MB/s. Even if I throw 300-400 processes at
ext4 and XFS, they only drop to ~1500-2000MB/s as they hit internal
limits.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
