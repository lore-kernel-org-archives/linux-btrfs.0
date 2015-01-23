Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:52161 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881AbbAWWbI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 17:31:08 -0500
Date: Sat, 24 Jan 2015 09:30:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Xing Gu <gux.fnst@cn.fujitsu.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com
Subject: Re: [PATCH v4] btrfs: add regression test for remount with
 thread_pool resized
Message-ID: <20150123223034.GO16552@dastard>
References: <1421998139-15881-1-git-send-email-gux.fnst@cn.fujitsu.com>
 <20150123123637.GQ3094@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150123123637.GQ3094@dhcp-13-216.nay.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 23, 2015 at 08:36:37PM +0800, Eryu Guan wrote:
> On Fri, Jan 23, 2015 at 03:28:59PM +0800, Xing Gu wrote:
> > Regression test for a btrfs issue of resizing 'thread_pool' when
> > remount the fs.
> > 
> > This regression was introduced by the following linux kernel commit:
> >     btrfs: Added btrfs_workqueue_struct implemented ordered
> >     execution based on kernel workqueue
> >     08a9ff3264181986d1d692a4e6fce3669700c9f8
> > And it was fixed by the following linux kernel commit:
> >     btrfs: fix crash in remount(thread_pool=) case
> >     800ee2247f483b6d05ed47ef3bbc90b56451746c
> > 
> > Signed-off-by: Xing Gu <gux.fnst@cn.fujitsu.com>
> > ---
> >  v3->v4: Remove the check for a bug message.
> > 
> >  v2->v3: Add the regresssion commit in description.
> >          Remove "dmesg -c > /dev/null".
> >          Echo "Silence is golden" to indicate that an empty output
> >          file is expected.
> > 
> >  v1->v2: Add the fix commit in description.
> >          Add the check for a bug message.
> > ---
> >  tests/btrfs/082     | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/082.out |  2 ++
> >  tests/btrfs/group   |  1 +
> >  3 files changed, 68 insertions(+)
> >  create mode 100755 tests/btrfs/082
> >  create mode 100644 tests/btrfs/082.out
> > 
> > diff --git a/tests/btrfs/082 b/tests/btrfs/082
> > new file mode 100755
> > index 0000000..7a6e4b5
> > --- /dev/null
> > +++ b/tests/btrfs/082
> > @@ -0,0 +1,65 @@
> > +#!/bin/bash
> > +# FS QA Test No. btrfs/082
> > +#
> > +# Regression test for a btrfs issue of resizing 'thread_pool' when
> > +# remount the fs.
> > +#
> > +# This regression was introduced by the following linux kernel commit:
> > +#     btrfs: Added btrfs_workqueue_struct implemented ordered
> > +#     execution based on kernel workqueue
> > +#     08a9ff3264181986d1d692a4e6fce3669700c9f8
> > +# And it was fixed by the following linux kernel commit:
> > +#     btrfs: fix crash in remount(thread_pool=) case
> > +#     800ee2247f483b6d05ed47ef3bbc90b56451746c
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2015 Fujitsu.  All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#
> > +#-----------------------------------------------------------------------
> > +#
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +
> > +_cleanup()
> > +{
> > +    rm -f $tmp.*
> > +}
> > +
> > +trap "_cleanup ; exit \$status" 0 1 2 3 15
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs btrfs
> > +_supported_os Linux
> > +_require_scratch
> > +
> > +_scratch_mkfs > /dev/null
> 
> Redirect stderr to /dev/null too, otherwise test fails if scratch device
> supports trim.
> 
> btrfs/082 0s ... - output mismatch (see /root/xfstests/results//btrfs/082.out.bad)
>     --- tests/btrfs/082.out     2015-01-23 20:27:15.603689913 +0800
>     +++ /root/xfstests/results//btrfs/082.out.bad       2015-01-23 20:33:46.514259626 +0800
>     @@ -1,2 +1,3 @@
>      QA output created by 082
>     +Performing full device TRIM (5.00GiB) ...
>      Silence is golden

I think the internal btrfs mkfs call needs to filter that so that
error messages are still caught by the test.

In fact, I'll go as far as to suggest that outputting operational
status information on stderr is a bug/regression in mkfs.btrfs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
