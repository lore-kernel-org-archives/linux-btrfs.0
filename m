Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:27092 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaA3Dyo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 22:54:44 -0500
Date: Thu, 30 Jan 2014 11:54:40 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [btrfs/i_size] xfstests generic/299 TFAIL
Message-ID: <20140130035440.GB12017@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Steven,

We noticed xfstests generic/299 TFAIL on btrfs since

commit 9fe55eea7e4b444bafc42fa0000cc2d1d2847275
Author:     Steven Whitehouse <swhiteho@redhat.com>
AuthorDate: Fri Jan 24 14:42:22 2014 +0000
Commit:     Al Viro <viro@zeniv.linux.org.uk>
CommitDate: Sun Jan 26 08:26:42 2014 -0500

    Fix race when checking i_size on direct i/o read
    

More changes that might help debugging:

2796e4cec525a2b  9fe55eea7e4b444bafc42fa00  
---------------  -------------------------  
         0           +Inf%          1 ~ 0%   xfstests.generic.299.fail
      6601 ~11%  +55547.3%    3673721 ~18%   slabinfo.btrfs_extent_map.active_objs
        49 ~ 6%   +6181.0%       3115 ~19%   slabinfo.btrfs_extent_buffer.num_slabs
        85 ~18%    +776.4%        750 ~14%   slabinfo.buffer_head.num_slabs
     30584 ~ 0%   +1105.5%     368688 ~ 0%   time.maximum_resident_set_size
        85 ~18%    +776.4%        750 ~14%   slabinfo.buffer_head.active_slabs
      3367 ~18%    +769.2%      29268 ~14%   slabinfo.buffer_head.num_objs
      3304 ~19%    +783.1%      29180 ~14%   slabinfo.buffer_head.active_objs
        49 ~ 6%   +6181.0%       3115 ~19%   slabinfo.btrfs_extent_buffer.active_slabs
      1249 ~ 6%   +6134.8%      77897 ~19%   slabinfo.btrfs_extent_buffer.num_objs
      1102 ~ 3%   +6957.3%      77771 ~19%   slabinfo.btrfs_extent_buffer.active_objs
       255 ~11%  +55224.5%     141298 ~18%   slabinfo.btrfs_extent_map.num_slabs
       255 ~11%  +55224.5%     141298 ~18%   slabinfo.btrfs_extent_map.active_slabs
      6645 ~10%  +55181.5%    3673784 ~18%   slabinfo.btrfs_extent_map.num_objs
      2850 ~ 7%    +434.8%      15242 ~ 9%   slabinfo.ext4_extent_status.num_objs
      2841 ~ 8%    +429.5%      15047 ~10%   slabinfo.ext4_extent_status.active_objs
     44659 ~ 2%   +1329.9%     638573 ~17%   meminfo.SReclaimable
     61541 ~ 2%    +964.6%     655186 ~17%   meminfo.Slab
        27 ~ 8%    +447.8%        149 ~ 9%   slabinfo.ext4_extent_status.num_slabs
      9188 ~ 3%    +666.4%      70420 ~ 9%   interrupts.TLB
      2642 ~ 5%    +425.0%      13874 ~14%   slabinfo.ext3_xattr.active_objs
      2662 ~ 5%    +424.9%      13973 ~14%   slabinfo.ext3_xattr.num_objs
        57 ~ 5%    +428.2%        303 ~14%   slabinfo.ext3_xattr.num_slabs
        57 ~ 5%    +428.2%        303 ~14%   slabinfo.ext3_xattr.active_slabs
        27 ~ 8%    +447.8%        149 ~ 9%   slabinfo.ext4_extent_status.active_slabs
         0 ~ 0%      +Inf%     138193 ~ 0%   proc-vmstat.unevictable_pgs_culled
       379 ~13%  +45684.1%     173705 ~ 0%   proc-vmstat.pgdeactivate
      8107 ~16%   +3196.9%     267299 ~ 0%   proc-vmstat.pgactivate
     11160 ~ 2%   +1329.0%     159479 ~17%   proc-vmstat.nr_slab_reclaimable
      6577 ~ 3%    +387.4%      32059 ~24%   proc-vmstat.nr_tlb_remote_flush
      6684 ~ 3%    +380.8%      32142 ~24%   proc-vmstat.nr_tlb_remote_flush_received
     15707 ~31%    +282.3%      60043 ~17%   meminfo.Dirty
   6380554 ~ 0%    +259.8%   22954274 ~ 7%   proc-vmstat.pgfault
     22901 ~ 3%    +290.9%      89514 ~18%   proc-vmstat.nr_active_file
      4067 ~29%    +268.0%      14966 ~17%   proc-vmstat.nr_dirty
     91655 ~ 3%    +291.3%     358640 ~18%   meminfo.Active(file)
   3088362 ~ 0%    +211.5%    9618749 ~ 6%   proc-vmstat.pgalloc_dma32
   3090040 ~ 0%    +211.3%    9619232 ~ 6%   proc-vmstat.pgfree
   3046221 ~ 0%    +211.2%    9479249 ~ 6%   proc-vmstat.numa_local
   3046221 ~ 0%    +211.2%    9479249 ~ 6%   proc-vmstat.numa_hit
     23371 ~ 3%    +218.6%      74472 ~29%   softirqs.TIMER
     51894 ~ 2%    +202.5%     156994 ~23%   interrupts.LOC
    207400 ~ 2%    +142.2%     502386 ~10%   meminfo.Active
    101124 ~ 1%    +151.8%     254632 ~17%   proc-vmstat.nr_tlb_local_flush_all
     30294 ~ 8%     -50.7%      14930 ~17%   slabinfo.btrfs_extent_state.active_objs
       725 ~ 7%     -49.5%        366 ~15%   slabinfo.btrfs_extent_state.num_slabs
       725 ~ 7%     -49.5%        366 ~15%   slabinfo.btrfs_extent_state.active_slabs
     30490 ~ 7%     -49.5%      15409 ~15%   slabinfo.btrfs_extent_state.num_objs
     63861 ~11%     +90.7%     121757 ~ 9%   softirqs.RCU
    849659 ~ 1%    +105.7%    1747978 ~15%   proc-vmstat.nr_tlb_local_flush_one
   1034500 ~ 0%     +94.1%    2007885 ~ 3%   proc-vmstat.pgpgin
    232831 ~14%     +90.8%     444281 ~13%   interrupts.RES
       169 ~ 3%     +91.2%        323 ~15%   uptime.boot
      7332 ~ 8%    +104.1%      14968 ~36%   softirqs.SCHED
     59342 ~17%     +60.4%      95197 ~23%   interrupts.43:PCI-MSI-edge.virtio1-requests
       555 ~ 8%     +70.4%        946 ~13%   slabinfo.blkdev_requests.num_objs
       526 ~ 7%     +65.0%        867 ~18%   slabinfo.kmalloc-2048.active_objs
       525 ~ 8%     +66.0%        872 ~15%   slabinfo.blkdev_requests.active_objs
    648109 ~ 1%     -36.8%     409436 ~ 9%   proc-vmstat.nr_free_pages
   2594146 ~ 1%     -36.9%    1635776 ~ 9%   meminfo.MemFree
       603 ~ 8%     +60.5%        968 ~16%   slabinfo.kmalloc-2048.num_objs
   2587973 ~ 1%     -36.7%    1637486 ~ 9%   vmstat.memory.free
       433 ~ 4%     +71.8%        745 ~25%   uptime.idle
    104603 ~ 0%     +49.4%     156274 ~ 9%   proc-vmstat.nr_unevictable
    418413 ~ 0%     +49.3%     624828 ~ 9%   meminfo.Unevictable
     81418 ~ 0%     -25.4%      60757 ~ 2%   proc-vmstat.nr_dirty_background_threshold
    162839 ~ 0%     -25.4%     121516 ~ 2%   proc-vmstat.nr_dirty_threshold
    956619 ~12%     +30.5%    1248532 ~11%   proc-vmstat.nr_written
    968744 ~12%     +29.9%    1258046 ~11%   proc-vmstat.nr_dirtied
     12837 ~ 7%     -23.1%       9877 ~17%   interrupts.IWI
    305754 ~ 3%     +27.7%     390352 ~ 4%   proc-vmstat.nr_file_pages
      2490 ~11%     +24.1%       3089 ~ 6%   slabinfo.kmalloc-96.num_objs
   1221055 ~ 3%     +19.2%    1455334 ~ 5%   meminfo.Cached
   1223056 ~ 3%     +19.0%    1455025 ~ 5%   vmstat.memory.cache
    172852 ~ 6%     -20.0%     138300 ~12%   proc-vmstat.nr_inactive_file
    689411 ~ 5%     -19.7%     553897 ~12%   meminfo.Inactive(file)
      2471 ~11%     +18.8%       2935 ~ 6%   slabinfo.kmalloc-96.active_objs
    711198 ~ 5%     -18.6%     579097 ~12%   meminfo.Inactive
     42.28 ~21%    +367.9%     197.85 ~10%   time.system_time
      5.06 ~ 6%    +616.9%      36.29 ~ 9%   time.user_time
   5711222 ~ 0%    +279.1%   21648853 ~ 8%   time.minor_page_faults
        32 ~16%    +148.4%         80 ~19%   time.percent_of_cpu_this_job_got
     85616 ~27%    +110.2%     179944 ~18%   time.involuntary_context_switches
   2067193 ~ 0%     +94.1%    4013246 ~ 3%   time.file_system_inputs
       144 ~ 4%    +106.7%        298 ~16%   time.elapsed_time
    144296 ~ 4%     -53.4%      67248 ~17%   vmstat.io.bo
  41865918 ~ 2%     -11.7%   36960769 ~ 7%   time.file_system_outputs

Thanks,
Fengguang
