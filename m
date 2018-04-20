Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:36117 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754549AbeDTLhz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 07:37:55 -0400
Received: by mail-ua0-f172.google.com with SMTP id v4so5495162uaj.3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 04:37:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180419214136.GA22356@hungrycats.org>
References: <CA+EzBbDv8GKKgSVwAYwQAn5Q3-MMz2BLUeFcjn3uv6eNBKvs5g@mail.gmail.com>
 <20180419214136.GA22356@hungrycats.org>
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Fri, 20 Apr 2018 06:37:53 -0500
Message-ID: <CA+EzBbCwMx=mrPyi6xROuf2pz_RfDgX8CGuWuX3nfw4yu_+zLA@mail.gmail.com>
Subject: Re: Hard link not persisted on fsync
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Zygo,

Thanks for the reply. Here are few responses about btrfs behavior that
you had questions about in your email.

On Thu, Apr 19, 2018 at 4:41 PM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
>
> On Mon, Apr 16, 2018 at 09:35:24AM -0500, Jayashree Mohan wrote:
> > Hi,
> >
> > The following seems to be a crash consistency bug on btrfs, where in
> > the link count is not persisted even after a fsync on the original
> > file.
> >
> > Consider the following workload :
> > creat foo
> > link (foo, A/bar)
> > fsync(foo)
> > ---Crash---
> >
> > Now, on recovery we expect the metadata of foo to be persisted i.e
> > have a link count of 2. However in btrfs, the link count is 1 and file
> > A/bar is not persisted. The expected behaviour would be to persist the
> > dependencies of inode foo. That is to say, shouldn't fsync of foo
> > persist A/bar and correctly update the link count?
>
> Those dependencies are backward.  foo's inode doesn't depend on anything
> but the data in the file foo, and foo's inode itself.
>
> "foo" and "A/bar" are dirents that both depend on the inode of foo, which
> implies that "A" and "." must be updated atomically with foo's inode.
> If you had called fsync(A) then we'd expect A/bar to exist and the inode
> to have a link count of 2.  If you'd called fsync(.) then...well, you
> didn't modify "." at all, so I guess either outcome is valid as long as
> the inode link count matches the number of dirents referencing the inode.
>
> But then...why does foo exist at all?  I'd expect at least some tests
> would end without foo on disk either, since all that was fsync()ed was the
> foo inode, not the foo dirent in the directory '.'.  Does btrfs combine
> creating foo and updating foo's inode into a single atomic operation?
> I vaguely recall that it does exactly that, in order to solve a bug
> some years ago.  What happens if you add a rename, e.g.
>
>         unlink foo2     # make sure foo2 doesn't exist
>         creat foo
>         rename(foo, foo2)
>         link(foo2, A/bar)
>         fsync(foo2)
>
> Do you get foo or foo2?  I'd expect foo since you didn't fsync '.',
> but maybe rename implies flush and you get foo2.

This is the workload we tried:

creat foo
rename(foo, foo2)
mkdir A
link(foo2, A/bar)
fsync(foo2)

Btrfs persists foo2 here, and A/bar is not persisted. Also, the link
count of foo2 is 1, while on the other filesystems, A/bar persist as
well and foo2 has a link count 2.
I don't think it's the rename here that implies the flush - removing
the fsync(foo2) ends up not persisting A/bar. So looks like, its the
fsync that forces all dependencies to the disk.

As a variant of the above workload, consider the following:

mkdir A
sync
creat foo
rename(foo, foo2)
link(foo2, A/bar)
fsync(foo2)

The only difference between this workload and the one above is, where
directory A is created and whether its persisted previously or not. In
this modified workload, foo2 has a link count of 2 and ends up
persisting A/bar. Why is A/bar being persisted here even when we did
not explicitly call a fsync on directory A?

We don't seem to correctly understand the reason behind these
different behaviors. It will be useful if you could provide more
insight into this.

> That's not to say that fsync is not a rich source of filesystem bugs.
> btrfs did once have (and maybe still has?) a bug where renames and fsync
> can create a dirent with no inode, e.g.
>
>         loop continuously:
>                 creat foo
>                 write(foo, data)
>                 fsync(foo)
>                 rename(foo, bar)
>
> and crash somewhere in the middle of the loop, which will create a
> dirent "foo" that points to a non-existent inode.
>
> Removing the "fsync" works around the bug.  rename() does a flush anyway,
> so the fsync() wasn't needed, but fsync() shouldn't _create_ a filesystem
> inconsistency, especially when Googling recommends app developers to
> sprinkle fsync()s indiscriminately in their code to prevent their data
> from being mangled.
>
> I haven't been tracking to see if that's fixed yet.  I last saw it on
> 4.11, but I have been aggressively avoiding fsync with eatmydata for
> some years now.
>
> > Note that ext4, xfs and f2fs recover to the correct link count of 2
> > for the above workload.
>
> Do those filesystems also work if you remove the fsync?  That may be
> your answer:  they could be flushing the other metadata earlier, before
> you call fsync().

>> creat foo
>> link (foo, A/bar)
> >fsync(foo)
>>---Crash---

Actually, they don't seem to work if we remove the fsync. The behavior
changes and we neither persist A/bar nor update the link count of foo
to 2. So this confirms that fsync is forcing the metadata and not the
link() syscall itself right?

Thanks,
Jayashree
