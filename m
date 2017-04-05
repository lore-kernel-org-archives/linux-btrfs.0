Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41713 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753522AbdDEOG6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Apr 2017 10:06:58 -0400
Date: Wed, 5 Apr 2017 16:06:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH] btrfs: check if the device is flush capable
Message-ID: <20170405140612.GH4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170404104144.9414-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170404104144.9414-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 04, 2017 at 06:41:44PM +0800, Anand Jain wrote:
> blkdev_issue_flush() or the empty buffer with the flag REQ_PREFLUSH
> will never return BIO_EOPNOTSUPP as of now, however it should rather
> or it may in future. So for now the BTRFS to have least affected by
> this change at the blk layer, we can check if the device is flush
> capable.
> 
> In this process, I rename the unused nobarrier member as flushable,
> which the below patch made it redundant.
> 
> Per commit b25de9d6da49b1a8760a89672283128aa8c78345
>    block: remove BIO_EOPNOTSUPP
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

So up to now, dev->nobarriers was always 0 and thus write_dev_flush
always sent down the empty bio with PREFLUSH. Depending on the actual
device flush capabilities, it either kept the flush bit or removed it in
the generic_make_request_checks, and then proceeded to
generic_make_request.

In short, we always sent the flush bio. What your patch changes is that
this will happen only for devices that have the flush capability,
determined by the queue bit.

This change does not seem to contradict the commit
387125fc722a8ed432066b85a552917343bdafca that brought the
dev->nobarriers, so regarding metadata ordering and superblock flushes,
all seem ok. But this could use some doublechecking.
