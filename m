From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: New experimental btrfs branch ready for testing
Date: Thu, 04 Jun 2009 14:02:20 -0500
Message-ID: <4A281A3C.6000006@austin.ibm.com>
References: <20090601210447.GC3890@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090601210447.GC3890@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> Hello everyone,
>
> Yan Zheng has been doing some major surgery to the back references and
> extent allocation code, tackling bottlenecks in the code that tracks
> extents.  It scales better with many snapshots and performs better in
> the common case of no snapshots at all.
>
> THE NEW CODE IS A FORWARD ROLLING DISK FORMAT CHANGE.  This means it is
> compatible with the current btrfs disk format, but once you mount a
> filesystem with the new code, it WILL NO LONGER BE MOUNTABLE FROM OLD
> KERNELS.  Old kernels spit out an error message when you try them on new
> format filesystems.
>
> This is a large change, and I'm hoping to have it stable in time for the
> 2.6.31 merge window.  I've been testing it for about a week now, and
> haven't been able to cause major problems yet.  But, testing the
> compatibility with old format filesystems is the hard part, and
> everyone that pulls the new code should backup their data first.
>
> I've setup git branches called newformat where you can pull the new code.
>
> For the kernel (based on 2.6.30-rc7):
>
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git newformat
>
>   
So I started the performance runs on this. The base tests completed fine 
on the raid system and I will post results as soon as I can finish 
postprocessing, but when I tried to do nodatacow that machine it crashed 
pretty early. Here is console log:

btrfs2 kernel: [82057.882255] ------------[ cut here ]------------
Message from syslogd@ at Thu Jun  4 08:02:47 2009 ...
btrfs2 kernel: [82057.882535] invalid opcode: 0000 [#1] SMP
Message from syslogd@ at Thu Jun  4 08:02:47 2009 ...
btrfs2 kernel: [82057.882535] last sysfs file: 
/sys/devices/system/cpu/cpu15/cache/index1/shared_cpu_map
Message from syslogd@ at Thu Jun  4 08:02:47 2009 ...
btrfs2 kernel: [82057.882535] Stack:
Message from syslogd@ at Thu Jun  4 08:02:47 2009 ...
btrfs2 kernel: [82057.882535]  ffff88011786d800 ffff8801259f6ea0 
000000b21f256030 00000000000000e9
Message from syslogd@ at Thu Jun  4 08:02:47 2009 ...
btrfs2 kernel: [82057.882535]  000000352231b250 ffff880089abbf40 
ffff88013d0e2440 0000000000000001
Message from syslogd@ at Thu Jun  4 08:02:47 2009 ...
btrfs2 kernel: [82057.882535] Call Trace:
Message from syslogd@ at Thu Jun  4 08:02:47 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffffa0445198>] 
run_one_delayed_ref+0x382/0x42f [btrfs]
Message from syslogd@ at Thu Jun  4 08:02:47 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffffa0464bd1>] ? 
map_extent_buffer+0xab/0xbe [btrfs]
Message from syslogd@ at Thu Jun  4 08:02:47 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffffa0445f75>] 
run_clustered_refs+0x237/0x2b4 [btrfs]
Message from syslogd@ at Thu Jun  4 08:02:47 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffffa0478f85>] ? 
btrfs_find_ref_cluster+0xdc/0x115 [btrfs]
Message from syslogd@ at Thu Jun  4 08:02:47 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffffa044609e>] 
btrfs_run_delayed_refs+0xac/0x195 [btrfs]
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffffa044e86e>] 
__btrfs_end_transaction+0x59/0xfe [btrfs]
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffffa044e92e>] 
btrfs_end_transaction+0xb/0xd [btrfs]
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffffa045418b>] 
btrfs_finish_ordered_io+0x224/0x24d [btrfs]
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffffa04541c4>] 
btrfs_writepage_end_io_hook+0x10/0x12 [btrfs]
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffffa0467599>] 
end_bio_extent_writepage+0xa3/0x18f [btrfs]
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffff8024276e>] ? 
del_timer_sync+0x14/0x20
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffff802cbbee>] bio_endio+0x26/0x28
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffffa044b5d6>] 
end_workqueue_fn+0x111/0x11e [btrfs]
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffffa046eff5>] 
worker_loop+0x67/0x1ee [btrfs]
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffffa046ef8e>] ? 
worker_loop+0x0/0x1ee [btrfs]
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffff8024c324>] kthread+0x56/0x86
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffff8020c9fa>] child_rip+0xa/0x20
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffff8024c2ce>] ? kthread+0x0/0x86
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...
btrfs2 kernel: [82057.882535]  [<ffffffff8020c9f0>] ? child_rip+0x0/0x20
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...
btrfs2 kernel: [82057.882535] Code: 08 4c 8d 45 d4 41 8d 44 24 18 48 8b 
73 20 48 8b 4d 18 41 b9 01 00 00 00 48 8b 7d b8 4c 89 ea 89 45 d4 e8 df 
e3 ff ff 85 c0 74 04 <0f> 0b eb fe 49 63 75 40 4d 8b 65 00 49 83 cf 01 
4c 89 e7 48 6b
Message from syslogd@ at Thu Jun  4 08:02:48 2009 ...


