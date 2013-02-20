Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:53802 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933919Ab3BTRyN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 12:54:13 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A55FF9A0691
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 10:54:12 -0700 (MST)
Date: Wed, 20 Feb 2013 12:54:10 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Aastha Mehta <aasthakm@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: basic questions regarding COW in Btrfs
Message-ID: <20130220175410.GB2062@localhost.localdomain>
References: <CAEx9m45BO=McK-NrL3fX7QiJMtf-T+bKoc1D1G=6vHxYT8b36g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAEx9m45BO=McK-NrL3fX7QiJMtf-T+bKoc1D1G=6vHxYT8b36g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 20, 2013 at 10:28:10AM -0700, Aastha Mehta wrote:
> Hello,
> 
> I am trying to understand the COW mechanism in Btrfs. Is it correct to
> say that unless nodatacow option is specified, Btrfs always performs
> COW for all the data+metadata extents used in the system?
> 

So we always cow the metadata, but yes nodatacow means we don't cow the actual
data in the data extents.

> I saw that COWing is implemented in btrfs_cow_block() function, which
> is called at the time of searching a slot for a particular item, while
> inserting into a new slot, committing transactions, while creating
> pending snapshots and few other places.
> 
> However, while tracing through the complete write path, I could not
> quite figure out when extents actually get COWed. Could you please
> point me to the place where COWing takes place? Is there any time
> when, for performance or any other reasons, the extents are not COWed
> but overwritten in place (apart from the explicit nodatacow flag being
> set during mount)?

You'll want to look at the tree operation ->fill_delalloc().  Thats where we do
cow_file_range().  We allocate new space and write.  When we finish the ordered
io we do btrfs_drop_extents() on the range we just wrote which will free up any
existing extents that exist, and then insert our new file extent.  Thanks,

Josef
