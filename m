From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Re: btrfs lockup after mounting for a second time on 2.6.26
Date: Thu, 12 Feb 2009 12:08:21 -0500
Message-ID: <20090212170821.GA27379@tux64-01>
References: <4993C23C.8000108@cs.drexel.edu> <1234450272.8300.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lee Trager <lt73@cs.drexel.edu>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1234450272.8300.2.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Opps didn't include the entire thing last time...

[  227.637684] SysRq : Show Blocked State
[  227.639369]   task                PC stack   pid father
[  227.639369] ls            D f784b9d4     0  3101   3003
[  227.639369]        f74e4da0 00000082 0000d950 f784b9d4 0000d950 f74e4f2c c1815fa0 00000001 
[  227.639369]        f784b9cc ffff9728 c18031b4 c013604c 00000000 00000000 00000000 000000ff 
[  227.639369]        c1815fa0 0145b000 c18031b4 c015688a c02b8498 f3459bb4 f3459bb4 c01568bd 
[  227.639369] Call Trace:
[  227.639369]  [<c013604c>] getnstimeofday+0x37/0xbc
[  227.639369]  [<c015688a>] sync_page+0x0/0x36
[  227.639369]  [<c02b8498>] io_schedule+0x49/0x80
[  227.639369]  [<c01568bd>] sync_page+0x33/0x36
[  227.639369]  [<c02b85c4>] __wait_on_bit_lock+0x2a/0x52
[  227.639369]  [<c015687c>] __lock_page+0x4e/0x54
[  227.639369]  [<c0131909>] wake_bit_function+0x0/0x3c
[  227.639369]  [<f8ce8312>] read_extent_buffer_pages+0x133/0x2f1 [btrfs]
[  227.639369]  [<c0117b50>] kmap_atomic_prot+0x9d/0xcc
[  227.639369]  [<f8ccd550>] btree_read_extent_buffer_pages+0x39/0x8c [btrfs]
[  227.639369]  [<f8ccf219>] btree_get_extent+0x0/0x173 [btrfs]
[  227.639369]  [<f8ccd856>] read_tree_block+0x29/0x4c [btrfs]
[  227.639369]  [<f8cb9c4a>] read_node_slot+0xa4/0xb2 [btrfs]
[  227.639369]  [<f8cbe46f>] btrfs_next_leaf+0x16f/0x27d [btrfs]
[  227.639369]  [<f8cc080a>] cache_block_group+0xe9/0x2a0 [btrfs]
[  227.639369]  [<c0184354>] alloc_inode+0x12e/0x186
[  227.639369]  [<f8cc1554>] find_free_extent+0x32a/0x7b2 [btrfs]
[  227.639369]  [<f8cc1bb1>] __btrfs_reserve_extent+0x1d5/0x370 [btrfs]
[  227.639369]  [<f8cc1d8b>] btrfs_reserve_extent+0x3f/0x61 [btrfs]
[  227.639369]  [<f8cbddbb>] btrfs_search_slot+0x257/0x79c [btrfs]
[  227.639369]  [<c0117c79>] kunmap_atomic+0x67/0x8a
[  227.639369]  [<f8ccccff>] btrfs_lookup_inode+0x27/0x88 [btrfs]
[  227.639369]  [<f8cd56c0>] btrfs_update_inode+0x3d/0xae [btrfs]
[  227.639369]  [<f8cd64e4>] btrfs_dirty_inode+0x3d/0x4a [btrfs]
[  227.639369]  [<c018cc33>] __mark_inode_dirty+0x21/0x12a
[  227.639369]  [<c0184f0a>] touch_atime+0xc7/0xd1
[  227.639369]  [<c017e8df>] vfs_readdir+0x75/0x8c
[  227.639369]  [<c017e6ec>] filldir64+0x0/0xc5
[  227.639369]  [<c017e959>] sys_getdents64+0x63/0xa5
[  227.639369]  [<c0103853>] sysenter_past_esp+0x78/0xb1
[  227.639369]  =======================
[  227.639369] Sched Debug Version: v0.07, 2.6.26-1-686 #1
[  227.639369] now at 210726.291061 msecs
[  227.639369]   .sysctl_sched_latency                    : 40.000000
[  227.639369]   .sysctl_sched_min_granularity            : 8.000000
[  227.639369]   .sysctl_sched_wakeup_granularity         : 20.000000
[  227.639369]   .sysctl_sched_child_runs_first           : 0.000001
[  227.639369]   .sysctl_sched_features                   : 895
[  227.639369] 
[  227.639369] cpu#0, 2200.225 MHz
[  227.639369]   .nr_running                    : 2
[  227.639369]   .load                          : 2048
[  227.639369]   .nr_switches                   : 34074
[  227.639369]   .nr_load_updates               : 15468
[  227.639369]   .nr_uninterruptible            : 4294967191
[  227.639369]   .jiffies                       : 4294944976
[  227.639369]   .next_balance                  : 4294.945040
[  227.639369]   .curr->pid                     : 3060
[  227.639369]   .clock                         : 210721.964922
[  227.639369]   .cpu_load[0]                   : 2048
[  227.639369]   .cpu_load[1]                   : 1024
[  227.639369]   .cpu_load[2]                   : 519
[  227.639369]   .cpu_load[3]                   : 299
[  227.639369]   .cpu_load[4]                   : 214
[  227.639369] 
[  227.639369] cfs_rq[0]:
[  227.639369]   .exec_clock                    : 0.000000
[  227.639369]   .MIN_vruntime                  : 49281.152431
[  227.639369]   .min_vruntime                  : 49309.797267
[  227.639369]   .max_vruntime                  : 49281.152431
[  227.639369]   .spread                        : 0.000000
[  227.639369]   .spread0                       : 0.000000
[  227.639369]   .nr_running                    : 2
[  227.639369]   .load                          : 2048
[  227.639369]   .nr_spread_over                : 0
[  227.639369] 
[  227.639369] runnable tasks:
[  227.639369]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  227.639369] ----------------------------------------------------------------------------------------------------------
[  227.639369]    vmware-guestd  2151     49281.152431      2020   120               0               0               0.000000               0.000000               0.000000 /
[  227.639369] R           bash  3060     49295.747111        63   120               0               0               0.000000               0.000000               0.000000 /
[  227.639369] 
[  227.639369] cpu#1, 2200.225 MHz
[  227.639369]   .nr_running                    : 2
[  227.639369]   .load                          : 2048
[  227.639369]   .nr_switches                   : 26399
[  227.639369]   .nr_load_updates               : 14353
[  227.639369]   .nr_uninterruptible            : 106
[  227.639369]   .jiffies                       : 4294944976
[  227.639369]   .next_balance                  : 4294.945104
[  227.639369]   .curr->pid                     : 2411
[  227.639369]   .clock                         : 210728.301926
[  227.639369]   .cpu_load[0]                   : 2048
[  227.639369]   .cpu_load[1]                   : 1024
[  227.639369]   .cpu_load[2]                   : 519
[  227.639369]   .cpu_load[3]                   : 321
[  227.639369]   .cpu_load[4]                   : 275
[  227.639369] 
[  227.639369] cfs_rq[1]:
[  227.639369]   .exec_clock                    : 0.000000
[  227.639369]   .MIN_vruntime                  : 34787.608965
[  227.639369]   .min_vruntime                  : 34826.431444
[  227.639369]   .max_vruntime                  : 34787.608965
[  227.639369]   .spread                        : 0.000000
[  227.639369]   .spread0                       : -14483.365823
[  227.639369]   .nr_running                    : 2
[  227.639369]   .load                          : 2048
[  227.639369]   .nr_spread_over                : 0
[  227.639369] 
[  227.639369] runnable tasks:
[  227.639369]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  227.639369] ----------------------------------------------------------------------------------------------------------
[  227.639369] R        syslogd  2411     34791.757624       811   120               0               0               0.000000               0.000000               0.000000 /
[  227.639369]            klogd  2420     34787.608965       605   120               0               0               0.000000               0.000000               0.000000 /
[  227.639369] 

