Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50076 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbaEEV21 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 17:28:27 -0400
Date: Mon, 5 May 2014 14:28:16 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Thoughts on RAID nomenclature
Message-ID: <20140505212816.GT10159@merlins.org>
References: <20140505211738.GS24298@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140505211738.GS24298@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 05, 2014 at 10:17:38PM +0100, Hugo Mills wrote:
>    Given these four (spread, dup, linear, grouped), I think it's
> fairly obvious that spread is a special case of grouped, where each
> device is its own group. Then dup is the opposite of grouped (i.e. you
> must have one or the other but not both). Finally, linear is a
> modifier that changes the sort order.
> 
>    All of these options run completely independently of the actual
> replication level selected, so we could have 3c:spread,linear
> (allocates on the first three devices only, until one fills up and
> then it moves to the fourth device), or 2c2s:grouped, with a device
> mapping {sda:1, sdb:1, sdc:1, sdd:2, sde:2, sdf:2} which puts
> different copies on different device controllers.

I generally like the idea and proposal :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
