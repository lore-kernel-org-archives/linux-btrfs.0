Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:52190 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761301Ab2KAOn0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 10:43:26 -0400
Date: Thu, 1 Nov 2012 10:43:23 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: make snapshot-aware defrag as a mount option
Message-ID: <20121101144323.GB8307@shiny>
References: <1351333721-3220-1-git-send-email-bo.li.liu@oracle.com>
 <1351333721-3220-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1351333721-3220-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 27, 2012 at 04:28:41AM -0600, Liu Bo wrote:
> This feature works on our crucial write endio path, so if we've got
> lots of fragments to process, it will be kind of a disaster to the
> performance, so I make such a change.
> 
> One can benifit from it while mounting with '-o snap_aware_defrag'.

I think we should always prefer to maintain snapshot cloning as much as
possible, and have a specific option to defrag that makes it break the
clone in favor of removing fragmentation.

So, please keep the snapshot aware defrag the default ;)

Thanks for taking these patches up again!

-chris
