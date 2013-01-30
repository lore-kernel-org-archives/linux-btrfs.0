Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:46345
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754924Ab3A3Svt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 13:51:49 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: RAID 0 across SSD and HDD
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130130100201.GN16285@carfax.org.uk>
Date: Wed, 30 Jan 2013 11:51:46 -0700
Cc: Roger Binns <rogerb@rogerbinns.com>, linux-btrfs@vger.kernel.org
Message-Id: <0D51C9F2-0AD6-47A0-AA38-1E307BEAD669@colorremedies.com>
References: <keap27$oqb$1@ger.gmane.org> <20130130100201.GN16285@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 30, 2013, at 3:02 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

> 
>   That would be the case with "single" mode, not with RAID-0.
> 
>   With RAID-0, you'd get data striped equally across all (in this
> case, both) the devices, up to the size of the second-largest one, at
> which point it'll stop allocating space.

This raises a question about the desirability/feasibility of changing this behavior. It's common to have odd sized disks. It's unfortunate that most of the life of a 'single' paring of disks, there is no performance improvement possible; and also unfortunate that in 'raid0' it doesn't fall back to 'single' behavior to fill up the remaining space, instead of ending allocation.

md raid0 will work on odd sized block devices, and it will fill up all the space. Presumably it does this by allocating chunks round robbin, and the point where a block device is full, it just starts allocating more chunks to the device(s) that have space. This means there's a distinction in behavior between md's level 'raid10' and separately creating "a stripe of mirrors", i.e. first creating raid1 arrays, then striping them with raid0.

Chris Murphy