Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56906 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752112AbdETAsG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 20:48:06 -0400
Date: Fri, 19 May 2017 17:47:48 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, Liu Bo <bo.li.liu@oracle.com>,
        Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: 4.11.0: kernel BUG at fs/btrfs/ctree.h:1779!
Message-ID: <20170520004748.GA29894@merlins.org>
References: <20170519041638.sf7sensley4lpxiz@merlins.org> <20170519190358.GC10137@lim.localdomain> <20170520001134.GW29894@merlins.org> <20170520003747.GO9701@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170520003747.GO9701@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 20, 2017 at 12:37:47AM +0000, Hugo Mills wrote:
> > Can I make another plea for just removing all those BUG/BUG_ON?
> > They really have no place in production code, there is no excuse for a
> > filesystem to bring down the entire and in the process not even tell you
> > which of your filesystems had the issue to start with.
> > 
> > Could this be made part of a cleanup for this build to remove them all?
> 
>    The removal of these has been an ongoing process for at least the
> last 5 years.
 
That's great news, thanks. I guess I'm a bit edgy because I've hit too many
of them already :) but glad to hear that there are a lot fewer now.

>    I don't understand the specifics of the kernel code in question(*),
> but compared to 5 years ago, btrfs has got rid of most of the
> BUG_ONs(**) a few years ago. The remaining ones are probably
> complicated to deal with in any way more elegant than just stopping.

The biggest problem is that those BUG* do not even tell you where the
problem.
The assumption that you'd only ever have a single btrfs filesystem mounted,
is flawed to say the least :)
(I have 5 different ones on my server)

>    I recall seeing someone's stats on BUG_ON locations a couple of
> years ago, and btrfs had managed to get the number of locations down
> below XFS (but no other FS). It's a kind of success, at least...

Good to know, thanks, and thanks to anyone who has worked on removing those.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
