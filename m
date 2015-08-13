Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47714 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbbHMDQK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 23:16:10 -0400
Date: Thu, 13 Aug 2015 11:15:46 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] fstests: btrfs regression test for defrag tail extents
Message-ID: <20150813031545.GA920@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1439194379-29290-1-git-send-email-bo.li.liu@oracle.com>
 <CAL3q7H4ubJzTtPQEzvsYbZ0ND=DA-uFo45PbQvo8+Pqt4ZK4Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4ubJzTtPQEzvsYbZ0ND=DA-uFo45PbQvo8+Pqt4ZK4Hw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 10, 2015 at 10:17:52AM +0100, Filipe David Manana wrote:
> On Mon, Aug 10, 2015 at 9:12 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > Regression test for btrfs defragment tool, it's aimed to verify
> > that tail extents won't be skipped as a separate extent while the previous
> > extents have been defrag'ed into a whole extent.
> 
> Thanks for doing this Liu.
> Some comments below.
> 
> >
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  tests/btrfs/098     | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/098.out |  3 +++
> >  tests/btrfs/group   |  1 +
> >  3 files changed, 72 insertions(+)
> >  create mode 100755 tests/btrfs/098
> >  create mode 100644 tests/btrfs/098.out
> >
> > diff --git a/tests/btrfs/098 b/tests/btrfs/098
> > new file mode 100755
> > index 0000000..e4bb38a
> > --- /dev/null
> > +++ b/tests/btrfs/098
> > @@ -0,0 +1,68 @@
> > +#! /bin/bash
> > +# FS QA Test 098
> > +#
> > +# Test if btrfs defrag tool can merge tail extents.
> 
> Well, this wasn't a problem in the tool (btrfs-progs) but rather in
> the kernel's defrag code (same observation regarding the commit
> message).
> 

Ah, that's right, thanks for pointing it out.

> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2015 Liu Bo.  All Rights Reserved.
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
> > +status=1       # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +       cd /
> > +       rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/defrag
> > +
> > +# real QA test starts here
> > +
> > +_supported_fs btrfs
> > +_supported_os Linux
> > +_require_scratch
> > +_require_defrag
> > +
> > +rm -f $seqres.full
> > +
> > +_scratch_mkfs >> $seqres.full 2>&1
> > +_scratch_mount
> > +
> > +$XFS_IO_PROG -f -c "pwrite 0 640k" $SCRATCH_MNT/foobar >> $seqres.full 2>&1
> 
> Shouldn't redirect stdout/stderr to $seqres.full but instead let it be
> part of the golden output (and pipe its output to _filter_xfs_io).
> That's what we do everywhere else.
> 
> > +
> > +# create sparse file layout
> > +for ((i = 160; i > 0; i--)); do
> > +       $XFS_IO_PROG -f -c "pwrite $((($RANDOM % 160) * 4))k 4k" \
> > +               $SCRATCH_MNT/foobar >> $seqres.full 2>&1
> 
> Same here if we could get rid of the random offset (is it really
> needed?). Without this loop (and even without the btrfs fix applied)
> this test succeeds as well - we want to verify the extent count after
> defrag is 1 for this scenario of a sparse file, so we should really
> check these writes actually succeed

I see, will follow the suggestion.

> 
> > +done
> > +
> > +_defrag --after 1 $SCRATCH_MNT/foobar
> > +
> > +# success, all done
> > +status=0
> > +exit
> 
> There doesn't seem to be really anything btrfs specific in this test.
> Any reason to not make it a generic test?

I was thinking that this issue can only occur on btrfs because of COW
and the test was doing in-place overwrite, but now I find that we can
just use generic/018's method to create fragments so that we can make it
generic.

> 
> > diff --git a/tests/btrfs/098.out b/tests/btrfs/098.out
> > new file mode 100644
> > index 0000000..7306733
> > --- /dev/null
> > +++ b/tests/btrfs/098.out
> > @@ -0,0 +1,3 @@
> > +QA output created by 098
> > +Before: in_range(0, -1)
> > +After: 1
> 
> So even without your btrfs fix applied, the test passes, therefore it
> doesn't serve as a regression test for btrfs.
> Can you double check it?

Yes, my miss..  Dave has reminded me of that this case is in fact a part
of generic/018, so I'd add it into generic/018 plus a comment of claming
btrfs regression.

Thanks,

-liubo

> 
> thanks
> 
> > diff --git a/tests/btrfs/group b/tests/btrfs/group
> > index e13865a..392de6d 100644
> > --- a/tests/btrfs/group
> > +++ b/tests/btrfs/group
> > @@ -100,3 +100,4 @@
> >  095 auto quick metadata
> >  096 auto quick clone
> >  097 auto quick send clone
> > +098 auto defrag quick
> > --
> > 1.8.2.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
