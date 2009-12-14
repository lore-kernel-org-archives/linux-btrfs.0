From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] btrfs: Show discard option in /proc/mounts
Date: Tue, 15 Dec 2009 00:04:28 +0100
Message-ID: <20091214230428.GA11530@lst.de>
References: <20091214220112.GJ7812@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091214220112.GJ7812@parisc-linux.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 14, 2009 at 03:01:12PM -0700, Matthew Wilcox wrote:
> 
> Christoph's patch e244a0aeb6a599c19a7c802cda6e2d67c847b154 doesn't display
> the discard option in /proc/mounts, leading to some confusion for me.
> Here's the missing bit.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Looks good, sorry for forgetting that bit.

