From: Daniel J Blueman <daniel@quora.org>
Subject: fs going r/o when out of space...
Date: Wed, 2 May 2012 13:44:02 +0800
Message-ID: <CAMVG2svvV4DDkytGBusSm_M0-H+Qnoo9R=wuWOtg-5qL2uXTag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I see the filesystem going readonly when run_clustered_refs returns
-ENOSPC [1], so it looks like we need something like:

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2451,7 +2451,8 @@ again:
                ret = run_clustered_refs(trans, root, &cluster);
                if (ret < 0) {
                        spin_unlock(&delayed_refs->lock);
-                       btrfs_abort_transaction(trans, root, ret);
+                       if (ret != -ENOSPC)
+                               btrfs_abort_transaction(trans, root, ret);
                        return ret;
                }

No?

Daniel

--- [1]

[fio --directory=/tmp/btrfsatron --timeout=60 workload]
bgwriter: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=32
queryA: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=mmap, iodepth=2
queryB: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=mmap, iodepth=2
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=32
fio 1.59
Starting 4 processes
fio: io_u error on file /tmp/btrfsatron/bgupdater.4.0: No space left on device
     write offset=65671168, buflen=4096
fio: io_u error on file /tmp/btrfsatron/bgupdater.4.0: No space left on device
     write offset=51646464, buflen=4096
fio: pid=4253, err=28/file:io_u.c:1266, func=io_u error, error=No
space left on device
fio: io_u error on file /tmp/btrfsatron/bgwriter.1.0: No space left on device
     write offset=63078400, buflen=4096
fio: io_u error on file /tmp/btrfsatron/bgwriter.1.0: No space left on device
     write offset=53940224, buflen=4096
fio: pid=4250, err=28/file:io_u.c:1266, func=io_u error, error=No
space left on device
Jobs: 2 (f=2): [_rr_] [100.0% done] [43406K/0K /s] [10.6K/0  iops] [eta 00m:00s]
bgwriter: (groupid=0, jobs=1): err=28 (file:io_u.c:1266, func=io_u
error, error=No space left on device): pid=4250
  write: io=12288 B, bw=81920 B/s, iops=233 , runt=   150msec
    slat (usec): min=11 , max=86459 , avg=4262.31, stdev=17666.67
    clat (msec): min=86 , max=148 , avg=107.73, stdev=35.61
     lat (msec): min=87 , max=149 , avg=128.51, stdev=35.55
  cpu          : usr=0.00%, sys=0.00%, ctx=4, majf=0, minf=57
  IO depths    : 1=2.9%, 2=5.7%, 4=11.4%, 8=22.9%, 16=45.7%, 32=11.4%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=0/35/0, short=0/0/0

     lat (msec): 100=5.71%, 250=2.86%
queryA: (groupid=0, jobs=1): err= 0: pid=4251
  read : io=131072KB, bw=19743KB/s, iops=4935 , runt=  6639msec
    clat (usec): min=36 , max=10273 , avg=115.09, stdev=332.36
     lat (usec): min=36 , max=10273 , avg=115.38, stdev=332.70
    bw (KB/s) : min= 1400, max=24280, per=51.15%, avg=19912.69, stdev=6530.51
  cpu          : usr=2.86%, sys=37.66%, ctx=66702, majf=32768, minf=31
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=32768/0/0, short=0/0/0
     lat (usec): 50=8.88%, 100=67.45%, 250=20.11%, 500=2.26%, 750=0.20%
     lat (usec): 1000=0.18%
     lat (msec): 2=0.39%, 4=0.34%, 10=0.16%, 20=0.02%
