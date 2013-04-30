Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:63057 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741Ab3D3Hih (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 03:38:37 -0400
Date: Tue, 30 Apr 2013 17:38:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey V3
Message-ID: <20130430073833.GI23072@dastard>
References: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 26, 2013 at 03:13:59PM -0400, Josef Bacik wrote:
> This test sets up a dm flakey target and then runs my fsync tester I've been
> using to verify btrfs's fsync() is working properly.  It will create a dm flakey
> device, mount it, run my test, make the flakey device start dropping writes, and
> then unmount the fs.  Then we mount it back up and make sure the md5sums match
> and then run fsck on the device to make sure we got a consistent fs.  I used the
> output from a run on BTRFS since it's the only one that passes this test
> properly.  I verified each test manually to make sure they were in fact valid
> files.  XFS and Ext4 both fail this test in one way or another.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V2->V3:
> -encorporate all of Dave Chinners feedback
> -expand the testing to run the tests with normal dmsetup suspend and with
>  --nolockfs

I haven't tested the new version yet, but all the changes I asked
for look good now.

Acked-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
