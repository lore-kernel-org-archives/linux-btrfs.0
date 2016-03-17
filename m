Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21716 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbcCQEOE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 00:14:04 -0400
Date: Wed, 16 Mar 2016 21:13:57 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] fstest: btrfs: test single 4k extent after
 subpagesize buffered writes
Message-ID: <20160317041357.GB29904@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1457394467-1245-1-git-send-email-bo.li.liu@oracle.com>
 <1457396879-30572-1-git-send-email-bo.li.liu@oracle.com>
 <20160315033941.GE30721@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160315033941.GE30721@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 15, 2016 at 02:39:41PM +1100, Dave Chinner wrote:
> On Mon, Mar 07, 2016 at 04:27:59PM -0800, Liu Bo wrote:
> > This is to test if COW enabled btrfs can end up with single 4k extents
> > when doing subpagesize buffered writes.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> ....
> > +_scratch_mkfs >> $seqres.full 2>&1
> > +_scratch_mount
> > +
> > +default_expire=`cat /proc/sys/vm/dirty_expire_centisecs`
> > +echo 50 > /proc/sys/vm/dirty_expire_centisecs
> 
> why?

Setting it to 50 is to flush dirty pages more frequently so that it's
more likely to reproduce this bug.

But I just realized that this may not be a good testcase for xfstests as
there're many factors impacting writeback flushing, which means this may
work well on my machine but may not trigger the bug on others' machines.

> 
> > +tfile=$SCRATCH_MNT/testfile
> > +
> > +PAGE_SIZE=$(get_page_size)
> > +SUBLEN=$((RANDOM % PAGE_SIZE))
> 
> local variables are lower case.

OK.

> 
> > +$XFS_IO_PROG -f -c "pwrite 0 $PAGE_SIZE" $tfile > /dev/null 2>&1
> > +$XFS_IO_PROG -c "pwrite $PAGE_SIZE $SUBLEN" $tfile > /dev/null 2>&1
> > +
> > +toff=$((PAGE_SIZE + SUBLEN))
> > +for ((i=0; i<10000; i++))
> > +do
> 
> # Add comment on what the loop is trying to do to the layout of the
> # file being written.
> for ((i = 0; i < 10000; i++)); do

OK.

> 
> > +	tlen=$PAGE_SIZE
> > +	if [ $((i % 2)) = 0 ]; then
> > +		tlen=$((PAGE_SIZE * 3))
> > +	fi
> > +	if [ $((i % 1000)) = 0 ]; then
> > +		tlen=$((RANDOM % PAGE_SIZE))
> > +	fi
> > +
> > +	$XFS_IO_PROG -c "pwrite $toff $tlen" $tfile > /dev/null 2>&1
> > +	toff=$((toff + tlen))
> > +done
> > +
> > +sync
> > +
> > +# check for single PAGESIZE extent
> > +$XFS_IO_PROG -c "fiemap -v" $tfile >> $seqres.full 2>&1
> > +$XFS_IO_PROG -c "fiemap -v" $tfile | awk '{if ($4 == 8) print $4}'
> 
> Assumes page size is 4k. Also assumes that no individual extent in
> the file is 4k. Likely broken.

My miss, will try to come up with a way to tell awk PAGE_SIZE, maybe call getpagesize() ?
(if you already how to do it, please do me a favor :-) )

> 
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/btrfs/027.out b/tests/btrfs/027.out
> > new file mode 100644
> > index 0000000..e8291ab
> > --- /dev/null
> > +++ b/tests/btrfs/027.out
> > @@ -0,0 +1 @@
> > +QA output created by 027
> 
> So are we expecting no output or not?

We don't expect any 4k single extent if btrfs is doing correctly, so I leave the output empty.

Thanks for the comments, Dave!

Thanks,

-liubo
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
