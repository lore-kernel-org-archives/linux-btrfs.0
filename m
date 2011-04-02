From: Larry D'Anna <larry@elder-gods.org>
Subject: Re: [PATCH 0/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Sat, 2 Apr 2011 12:56:29 -0400
Message-ID: <20110402165629.GA24734@cthulhu>
References: <cover.1301542804.git.larry@elder-gods.org>
 <20110331063636.GA5297@infradead.org>
 <1301572893-sup-3464@think>
 <20110401133405.GA17956@infradead.org>
 <1301759479.8770.8.camel@tankquad>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
To: Ken Drummond <btrfs@kendrummond.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1301759479.8770.8.camel@tankquad>
List-ID: <linux-btrfs.vger.kernel.org>

* Ken Drummond (btrfs@kendrummond.com) [110402 11:51]:
> I don't really understand the details here, but doesn't the creation of
> a snapshot already lead to data extents being shared between
> sub-volumes?  From a simple user perspective this sounds like a very
> useful capability.

I was surprised and frustrated to find it missing.  I had just copied a large
quantity of data into btrfs, realized i need to make a subvolume to try out
snapshotting, and then found out i had to copy all the data *again* to get it
into a subvolume.  There are tons of scenarios where users will want and expect
to be able to do this.
