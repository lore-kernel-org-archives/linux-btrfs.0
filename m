Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([125.16.236.4]:38952 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbcCURCn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 13:02:43 -0400
Received: from localhost
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 21 Mar 2016 22:32:40 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay05.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2LH25ig61407316
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 22:32:06 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2LMVHPQ017933
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 04:01:18 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: make sure we stay inside the bvec during __btrfs_lookup_bio_sums
Date: Mon, 21 Mar 2016 22:32:33 +0530
Message-ID: <10889043.sdhK3zvePA@localhost.localdomain>
In-Reply-To: <20160321150014.hod3ktlnpaxbx2u7@floor.thefacebook.com>
References: <20160321150014.hod3ktlnpaxbx2u7@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 21 Mar 2016 11:00:14 Chris Mason wrote:
> Hi everyone,
> 
> I realized last week that CONFIG_DEBUG_PAGEALLOC had dropped out of my
> config, and hit a crash inside __btrfs_lookup_bio_sums once I enabled it
> again.  It's hard for this bug to cause problems because Chandan's inner
> loop is always done at the same time the outer loop is done.  Without my
> goto, it's just exiting normally, but only after reading bvec->bv_len
> (which isn't valid).
> 
> I have this on top of my integration-4.6.  Once things pass I'll
> send a pull later today or Tuesday morning:
> 
> Commit c40a3d38aff4e1c (Btrfs: Compute and look up csums based on
> sectorsized blocks) changes around how we walk the bios while looking up
> crcs.  There's an inner loop that is jumping to the next bvec based on
> sectors and before it derefs the next bvec, it needs to make sure we're
> still in the bio.
> 
> In this case, the outer loop would have decided to stop moving forward
> too, and the bvec deref is never actually used for anything.  But
> CONFIG_DEBUG_PAGEALLOC catches it because we're outside our bio.
>

Chris, Thanks for finding the issue and fixing it. From now onwards, I will
make sure that I have CONFIG_DEBUG_PAGEALLOC enabled on my test kernel build
config.

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan

