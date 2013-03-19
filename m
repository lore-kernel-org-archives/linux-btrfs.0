Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:6003 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933653Ab3CSTby (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 15:31:54 -0400
Date: Wed, 20 Mar 2013 06:31:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com,
        alex.btrfs@zadarastorage.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: add background noise to test 276 (btrfs
 backref resolving)
Message-ID: <20130319193152.GD6369@dastard>
References: <1363710260-10225-1-git-send-email-list.btrfs@jan-o-sch.net>
 <51489BD6.6030504@sandeen.net>
 <5148B9E5.5000702@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5148B9E5.5000702@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 19, 2013 at 08:17:57PM +0100, Jan Schmidt wrote:
> On 19.03.2013 18:09, Eric Sandeen wrote:
> >> Furthermore, this increases two constants which make the test simply cycle a
> >> few seconds longer, increasing the chance to hit on something suspicious in
> >> case we broke something.
> > 
> > Normally we don't change existing tests lest new failures look like regressions
> > when they aren't, but hey, "btrfs is an experimental filesystem" so maybe it's
> > ok in this case.  ;)  At some point when things are settled down, we wouldn't
> > want to make a change like this.  But for now it doesn't bother me.
> 
> (justification) I thought about adding this modification as a separate
> test - and I have no strict objections against doing so. It's just that
> I hate duplicating code and I couldn't think of a good way to share all
> that code between two individual tests.

The current way is to use a common.<blah> file to do it.

However, using test templates is the way I want to do it in future -
it will be perfect for these sorts of test variations:

http://oss.sgi.com/archives/xfs/2013-03/msg00578.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
