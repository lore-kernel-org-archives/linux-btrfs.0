Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37575 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaEGIwu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 04:52:50 -0400
Date: Wed, 7 May 2014 01:52:40 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: raid0 vs single, and should we allow -mdup by default on SSDs?
Message-ID: <20140507085240.GN10159@merlins.org>
References: <pan$43f87$1b04f612$26876f7$5d505a6d@cox.net>
 <pan$31100$5edd829$14fe1b2f$4e1f4bd7@cox.net>
 <pan$a6ac4$b6e79aa$56ddd950$5b7b75c2@cox.net>
 <20140507081840.GM10159@merlins.org>
 <20140507082941.GA19199@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140507082941.GA19199@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 07, 2014 at 09:29:41AM +0100, Hugo Mills wrote:
> On Wed, May 07, 2014 at 01:18:40AM -0700, Marc MERLIN wrote:
> > On Tue, May 06, 2014 at 07:39:12PM +0000, Duncan wrote:
> > > That appears to be a very good use of either -d raid0 or -d single, yes.  
> > > And since you're apparently not streaming such high resolution video that 
> > > you NEED the raid0, single does indeed give you a somewhat better chance 
> > > at recovery.
> >  
> > zoneminder saves 'video' as a stream of independent small jpegs, so I'm
> > good. Actually come to think of it they're so small that they probably
> > all ended up in the raid1 metadata. That also means that I'm not getting
> > twice the storage space like I planned to. Oh well...
> 
>    There's a mount option to change the threshold at which files are
> inlined in metadata: maxinline=<bytes>. You could play with that for
> this particular use-case.

Oh cool, thank you.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
