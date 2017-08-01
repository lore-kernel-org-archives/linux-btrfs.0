Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32016 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751941AbdHASJI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 14:09:08 -0400
Date: Tue, 1 Aug 2017 11:07:57 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
Message-ID: <20170801170757.GD26357@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
 <20170801222547.35d1bd03@natsu>
 <50312ea2-a0bf-09f7-8bc0-804c3a087ae4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50312ea2-a0bf-09f7-8bc0-804c3a087ae4@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 01, 2017 at 01:39:59PM -0400, Austin S. Hemmelgarn wrote:
> On 2017-08-01 13:25, Roman Mamedov wrote:
> > On Tue,  1 Aug 2017 10:14:23 -0600
> > Liu Bo <bo.li.liu@oracle.com> wrote:
> > 
> > > This aims to fix write hole issue on btrfs raid5/6 setup by adding a
> > > separate disk as a journal (aka raid5/6 log), so that after unclean
> > > shutdown we can make sure data and parity are consistent on the raid
> > > array by replaying the journal.
> > 
> > Could it be possible to designate areas on the in-array devices to be used as
> > journal?
> > 
> > While md doesn't have much spare room in its metadata for extraneous things
> > like this, Btrfs could use almost as much as it wants to, adding to size of the
> > FS metadata areas. Reliability-wise, the log could be stored as RAID1 chunks.
> > 
> > It doesn't seem convenient to need having an additional storage device around
> > just for the log, and also needing to maintain its fault tolerance yourself (so
> > the log device would better be on a mirror, such as mdadm RAID1? more expense
> > and maintenance complexity).
> > 
> I agree, MD pretty much needs a separate device simply because they can't
> allocate arbitrary space on the other array members.  BTRFS can do that
> though, and I would actually think that that would be _easier_ to implement
> than having a separate device.
>

Yes and no, using chunks may need a new ioctl and diving into chunk
allocation/(auto)deletion maze.

> That said, I do think that it would need to be a separate chunk type,
> because things could get really complicated if the metadata is itself using
> a parity raid profile.

Exactly, esp. when balance comes into the picture.

Thanks,

-liubo