I also ran this on the single disk system and it did not make it through 
base tests.  Error are different.

[101511.664497] Pid: 28597, comm: btrfs-transacti Tainted: G      D    
2.6.30-rc7-autokern1 #1 IBM x3950-[88726RU]-
[101511.675497] RIP: 0010:[<ffffffff804cd70d>]  [<ffffffff804cd70d>] 
_spin_lock+0x14/0x1a
[101511.684494] RSP: 0018:ffff8801309bbb40  EFLAGS: 00000297
[101511.689494] RAX: 0000000000001514 RBX: ffff8801309bbb40 RCX: 
ffff8801309bbb40
[101511.697493] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
ffff8800b7427d70
[101511.705491] RBP: ffffffff8020c50e R08: 0000000000000001 R09: 
ffff8801309bba68
[101511.713490] R10: ffff88012231b910 R11: ffff8800478ad5b0 R12: 
0000001a00000032
[101511.721488] R13: ffffffffa04370b1 R14: ffff8801309bbb60 R15: 
00000000000003bf
[101511.729486] FS:  0000000000000000(0000) GS:ffff88002bac0000(0000) 
knlGS:0000000000000000
[101511.738483] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[101511.744482] CR2: 00007fbcd3ff1b80 CR3: 0000000000201000 CR4: 
00000000000006e0
[101511.752480] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[101511.760479] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[101511.768478] Call Trace:
[101511.771478]  [<ffffffffa0471187>] ? btrfs_try_spin_lock+0x1c/0x61 
[btrfs]
[101511.778476]  [<ffffffffa043ea17>] ? btrfs_search_slot+0x619/0x73e 
[btrfs]
[101511.786474]  [<ffffffffa043f11d>] ? 
btrfs_insert_empty_items+0x5e/0xa9 [btrfs]
[101511.803472]  [<ffffffffa0440ce0>] ? 
alloc_reserved_file_extent+0x89/0x1c3 [btrfs]
[101511.811470]  [<ffffffffa04401d8>] ? 
update_reserved_extents+0x98/0xab [btrfs]
[101511.819468]  [<ffffffffa0445198>] ? run_one_delayed_ref+0x382/0x42f 
[btrfs]
[101511.827467]  [<ffffffff802a5387>] ? cache_flusharray+0xa2/0xae
[101511.833466]  [<ffffffffa0445f75>] ? run_clustered_refs+0x237/0x2b4 
[btrfs]
[101511.840463]  [<ffffffffa0478f85>] ? 
btrfs_find_ref_cluster+0xdc/0x115 [btrfs]
[101511.848462]  [<ffffffff804cbdad>] ? thread_return+0x3e/0x91
[101511.854461]  [<ffffffffa044609e>] ? 
btrfs_run_delayed_refs+0xac/0x195 [btrfs]
[101511.862459]  [<ffffffffa044f59f>] ? 
btrfs_commit_transaction+0x7b/0x69c [btrfs]
[101511.870458]  [<ffffffff8024c460>] ? autoremove_wake_function+0x0/0x38
[101511.877458]  [<ffffffffa044ee87>] ? start_transaction+0x103/0x10f 
[btrfs]
[101511.885456]  [<ffffffffa044c2c6>] ? transaction_kthread+0x17f/0x20a 
[btrfs]
[101511.892453]  [<ffffffffa044c147>] ? transaction_kthread+0x0/0x20a 
[btrfs]
[101511.900453]  [<ffffffffa044c147>] ? transaction_kthread+0x0/0x20a 
[btrfs]
[101511.907452]  [<ffffffff8024c324>] ? kthread+0x56/0x86
[101511.912450]  [<ffffffff8020c9fa>] ? child_rip+0xa/0x20
[101511.918449]  [<ffffffff8024c2ce>] ? kthread+0x0/0x86
[101511.923449]  [<ffffffff8020c9f0>] ? child_rip+0x0/0

