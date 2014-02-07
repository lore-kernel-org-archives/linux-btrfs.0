Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46184 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaBGKOD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 05:14:03 -0500
Received: by mail-pa0-f48.google.com with SMTP id kx10so2987565pab.35
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 02:14:02 -0800 (PST)
Date: Fri, 7 Feb 2014 02:13:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Fengguang Wu <fengguang.wu@intel.com>, Tejun Heo <tj@kernel.org>
cc: Filipe David Borba Manana <fdmanana@gmail.com>, Chris Mason <clm@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [btrfs] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000038
In-Reply-To: <20140207023801.GC11051@localhost>
Message-ID: <alpine.DEB.2.02.1402070213020.22146@chino.kir.corp.google.com>
References: <20140207023801.GC11051@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 7 Feb 2014, Fengguang Wu wrote:

> [    1.625020] BTRFS: selftest: Running btrfs_split_item tests
> [    1.627004] BTRFS: selftest: Running find delalloc tests
> [    2.289182] tsc: Refined TSC clocksource calibration: 2299.967 MHz
> [  292.084537] kthreadd invoked oom-killer: gfp_mask=0x3000d0, order=1, oom_score_adj=0
> [  292.086439] kthreadd cpuset=
> [  292.087072] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
> [  292.087372] IP: [<ffffffff812119de>] pr_cont_kernfs_name+0x1b/0x6c

This looks like a problem with the cpuset cgroup name, are you sure this 
isn't related to the removal of cgroup->name?

