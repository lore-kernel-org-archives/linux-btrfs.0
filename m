Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39324 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbaKVW0O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Nov 2014 17:26:14 -0500
Date: Sat, 22 Nov 2014 14:26:06 -0800
From: Marc MERLIN <marc@merlins.org>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <20141122222606.GO8916@merlins.org>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

+btrfs list so that someone can correct me if I'm wrong.

On Sat, Nov 22, 2014 at 09:34:59PM +0100, Patrik Lundquist wrote:
> Hi,
> 
> I was scratching my head over a failing btrfs balance and read your
> very informative
> http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html,
> but shouldn't
> 
> "I can ask balance to rewrite all chunks that are more than 55% full"
> 
> be
> 
> "I can ask balance to rewrite all chunks that are less than 55% full"?

This one hurts my brain every time I think about it :)

So, the bigger the -dusage number, the more work btrfs has to do.

-dusage=0 does almost nothing
-dusage=100 effectively rebalances everything

But saying saying "less than 95% full" for -dusage=95 would mean
rebalancing everything that isn't almost full, so I'm not sure it makes
sense either (I would think you'd wan't to reblance full blocks first).

The logical wording would be "less than 95% space free".

I'll update my page since this is what makes the most sense.

Now, just to be sure, if I'm getting this right, if your filesystem is
55% full, you could rebalance all blocks that have less than 55% space
free, and use -dusage=55

Does that sound right?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
