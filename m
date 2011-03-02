From: Justin Ossevoort <justin@internetionals.nl>
Subject: Re: btrfs wishlist
Date: Wed, 02 Mar 2011 15:18:40 +0100
Message-ID: <4D6E51C0.1030401@internetionals.nl>
References: <28499638.308.1299004542529.JavaMail.root@zimbra> <1299004651-sup-1713@think> <4D6E0858.6030603@nsc.liu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Thomas Bellman <bellman@nsc.liu.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D6E0858.6030603@nsc.liu.se>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/03/11 10:05, Thomas Bellman wrote:
> Will the stripe *width* be configurable?  If I have something like a
> Sun Thor with 48 drives, I would probably not be entirely comfortable
> having 46 drives data and 2 drives parity; too little redundancy for
> my tastes.  2 drives parity per 10 drives data is more like what I
> would run, but that would of course be an individual choice.

On thing to remember is is that the parity is for specific pieces of
file system data. So not your entire dataset is at risk when only write
errors occur on a few places on a few disks, only file system objects
that have data stored in those places are at immediate risk. This means
that only files unlucky enough to have multiple failing sectors for the
same stripe width to be really impacted.
Of course this only matters as long as we're talking about bad sectors
and not full disk failure.

Regards,

	justin....
