From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: btrfs: hanging processes - race condition?
Date: Fri, 18 Jun 2010 08:57:36 +0800
Message-ID: <20100618005736.GA3454@sli10-desk.sh.intel.com>
References: <Pine.LNX.4.64.1006101022570.12518@lyn-del-uti-015>
 <20100611011242.GA22585@sli10-desk.sh.intel.com>
 <AANLkTilJCKyddGMIi77QG-uluyqgXPlPYVDcFTmWno8O@mail.gmail.com>
 <20100613065006.GA2597@sli10-desk.sh.intel.com>
 <20100614132829.GE18266@think>
 <20100617014118.GA21213@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	"Yan, Zheng " <yanzheng@21cn.com>,
	Jerome Ibanes <Jerome@ops.zillow.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"Zhang, Y
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100617014118.GA21213@sli10-desk.sh.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 17, 2010 at 09:41:18AM +0800, Shaohua Li wrote:
> On Mon, Jun 14, 2010 at 09:28:29PM +0800, Chris Mason wrote:
> > On Sun, Jun 13, 2010 at 02:50:06PM +0800, Shaohua Li wrote:
> > > On Fri, Jun 11, 2010 at 10:32:07AM +0800, Yan, Zheng  wrote:
> > > > On Fri, Jun 11, 2010 at 9:12 AM, Shaohua Li <shaohua.li@intel.c=
om> wrote:
> > > > > On Fri, Jun 11, 2010 at 01:41:41AM +0800, Jerome Ibanes wrote=
:
> > > > >> List,
> > > > >>
> > > > >> I ran into a hang issue (race condition: cpu is high when th=
e server is
> > > > >> idle, meaning that btrfs is hanging, and IOwait is high as w=
ell) running
> > > > >> 2.6.34 on debian/lenny on a x86_64 server (dual Opteron 275 =
w/ 16GB ram).
> > > > >> The btrfs filesystem live on 18x300GB scsi spindles, configu=
red as Raid-0,
> > > > >> as shown below:
> > > > >>
> > > > >> Label: none =A0uuid: bc6442c6-2fe2-4236-a5aa-6b7841234c52
> > > > >> =A0 =A0 =A0 =A0 =A0Total devices 18 FS bytes used 2.94TB
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 =A05 size 279.39GB used 208.33G=
B path /dev/cciss/c1d0
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 17 size 279.39GB used 208.34GB =
path /dev/cciss/c1d8
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 16 size 279.39GB used 209.33GB =
path /dev/cciss/c1d7
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 =A04 size 279.39GB used 208.33G=
B path /dev/cciss/c0d4
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 =A01 size 279.39GB used 233.72G=
B path /dev/cciss/c0d1
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 13 size 279.39GB used 208.33GB =
path /dev/cciss/c1d4
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 =A08 size 279.39GB used 208.33G=
B path /dev/cciss/c1d11
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 12 size 279.39GB used 208.33GB =
path /dev/cciss/c1d3
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 =A03 size 279.39GB used 208.33G=
B path /dev/cciss/c0d3
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 =A09 size 279.39GB used 208.33G=
B path /dev/cciss/c1d12
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 =A06 size 279.39GB used 208.33G=
B path /dev/cciss/c1d1
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 11 size 279.39GB used 208.33GB =
path /dev/cciss/c1d2
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 14 size 279.39GB used 208.33GB =
path /dev/cciss/c1d5
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 =A02 size 279.39GB used 233.70G=
B path /dev/cciss/c0d2
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 15 size 279.39GB used 209.33GB =
path /dev/cciss/c1d6
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 10 size 279.39GB used 208.33GB =
path /dev/cciss/c1d13
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 =A07 size 279.39GB used 208.33G=
B path /dev/cciss/c1d10
> > > > >> =A0 =A0 =A0 =A0 =A0devid =A0 18 size 279.39GB used 208.34GB =
path /dev/cciss/c1d9
> > > > >> Btrfs v0.19-16-g075587c-dirty
> > > > >>
> > > > >> The filesystem, mounted in /mnt/btrfs is hanging, no existin=
g or new
> > > > >> process can access it, however 'df' still displays the disk =
usage (3TB out
> > > > >> of 5). The disks appear to be physically healthy. Please not=
e that a
> > > > >> significant number of files were placed on this filesystem, =
between 20 and
> > > > >> 30 million files.
> > > > >>
> > > > >> The relevant kernel messages are displayed below:
> > > > >>
> > > > >> INFO: task btrfs-submit-0:4220 blocked for more than 120 sec=
onds.
> > > > >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
> > > > >> btrfs-submit- D 000000010042e12f =A0 =A0 0 =A04220 =A0 =A0 =A0=
2 0x00000000
> > > > >> =A0 ffff8803e584ac70 0000000000000046 0000000000004000 00000=
00000011680
> > > > >> =A0 ffff8803f7349fd8 ffff8803f7349fd8 ffff8803e584ac70 00000=
00000011680
> > > > >> =A0 0000000000000001 ffff8803ff99d250 ffffffff8149f020 00000=
00081150ab0
> > > > >> Call Trace:
> > > > >> =A0 [<ffffffff813089f3>] ? io_schedule+0x71/0xb1
> > > > >> =A0 [<ffffffff811470be>] ? get_request_wait+0xab/0x140
> > > > >> =A0 [<ffffffff810406f4>] ? autoremove_wake_function+0x0/0x2e
> > > > >> =A0 [<ffffffff81143a4d>] ? elv_rq_merge_ok+0x89/0x97
> > > > >> =A0 [<ffffffff8114a245>] ? blk_recount_segments+0x17/0x27
> > > > >> =A0 [<ffffffff81147429>] ? __make_request+0x2d6/0x3fc
> > > > >> =A0 [<ffffffff81145b16>] ? generic_make_request+0x207/0x268
> > > > >> =A0 [<ffffffff81145c12>] ? submit_bio+0x9b/0xa2
> > > > >> =A0 [<ffffffffa01aa081>] ? btrfs_requeue_work+0xd7/0xe1 [btr=
fs]
> > > > >> =A0 [<ffffffffa01a5365>] ? run_scheduled_bios+0x297/0x48f [b=
trfs]
> > > > >> =A0 [<ffffffffa01aa687>] ? worker_loop+0x17c/0x452 [btrfs]
> > > > >> =A0 [<ffffffffa01aa50b>] ? worker_loop+0x0/0x452 [btrfs]
> > > > >> =A0 [<ffffffff81040331>] ? kthread+0x79/0x81
> > > > >> =A0 [<ffffffff81003674>] ? kernel_thread_helper+0x4/0x10
> > > > >> =A0 [<ffffffff810402b8>] ? kthread+0x0/0x81
> > > > >> =A0 [<ffffffff81003670>] ? kernel_thread_helper+0x0/0x10
> > > > > This looks like the issue we saw too, http://lkml.org/lkml/20=
10/6/8/375.
> > > > > This is reproduceable in our setup.
> > > >=20
> > > > I think I know the cause of http://lkml.org/lkml/2010/6/8/375.
> > > > The code in the first do-while loop in btrfs_commit_transaction
> > > > set current process to TASK_UNINTERRUPTIBLE state, then calls
> > > > btrfs_start_delalloc_inodes, btrfs_wait_ordered_extents and
> > > > btrfs_run_ordered_operations(). All of these function may call
> > > > cond_resched().
> > > Hi,
> > > When I test random write, I saw a lot of threads jump into btree_=
writepages()
> > > and do noting and io throughput is zero for some time. Looks like=
 there is a
