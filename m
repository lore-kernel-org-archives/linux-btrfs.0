Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbcFWNNe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 09:13:34 -0400
Date: Thu, 23 Jun 2016 15:13:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [RFC][PATCH] btrfs-progs: inspect: new subcommand to dump chunks
Message-ID: <20160623131352.GC4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466616406-28087-1-git-send-email-dsterba@suse.com>
 <376fafee-8baa-2a49-7d77-892ceb419b83@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <376fafee-8baa-2a49-7d77-892ceb419b83@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 12:20:38AM +0200, Hans van Kranenburg wrote:
> > Printing 'usage' is not default as it's quite slow, it uses the search ioctl
> > and probably not in the best way, or there's some other issue in the
> > implementation.
> 
> Interesting.
> 
> So after reading this, I wrote a little test to test some scenarios:
> 
> https://github.com/knorrie/python-btrfs/commit/1ca99880dfa0e14b148f3d9e2b6b381b781eb52d
> 
> It's very clear that the most optimal way of doing this search is to 
> have nr_items=1 and if possible, specify the length in offset.

And that solved it.

[...]

> It seems that searching in the empty space between
>   (vaddr BLOCK_GROUP_ITEM length+1) and
>   (vaddr BLOCK_GROUP_ITEM ULLONG_MAX)
> is really expensive, while there's absolutely nothing to find.

Yeah, the few BLOCK_GROUP_ITEMs are scattered among tons of EXTENT_ITEMs 
