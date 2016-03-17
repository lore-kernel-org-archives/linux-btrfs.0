Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18342 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935087AbcCQV31 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 17:29:27 -0400
Date: Thu, 17 Mar 2016 14:31:39 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] fstest: btrfs: test single 4k extent after
 subpagesize buffered writes
Message-ID: <20160317213139.GA22349@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1457394467-1245-1-git-send-email-bo.li.liu@oracle.com>
 <1457396879-30572-1-git-send-email-bo.li.liu@oracle.com>
 <20160315033941.GE30721@dastard>
 <20160317041357.GB29904@localhost.localdomain>
 <20160317210715.GI11812@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160317210715.GI11812@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 18, 2016 at 08:07:15AM +1100, Dave Chinner wrote:
> On Wed, Mar 16, 2016 at 09:13:57PM -0700, Liu Bo wrote:
> > On Tue, Mar 15, 2016 at 02:39:41PM +1100, Dave Chinner wrote:
> > > On Mon, Mar 07, 2016 at 04:27:59PM -0800, Liu Bo wrote:
> > > > This is to test if COW enabled btrfs can end up with single 4k extents
> > > > when doing subpagesize buffered writes.
> > > > 
> > > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > > > ---
> > > ....
> > > > +_scratch_mkfs >> $seqres.full 2>&1
> > > > +_scratch_mount
> > > > +
> > > > +default_expire=`cat /proc/sys/vm/dirty_expire_centisecs`
> > > > +echo 50 > /proc/sys/vm/dirty_expire_centisecs
> > > 
> > > why?
> > 
> > Setting it to 50 is to flush dirty pages more frequently so that it's
> > more likely to reproduce this bug.
> 
> Explainations should be in comments.

Got it, that makes sense.

> 
> ....
> > > > +	$XFS_IO_PROG -c "pwrite $toff $tlen" $tfile > /dev/null 2>&1
> > > > +	toff=$((toff + tlen))
> > > > +done
> > > > +
> > > > +sync
> > > > +
> > > > +# check for single PAGESIZE extent
> > > > +$XFS_IO_PROG -c "fiemap -v" $tfile >> $seqres.full 2>&1
> > > > +$XFS_IO_PROG -c "fiemap -v" $tfile | awk '{if ($4 == 8) print $4}'
> > > 
> > > Assumes page size is 4k. Also assumes that no individual extent in
> > > the file is 4k. Likely broken.
> > 
> > My miss, will try to come up with a way to tell awk PAGE_SIZE, maybe call getpagesize() ?
> > (if you already how to do it, please do me a favor :-) )
> 
> awk -v pgsize=$page_size \
> 	'{ cnt = pgsize/512; if ($4 == pgsize) print $4; }
> 
> Assuming that fiemap is reporting in 512 byte block size, not sector
> sizes...

Yeah, I noticed that.

> 
> > > > --- /dev/null
> > > > +++ b/tests/btrfs/027.out
> > > > @@ -0,0 +1 @@
> > > > +QA output created by 027
> > > 
> > > So are we expecting no output or not?
> > 
> > We don't expect any 4k single extent if btrfs is doing correctly, so I leave the output empty.
> 
> Convention is that we echo a line to the golden output file to
> document the test is expected to give no output. That's why you see
> 
> echo "Silence is golden"
> 
> in many tests...

I see, will update it.

Thank you for the nice explanation.

Thanks,

-liubo
