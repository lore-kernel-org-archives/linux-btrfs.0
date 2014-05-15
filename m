Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaEORuG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 13:50:06 -0400
Date: Thu, 15 May 2014 19:50:04 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>,
        Russell Coker <russell@coker.com.au>, linux-btrfs@vger.kernel.org
Subject: Re: known UUID and metadata consistency
Message-ID: <20140515175004.GT6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201405111416.28012.russell@coker.com.au>
 <20140511091041.GA23212@carfax.org.uk>
 <20140512171017.GF6917@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140512171017.GF6917@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 12, 2014 at 07:10:17PM +0200, David Sterba wrote:
> One thing that looks as a show stopper is the fact that the fake data
> blocks that would become the metadata blocks would lie out of any
> metadata group. I'm not familiar with the chunk rebuilder, but this
> seems as a simple check to do when it tries to guess the block group
> layout from what it finds on disk.

There's one more hurdle that looks tough to overcome: each metadata
block records the chunk tree UUID, and this piece of information is not
available to the user through ioctls, sysfs or ordinary data reads.
