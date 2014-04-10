Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18949 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454AbaDJPor (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 11:44:47 -0400
Date: Thu, 10 Apr 2014 23:44:10 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, alanqk@gmail.com,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: Re: [RFC PATCH v10 00/16] Online(inband) data deduplication
Message-ID: <20140410154355.GA23295@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
 <53465F81.7000803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <53465F81.7000803@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 10, 2014 at 12:08:17PM +0300, Konstantinos Skarlatos wrote:
> On 10/4/2014 6:48 πμ, Liu Bo wrote:
> >Hello,
> >
> >This the 10th attempt for in-band data dedupe, based on Linux _3.14_ kernel.
> >
> >Data deduplication is a specialized data compression technique for eliminating
> >duplicate copies of repeating data.[1]
> >
> >This patch set is also related to "Content based storage" in project ideas[2],
> >it introduces inband data deduplication for btrfs and dedup/dedupe is for short.
> >
> >* PATCH 1 is a speed-up improvement, which is about dedup and quota.
> >
> >* PATCH 2-5 is the preparation work for dedup implementation.
> >
> >* PATCH 6 shows how we implement dedup feature.
> >
> >* PATCH 7 fixes a backref walking bug with dedup.
> >
> >* PATCH 8 fixes a free space bug of dedup extents on error handling.
> >
> >* PATCH 9 adds the ioctl to control dedup feature.
> >
> >* PATCH 10 targets delayed refs' scalability problem of deleting refs, which is
> >   uncovered by the dedup feature.
> >
> >* PATCH 11-16 fixes bugs of dedupe including race bug, deadlock, abnormal
> >   transaction abortion and crash.
> >
> >* btrfs-progs patch(PATCH 17) offers all details about how to control the
> >   dedup feature on progs side.
> >
> >I've tested this with xfstests by adding a inline dedup 'enable & on' in xfstests'
> >mount and scratch_mount.
> >
> >
> >***NOTE***
> >Known bugs:
> >* Mounting with options "flushoncommit" and enabling dedupe feature will end up
> >   with _deadlock_.
> >
> >
> >TODO:
> >* a bit-to-bit comparison callback.
> >
> >All comments are welcome!
> Hi Liu,
> Thanks for doing this work.
> I tested your previous patches a few months ago, and will now test
> the new ones. One question about memory requirements, are they in
> the same league as ZFS dedup (ie needing 10's of gb of RAM for multi
> TB filesystems) or are they more reasonable?
> Thanks

Hi Konstantinos,

It depends on Linux native memory management which can reclaim memory when
lacking memory, but still, it'd lead to high memory pressure according to my
experiments.

Thanks for testing it!

-liubo