queryB: (groupid=0, jobs=1): err= 0: pid=4252
  read : io=131072KB, bw=19464KB/s, iops=4866 , runt=  6734msec
    clat (usec): min=37 , max=12375 , avg=114.55, stdev=319.44
     lat (usec): min=37 , max=12375 , avg=114.75, stdev=319.47
    bw (KB/s) : min=  952, max=23680, per=50.51%, avg=19664.31, stdev=6573.53
  cpu          : usr=2.23%, sys=37.72%, ctx=67050, majf=32768, minf=30
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=32768/0/0, short=0/0/0
     lat (usec): 50=9.82%, 100=65.63%, 250=20.82%, 500=2.42%, 750=0.24%
     lat (usec): 1000=0.18%
     lat (msec): 2=0.39%, 4=0.36%, 10=0.13%, 20=0.02%
bgupdater: (groupid=0, jobs=1): err=28 (file:io_u.c:1266, func=io_u
error, error=No space left on device): pid=4253
  read : io=20480 B, bw=138378 B/s, iops=141 , runt=   148msec
    slat (usec): min=62 , max=203 , avg=129.52, stdev=36.18
    clat (msec): min=84 , max=146 , avg=134.02, stdev=27.53
     lat (msec): min=84 , max=146 , avg=134.09, stdev=27.53
  write: io=8192 B, bw=55351 B/s, iops=121 , runt=   148msec
    slat (usec): min=19 , max=81653 , avg=8011.39, stdev=23377.08
    clat (usec): min=84555 , max=85065 , avg=84810.00, stdev=360.62
     lat (msec): min=84 , max=146 , avg=115.73, stdev=43.57
  cpu          : usr=0.00%, sys=34.01%, ctx=1113, majf=0, minf=57
  IO depths    : 1=2.6%, 2=5.1%, 4=10.3%, 8=20.5%, 16=41.0%, 32=20.5%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=21/18/0, short=0/0/0

     lat (msec): 100=7.69%, 250=10.26%

Run status group 0 (all jobs):
   READ: io=262164KB, aggrb=38931KB/s, minb=138KB/s, maxb=20216KB/s,
mint=148msec, maxt=6734msec
  WRITE: io=20KB, aggrb=133KB/s, minb=55KB/s, maxb=81KB/s,
mint=148msec, maxt=150msec
btrfs: fail to dirty inode 260 error -28
use_block_rsv: 790 callbacks suppressed
btrfs: block rsv returned -28
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:6219 use_block_rsv+0x15c/0x170 [btrfs]()
Hardware name: Latitude E5420
Modules linked in: brd dm_crypt dm_mod kvm_intel kvm coretemp
microcode uvcvideo videobuf2_core videodev videobuf2_vmalloc
videobuf2_memops iwlwifi binfmt_misc btrfs i915 cfbcopyarea cfbimgblt
cfbfillrect video
Pid: 4032, comm: btrfs Tainted: G        W    3.4.0-rc5-debug+ #7
Call Trace:
 [<ffffffff8103c5ca>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103c615>] warn_slowpath_null+0x15/0x20
 [<ffffffffa00af9bc>] use_block_rsv+0x15c/0x170 [btrfs]
 [<ffffffffa00b2a88>] btrfs_alloc_free_block+0x38/0x200 [btrfs]
 [<ffffffffa00e7d74>] ? read_extent_buffer+0xb4/0x110 [btrfs]
 [<ffffffffa00a08d0>] __btrfs_cow_block+0x130/0x4d0 [btrfs]
 [<ffffffffa00a0d67>] btrfs_cow_block+0xf7/0x1b0 [btrfs]
 [<ffffffffa01093bf>] do_relocation+0x45f/0x540 [btrfs]
 [<ffffffffa00a7871>] ? block_rsv_add_bytes+0x51/0x70 [btrfs]
 [<ffffffffa0109ca4>] relocate_tree_block+0x234/0x270 [btrfs]
 [<ffffffffa010c7b3>] relocate_tree_blocks+0x123/0x1a0 [btrfs]
 [<ffffffffa010d5bc>] relocate_block_group+0x1ec/0x560 [btrfs]
 [<ffffffffa010daf4>] btrfs_relocate_block_group+0x1c4/0x300 [btrfs]
 [<ffffffffa00eba3a>] btrfs_relocate_chunk.isra.52+0x4a/0x240 [btrfs]
 [<ffffffffa00e70da>] ? free_extent_buffer+0x2a/0x70 [btrfs]
 [<ffffffffa00eeb34>] __btrfs_balance+0x2f4/0x3f0 [btrfs]
 [<ffffffffa00eef23>] btrfs_balance+0x2f3/0x4d0 [btrfs]
 [<ffffffffa00f543b>] btrfs_ioctl_balance.isra.53+0xeb/0x470 [btrfs]
 [<ffffffff8102817c>] ? do_page_fault+0x1fc/0x460
 [<ffffffffa00f7ab1>] btrfs_ioctl+0x91/0x770 [btrfs]
 [<ffffffff810ea8e6>] ? do_brk+0x246/0x360
 [<ffffffff811286d7>] do_vfs_ioctl+0x87/0x340
 [<ffffffff812232e4>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff811289da>] sys_ioctl+0x4a/0x80
 [<ffffffff815ad1a2>] system_call_fastpath+0x16/0x1b
