From: Thomas Bellman <bellman@nsc.liu.se>
Subject: Re: btrfs wishlist
Date: Wed, 02 Mar 2011 10:05:28 +0100
Message-ID: <4D6E0858.6030603@nsc.liu.se>
References: <28499638.308.1299004542529.JavaMail.root@zimbra> <1299004651-sup-1713@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1299004651-sup-1713@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 2011-03-01 19:39, Chris Mason wrote:

> We'll have raid56, but it won't be variable stripe size.  There will be
> one stripe size for data and one for metadata but that's it.

Will the stripe *width* be configurable?  If I have something like a
Sun Thor with 48 drives, I would probably not be entirely comfortable
having 46 drives data and 2 drives parity; too little redundancy for
my tastes.  2 drives parity per 10 drives data is more like what I
would run, but that would of course be an individual choice.


	/Bellman
