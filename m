Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59135 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752004AbdEQRO7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 13:14:59 -0400
Date: Wed, 17 May 2017 19:14:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "anand.jain@oracle.com" <anand.jain@oracle.com>
Subject: Re: [RFC PATCH 0/2] Introduce blkdev_issue_flush_no_wait()
Message-ID: <20170517171400.GI4065@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170516093914.16035-1-anand.jain@oracle.com>
 <1494943642.2935.1.camel@sandisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1494943642.2935.1.camel@sandisk.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 16, 2017 at 02:07:23PM +0000, Bart Van Assche wrote:
> On Tue, 2017-05-16 at 17:39 +0800, Anand Jain wrote:
> > BTRFS wanted a block device flush function which does not wait for
> > its completion, so that the flush for the next device can be called
> > in the same thread.
> > 
> > Here is a RFC patch to provide the function
> > 'blkdev_issue_flush_no_wait()', which is based on the current device
> > flush function 'blkdev_issue_flush()', however it uses submit_bio()
> > instead of submit_bio_wait().
> > 
> > This patch is for review comments, will send out a final patch based
> > on the comments received.
> 
> Since the block layer can reorder requests, I think using
> blkdev_issue_flush_no_wait() will only yield the intended result if
> the caller waits until the requests that have to be flushed have completed.
> Is that how you intend to use this function?

Yes, this is intended. Regarding the two patches, I don't think we need
them. A more detailed explanation below.

The function blkdev_issue_flush_no_wait would be used in multi-device
btrfs to submit the barriers in parallel.

fs/btrfs/disk-io.c:barrier_all_devices

pseudocode:

foreach device
	write_dev_flush(wait=0)
		submit_bio(device->bio)

(would newly use blkdev_issue_flush_no_wait)


foreach device
	write_dev_flush(wiat=1)
		wait_for_completion(device->bio)

The submission path of write_dev_flush mimics the structure of
blkdev_issue_flush, so Anand supposedly wants to move that to API.

I personally don't think this is necessary and am fine with opencoding
it, btrfs would likely be the only user of the new function anyway.
Other reason is that we want to preallocate the bio used for flushing so
we can avoid ENOMEM when submitting disk barriers. This would not be
possible. In summary, I think we can address all the problems inside
btrfs without extending block layer as for now.
