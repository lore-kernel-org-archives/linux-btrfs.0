From: Simon Kirby <sim@hostway.ca>
Subject: Re: remote mirroring in the works?
Date: Mon, 30 Aug 2010 23:30:31 -0700
Message-ID: <20100831063031.GE29552@hostway.ca>
References: <29385727.6.1283191163871.JavaMail.root@zimbra> <4C7BF51B.2070201@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
	linux-btrfs@vger.kernel.org, Fred van Zwieten <fvzwieten@gmail.com>
To: "K. Richard Pixley" <rich@noir.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C7BF51B.2070201@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 30, 2010 at 11:14:51AM -0700, K. Richard Pixley wrote:

>  On 20100830 10:59, Roy Sigurd Karlsbakk wrote:
>>> I think drbd does precisely what you want.
>>>
>>> It's not useful for fault tolerance, nor for load balancing, but it
>>> will
>>> produce a remote block copy that can be used as a sort of "hot
>>> backup".
>> drbd with heartbeat/pacemaker can provide fault tolerance...
> I think that's a matter of semantics.
>
> Once you've failed over from the primary system to the secondary,  
> changes to your block device are terminal.  It's not easy to produce a  
> system which can manage those changes and "heal" in the sense of  
> allowing the primary system to return to service.  In effect, returning  
> the primary system to service requires taking both systems down and  
> copying the block device from the secondary back to the first.

This is totally incorrect.  DRBD replicates in both directions quite
well, in fact.  I've been using it on about 60 machines for many years,
and I have never had to do what you mention.

What it does not help with is avoiding corruption that occurs above the
block layer; eg, if your file system or your database on top of it barfs,
there is no other "good copy".  fsck or repair is still required in these
cases.  It is just like local RAID 1 in this respect -- you still need a
backup and/or copy at the file level, which is closer to what is needed
here.

Simon-