> [  292.087372] PGD 0 
> [  292.087372] Oops: 0000 [#1] 
> [  292.087372] Modules linked in:
> [  292.087372] CPU: 0 PID: 2 Comm: kthreadd Not tainted 3.14.0-rc1-wl-ath-00978-g4830363 #2
> [  292.087372] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [  292.087372] task: ffff880000148050 ti: ffff88000014a000 task.ti: ffff88000014a000
> [  292.087372] RIP: 0010:[<ffffffff812119de>]  [<ffffffff812119de>] pr_cont_kernfs_name+0x1b/0x6c
> [  292.087372] RSP: 0000:ffff88000014bb20  EFLAGS: 00010046
> [  292.087372] RAX: 0000000000000282 RBX: 0000000000000000 RCX: 0000000000000002
> [  292.087372] RDX: ffffffff812119de RSI: ffffffff8247d4a8 RDI: 0000000000000046
> [  292.087372] RBP: ffff88000014bb30 R08: ffffffff82f31218 R09: 0000000000000000
> [  292.087372] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff833c4ab8
> [  292.087372] R13: 00000000003000d0 R14: 0000000000000001 R15: 0000000000000000
> [  292.087372] FS:  0000000000000000(0000) GS:ffffffff82279000(0000) knlGS:0000000000000000
> [  292.087372] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  292.087372] CR2: 0000000000000038 CR3: 0000000002269000 CR4: 00000000000006b0
> [  292.087372] Stack:
> [  292.087372]  ffff880000148050 ffffffff833c4ab8 ffff88000014bb50 ffffffff8110836d
> [  292.087372]  ffff880000148050 ffff880000148530 ffff88000014bbd0 ffffffff81ae2614
> [  292.087372]  ffff880000148640 ffff88000014bb78 ffffffff810c7dd7 ffff88000014bb98
> [  292.087372] Call Trace:
> [  292.087372]  [<ffffffff8110836d>] cpuset_print_task_mems_allowed+0x65/0x8b
> [  292.087372]  [<ffffffff81ae2614>] dump_header.isra.11+0x68/0x29a
> [  292.087372]  [<ffffffff810c7dd7>] ? local_clock+0x2b/0x34
> [  292.087372]  [<ffffffff810ce52b>] ? lock_release_holdtime+0xcf/0xdb
> [  292.087372]  [<ffffffff811533d2>] ? out_of_memory+0x318/0x40f
> [  292.087372]  [<ffffffff8115342d>] out_of_memory+0x373/0x40f
> [  292.087372]  [<ffffffff8115324d>] ? out_of_memory+0x193/0x40f
> [  292.087372]  [<ffffffff8115a0ac>] __alloc_pages_nodemask+0xdd1/0x12c4
> [  292.087372]  [<ffffffff8100d301>] ? native_sched_clock+0xe4/0xfc
> [  292.087372]  [<ffffffff81089519>] copy_process+0x21d/0x2115
> [  292.087372]  [<ffffffff810b693e>] ? kthread_create_on_node+0x23e/0x23e
> [  292.087372]  [<ffffffff8100d322>] ? sched_clock+0x9/0xd
> [  292.087372]  [<ffffffff810c7aa7>] ? sched_clock_local.constprop.2+0x35/0xc8
> [  292.087372]  [<ffffffff810360bf>] ? pvclock_clocksource_read+0x9b/0x140
> [  292.087372]  [<ffffffff810b693e>] ? kthread_create_on_node+0x23e/0x23e
> [  292.087372]  [<ffffffff8108b61c>] do_fork+0x105/0x4db
> [  292.087372]  [<ffffffff810c7d54>] ? sched_clock_cpu+0xc9/0xdb
> [  292.087372]  [<ffffffff810c7dd7>] ? local_clock+0x2b/0x34
> [  292.087372]  [<ffffffff810ce52b>] ? lock_release_holdtime+0xcf/0xdb
> [  292.087372]  [<ffffffff810b768d>] ? kthreadd+0x1b3/0x24a
> [  292.087372]  [<ffffffff8108ba18>] kernel_thread+0x26/0x28
> [  292.087372]  [<ffffffff810b76a1>] kthreadd+0x1c7/0x24a
> [  292.087372]  [<ffffffff81afc50a>] ? ret_from_fork+0x7a/0xb0
> [  292.087372]  [<ffffffff810b74da>] ? kthread_create_on_cpu+0x7a/0x7a
> [  292.087372]  [<ffffffff81afc50a>] ret_from_fork+0x7a/0xb0
> [  292.087372]  [<ffffffff810b74da>] ? kthread_create_on_cpu+0x7a/0x7a
> [  292.087372] Code: 1c 92 8e 00 48 8b 45 e0 59 5b 41 5c 41 5d 5d c3 0f 1f 44 00 00 55 48 89 e5 41 54 53 48 89 fb 48 c7 c7 90 d4 47 82 e8 b1 8f 8e 00 <48> 83 7b 38 00 49 89 c4 74 06 48 8b 73 40 eb 07 48 c7 c6 48 fe 
> [  292.087372] RIP  [<ffffffff812119de>] pr_cont_kernfs_name+0x1b/0x6c
> [  292.087372]  RSP <ffff88000014bb20>
> [  292.087372] CR2: 0000000000000038
> [  292.087372] ---[ end trace df25444498a82119 ]---
> [  292.087372] ---[ end trace df25444498a82119 ]---
> 
> git bisect start 483036322b45d800fd68cb028874b6cd4fee3dba 38dbfb59d1175ef458d006556061adeaa8751b72 --
> git bisect  bad 50a557bc0d03997d9203d749b0304c54d2c6e5f5  # 02:20      0-      5  Merge 'cgroup/review-simplify' into devel-hourly-2014020601
> git bisect  bad c04e036e53a39cf2986ddaaf5607ff011f9ea55b  # 03:14      0-      1  Merge 'pinctrl/for-next' into devel-hourly-2014020601
> git bisect good 08ce20bd7ef9a08b74cdfe6fe454374be72b5825  # 03:58     25+      0  Merge 'pci/pci/msi' into devel-hourly-2014020601
> git bisect good 4f86564c657669f69c9cc03151ef6f23ae9e2015  # 04:32     25+      0  Merge 'm68knommu/cf' into devel-hourly-2014020601
> git bisect  bad 29ae23c20b538664beaea72bb0721ce2538b4ca9  # 04:50      0-     11  Merge 'm68knommu/cfmmu' into devel-hourly-2014020601
> git bisect  bad bbce71dbd03db3cf6df7faba0132d87a1a055827  # 04:58      0-      3  Merge 'nfs/devel' into devel-hourly-2014020601
> git bisect good 88a78a912ee059467ae6db7429a6efe4654620a5  # 06:16     25+      1  Merge branch 'acl_fixes' into linux-next
> git bisect good 12b13835a0a8bfabea68741e1ab4d4a4cb77d037  # 06:36     25+      0  kbuild: don't enable DEBUG_INFO when building for COMPILE_TEST
> git bisect  bad 1f35d872a0b9dd05de8f0e50fc2957bf74ea30f7  # 06:55      0-      9  NFS: Shrink nfs_inode by sharing storage for cookieverf and commit_info
> git bisect  bad 878a876b2e10888afe53766dcca33f723ae20edc  # 07:16      0-      4  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
> git bisect good d7512f79fd6cb8e2d9b78770289df6391a867ca1  # 07:20     25+      0  Merge tag 'nfs-for-3.14-3' of git://git.linux-nfs.org/projects/trondmy/linux-nfs
> git bisect  bad 9343224bfd4be6a02e6ae0c0d66426c955c7d76e  # 07:34      0-     12  Merge branch 'akpm' (patches from Andrew Morton)
> git bisect  bad 0cc2aa51be9d2f2b001c0e070b2e5cdde89b39f4  # 07:47      0-     10  Add linux-next specific files for 20140206
> 
> Thanks,
> Fengguang
> 
