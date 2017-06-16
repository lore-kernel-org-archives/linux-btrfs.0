Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32931 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753678AbdFPOEJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Jun 2017 10:04:09 -0400
Date: Fri, 16 Jun 2017 16:03:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/5] btrfs: add fs flag to force device flushing
Message-ID: <20170616140303.GA21388@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1497544265.git.dsterba@suse.com>
 <8c201990ae0acb3b80437f9de2e432b60ecf8e4a.1497544265.git.dsterba@suse.com>
 <e8b99f82-4e39-fda5-39f3-f3349577687d@oracle.com>
 <96590a3c-ba90-c671-2e23-d629834547a6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <96590a3c-ba90-c671-2e23-d629834547a6@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 16, 2017 at 06:27:20AM +0800, Anand Jain wrote:
> 
> 
> 
> 
> >> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >> index 59a732a13370..659a3b4645d2 100644
> >> --- a/fs/btrfs/disk-io.c
> >> +++ b/fs/btrfs/disk-io.c
> >> @@ -3494,7 +3494,8 @@ static void write_dev_flush(struct btrfs_device 
> >> *device)
> >>       struct request_queue *q = bdev_get_queue(device->bdev);
> >>       struct bio *bio = device->flush_bio;
> >> -    if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
> >> +    if (!test_bit(BTRFS_FS_FORCE_DEV_FLUSH, &device->fs_info->flags)
> >> +        && !test_bit(QUEUE_FLAG_WC, &q->queue_flags))
> >>           return;
> > 
> > 
> >   Now I understand what you meant. But the most common case in our test
> >   set up is a device with write cache. So BTRFS_FS_FORCE_DEV_FLUSH does
> >   not bring any additional force. IMO.
> > 
> > Thanks, Anand
> 
>   Or one another idea is we could remove
> 
>     !test_bit(QUEUE_FLAG_WC, &q->queue_flags)
> 
>   which purpose is to only fail early.

I'd prefer to keep it that way.

>   If we remove it there is consistency in our code with or
>   with out the write cache.
