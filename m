Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54803 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752672AbdDCMZj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Apr 2017 08:25:39 -0400
Date: Mon, 3 Apr 2017 14:24:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: drop the nossd flag when remounting with -o ssd
Message-ID: <20170403122454.GT4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170331171016.GN4781@twin.jikos.cz>
 <20170331200850.7067-1-kilobyte@angband.pl>
 <ec137980-08d0-77d8-258b-29610a49a13f@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ec137980-08d0-77d8-258b-29610a49a13f@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 31, 2017 at 10:24:57PM +0200, Hans van Kranenburg wrote:
> >> Adding the 'nossd_spread' would be good to have, even if it might be
> >> just a marginal usecase.
> 
> Please no, don't make it more complex if not needed.

The only use is when ssd,ssd_spread are on and then I'd just want to
disable ssd_spread, without disabling ssd at the same time.

1. mount -o ssd,ssd_spread
2. mount -o remount,nossd_spread

compared to

1. mount -o ssd,ssd_spread
2. mount -o remount,nossd
3. mount -o remount,ssd

I'd vote for adding nossd_spread, as the 'no-' options are common and
otherwise disabling ssd_spread would be another usage exception.

> > Not sure if there's much point.  In any case, that's a separate patch.
> > Should I add one while we're here?
> 
> Since the whole ssd thing is a bit of a joke actually, I'd rather see it
> replaces with an option to choose an extent allocator algorithm.

Yeah, SSD is not the shiny new tech anymore, so we'd need something more
future proof.

> The amount of if statements using this SSD things in btrfs in the kernel
> can be counted on one hand, and what they actually do is quite
> questionable (food for another mail thread).

That's right, do you have suggestions for futher SSD optimizations?
Other than better block alignment, faster flushes and no seek penalty, I
don't see much else.
