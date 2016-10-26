Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35444 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753810AbcJZBd2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 21:33:28 -0400
MIME-Version: 1.0
In-Reply-To: <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk>
References: <332c8e94-a969-093f-1fb4-30d89be8993e@kernel.org>
 <20161020225028.czodw54tjbiwwv3o@codemonkey.org.uk> <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
 <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk> <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
 <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk> <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
 <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com> <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk>
 <77d9983d-a00a-1dc1-a9a1-631de1d0c146@fb.com> <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Oct 2016 18:33:26 -0700
Message-ID: <CA+55aFyv0k9e6bBqGm-LL3CUwimS4+rSu341P7SOV5ezYrrW_g@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 25, 2016 at 5:27 PM, Dave Jones <davej@codemonkey.org.uk> wrote:
>
> DaveC: Do these look like real problems, or is this more "looks like
> random memory corruption" ?  It's been a while since I did some stress
> testing on XFS, so these might not be new..

Andy, do you think we could just do some poisoning of the stack as we
free it, to see if that catches anything?

Something truly stupid like just

    --- a/kernel/fork.c
    +++ b/kernel/fork.c
    @@ -218,6 +218,7 @@ static inline void free_thread_stack(struct
task_struct *tsk)
                    unsigned long flags;
                    int i;

    +               memset(tsk->stack_vm_area->addr, 0xd0, THREAD_SIZE);
                    local_irq_save(flags);
                    for (i = 0; i < NR_CACHED_STACKS; i++) {
                            if (this_cpu_read(cached_stacks[i]))

or similar?

It seems like DaveJ had an easier time triggering these problems with
the stack cache, but they clearly didn't go away when the stack cache
was disabled. So maybe the stack cache just made the reuse more likely
and faster, making the problem show up faster too. But if we actively
poison things, we'll corrupt the free'd stack *immediately* if there
is some stale use..

Completely untested. Maybe there's some reason we can't write to the
whole thing like that?

                 Linus

              Linus