---[ end trace e8b31383e015594e ]---
btrfs: block rsv returned -28
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:6219 use_block_rsv+0x15c/0x170 [btrfs]()
Hardware name: Latitude E5420
Modules linked in: brd dm_crypt dm_mod kvm_intel kvm coretemp
microcode uvcvideo videobuf2_core videodev videobuf2_vmalloc
videobuf2_memops iwlwifi binfmt_misc btrfs i915 cfbcopyarea cfbimgblt
cfbfillrect video
Pid: 4032, comm: btrfs Tainted: G        W    3.4.0-rc5-debug+ #7
Call Trace:
 [<ffffffff8103c5ca>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103c615>] warn_slowpath_null+0x15/0x20
 [<ffffffffa00af9bc>] use_block_rsv+0x15c/0x170 [btrfs]
 [<ffffffffa00b2a88>] btrfs_alloc_free_block+0x38/0x200 [btrfs]
 [<ffffffffa00e7d74>] ? read_extent_buffer+0xb4/0x110 [btrfs]
 [<ffffffffa00a08d0>] __btrfs_cow_block+0x130/0x4d0 [btrfs]
 [<ffffffffa00a0d67>] btrfs_cow_block+0xf7/0x1b0 [btrfs]
 [<ffffffffa01093bf>] do_relocation+0x45f/0x540 [btrfs]
 [<ffffffffa00a7871>] ? block_rsv_add_bytes+0x51/0x70 [btrfs]
 [<ffffffffa0109ca4>] relocate_tree_block+0x234/0x270 [btrfs]
 [<ffffffffa010c7b3>] relocate_tree_blocks+0x123/0x1a0 [btrfs]
 [<ffffffffa010d5bc>] relocate_block_group+0x1ec/0x560 [btrfs]
 [<ffffffffa010daf4>] btrfs_relocate_block_group+0x1c4/0x300 [btrfs]
 [<ffffffffa00eba3a>] btrfs_relocate_chunk.isra.52+0x4a/0x240 [btrfs]
 [<ffffffffa00e70da>] ? free_extent_buffer+0x2a/0x70 [btrfs]
 [<ffffffffa00eeb34>] __btrfs_balance+0x2f4/0x3f0 [btrfs]
 [<ffffffffa00eef23>] btrfs_balance+0x2f3/0x4d0 [btrfs]
 [<ffffffffa00f543b>] btrfs_ioctl_balance.isra.53+0xeb/0x470 [btrfs]
 [<ffffffff8102817c>] ? do_page_fault+0x1fc/0x460
 [<ffffffffa00f7ab1>] btrfs_ioctl+0x91/0x770 [btrfs]
 [<ffffffff810ea8e6>] ? do_brk+0x246/0x360
 [<ffffffff811286d7>] do_vfs_ioctl+0x87/0x340
 [<ffffffff812232e4>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff811289da>] sys_ioctl+0x4a/0x80
 [<ffffffff815ad1a2>] system_call_fastpath+0x16/0x1b
