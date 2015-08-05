Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:18802 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701AbbHEDLL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Aug 2015 23:11:11 -0400
Date: Wed, 5 Aug 2015 13:10:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v2] fstests: btrfs: Add regression test for reserved
 space leak.
Message-ID: <20150805031056.GB3902@dastard>
References: <1438736914-28147-1-git-send-email-quwenruo@cn.fujitsu.com>
 <55C16631.1060505@jp.fujitsu.com>
 <55C16957.1010802@cn.fujitsu.com>
 <20150805015732.GZ3902@dastard>
 <55C17A74.3050402@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55C17A74.3050402@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 05, 2015 at 11:52:36AM +0900, Tsutomu Itoh wrote:
> On 2015/08/05 10:57, Dave Chinner wrote:
> >On Wed, Aug 05, 2015 at 09:39:35AM +0800, Qu Wenruo wrote:
> >>Tsutomu Itoh wrote on 2015/08/05 10:26 +0900:
> >>>On 2015/08/05 10:08, Qu Wenruo wrote:
> >>>>+# As the reserved space freeing happens at commit_transaction time,
> >>>>+# without a transaction commit, no reserved space needs freeing and
> >>>>+# won't trigger the bug.
> >>>>+sync
> >>>
> >>>Isn't '$BTRFS_UTIL_PROG filesystem sync' better instead of 'sync'?
> >>>
> >>>Thanks,
> >>>Tsutomu
> >>Hi, Tsutomu-san,
> >>
> >>Yes, I did use such method before, but Dave said it's better to use
> >>unified interface to sync a filesystem other than the specialized
> >>one.
> >>
> >>So I still use sync as Dave said.
> >
> >Mainly because "sync" is what users will use to make sure their data
> >is safe. filesystem specific tools have a habit of doing "special
> >stuff" to sync a filesystem, so it may not reflect the way users
> >expect the system to behaviour when they run sync.
> >
> >The other option is this:
> >
> >_syncfs()
> >{
> >	mntpt=$1
> >
> >	$XFS_IO_PROG -c syncfs $mntpt
> >}
> >
> >_sync_test()
> >{
> >	_syncfs $TEST_DIR
> >}
> >
> >_sync_scratch()
> >{
> >	_syncfs $SCRATCH_MNT
> >}
> >
> >which only runs sync on the filesystem that needs syncing (via the
> >syncfs() syscall)
> 
> I think that syncfs is better instead of sync because the syncing of
> the specified filesystem is necessary.

sync guarantees that. IOWs, there's no difference between sync and
syncfs for the persepctive of this test and so the test does not
need really need changing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
