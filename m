From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: severe hardlink bug
Date: Sun, 24 Jan 2010 12:04:32 +0100
Message-ID: <20100124120432.41bd9b2d.skraw@ithnet.com>
References: <20100124015138.092c4959@simplux>
	<201001240909.44753.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org, mniederle@gmx.at
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001240909.44753.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 24 Jan 2010 09:09:44 +0100
Goffredo Baroncelli <kreijack@gmail.com> wrote:

> On Sunday 24 January 2010, Michael Niederle wrote:
> > I'm using btrfs with a kernel 2.6.32.2 (builtin) as the root file system of 
> a
> > Gentoo Linux installation.
> > 
> > While attempting to install the plt-scheme package a strange error about 
> link
> > counts occurred ([Error 31] Too many Links).
> 
> See this thread:
> 
> Mass-Hardlinking Oops - http://thread.gmane.org/gmane.comp.file-
> systems.btrfs/3427
> 
> There is a limit of the number of hardlink for a file. The maximum number of 
> the link depends by  name length.

Honestly, this dependency is braindead. How do the fs authors think an
application programmer should judge how many hardlinks are possible for a
certain fs ? This is a really bad design issue. Are we really in year 2010 ?

> BR
> Goffredo

-- 
Regards,
Stephan

