Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36459 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932554AbdKQFxV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 00:53:21 -0500
Date: Thu, 16 Nov 2017 21:53:15 -0800
From: Marc MERLIN <marc@merlins.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org
Message-ID: <20171117055315.7bmhthyqityiffwl@merlins.org>
References: <20171116170445.24n57phzltgiehj6@merlins.org>
 <20171116170742.vyhxckxrgjzwqyvf@merlins.org>
 <70b25128-d724-4e8e-9835-4a092cf8d5a6@applied-asynchrony.com>
 <20171116214551.vpp4eevs7b4bszjt@merlins.org>
 <2b97e49b-74fd-77c1-a340-8254f8999bb1@applied-asynchrony.com>
 <20171117001256.GN10969@merlins.org>
 <20171117104148.04986eee@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20171117104148.04986eee@natsu>
Subject: Re: 4.13.12: kernel BUG at fs/btrfs/ctree.h:1802!
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 17, 2017 at 10:41:48AM +0500, Roman Mamedov wrote:
> On Thu, 16 Nov 2017 16:12:56 -0800
> Marc MERLIN <marc@merlins.org> wrote:
> 
> > On Thu, Nov 16, 2017 at 11:32:33PM +0100, Holger Hoffstätte wrote:
> > > Don't pop the champagne just yet, I just read that apprently 4.14 broke
> > > bcache for some people [1]. Not sure how much that affects you, but it might
> > > well make things worse. Yeah, I know, wonderful.
> > 
> > Oh my, that's actually pretty terrible.
> > I've just reverted both my machines to 3.13, the last thing I need is more
> > btrfs corruption.
> 
> Why so far back though, the latest 4.4 and 4.9 are both good series and run
> without issues for me since a long time. Or perhaps you meant 4.13 :)
 
Typo indeed, I meant 4.13.

> I suggest that you try lvmcache instead. It's much more flexible than bcache,
> does pretty much the same job, and has much less of the "hacky" feel to it.

I can read up on it, it's going to be a big pain to convert from one to
the other, but I can look at it for new filesystems.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
