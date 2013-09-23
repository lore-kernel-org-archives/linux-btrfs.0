Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab3IWPoH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 11:44:07 -0400
Date: Mon, 23 Sep 2013 17:44:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: check if device supports trim
Message-ID: <20130923154403.GP6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379695327-30046-1-git-send-email-dsterba@suse.cz>
 <52405958.4050209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52405958.4050209@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 23, 2013 at 10:08:08AM -0500, Eric Sandeen wrote:
> On 9/20/13 11:42 AM, David Sterba wrote:
> > The message about trim was printed unconditionally, we should check if
> > trim is supported at all.
> 
> Good idea, but I wonder if there's any risk that discard(0,0) will ever
> be optimized away on the kernel side & pass unconditionally?

I hope the checks in blkdev_issue_discard() stay in the order as of now:

 40 int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 41                 sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
 42 {
...
 52
 53         if (!q)
 54                 return -ENXIO;
 55
 56         if (!blk_queue_discard(q))
 57                 return -EOPNOTSUPP;

here it returns no matter what the arguments are, setting length to 0 is
just cautious.

 59         /* Zero-sector (unknown) and one-sector granularities are the same.  */
 60         granularity = max(q->limits.discard_granularity >> 9, 1U);
 61         alignment = bdev_discard_alignment(bdev) >> 9;
 62         alignment = sector_div(alignment, granularity);
 63

> I was thinking we could get this from blkid, but maybe not.

Possibly yes, with other information like rotational etc.

Alternatively,

/sys/block/sdx/queue/dicard_granularity > 0 means that the device
supports discard, but that's imo even more fragile than the direct
call to discard.