> > > live lock. See the code of btree_writepages():
> > > 	if (wbc->sync_mode =3D=3D WB_SYNC_NONE) {
> > > 		struct btrfs_root *root =3D BTRFS_I(mapping->host)->root;
> > > 		u64 num_dirty;
> > > 		unsigned long thresh =3D 32 * 1024 * 1024;
> > >=20
> > > 		if (wbc->for_kupdate)
> > > 			return 0;
> > >=20
> > > 		/* this is a bit racy, but that's ok */
> > > 		num_dirty =3D root->fs_info->dirty_metadata_bytes;
> > > >>>>>>		if (num_dirty < thresh)
> > > 			return 0;
> > > 	}
> > > The marked line is quite intrusive. In my test, the live lock is =
caused by the thresh
> > > check. The dirty_metadata_bytes < 32M. Without it, I can't see th=
e live lock. Not
> > > sure if this is related to the hang.
> >=20
> > How much ram do you have?  The goal of the check is to avoid writin=
g
> > metadata blocks because once we write them we have to do more IO to=
 cow
> > them again if they are changed later.
> >=20
> > It shouldn't be looping hard in btrfs there, what was the workload?
> This is a fio randomwrite. Yep, I limited memory to a small size (~50=
0M), because it makes
> me easily to produce a 'xxx blocked for more than 120 seconds' issue.=
 I can understand small
