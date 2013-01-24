Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:36900 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab3AXQof (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 11:44:35 -0500
Date: Thu, 24 Jan 2013 11:44:33 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: fix memory leak on extent map after fsync
Message-ID: <20130124164433.GE2349@localhost.localdomain>
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

This isn't going to work, we use the LOGGING flag to make sure the em isn't
merged as well.  Thanks,

Josef
