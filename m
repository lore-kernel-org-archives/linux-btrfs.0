From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: write(2) taking 4s. (Was: Memory leak?)
Date: Sat, 16 Jul 2011 17:22:10 +0100
Message-ID: <20110716162210.GB5638@yahoo.fr>
References: <20110706081111.GA6931@yahoo.fr>
 <20110708124429.GB4284@yahoo.fr>
 <1310137241-sup-8158@shiny>
 <20110709170959.GC4294@yahoo.fr>
 <CAE5mzvhZwrtEZ8FUfcYzoMsRwuPjNDn=iCZ6_-CKaifEPZWAKA@mail.gmail.com>
 <20110709203649.GE4294@yahoo.fr>
 <1310301809-sup-9903@shiny>
 <20110710183728.GB4277@yahoo.fr>
 <20110711090121.GA2537@yahoo.fr>
 <20110716121210.GA5638@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110716121210.GA5638@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-16 13:12:10 +0100, Stephane Chazelas:
[...]
> ntfsclone (patched to only write modified clusters):
> 
> # strace -Te write -p 4717
> Process 4717 attached - interrupt to quit
> write(1, " 65.16 percent completed\r", 25) = 25 <0.008996>
> write(1, " 65.16 percent completed\r", 25) = 25 <0.743358>
> write(1, " 65.16 percent completed\r", 25) = 25 <0.306582>
> write(1, " 65.17 percent completed\r", 25) = 25 <4.082723>
> write(1, " 65.17 percent completed\r", 25) = 25 <0.006402>
> write(1, " 65.17 percent completed\r", 25) = 25 <0.012582>
> write(1, " 65.17 percent completed\r", 25) = 25 <4.052504>
> write(1, " 65.17 percent completed\r", 25) = 25 <0.012111>
> write(1, " 65.17 percent completed\r", 25) = 25 <0.016001>
> write(1, " 65.17 percent completed\r", 25) = 25 <4.028017>
> write(1, " 65.18 percent completed\r", 25) = 25 <0.013365>
> write(1, " 65.18 percent completed\r", 25) = 25 <0.003963>
> (that's writing to a log file)
> 
> See how many write(2)s take 4 seconds.
[...]

top - 17:14:18 up 1 day,  9:20,  3 users,  load average: 1.00, 1.06, 1.11
Tasks: 146 total,   1 running, 145 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0%us,  0.0%sy,  0.0%ni, 25.0%id, 75.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   5094800k total,  4616412k used,   478388k free,  1420192k buffers
Swap:  4194300k total,     8720k used,  4185580k free,  2266240k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 2156 root      20   0     0    0    0 D    0  0.0   0:00.02 0 flush-btrfs-1
 6206 root      20   0 19112 1284  916 R    0  0.0   0:00.09 0 top
    1 root      20   0  8400  220  196 S    0  0.0   0:02.26 0 init
(all the other processes sleeping)

I suspect load 1 is for that flush-btrfs-1 in

[86372.445554] flush-btrfs-1   D ffff88014438da30     0  2156      2 0x00000000
[86372.445554]  ffff88014438da30 0000000000000046 ffffffff8100e366 ffff88014438a9a0
[86372.445554]  00000000000127c0 ffff880021501fd8 ffff880021501fd8 00000000000127c0
[86372.445554]  ffff88014438da30 ffff880021500010 ffffffff8100e366 ffffffff81066ec6
[86372.445554] Call Trace:
[86372.445554]  [<ffffffff8100e366>] ? read_tsc+0x5/0x16
[86372.445554]  [<ffffffff8100e366>] ? read_tsc+0x5/0x16
[86372.445554]  [<ffffffff81066ec6>] ? timekeeping_get_ns+0xd/0x2a
[86372.445554]  [<ffffffff810b607c>] ? __lock_page+0x63/0x63
[86372.445554]  [<ffffffff81339473>] ? io_schedule+0x84/0xc3
[86372.445554]  [<ffffffff811aa0aa>] ? radix_tree_gang_lookup_tag_slot+0x7a/0x9f
[86372.445554]  [<ffffffff810b6085>] ? sleep_on_page+0x9/0xd
[86372.445554]  [<ffffffff813399d5>] ? __wait_on_bit_lock+0x3c/0x85
[86372.445554]  [<ffffffff810b6076>] ? __lock_page+0x5d/0x63
[86372.445554]  [<ffffffff8105fff7>] ? autoremove_wake_function+0x2a/0x2a
[86372.445554]  [<ffffffffa0192784>] ? T.1090+0xba/0x234 [btrfs]
[86372.445554]  [<ffffffffa01929ee>] ? extent_writepages+0x40/0x56 [btrfs]
[86372.445554]  [<ffffffffa017e5f0>] ? btrfs_submit_direct+0x403/0x403 [btrfs]
[86372.445554]  [<ffffffff8111b29c>] ? writeback_single_inode+0xb8/0x1b8
[86372.445554]  [<ffffffff8111b5af>] ? writeback_sb_inodes+0xc2/0x13b
[86372.445554]  [<ffffffff8111b96e>] ? writeback_inodes_wb+0xfd/0x10f
[86372.445554]  [<ffffffff8111c088>] ? wb_writeback+0x213/0x330
[86372.445554]  [<ffffffff81052368>] ? lock_timer_base+0x25/0x49
[86372.445554]  [<ffffffff8111c312>] ? wb_do_writeback+0x16d/0x1fc
[86372.445554]  [<ffffffff81052824>] ? del_timer_sync+0x34/0x3e
[86372.445554]  [<ffffffff8111c464>] ? bdi_writeback_thread+0xc3/0x1ff
[86372.445554]  [<ffffffff8111c3a1>] ? wb_do_writeback+0x1fc/0x1fc
[86372.445554]  [<ffffffff8111c3a1>] ? wb_do_writeback+0x1fc/0x1fc
[86372.445554]  [<ffffffff8105fb91>] ? kthread+0x7a/0x82
[86372.445554]  [<ffffffff81340f24>] ? kernel_thread_helper+0x4/0x10
[86372.445554]  [<ffffffff8105fb17>] ? kthread_worker_fn+0x147/0x147
[86372.445554]  [<ffffffff81340f20>] ? gs_change+0x13/0x13

Also, if I run sync(1), it seems to never return.

[120348.788021] sync            D ffff88011b3e1bc0     0  6215   1789 0x00000000
[120348.788021]  ffff88011b3e1bc0 0000000000000082 0000000000000000 ffffffff8160b020
[120348.788021]  00000000000127c0 ffff8800b0f25fd8 ffff8800b0f25fd8 00000000000127c0
[120348.788021]  ffff88011b3e1bc0 ffff8800b0f24010 ffff88011b3e1bc0 000000014fc127c0
[120348.788021] Call Trace:
[120348.788021]  [<ffffffff8133989f>] ? schedule_timeout+0x2d/0xd7
[120348.788021]  [<ffffffff8111f2fa>] ? __sync_filesystem+0x74/0x74
[120348.788021]  [<ffffffff81339714>] ? wait_for_common+0xd1/0x14e
[120348.788021]  [<ffffffff810427f2>] ? try_to_wake_up+0x18c/0x18c
[120348.788021]  [<ffffffff8111f2fa>] ? __sync_filesystem+0x74/0x74
[120348.788021]  [<ffffffff8111f2fa>] ? __sync_filesystem+0x74/0x74
[120348.788021]  [<ffffffff8111bab6>] ? writeback_inodes_sb_nr+0x72/0x78
[120348.788021]  [<ffffffff8111f2d4>] ? __sync_filesystem+0x4e/0x74
[120348.788021]  [<ffffffff81100d0d>] ? iterate_supers+0x5e/0xab
[120348.788021]  [<ffffffff8111f337>] ? sys_sync+0x28/0x53
[120348.788021]  [<ffffffff8133fe12>] ? system_call_fastpath+0x16/0x1b

-- 
Stephane