> memory could be an issue, but this still looks intrusive, right?
>=20
> The issue Yanmin reported is under 2.6.35-rc1, so might not be the
> 'TASK_UNINTERRUPTIBLE' issue, but we will try -rc3 too.
I still get below message with 2.6.35-rc3. The system is still running,=
 because
my fio test finished even with the message.

INFO: task flush-btrfs-134:14144 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
flush-btrfs-1 D 0000000100346d5c  4480 14144      2 0x00000000
 ffff88016fd51530 0000000000000046 0000000000000001 ffff880100000000
 ffff88023ef0f100 0000000000013ac0 0000000000013ac0 0000000000004000
 0000000000013ac0 ffff88018be2dfd8 ffff88016fd51530 ffff88018be2dfd8
Call Trace:
 [<ffffffff8124be61>] ? wait_block_group_cache_progress+0xc0/0xe4
 [<ffffffff81052977>] ? autoremove_wake_function+0x0/0x2a
 [<ffffffff81052977>] ? autoremove_wake_function+0x0/0x2a
 [<ffffffff8124f956>] ? find_free_extent+0x694/0x9c4
 [<ffffffff8124fd53>] ? btrfs_reserve_extent+0xcd/0x189
 [<ffffffff81262803>] ? cow_file_range+0x19e/0x2fc
 [<ffffffff81262fe0>] ? run_delalloc_range+0xa7/0x393
 [<ffffffff8127832e>] ? test_range_bit+0x2b/0x127
 [<ffffffff8127b44e>] ? find_lock_delalloc_range+0x1af/0x1d1
 [<ffffffff8127b655>] ? __extent_writepage+0x1e5/0x61f
 [<ffffffff812c1fac>] ? prio_tree_next+0x1c0/0x221
 [<ffffffff812bf3c8>] ? cpumask_any_but+0x28/0x37
 [<ffffffff810b4af7>] ? page_mkclean+0x120/0x148
 [<ffffffff8127bed2>] ? extent_write_cache_pages.clone.0+0x15e/0x26c
 [<ffffffff8127c0db>] ? extent_writepages+0x41/0x5a
 [<ffffffff81264319>] ? btrfs_get_extent+0x0/0x798
 [<ffffffff810e6fcb>] ? writeback_single_inode+0xd1/0x2e8
 [<ffffffff810e7d02>] ? writeback_inodes_wb+0x40d/0x51f
 [<ffffffff810e7f47>] ? wb_writeback+0x133/0x1b2
 [<ffffffff810e81ae>] ? wb_do_writeback+0x148/0x15e
 [<ffffffff810e81fe>] ? bdi_writeback_task+0x3a/0x113
 [<ffffffff81052897>] ? bit_waitqueue+0x14/0xa4
 [<ffffffff810a9b19>] ? bdi_start_fn+0x0/0xc2
 [<ffffffff810a9b7c>] ? bdi_start_fn+0x63/0xc2
 [<ffffffff810a9b19>] ? bdi_start_fn+0x0/0xc2
 [<ffffffff81052525>] ? kthread+0x75/0x7d
 [<ffffffff81003654>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff810524b0>] ? kthread+0x0/0x7d
 [<ffffffff81003650>] ? kernel_thread_helper+0x0/0x10
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
