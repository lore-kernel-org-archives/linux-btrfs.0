Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:6299 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757217Ab3K0Ava (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 19:51:30 -0500
Date: Wed, 27 Nov 2013 11:51:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: missing /sbin/fsck.btrfs
Message-ID: <20131127005126.GC10988@dastard>
References: <13F547BC-D81C-45FB-9DC8-9C076B8605EF@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <13F547BC-D81C-45FB-9DC8-9C076B8605EF@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 25, 2013 at 11:40:49PM -0700, Chris Murphy wrote:
> Hi,
> 
> Is there supposed to be an /sbin/fsck.btrfs? I'm seeing a handful
> of threads indicating some idea of having it just do a no-op like
> fsck.xfs does, but then also the idea that /etc/fstab should
> correctly set fs_passno to 0 instead of such trickery.

You're missing a key thing that fsck.xfs does that fstab expects to
work - it fails with an error if the device is missing. If the
device is present, then fsck.xfs returns success.

We did this because people were having problems when devices took a
long time to instantiate (e.g. SAN, iscsi and other remote devices)
and the 'device exists' check prevents /etc/fstab trying to mount
the filesystems before they are present and then throwing a hissy
fit....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
