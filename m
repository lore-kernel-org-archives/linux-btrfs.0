Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58522 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752932AbdLMSs3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Dec 2017 13:48:29 -0500
Date: Wed, 13 Dec 2017 10:07:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, rostedt@goodmis.org,
        mingo@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, kernel-team@fb.com,
        daniel@iogearbox.net, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v9 0/5] Add the ability to do BPF directed error injection
Message-ID: <20171213180732.GE13436@magnolia>
References: <1513010210-30594-1-git-send-email-josef@toxicpanda.com>
 <20171212231150.GA4894@magnolia>
 <20171213180356.hsuhzoa7s4ngro2r@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171213180356.hsuhzoa7s4ngro2r@destiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 13, 2017 at 01:03:57PM -0500, Josef Bacik wrote:
> On Tue, Dec 12, 2017 at 03:11:50PM -0800, Darrick J. Wong wrote:
> > On Mon, Dec 11, 2017 at 11:36:45AM -0500, Josef Bacik wrote:
> > > This is the same as v8, just rebased onto the bpf tree.
> > > 
> > > v8->v9:
> > > - rebased onto the bpf tree.
> > > 
> > > v7->v8:
> > > - removed the _ASM_KPROBE_ERROR_INJECT since it was not needed.
> > > 
> > > v6->v7:
> > > - moved the opt-in macro to bpf.h out of kprobes.h.
> > > 
> > > v5->v6:
> > > - add BPF_ALLOW_ERROR_INJECTION() tagging for functions that will support this
> > >   feature.  This way only functions that opt-in will be allowed to be
> > >   overridden.
> > > - added a btrfs patch to allow error injection for open_ctree() so that the bpf
> > >   sample actually works.
> > > 
> > > v4->v5:
> > > - disallow kprobe_override programs from being put in the prog map array so we
> > >   don't tail call into something we didn't check.  This allows us to make the
> > >   normal path still fast without a bunch of percpu operations.
> > > 
> > > v3->v4:
> > > - fix a build error found by kbuild test bot (I didn't wait long enough
> > >   apparently.)
> > > - Added a warning message as per Daniels suggestion.
> > > 
> > > v2->v3:
> > > - added a ->kprobe_override flag to bpf_prog.
> > > - added some sanity checks to disallow attaching bpf progs that have
> > >   ->kprobe_override set that aren't for ftrace kprobes.
> > > - added the trace_kprobe_ftrace helper to check if the trace_event_call is a
> > >   ftrace kprobe.
> > > - renamed bpf_kprobe_state to bpf_kprobe_override, fixed it so we only read this
> > >   value in the kprobe path, and thus only write to it if we're overriding or
> > >   clearing the override.
> > > 
> > > v1->v2:
> > > - moved things around to make sure that bpf_override_return could really only be
> > >   used for an ftrace kprobe.
> > > - killed the special return values from trace_call_bpf.
> > > - renamed pc_modified to bpf_kprobe_state so bpf_override_return could tell if
> > >   it was being called from an ftrace kprobe context.
> > > - reworked the logic in kprobe_perf_func to take advantage of bpf_kprobe_state.
> > > - updated the test as per Alexei's review.
> > > 
> > > - Original message -
> > > 
> > > A lot of our error paths are not well tested because we have no good way of
> > > injecting errors generically.  Some subystems (block, memory) have ways to
> > > inject errors, but they are random so it's hard to get reproduceable results.
> > > 
> > > With BPF we can add determinism to our error injection.  We can use kprobes and
> > > other things to verify we are injecting errors at the exact case we are trying
> > > to test.  This patch gives us the tool to actual do the error injection part.
> > > It is very simple, we just set the return value of the pt_regs we're given to
> > > whatever we provide, and then override the PC with a dummy function that simply
> > > returns.
> > 
> > Heh, this looks cool.  I decided to try it to see what happens, and saw
> > a bunch of dmesg pasted in below.  Is that supposed to happen?  Or am I
> > the only fs developer still running with lockdep enabled? :)
> > 
> > It looks like bpf_override_return has some sort of side effect such that
> > we get the splat, since commenting it out makes the symptom go away.
> > 
> > <shrug>
> > 
> > --D
> > 
> > [ 1847.769183] BTRFS error (device (null)): open_ctree failed
> > [ 1847.770130] BUG: sleeping function called from invalid context at /storage/home/djwong/cdev/work/linux-xfs/kernel/locking/rwsem.c:69
> > [ 1847.771976] in_atomic(): 1, irqs_disabled(): 0, pid: 1524, name: mount
> > [ 1847.773016] 1 lock held by mount/1524:
> > [ 1847.773530]  #0:  (&type->s_umount_key#34/1){+.+.}, at: [<00000000653a9bb4>] sget_userns+0x302/0x4f0
> > [ 1847.774731] Preemption disabled at:
> > [ 1847.774735] [<          (null)>]           (null)
> > [ 1847.777009] CPU: 2 PID: 1524 Comm: mount Tainted: G        W        4.15.0-rc3-xfsx #3
> > [ 1847.778800] Call Trace:
> > [ 1847.779047]  dump_stack+0x7c/0xbe
> > [ 1847.779361]  ___might_sleep+0x1f7/0x260
> > [ 1847.779720]  down_write+0x29/0xb0
> > [ 1847.780046]  unregister_shrinker+0x15/0x70
> > [ 1847.780427]  deactivate_locked_super+0x2e/0x60
> > [ 1847.780935]  btrfs_mount+0xbb6/0x1000 [btrfs]
> > [ 1847.781353]  ? __lockdep_init_map+0x5c/0x1d0
> > [ 1847.781750]  ? mount_fs+0xf/0x80
> > [ 1847.782065]  ? alloc_vfsmnt+0x1a1/0x230
> > [ 1847.782429]  mount_fs+0xf/0x80
> > [ 1847.782733]  vfs_kern_mount+0x62/0x160
> > [ 1847.783128]  btrfs_mount+0x3d3/0x1000 [btrfs]
> > [ 1847.783493]  ? __lockdep_init_map+0x5c/0x1d0
> > [ 1847.783849]  ? __lockdep_init_map+0x5c/0x1d0
> > [ 1847.784207]  ? mount_fs+0xf/0x80
> > [ 1847.784502]  mount_fs+0xf/0x80
> > [ 1847.784835]  vfs_kern_mount+0x62/0x160
> > [ 1847.785235]  do_mount+0x1b1/0xd50
> > [ 1847.785594]  ? _copy_from_user+0x5b/0x90
> > [ 1847.786028]  ? memdup_user+0x4b/0x70
> > [ 1847.786501]  SyS_mount+0x85/0xd0
> > [ 1847.786835]  entry_SYSCALL_64_fastpath+0x1f/0x96
> > [ 1847.787311] RIP: 0033:0x7f6ebecc1b5a
> > [ 1847.787691] RSP: 002b:00007ffc7bd1c958 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
> > [ 1847.788383] RAX: ffffffffffffffda RBX: 00007f6ebefba63a RCX: 00007f6ebecc1b5a
> > [ 1847.789106] RDX: 0000000000bfd010 RSI: 0000000000bfa230 RDI: 0000000000bfa210
> > [ 1847.789807] RBP: 0000000000bfa0f0 R08: 0000000000000000 R09: 0000000000000014
> > [ 1847.790511] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 00007f6ebf1ca83c
> > [ 1847.791211] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
> > [ 1847.792029] BUG: scheduling while atomic: mount/1524/0x00000002
> > [ 1847.792680] 1 lock held by mount/1524:
> > [ 1847.793087]  #0:  (rcu_preempt_state.exp_mutex){+.+.}, at: [<00000000a6c536a9>] _synchronize_rcu_expedited+0x1ce/0x400
> > [ 1847.794129] Modules linked in: xfs libcrc32c btrfs xor zstd_decompress zstd_compress xxhash lzo_compress lzo_decompress zlib_deflate raid6_pq dax_pmem device_dax nd_pmem sch_fq_codel af_packet [last unloaded: xfs]
> > [ 1847.795949] Preemption disabled at:
> > [ 1847.795951] [<          (null)>]           (null)
> > [ 1847.796844] CPU: 2 PID: 1524 Comm: mount Tainted: G        W        4.15.0-rc3-xfsx #3
> > [ 1847.797621] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
> > [ 1847.798510] Call Trace:
> > [ 1847.798786]  dump_stack+0x7c/0xbe
> > [ 1847.799134]  __schedule_bug+0x88/0xe0
> > [ 1847.799517]  __schedule+0x78c/0xb20
> > [ 1847.799890]  ? trace_hardirqs_on_caller+0x119/0x180
> > [ 1847.800391]  schedule+0x40/0x90
> > [ 1847.800729]  _synchronize_rcu_expedited+0x36b/0x400
> > [ 1847.801218]  ? rcu_preempt_qs+0xa0/0xa0
> > [ 1847.801616]  ? remove_wait_queue+0x60/0x60
> > [ 1847.802040]  ? rcu_preempt_qs+0xa0/0xa0
> > [ 1847.802433]  ? rcu_exp_wait_wake+0x630/0x630
> > [ 1847.802872]  ? __lock_acquire+0xfb9/0x1120
> > [ 1847.803302]  ? __lock_acquire+0x534/0x1120
> > [ 1847.803725]  ? bdi_unregister+0x57/0x1a0
> > [ 1847.804135]  bdi_unregister+0x5c/0x1a0
> > [ 1847.804519]  bdi_put+0xcb/0xe0
> > [ 1847.804746]  generic_shutdown_super+0xe2/0x110
> > [ 1847.805066]  kill_anon_super+0xe/0x20
> > [ 1847.805344]  btrfs_kill_super+0x12/0xa0 [btrfs]
> > [ 1847.805664]  deactivate_locked_super+0x34/0x60
> > [ 1847.806111]  btrfs_mount+0xbb6/0x1000 [btrfs]
> > [ 1847.806476]  ? __lockdep_init_map+0x5c/0x1d0
> > [ 1847.806824]  ? mount_fs+0xf/0x80
> > [ 1847.807104]  ? alloc_vfsmnt+0x1a1/0x230
> > [ 1847.807416]  mount_fs+0xf/0x80
> > [ 1847.807712]  vfs_kern_mount+0x62/0x160
> > [ 1847.808112]  btrfs_mount+0x3d3/0x1000 [btrfs]
> > [ 1847.808565]  ? __lockdep_init_map+0x5c/0x1d0
> > [ 1847.809005]  ? __lockdep_init_map+0x5c/0x1d0
> > [ 1847.809425]  ? mount_fs+0xf/0x80
> > [ 1847.809731]  mount_fs+0xf/0x80
> > [ 1847.810070]  vfs_kern_mount+0x62/0x160
> > [ 1847.810469]  do_mount+0x1b1/0xd50
> > [ 1847.810821]  ? _copy_from_user+0x5b/0x90
> > [ 1847.811237]  ? memdup_user+0x4b/0x70
> > [ 1847.811622]  SyS_mount+0x85/0xd0
> > [ 1847.811996]  entry_SYSCALL_64_fastpath+0x1f/0x96
> > [ 1847.812465] RIP: 0033:0x7f6ebecc1b5a
> > [ 1847.812840] RSP: 002b:00007ffc7bd1c958 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
> > [ 1847.813615] RAX: ffffffffffffffda RBX: 00007f6ebefba63a RCX: 00007f6ebecc1b5a
> > [ 1847.814302] RDX: 0000000000bfd010 RSI: 0000000000bfa230 RDI: 0000000000bfa210
> > [ 1847.814770] RBP: 0000000000bfa0f0 R08: 0000000000000000 R09: 0000000000000014
> > [ 1847.815246] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 00007f6ebf1ca83c
> > [ 1847.815720] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
> i> 
> 
> Looks like this is new, Masami this is happening because of your change here
> 
> 5bb4fc2d8641 ("kprobes/x86: Disable preemption in ftrace-based jprobes")
> 
> which makes it not do the preempt_enable() if the handler returns 1.  Why is
> that?  Should I be doing preempt_enable_no_resched() from the handler before
> returning 1?  Or is this just an oversight on your part?  Thanks,

FWIW I shut up the preemption imbalance warnings with the attached
coarse bandaid.  No idea if that's the correct fix...

--D

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5db8498..fd948e3 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1215,8 +1215,10 @@ kprobe_perf_func(struct trace_kprobe *tk, struct pt_regs *regs)
 		if (__this_cpu_read(bpf_kprobe_override)) {
 			__this_cpu_write(bpf_kprobe_override, 0);
 			reset_current_kprobe();
+			preempt_enable();
 			return 1;
 		}
+		preempt_enable();
 		if (!ret)
 			return 0;
 	}
> 
> Josef
