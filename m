Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:49730 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab3A1VXe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 16:23:34 -0500
Date: Mon, 28 Jan 2013 16:23:31 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Jim Schutt <jaschut@sandia.gov>
CC: Josef Bacik <JBacik@fusionio.com>, Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix a deadlock on chunk mutex
Message-ID: <20130128212331.GG3257@localhost.localdomain>
References: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>
 <20121218135242.GC2403@localhost.localdomain>
 <50E5D19E.3060406@sandia.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50E5D19E.3060406@sandia.gov>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 03, 2013 at 11:44:46AM -0700, Jim Schutt wrote:
> Hi Josef,
> 
> Thanks for the patch - sorry for the long delay in testing...
> 

Jim,

I've been trying to reason out how this happens, could you do a btrfs fi df on
the filesystem thats giving you trouble so I can see if what I think is
happening is what's actually happening.  Thanks,

Josef
