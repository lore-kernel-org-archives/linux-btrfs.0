Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759869Ab3BLOSD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 09:18:03 -0500
Date: Tue, 12 Feb 2013 15:18:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Ian Kumlien <pomac@demius.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: -U_FORTIFY_SOURCE before -D
Message-ID: <20130212141801.GX12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
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
> 
> Current workaround is to pass AM_CFLAGS to make:
>     make AM_CFLAGS=stuff_w/o_fortify_source
> It's what gentoo's live ebuild does.

The fortify flag was added without a special reason, it's good to have
it. I'm ok with adding the forced undefine to keep the build quiet and
working as specified in the Makefile.

david
