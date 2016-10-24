Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:54272 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbcJXElD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 00:41:03 -0400
Date: Mon, 24 Oct 2016 00:40:51 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: bio linked list corruption.
Message-ID: <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk>
References: <20161018234248.GB93792@clm-mbp.masoncoding.com>
 <CA+55aFyXi-iUYx6kOnQrCjzGj-uoOa+0voz0HZz7DAFPYK6ctg@mail.gmail.com>
 <332c8e94-a969-093f-1fb4-30d89be8993e@kernel.org>
 <20161020225028.czodw54tjbiwwv3o@codemonkey.org.uk>
 <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
 <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk>
 <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
 <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
 <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
 <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 23, 2016 at 05:32:21PM -0400, Chris Mason wrote:
 > 
 > 
 > On 10/22/2016 11:20 AM, Dave Jones wrote:
 > > On Fri, Oct 21, 2016 at 04:02:45PM -0400, Dave Jones wrote:
 > >
 > >  >  > It could be worth trying this, too:
 > >  >  >
 > >  >  > https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vmap_stack&id=174531fef4e8
 > >  >  >
 > >  >  > It occurred to me that the current code is a little bit fragile.
 > >  >
 > >  > It's been nearly 24hrs with the above changes, and it's been pretty much
 > >  > silent the whole time.
 > >  >
 > >  > The only thing of note over that time period has been a btrfs lockdep
 > >  > warning that's been around for a while, and occasional btrfs checksum
 > >  > failures, which I've been seeing for a while, but seem to have gotten
 > >  > worse since 4.8.
 > >  >
 > >  > I'm pretty confident in the disk being ok in this machine, so I think
 > >  > the checksum warnings are bogus.  Chris suggested they may be the result
 > >  > of memory corruption, but there's little else going on.
 > >
 > > The only interesting thing last nights run was this..
 > >
 > > BUG: Bad page state in process kworker/u8:1  pfn:4e2b70
 > > page:ffffea00138adc00 count:0 mapcount:0 mapping:ffff88046e9fc2e0 index:0xdf0
 > > flags: 0x400000000000000c(referenced|uptodate)
 > > page dumped because: non-NULL mapping
 > > CPU: 3 PID: 24234 Comm: kworker/u8:1 Not tainted 4.9.0-rc1-think+ #11
 > > Workqueue: writeback wb_workfn (flush-btrfs-2)
 > 
 > Well crud, we're back to wondering if this is Btrfs or the stack 
 > corruption.  Since the pagevecs are on the stack and this is a new 
 > crash, my guess is you'll be able to trigger it on xfs/ext4 too.  But we 
 > should make sure.

Here's an interesting one from today, pointing the finger at xattrs again.


