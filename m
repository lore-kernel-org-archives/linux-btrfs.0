Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38177 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752398AbdENXRP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 May 2017 19:17:15 -0400
Date: Sun, 14 May 2017 16:16:52 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
Message-ID: <20170514231652.sdpaci7e4oxs5gc3@merlins.org>
References: <20170513205431.lm6y5tcffr35gq4a@merlins.org>
 <95bffb8b-7e66-7d6b-2455-f7a025dbb96c@mendix.com>
 <20170514201508.bd3dshfymqt4swpb@merlins.org>
 <20170514212111.GL9701@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170514212111.GL9701@carfax.org.uk>
Subject: Re: balancing every night broke balancing so now I can't balance
 anymore?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 14, 2017 at 09:21:11PM +0000, Hugo Mills wrote:
> > 2) balance -musage=0
> > 3) balance -musage=20
> 
>    In most cases, this is going to make ENOSPC problems worse, not
> better. The reason for doign this kind of balance is to recover unused
> space and allow it to be reallocated. The typical behaviour is that
> data gets overallocated, and it's metadata which runs out. So, the
> last thing you want to be doing is reducing the metadata allocation,
> because that's the scarce resource.
> 
>    Also, I'd usually recommend using limit=n, where n is approximately
> the amount of data overallcation (allocated space less used
> space). It's much more controllable than usage.


Thanks for that.
So, would you just remove the balance -musage=20 altogether?

As for limit= I'm not sure if it would be helpful since I run this
nightly. Anything that doesn't get done tonight due to limit, would be
done tomorrow?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
