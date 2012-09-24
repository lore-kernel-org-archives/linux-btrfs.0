Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44852 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab2IXOlE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 10:41:04 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1TG9qJ-0007HV-9J
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2012 07:41:03 -0700
Date: Mon, 24 Sep 2012 07:41:03 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: crash in read_extent_buffer+0xb7/0xfb
Message-ID: <20120924144103.GM23057@merlins.org>
References: <20120920171747.GG26105@merlins.org> <20120921034652.GA871@merlins.org> <20120923161634.GA23057@merlins.org> <20120924130847.GD14582@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120924130847.GD14582@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 03:08:47PM +0200, David Sterba wrote:
> > I had a different crash while copying to a btrfs 5 disk array. Not sure if this is
> > also fixed too, but pasting just in case.
> >  
> > [207025.055956] btrfs: bdev /dev/mapper/crypt_sdo1 errs: wr 46779, rd 0, flush 7 6, corrupt 0, gen 0
> 
> So many write and flush errors?
 
It's possible, I have crappy drives that were cheap that I'm using for tests
and copies.

> R11 contains the POISON_FREE pattern, though it's not clear who and where
> used it. It may come from some unhandled case in the write error
> recovery paths.
 
Considering that I was doing a huge copy to a brtfs filesystem (source was
ext4) and that I was using crappy drives in a 5 drives configuration
with no redundancy since there is no raid5 yet, it's very possible.

> The crash site is not any of the BUG_ON but some place that actually
> tries to access an unmapped memory, so from that point it slipped
> through sanity checks.

If that helps, I forgot to decode the ASM:

========
   0:   b7 6d                   mov    $0x6d,%bh
   2:   db b6 6d db b6 6d       (bad)  0x6db6db6d(%rsi)
   8:   49 bd 00 00 00 00 00    movabs $0xffff880000000000,%r13
   f:   88 ff ff 
  12:   49 c1 e0 03             shl    $0x3,%r8
  16:   eb 43                   jmp    0x5b
  18:   48 8b 8b 50 01 00 00    mov    0x150(%rbx),%rcx
  1f:   4c 89 d0                mov    %r10,%rax
  22:   48 89 d7                mov    %rdx,%rdi
  25:   4c 29 f8                sub    %r15,%rax
  28:   4c 39 e0                cmp    %r12,%rax
  2b:*  4a 8b 0c 01             mov    (%rcx,%r8,1),%rcx     <-- trapping instruction
  2f:   49 0f 47 c4             cmova  %r12,%rax
  33:   49 83 c0 08             add    $0x8,%r8
  37:   49 29 c4                sub    %rax,%r12
  3a:   4c 01 c9                add    %r9,%rcx
  3d:   48                      rex.W
  3e:   c1                      .byte 0xc1
  3f:   f9                      stc    

Code starting with the faulting instruction
===========================================
   0:   4a 8b 0c 01             mov    (%rcx,%r8,1),%rcx
   4:   49 0f 47 c4             cmova  %r12,%rax
   8:   49 83 c0 08             add    $0x8,%r8
   c:   49 29 c4                sub    %rax,%r12
   f:   4c 01 c9                add    %r9,%rcx
  12:   48                      rex.W
  13:   c1                      .byte 0xc1
  14:   f9                      stc   

For 

