Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41506 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730780AbeGQMMp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 08:12:45 -0400
Date: Tue, 17 Jul 2018 13:40:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH RESEND 2/2] btrfs-progs: make all programs and libraries
 optional
Message-ID: <20180717114024.GU3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1531436967.git.osandov@fb.com>
 <116774c27511a8186b837f82053fbeba2a50d75c.1531436967.git.osandov@fb.com>
 <20180716145657.GK3126@twin.jikos.cz>
 <20180716174452.GA19219@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180716174452.GA19219@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 16, 2018 at 10:44:52AM -0700, Omar Sandoval wrote:
> On Mon, Jul 16, 2018 at 04:56:57PM +0200, David Sterba wrote:
> > On Thu, Jul 12, 2018 at 04:11:19PM -0700, Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > > 
> > > We have a build system internally which only needs to build the
> > > libraries out of a repository, not any binaries. I looked at how this
> > > works with other projects, and the best example was util-linux, which
> > > makes it possible to enable or disable everything individually. This is
> > > nice and really flexible, so let's do the same. This way, if you only
> > > want to build and install libbtrfsutil, you can simply do
> > > 
> > >   ./configure --disable-documentation --disable-all-programs --enable-libbtrfsutil
> > >   make
> > >   make install
> > 
> > I think this is an overkill and abusing the --enable-XXX options.  You
> > want to avoid building the tools by default, so adding an option for
> > that is fine. Selectively building only certain tools can utilize that
> > option too and just follow with 'make btrfs-image' etc.
> 
> Yeah, it's easy to build stuff selectively, but `make install` will
> still try to build everything, that's the part I'm more concerned with.

Oh right, installation. What if it installs just the binaries that are
built? The default actions done by configure & make & make install would
not change, but there could be configure --disable-all, then selectively
make and final make install would be 

for p in $(progs_install); if test -f $p && $(INSTALL) ...; fi

> > The number of --enable-* will stay minimal and we don't even have to
> > discuss how to find a good naming scheme (that works for util-linux but
> > looks a bit confusing for btrfs-progs).
> 
> Ok, I can collapse these into just --disable-programs/--enable-programs,
> and --disable-libraries/--enable-libraries? That would be enough for me.

Sounds ok.
