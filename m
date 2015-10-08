Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:58901 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755911AbbJHWdM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 18:33:12 -0400
Date: Fri, 9 Oct 2015 09:33:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Justin Maggard <jmaggard10@gmail.com>, fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Justin Maggard <jmaggard@netgear.com>
Subject: Re: [PATCH] btrfs: test unmount during quota rescan
Message-ID: <20151008223309.GW27164@dastard>
References: <1444230527-4639-1-git-send-email-jmaggard@netgear.com>
 <CAL3q7H72PVQRXrWhT=uZcww2K+Y7-bZE5u5K4OMnz-FAKT3-ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H72PVQRXrWhT=uZcww2K+Y7-bZE5u5K4OMnz-FAKT3-ZA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 08, 2015 at 10:39:48AM +0100, Filipe Manana wrote:
> On Wed, Oct 7, 2015 at 4:08 PM, Justin Maggard <jmaggard10@gmail.com> wrote:
> > This test case tests if we are able to unmount a filesystem while
> > a quota rescan is running.  Up to now (4.3-rc4) this would result
> > in a kernel NULL pointer dereference.
> 
> Please mention here the title of the patch that fixes this problem
> ("btrfs: qgroup: exit the rescan worker during umount").
> 
> >
> > Signed-off-by: Justin Maggard <jmaggard@netgear.com>
> > ---
> >  tests/btrfs/104     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/104.out |  1 +
> >  tests/btrfs/group   |  1 +
> >  3 files changed, 87 insertions(+)
> >  create mode 100755 tests/btrfs/104
> >  create mode 100644 tests/btrfs/104.out
> >
> > diff --git a/tests/btrfs/104 b/tests/btrfs/104
> > new file mode 100755
> > index 0000000..7c51298
> > --- /dev/null
> > +++ b/tests/btrfs/104
> > @@ -0,0 +1,85 @@
> > +#! /bin/bash
> > +# FS QA Test No. btrfs/200
> 
> 104 (should match the file name)
> 
> > +#
> > +# btrfs quota scan/unmount sanity test
> > +#
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2015 NETGEAR, Inc.  All Rights Reserved.
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
> > +
> > +status=1       # failure is the default!
> > +
> > +_cleanup()
> > +{
> > +       cd /
> > +       rm -f $tmp.*
> > +       $UMOUNT_PROG $loop_mnt >/dev/null 2>&1
> > +       _destroy_loop_device $loop_dev1
> > +       rm -rf $loop_mnt
> > +       rm -f $fs_img1
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
> > +_require_test
> > +
> > +rm -f $seqres.full
> > +
> > +loop_mnt=$TEST_DIR/$seq.$$.mnt
> > +fs_img1=$TEST_DIR/$seq.$$.img1
> > +mkdir $loop_mnt
> > +$XFS_IO_PROG -f -c "truncate 1G" $fs_img1 >>$seqres.full 2>&1
> 
> Don't redirect stdout/stderr here. If the truncate fails, xfs_io
> prints something to stderr, resulting in a test failure due to
> mismatch with the golden output.
> 
> > +
> > +loop_dev1=`_create_loop_device $fs_img1`
> > +
> > +_mkfs_dev $loop_dev1 >>$seqres.full 2>&1
> > +_mount $loop_dev1 $loop_mnt
> 
> Any reason to use a loop device on not the scratch device as most
> other tests do?
> 
> > +for i in 0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p
> > +do
> > +  for j in 0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p
> 
> Coding style in xfstests is:
> 
> for ... ; do
> done
> 
> Also use 8 spaces tabs for indentation.
> 
> > +  do
> > +    for k in 0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p
> > +    do
> > +      for l in 0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p
> > +      do
> > +       touch $loop_mnt/${i}${j}${k}${l}
> > +      done
> > +    done
> > +  done
> > +done >>$seqres.full 2>&1

And, well, it's a strange way of creating 26**4 files.

Why not just:

for i in `seq 0 1 450000`; do
	echo -n > $SCRATCH_MNT/file.$i
done

note that the use of 'echo -n' rather than touch means the test
does not need to fork a new process just to create each file and
so runs much, much faster...

> > +echo 3 > /proc/sys/vm/drop_caches
> > +$BTRFS_UTIL_PROG quota enable $loop_mnt
> > +$UMOUNT_PROG $loop_mnt
> > +
> > +status=0

What's the failure criteria here?

i.e. shouldn't you at least do a quota report and check that it
reports the correct number of inodes in the quota group?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