---[ end trace e8b31383e015594f ]---
btrfs: run_one_delayed_ref returned -28
------------[ cut here ]------------
WARNING: at fs/btrfs/super.c:219 __btrfs_abort_transaction+0xa6/0xc0 [btrfs]()
Hardware name: Latitude E5420
btrfs: Transaction aborted
Modules linked in: brd dm_crypt dm_mod kvm_intel kvm coretemp
microcode uvcvideo videobuf2_core videodev videobuf2_vmalloc
videobuf2_memops iwlwifi binfmt_misc btrfs i915 cfbcopyarea cfbimgblt
cfbfillrect video
Pid: 4032, comm: btrfs Tainted: G        W    3.4.0-rc5-debug+ #7
Call Trace:
 [<ffffffff8103c5ca>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103c6a1>] warn_slowpath_fmt+0x41/0x50
 [<ffffffffa009dc76>] __btrfs_abort_transaction+0xa6/0xc0 [btrfs]
 [<ffffffffa00b1736>] btrfs_run_delayed_refs+0x296/0x300 [btrfs]
 [<ffffffffa00c2104>] btrfs_commit_transaction+0xb4/0x900 [btrfs]
 [<ffffffff8105e250>] ? __init_waitqueue_head+0x60/0x60
 [<ffffffff815ac546>] ? _raw_spin_unlock+0x26/0x40
 [<ffffffffa010d602>] relocate_block_group+0x232/0x560 [btrfs]
 [<ffffffffa010daf4>] btrfs_relocate_block_group+0x1c4/0x300 [btrfs]
 [<ffffffffa00eba3a>] btrfs_relocate_chunk.isra.52+0x4a/0x240 [btrfs]
 [<ffffffffa00e70da>] ? free_extent_buffer+0x2a/0x70 [btrfs]
 [<ffffffffa00eeb34>] __btrfs_balance+0x2f4/0x3f0 [btrfs]
 [<ffffffffa00eef23>] btrfs_balance+0x2f3/0x4d0 [btrfs]
 [<ffffffffa00f543b>] btrfs_ioctl_balance.isra.53+0xeb/0x470 [btrfs]
 [<ffffffff8102817c>] ? do_page_fault+0x1fc/0x460
 [<ffffffffa00f7ab1>] btrfs_ioctl+0x91/0x770 [btrfs]
 [<ffffffff810ea8e6>] ? do_brk+0x246/0x360
 [<ffffffff811286d7>] do_vfs_ioctl+0x87/0x340
 [<ffffffff812232e4>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff811289da>] sys_ioctl+0x4a/0x80
 [<ffffffff815ad1a2>] system_call_fastpath+0x16/0x1b
