From: Philip Love <Love_Phil@emc.com>
Subject: Re: btrfs bug while defragmenting
Date: Tue, 9 Mar 2010 12:06:36 -0800
Message-ID: <B908B307-41C6-4F40-BD6B-451FDD32EF8B@emc.com>
References: <D09C8589-EA52-4778-8B29-1B06B27292D0@emc.com> <20100309192516.GQ15485@think>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100309192516.GQ15485@think>
List-ID: <linux-btrfs.vger.kernel.org>


> Well, I don't think that count is quite right.  But I also don't see
> anything in the ioctl that could cause it.  How easily can you reproduce
> this?
> 
> I do see that the ioctl should be triple checking the page is part of
> the mapping after doing a readpage on it, but it should only get dropped
> in the face of truncate.  Is this file actively in use at the time that
> you're running the ioctl?
> 
I reproduced it again. The fs is idle apart from the defragment.

mount -o nodatacow /dev/sdc1 backend
btrfsctl -d /mnt/backend/phil/i2

i2 is a 10GB file (initially created with dd) that is heavily fragmented since it was use to test random write io.

Here is the fio job that I was previously using on this file, the fs was mounted with cow when doing the tests.

[global]
directory=/mnt/backend/phil
ioengine=posixaio
iodepth=16
filesize=10g
direct=1
filename=i1:i2:i3:i4:i5:i6:i7:i8

[rand-write]
norandommap
numjobs=4
rw=randwrite
bs=4k
size=100m
end_fsync=1
stonewall

Here was the fio output, as a side note I noticed that the max clat was 16 seconds.

rand-write: (groupid=0, jobs=1): err= 0: pid=5343
  write: io=100MB, bw=849KB/s, iops=212, runt=120733msec
    slat (usec): min=0, max=1,269, avg= 1.14, stdev= 8.43
    clat (msec): min=2, max=16,927, avg=75.37, stdev=486.27
    bw (KB/s) : min=    0, max= 4307, per=34.09%, avg=1107.50, stdev=987.95
  cpu          : usr=0.22%, sys=0.87%, ctx=45803, majf=0, minf=89
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.9%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w: total=0/25615, short=0/0

     lat (msec): 4=0.19%, 10=16.58%, 20=18.10%, 50=28.55%, 100=20.19%
     lat (msec): 250=13.83%, 500=2.21%, 750=0.17%, >=2000=0.19%

Run status group 0 (all jobs):
  WRITE: io=400MB, aggrb=3,249KB/s, minb=831KB/s, maxb=875KB/s, mint=119841msec, maxt=126134msec



