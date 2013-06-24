Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:44763 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3FXNd0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 09:33:26 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 25DCB9A036E
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Jun 2013 07:33:26 -0600 (MDT)
Date: Mon, 24 Jun 2013 09:33:23 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Eric Sandeen <sandeen@redhat.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: make fs for 274 larger
Message-ID: <20130624133323.GF4288@localhost.localdomain>
References: <1371846648-21841-1-git-send-email-jbacik@fusionio.com>
 <51C4CB72.9080705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51C4CB72.9080705@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 21, 2013 at 04:53:54PM -0500, Eric Sandeen wrote:
> On 6/21/13 3:30 PM, Josef Bacik wrote:
> > Btrfs will default to mixed block groups for 1 gigabyte file systems and
> > smaller, which means data and metadata share the same area.  This makes
> > generic/274 fail for us because we cannot reserve enough metadata space to do
> > our writes.  Bumping the scratch fs up to 2 gigabytes allows us to do our normal
> > metadata/data seperation and allows us to pass this test.  Thanks,
> 
> It'd be nice if we could force btrfs into the other mode just for this
> test, but it's probably harmless to just make everyone else bigger.
> Makes the test take longer though, another gig to write.
> 
> Did you test other filesystems w/ the change?
> 
> Seems like a reasonable & expedient solution though, so:
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Yeah I tested xfs and ext4 and they worked out right, it takes a little longer
but its like 10-15 seconds so not too big of a deal.  I had thought of making
this test force btrfs to do non-mixed but I didn't want to wire all that up when
we could just jack the size up.  Thanks,

Josef