---[ end trace e8b31383e0155950 ]---
BTRFS error (device ram1) in btrfs_run_delayed_refs:2454: error 28
btrfs is forced readonly
BTRFS warning (device ram1): Skipping commit of aborted
transaction.btrfs: fail to dirty inode 260 error -28
use_block_rsv: 790 callbacks suppressed
btrfs: block rsv returned -28
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:6219 use_block_rsv+0x15c/0x170 [btrfs]()
Hardware name: Latitude E5420
Modules linked in: brd dm_crypt dm_mod kvm_intel kvm coretemp
microcode uvcvideo videobuf2_core videodev videobuf2_vmalloc
videobuf2_memops iwlwifi binfmt_misc btrfs i915 cfbcopyarea cfbimgblt
cfbfillrect video
Pid: 4032, comm: btrfs Tainted: G        W    3.4.0-rc5-debug+ #7
Call Trace:
 [<ffffffff8103c5ca>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103c615>] warn_slowpath_null+0x15/0x20
 [<ffffffffa00af9bc>] use_block_rsv+0x15c/0x170 [btrfs]
 [<ffffffffa00b2a88>] btrfs_alloc_free_block+0x38/0x200 [btrfs]
 [<ffffffffa00e7d74>] ? read_extent_buffer+0xb4/0x110 [btrfs]
 [<ffffffffa00a08d0>] __btrfs_cow_block+0x130/0x4d0 [btrfs]
 [<ffffffffa00a0d67>] btrfs_cow_block+0xf7/0x1b0 [btrfs]
 [<ffffffffa01093bf>] do_relocation+0x45f/0x540 [btrfs]
 [<ffffffffa00a7871>] ? block_rsv_add_bytes+0x51/0x70 [btrfs]
 [<ffffffffa0109ca4>] relocate_tree_block+0x234/0x270 [btrfs]
 [<ffffffffa010c7b3>] relocate_tree_blocks+0x123/0x1a0 [btrfs]
 [<ffffffffa010d5bc>] relocate_block_group+0x1ec/0x560 [btrfs]
 [<ffffffffa010daf4>] btrfs_relocate_block_group+0x1c4/0x300 [btrfs]
 [<ffffffffa00eba3a>] btrfs_relocate_chunk.isra.52+0x4a/0x240 [btrfs]
 [<ffffffffa00e70da>] ? free_extent_buffer+0x2a/0x70 [btrfs]
 [<ffffffffa00eeb34>] __btrfs_balance+0x2f4/0x3f0 [btrfs]
 [<ffffffffa00eef23>] btrfs_balance+0x2f3/0x4d0 [btrfs]
 [<ffffffffa00f543b>] btrfs_ioctl_balance.isra.53+0xeb/0x470 [btrfs]
 [<ffffffff8102817c>] ? do_page_fault+0x1fc/0x460
 [<ffffffffa00f7ab1>] btrfs_ioctl+0x91/0x770 [btrfs]
 [<ffffffff810ea8e6>] ? do_brk+0x246/0x360
 [<ffffffff811286d7>] do_vfs_ioctl+0x87/0x340
 [<ffffffff812232e4>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff811289da>] sys_ioctl+0x4a/0x80
 [<ffffffff815ad1a2>] system_call_fastpath+0x16/0x1b
---[ end trace e8b31383e015594e ]---
btrfs: block rsv returned -28
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:6219 use_block_rsv+0x15c/0x170 [btrfs]()
Hardware name: Latitude E5420
Modules linked in: brd dm_crypt dm_mod kvm_intel kvm coretemp
microcode uvcvideo videobuf2_core videodev videobuf2_vmalloc
videobuf2_memops iwlwifi binfmt_misc btrfs i915 cfbcopyarea cfbimgblt
cfbfillrect video
Pid: 4032, comm: btrfs Tainted: G        W    3.4.0-rc5-debug+ #7
Call Trace:
 [<ffffffff8103c5ca>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103c615>] warn_slowpath_null+0x15/0x20
 [<ffffffffa00af9bc>] use_block_rsv+0x15c/0x170 [btrfs]
 [<ffffffffa00b2a88>] btrfs_alloc_free_block+0x38/0x200 [btrfs]
 [<ffffffffa00e7d74>] ? read_extent_buffer+0xb4/0x110 [btrfs]
 [<ffffffffa00a08d0>] __btrfs_cow_block+0x130/0x4d0 [btrfs]
 [<ffffffffa00a0d67>] btrfs_cow_block+0xf7/0x1b0 [btrfs]
 [<ffffffffa01093bf>] do_relocation+0x45f/0x540 [btrfs]
 [<ffffffffa00a7871>] ? block_rsv_add_bytes+0x51/0x70 [btrfs]
 [<ffffffffa0109ca4>] relocate_tree_block+0x234/0x270 [btrfs]
 [<ffffffffa010c7b3>] relocate_tree_blocks+0x123/0x1a0 [btrfs]
 [<ffffffffa010d5bc>] relocate_block_group+0x1ec/0x560 [btrfs]
 [<ffffffffa010daf4>] btrfs_relocate_block_group+0x1c4/0x300 [btrfs]
 [<ffffffffa00eba3a>] btrfs_relocate_chunk.isra.52+0x4a/0x240 [btrfs]
 [<ffffffffa00e70da>] ? free_extent_buffer+0x2a/0x70 [btrfs]
 [<ffffffffa00eeb34>] __btrfs_balance+0x2f4/0x3f0 [btrfs]
 [<ffffffffa00eef23>] btrfs_balance+0x2f3/0x4d0 [btrfs]
 [<ffffffffa00f543b>] btrfs_ioctl_balance.isra.53+0xeb/0x470 [btrfs]
 [<ffffffff8102817c>] ? do_page_fault+0x1fc/0x460
 [<ffffffffa00f7ab1>] btrfs_ioctl+0x91/0x770 [btrfs]
 [<ffffffff810ea8e6>] ? do_brk+0x246/0x360
 [<ffffffff811286d7>] do_vfs_ioctl+0x87/0x340
 [<ffffffff812232e4>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff811289da>] sys_ioctl+0x4a/0x80
 [<ffffffff815ad1a2>] system_call_fastpath+0x16/0x1b
