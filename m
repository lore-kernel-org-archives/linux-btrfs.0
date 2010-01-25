From: Chris Mason <chris.mason@oracle.com>
Subject: Re: severe hardlink bug
Date: Mon, 25 Jan 2010 10:45:04 -0500
Message-ID: <20100125154504.GC331@think>
References: <20100124015138.092c4959@simplux>
 <201001240909.44753.kreijack@libero.it>
 <20100124120432.41bd9b2d.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs@vger.kernel.org, mniederle@gmx.at
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100124120432.41bd9b2d.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 24, 2010 at 12:04:32PM +0100, Stephan von Krawczynski wrote:
> On Sun, 24 Jan 2010 09:09:44 +0100
> Goffredo Baroncelli <kreijack@gmail.com> wrote:
> 
> > On Sunday 24 January 2010, Michael Niederle wrote:
> > > I'm using btrfs with a kernel 2.6.32.2 (builtin) as the root file system of 
> > a
> > > Gentoo Linux installation.
> > > 
> > > While attempting to install the plt-scheme package a strange error about 
> > link
> > > counts occurred ([Error 31] Too many Links).
> > 
> > See this thread:
> > 
> > Mass-Hardlinking Oops - http://thread.gmane.org/gmane.comp.file-
> > systems.btrfs/3427
> > 
> > There is a limit of the number of hardlink for a file. The maximum number of 
> > the link depends by  name length.
> 
> Honestly, this dependency is braindead. How do the fs authors think an
> application programmer should judge how many hardlinks are possible for a
> certain fs ? This is a really bad design issue. Are we really in year 2010 ?

Yes, this was a design trade off to maintain the back links for the
file.  Keep in mind the limit is only per-directory, as long as you're
working between different directories you can have any many back links
as you want.

But, it's on the list to get fixed once raid5/6 are out of the way.

-chris

