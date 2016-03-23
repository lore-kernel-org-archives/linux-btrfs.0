Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:51473 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819AbcCWAJL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 20:09:11 -0400
Date: Wed, 23 Mar 2016 11:08:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: _fail the tests if _scratch_mount failed to
 avoid fully filling root fs
Message-ID: <20160323000856.GY11812@dastard>
References: <1458545021-23285-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458545021-23285-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 03:23:41PM +0800, Eryu Guan wrote:
> btrfs failed to mount small fs on ppc64 host with error ENOSPC, even
> creating such small fs succeeded, then generic/027 consumed all free
> space on root fs not on SCRATCH_DEV and test harness cannot create tmp
> files and continue other tests.
> 
> Though I think it's a btrfs bug, it's still worth preventing this
> situation from happening in the harness, as such tests usually aim to
> exercise fs on ENOSPC conditions, there's no point to continue if the
> small fs is not mounted.

I think the btrfs bug should be fixed. At minimum, the workaround to
see if the filesytem can be mounted should be in btrfs's
implementation of scratch_mkfs_sized....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