[69943.450108] Oops: 0003 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[69943.454452] CPU: 1 PID: 21558 Comm: trinity-c60 Not tainted 4.9.0-rc1-think+ #11 
[69943.463510] task: ffff8804f8dd3740 task.stack: ffffc9000b108000
[69943.468077] RIP: 0010:[<ffffffff810c3f6b>] 
[69943.472704]  [<ffffffff810c3f6b>] __lock_acquire.isra.32+0x6b/0x8c0
[69943.477489] RSP: 0018:ffffc9000b10b9e8  EFLAGS: 00010086
[69943.482368] RAX: ffffffff81789b90 RBX: ffff8804f8dd3740 RCX: 0000000000000000
[69943.487410] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[69943.492515] RBP: ffffc9000b10ba18 R08: 0000000000000001 R09: 0000000000000000
[69943.497666] R10: 0000000000000001 R11: 00003f9cfa7f4e73 R12: 0000000000000000
[69943.502880] R13: 0000000000000000 R14: ffffc9000af7bd48 R15: ffff8804f8dd3740
[69943.508163] FS:  00007f64904a2b40(0000) GS:ffff880507a00000(0000) knlGS:0000000000000000
[69943.513591] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[69943.518917] CR2: ffffffff81789d28 CR3: 00000004a8f16000 CR4: 00000000001406e0
[69943.524253] DR0: 00007f5b97fd4000 DR1: 0000000000000000 DR2: 0000000000000000
[69943.529488] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[69943.534771] Stack:
[69943.540023]  ffff880507bd74c0
[69943.545317]  ffff8804f8dd3740 0000000000000046 0000000000000286[69943.545456]  ffffc9000af7bd08
[69943.550930]  0000000000000100 ffffc9000b10ba50 ffffffff810c4b68[69943.551069]  ffffffff810ba40c
[69943.556657]  ffff880400000000 0000000000000000 ffffc9000af7bd48[69943.556796] Call Trace:
[69943.562465]  [<ffffffff810c4b68>] lock_acquire+0x58/0x70
[69943.568354]  [<ffffffff810ba40c>] ? finish_wait+0x3c/0x70
[69943.574306]  [<ffffffff8178fef2>] _raw_spin_lock_irqsave+0x42/0x80
[69943.580335]  [<ffffffff810ba40c>] ? finish_wait+0x3c/0x70
[69943.586237]  [<ffffffff810ba40c>] finish_wait+0x3c/0x70
[69943.591992]  [<ffffffff81169727>] shmem_fault+0x167/0x1b0
[69943.597807]  [<ffffffff810ba6c0>] ? prepare_to_wait_event+0x100/0x100
[69943.603741]  [<ffffffff8117b46d>] __do_fault+0x6d/0x1b0
[69943.609743]  [<ffffffff8117f168>] handle_mm_fault+0xc58/0x1170
[69943.615822]  [<ffffffff8117e553>] ? handle_mm_fault+0x43/0x1170
[69943.621971]  [<ffffffff81044982>] __do_page_fault+0x172/0x4e0
[69943.628184]  [<ffffffff81044d10>] do_page_fault+0x20/0x70
[69943.634449]  [<ffffffff8132a897>] ? debug_smp_processor_id+0x17/0x20
[69943.640784]  [<ffffffff81791f3f>] page_fault+0x1f/0x30
[69943.647170]  [<ffffffff8133d69c>] ? strncpy_from_user+0x5c/0x170
[69943.653480]  [<ffffffff8133d686>] ? strncpy_from_user+0x46/0x170
[69943.659632]  [<ffffffff811f22a7>] setxattr+0x57/0x170
[69943.665846]  [<ffffffff8132a897>] ? debug_smp_processor_id+0x17/0x20
[69943.672172]  [<ffffffff810c1f09>] ? get_lock_stats+0x19/0x50
[69943.678558]  [<ffffffff810a58f6>] ? sched_clock_cpu+0xb6/0xd0
[69943.685007]  [<ffffffff810c40cf>] ? __lock_acquire.isra.32+0x1cf/0x8c0
[69943.691542]  [<ffffffff8132a8b3>] ? __this_cpu_preempt_check+0x13/0x20
[69943.698130]  [<ffffffff8109b9bc>] ? preempt_count_add+0x7c/0xc0
[69943.704791]  [<ffffffff811ecda1>] ? __mnt_want_write+0x61/0x90
[69943.711519]  [<ffffffff811f2638>] SyS_fsetxattr+0x78/0xa0
[69943.718300]  [<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[69943.724949]  [<ffffffff81790a4b>] entry_SYSCALL64_slow_path+0x25/0x25
[69943.731521] Code: 
[69943.738124] 00 83 fe 01 0f 86 0e 03 00 00 31 d2 4c 89 f7 44 89 45 d0 89 4d d4 e8 75 e7 ff ff 8b 4d d4 48 85 c0 44 8b 45 d0 0f 84 d8 02 00 00 <f0> ff 80 98 01 00 00 8b 15 e0 21 8f 01 45 8b 8f 50 08 00 00 85 [69943.745506] RIP 
[69943.752432]  [<ffffffff810c3f6b>] __lock_acquire.isra.32+0x6b/0x8c0
 RSP <ffffc9000b10b9e8>
[69943.766856] CR2: ffffffff81789d28


