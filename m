Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbaLASvf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 13:51:35 -0500
Date: Mon, 1 Dec 2014 19:51:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Message-ID: <20141201185135.GN12140@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
 <20141125163905.GJ26471@twin.jikos.cz>
 <20141127035219.GB2224@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141127035219.GB2224@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 27, 2014 at 11:52:20AM +0800, Liu Bo wrote:
> > There are several checksum algorithms that trade off speed and strength
> > so we may want to support more than just sha256. Easy to add but I'd
> > rather see them added in all at once than one by one.
> > 
> > Another question is if we'd like to use different checksum for data and
> > metadata. This would not cost any format change if we use the 2 bytes in
> > super block csum_type.
> 
> Yes, but breaking it into meta_csum_type and data_csum_type will need a
> imcompat flag.

Not necessarily a new bit. If we read the field as-is, see if it's zero
we know it's the previous version, otherwise the new one and then set
only in-memory fileds for data and metadata.

The backward compatibility is fine, old kernels will refuse to mount
with csum_type != 0.

> > Optional/crazy/format change stuff:
> > 
> > * per-file checksum algorithm - unlike compression, the whole file would
> >   have to use the same csum algo
> >   reflink would work iff the algos match
> >   snapshotting is unaffected
> > 
> > * per-subvolume checksum algorithm - specify the csum type at creation
> >   time, or afterwards unless it's modified
> 
> I thought about this before, if we enable this, a few cases need to be dealt
> with(at least),
> 1. convert file data's csum from one algorithm to another

On-line or offline? I'd rather avoid doing that on a mounted filesystem.

> 2. to make different checksum length co-exist, we can either use different
>    key.type for different algorithms, or pack checksum into a new structure that
>    has algorithm types(and length).

Oh right, the mixed sizes of checksums could be a problem and would
require a format change (and thus the incompatibility bit).

The key.type approach looks better, we'd encode the algorithm type
effectively, the item bytes contain only fixed-size checksums.
(Here I'm thinking a new BTRFS_EXTENT_CSUM_KEY per checksum type.)

OTOH storing the algo type (size is not needed) would add overhead
per-checksum (probably only a single byte but still).
