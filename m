Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:37585 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab3A1XYx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 18:24:53 -0500
Date: Tue, 29 Jan 2013 00:24:39 +0100
From: Ian Kumlien <pomac@vapor.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add static compile target
Message-ID: <20130128232439.GH15780@pomac.netswarm.net>
References: <1359158987-19921-1-git-send-email-pomac@demius.net>
 <20130128170500.GC16977@twin.jikos.cz>
 <20130128184101.GG15780@pomac.netswarm.net>
 <20130128214651.GH16977@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130128214651.GH16977@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 28, 2013 at 10:46:51PM +0100, David Sterba wrote:
> On Mon, Jan 28, 2013 at 07:41:01PM +0100, Ian Kumlien wrote:
> > > I tried to build 'btrfs' only and moved the static libs definition to
> > > the beginning (still needs the uuid static library though):
> > 
> > Which you haven't included - you sould also include btrfsck at bare
> > minimum ;)
> > 
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -19,6 +19,7 @@ prefix ?= /usr/local
> > > +STATIC_LIBS= -lpthread
> > > +static: CFLAGS += -static
> > > +static: LIBS = $(STATIC_LIBS)
> > 
> > I think you mean += since this will not build since it misses libuuid
> > 
> > If you don't have the libs to do a static build - that is one thing but
> > it should work =)
> 
> Resume: if the distro contains all required libs as static, then your
> patch works.

Yeah... But if it's shipped in a dist i assume they will create static
versions and srip them, just like it seems that other dists does.

> I wanted to get an idea how the static build would go so my patch
> was a dirty workaroud, that did not work in the end anyway.

=) I was a bit confused about it - but you are right, 'btrfs' and
'btrfsck' is the only two we really need to have as static...

> david
