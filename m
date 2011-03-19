From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: Calculating/estimating the process of an ongoing balance
Date: Sat, 19 Mar 2011 13:25:34 +0200
Message-ID: <20110319112534.GA7404@kwango.lan.net>
References: <4D848D2B.9000303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D848D2B.9000303@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 19, 2011 at 12:02:03PM +0100, Andreas Philipp wrote:
> Hi all,
> 
> During a btrfs filesystem balance there are lines like the following
> one in dmesg
> btrfs: relocating block group 2122280075264 flags 9
> Since the "big" number is strictly decreasing, I wonder whether this
> can be used as some progress counter? For example,
> do I get something like a percentage of what has been done/balanced by
> the following formula:
> (h-l)/h
> where h is the highest, i.e. first, value and l is the last, i.e.
> smallest, value?

The patches have been posted to the list, although I'm not sure what
their current status is [1].  If you feel like it, apply and test them,
any feedback is more than welcome.

[1] - http://thread.gmane.org/gmane.comp.file-systems.btrfs/7487/

> Just for interest: There are two types of these lines appearing. One
> type with 'flags 9' and one with 'flags 20'. Do the first ones refer
> to block groups holding metadata and the second ones to block groups
> holding data or is it totally different (and more complicated)?

Yes, you are right.  9 designates a raid0 data block group and 20 means
a raid1 metadata group.

> Thanks,
> Andreas Philipp

Thanks,

		Ilya
