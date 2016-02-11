Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:51742 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbcBKFnR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 00:43:17 -0500
Received: from localhost
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 11 Feb 2016 15:43:15 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 328B1357803F
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 16:43:11 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u1B5h2Iu62128318
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 16:43:11 +1100
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u1B5gb7T019759
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 16:42:38 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: dsterba@suse.cz
Cc: bo.li.liu@oracle.com, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [RFC PATCH V11 01/21] Btrfs: subpagesize-blocksize: Fix whole page read.
Date: Thu, 11 Feb 2016 11:12:19 +0530
Message-ID: <8178488.APUmxNEtXs@localhost.localdomain>
In-Reply-To: <20160210103924.GC30511@twin.jikos.cz>
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com> <2574653.62sO1fmDVj@localhost.localdomain> <20160210103924.GC30511@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 10 Feb 2016 11:39:25 David Sterba wrote:
> 
> The explanations and the table would be good in the changelog and as
> comments. I think we'll need to consider the smaller blocks more often
> so some examples and locking rules would be useful, eg. documented in
> this file.

David, I agree.  As suggested, I will add the documentation to the commit
message and as comments in the code.

-- 
chandan

