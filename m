Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32541 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162592AbbKTUJ1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 15:09:27 -0500
Date: Fri, 20 Nov 2015 15:09:21 -0500
From: Chris Mason <clm@fb.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: <axboe@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix a bug of sleeping in atomic context
Message-ID: <20151120200921.GD9887@ret.masoncoding.com>
References: <1447984177-26795-1-git-send-email-bo.li.liu@oracle.com>
 <20151120131358.GC9887@ret.masoncoding.com>
 <20151120175749.GA10385@localhost.localdomain>
 <20151120200633.GB10385@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20151120200633.GB10385@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 20, 2015 at 12:06:33PM -0800, Liu Bo wrote:
> On Fri, Nov 20, 2015 at 09:57:49AM -0800, Liu Bo wrote:
> > On Fri, Nov 20, 2015 at 08:13:58AM -0500, Chris Mason wrote:
> > > On Thu, Nov 19, 2015 at 05:49:37PM -0800, Liu Bo wrote:
> > > > while xfstesting, this bug[1] is spotted by both btrfs/061 and btrfs/063,
> > > > so those sub-stripe writes are gatherred into plug callback list and
> > > > hopefully we can have a full stripe writes.
> > > > 
> > > > However, while processing these plugged callbacks, it's within an atomic
> > > > context which is provided by blk_sq_make_request() because of a get_cpu()
> > > > in blk_mq_get_ctx().
> > > > 
> > > > This changes to always use btrfs_rmw_helper to complete the pending writes.
> > > > 
> > > 
> > > Thanks Liu, but MD raid has the same troubles, we're not atomic in our unplugs.
> > 
> > Yeah, MD also does, but I don't see a way to change mq code at this
> > stage..
> 
> Correct it: MD raid5_unplug runs stripes inside a pair of spinlock (conf->device_lock) and moreover, those writes will be forwarded to raid5d to finish the job.
> 
> So md raid can run fine within atomic context.

Check MD raid10

-chris
