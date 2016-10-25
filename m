Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:40643 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758033AbcJYBJr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 21:09:47 -0400
Received: by mail-ua0-f180.google.com with SMTP id u14so7612461uau.7
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Oct 2016 18:09:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+55aFxYe4ei-X5WATx6ETJh3hGbwKVfeVzDYfQ8E0-C6AhYTw@mail.gmail.com>
References: <20161018234248.GB93792@clm-mbp.masoncoding.com>
 <CA+55aFyXi-iUYx6kOnQrCjzGj-uoOa+0voz0HZz7DAFPYK6ctg@mail.gmail.com>
 <332c8e94-a969-093f-1fb4-30d89be8993e@kernel.org> <20161020225028.czodw54tjbiwwv3o@codemonkey.org.uk>
 <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
 <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk> <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
 <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk> <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
 <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com> <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk>
 <CALCETrXoGd3gq=g61q07JDNTSaY7TjDoPQd3F8UgiwDfyJVLug@mail.gmail.com>
 <CA+55aFycKG_7qpSs_pH7ibnOYL9vM85UMGhUFEGC-qpB4qkb5A@mail.gmail.com>
 <CALCETrVQUuPk4c--21+fY98MFy-0mu7C=FAKfLCjPuarP4vUdg@mail.gmail.com> <CA+55aFxYe4ei-X5WATx6ETJh3hGbwKVfeVzDYfQ8E0-C6AhYTw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 24 Oct 2016 18:09:24 -0700
Message-ID: <CALCETrVpxnRvOZ5=bHU99GOYdVgottczZ0sHgYh3nqzA4Y4+_g@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Sterba <dsterba@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@fb.com>,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Oct 24, 2016 5:00 PM, "Linus Torvalds" <torvalds@linux-foundation.org> wrote:
>
> On Mon, Oct 24, 2016 at 3:42 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> > Now the fallocate thread catches up and *exits*.  Dave's test makes a
> > new thread that reuses the stack (the vmap area or the backing store).
> >
> > Now the shmem_fault thread continues on its merry way and takes
> > q->lock.  But oh crap, q->lock is pointing at some random spot on some
> > other thread's stack.  Kaboom!
>
> Note that q->lock should be entirely immaterial, since inode->i_lock
> nests outside of it in all uses.
>
> Now, if there is some code that runs *without* the inode->i_lock, then
> that would be a big bug.
>
> But I'm not seeing it.
>
> I do agree that some race on some stack data structure could easily be
> the cause of these issues. And yes, the vmap code obviously starts
> reusing the stack much earlier, and would trigger problems that would
> essentially be hidden by the fact that the kernel stack used to stay
> around not just until exit(), but until the process was reaped.
>
> I just think that in this case i_lock really looks like it should
> serialize things correctly.
>
> Or are you seeing something I'm not?

No, I missed that.

--Andy
