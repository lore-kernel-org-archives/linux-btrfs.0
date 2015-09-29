Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:6480 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbbI2Vvj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 17:51:39 -0400
Date: Wed, 30 Sep 2015 07:51:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2] fstests: generic: Check if a bull fallocate will
 change extent number
Message-ID: <20150929215135.GZ3902@dastard>
References: <1443519264-19184-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443519264-19184-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 29, 2015 at 05:34:24PM +0800, Qu Wenruo wrote:
> Normally, a bull fallocate call on a fully written and synced file
> should not add an extent.

Why not? Filesystems can do whatever they want with extents during
a fallocate call. e.g. if the blocks are shared, then fallocate
might break the block sharing so future overwrites don't get
ENOSPC. This is a requirement set down by posix_fallocate(3)

"After a successful call to posix_fallocate(), subsequent writes to
bytes in the specified range are guaranteed not  to fail because of
lack of disk space."

Hence if you've got a file with shared blocks, a "full fallocate"
must change the extent layout to break the sharing. As such, the
premise of this test is wrong.

That's not to say that btrfs has a bug:

> Btrfs has a bug to always truncate the last page if the fallocate start
> offset is smaller than inode size.

But it' not clear that this behaviour is actually a bug if it's not
changing the file data.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
