Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:45192 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760833Ab3BIWdn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Feb 2013 17:33:43 -0500
Date: Sat, 9 Feb 2013 23:33:41 +0100
From: Ian Kumlien <pomac@vapor.com>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Ian Kumlien <pomac@demius.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: -U_FORTIFY_SOURCE before -D
Message-ID: <20130209223341.GT15780@pomac.netswarm.net>
References: <1360366221-22703-1-git-send-email-pomac@demius.net>
 <20130209210206.66e2b886@sf>
 <20130209185720.GR15780@pomac.netswarm.net>
 <20130210010626.487a8044@sf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130210010626.487a8044@sf>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 10, 2013 at 01:06:26AM +0300, Sergei Trofimovich wrote:
> On Sat, 9 Feb 2013 19:57:20 +0100
> Ian Kumlien <pomac@vapor.com> wrote:
> 
> > On Sat, Feb 09, 2013 at 09:02:06PM +0300, Sergei Trofimovich wrote:
> > > On Sat,  9 Feb 2013 00:30:21 +0100
> > > Ian Kumlien <pomac@demius.net> wrote:
> > > 
> > > > My builds are cluttered with:
> > > > <command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by
> > > > default]
> > > > 
> > > > Which makes it hard to tell if something breaks or not.
> > > 
> > > > I don't know about you, but bilding with 
> > > > GCC 4.7.2 on gentoo, this is a issue.
> > > 
> > > Unfortunately it's a gentoo specific gcc bug. I'd suggest reporting
> > > it to bugs.gentoo.org. That -D by default breaks linux's perf as well
> > > (due to -D_FOTIFY_SOURCE=2 -Werror in perf sources).
> > 
> > Is it? There is a workaround in the android build system for compilers
> > on ubuntu.
> > 
> > Where can i find that bug report?
> 
> I think you need to fill the new one.
> 
> > This is not a emerge, this is a normal system build.
> 
> Yeah, gentoo has patched gcc specs so you get -D_FORTIFY_SOURCE=2
> in gcc command line by default.
> 
> http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo/src/patchsets/gcc/4.6.0/gentoo/10_all_default-fortify-source.patch?view=markup

Actually they don't patch the specs they patch the source.

If they'd patched the specs i would have found it, i actually checked
gcc -dumpspecs

Again, is there any harm in adding this patch? Apparently other distors
has done the same...

> > > Current workaround is to pass AM_CFLAGS to make:
> > >     make AM_CFLAGS=stuff_w/o_fortify_source
> > > It's what gentoo's live ebuild does.
> > 
> > I can't see it here in the live ebuild... 
> 
> sys-fs/btrfs-progs/btrfs-progs-9999.ebuild:
> ...
> src_compile() {
>         emake \
>                 CC="$(tc-getCC)" \
>                 AM_CFLAGS=-D_FILE_OFFSET_BITS=64 \
>                 ...
> }
> 
> This line overrides in-Makefiles AM_CFLAGS.

Must have changed recently... Was it changed on the 4:th, 5 days ago?

> -- 
> 
>   Sergei


