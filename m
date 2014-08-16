Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:44262 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaHPHwq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Aug 2014 03:52:46 -0400
Date: Sat, 16 Aug 2014 15:52:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Chris Mason <clm@fb.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [btrfs] 4c468fd7485: +7.8% blogbench.write_score, -5.1%
 turbostat.Pkg_W
Message-ID: <20140816075233.GA26842@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Chris,

FYI, we noticed increased performance and reduced power consumption on

commit 4c468fd74859d901c0b78b42bef189295e00d74f ("btrfs: disable strict file flushes for renames and truncates")

test case: lkp-sb02/blogbench/1HDD-btrfs

0954d74f8f37a47  4c468fd74859d901c0b78b42b 
---------------  ------------------------- 
      1094 ± 1%      +7.8%       1180 ± 2%  TOTAL blogbench.write_score
      1396 ±19%    -100.0%          0 ± 0%  TOTAL slabinfo.btrfs_delalloc_work.active_objs
      1497 ±17%    -100.0%          0 ± 0%  TOTAL slabinfo.btrfs_delalloc_work.num_objs
       426 ±45%    -100.0%          0 ± 0%  TOTAL proc-vmstat.nr_vmscan_write
      1.02 ±38%    +193.1%       2.99 ±37%  TOTAL turbostat.%pc6
      0.12 ±48%    +113.8%       0.25 ±29%  TOTAL turbostat.%pc3
      0.38 ±18%    +117.7%       0.84 ±34%  TOTAL turbostat.%pc2
     19377 ±14%     -50.9%       9520 ±20%  TOTAL proc-vmstat.workingset_refault
        44 ±41%     +68.8%         75 ±28%  TOTAL cpuidle.POLL.usage
     31549 ± 1%     +95.7%      61732 ± 1%  TOTAL softirqs.BLOCK
      4547 ±10%     -38.3%       2804 ± 9%  TOTAL slabinfo.btrfs_ordered_extent.active_objs
      4628 ±10%     -37.1%       2913 ± 9%  TOTAL slabinfo.btrfs_ordered_extent.num_objs
     17597 ± 8%     -30.2%      12291 ±14%  TOTAL proc-vmstat.nr_writeback
     70335 ± 8%     -30.1%      49174 ±14%  TOTAL meminfo.Writeback
      3606 ± 6%     -29.1%       2556 ±10%  TOTAL slabinfo.mnt_cache.active_objs
     14763 ±12%     -29.9%      10350 ± 8%  TOTAL proc-vmstat.nr_dirty
      3766 ± 5%     -27.8%       2720 ±10%  TOTAL slabinfo.mnt_cache.num_objs
      3509 ± 6%     -28.5%       2510 ±11%  TOTAL slabinfo.kmalloc-4096.active_objs
     59201 ±11%     -30.1%      41396 ± 8%  TOTAL meminfo.Dirty
       479 ±13%     -30.5%        333 ±10%  TOTAL slabinfo.kmalloc-4096.num_slabs
       479 ±13%     -30.5%        333 ±10%  TOTAL slabinfo.kmalloc-4096.active_slabs
      3636 ± 6%     -26.6%       2669 ±10%  TOTAL slabinfo.kmalloc-4096.num_objs
      6040 ± 8%     -28.6%       4314 ± 6%  TOTAL slabinfo.kmalloc-96.num_objs
      5358 ± 5%     -25.1%       4011 ± 7%  TOTAL slabinfo.kmalloc-96.active_objs
    757208 ± 4%     -22.1%     589874 ± 4%  TOTAL meminfo.MemFree
    189508 ± 4%     -22.2%     147518 ± 4%  TOTAL proc-vmstat.nr_free_pages
    762781 ± 4%     -21.1%     601525 ± 4%  TOTAL vmstat.memory.free
     10491 ± 2%     -16.8%       8725 ± 2%  TOTAL slabinfo.kmalloc-64.num_objs
      2513 ± 4%     +16.3%       2923 ± 4%  TOTAL slabinfo.kmalloc-128.active_objs
      9768 ± 3%     -15.1%       8298 ± 1%  TOTAL slabinfo.kmalloc-64.active_objs
      2627 ± 4%     +14.0%       2995 ± 4%  TOTAL slabinfo.kmalloc-128.num_objs
     96242 ± 2%     +15.5%     111120 ± 2%  TOTAL slabinfo.btrfs_path.active_objs
      3448 ± 2%     +15.1%       3968 ± 2%  TOTAL slabinfo.btrfs_path.num_slabs
      3448 ± 2%     +15.1%       3968 ± 2%  TOTAL slabinfo.btrfs_path.active_slabs
     96580 ± 2%     +15.1%     111132 ± 2%  TOTAL slabinfo.btrfs_path.num_objs
      2526 ± 2%     +13.5%       2867 ± 1%  TOTAL slabinfo.btrfs_extent_state.num_slabs
      2526 ± 2%     +13.5%       2867 ± 1%  TOTAL slabinfo.btrfs_extent_state.active_slabs
    106133 ± 2%     +13.5%     120434 ± 1%  TOTAL slabinfo.btrfs_extent_state.num_objs
    104326 ± 2%     +12.3%     117189 ± 1%  TOTAL slabinfo.btrfs_extent_state.active_objs
    110759 ± 2%     +13.4%     125640 ± 2%  TOTAL slabinfo.btrfs_inode.active_objs
    110759 ± 2%     +13.4%     125642 ± 2%  TOTAL slabinfo.btrfs_delayed_node.active_objs
      4261 ± 2%     +13.4%       4832 ± 2%  TOTAL slabinfo.btrfs_delayed_node.num_slabs
      4261 ± 2%     +13.4%       4832 ± 2%  TOTAL slabinfo.btrfs_delayed_node.active_slabs
    110797 ± 2%     +13.4%     125663 ± 2%  TOTAL slabinfo.btrfs_delayed_node.num_objs
    110815 ± 2%     +13.4%     125669 ± 2%  TOTAL slabinfo.btrfs_inode.num_objs
      6926 ± 2%     +13.4%       7853 ± 2%  TOTAL slabinfo.btrfs_inode.num_slabs
      6926 ± 2%     +13.4%       7853 ± 2%  TOTAL slabinfo.btrfs_inode.active_slabs
      5607 ± 3%     -11.0%       4991 ± 3%  TOTAL slabinfo.kmalloc-256.active_objs
      6077 ± 2%      -9.9%       5476 ± 3%  TOTAL slabinfo.kmalloc-256.num_objs
     11153 ± 1%      -7.7%      10295 ± 2%  TOTAL proc-vmstat.nr_slab_unreclaimable
    547824 ± 3%     +16.5%     638368 ± 8%  TOTAL meminfo.Inactive(file)
    112124 ± 2%     +11.6%     125105 ± 2%  TOTAL slabinfo.radix_tree_node.active_objs
    112169 ± 2%     +11.6%     125134 ± 2%  TOTAL slabinfo.radix_tree_node.num_objs
      4005 ± 2%     +11.6%       4468 ± 2%  TOTAL slabinfo.radix_tree_node.num_slabs
      4005 ± 2%     +11.6%       4468 ± 2%  TOTAL slabinfo.radix_tree_node.active_slabs
    551119 ± 3%     +16.4%     641663 ± 8%  TOTAL meminfo.Inactive
    285596 ± 2%     +11.4%     318160 ± 2%  TOTAL meminfo.SReclaimable
       156 ± 3%    +118.0%        340 ± 2%  TOTAL iostat.sda.w/s
       282 ± 3%     -43.2%        160 ± 3%  TOTAL iostat.sda.avgrq-sz
      1.45 ±12%     -28.9%       1.03 ±18%  TOTAL iostat.sda.rrqm/s
       633 ± 2%     -26.5%        465 ± 2%  TOTAL iostat.sda.wrqm/s
    154423 ± 5%     +17.4%     181309 ± 3%  TOTAL time.voluntary_context_switches
       536 ± 5%     -11.5%        474 ± 9%  TOTAL iostat.sda.await
    102.71 ± 5%     +10.4%     113.36 ± 6%  TOTAL iostat.sda.avgqu-sz
     20842 ± 2%      -6.5%      19493 ± 2%  TOTAL iostat.sda.wkB/s
     20856 ± 2%      -6.4%      19525 ± 2%  TOTAL vmstat.io.bo
     75.48 ± 4%      -6.9%      70.27 ± 5%  TOTAL turbostat.%c0
       285 ± 4%      -6.6%        266 ± 5%  TOTAL time.percent_of_cpu_this_job_got
     34.58 ± 2%      -5.5%      32.68 ± 3%  TOTAL turbostat.Cor_W
     39.86 ± 2%      -5.1%      37.82 ± 3%  TOTAL turbostat.Pkg_W
      5805 ± 1%      -4.3%       5558 ± 3%  TOTAL vmstat.system.in
  10069454 ± 1%      +6.3%   10699830 ± 1%  TOTAL time.file_system_outputs


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Fengguang

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
mkfs -t btrfs /dev/sda2
mount -t btrfs /dev/sda2 /fs/sda2
./blogbench -d /fs/sda2

--k1lZvvs/B4yU6o8G--
