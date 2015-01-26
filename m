Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:22334 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757226AbbAZXq6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Jan 2015 18:46:58 -0500
Date: Tue, 27 Jan 2015 10:46:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Xing Gu <gux.fnst@cn.fujitsu.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, eguan@redhat.com
Subject: Re: [PATCH v5] btrfs: add regression test for remount with
 thread_pool resized
Message-ID: <20150126234654.GB7621@dastard>
References: <1422261834-8691-1-git-send-email-gux.fnst@cn.fujitsu.com>
 <54C6097F.8040600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54C6097F.8040600@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 26, 2015 at 05:31:43PM +0800, Qu Wenruo wrote:
> >+# get standard environment, filters and checks
> >+. ./common/rc
> >+. ./common/filter
> >+
> >+# real QA test starts here
> >+_supported_fs btrfs
> >+_supported_os Linux
> >+_require_scratch
> >+
> >+_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
> IMHO, it's better to add a new btrfs_mkfs_filter(or something
> similar) to common/filter.btrfs,
> and modify the btrfs case in common/rc:scratch_mkfs() to use the
> filter to wipe the "Performing TRIM"
> line *ONLY*, as other btrfs filters do.

There's already common/filter:_filter_mkfs which has a $FSTYP switch
in it. That's the place to add any btrfs specific mkfs filters,
either in line or as a callout to a special functionin common/btrfs.

Cheers.

Dave.

-- 
Dave Chinner
david@fromorbit.com
