Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:48071 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab2JHOdx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 10:33:53 -0400
Date: Mon, 8 Oct 2012 10:33:51 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Christian Hesse <list@eworm.de>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: fix btrfs-progs build
Message-ID: <20121008143351.GD4132@shiny>
References: <20121008161713.218a6eb1@leda>
 <20121008142908.GC4132@shiny>
 <20121008163031.4656b6ff@leda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20121008163031.4656b6ff@leda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 08, 2012 at 08:30:31AM -0600, Christian Hesse wrote:
> Chris Mason <chris.mason@fusionio.com> on Mon, 2012/10/08 10:29:
> > On Mon, Oct 08, 2012 at 08:17:13AM -0600, Christian Hesse wrote:
> > > Hello everybody,
> > > 
> > > man pages for btrfs-progs are compressed by gzip by default. In Makefile
> > > the variable GZIP is use, this evaluates to 'gzip gzip' on my system.
> > > From man gzip:
> > > 
> > > > The environment variable GZIP can hold a set of default options for
> > > > gzip. These options are interpreted first and can be overwritten by
> > > > explicit command line parameters.
> > > 
> > > So using any other variable name fixes this. Patch is attached.
> > 
> > Ok, which system is this?  Just curious, I'll pull in the patch.
> 
> This is Arch Linux with gzip 1.5-1.

Strange, I'm running running arch linux with gzip 1.5-1 and it builds.
I wonder if something else is expanding it.  I'll take the patch
regardless, there's no reason to add build problems when we don't need
to.

-chris

