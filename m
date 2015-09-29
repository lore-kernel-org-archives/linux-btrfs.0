Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:58617 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933745AbbI2SVl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 14:21:41 -0400
Received: from rc.speed47.net (nginx [192.168.80.2])
	by box.speed47.net (Postfix) with ESMTP id 7BFBEBFF8
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 20:21:36 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 29 Sep 2015 20:21:36 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: linux-btrfs@vger.kernel.org
Subject: ftrace of kernel BUG at extent-tree.c during balance
Message-ID: <d6b79bdb48814047104c29d388fd81e2@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This bug has been discussed several times here already, both recently 
and also in 2012 where the bug was deemed fixed in btrfs-next, but 
probably wasn't in the end [1]. It has also been reported at a couple 
other places, such as [2].

I managed to add some trace_printk's at the beggining of each function 
present in the stack trace, and reproduced the problem. Took me a couple 
days to reproduce it and get potentially useful logs.

The stacktrace is :

[60424.709967] kernel BUG at fs/btrfs/extent-tree.c:1841!
[60424.710748] CPU: 0 PID: 1622 Comm: kworker/u2:3 Tainted: G        W   
     4.3.0-rc1 #1
[60424.710816] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper 
[btrfs]
[60424.710849] task: ffff880113fd0000 ti: ffff8800550f0000 task.ti: 
ffff8800550f0000
[60424.710874] RIP: 0010:[<ffffffffc0acb9d5>]  [<ffffffffc0acb9d5>] 
insert_inline_extent_backref+0x195/0x1a0 [btrfs]
[60424.711189] Call Trace:
[60424.711206]  [<ffffffffc0acbac1>] __btrfs_inc_extent_ref+0xe1/0x290 
[btrfs]
[60424.711234]  [<ffffffffc0ad25ee>] 
__btrfs_run_delayed_refs+0xd1e/0x1070 [btrfs]
[60424.711264]  [<ffffffff811370fc>] ? 
ring_buffer_unlock_commit+0x2c/0x260
[60424.711287]  [<ffffffff81143760>] ? __trace_bprintk+0x50/0x60
[60424.711307]  [<ffffffffc0ad55f1>] btrfs_run_delayed_refs+0x91/0x2c0 
[btrfs]
[60424.711332]  [<ffffffffc0aeaec0>] ? 
btrfs_start_transaction_lflush+0x20/0x20 [btrfs]
[60424.711358]  [<ffffffffc0ad5857>] delayed_ref_async_start+0x37/0x90 
[btrfs]
[60424.711384]  [<ffffffffc0b19e50>] normal_work_helper+0xc0/0x270 
[btrfs]
[60424.711404]  [<ffffffff817ad688>] ftrace_graph_caller+0xa8/0xa8
[60424.711427]  [<ffffffffc0b1a232>] btrfs_extent_refs_helper+0x12/0x20 
[btrfs]
[60424.711446]  [<ffffffff817ad688>] ftrace_graph_caller+0xa8/0xa8
[60424.711464]  [<ffffffff8109127e>] process_one_work+0x14e/0x3d0
[60424.711481]  [<ffffffff8109192a>] worker_thread+0x11a/0x470
[60424.711497]  [<ffffffff81091810>] ? rescuer_thread+0x310/0x310
[60424.711514]  [<ffffffff81097059>] kthread+0xc9/0xe0
[60424.711529]  [<ffffffff81096f90>] ? kthread_park+0x60/0x60

Corresponding code is (slightly modified on my end for ftrace) :

static noinline_for_stack
int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
          struct btrfs_root *root,
          struct btrfs_path *path,
          u64 bytenr, u64 num_bytes, u64 parent,
          u64 root_objectid, u64 owner,
          u64 offset, int refs_to_add,
          struct btrfs_delayed_extent_op *extent_op)
{
   struct btrfs_extent_inline_ref *iref;
   int ret;
   trace_printk("insert_inline_extent_backref args: trans=%p root=%p 
path=%p bytenr=%llu num_bytes=%llu parent=%llu root_objectid=%llu 
owner=%llu offset=%llu refs_to_add=%d extent_op=%p\n",
     trans, root, path, bytenr, num_bytes, parent, root_objectid, owner, 
offset, refs_to_add, extent_op);

