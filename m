Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35837 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750979AbcLDXEt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Dec 2016 18:04:49 -0500
MIME-Version: 1.0
In-Reply-To: <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk>
References: <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com> <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com> <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk> <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com> <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk>
 <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk>
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 5 Dec 2016 00:04:46 +0100
Message-ID: <CAOMGZ=HPUoVZ8_yBLsMUHLigvKadKwBio-8gJ5-WM+2Fe4BZ6A@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23 November 2016 at 20:58, Dave Jones <davej@codemonkey.org.uk> wrote:
> On Wed, Nov 23, 2016 at 02:34:19PM -0500, Dave Jones wrote:
>
>  > [  317.689216] BUG: Bad page state in process kworker/u8:8  pfn:4d8fd4
>  > trace from just before this happened. Does this shed any light ?
>  >
>  > https://codemonkey.org.uk/junk/trace.txt
>
> crap, I just noticed the timestamps in the trace come from quite a bit
> later.  I'll tweak the code to do the taint checking/ftrace stop after
> every syscall, that should narrow the window some more.

FWIW I hit this as well:

BUG: unable to handle kernel paging request at ffffffff81ff08b7
IP: [<ffffffff8135f2ea>] __lock_acquire.isra.32+0xda/0x1a30
PGD 461e067 PUD 461f063
PMD 1e001e1
Oops: 0003 [#1] PREEMPT SMP KASAN
Dumping ftrace buffer:
  (ftrace buffer empty)
CPU: 0 PID: 21744 Comm: trinity-c56 Tainted: G    B           4.9.0-rc7+ #217
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
task: ffff8801ee924080 task.stack: ffff8801bab88000
RIP: 0010:[<ffffffff8135f2ea>]  [<ffffffff8135f2ea>]
__lock_acquire.isra.32+0xda/0x1a30
RSP: 0018:ffff8801bab8f730  EFLAGS: 00010082
RAX: ffffffff81ff071f RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff85ae7d00
RBP: ffff8801bab8f7b0 R08: 0000000000000001 R09: 0000000000000000
R10: ffff8801e727fc40 R11: fffffbfff0b54ced R12: ffffffff85ae7d00
R13: ffffffff84912920 R14: ffff8801ee924080 R15: 0000000000000000
FS:  00007f37ee653700(0000) GS:ffff8801f6a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffff81ff08b7 CR3: 00000001daa70000 CR4: 00000000000006f0
DR0: 00007f37ee465000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Stack:
ffff8801ee9247d0 0000000000000000 0000000100000000 ffff8801ee924080
ffff8801f6a201c0 ffff8801f6a201c0 0000000000000000 0000000000000001
ffff880100000000 ffff880100000000 ffff8801e727fc40 ffff8801ee924080
Call Trace:
[<ffffffff81361751>] lock_acquire+0x141/0x2b0
[<ffffffff813530c0>] ? finish_wait+0xb0/0x180
[<ffffffff83c95b29>] _raw_spin_lock_irqsave+0x49/0x60
[<ffffffff813530c0>] ? finish_wait+0xb0/0x180
[<ffffffff813530c0>] finish_wait+0xb0/0x180
[<ffffffff81576227>] shmem_fault+0x4c7/0x6b0
[<ffffffff83a9b7cd>] ? p9_client_rpc+0x13d/0xf40
[<ffffffff81575d60>] ? shmem_getpage_gfp+0x1c90/0x1c90
[<ffffffff81fbe777>] ? radix_tree_next_chunk+0x4f7/0x840
[<ffffffff81352150>] ? wake_atomic_t_function+0x210/0x210
[<ffffffff815ad316>] __do_fault+0x206/0x410
[<ffffffff815ad110>] ? do_page_mkwrite+0x320/0x320
[<ffffffff815b9bcf>] handle_mm_fault+0x1cef/0x2a60
[<ffffffff815b8012>] ? handle_mm_fault+0x132/0x2a60
[<ffffffff815b7ee0>] ? __pmd_alloc+0x370/0x370
[<ffffffff81692e7e>] ? inode_add_bytes+0x10e/0x160
[<ffffffff8162de11>] ? memset+0x31/0x40
[<ffffffff815cba10>] ? find_vma+0x30/0x150
[<ffffffff812373a2>] __do_page_fault+0x452/0x9f0
[<ffffffff81ff071f>] ? iov_iter_init+0xaf/0x1d0
[<ffffffff81237bf5>] trace_do_page_fault+0x1e5/0x3a0
[<ffffffff8122a007>] do_async_page_fault+0x27/0xa0
[<ffffffff83c97618>] async_page_fault+0x28/0x30
[<ffffffff82059341>] ? strnlen_user+0x91/0x1a0
[<ffffffff8205931e>] ? strnlen_user+0x6e/0x1a0
[<ffffffff8157e038>] strndup_user+0x28/0xb0
[<ffffffff81d83c17>] SyS_add_key+0xc7/0x370
[<ffffffff81d83b50>] ? key_get_type_from_user.constprop.6+0xd0/0xd0
[<ffffffff815143ea>] ? __context_tracking_exit.part.4+0x3a/0x1e0
[<ffffffff81d83b50>] ? key_get_type_from_user.constprop.6+0xd0/0xd0
[<ffffffff8100524f>] do_syscall_64+0x1af/0x4d0
[<ffffffff83c96534>] entry_SYSCALL64_slow_path+0x25/0x25
Code: 89 4d b8 44 89 45 c0 89 4d c8 4c 89 55 d0 e8 ee c3 ff ff 48 85
c0 4c 8b 55 d0 8b 4d c8 44 8b 45 c0 4c 8b 4d b8 0f 84 c6 01 00 00 <3e>
ff 80 98 01 00 00 49 8d be 48 07 00 00 48 ba 00 00 00 00 00
RIP  [<ffffffff8135f2ea>] __lock_acquire.isra.32+0xda/0x1a30

I didn't read all the emails in this thread, the crash site looks
identical to one of the earlier traces although the caller may be
different.

I think you can rule out btrfs in any case, probably block layer as
well, since it looks like this comes from shmem.


Vegard
