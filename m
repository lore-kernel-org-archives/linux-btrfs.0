Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:10324 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754579AbcCOCmt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 22:42:49 -0400
Date: Tue, 15 Mar 2016 13:42:30 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/6] Btrfs in-band de-duplication test cases
Message-ID: <20160315024230.GB30721@dastard>
References: <1457512424-9215-1-git-send-email-quwenruo@cn.fujitsu.com>
 <56E66EBF.8000105@cn.fujitsu.com>
 <20160314172430.GA5769@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160314172430.GA5769@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 14, 2016 at 10:24:30AM -0700, Darrick J. Wong wrote:
> On Mon, Mar 14, 2016 at 03:56:47PM +0800, Qu Wenruo wrote:
> > Please don't merge this patchset.
> > 
> > As the there is some naming undecided recently.
> > 
> > The abbreviation 'dedup' may be changed to 'dedupe'.
> > I'll update them when all related parts is settled down.
> 
> There's already a 'dedupe' group in xfstests for testing the out-of-band ioctl
> that duperemove uses.  I wondered if that factored into your decision to use
> 'dedup' as the group name for the inband tests.
> 
> Seeing as other filesystems are beginning to support the OOB ioctls and might
> never support the in-band stuff btrfs is doing, what do people think about
> keeping the out-of and in-band dedup tests in separate groups to make it clear
> which dedupe feature each test is aiming to validate?

So just name the two groups appropriately: "ib-dedupe" and
"oob-dedupe" or something like that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