Mar  9 11:51:59 sentryA kernel: [ 5781.604400] btrfs: setting nodatacow
Mar  9 11:55:11 sentryA kernel: [ 5969.275082] BUG: Bad page state in process btrfsctl  pfn:1efe9a
Mar  9 11:55:11 sentryA kernel: [ 5969.275093] BUG: unable to handle kernel NULL pointer dereference at 000000000000000a
Mar  9 11:55:11 sentryA kernel: [ 5969.368991] IP: [<ffffffff810a2dbd>] bad_page+0xe6/0x118
Mar  9 11:55:11 sentryA kernel: [ 5969.432615] PGD 30f9fe067 PUD 329661067 PMD 0 
Mar  9 11:55:11 sentryA kernel: [ 5969.486052] Oops: 0000 [#1] SMP 
Mar  9 11:55:11 sentryA kernel: [ 5969.524834] last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
Mar  9 11:55:11 sentryA kernel: [ 5969.618514] CPU 1 
Mar  9 11:55:11 sentryA kernel: [ 5969.642634] Pid: 4344, comm: btrfsctl Not tainted 2.6.33-5-default #1 GreenCity/Silkcity CRB/Ty
lersburg & ICH9/ICH10 Chipset
Mar  9 11:55:11 sentryA kernel: [ 5969.776864] RIP: 0010:[<ffffffff810a2dbd>]  [<ffffffff810a2dbd>] bad_page+0xe6/0x118
Mar  9 11:55:11 sentryA kernel: [ 5969.869595] RSP: 0018:ffff8802dc82fa28  EFLAGS: 00010286
Mar  9 11:55:11 sentryA kernel: [ 5969.933118] RAX: 0000000000000002 RBX: ffffea0006c7b1b0 RCX: 0000000000000aed
Mar  9 11:55:11 sentryA kernel: [ 5970.018470] RDX: ffff88002e47b000 RSI: 000000000000000c RDI: ffffffff81717960
Mar  9 11:55:11 sentryA kernel: [ 5970.103830] RBP: ffff8802dc82fa38 R08: 00000000ffffc900 R09: 0000000000000000
Mar  9 11:55:11 sentryA kernel: [ 5970.189193] R10: 0000000000000000 R11: 0000000000018600 R12: ffff8803318df0c0
Mar  9 11:55:11 sentryA kernel: [ 5970.274548] R13: dead000000200200 R14: 0000000000000286 R15: ffff88000002ee00
Mar  9 11:55:11 sentryA kernel: [ 5970.359903] FS:  00007f683d913740(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
Mar  9 11:55:11 sentryA kernel: [ 5970.456697] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar  9 11:55:11 sentryA kernel: [ 5970.525420] CR2: 000000000000000a CR3: 000000032890d000 CR4: 00000000000006e0
Mar  9 11:55:11 sentryA kernel: [ 5970.610777] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar  9 11:55:11 sentryA kernel: [ 5970.696144] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar  9 11:55:11 sentryA kernel: [ 5970.781496] Process btrfsctl (pid: 4344, threadinfo ffff8802dc82e000, task ffff8803277dc140)
Mar  9 11:55:11 sentryA kernel: [ 5970.882449] Stack:
Mar  9 11:55:11 sentryA kernel: [ 5970.906466]  ffffea0006c7b1b0 ffffea0006c7b1b0 ffff8802dc82fb68 ffffffff810a4fb2
Mar  9 11:55:11 sentryA kernel: [ 5970.993184] <0> ffff8802dc82fb00 ffff8802dc82e000 0000000000000030 0000000000000002
Mar  9 11:55:11 sentryA kernel: [ 5971.085308] <0> ffff8803277dc9c0 ffff8802dc82ffd8 00000000dc82fad8 0000000000000286
Mar  9 11:55:11 sentryA kernel: [ 5971.179611] Call Trace:
Mar  9 11:55:11 sentryA kernel: [ 5971.208830]  [<ffffffff810a4fb2>] get_page_from_freelist+0x49e/0x707
Mar  9 11:55:11 sentryA kernel: [ 5971.284829]  [<ffffffff810a542e>] __alloc_pages_nodemask+0x123/0x64d
Mar  9 11:55:11 sentryA kernel: [ 5971.360845]  [<ffffffffa030b8dd>] ? submit_one_bio+0x7e/0x8a [btrfs]
Mar  9 11:55:11 sentryA kernel: [ 5971.436957]  [<ffffffffa030ec36>] ? extent_readpages+0x16e/0x197 [btrfs]
Mar  9 11:55:11 sentryA kernel: [ 5971.517219]  [<ffffffff8119cb0c>] ? prop_fraction_single+0x3c/0x5e
Mar  9 11:55:11 sentryA kernel: [ 5971.591142]  [<ffffffff810c9210>] alloc_pages_current+0x96/0x9f
Mar  9 11:55:14 sentryA kernel: [ 5971.661946]  [<ffffffff8109f60e>] __page_cache_alloc+0x59/0x5d
Mar  9 11:55:14 sentryA kernel: [ 5971.731717]  [<ffffffff810a6e3a>] __do_page_cache_readahead+0x96/0x1a2
Mar  9 11:55:14 sentryA kernel: [ 5971.809799]  [<ffffffff810a6f62>] ra_submit+0x1c/0x20
Mar  9 11:55:14 sentryA kernel: [ 5971.870213]  [<ffffffff810a71f2>] ondemand_readahead+0x1b2/0x1c5
Mar  9 11:55:14 sentryA kernel: [ 5971.942054]  [<ffffffff810a72be>] page_cache_sync_readahead+0x17/0x19
Mar  9 11:55:14 sentryA kernel: [ 5972.019122]  [<ffffffffa02f51e1>] btrfs_force_ra+0x1c/0x25 [btrfs]
Mar  9 11:55:14 sentryA kernel: [ 5972.093145]  [<ffffffffa03183a3>] btrfs_ioctl+0x558/0x959 [btrfs]
Mar  9 11:55:14 sentryA kernel: [ 5972.166130]  [<ffffffff810e26e4>] vfs_ioctl+0x2a/0x9e
Mar  9 11:55:14 sentryA kernel: [ 5972.226543]  [<ffffffff810e2c15>] do_vfs_ioctl+0x442/0x47f
Mar  9 11:55:14 sentryA kernel: [ 5972.292151]  [<ffffffff8119e5e7>] ? __up_read+0x9e/0xa7
Mar  9 11:55:15 sentryA kernel: [ 5972.354647]  [<ffffffff810568fb>] ? up_read+0x9/0xb
Mar  9 11:55:15 sentryA kernel: [ 5972.412974]  [<ffffffff810e2ca7>] sys_ioctl+0x55/0x77
Mar  9 11:55:15 sentryA kernel: [ 5972.473391]  [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
Mar  9 11:55:15 sentryA kernel: [ 5972.545332] Code: 13 48 c1 fa 03 48 0f af d0 31 c0 e8 77 ff 1e 00 48 8b 13 48 8b 73 20 4c 8b 4b
 18 44 8b 43 0c 48 89 d8 66 85 d2 79 04 48 8b 43 10 <8b> 48 08 41 ff c0 48 89 34 24 48 c7 c7 b7 2d 39 81 48 89 de 31 
Mar  9 11:55:15 sentryA kernel: [ 5972.777813] RIP  [<ffffffff810a2dbd>] bad_page+0xe6/0x118
Mar  9 11:55:15 sentryA kernel: [ 5972.842487]  RSP <ffff8802dc82fa28>
Mar  9 11:55:15 sentryA kernel: [ 5972.884179] CR2: 000000000000000a
Mar  9 11:55:15 sentryA kernel: [ 5972.923939] ---[ end trace ff6ec4d6b9203041 ]---
Mar  9 11:55:15 sentryA kernel: [ 5973.283636] BUG: Bad page state in process kjournald  pfn:1efe9d
Mar  9 11:55:15 sentryA kernel: [ 5973.355494] page:ffffea0006c7b258 flags:0000000000001040 count:9216 mapcount:1 mapping:(null) i
ndex:0
Mar  9 11:55:15 sentryA kernel: [ 5973.465810] Pid: 553, comm: kjournald Tainted: G      D    2.6.33-5-default #1
Mar  9 11:55:15 sentryA kernel: [ 5973.552281] Call Trace:
Mar  9 11:55:15 sentryA kernel: [ 5973.581533]  [<ffffffff810a2ddd>] bad_page+0x106/0x118
Mar  9 11:55:15 sentryA kernel: [ 5973.643086]  [<ffffffff810a4fb2>] get_page_from_freelist+0x49e/0x707
Mar  9 11:55:15 sentryA kernel: [ 5973.719201]  [<ffffffff810a542e>] __alloc_pages_nodemask+0x123/0x64d
Mar  9 11:55:15 sentryA kernel: [ 5973.795351]  [<ffffffff8109f1c2>] ? find_get_page+0x23/0x8f
Mar  9 11:55:15 sentryA kernel: [ 5973.862047]  [<ffffffff810c9210>] alloc_pages_current+0x96/0x9f
Mar  9 11:55:15 sentryA kernel: [ 5973.932848]  [<ffffffff8109f60e>] __page_cache_alloc+0x59/0x5d
Mar  9 11:55:15 sentryA kernel: [ 5974.002612]  [<ffffffff8109fd58>] find_or_create_page+0x41/0x85
Mar  9 11:55:15 sentryA kernel: [ 5974.073463]  [<ffffffff810f622c>] __getblk+0x11a/0x2a5
Mar  9 11:55:15 sentryA kernel: [ 5974.134979]  [<ffffffffa00300b6>] journal_get_descriptor_buffer+0x33/0x7f [jbd]
Mar  9 11:55:15 sentryA kernel: [ 5974.222531]  [<ffffffffa002bfd5>] journal_commit_transaction+0xe37/0x12d2 [jbd]
Mar  9 11:55:15 sentryA kernel: [ 5974.310108]  [<ffffffff81046ff7>] ? try_to_del_timer_sync+0xa5/0xb2
Mar  9 11:55:15 sentryA kernel: [ 5974.385130]  [<ffffffffa002f7a3>] kjournald+0x164/0x396 [jbd]
Mar  9 11:55:15 sentryA kernel: [ 5974.453958]  [<ffffffff81053084>] ? autoremove_wake_function+0x0/0x38
Mar  9 11:55:15 sentryA kernel: [ 5974.531179]  [<ffffffffa002f63f>] ? kjournald+0x0/0x396 [jbd]
Mar  9 11:55:15 sentryA kernel: [ 5974.599945]  [<ffffffff81052c1a>] kthread+0x7d/0x85
Mar  9 11:55:15 sentryA kernel: [ 5974.658372]  [<ffffffff81003754>] kernel_thread_helper+0x4/0x10
Mar  9 11:55:15 sentryA kernel: [ 5974.729290]  [<ffffffff81052b9d>] ? kthread+0x0/0x85
Mar  9 11:55:15 sentryA kernel: [ 5974.788795]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
Mar  9 11:55:15 sentryA kernel: [ 5974.861723] BUG: Bad page state in process kjournald  pfn:1efe9c
Mar  9 11:55:15 sentryA kernel: [ 5974.933585] page:ffffea0006c7b220 flags:0040000000000000 count:0 mapcount:0 mapping:ffffffffa02
a13a8 index:ffffc900028a6878
Mar  9 11:55:15 sentryA kernel: [ 5975.066896] Pid: 553, comm: kjournald Tainted: G    B D    2.6.33-5-default #1
Mar  9 11:55:15 sentryA kernel: [ 5975.153368] Call Trace:
Mar  9 11:55:15 sentryA kernel: [ 5975.182600]  [<ffffffff810a2ddd>] bad_page+0x106/0x118
Mar  9 11:55:15 sentryA kernel: [ 5975.244143]  [<ffffffff810a4fb2>] get_page_from_freelist+0x49e/0x707
Mar  9 11:55:15 sentryA kernel: [ 5975.320281]  [<ffffffff810a542e>] __alloc_pages_nodemask+0x123/0x64d
Mar  9 11:55:15 sentryA kernel: [ 5975.396363]  [<ffffffff8109f1c2>] ? find_get_page+0x23/0x8f
Mar  9 11:55:15 sentryA kernel: [ 5975.463014]  [<ffffffff810c9210>] alloc_pages_current+0x96/0x9f
Mar  9 11:55:15 sentryA kernel: [ 5975.533956]  [<ffffffff8109f60e>] __page_cache_alloc+0x59/0x5d
Mar  9 11:55:16 sentryA kernel: [ 5975.603808]  [<ffffffff8109fd58>] find_or_create_page+0x41/0x85
Mar  9 11:55:16 sentryA kernel: [ 5975.674725]  [<ffffffff810f622c>] __getblk+0x11a/0x2a5
Mar  9 11:55:16 sentryA kernel: [ 5975.736264]  [<ffffffffa00300b6>] journal_get_descriptor_buffer+0x33/0x7f [jbd]
Mar  9 11:55:16 sentryA kernel: [ 5975.823855]  [<ffffffffa002bfd5>] journal_commit_transaction+0xe37/0x12d2 [jbd]
Mar  9 11:55:16 sentryA kernel: [ 5975.911358]  [<ffffffff81046ff7>] ? try_to_del_timer_sync+0xa5/0xb2
Mar  9 11:55:16 sentryA kernel: [ 5975.986423]  [<ffffffffa002f7a3>] kjournald+0x164/0x396 [jbd]
Mar  9 11:55:16 sentryA kernel: [ 5976.055175]  [<ffffffff81053084>] ? autoremove_wake_function+0x0/0x38
Mar  9 11:55:16 sentryA kernel: [ 5976.132284]  [<ffffffffa002f63f>] ? kjournald+0x0/0x396 [jbd]
Mar  9 11:55:16 sentryA kernel: [ 5976.201003]  [<ffffffff81052c1a>] kthread+0x7d/0x85
Mar  9 11:55:16 sentryA kernel: [ 5976.259370]  [<ffffffff81003754>] kernel_thread_helper+0x4/0x10
Mar  9 11:55:16 sentryA kernel: [ 5976.330246]  [<ffffffff81052b9d>] ? kthread+0x0/0x85
Mar  9 11:55:16 sentryA kernel: [ 5976.389626]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10


