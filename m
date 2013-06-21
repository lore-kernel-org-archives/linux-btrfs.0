Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:40943 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965396Ab3FUBEz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 21:04:55 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 6F68C7C041C
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 19:04:55 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Sage Weil <sage@inktank.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <alpine.DEB.2.00.1306201755480.20350@cobra.newdream.net>
CC: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net>
 <20130618163706.GC19183@localhost.localdomain>
 <20130618165952.9494.8953@localhost.localdomain>
 <alpine.DEB.2.00.1306192043380.14838@cobra.newdream.net>
 <alpine.DEB.2.00.1306201455440.454@cobra.newdream.net>
 <20130621004216.4477.93556@localhost.localdomain>
 <alpine.DEB.2.00.1306201755480.20350@cobra.newdream.net>
Message-ID: <20130621010453.4477.41145@localhost.localdomain>
Subject: Re: hang on 3.9, 3.10-rc5
Date: Thu, 20 Jun 2013 21:04:53 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Sage Weil (2013-06-20 21:00:21)
> On Thu, 20 Jun 2013, Chris Mason wrote:
> > Awesome, thanks for getting the traces for us.  Looks like this one has
> > been around since v3.7, so I'm not going to try and sneak it into the
> > 3.10 final.  I'll have it in the next merge window and for stable.
> 
> Weird, these same tests have been running on it nightly for ages and it 
> seems like these failures just started with 3.9.  Perhaps some other 
> change made it hang when it didn't before?
> 

It's always possible, there are a ton of moving pieces here.  The
wait_event you were hung on was waiting for crcs to finish, and that
part at least isn't new.

Somewhat unrelated, but are you still using notreelog?

-chris

