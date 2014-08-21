Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:48179 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791AbaHUJBK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 05:01:10 -0400
Date: Thu, 21 Aug 2014 19:01:05 +1000
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/15] btrfs: new test to run btrfs balance and subvolume
 test simultaneously
Message-ID: <20140821090105.GJ26465@dastard>
References: <1408556044-907-1-git-send-email-eguan@redhat.com>
 <1408556044-907-3-git-send-email-eguan@redhat.com>
 <53F553AE.5060707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <53F553AE.5060707@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 21, 2014 at 10:04:30AM +0800, Qu Wenruo wrote:
> 
> -------- Original Message --------
> Subject: [PATCH 01/15] btrfs: new test to run btrfs balance and
> subvolume test simultaneously
> From: Eryu Guan <eguan@redhat.com>
> To: <fstests@vger.kernel.org>
> Date: 2014年08月21日 01:33
> >Run btrfs balance and subvolume create/mount/umount/delete simultaneously,
> >with fsstress running in background.
> >
> >Signed-off-by: Eryu Guan <eguan@redhat.com>
> >---
> >  tests/btrfs/057     | 147 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/057.out |   2 +
> >  tests/btrfs/group   |   1 +
> >  3 files changed, 150 insertions(+)
> >  create mode 100755 tests/btrfs/057
> >  create mode 100644 tests/btrfs/057.out
> >
> >diff --git a/tests/btrfs/057 b/tests/btrfs/057
> >new file mode 100755
> >index 0000000..2f507a7
> >--- /dev/null
> >+++ b/tests/btrfs/057
> >@@ -0,0 +1,147 @@
> >+#! /bin/bash
> >+# FSQA Test No. btrfs/057
> >+#
> >+# Run btrfs balance and subvolume create/mount/umount/delete simultaneously,
> >+# with fsstress running in background.
> >+#
> >+#-----------------------------------------------------------------------
> >+# Copyright (C) 2014 Red Hat Inc. All rights reserved.
> >+#
> >+# This program is free software; you can redistribute it and/or
> >+# modify it under the terms of the GNU General Public License as
> >+# published by the Free Software Foundation.
> >+#
> >+# This program is distributed in the hope that it would be useful,
> >+# but WITHOUT ANY WARRANTY; without even the implied warranty of
> >+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >+# GNU General Public License for more details.
> >+#
> >+# You should have received a copy of the GNU General Public License
> >+# along with this program; if not, write the Free Software Foundation,
> >+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> >+#
> >+#-----------------------------------------------------------------------
> >+#
> >+
> >+seq=`basename $0`
> >+seqres=$RESULT_DIR/$seq
> >+echo "QA output created by $seq"
> >+
> >+here=`pwd`
> >+tmp=/tmp/$$
> >+status=1
> >+trap "_cleanup; exit \$status" 0 1 2 3 15
> >+
> >+_cleanup()
> >+{
> >+	cd /
> >+	rm -fr $tmp.*
> >+}
> >+
> >+# get standard environment, filters and checks
> >+. ./common/rc
> >+. ./common/filter
> >+
> >+# real QA test starts here
> >+_supported_fs btrfs
> >+_supported_os Linux
> >+_require_scratch
> >+_require_scratch_dev_pool 4
> >+
> >+rm -f $seqres.full
> >+
> >+# test case array
> >+tcs=(
> >+	"-m single -d single"
> >+	"-m dup -d single"
> >+	"-m raid0 -d raid0"
> >+	"-m raid1 -d raid0"
> >+	"-m raid1 -d raid1"
> >+	"-m raid10 -d raid10"
> >+	"-m raid5 -d raid5"
> >+	"-m raid6 -d raid6"
> >+)
> I wonder should we add the mkfs options there.
> Since xfstests already use environment MKFS_OPTIONS to do mkfs,
> if really need to test all mkfs options, IMO it is better to change
> MKFS_OPTIONS on each test round.

Hmmm - I you didn't read the code, because:

> >+run_test()
> >+{
> >+	local mkfs_opts=$1
> >+	local saved_mkfs_opts=$MKFS_OPTIONS
> >+	local subvol_mnt=$tmp.mnt
> >+
> >+	echo "Test $mkfs_opts" >>$seqres.full
> >+
> >+	MKFS_OPTIONS="$MKFS_OPTIONS $mkfs_opts"
> >+	# dup only works on single device

it's doing exactly what you suggest.

And it's wrong. This:

_scratch_mkfs $mkfs_opts

is all that is needed. This wheel does not need reinventing. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
