Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22054 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbaLQINl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 03:13:41 -0500
Date: Wed, 17 Dec 2014 16:13:29 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] xfstests: btrfs: add test case for qgroup account on
 shared extents
Message-ID: <20141217081328.GA13331@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1418723004-30543-1-git-send-email-bo.li.liu@oracle.com>
 <1418788268-30145-1-git-send-email-bo.li.liu@oracle.com>
 <20141217052531.GH15495@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141217052531.GH15495@dhcp-13-216.nay.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 17, 2014 at 01:25:31PM +0800, Eryu Guan wrote:
> On Wed, Dec 17, 2014 at 11:51:08AM +0800, Liu Bo wrote:
> > This is a regression test of
> > 'commit fcebe4562dec ("Btrfs: rework qgroup accounting")'
> > 
> > It can produce qgroup related warnings.
> 
> The commit is in kernel since May 13, but I still saw warnings on
> 3.18+ kernel and test fails too. Is this expected?

Yes, I just sent the fix,

Btrfs: fix a warning of qgroup account on shared extents
https://patchwork.kernel.org/patch/5499981/

> 
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > v2: - use new seq number 017 instead 080
> >     - use 'cloner' to get shared extents
> >     - use XFS_IO_PROG instead
> > 
> >  tests/btrfs/017     | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/017.out |  3 +++
> >  tests/btrfs/group   |  1 +
> >  3 files changed, 78 insertions(+)
> >  create mode 100755 tests/btrfs/017
> >  create mode 100644 tests/btrfs/017.out
> > 
> > diff --git a/tests/btrfs/017 b/tests/btrfs/017
> > new file mode 100755
> > index 0000000..fc0e671
> > --- /dev/null
> > +++ b/tests/btrfs/017
> > @@ -0,0 +1,74 @@
> > +#! /bin/bash
> > +# FS QA Test No. 017
> > +#
> > +# Regression of 'commit fcebe4562dec ("Btrfs: rework qgroup accounting")',
> > +# this will throw a warning into dmesg.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2014 Liu Bo.  All Rights Reserved.
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
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +    cd /
> > +    rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +
> > +_need_to_be_root
> > +_supported_fs btrfs
> > +_supported_os Linux
> > +_require_scratch
> > +_require_cloner
> > + 
> 
> Trailing whitespace here.
> 
> > +run_check _scratch_mkfs "-b 1g --nodesize 4096"
> 
> Usually this can be done by _scratch_mkfs_sized, but it doesn't accept
> additional mkfs options, given that usually scratch dev is bigger than
> 1G, so I think using _scratch_mkfs is fine here.
> 
> > +run_check _scratch_mount
> > +
> > +run_check $XFS_IO_PROG -f -d -c "pwrite 0 8K" $SCRATCH_MNT/foo
> > +
> > +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap
> > +
> > +run_check $CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo-reflink
> > +run_check $CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink
> > +run_check $CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink2
> > +
> > +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> > +_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
> > +
> > +rm -fr $SCRATCH_MNT/* >/dev/null 2>&1
> > +
> > +_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
> > +
> > +$BTRFS_UTIL_PROG qgroup show $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' | $AWK_PROG '{print $2" "$3}'
> 
> It'd be better to add some comments to explain the test steps, the
> kernel commit is big and it's not obvious to me why these magic
> steps could trigger kernel warning :)

Well, I'll add the fix link that could explain a bit.

> 
> Anyway,
> 
> Reviewed-by: Eryu Guan <eguan@redhat.com>
> 

Thanks!

-liubo

> Thanks,
> Eryu
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/btrfs/017.out b/tests/btrfs/017.out
> > new file mode 100644
> > index 0000000..e25e631
> > --- /dev/null
> > +++ b/tests/btrfs/017.out
> > @@ -0,0 +1,3 @@
> > +QA output created by 017
> > +4096 4096
> > +4096 4096
> > diff --git a/tests/btrfs/group b/tests/btrfs/group
> > index abb2fe4..e29999b 100644
> > --- a/tests/btrfs/group
> > +++ b/tests/btrfs/group
> > @@ -19,6 +19,7 @@
> >  014 auto balance
> >  015 auto quick snapshot
> >  016 auto quick send
> > +017 auto quick qgroup
> >  018 auto quick subvol
> >  019 auto quick send
> >  020 auto quick replace
> > -- 
> > 1.8.2.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
