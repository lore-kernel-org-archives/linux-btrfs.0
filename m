From: btrfs-devel@arbitraryconstant.com
Subject: Re: Btrfs v0.16 released
Date: Thu, 7 Aug 2008 13:33:47 -0600 (MDT)
Message-ID: <61917.68.145.124.201.1218137627.squirrel@avalon.arbitraryconstant.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> If there is no
> alternate mirror, the caller gets EIO and in the case of a failed csum,
> the page is zero filled (actually filled with ones so I can find bogus
> pages in an oops).

You mention there will be a utility to scrub the disks to repair stuff
like this, but does it make sense to retry the read in event the it came
back from the wrong sector or a bit got flipped somewhere or some other
transient error?


