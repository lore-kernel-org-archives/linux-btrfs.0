Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:48614 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaCVXVX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 19:21:23 -0400
Received: by mail-ob0-f179.google.com with SMTP id va2so4137051obc.24
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Mar 2014 16:21:22 -0700 (PDT)
MIME-Version: 1.0
From: Jon Nelson <jnelson@jamponi.net>
Date: Sat, 22 Mar 2014 18:21:02 -0500
Message-ID: <CAKuK5J05tCf55T1X_ENNdP4oXCiODXSR48coQ0rgkihcb9EUSw@mail.gmail.com>
Subject: Re: fresh btrfs filesystem, out of disk space, hundreds of gigs free
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:

>
> Jon Nelson posted on Fri, 21 Mar 2014 19:00:51 -0500 as excerpted:
>
> > Using openSUSE 13.1 on x86_64 which - as of this writing - is 3.11.10,
> > Would a more recent kernel than 3.11 have done me any good?
>
> [Reordered the kernel question from below to here, where you reported the
> running version.]
>
> As both mkfs.btrfs and the wiki recommend, always use the latest kernel.
> In fact, the kernel config's btrfs option had a pretty strong warning thru
> 3.12 that was only toned down in 3.13 as well, so I'd definitely
> recommend at least the latest 3.13.x stable series kernel in any case.

I would like to say that your response is one of the most useful and
detailed responsed I've ever received on a mailing list. Thank you!

The "please run the very latest kernel/userland" is sort of true for
everything, though. Also, I am of the understanding that the openSUSE folks
back-port *some* of the btrfs-relevant bits to both the kernel and the
userspace tools, but I could be wrong, too.

> > I tried to copy a bunch of files over to a btrfs filesystem (which was
> > mounted as /, in fact).
> >
> > After some time, things ground to a halt and I got out of disk space
> > errors. btrfs fi df /   showed about 1TB of *data* free, and 500MB
> > of metadata free.
>
> It's the metadata, plus no space left to allocate more.  See below.

Right. Although I did a poor job of noting it, I understood at least that much.

> > Below are the btrfs fi df /  and  btrfs fi show.
> >
> >
> > turnip:~ # btrfs fi df /
> > Data, single: total=1.80TiB, used=832.22GiB
> > System, DUP: total=8.00MiB, used=204.00KiB
> > System, single: total=4.00MiB, used=0.00
> > Metadata, DUP: total=5.50GiB, used=5.00GiB
> > Metadata, single: total=8.00MiB, used=0.00
>
> FWIW, the system and metadata single chunks reported there are an
> artifact from mkfs.btrfs and aren't used (used=0.00).  At some point it
> should be updated to remove them automatically, but meanwhile, a balance
> should remove them from the listing.  If you do that balance immediately
> after filesystem creation, at the first mount, you'll be rid of them when
> there's not a whole lot of other data on the filesystem to balance as
> well.  That would leave:
>
> > Data, single: total=1.80TiB, used=832.22GiB
> > System, DUP: total=8.00MiB, used=204.00KiB
> > Metadata, DUP: total=5.50GiB, used=5.00GiB
>
> Metadata is the red-flag here.  Metadata chunks are 256 MiB in size, but
> in default DUP mode, two are allocated at once, thus 512 MiB at a time.
> And you're under 512 MiB free so you're running on the last pair of
> metadata chunks, which means depending on the operation, you may need to
> allocate metadata pretty quickly.  You can probably copy a few files
> before that, but a big copy operation with many files at a time would
> likely need to allocate more metadata.

The size of the chunks allocated is especially useful information. I've not
seen that anywhere else, and does explain a fair bit.

> But for a complete picture you need the filesystem show output, below, as
> well...
>
> > turnip:~ # btrfs fi show
> > Label: none  uuid: 9379c138-b309-4556-8835-0f156b863d29
> >         Total devices 1 FS bytes used 837.22GiB
> >         devid    1 size 1.81TiB used 1.81TiB path /dev/sda3
> >
> > Btrfs v3.12+20131125
>
> OK.  Here we see the root problem.  Size 1.81 TiB, used 1.81 TiB.  No
> unallocated space at all.  Whichever runs out of space first, data or
> metadata, you'll be stuck.

Now it's at this point that I am unclear. I thought the above said:
"1 device on this filesystem, 837.22 GiB used."
and
"device ID #1 is /dev/sda3, is 1.81TiB in size, and btrfs is using 1.81TiB
of that"

Which I interpret differently. Can you go into more detail as to how (from
btrfs fi show) we can say "the _filesystem_ (not the device) is full"?

> And as was discussed above, you're going to need another pair of metadata
> chunks allocated pretty quickly, but there's no unallocated space
> available to allocate to them, so no surprise at all you got free-space
> errors! =:^(
>
> Conversely, you have all sorts of free data space.  Data space is
> allocated in gig-size chunks, and you have nearly a TiB of free data-
> space, which means there's quite a few nearly empty data chunks available.

> To correct that imbalance and free the extra data space to the pool so
> more metadata can be allocated, you run a balance.

In fact, I did try a balance - both a data-only and a metadata-only balance.
 The metadata-only balance failed. I cancelled the data-only balance early,
although perhaps I should have been more patient. I went from a running
system to working from a rescue environment -- I was under a bit of time
pressure to get things moving again.

> Here, you probably want a balance of the data only, since it's what's
> unbalanced, and on slow spinning rust (as opposed to fast SSD) rewriting
> /everything/, as balance does by default, will take some time.  To do
> data only, use the -d option:
>
> # btrfs balance start -d /
>
> (You said it was mounted on root, so that's what I used.)

I'm going to remove a bunch of (great!) quoted stuff here that, while
useful, won't be relevant to my reply.

> Meanwhile, I strongly urge you to read up on the btrfs wiki.  The
> following is easy to remember and bookmark:

I read the wiki and related pages many times, but there is a lot of info
there and I must have skipped over the "if your device is large" section.

To be honest, it seems like a lot of hoop-jumping and a maintenance burden
for the administrator. Not being able to draw from "free space pool" for
either data or metadata seems like a big bummer. I'm hoping that such a
limitation will be resolved at some near-term future point.

Otherwise, I think it's a problem to suggest that btrfs will require
administrators to keep an eye on data /and/ metadata free space (using
btrfs-specific tools) *and* that they might need to run processes which
shuffle data about in the hopes that such actions might arrange things more
optimally.

I've been very excited to reap the very real benefits of btrfs but it seems
like the also real downsides continue to negatively impact it's operation.

Thanks again for your truly excellent response. I'm a big fan of the design
and featureset provided by btrfs, but some of these rough edges hurt a bit
more when they've bit me more than once.


-- 
Jon
Software Blacksmith
