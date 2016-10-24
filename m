Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:34854 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751335AbcJXWmp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 18:42:45 -0400
Received: by mail-ua0-f171.google.com with SMTP id 90so21315848uan.2
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Oct 2016 15:42:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+55aFycKG_7qpSs_pH7ibnOYL9vM85UMGhUFEGC-qpB4qkb5A@mail.gmail.com>
References: <20161018234248.GB93792@clm-mbp.masoncoding.com>
 <CA+55aFyXi-iUYx6kOnQrCjzGj-uoOa+0voz0HZz7DAFPYK6ctg@mail.gmail.com>
 <332c8e94-a969-093f-1fb4-30d89be8993e@kernel.org> <20161020225028.czodw54tjbiwwv3o@codemonkey.org.uk>
 <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
 <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk> <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
 <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk> <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
 <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com> <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk>
 <CALCETrXoGd3gq=g61q07JDNTSaY7TjDoPQd3F8UgiwDfyJVLug@mail.gmail.com> <CA+55aFycKG_7qpSs_pH7ibnOYL9vM85UMGhUFEGC-qpB4qkb5A@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 24 Oct 2016 15:42:23 -0700
Message-ID: <CALCETrVQUuPk4c--21+fY98MFy-0mu7C=FAKfLCjPuarP4vUdg@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 24, 2016 at 1:46 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Oct 24, 2016 at 1:06 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>
>>> [69943.450108] Oops: 0003 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>>
>> This is an unhandled kernel page fault.  The string "Oops" is so helpful :-/
>
> I think there was a line above it that DaveJ just didn't include.
>
>>
>>> [69943.454452] CPU: 1 PID: 21558 Comm: trinity-c60 Not tainted 4.9.0-rc1-think+ #11
>>> [69943.463510] task: ffff8804f8dd3740 task.stack: ffffc9000b108000
>>> [69943.468077] RIP: 0010:[<ffffffff810c3f6b>]
>>> [69943.472704]  [<ffffffff810c3f6b>] __lock_acquire.isra.32+0x6b/0x8c0
>>> [69943.477489] RSP: 0018:ffffc9000b10b9e8  EFLAGS: 00010086
>>> [69943.482368] RAX: ffffffff81789b90 RBX: ffff8804f8dd3740 RCX: 0000000000000000
>>> [69943.487410] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>>> [69943.492515] RBP: ffffc9000b10ba18 R08: 0000000000000001 R09: 0000000000000000
>>> [69943.497666] R10: 0000000000000001 R11: 00003f9cfa7f4e73 R12: 0000000000000000
>>> [69943.502880] R13: 0000000000000000 R14: ffffc9000af7bd48 R15: ffff8804f8dd3740
>>> [69943.508163] FS:  00007f64904a2b40(0000) GS:ffff880507a00000(0000) knlGS:0000000000000000
>>> [69943.513591] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [69943.518917] CR2: ffffffff81789d28 CR3: 00000004a8f16000 CR4: 00000000001406e0
>>> [69943.524253] DR0: 00007f5b97fd4000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [69943.529488] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
>>> [69943.534771] Stack:
>>> [69943.540023]  ffff880507bd74c0
>>> [69943.545317]  ffff8804f8dd3740 0000000000000046 0000000000000286[69943.545456]  ffffc9000af7bd08
>>> [69943.550930]  0000000000000100 ffffc9000b10ba50 ffffffff810c4b68[69943.551069]  ffffffff810ba40c
>>> [69943.556657]  ffff880400000000 0000000000000000 ffffc9000af7bd48[69943.556796] Call Trace:
>>> [69943.562465]  [<ffffffff810c4b68>] lock_acquire+0x58/0x70
>>> [69943.568354]  [<ffffffff810ba40c>] ? finish_wait+0x3c/0x70
>>> [69943.574306]  [<ffffffff8178fef2>] _raw_spin_lock_irqsave+0x42/0x80
>>> [69943.580335]  [<ffffffff810ba40c>] ? finish_wait+0x3c/0x70
>>> [69943.586237]  [<ffffffff810ba40c>] finish_wait+0x3c/0x70
>>> [69943.591992]  [<ffffffff81169727>] shmem_fault+0x167/0x1b0
>>> [69943.597807]  [<ffffffff810ba6c0>] ? prepare_to_wait_event+0x100/0x100
>>> [69943.603741]  [<ffffffff8117b46d>] __do_fault+0x6d/0x1b0
>>> [69943.609743]  [<ffffffff8117f168>] handle_mm_fault+0xc58/0x1170
>>> [69943.615822]  [<ffffffff8117e553>] ? handle_mm_fault+0x43/0x1170
>>> [69943.621971]  [<ffffffff81044982>] __do_page_fault+0x172/0x4e0
>>> [69943.628184]  [<ffffffff81044d10>] do_page_fault+0x20/0x70
>>> [69943.634449]  [<ffffffff8132a897>] ? debug_smp_processor_id+0x17/0x20
>>> [69943.640784]  [<ffffffff81791f3f>] page_fault+0x1f/0x30
>>> [69943.647170]  [<ffffffff8133d69c>] ? strncpy_from_user+0x5c/0x170
>>> [69943.653480]  [<ffffffff8133d686>] ? strncpy_from_user+0x46/0x170
>>> [69943.659632]  [<ffffffff811f22a7>] setxattr+0x57/0x170
>>> [69943.665846]  [<ffffffff8132a897>] ? debug_smp_processor_id+0x17/0x20
>>> [69943.672172]  [<ffffffff810c1f09>] ? get_lock_stats+0x19/0x50
>>> [69943.678558]  [<ffffffff810a58f6>] ? sched_clock_cpu+0xb6/0xd0
>>> [69943.685007]  [<ffffffff810c40cf>] ? __lock_acquire.isra.32+0x1cf/0x8c0
>>> [69943.691542]  [<ffffffff8132a8b3>] ? __this_cpu_preempt_check+0x13/0x20
>>> [69943.698130]  [<ffffffff8109b9bc>] ? preempt_count_add+0x7c/0xc0
>>> [69943.704791]  [<ffffffff811ecda1>] ? __mnt_want_write+0x61/0x90
>>> [69943.711519]  [<ffffffff811f2638>] SyS_fsetxattr+0x78/0xa0
>>> [69943.718300]  [<ffffffff8100255c>] do_syscall_64+0x5c/0x170
>>> [69943.724949]  [<ffffffff81790a4b>] entry_SYSCALL64_slow_path+0x25/0x25
>>> [69943.731521] Code:
>>> [69943.738124] 00 83 fe 01 0f 86 0e 03 00 00 31 d2 4c 89 f7 44 89 45 d0 89 4d d4 e8 75 e7 ff ff 8b 4d d4 48 85 c0 44 8b 45 d0 0f 84 d8 02 00 00 <f0> ff 80 98 01 00 00 8b 15 e0 21 8f 01 45 8b 8f 50 08 00 00 85
>>
>> That's lock incl 0x198(%rax).  I think this is:
>>
>>     atomic_inc((atomic_t *)&class->ops);
>>
>> I suppose this could be stack corruption at work, but after a fair
>> amount of staring, I still haven't found anything in the vmap_stack
>> code that would cause stack corruption.
>
> Well, it is intriguing that what faults is this:
>
>                         finish_wait(shmem_falloc_waitq, &shmem_fault_wait);
>
> where 'shmem_fault_wait' is a on-stack wait queue. So it really looks
> very much like stack corruption.
>
> What strikes me is that "finish_wait()" does this optimistic "has my
> entry been removed" without holding the waitqueue lock (and uses
> list_empty_careful() to make sure it does that "safely").
>
> It has that big comment too:
>
>                         /*
>                          * shmem_falloc_waitq points into the shmem_fallocate()
>                          * stack of the hole-punching task: shmem_falloc_waitq
>                          * is usually invalid by the time we reach here, but
>                          * finish_wait() does not dereference it in that case;
>                          * though i_lock needed lest racing with wake_up_all().
>                          */
>
> the stack it comes from is the wait queue head from shmem_fallocate(),
> which will do "wake_up_all()" under the inode lock.

