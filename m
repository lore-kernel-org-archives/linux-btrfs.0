From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfstests: Add support for btrfs in 015
Date: Thu, 28 Jul 2011 04:47:56 -0400
Message-ID: <20110728084756.GC3407@infradead.org>
References: <cover.1311776403.git.sbehrens@giantdisaster.de>
 <bebfc5c98e0fb878f55c1312d8750ce7b7f82e07.1311776403.git.sbehrens@giantdisaster.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: Stefan Behrens <sbehrens@giantdisaster.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <bebfc5c98e0fb878f55c1312d8750ce7b7f82e07.1311776403.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2011 at 10:28:00AM +0200, Stefan Behrens wrote:
> Added btrfs to the list of supported filesystems for test 015, and
> increased free space reporting tolerance to 10% for btrfs.
> Replaced the call to _scratch_mkfs_xfs with the XFS specific size
> parameter by the generic one for sized filesystem creation which is
> _scratch_mkfs_sized.

ACK for the _scratch_mkfs_sized changed, but I'm really curious why
we would allow so much more tolerance for btrfs.

And again, why can't these be marked generic?

