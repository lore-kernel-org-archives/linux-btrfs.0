Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:46029 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab3AXQwN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 11:52:13 -0500
Date: Thu, 24 Jan 2013 11:52:10 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: fix memory leak on extent map after fsync
Message-ID: <20130124165210.GF2349@localhost.localdomain>
References: <1357656561-24604-1-git-send-email-bo.li.liu@oracle.com>
 <1357656561-24604-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1357656561-24604-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 08, 2013 at 07:49:21AM -0700, Liu Bo wrote:
> During fsync, we put the changed parts(i.e. extent map) into the log tree,
> and we ship these parts from a list of modified_extents to a local list
> to process, of course, we must increment the refs of the extent maps to
> avoid it from getting evicted from cache.
> 
> The problem is
> we don't hold the tree writer lock all the time of iterating the local list,
> and it is possible that other threads hack in and delete the extent map from
> the local list silently.  So we'll end up with memory leak here.
> 
> I hit this when testing xfstest 274 with mount options 'autodefrag,compress=zlib'.
> 
> With this fix, the memory leak has gone away.
> 

And actually I fixed this in one of my other fsync patches that didn't get
pulled in yet, so I'll break it out of that patch and we can send that along.
Thanks,

Josef
