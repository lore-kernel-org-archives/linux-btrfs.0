Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaL2O4U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 09:56:20 -0500
Date: Mon, 29 Dec 2014 15:56:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs: Enhance btrfs chunk allocation algorithm
 to reduce ENOSPC caused by unbalanced data/metadata allocation.
Message-ID: <20141229145619.GG6490@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1419386114-21703-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1419386114-21703-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1419386114-21703-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 24, 2014 at 09:55:14AM +0800, Qu Wenruo wrote:
> When btrfs allocate a chunk, it will try to alloc up to 1G for data and
> 256M for metadata, or 10% of all the writeable space if there is enough
> space for the stripe on device.
> 
> However, when we run out of space, this allocation may cause unbalanced
> chunk allocation.
> For example, there are only 1G unallocated space, and request for
> allocate DATA chunk is sent, and all the space will be allocated as data
> chunk, making later metadata chunk alloc request unable to handle, which
> will cause ENOSPC.

The question is why the metadata is full although there's 1G free, as
the metadata chunks are being preallocated according to the metadata
ratio.

> This is the one of the common complains from end users about why ENOSPC
> happens but there is still available space.
> 
> This patch will try not to alloc chunk which is more than half of the
> unallocated space, making the last space more balanced at a small cost
> of more fragmented chunk at the last 1G.

I'm really worried about the small chunks and the fragmentation on that
level wrt balancing. The small chunks will be relolcated to bigger free
chunks (eg. 256mb) and make it unusable for further rebalancing of the
256mb chunks. Newly allocated chunks will have to be reduced in size to
fit in the remaining place and will cause further fragmentation of the
chunk space.

The drawbacks of small chunks are obvious:

* more chunks mean more processing
* smaller chance of getting big contiguous space for extents, leading to
  file fragmentation that cannot be much improved fixed by
  defragmentation

IMO the chunk allocation should be more predictable and should give some
clue how the layout happens, otherwise this will become another dark
corner that would make debugging harder and can negatively and
unpreditactably affect performance after some time.

The problems you're trying to address are real, no doubt here, but I'd
rather try to address them in a different way.
