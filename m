Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42000 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575AbcAJBWJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Jan 2016 20:22:09 -0500
Message-ID: <5691B208.9060001@cs.wisc.edu>
Date: Sat, 09 Jan 2016 19:21:12 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>, mchristi@redhat.com
CC: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com,
        linux-scsi@vger.kernel.org, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, philipp.reisner@linbit.com,
        linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, target-devel@vger.kernel.org,
        linux-mtd@lists.infradead.org, osd-dev@open-osd.org,
        linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] [PATCH 02/35] block: add REQ_OP definitions and bi_op/op
 fields
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com> <1452027218-32303-3-git-send-email-mchristi@redhat.com> <20160109133716.GB26660@infradead.org> <5691AC2E.2050403@cs.wisc.edu>
In-Reply-To: <5691AC2E.2050403@cs.wisc.edu>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/09/2016 06:56 PM, Mike Christie wrote:
> On 01/09/2016 07:37 AM, Christoph Hellwig wrote:
>> Seems like this is missing REQ_OP_FLUSH, which still hides as a write?
>>

Oh yeah, to answer the second part of your question, REQ_OP_FLUSH is
only a flush operation like what request_fn drivers wanted.

REQ_PREFLUSH can be set with a REQ_OP_WRITE bio when filesystems want to
do both.

There is then the case where filesystems and blkdev_issue_flush could
just want to request a flush. I left them as a REQ_PREFLUSH with
REQ_OP_WRITE set, so there would be a single code path.

> 
> I might have misunderstood what you wanted or am misunderstanding you now.
> 
> I did not change the flush related code until the last patches. I added
> REQ_OP_FLUSH in patch:
> 
> [PATCH 33/35] block, drivers: add REQ_OP_FLUSH operation
> commit 18dea20363ba245a47bc1bb54f6465b8a05b19af
> Author: Mike Christie <mchristi@redhat.com>
> Date:   Tue Jan 5 21:02:17 2016 -0600
> 
>     block, drivers: add REQ_OP_FLUSH operation
> 
> 
> and I added the REQ_PREFLUSH flag in
> 
> 
> [PATCH 35/35] block, drivers, fs: rename REQ_FLUSH to REQ_PREFLUSH
> commit 303dc6a7cc3673065538ba041562fcd833a619af
> Author: Mike Christie <mchristi@redhat.com>
> Date:   Thu Jan 7 18:17:03 2016 -0600
> 
>     block, drivers, fs: rename REQ_FLUSH to REQ_PREFLUSH
> 
> 
> I did them in separate patches, because I was not sure if they were
> correct with what you requested before, and because they were a little
> more tricky because of how request_fn drivers, make_request_fn drivers,
> and dm-multipath handle flushes differently.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

