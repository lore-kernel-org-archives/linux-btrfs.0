Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:34001 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbeGPSNW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 14:13:22 -0400
Received: by mail-pl0-f67.google.com with SMTP id f6-v6so1655344plo.1
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 10:44:54 -0700 (PDT)
Date: Mon, 16 Jul 2018 10:44:52 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH RESEND 2/2] btrfs-progs: make all programs and libraries
 optional
Message-ID: <20180716174452.GA19219@vader>
References: <cover.1531436967.git.osandov@fb.com>
 <116774c27511a8186b837f82053fbeba2a50d75c.1531436967.git.osandov@fb.com>
 <20180716145657.GK3126@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180716145657.GK3126@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 16, 2018 at 04:56:57PM +0200, David Sterba wrote:
> On Thu, Jul 12, 2018 at 04:11:19PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > We have a build system internally which only needs to build the
> > libraries out of a repository, not any binaries. I looked at how this
> > works with other projects, and the best example was util-linux, which
> > makes it possible to enable or disable everything individually. This is
> > nice and really flexible, so let's do the same. This way, if you only
> > want to build and install libbtrfsutil, you can simply do
> > 
> >   ./configure --disable-documentation --disable-all-programs --enable-libbtrfsutil
> >   make
> >   make install
> 
> I think this is an overkill and abusing the --enable-XXX options.  You
> want to avoid building the tools by default, so adding an option for
> that is fine. Selectively building only certain tools can utilize that
> option too and just follow with 'make btrfs-image' etc.

Yeah, it's easy to build stuff selectively, but `make install` will
still try to build everything, that's the part I'm more concerned with.

> The number of --enable-* will stay minimal and we don't even have to
> discuss how to find a good naming scheme (that works for util-linux but
> looks a bit confusing for btrfs-progs).

Ok, I can collapse these into just --disable-programs/--enable-programs,
and --disable-libraries/--enable-libraries? That would be enough for me.
