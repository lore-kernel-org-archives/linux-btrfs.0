Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33649 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752186AbcJXVR5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 17:17:57 -0400
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
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Oct 2016 14:17:55 -0700
Message-ID: <CA+55aFyqUvb1BEraMp2LGK7Hm1xwzQzwsWb+KykpZiYSQ5cUEA@mail.gmail.com>
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

On Mon, Oct 24, 2016 at 1:46 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So this is all some really subtle code, but I'm not seeing that it
> would be wrong.

Ahh... Except maybe..

The vmalloc/vfree code itself is a bit scary. In particular, we have a
rather insane model of TLB flushing. We leave the virtual area on a
lazy purge-list, and we delay flushing the TLB and actually freeing
the virtual memory for it so that we can batch things up.

But we've free'd the physical pages that are *mapped* by that area
when we do the vfree(). So there can be stale TLB entries that point
to pages that have gotten re-used. They shouldn't matter, because
nothing should be writing to those pages, but it strikes me that this
may also be hurting the DEBUG_PAGEALLOC thing. Maybe we're not getting
the page fautls that we *should* be getting, and there are hidden
reads and writes to those paghes that already got free'd.\

There was some nasty reason why we did that insane thing. I think it
was just that there are a few high-frequency vmalloc/vfree users and
the TLB flushing was killing some performance.

But it does strike me that we are playing very fast and loose with the
TLB on the vmalloc area.

So maybe all the new VMAP code is fine, and it's really vmalloc/vfree
that has been subtly broken but nobody has ever cared before?

              Linus
