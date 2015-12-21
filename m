Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:34351 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbbLUARL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Dec 2015 19:17:11 -0500
Date: Mon, 21 Dec 2015 11:16:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Ideas to do custom operation just after mount?
Message-ID: <20151221001654.GM19802@dastard>
References: <56721602.5050204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56721602.5050204@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 17, 2015 at 09:55:14AM +0800, Qu Wenruo wrote:
> Hi,
> 
> Will xfstests provides some API to do some operation just after
> mounting a filesystem?
> 
> Some filesystem(OK, btrfs again) has some function(now qgroup only)
> which needed to be enabled by ioctl instead of mount option.

Irk.

Seriously, I need ot find some time to split all the fs specific
stuff in common/rc into separate files and have each different
filesystem implement it's own version of the relevant functions
like _scratch_mkfs, _scratch_mount, etc.

That will enable btrfs to do truly hideous stuff like this that
admins will hate you for requiring, and the rest of us won't have to
care about it.

> So is there any good idea to do some operation just after mounting
> in xfstests?

You're just going to have to wait a bit - the first piece of this
is in the overlayfs support patches, and the rest of it is in my
local work area in an incomplete state.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
