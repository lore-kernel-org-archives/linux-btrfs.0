Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab3IWPqF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 11:46:05 -0400
Message-ID: <5240623A.7070309@redhat.com>
Date: Mon, 23 Sep 2013 10:46:02 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: check if device supports trim
References: <1379695327-30046-1-git-send-email-dsterba@suse.cz> <52405958.4050209@redhat.com> <20130923154403.GP6810@twin.jikos.cz>
In-Reply-To: <20130923154403.GP6810@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/23/13 10:44 AM, David Sterba wrote:
> On Mon, Sep 23, 2013 at 10:08:08AM -0500, Eric Sandeen wrote:
>> On 9/20/13 11:42 AM, David Sterba wrote:
>>> The message about trim was printed unconditionally, we should check if
>>> trim is supported at all.
>>
>> Good idea, but I wonder if there's any risk that discard(0,0) will ever
>> be optimized away on the kernel side & pass unconditionally?
> 
> I hope the checks in blkdev_issue_discard() stay in the order as of now:
> 
>  40 int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  41                 sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
>  42 {
> ...
>  52
>  53         if (!q)
>  54                 return -ENXIO;
>  55
>  56         if (!blk_queue_discard(q))
>  57                 return -EOPNOTSUPP;
> 
> here it returns no matter what the arguments are, setting length to 0 is
> just cautious.
> 
>  59         /* Zero-sector (unknown) and one-sector granularities are the same.  */
>  60         granularity = max(q->limits.discard_granularity >> 9, 1U);
>  61         alignment = bdev_discard_alignment(bdev) >> 9;
>  62         alignment = sector_div(alignment, granularity);
>  63
> 
>> I was thinking we could get this from blkid, but maybe not.
> 
> Possibly yes, with other information like rotational etc.
> 
> Alternatively,
> 
> /sys/block/sdx/queue/dicard_granularity > 0 means that the device
> supports discard, but that's imo even more fragile than the direct
> call to discard.

Perhaps; and I don't think libblkid gives us easy access to that anyway,
at least I didn't see it on a quick look.

So yeah, I think it's fine as you sent it; it doesn't actually change
behavior anyway other than the printf.

Thanks,
-Eric

