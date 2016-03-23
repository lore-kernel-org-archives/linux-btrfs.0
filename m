Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbcCWHiN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 03:38:13 -0400
Date: Wed, 23 Mar 2016 15:38:07 +0800
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: _fail the tests if _scratch_mount failed to
 avoid fully filling root fs
Message-ID: <20160323073807.GP11419@eguan.usersys.redhat.com>
References: <1458545021-23285-1-git-send-email-eguan@redhat.com>
 <20160323000856.GY11812@dastard>
 <20160323032329.GM11419@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160323032329.GM11419@eguan.usersys.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 23, 2016 at 11:23:29AM +0800, Eryu Guan wrote:
> On Wed, Mar 23, 2016 at 11:08:56AM +1100, Dave Chinner wrote:
> > On Mon, Mar 21, 2016 at 03:23:41PM +0800, Eryu Guan wrote:
> > > btrfs failed to mount small fs on ppc64 host with error ENOSPC, even
> > > creating such small fs succeeded, then generic/027 consumed all free
> > > space on root fs not on SCRATCH_DEV and test harness cannot create tmp
> > > files and continue other tests.
> > > 
> > > Though I think it's a btrfs bug, it's still worth preventing this
> > > situation from happening in the harness, as such tests usually aim to
> > > exercise fs on ENOSPC conditions, there's no point to continue if the
> > > small fs is not mounted.
> > 
> > I think the btrfs bug should be fixed. At minimum, the workaround to
> > see if the filesytem can be mounted should be in btrfs's
> > implementation of scratch_mkfs_sized....
> 
> OK, I'll add workaround in _scratch_mkfs_sized. Thanks for reviewing!

I think about it another time, I agree that what really should be fixed
is the btrfs bug, not fstests. I'll drop this patch and report bug to
btrfs list.

Thanks,
Eryu
