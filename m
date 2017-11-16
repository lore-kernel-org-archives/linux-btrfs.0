Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55592 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933899AbdKPVpw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 16:45:52 -0500
Date: Thu, 16 Nov 2017 13:45:51 -0800
From: Marc MERLIN <marc@merlins.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 4.13.12: kernel BUG at fs/btrfs/ctree.h:1802!
Message-ID: <20171116214551.vpp4eevs7b4bszjt@merlins.org>
References: <20171116170445.24n57phzltgiehj6@merlins.org>
 <20171116170742.vyhxckxrgjzwqyvf@merlins.org>
 <70b25128-d724-4e8e-9835-4a092cf8d5a6@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <70b25128-d724-4e8e-9835-4a092cf8d5a6@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 16, 2017 at 06:27:44PM +0100, Holger Hoffstätte wrote:
> On 11/16/17 18:07, Marc MERLIN wrote:
> > Sorry, was missing the kernel number in the subject, just fixed that.
> > 
> > On Thu, Nov 16, 2017 at 09:04:45AM -0800, Marc MERLIN wrote:
> >> My server now reboots every 20mn or so, with this.
> >> Sadly another BUG_ON() and it won't even tell me which filesystem
> >> it's on
> >>
> >> static inline u32 btrfs_extent_inline_ref_size(int type)
> >> {
> >> 	if (type == BTRFS_TREE_BLOCK_REF_KEY ||
> >> 	    type == BTRFS_SHARED_BLOCK_REF_KEY)
> >> 		return sizeof(struct btrfs_extent_inline_ref);
> >> 	if (type == BTRFS_SHARED_DATA_REF_KEY)
> >> 		return sizeof(struct btrfs_shared_data_ref) +
> >> 		       sizeof(struct btrfs_extent_inline_ref);
> >> 	if (type == BTRFS_EXTENT_DATA_REF_KEY)
> >> 		return sizeof(struct btrfs_extent_data_ref) +
> >> 		       offsetof(struct btrfs_extent_inline_ref, offset);
> >> 	BUG();
> >> 	return 0;
> >> }
> 
> This BUG() was recently removed and seems to be caused by some kind
> of persistent corruption, which is seen as invalid inline extent.
> See [1], [2] for details. Maybe you can backport them?
> Alternatively just give 4.14 a whirl, it's great.
> 
> -h
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=167ce953ca55bdee20fe56c3c0fa51002435f745
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4335958de2a43c6790c7f6aa0682aa7189983fa4

First thanks a lot for the quick reply, it was super timely considering
my server was rebooting every 20mn :)
I've now been running 4.14 for a couple of hours, and things seem ok
btrfs-wise.

So, just so that I understand:
1) I do have some kind of FS problem/corruption (minor? major?)

2) it started crashing 4.9.36 and then 4.13 today, every 20mn, probably due to some background
cleaner process that kept starting and hitting the problem spot

3) 4.14 does not crash anymore, but it doesn't even report any problem either. Does it mean
the error that crashed the old kernel is minor enough that the new kernel doesn't bother even
logging it?

4) I just ran scrub on the filesystem and it ran fine.

Sadly, while the BUG_ON was another one that failed to say which
mountpoint was affected, through painful trial and error, I think I
found out that it was affecting the root filesystem.
Doing a check or check --repair on that FS will be a major pain (need a rescue
media with the right version of dmcrypt, bcache, btrfs kernel, and btrfs progs)

I'm asusming that running btrfs check --force on a mounted filesystem
that is being used is not going to give useful results, unless I leave
the FS read only. Correct?


