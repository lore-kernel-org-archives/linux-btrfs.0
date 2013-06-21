Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:44443 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161101Ab3FUBJe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 21:09:34 -0400
Date: Thu, 20 Jun 2013 18:09:33 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: Chris Mason <chris.mason@fusionio.com>
cc: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: hang on 3.9, 3.10-rc5
In-Reply-To: <20130621010453.4477.41145@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1306201805420.20350@cobra.newdream.net>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net> <20130618163706.GC19183@localhost.localdomain> <20130618165952.9494.8953@localhost.localdomain> <alpine.DEB.2.00.1306192043380.14838@cobra.newdream.net> <alpine.DEB.2.00.1306201455440.454@cobra.newdream.net>
 <20130621004216.4477.93556@localhost.localdomain> <alpine.DEB.2.00.1306201755480.20350@cobra.newdream.net> <20130621010453.4477.41145@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 20 Jun 2013, Chris Mason wrote:
> Quoting Sage Weil (2013-06-20 21:00:21)
> > On Thu, 20 Jun 2013, Chris Mason wrote:
> > > Awesome, thanks for getting the traces for us.  Looks like this one has
> > > been around since v3.7, so I'm not going to try and sneak it into the
> > > 3.10 final.  I'll have it in the next merge window and for stable.
> > 
> > Weird, these same tests have been running on it nightly for ages and it 
> > seems like these failures just started with 3.9.  Perhaps some other 
> > change made it hang when it didn't before?
> > 
> 
> It's always possible, there are a ton of moving pieces here.  The
> wait_event you were hung on was waiting for crcs to finish, and that
> part at least isn't new.

K.  There was also a shift of writes to leveldb (which does the mmap 
thing), so that may explain the change in behavior.

> Somewhat unrelated, but are you still using notreelog?

Nope, just noatime.

Thanks-
sage
