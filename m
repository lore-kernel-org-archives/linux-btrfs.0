Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:44766 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317Ab3HMP6P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:15 -0400
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 13 Aug 2013 21:19:35 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 1CF083940053
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 21:28:01 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r7DFxSYF22544536
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 21:29:29 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r7DFw8iA029539
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 21:28:08 +0530
From: chandan <chandan@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, sekharan@linux.vnet.ibm.com
Subject: Re: [PATCH] _test_generic_punch: Extend $testfile's size to work with 64k block.
Date: Tue, 13 Aug 2013 21:28:06 +0530
Message-ID: <1795219.CLAn9GhObP@localhost.localdomain>
In-Reply-To: <20130812011155.GL12779@dastard>
References: <3326777.u9YeDIQiYF@localhost.localdomain> <20130812011155.GL12779@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Dave,

> So, to do this properly, I'd suggest that the code needs to scale
> the offset/size of the IO being done by the filesystem block size,
> not use a fixed size. Using a filter on the bmap output to handle
> the different block ranges will ensure everything works correctly
> from a golden output POV, except for one thing - the md5sum.
> 
Yes, we did try the approach of using variable block size and scaling
the offset values in the filter function. But we got stuck
working with md5sum (since we would need two sets of md5sums (with and
without '-k' option) per block size). As suggested, I will be
reposting the patch to use "_requires_le_4k_blocksize".

chandan

