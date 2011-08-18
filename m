From: youagree <n3ocort3x@gmail.com>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Thu, 18 Aug 2011 08:44:41 +0200
Message-ID: <4E4CB4D9.4060509@gmail.com>
References: <4E41A6A4.9070702@uvm.edu> <4E4BCF0C.7060109@uvm.edu> <4E4BD05B.9070501@cchtml.com> <4E4BD272.8000704@uvm.edu> <20110817145509.GA23804@hendrix.borisch.local> <4E4C7BCD.6090004@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4C7BCD.6090004@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is most probably related to the same regression seen after 2.6.38,
my blocked comment on 3 August included an indication to that the
behavior was present in my distro 2.6.38 kernel too, it just was
appearing after a considerably longer uptime (on my desktop system using
btrfs as rootfs on an Intel ICH10 driven SATA HDD).

I have reverted my /  to ext4 since, and I'm okay with it, although I
would be very happy to see some improvement on this serious-for-me issue.


Btrfs slowdown

news://news.gmane.org:119/CAO47_-9BLKWUGDEuzaLqHSq9tZkAUaO8FMQEy1pPk9A2Hb+5AQ@mail.gmail.com

Also, a patch by Josef Bacik was an attempt for fixing this, but no one
reported about testing it on an affected system, it did not eliminate
the slowdowns for me:

PLEASE TEST: Everybody who is seeing weird and long hangs
news://news.gmane.org:119/4E36C47E.70309@redhat.com


My comment was going as an aswer to Mck's post in "Btrfs slowdown"
thread, where I reported about this in a little more detail - but it
never appeared on the list.

I try including it now:

________________________________________________________________________

I'm confirming this too. Following advices given on #btrfs irc, I have
applied Josef's second patch for fs/btrfs/extent_io.c and I'm reporting
that it did NOT make the slowdowns disappear on 3.0 kernels (even with
some rather different configs).

The HDD thrashing appeared on all other kernel versions I tried, higher
than 2.6.37.
Initially, I had been into looking for a latest known good kernel (to
prepare a proper git bisect as cwillu advised) and at first I also felt
like 2.6.38 does not show this miserable behaviour. But later it turned
out this was only for approximately 2 days of uptime. Given enough time,
the lock-ups appeared on 2.6.38 too. Although they were not that
apparent than on later kernel versions, and the individual lockups took
much less time with 2.6.38 running for 2 days (binary Sabayon Linux
repository kernel).

My HDD, with btrfs as / on it emits very distinct (and loud enough)
noises with a slightly different character for reads and writes - and I
can actually hear the disk's repetitive seek pattern during a such
thrashing period.

Based on that, I guess it must be the exact same thing happening with
2.6.38 as with later kernels because they sound very similar. They last
much shorter but they have a similarly repetitive seeking nature with
other I/O severely throttled and I believe it is write what is mostly
what's happening during a lockup. So I concluded that I failed to
identify a known good version so far. I didn't have time to get into
earlier kernels than .38. (Tried .37, but for too brief of uptime to
claim they did not appear when I was on .37)

Similar with my current kernel. It started happening after about 12
hours of running the machine using
# uname -a
Linux insula 3.0.0-git15genseed #2 SMP PREEMPT Tue Aug 2 20:10:05 CEST
2011 x86_64 Intel(R) Core(TM)2 Duo CPU E4500 @ 2.20GHz GenuineIntel
GNU/Linux

As appended string reflects, it is a custom kernel, it has Josef's patch
applied with the config attached.Tried to patch my distro's 3.0 kernel,
no change was experienced with regards to the issue (iirc it was even a
lot worse).

Let me know if I can contribute with anything that would be valuable for
the developers towards elimination of this very nasty bug.

Now, after 23 hours of uptime, my PC has become almost unusable.
Currently there's about 8 seconds thrashing, 10 seconds not thrashing,
and during thrashing, all other (disk) I/O is practically blocked.

SysRq+W under thrashing (dunno how informative it is, but here's one):

[62279.779382] SysRq : Show Blocked State
[62279.779389]   task                        PC stack   pid father
[62279.779404] btrfs-submit-0  D 0000000000000000  5616  4678      2
0x00000000
[62279.779413]  ffff88012b1370d0 0000000000000046 ffff880100000000
ffffffff8182c020
[62279.779422]  ffff880128d39fd8 0000000000010480 0000000000004000
ffff880128d38000
[62279.779429]  ffff880128d39fd8 0000000000010480 ffff88012b1370d0
0000000000010480
[62279.779437] Call Trace:
[62279.779449]  [<ffffffff812779c6>] ? cfq_set_request+0x33e/0x37e
[62279.779456]  [<ffffffff81277063>] ? cfq_cic_lookup+0x35/0x139
[62279.779462]  [<ffffffff812773a2>] ? cfq_may_queue+0x51/0x6e
[62279.779470]  [<ffffffff8143ed81>] ? io_schedule+0x4e/0x63
[62279.779477]  [<ffffffff8126b276>] ? get_request_wait+0xaa/0x10e
[62279.779484]  [<ffffffff8104f2ad>] ? wake_up_bit+0x23/0x23
[62279.779490]  [<ffffffff8126c2a6>] ? __make_request+0x175/0x26b
[62279.779496]  [<ffffffff8126a267>] ? generic_make_request+0x224/0x289
[62279.779502]  [<ffffffff8126a37f>] ? submit_bio+0xb3/0xbc
[62279.779509]  [<ffffffff81372238>] ? dm_any_congested+0x4f/0x57
[62279.779516]  [<ffffffff81206de6>] ? run_scheduled_bios+0x246/0x3b1
[62279.779523]  [<ffffffff8120c791>] ? worker_loop+0x180/0x4bb
[62279.779529]  [<ffffffff8120c611>] ? btrfs_queue_worker+0x24e/0x24e
[62279.779535]  [<ffffffff8104eee7>] ? kthread+0x7a/0x82
[62279.779542]  [<ffffffff81442554>] ? kernel_thread_helper+0x4/0x10
[62279.779548]  [<ffffffff8104ee6d>] ? kthread_worker_fn+0x149/0x149
[62279.779554]  [<ffffffff81442550>] ? gs_change+0xb/0xb
[62279.779560] btrfs-transacti D 0000000000000001  3856  4689      2
0x00000000
[62279.779568]  ffff88012b205320 0000000000000046 0000000000000000
ffff88012b06d320
[62279.779576]  ffff880128d97fd8 0000000000010480 0000000000004000
ffff880128d96000
[62279.779583]  ffff880128d97fd8 0000000000010480 ffff88012b205320
0000000000010480
[62279.779591] Call Trace:
[62279.779597]  [<ffffffff8120152f>] ? alloc_extent_state+0x12/0x55
[62279.779605]  [<ffffffff810aefbe>] ? kmem_cache_free+0x87/0x8e
[62279.779611]  [<ffffffff8127e2ab>] ? rb_erase+0x134/0x26f
[62279.779617]  [<ffffffff81081326>] ? __lock_page+0x63/0x63
[62279.779622]  [<ffffffff8143ed81>] ? io_schedule+0x4e/0x63
[62279.779628]  [<ffffffff8108132f>] ? sleep_on_page+0x9/0x10
[62279.779633]  [<ffffffff81081326>] ? __lock_page+0x63/0x63
[62279.779638]  [<ffffffff8143f36c>] ? __wait_on_bit+0x3e/0x71
[62279.779644]  [<ffffffff810814c9>] ? wait_on_page_bit+0x6a/0x70
[62279.779650]  [<ffffffff8104f2d7>] ? autoremove_wake_function+0x2a/0x2a
[62279.779657]  [<ffffffff811ebb53>] ? btrfs_wait_marked_extents+0xf5/0x12f
[62279.779664]  [<ffffffff811ebbb6>] ?
btrfs_write_and_wait_marked_extents+0x29/0x3d
[62279.779670]  [<ffffffff811ec2b0>] ? btrfs_commit_transaction+0x5c7/0x6e8
[62279.779677]  [<ffffffff810433c4>] ? del_timer_sync+0x34/0x3e
[62279.779682]  [<ffffffff8143f1bd>] ? schedule_timeout+0x182/0x1a0
[62279.779688]  [<ffffffff8104f2ad>] ? wake_up_bit+0x23/0x23
[62279.779694]  [<ffffffff811ec801>] ? start_transaction+0x1e0/0x21a
[62279.779700]  [<ffffffff811e66c4>] ? transaction_kthread+0x180/0x238
[62279.779706]  [<ffffffff811e6544>] ? btrfs_congested_fn+0x87/0x87
[62279.779712]  [<ffffffff811e6544>] ? btrfs_congested_fn+0x87/0x87
[62279.779718]  [<ffffffff8104eee7>] ? kthread+0x7a/0x82
[62279.779724]  [<ffffffff81442554>] ? kernel_thread_helper+0x4/0x10
[62279.779730]  [<ffffffff8104ee6d>] ? kthread_worker_fn+0x149/0x149
[62279.779736]  [<ffffffff81442550>] ? gs_change+0xb/0xb
[62279.779759] btrfs-endio-wri D 0000000000000000  4208 11320      2
0x00000000
[62279.779767]  ffff88012b173570 0000000000000046 0000000000000000
ffffffff8182c020
[62279.779775]  ffff88011afa9fd8 0000000000010480 0000000000004000
ffff88011afa8000
[62279.779782]  ffff88011afa9fd8 0000000000010480 ffff88012b173570
0000000000010480
[62279.779789] Call Trace:
[62279.779796]  [<ffffffff8126a267>] ? generic_make_request+0x224/0x289
[62279.779802]  [<ffffffff811faaeb>] ? lookup_extent_mapping+0x37/0xb3
[62279.779808]  [<ffffffff81081326>] ? __lock_page+0x63/0x63
[62279.779813]  [<ffffffff8143ed81>] ? io_schedule+0x4e/0x63
[62279.779818]  [<ffffffff8108132f>] ? sleep_on_page+0x9/0x10
[62279.779823]  [<ffffffff81081326>] ? __lock_page+0x63/0x63
[62279.779828]  [<ffffffff8143f36c>] ? __wait_on_bit+0x3e/0x71
[62279.779834]  [<ffffffff810814c9>] ? wait_on_page_bit+0x6a/0x70
[62279.779840]  [<ffffffff8104f2d7>] ? autoremove_wake_function+0x2a/0x2a
[62279.779846]  [<ffffffff81205835>] ? read_extent_buffer_pages+0x318/0x39b
[62279.779852]  [<ffffffff811e5a9e>] ? verify_parent_transid+0x1d9/0x1d9
[62279.779859]  [<ffffffff811e6c95>] ?
btree_read_extent_buffer_pages.clone.66+0x58/0xb2
[62279.779865]  [<ffffffff811e78b7>] ? read_tree_block+0x31/0x44
[62279.779871]  [<ffffffff811d1a8a>] ?
read_block_for_search.clone.41+0x309/0x33f
[62279.779878]  [<ffffffff812115fa>] ? btrfs_tree_read_unlock+0x9/0x33
[62279.779884]  [<ffffffff811cd235>] ? unlock_up+0x114/0x140
[62279.779890]  [<ffffffff811d4203>] ? btrfs_search_slot+0x7e7/0xa5e
[62279.779897]  [<ffffffff811d54fc>] ? btrfs_insert_empty_items+0x62/0xb3
[62279.779904]  [<ffffffff811da616>] ?
alloc_reserved_file_extent.clone.68+0x9b/0x213
[62279.779911]  [<ffffffff811dd08c>] ? run_clustered_refs+0x61f/0x70b
[62279.779918]  [<ffffffff811dd241>] ? btrfs_run_delayed_refs+0xc9/0x1cd
[62279.779924]  [<ffffffff811ec46f>] ? __btrfs_end_transaction+0x83/0x1e2
[62279.779931]  [<ffffffff811f171d>] ? btrfs_finish_ordered_io+0x280/0x2a5
[62279.779937]  [<ffffffff81202316>] ? end_bio_extent_writepage+0xa0/0x14a
[62279.779943]  [<ffffffff8120c791>] ? worker_loop+0x180/0x4bb
[62279.779949]  [<ffffffff8120c611>] ? btrfs_queue_worker+0x24e/0x24e
[62279.779955]  [<ffffffff8104eee7>] ? kthread+0x7a/0x82
[62279.779962]  [<ffffffff81442554>] ? kernel_thread_helper+0x4/0x10
[62279.779968]  [<ffffffff8104ee6d>] ? kthread_worker_fn+0x149/0x149
[62279.779974]  [<ffffffff81442550>] ? gs_change+0xb/0xb


# mount | grep btrfs
/dev/mapper/vg0-rootvol on / type btrfs (rw,relatime)


Thanks for all efforts.


