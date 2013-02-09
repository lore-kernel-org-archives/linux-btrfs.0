Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:39029 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760819Ab3BIS5V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Feb 2013 13:57:21 -0500
Date: Sat, 9 Feb 2013 19:57:20 +0100
From: Ian Kumlien <pomac@vapor.com>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Ian Kumlien <pomac@demius.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: -U_FORTIFY_SOURCE before -D
Message-ID: <20130209185720.GR15780@pomac.netswarm.net>
References: <1360366221-22703-1-git-send-email-pomac@demius.net>
 <20130209210206.66e2b886@sf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130209210206.66e2b886@sf>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 09, 2013 at 09:02:06PM +0300, Sergei Trofimovich wrote:
> On Sat,  9 Feb 2013 00:30:21 +0100
> Ian Kumlien <pomac@demius.net> wrote:
> 
> > My builds are cluttered with:
> > <command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by
> > default]
> > 
> > Which makes it hard to tell if something breaks or not.
> 
> > I don't know about you, but bilding with 
> > GCC 4.7.2 on gentoo, this is a issue.
> 
> Unfortunately it's a gentoo specific gcc bug. I'd suggest reporting
> it to bugs.gentoo.org. That -D by default breaks linux's perf as well
> (due to -D_FOTIFY_SOURCE=2 -Werror in perf sources).

Is it? There is a workaround in the android build system for compilers
on ubuntu.

Where can i find that bug report?

This is not a emerge, this is a normal system build.

> Current workaround is to pass AM_CFLAGS to make:
>     make AM_CFLAGS=stuff_w/o_fortify_source
> It's what gentoo's live ebuild does.

I can't see it here in the live ebuild... 

> -- 
> 
>   Sergei


