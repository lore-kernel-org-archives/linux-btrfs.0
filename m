Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbaKYQjG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 11:39:06 -0500
Date: Tue, 25 Nov 2014 17:39:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Message-ID: <20141125163905.GJ26471@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 24, 2014 at 01:23:05PM +0800, Liu Bo wrote:
> This brings a strong-but-slow checksum algorithm, sha256.
> 
> Actually btrfs used sha256 at the early time, but then moved to crc32c for
> performance purposes.
> 
> As crc32c is sort of weak due to its hash collision issue, we need a stronger
> algorithm as an alternative.
> 
> Users can choose sha256 from mkfs.btrfs via
> 
> $ mkfs.btrfs -C 256 /device

There's already some good feedback so I'll try to cover what hasn't been
mentioned yet.

I think it's better to separate the preparatory works from adding the
algorithm itself. The former can be merged (and tested) independently.

There are several checksum algorithms that trade off speed and strength
so we may want to support more than just sha256. Easy to add but I'd
rather see them added in all at once than one by one.

Another question is if we'd like to use different checksum for data and
metadata. This would not cost any format change if we use the 2 bytes in
super block csum_type.


Optional/crazy/format change stuff:

* per-file checksum algorithm - unlike compression, the whole file would
  have to use the same csum algo
  reflink would work iff the algos match
  snapshotting is unaffected

* per-subvolume checksum algorithm - specify the csum type at creation
  time, or afterwards unless it's modified