As for 4.14, the serial console code seems broken though, I can't get login or bash
to work anymore on them:
[ 2786.305004] INFO: task login:5636 blocked for more than 120 seconds.
[ 2786.324648]       Tainted: G     U  W       4.14.0-amd64-stkreg-sysrq-20171018 #1
[ 2786.347692] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2786.371742] login           D    0  5636      1 0xa0020006
[ 2786.388826] Call Trace:
[ 2786.396756]  __schedule+0x4b3/0x5bd
[ 2786.408077]  schedule+0x89/0x9a
[ 2786.418070]  schedule_timeout+0x43/0x101
[ 2786.430728]  ? default_wake_function+0x12/0x14
[ 2786.444620]  ? woken_wake_function+0x11/0x13
[ 2786.457967]  ldsem_down_write+0xe0/0x1a8
[ 2786.470293]  ? ldsem_down_write+0xe0/0x1a8
[ 2786.483143]  ? __wake_up_common_lock+0xa6/0xcf
[ 2786.497039]  tty_ldisc_lock+0x16/0x30
[ 2786.508587]  ? tty_ldisc_lock+0x16/0x30
[ 2786.520655]  tty_ldisc_hangup+0xbb/0x170
[ 2786.533000]  __tty_hangup+0x15f/0x21d
[ 2786.544541]  tty_vhangup_session+0x13/0x15
[ 2786.557388]  disassociate_ctty+0x51/0x209
[ 2786.570004]  do_exit+0x43a/0x923
[ 2786.580262]  ? recalc_sigpending_tsk+0x42/0x49
[ 2786.594120]  do_group_exit+0x6c/0xa5
[ 2786.605419]  get_signal+0x46b/0x4b3
[ 2786.616464]  do_signal+0x37/0x5ed
[ 2786.626969]  ? list_add+0x34/0x34
[ 2786.637474]  ? C_SYSC_wait4+0x49/0x99
[ 2786.649099]  ? handle_mm_fault+0x10f/0x17f
[ 2786.661968]  prepare_exit_to_usermode+0x94/0xef
[ 2786.676115]  syscall_return_slowpath+0xb9/0xd9
[ 2786.690035]  do_fast_syscall_32+0xc3/0xfe
[ 2786.702897]  entry_SYSENTER_compat+0x4c/0x5b
[ 2786.716272] RIP: 0023:0xf7f45c29
[ 2786.726496] RSP: 002b:00000000ffb5d0f0 EFLAGS: 00000246 ORIG_RAX: 0000000000000072
[ 2786.749827] RAX: fffffffffffffe00 RBX: 00000000ffffffff RCX: 0000000000000000
[ 2786.772104] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000080504ec
[ 2786.794087] RBP: 00000000ffb5f638 R08: 0000000000000000 R09: 0000000000000000
[ 2786.794088] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 2786.794088] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

[ 2665.988277] INFO: task bash:5685 blocked for more than 120 seconds.
[ 2665.988278]       Tainted: G     U  W       4.14.0-amd64-stkreg-sysrq-20171018 #1
[ 2665.988279] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2665.988281] bash            D    0  5685   5636 0xa0020086
[ 2665.988284] Call Trace:
[ 2665.988288]  __schedule+0x4b3/0x5bd
[ 2665.988291]  schedule+0x89/0x9a
[ 2665.988293]  schedule_preempt_disabled+0x15/0x1e
[ 2665.988294]  __mutex_lock.isra.1+0x16d/0x2e0
[ 2665.988298]  __mutex_lock_slowpath+0x13/0x15
[ 2665.988300]  ? __mutex_lock_slowpath+0x13/0x15
[ 2665.988301]  mutex_lock+0x2a/0x2d
[ 2665.988304]  tty_lock+0x31/0x3c
[ 2665.988306]  tty_release+0x48/0x53c
[ 2665.988310]  __fput+0xf0/0x190
[ 2665.988312]  ____fput+0xe/0x10
[ 2665.988314]  task_work_run+0x79/0x8c
[ 2665.988317]  do_exit+0x447/0x923
[ 2665.988320]  ? recalc_sigpending_tsk+0x42/0x49
[ 2665.988322]  do_group_exit+0x6c/0xa5
[ 2665.988323]  get_signal+0x46b/0x4b3
[ 2665.988327]  do_signal+0x37/0x5ed
[ 2665.988329]  ? group_send_sig_info+0x4e/0x56
[ 2665.988331]  ? SYSC_kill+0xa8/0x1b1
[ 2665.988333]  ? do_sigaction+0xbe/0x18b
[ 2665.988335]  ? __audit_syscall_entry+0xc2/0xe6
[ 2665.988338]  prepare_exit_to_usermode+0x94/0xef
[ 2665.988341]  syscall_return_slowpath+0xb9/0xd9
[ 2665.988343]  do_fast_syscall_32+0xc3/0xfe
[ 2665.988345]  entry_SYSENTER_compat+0x4c/0x5b
[ 2665.988347] RIP: 0023:0xf7f24c29
[ 2665.988348] RSP: 002b:00000000ffccf9ec EFLAGS: 00000206 ORIG_RAX: 0000000000000025
[ 2665.988350] RAX: 0000000000000000 RBX: 0000000000001635 RCX: 0000000000000001
[ 2665.988351] RDX: 0000000000000001 RSI: 00000000080a0310 RDI: 0000000000000000
[ 2665.988351] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
[ 2665.988352] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 2665.988353] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
