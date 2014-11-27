Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23054 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaK0Dwc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 22:52:32 -0500
Date: Thu, 27 Nov 2014 11:52:20 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Message-ID: <20141127035219.GB2224@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
 <20141125163905.GJ26471@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141125163905.GJ26471@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 25, 2014 at 05:39:05PM +0100, David Sterba wrote:
> On Mon, Nov 24, 2014 at 01:23:05PM +0800, Liu Bo wrote:
> > This brings a strong-but-slow checksum algorithm, sha256.
> > 
> > Actually btrfs used sha256 at the early time, but then moved to crc32c for
> > performance purposes.
> > 
> > As crc32c is sort of weak due to its hash collision issue, we need a stronger
> > algorithm as an alternative.
> > 
> > Users can choose sha256 from mkfs.btrfs via
> > 
> > $ mkfs.btrfs -C 256 /device
> 
> There's already some good feedback so I'll try to cover what hasn't been
> mentioned yet.
> 
> I think it's better to separate the preparatory works from adding the
> algorithm itself. The former can be merged (and tested) independently.

That's a good point.

> 
> There are several checksum algorithms that trade off speed and strength
> so we may want to support more than just sha256. Easy to add but I'd
> rather see them added in all at once than one by one.
> 
> Another question is if we'd like to use different checksum for data and
> metadata. This would not cost any format change if we use the 2 bytes in
> super block csum_type.

Yes, but breaking it into meta_csum_type and data_csum_type will need a
imcompat flag.

> 
> 
> Optional/crazy/format change stuff:
> 
> * per-file checksum algorithm - unlike compression, the whole file would
>   have to use the same csum algo
>   reflink would work iff the algos match
>   snapshotting is unaffected
> 
> * per-subvolume checksum algorithm - specify the csum type at creation
>   time, or afterwards unless it's modified

I thought about this before, if we enable this, a few cases need to be dealt
with(at least),
1. convert file data's csum from one algorithm to another
2. to make different checksum length co-exist, we can either use different
   key.type for different algorithms, or pack checksum into a new structure that
   has algorithm types(and length).

thanks,
-liubo
