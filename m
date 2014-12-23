Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:7327 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbaLWU4U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 15:56:20 -0500
Date: Wed, 24 Dec 2014 07:56:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Xing Gu <gux.fnst@cn.fujitsu.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, slyfox@gentoo.org,
        quwenruo@cn.fujitsu.com
Subject: Re: [PATCH v2] btrfs: add regression test for remount with
 thread_pool resized
Message-ID: <20141223205607.GH4521@dastard>
References: <1401439971-18589-1-git-send-email-gux.fnst@cn.fujitsu.com>
 <1419313262-3664-1-git-send-email-gux.fnst@cn.fujitsu.com>
 <20141223072310.GL11929@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141223072310.GL11929@dhcp-13-216.nay.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 23, 2014 at 03:23:10PM +0800, Eryu Guan wrote:
> On Tue, Dec 23, 2014 at 01:41:02PM +0800, Xing Gu wrote:
> > Regression test for a btrfs issue of resizing 'thread_pool'
> > when remount the fs.
> > 
> > Signed-off-by: Xing Gu <gux.fnst@cn.fujitsu.com>
> > ---
> >  tests/btrfs/017     | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/017.out |  1 +
> >  tests/btrfs/group   |  1 +
> >  3 files changed, 66 insertions(+)
> >  create mode 100755 tests/btrfs/017
> >  create mode 100644 tests/btrfs/017.out
> > 
> > diff --git a/tests/btrfs/017 b/tests/btrfs/017
> > new file mode 100755
> > index 0000000..81f5af6
> > --- /dev/null
> > +++ b/tests/btrfs/017
> > @@ -0,0 +1,64 @@
> > +#!/bin/bash
> > +# FS QA Test No. btrfs/017
> > +#
> > +# Regression test for a btrfs issue of resizing 'thread_pool' when
> > +# remount the fs.
> > +# This was fixed in the following linux kernel patch:
> > +#     800ee22 btrfs: fix crash in remount(thread_pool=) case
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2014 Fujitsu.  All Rights Reserved.
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
> > +
> > +dmesg -c > /dev/null
> > +nr_null=`dmesg | grep -c "kernel NULL pointer dereference"`
> 
> dmesg -c cleared dmesg buffer and nr_null is zero, I think this is
> duplicated work, either dmesg -c or check nr_null before remount.

Please don't clear the dmesg buffer - it means that people can't
review the kernel error messages across the entire test run for
errors unless they are capturing that information elsewhere.

And yes, I don't use syslog for capturing dmesg output on my test
boxes because that leads to root filesystem ENOSPC whenever I'm
dumping a lot of debug to the console....

> Actually I'm thinking about checking dmesg log in check after each test,
> which could detect kernel BUG, WARNING and NULL pointer dereference etc.
> so test doesn't need to check dmesg itself. I'll send it out for review
> soon.

Some tests actually generate errors/warnings on purpose. IOWs, the
presence of messages in dmesg is not always indicative of an
error....

> > +_scratch_mount "-o remount,thread_pool=10"
> > +new_null=`dmesg | grep -c "kernel NULL pointer dereference"`
> > +if [ $new_null -ne $nr_null ]; then
> > +	_fatal "kernel bug detected, check dmesg for more infomation."
> 
> _fail is better than _fatal, and don't forget to remove $seqres.full before
> test if you use _fail, cause it dumps errors to $seqres.full
> 
> But simply echo the error message could fail the test too, I'm fine with
> either way..

Echo the error message, set status=1 and exit.

Oh, wait, that's what _fail does. ;)

> > +exit
> > diff --git a/tests/btrfs/017.out b/tests/btrfs/017.out
> > new file mode 100644
> > index 0000000..90c4b69
> > --- /dev/null
> > +++ b/tests/btrfs/017.out
> > @@ -0,0 +1 @@
> > +QA output created by 017

Empty output with no indication that it should be empty is bad form
as well. The test should echo something to indicate that an empty
output file is expected. "Silence is golden" is the usual string
used to indicate that the golden output expects no output from the
test.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
