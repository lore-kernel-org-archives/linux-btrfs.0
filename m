Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:22284 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259Ab3CJXD2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 19:03:28 -0400
Date: Mon, 11 Mar 2013 10:03:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Koen De Wit <koen.de.wit@oracle.com>, xfs@oss.sgi.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: xfstests: 301: sparse copy between different
 filesystems/mountpoints on btrfs
Message-ID: <20130310230325.GM23616@dastard>
References: <50F9C331.9000501@oracle.com>
 <513BD2CF.5020204@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <513BD2CF.5020204@sandeen.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 09, 2013 at 06:24:47PM -0600, Eric Sandeen wrote:
> On 1/18/13 3:48 PM, Koen De Wit wrote:
> > +}
> > +
> > +_scratch_mount
> > +_create_reflinks_to $TESTDIR2
> > +_scratch_unmount
> > +
> > +mount $TEST_DEV $SCRATCH_MNT
> > +_create_reflinks_to $TESTDIR3
> > +umount $SCRATCH_MNT
> 
> TBH this confuses me, not that it's necessarily wrong (?)
> You mount TEST_DEV on $SCRATCH_MNT which makes my brain hurt a little.
> Then _create_reflinks_to $TESTDIR3 and at that point, um, what's going on,
> what's linking what to where?

Mounting the TEST_DEV on SCRATCH_MNT is almost always a bad thing to
do. The test harness expects TEST_DEV to be mounted on TEST_DIR, not
anywhere else.

If you need multiple scratch filesystems to test cross-device
linkage errors, use loopback devices or make use of the btrfs
scratch device pool...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