[207055.244330] Pid: 6456, comm: btrfs-transacti Tainted: G        W    3.5.3-amd64-preempt-noide-20120903 #1 System manufacturer System Product Name/P8H67-M PRO
[207055.261478] RIP: 0010:[<ffffffff811fc9ae>]  [<ffffffff811fc9ae>] read_extent_buffer+0xb7/0xfb
[207055.271621] RSP: 0018:ffff880105ff3880  EFLAGS: 00010202
[207055.278516] RAX: 0000000000000bbe RBX: ffff8800405ba1f8 RCX: ffff8800405ba2c8
[207055.287257] RDX: ffff880105ff38ec RSI: 0000000000000086 RDI: ffff880105ff38ec
[207055.295967] RBP: ffff880105ff38c0 R08: 007ffffffd4ebdc8 R09: 0000160000000000
[207055.304674] R10: 0000000000001000 R11: 6db6db6db6db6db7 R12: 0000000000000004
[207055.313356] R13: ffff880000000000 R14: fffffffa9d7b9446 R15: 000000000000044 2
[207055.322032] FS:  0000000000000000(0000) GS:ffff88011f380000(0000) knlGS:0000000000000000
[207055.331692] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[207055.339014] CR2: 00000000f7021000 CR3: 0000000001a0c000 CR4: 00000000000407e0
[207055.347715] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[207055.356403] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[207055.365092] Process btrfs-transacti (pid: 6456, threadinfo ffff880105ff2000,task ffff880105e7e600)
[207055.376219] Stack:
[207055.380369]  fffffffa9d7b9442 000fffffffa9d7b9 ffff880105ff38a0 0000000000000000
[207055.389447]  ffff8800405ba1f8 fffffffa9d7b9431 fffffffa9d7b9442 00000000798be017
[207055.398481]  ffff880105ff3910 ffffffff811f2855 ffff8800405ba1f8 fffffffa9d7b9000
[207055.407543] Call Trace:
[207055.411582]  [<ffffffff811f2855>] btrfs_token_item_offset+0x86/0xb8
[207055.419436]  [<ffffffff811f295f>] btrfs_item_offset+0xb/0xd
[207055.426585]  [<ffffffff811c04bf>] btrfs_item_offset_nr+0x14/0x16
[207055.434143]  [<ffffffff811c08f9>] leaf_space_used+0x58/0x81
[207055.441269]  [<ffffffff811c42ea>] btrfs_leaf_free_space+0x33/0x72
[207055.448924]  [<ffffffff811c4d45>] push_leaf_right+0xa1/0x142
[207055.456092]  [<ffffffff814aa936>] ? _raw_spin_lock+0x1b/0x1f
[207055.463329]  [<ffffffff811c4f13>] split_leaf+0x79/0x52f
[207055.470222]  [<ffffffff811f295f>] ? btrfs_item_offset+0xb/0xd
[207055.477483]  [<ffffffff811c08f9>] ? leaf_space_used+0x58/0x81
[207055.484744]  [<ffffffff814aac0e>] ? _raw_write_unlock+0x28/0x33
[207055.492203]  [<ffffffff8120a523>] ? btrfs_set_lock_blocking_rw+0x9b/0xec
[207055.500770]  [<ffffffff811c5b5c>] btrfs_search_slot+0x583/0x62e
[207055.508199]  [<ffffffff811c6e32>] btrfs_insert_empty_items+0x62/0xb4
[207055.516029]  [<ffffffff811cef40>] run_clustered_refs+0x3e2/0x741
[207055.523655]  [<ffffffff811cf503>] btrfs_run_delayed_refs+0x264/0x373
[207055.531450]  [<ffffffff81085cf8>] ? arch_local_irq_save+0x15/0x1b
[207055.538950]  [<ffffffff814aa936>] ? _raw_spin_lock+0x1b/0x1f
[207055.545965]  [<ffffffff814aaab9>] ? _raw_spin_unlock+0x27/0x32
[207055.553168]  [<ffffffff811f6c51>] ? btrfs_run_ordered_operations+0x19f/0x1ae
[207055.561517]  [<ffffffff811dd30f>] btrfs_commit_transaction+0xa9/0x8dc
[207055.569231]  [<ffffffff8105957a>] ? add_wait_queue+0x44/0x44
[207055.576235]  [<ffffffff81049f32>] ? init_timer_deferrable_key+0x17/0x17
[207055.584056]  [<ffffffff811d7e58>] transaction_kthread+0x174/0x230
[207055.591332]  [<ffffffff811d7ce4>] ? try_to_freeze+0x33/0x33
[207055.598153]  [<ffffffff81058e3c>] kthread+0x86/0x8e
[207055.604162]  [<ffffffff814b08a4>] kernel_thread_helper+0x4/0x10
[207055.611168]  [<ffffffff81058db6>] ? kthread_freezable_should_stop+0x3e/0x3e
[207055.619358]  [<ffffffff814b08a0>] ? gs_change+0x13/0x13
[207055.625624] Code: b7 6d db b6 6d db b6 6d 49 bd 00 00 00 00 00 88 ff ff 49 c1 e0 03 eb 43 48 8b 8b 50 01 00 00 4c 89 d0 48 89 d7 4c 29 f8 4c 39 e0 <4a> 8b 0c 01 49 0f 47 c4 49 83 c0 08 49 29 c4 4c 01 c9 48 c1 f9
[207055.647970] RIP  [<ffffffff811fc9ae>] read_extent_buffer+0xb7/0xfb
[207055.655271]  RSP <ffff880105ff3880>
[207055.665029] ---[ end trace 06a6f0aa8102336a ]---
[207055.671223] Kernel panic - not syncing: Fatal exception
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
