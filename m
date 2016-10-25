Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33434 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751288AbcJYAAh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 20:00:37 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVQUuPk4c--21+fY98MFy-0mu7C=FAKfLCjPuarP4vUdg@mail.gmail.com>
References: <20161018234248.GB93792@clm-mbp.masoncoding.com>
 <CA+55aFyXi-iUYx6kOnQrCjzGj-uoOa+0voz0HZz7DAFPYK6ctg@mail.gmail.com>
 <332c8e94-a969-093f-1fb4-30d89be8993e@kernel.org> <20161020225028.czodw54tjbiwwv3o@codemonkey.org.uk>
 <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
 <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk> <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
 <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk> <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
 <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com> <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk>
 <CALCETrXoGd3gq=g61q07JDNTSaY7TjDoPQd3F8UgiwDfyJVLug@mail.gmail.com>
 <CA+55aFycKG_7qpSs_pH7ibnOYL9vM85UMGhUFEGC-qpB4qkb5A@mail.gmail.com> <CALCETrVQUuPk4c--21+fY98MFy-0mu7C=FAKfLCjPuarP4vUdg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Oct 2016 17:00:35 -0700
Message-ID: <CA+55aFxYe4ei-X5WATx6ETJh3hGbwKVfeVzDYfQ8E0-C6AhYTw@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 24, 2016 at 3:42 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Here's my theory: I think you're looking at the right code but the
> wrong stack.  shmem_fault_wait is fine, but shmem_fault_waitq looks
> really dicey.

Hmm.

> Consider:
>
> fallocate calls wake_up_all(), which calls autoremove_wait_function().
> That wakes up the shmem_fault thread.  Suppose that the shmem_fault
> thread gets moving really quickly (presumably because it never went to
> sleep in the first place -- suppose it hadn't made it to schedule(),
> so schedule() turns into a no-op).  It calls finish_wait() *before*
> autoremove_wake_function() does the list_del_init().  finish_wait()
> gets to the list_empty_careful() call and it returns true.

All of this happens under inode->i_lock, so the different parts are
serialized. So if this happens before the wakeup, then finish_wait()
will se that the wait-queue entry is not empty (it points to the wait
queue head in shmem_falloc_waitq.

But then it will just remove itself carefully with list_del_init()
under the waitqueue lock, and things are fine.

Yes, it uses the waitiqueue lock on the other stack, but that stack is
still ok since
 (a) we're serialized by inode->i_lock
 (b) this code ran before the fallocate thread catches up and exits.

In other words, your scenario seems to be dependent on those two
threads being able to race. But they both hold inode->i_lock in the
critical region you are talking about.

> Now the fallocate thread catches up and *exits*.  Dave's test makes a
> new thread that reuses the stack (the vmap area or the backing store).
>
> Now the shmem_fault thread continues on its merry way and takes
> q->lock.  But oh crap, q->lock is pointing at some random spot on some
> other thread's stack.  Kaboom!

Note that q->lock should be entirely immaterial, since inode->i_lock
nests outside of it in all uses.

Now, if there is some code that runs *without* the inode->i_lock, then
that would be a big bug.

But I'm not seeing it.

I do agree that some race on some stack data structure could easily be
the cause of these issues. And yes, the vmap code obviously starts
reusing the stack much earlier, and would trigger problems that would
essentially be hidden by the fact that the kernel stack used to stay
around not just until exit(), but until the process was reaped.

I just think that in this case i_lock really looks like it should
serialize things correctly.

Or are you seeing something I'm not?

                   Linus
