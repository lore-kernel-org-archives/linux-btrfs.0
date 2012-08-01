Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43701 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab2HAGV5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 02:21:57 -0400
Date: Tue, 31 Jul 2012 23:21:56 -0700
From: Marc MERLIN <marc@merlins.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Message-ID: <20120801062156.GI12695@merlins.org>
References: <20120722185848.GA10089@merlins.org> <201207222135.11159.Martin@lichtvoll.de> <20120722204428.GC3925@merlins.org> <20120722224145.GC12951@merlins.org> <20120723064202.GB6931@merlins.org> <20120727110835.GA6933@shiny> <20120801053042.GG12695@merlins.org> <20120727184238.GA6713@merlins.org> <20120801060135.GH12695@merlins.org> <CAG1y0sdnyv4O8zab+WwLxZ6qUJTcVryrAgnDfv5eiAw+eZh-Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAG1y0sdnyv4O8zab+WwLxZ6qUJTcVryrAgnDfv5eiAw+eZh-Gg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 01, 2012 at 01:08:46PM +0700, Fajar A. Nugraha wrote:
> > It it were a random crappy SSD from a random vendor, I'd blame the SSD, but
> > I have a hard time believing that samsung is selling SSDs that are slower
> > than hard drives at random IO and 'seeks'.
> 
> You'd be surprised on how badly some vendors can screw up :)
 
At some point, it may come down to that indeed :-/
I'm still hopefully that Samsung didn't, but we'll see.
 
> > First: btrfs is the slowest:
> 
> > gandalfthegreat:/mnt/ssd/var/local# grep /mnt/ssd/var /proc/mounts
> > /dev/mapper/ssd /mnt/ssd/var btrfs rw,noatime,compress=lzo,ssd,discard,space_cache 0 0
> 
> Just checking, did you explicitly activate "discard"? Cause on my

Yes. Note that it should a noop when all you're doing is stating inodes and
not writing (I'm using noatime).

> setup (with corsair SSD) it made things MUCH slower. Also, try adding
> "noatime" (just in case the slow down was because "du" cause many
> access time updates)

I have noatime in there already :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
