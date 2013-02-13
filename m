Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934065Ab3BMVLN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 16:11:13 -0500
Date: Wed, 13 Feb 2013 13:11:12 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: Filipe Brandenburger <filbranden@google.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Integration branch of btrfs-progs 2013-02
Message-ID: <20130213211112.GA31017@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20130212231526.GE12339@twin.jikos.cz> <CADU+-uC64KQPys9K3yC3PG11LLCqQtSsRYDAPvKzcwsCn6MoVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADU+-uC64KQPys9K3yC3PG11LLCqQtSsRYDAPvKzcwsCn6MoVQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 12, 2013 at 07:35:31PM -0800, Filipe Brandenburger wrote:
> Hi David,
> 
> I really have concerns about the libification, in particular this commit:
> 
> 6fc8b21 btrfs-progs: libify some parts of btrfs-progs
> 
> The relevant snippets that concern me below:
> 
> +libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
> +              crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
> +              extent_io.h ioctl.h ctree.h
> ...
> +headers = $(libbtrfs_headers)
> ...
> +       $(INSTALL) -m644 $(headers) $(DESTDIR)$(incdir)
> 
> 
> I really don't think that all those headers should be exposed to the userspace.
> 
> I think, to do it right, there should be a single or a few header
> files, like /usr/include/btrfs.h or /usr/include/libbtrfs.h or
> /usr/include/btrfs/xyz.h, that export only the parts that are really
> necessary for an application that wants to use libbtrfs. Does it
> really make sense to have btrfs-progs expose things like ctree.h or
> crc32c.h or even list.h to userspace?!

It's worked in ocfs2-tools for years now. In fact on my system here I
counted 6 other packages which expose some version of it which they took
initially from the kernel. There's nothing inherently "kernely" about a lot
of that stuff and it's stable code which has worked well for years. The same
goes for the crc32 functions. Btrfs-progs needs that code to function.
Anything linking against libbtrfs will need that too.


> Another reason of my concerns is that I've been trying to work on
> exporting the equivalent of ioctl.h, with the constants and structs
> needed to call btrfs-specific ioctls, from the kernel side, I already
> submitted a patch to export it from a Linux kernel build as
> /usr/include/linux/btrfs.h. I believe that's the right way to export
> that particular information.

I don't disagree with this goal, in fact I quite like it. Can you point us
to your work?


> The other part of it is synchronizing the header files (and to some
> extent some source files, like ctree.c) between the kernel and
> btrfs-progs. The current version of those headers (and C source files)
> in btrfs-progs was a copy of the same files from the kernel tree that
> was edited to compile in userspace and then diverged from the copy of
> the same files in the kernel. We should try to unify those (I sent
> another patch with a suggestion of a script that would update those
> from the kernel git tree.) Exposing those to userspace now would only
> muddle that situation more.
> 
> If you think you can build a new header file that is clean and contain
> only the prototypes and constants and structs that are strictly
> required to export functions in a libbtrfs, then I'd fully support
> this patchset. If it's going to export all the header files as it's
> doing now, then I wouldn't...

It's impractical to expect us to hide that data when there is no official
distribution of /usr/include/linux/btrfs.h and there are applications which
want to be developed against this. In fact there's really no point of having
the library if we don't expose interfaces (including necessary structure
definitions).

If you look at the patch series that I posted, you'll notice that while I
actually did some of the initial grunt work, there are patches from several
people who were interested that the library work a certain way and I
included their patches.

What about porting some of your work over to libbtrfs? That way we could get
the nicely unified header files in both places.

Btw, it's also trivial to add a configure check for /usr/include/linux/btrfs.h
if different behavior on install is required. We could even add that now (if
you have an idea of what would change) despite your patch not being upstream.
	--Mark

--
Mark Fasheh
