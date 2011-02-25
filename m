From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped buffer of the same page
Date: Fri, 25 Feb 2011 14:19:50 -0500
Message-ID: <1298661529-sup-6456@think>
References: <1291887014-18447-1-git-send-email-xin.zhong@intel.com> <201101280354.36884.johannes.hirte@fem.tu-ilmenau.de> <1865303E0DED764181A9D882DEF65FB685DF762B45@shsmsx502.ccr.corp.intel.com> <201102020034.43808.johannes.hirte@fem.tu-ilmenau.de> <1865303E0DED764181A9D882DEF65FB68621CA7167@shsmsx502.ccr.corp.intel.com> <1298028713.11103.13.camel@mainframe> <1865303E0DED764181A9D882DEF65FB686421B24FB@shsmsx502.ccr.corp.intel.com> <1298559118.11224.40.camel@mainframe> <AANLkTimkEGAGjY17FX_EFGwo6RJEoEfQ3WdKhNUymSE+@mail.gmail.com> <1298563230-sup-9619@think> <AANLkTi=gn+713wttLh+iZQqOQXAvkW2bEE7c=rGKurXs@mail.gmail.com> <1298564340-sup-3124@think> <AANLkTi=qUV6TQJbJQ-JAeQ3PFRZpCwAYn4SnbrS89XM9@mail.gmail.com> <AANLkTinvyb-bTVVignd1KGojvh-QrYCFmCnwYKBsYC_2@mail.gmail.com> <AANLkTinrD1vu7NVU
 GCsqvaB6KroeeLPQV3M9QJh0OKUK@mail.gmail.com> <AANLkTik3KtjzP4zVU-foQUxEvZEtrTi7T2aj6PJzUV43@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: =?utf-8?q?Maria_Wikstr=C3=B6m?= <maria@ponstudios.se>,
	"Zhong, Xin" <xin.zhong@intel.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTik3KtjzP4zVU-foQUxEvZEtrTi7T2aj6PJzUV43@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Mitch Harder's message of 2011-02-25 13:43:37 -0500:
> > The loop is more-or-less following this process (from within the
> > "while (iov_iter_count(&i) > 0) {}" loop):
> >
> > (1) Reserve some space with btrfs_delalloc_reserve_space()
> > (2) Prepare the reserved space with prepare_pages()
> > (3) Call btrfs_copy_from_user() to copy to the prepared space.
> > -------------> From btrfs_copy_from_user()
> > (4) ........Try to copy with copied = iov_iter_copy_from_user_atomic()
> > (5) ........The above operation results with copied == 0. Break and
> > return with a return value of 0 bytes copied.
> > (6) There is no special handling for copied == 0 in the "while
> > (iov_iter_count(&i) > 0) {}" loop, so it loops back around, reserves
> > some more space, and tries again.
> >
> > If I look back at how the code was set up before the patch at the head
> > of this thread was applied (Btrfs: pwrite blocked when writing from
> > the mmaped buffer of the same page), the btrfs_copy_from_user()
> > function had some handling for "copied == 0" that would change the
> > scope of the amount to write, and loop back to try the write again.
> >
> > I attempted to construct a patch that just reverted the handling for
> > "copied == 0" in btrfs_copy_from_user(), however, that just resulted
> > in my computer locking up when it reached the point where it was
> > previously beginning to allocate disk space.
> >
> > So, I apologize for not having a patch to address the issue I'm
> > seeing, but I hope I've added some insight.
> >
> 
> Some clarification on my previous message...
> 
> After looking at my ftrace log more closely, I can see where Btrfs is
> trying to release the allocated pages.  However, the calculation for
> the number of dirty_pages is equal to 1 when "copied == 0".
> 
> So I'm seeing at least two problems:
> (1)  It keeps looping when "copied == 0".
> (2)  One dirty page is not being released on every loop even though
> "copied == 0" (at least this problem keeps it from being an infinite
> loop by eventually exhausting reserveable space on the disk).

Very nice, I think you're exactly right.  I should be able to reproduce this
now, thanks!

-chris
