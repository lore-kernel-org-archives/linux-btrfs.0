Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47960 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab3J2SaR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 14:30:17 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 153719A06A4
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 12:30:17 -0600 (MDT)
Date: Tue, 29 Oct 2013 14:30:13 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Jeff Mahoney <jeffm@suse.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: incompatible format change to remove hole extents
 V2
Message-ID: <20131029183013.GH4543@localhost.localdomain>
References: <1383054986-21707-1-git-send-email-jbacik@fusionio.com>
 <526FFB38.4030008@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <526FFB38.4030008@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 29, 2013 at 02:15:20PM -0400, Jeff Mahoney wrote:
> On 10/29/13, 9:56 AM, Josef Bacik wrote:
> > Btrfs has always had these filler extent data items for holes in inodes.  This
> > has made somethings very easy, like logging hole punches and sending hole
> > punches.  However for large holey files these extent data items are pure
> > overhead.  So add an incompatible feature to no longer add hole extents to
> > reduce the amount of metadata used by these sort of files.  This has a few
> > changes for logging and send obviously since they will need to detect holes and
> > log/send the holes if there are any.  I've tested this thoroughly with xfstests
> > and it doesn't cause any issues with and without the incompat format set.
> > Thanks,
> 
> This sounds like it could be a candidate for the online-enable mask in
> my feature ioctl patchset.

Yeah once I pull your stuff in I'll add it.  Thanks,

Josef
