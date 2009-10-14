From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2] btrfs: enable discard support
Date: Wed, 14 Oct 2009 09:27:04 -0400
Message-ID: <20091014132704.GG7850@think>
References: <20091014010302.GA21031@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091014010302.GA21031@lst.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 14, 2009 at 03:03:02AM +0200, Christoph Hellwig wrote:
> The discard support code in btrfs currently is guarded by ifdefs for
> BIO_RW_DISCARD, which is never defines as it's the name of an enum
> memeber.  Just remove the useless ifdefs to actually enable the code.

Thanks Christoph,

Any objection to me reordering these?  That way someone bisecting around
won't hit discard support without expecting it.

-chris