   ret = lookup_inline_extent_backref(trans, root, path, &iref,
              bytenr, num_bytes, parent,
              root_objectid, owner, offset, 1);
   if (ret == 0) {
     if (owner < BTRFS_FIRST_FREE_OBJECTID)
     {
       trace_printk("info: CONDITIONS MET FOR BUG, STOPPING TRACING\n");
       tracing_off();
       printk("{btrfs} in insert_inline_extent_backref, got owner < 
BTRFS_FIRST_FREE_OBJECTID\n");
       printk("{btrfs} with bytenr=%llu num_bytes=%llu parent=%llu 
root_objectid=%llu owner=%llu offset=%llu refs_to_add=%d 
BTRFS_FIRST_FREE_OBJECTID=%llu\n",
         bytenr, num_bytes, parent, root_objectid, owner, offset, 
refs_to_add, BTRFS_FIRST_FREE_OBJECTID);
       BUG(); // <== here
     }


The ftrace configuration was :

echo 8 > max_graph_depth
echo function_graph > current_tracer
echo :mod:btrfs > set_ftrace_filter
echo btrfs_{g,s}et_token_{8,16,32,64} btrfs_comp_cpu_keys 
read_extent_buffer map_private_extent_buffer free_extent_buffer 
release_extent_buffer check_buffer_tree_ref find_extent_buffer 
extent_buffer_uptodate verify_parent_transid mark_extent_buffer_accessed 
btrfs_set_path_blocking btrfs_set_lock_blocking_rw btrfs_tree_read_lock 
alloc_extent_buffer btrfs_find_create_tree_block 
read_extent_buffer_pages btree_read_extent_buffer_pages.constprop.56 
read_tree_block btrfs_tree_read_unlock_blocking 
btrfs_clear_path_blocking bin_search > set_ftrace_notrace

The kernel was booted with nosmp to avoid out of order logs.

The ftrace data was collected by netcat and sent over the network to a 
logging machine. The kernel stacktrace was collected with netconsole on 
the same machine.

Over 100G of logs were created during the 3 days I was trying to 
reproduce the bug *and* getting a usable ftrace configuration. I had a 
script to pause/resume the balance from time to time to enable log 
splitting and keep only the one where the bug would happen. This last 
log is a little under 1G (uncompressed, 40M compressed). I suspect the 
last few lines of this log were not sent by the crashing machine (the 
trace_printk above doesn't appear), but the crash condition can be seen 
however (owner == 1).

The first and last 1000 lines of this log are available here :
http://www.speed47.net/tmp2/bug_first_1k.log.gz
http://www.speed47.net/tmp2/bug_last_1k.log.gz

The complete log is available here (40M) :
http://www.speed47.net/tmp2/btrfs_ftrace.2015-09-29.15-11-15.cpu0.gz

You can grep "args:" to get the trace_printk's indicating the values of 
the parameters a function was called with. Such code was added to the 
following functions:
insert_inline_extent_backref <== where the BUG_ON() triggers
__btrfs_inc_extent_ref
run_delayed_data_ref
run_delayed_tree_ref
__btrfs_run_delayed_refs
btrfs_run_delayed_refs
btrfs_drop_snapshot
btrfs_ioctl_balance
merge_reloc_roots
relocate_block_group
btrfs_relocate_block_group
btrfs_should_end_transaction
btrfs_relocate_chunk
__btrfs_balance
btrfs_balance

As already seen, the bug happens when owner == 1 (which is < 256 aka 
BTRFS_FIRST_FREE_OBJECTID).

May a developer have a look at it ? I can ftrace more/less and/or add 
more precise trace_printk's if needed.

Thanks,

-- 
Stéphane.

[1] 
http://thread.gmane.org/gmane.comp.file-systems.btrfs/19106/focus=19109
[2] https://bugzilla.opensuse.org/show_bug.cgi?id=940212