---[ end trace e8b31383e015594f ]---
btrfs: run_one_delayed_ref returned -28
------------[ cut here ]------------
WARNING: at fs/btrfs/super.c:219 __btrfs_abort_transaction+0xa6/0xc0 [btrfs]()
Hardware name: Latitude E5420
btrfs: Transaction aborted
Modules linked in: brd dm_crypt dm_mod kvm_intel kvm coretemp
microcode uvcvideo videobuf2_core videodev videobuf2_vmalloc
videobuf2_memops iwlwifi binfmt_misc btrfs i915 cfbcopyarea cfbimgblt
cfbfillrect video
Pid: 4032, comm: btrfs Tainted: G        W    3.4.0-rc5-debug+ #7
Call Trace:
 [<ffffffff8103c5ca>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103c6a1>] warn_slowpath_fmt+0x41/0x50
 [<ffffffffa009dc76>] __btrfs_abort_transaction+0xa6/0xc0 [btrfs]
 [<ffffffffa00b1736>] btrfs_run_delayed_refs+0x296/0x300 [btrfs]
 [<ffffffffa00c2104>] btrfs_commit_transaction+0xb4/0x900 [btrfs]
 [<ffffffff8105e250>] ? __init_waitqueue_head+0x60/0x60
 [<ffffffff815ac546>] ? _raw_spin_unlock+0x26/0x40
 [<ffffffffa010d602>] relocate_block_group+0x232/0x560 [btrfs]
 [<ffffffffa010daf4>] btrfs_relocate_block_group+0x1c4/0x300 [btrfs]
 [<ffffffffa00eba3a>] btrfs_relocate_chunk.isra.52+0x4a/0x240 [btrfs]
 [<ffffffffa00e70da>] ? free_extent_buffer+0x2a/0x70 [btrfs]
 [<ffffffffa00eeb34>] __btrfs_balance+0x2f4/0x3f0 [btrfs]
 [<ffffffffa00eef23>] btrfs_balance+0x2f3/0x4d0 [btrfs]
 [<ffffffffa00f543b>] btrfs_ioctl_balance.isra.53+0xeb/0x470 [btrfs]
 [<ffffffff8102817c>] ? do_page_fault+0x1fc/0x460
 [<ffffffffa00f7ab1>] btrfs_ioctl+0x91/0x770 [btrfs]
 [<ffffffff810ea8e6>] ? do_brk+0x246/0x360
 [<ffffffff811286d7>] do_vfs_ioctl+0x87/0x340
 [<ffffffff812232e4>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff811289da>] sys_ioctl+0x4a/0x80
 [<ffffffff815ad1a2>] system_call_fastpath+0x16/0x1b
---[ end trace e8b31383e0155950 ]---
BTRFS error (device ram1) in btrfs_run_delayed_refs:2454: error 28
btrfs is forced readonly
BTRFS warning (device ram1): Skipping commit of aborted transaction.
...
-- 
Daniel J Blueman