Here's my theory: I think you're looking at the right code but the
wrong stack.  shmem_fault_wait is fine, but shmem_fault_waitq looks
really dicey.  Consider:

fallocate calls wake_up_all(), which calls autoremove_wait_function().
That wakes up the shmem_fault thread.  Suppose that the shmem_fault
thread gets moving really quickly (presumably because it never went to
sleep in the first place -- suppose it hadn't made it to schedule(),
so schedule() turns into a no-op).  It calls finish_wait() *before*
autoremove_wake_function() does the list_del_init().  finish_wait()
gets to the list_empty_careful() call and it returns true.

Now the fallocate thread catches up and *exits*.  Dave's test makes a
new thread that reuses the stack (the vmap area or the backing store).

Now the shmem_fault thread continues on its merry way and takes
q->lock.  But oh crap, q->lock is pointing at some random spot on some
other thread's stack.  Kaboom!

If I'm right, actually blowing up due to this bug would have been
very, very unlikely on 4.8 and below, and it has nothing to do with
vmap stacks per se -- it was the RCU removal.  We used to wait for an
RCU grace period before reusing a stack, and there couldn't have been
an RCU grace period in the middle of finish_wait(), so we were safer.
(Not totally safe, because the thread that called fallocate() could
have made it somewhere else that used the same stack depth, but I can
see that being less likely.)

IOW, I think that autoremove_wake_function() is buggy.  It should
remove the wait entry, then try to wake the thread, then re-add the
wait entry if the wakeup fails.  Or maybe it should use some atomic
flag in the wait entry or have some other locking to make sure that
finish_wait does not touch q->lock if autoremove_wake_function
succeeds.

--Andy
