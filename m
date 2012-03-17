From: Alex <alex@bpmit.com>
Subject: Re: "not enough space" with "data raid0"
Date: Sat, 17 Mar 2012 15:17:05 +0000 (UTC)
Message-ID: <loom.20120317T161152-906@post.gmane.org>
References: <C52pxfli1uB@helmut.hullen.de> <loom.20120317T131420-684@post.gmane.org> <20120317122522.GD3172@carfax.org.uk> <loom.20120317T141129-14@post.gmane.org> <20120317140057.GF3172@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills <hugo <at> carfax.org.uk> writes:

> 
> On Sat, Mar 17, 2012 at 01:36:04PM +0000, Alex wrote:

> 
>    I don't have this problem personally. I just know something about
> the way btrfs allocates chunks. I think you meant Helmut has the
> problem. :)
> 
> > I'm struggling how to mkfs.btrfs with this new knowledge whilst resolving it
> > with the btrfs storage pool concept.
> > 
> > I stress there is a difficulty with my understanding not btrfs.
> 
>    Hugo.
> 


Yes, I meant Hugo .. damn .. Helmut, sorry! However deed-poll is a cost
effective measure which would allow you to avoid the coincident first letter
with Helmut. ;-)

Since we're still experimental in the non-SUSE and Oracle world and the space
meta demands sb lower can I squeak by:

mkfs.btrfs -d single -m raid1 ?

Don't laugh.



