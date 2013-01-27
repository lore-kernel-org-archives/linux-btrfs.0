Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:46892 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab3A0TW5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Jan 2013 14:22:57 -0500
Date: Sun, 27 Jan 2013 20:22:48 +0100
From: Ian Kumlien <pomac@vapor.com>
To: Gene Czarcinski <gene@czarc.net>
Cc: Ian Kumlien <pomac@demius.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add static compile target
Message-ID: <20130127192248.GE15780@pomac.netswarm.net>
References: <1359158987-19921-1-git-send-email-pomac@demius.net>
 <51055FC9.9080602@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51055FC9.9080602@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 27, 2013 at 12:11:37PM -0500, Gene Czarcinski wrote:
> On 01/25/2013 07:09 PM, Ian Kumlien wrote:
> > Sometimes, when you least expect it, a static binary is what you need to
> > rescue your data... Or just get a good enough handle on things to make
> > it work again ;)
> You certainly have a good point.  I took q quick look on Fedora 18 and 
> e2fsprogs has a separate static package but xfsprogs, jfsutils, and 
> reiserfs-utils do not.  On the other hand, those without a separate 
> static package may be only static.
> 
> I guess it depends how much bloat there would be with static only. For 
> e2fsprogs, the static package only contains the static (".a") 
> libraries.  I believe your patch makes all of the binaries static linked.

Yes, 'btrfs' is my main goal

> Is this necessary?  1) Btrfs fixes a lot of stuff on-the fly.  2) If you 
> need to recover "standalone", rescue has btrfs.

I have needed this on several ocations, f.ex. running a ubuntu livecd on
one machine to try to fix something - compiling it on another machine and
then copying it and running it on the affected machine.

In some cases this has been to get a hold of a specific version of
btrfs-progs

> I did a quick check and most of the btrfs binaries are less than 200K 
> bytes whereas the static versions are around 1.2M bytes.  I know that 
> disk space is cheap these days but does this solve a real problem?

Non stripped btrfs here is 2.4 MB, stripped 1.1 MB - this is 64 bit gcc
4.7.2.

My patch adds a compile target to allow you to build static binaries,
it's something i have manually hardcoded in to various btrfs-progs.

> Gene
> >
> > "make static" is a gift to you, dear user with filesystem problems!
> > ---
> >   Makefile | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > diff --git a/Makefile b/Makefile
> > index 4894903..9148d0b 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -117,4 +117,8 @@ install: $(progs) install-man
> >   	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
> >   	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
> >   
> > +static: CFLAGS += -static
> > +static: LIBS += -lpthread
> > +static: all
> > +
> >   -include .*.d
> 
