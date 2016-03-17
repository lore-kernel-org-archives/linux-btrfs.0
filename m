Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbcCQEYh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 00:24:37 -0400
Date: Thu, 17 Mar 2016 12:24:35 +0800
From: Eryu Guan <eguan@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] fstest: btrfs: test single 4k extent after
 subpagesize buffered writes
Message-ID: <20160317042435.GV11419@eguan.usersys.redhat.com>
References: <1457394467-1245-1-git-send-email-bo.li.liu@oracle.com>
 <1457396879-30572-1-git-send-email-bo.li.liu@oracle.com>
 <20160315033941.GE30721@dastard>
 <20160317041357.GB29904@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160317041357.GB29904@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 16, 2016 at 09:13:57PM -0700, Liu Bo wrote:
> On Tue, Mar 15, 2016 at 02:39:41PM +1100, Dave Chinner wrote:
> > On Mon, Mar 07, 2016 at 04:27:59PM -0800, Liu Bo wrote:
> > > This is to test if COW enabled btrfs can end up with single 4k extents
> > > when doing subpagesize buffered writes.
> > > 
> > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
...
> > > +# check for single PAGESIZE extent
> > > +$XFS_IO_PROG -c "fiemap -v" $tfile >> $seqres.full 2>&1
> > > +$XFS_IO_PROG -c "fiemap -v" $tfile | awk '{if ($4 == 8) print $4}'
> > 
> > Assumes page size is 4k. Also assumes that no individual extent in
> > the file is 4k. Likely broken.
> 
> My miss, will try to come up with a way to tell awk PAGE_SIZE, maybe call getpagesize() ?
> (if you already how to do it, please do me a favor :-) )

./src/feature is able to do this, e.g. pagesize=`$here/src/feature -s`

Thanks,
Eryu