On Thu, Feb 12, 2009 at 09:51:12AM -0500, Chris Mason wrote:
> On Thu, 2009-02-12 at 01:31 -0500, Lee Trager wrote:
> > While running a few tests with the btrfs sources pulled from
> > btrfs-unstable patched with my patch to compile under 2.6.26 I
> > encountered a very weird problem. Everything works fine the first time I
> > mount the file system (either actual disk or loop back). When I
> > unmounted the file system and mounted it again(I'm not doing mount -o
> > remount ...) btrfs is completely unusable. When I tried to view some of
> > the data which I previously put on the btrfs partition by doing a simple
> > ls /mnt/btrfs in bash nothing happens. ls shows nothing, just hangs, and
> > I am unable to kill ls. The same thing happens when I try to copy a file
> > from my ext3 partition onto the btrfs partition after mounting it for a
> > second time. The rest of the system is completely usable and the only
> > things that are effects are applications which are trying to read/write
> > from the btrfs file system. There are no kernel opps or any other errors
> > messages in any of my logs. This happens if I have compression on or
> > not. I'd be happy to fix this issue but I don't have a clue about where
> > to start looking for what is wrong.
> > 
> > Could someone please help me?
> 
> Thanks for working on this.  The first step is to figure out what ls is
> doing, and my guess is trying to read block groups.  Do a sysrq-w while
> it is hung and send the results along.
> 
> -chris
> 
