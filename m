Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:56958 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab3BMDfd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 22:35:33 -0500
Received: by mail-la0-f48.google.com with SMTP id fq13so739622lab.21
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 19:35:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130212231526.GE12339@twin.jikos.cz>
References: <20130212231526.GE12339@twin.jikos.cz>
Date: Tue, 12 Feb 2013 19:35:31 -0800
Message-ID: <CADU+-uC64KQPys9K3yC3PG11LLCqQtSsRYDAPvKzcwsCn6MoVQ@mail.gmail.com>
Subject: Re: Integration branch of btrfs-progs 2013-02
From: Filipe Brandenburger <filbranden@google.com>
To: dsterba@suse.cz
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

I really have concerns about the libification, in particular this commit:

6fc8b21 btrfs-progs: libify some parts of btrfs-progs

The relevant snippets that concern me below:

+libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
+              crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
+              extent_io.h ioctl.h ctree.h
...
+headers = $(libbtrfs_headers)
...
+       $(INSTALL) -m644 $(headers) $(DESTDIR)$(incdir)


I really don't think that all those headers should be exposed to the userspace.

I think, to do it right, there should be a single or a few header
files, like /usr/include/btrfs.h or /usr/include/libbtrfs.h or
/usr/include/btrfs/xyz.h, that export only the parts that are really
necessary for an application that wants to use libbtrfs. Does it
really make sense to have btrfs-progs expose things like ctree.h or
crc32c.h or even list.h to userspace?!

Another reason of my concerns is that I've been trying to work on
exporting the equivalent of ioctl.h, with the constants and structs
needed to call btrfs-specific ioctls, from the kernel side, I already
submitted a patch to export it from a Linux kernel build as
/usr/include/linux/btrfs.h. I believe that's the right way to export
that particular information.

The other part of it is synchronizing the header files (and to some
extent some source files, like ctree.c) between the kernel and
btrfs-progs. The current version of those headers (and C source files)
in btrfs-progs was a copy of the same files from the kernel tree that
was edited to compile in userspace and then diverged from the copy of
the same files in the kernel. We should try to unify those (I sent
another patch with a suggestion of a script that would update those
from the kernel git tree.) Exposing those to userspace now would only
muddle that situation more.

If you think you can build a new header file that is clean and contain
only the prototypes and constants and structs that are strictly
required to export functions in a libbtrfs, then I'd fully support
this patchset. If it's going to export all the header files as it's
doing now, then I wouldn't...

Thanks,
Filipe
