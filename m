Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:43646 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3HURbV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Aug 2013 13:31:21 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 3BC3B9A04E0
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Aug 2013 11:31:21 -0600 (MDT)
Date: Wed, 21 Aug 2013 13:31:19 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Eric Sandeen <sandeen@sandeen.net>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests: btrfs/003: stat the dev we're removing to make
 sure its' really gone
Message-ID: <20130821173119.GN3990@localhost.localdomain>
References: <1377101015-3070-1-git-send-email-jbacik@fusionio.com>
 <5214EE7F.8090507@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5214EE7F.8090507@sandeen.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 21, 2013 at 11:44:47AM -0500, Eric Sandeen wrote:
> On 8/21/13 11:03 AM, Josef Bacik wrote:
> > I've been periodically failing btrfs/003 because my box sometimes takes a little
> > longer to unregister the device when we remove it and so the output from btrfs
> > dev show doesn't match what we are wanting since it still sees the device.  To
> > fix this just stat and sleep if we still see the device node and only continue
> > once udev or whatever actually removes the device node so that we don't get
> > random failures.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> >  tests/btrfs/003 |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/tests/btrfs/003 b/tests/btrfs/003
> > index 5c88651..dba1a32 100755
> > --- a/tests/btrfs/003
> > +++ b/tests/btrfs/003
> > @@ -145,6 +145,12 @@ _test_replace()
> >  	_devmgt_remove ${DEVHTL}
> >  	dev_removed=1
> >  
> 
> This should probably go into _devmgt_remove,
> and possibly the reverse in _devmgmt_add as well, with
> a comment explaining what it's doing?
> 
> Otherwise someone else will run into the same problem down the line.
> 

No, the next guy will have to go as much pain and annoyance as I did to make
sure he is worthy of the fix.  Thanks,

Josef