[101536.249729] Pid: 28594, comm: btrfs-endio-wri Tainted: G      D    
2.6.30-rc7-autokern1 #1 IBM x3950-[88726RU]-
[101536.249729] RIP: 0010:[<ffffffff804cd70d>]  [<ffffffff804cd70d>] 
_spin_lock+0x14/0x1a
[101536.249729] RSP: 0018:ffff88011a80da80  EFLAGS: 00000297
[101536.249729] RAX: 000000000000c6c2 RBX: ffff88011a80da80 RCX: 
0000000000000000
[101536.249729] RDX: 0000000000000000 RSI: ffff88013d080000 RDI: 
ffff8800478ad6b0
[101536.249729] RBP: ffffffff8020c50e R08: 000000000000004c R09: 
0000000000000001
[101536.249729] R10: 0000000000000008 R11: 0000000000086000 R12: 
ffff88011a80da40
[101536.249729] R13: ffff8800aa254800 R14: 0000000b470c7fff R15: 
ffff88011f256030
[101536.249729] FS:  0000000000000000(0000) GS:ffff88002ba30000(0000) 
knlGS:0000000000000000
[101536.249729] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[101536.249729] CR2: 000000000065b078 CR3: 0000000000201000 CR4: 
00000000000006e0
[101536.249729] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[101536.249729] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[101536.249729] Call Trace:
[101536.249729]  [<ffffffffa04710cf>] ? btrfs_tree_lock+0x54/0x9e [btrfs]
[101536.249729]  [<ffffffffa0471022>] ? btrfs_wake_function+0x0/0x10 [btrfs]
[101536.249729]  [<ffffffffa0438104>] ? btrfs_lock_root_node+0x1d/0x4b 
[btrfs]
[101536.249729]  [<ffffffffa043e4c5>] ? btrfs_search_slot+0xc7/0x73e [btrfs]
[101536.249729]  [<ffffffffa043f11d>] ? 
btrfs_insert_empty_items+0x5e/0xa9 [btrfs]
[101536.249729]  [<ffffffffa0444f7a>] ? run_one_delayed_ref+0x164/0x42f 
[btrfs]
[101536.249729]  [<ffffffffa0445f75>] ? run_clustered_refs+0x237/0x2b4 
[btrfs]
[101536.249729]  [<ffffffffa0478f85>] ? 
btrfs_find_ref_cluster+0xdc/0x115 [btrfs]
[101536.249729]  [<ffffffffa044609e>] ? 
btrfs_run_delayed_refs+0xac/0x195 [btrfs]
[101536.249729]  [<ffffffffa044e86e>] ? 
__btrfs_end_transaction+0x59/0xfe [btrfs]
[101536.249729]  [<ffffffffa044e92e>] ? btrfs_end_transaction+0xb/0xd 
[btrfs]
[101536.249729]  [<ffffffffa045418b>] ? 
btrfs_finish_ordered_io+0x224/0x24d [btrfs]
[101536.249729]  [<ffffffffa04541c4>] ? 
btrfs_writepage_end_io_hook+0x10/0x12 [btrfs]
[101536.249729]  [<ffffffffa0467599>] ? 
end_bio_extent_writepage+0xa3/0x18f [btrfs]
[101536.249729]  [<ffffffff8024276e>] ? del_timer_sync+0x14/0x20
[101536.249729]  [<ffffffff802cbbee>] ? bio_endio+0x26/0x28
[101536.249729]  [<ffffffffa044b5d6>] ? end_workqueue_fn+0x111/0x11e [btrfs]
[101536.249729]  [<ffffffffa046eff5>] ? worker_loop+0x67/0x1ee [btrfs]
:                                                                                               



> For the progs:
>
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git newformat
>   

I should mention that I missed the part about the new user tools, so 
while these we newly formated filesystems, they were created with the 
old tools.  These are both running 64bit. I plan to install the new 
tools and re-run.

Steve


> The main benefit of the new code is that backrefs on the extent
> allocation tree use a fuzzier format.  It basically means that we search
> for the key in the extent allocation tree instead of providing an exact
> backref to the parent block.
>
> This means we can predict how many blocks will be changed when changing
> the extent allocation tree, and it makes enospc much less complex.  It
> is also significantly faster.
>
> For regular subvolume trees, a similar change is made as long as there
> are no snapshots against a given block.  This is the common case, and it
> makes COW less expensive overall.
>
> Yan Zheng also worked out a way to free blocks during the transaction
> without needing to do an explicit snapshot deletion on the old root when
> the transaction was done.  This gets rid of some complex caching code,
> and fixes worst-case problems where btrfs could take a very very long
> time to unmount.
>
> btrfs-vol -b is faster with the new code as well, he added caching of
> high levels in the tree to speed things up.
>
> (Many kudos to Yan Zheng for all of this work!)
>
> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

