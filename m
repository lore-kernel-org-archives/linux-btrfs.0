Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:56414 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab3A1SlP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 13:41:15 -0500
Date: Mon, 28 Jan 2013 19:41:01 +0100
From: Ian Kumlien <pomac@vapor.com>
To: David Sterba <dsterba@suse.cz>
Cc: Ian Kumlien <pomac@demius.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add static compile target
Message-ID: <20130128184101.GG15780@pomac.netswarm.net>
References: <1359158987-19921-1-git-send-email-pomac@demius.net>
 <20130128170500.GC16977@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130128170500.GC16977@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 28, 2013 at 06:05:00PM +0100, David Sterba wrote:
> On Sat, Jan 26, 2013 at 01:09:47AM +0100, Ian Kumlien wrote:
> > Sometimes, when you least expect it, a static binary is what you need to
> > rescue your data... Or just get a good enough handle on things to make
> > it work again ;)
> > 
> > "make static" is a gift to you, dear user with filesystem problems!
> 
> Adding the build target does not cost us anything. The result depends on the
> distro and set of the needed libraries provided for a static build. Even
> the basic 'btrfs' too needs uuid (due to cmds-receive) and I don't have
> it in my distro. The other utilities may need static zlib or lzo
> (restore) or libblkid (mkfs.btrfs).

Yes, this is all part of the static package... 

> I tried to build 'btrfs' only and moved the static libs definition to
> the beginning (still needs the uuid static library though):

Which you haven't included - you sould also include btrfsck at bare
minimum ;)

> --- a/Makefile
> +++ b/Makefile
> @@ -19,6 +19,7 @@ prefix ?= /usr/local
>  bindir = $(prefix)/bin
>  LIBS=-luuid -lm
>  RESTORE_LIBS=-lz
> +STATIC_LIBS= -lpthread
> 
>  progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
>         btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
> @@ -117,4 +118,9 @@ install: $(progs) install-man
>         $(INSTALL) -m755 -d $(DESTDIR)$(bindir)
>         $(INSTALL) $(progs) $(DESTDIR)$(bindir)
> 
> +static: CFLAGS += -static
> +static: LIBS = $(STATIC_LIBS)

I think you mean += since this will not build since it misses libuuid

If you don't have the libs to do a static build - that is one thing but
it should work =)

> +static: version btrfs
