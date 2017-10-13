Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59621 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753040AbdJNQsn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Oct 2017 12:48:43 -0400
Date: Fri, 13 Oct 2017 20:10:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Naohiro Aota <naota@elisp.net>
Cc: David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: set include path relatively
Message-ID: <20171013181012.GF3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171012022224.28376-1-naota@elisp.net>
 <20171012123809.GF3521@twin.jikos.cz>
 <CAEe67=-YoRnbBAQt=d49W0rBVDw+znTXB1Vu6rAcdNSVr+mCaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEe67=-YoRnbBAQt=d49W0rBVDw+znTXB1Vu6rAcdNSVr+mCaQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 13, 2017 at 04:01:31PM +0900, Naohiro Aota wrote:
> 2017-10-12 21:38 GMT+09:00 David Sterba <dsterba@suse.cz>:
> > On Thu, Oct 12, 2017 at 11:22:24AM +0900, Naohiro Aota wrote:
> >> Currently, gcc is passed the include directory with full path. As a result,
> >> dependency files (*.o.d) also record the full path at the build time. Such
> >> full path dependency is annoying for sharing the source between multiple
> >> machines, containers, or anything the path differ.
> >>
> >> And this is the same way what other program using autotools e.g. e2fsprogs
> >> is doing:
> >>
> >> $ grep top_builddir Makefile
> >> top_builddir = .
> >> CPPFLAGS = -I. -I$(top_builddir)/lib -I$(top_srcdir)/lib
> >> BUILD_CFLAGS = -g -O2  -I. -I$(top_builddir)/lib -I$(top_srcdir)/lib -DHAVE_CONFIG_H
> >> <snip>
> >
> > Makes sense for the header files. TOPDIR is also used for linking, can
> > it cause similar problems, where the library search path is set as -L$(TOPDIR) ?
> 
> Since both "TOPDIR := $(shell pwd)" and -L$(TOPDIR) is evaluated at
> the build time,
> it never cause problem on linking itself. What the problem with
> dependency files is persisting
> the full path into the dep files. We generate the dep files only for
> objects (%.o.d rule)
> 
> Well, it's ok to use "-L." here, and it's the same way with autotools does.
> 
> > I wonder if we should do the same as in the example above and set
> > default value of TOPDIR to '.', instead of `pwd`.
> 
> TOPDIR is also used by library-test{,.static}. They run gcc in a
> temporary directory.
> Thus, TOPDIR here should be absolute.

I've added another variable with absolute path to make library-test work
and updated your patch so we can use TOPDIR = .
