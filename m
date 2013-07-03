Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:6888 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753107Ab3GCGhu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 02:37:50 -0400
Date: Wed, 3 Jul 2013 16:37:24 +1000
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <esandeen@redhat.com>
Cc: Koen De Wit <koen.de.wit@oracle.com>, Eric Sandeen <sandeen@redhat.com>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] xfstests: btrfs/316: cross-subvolume sparse copy
Message-ID: <20130703063724.GK14996@dastard>
References: <51D29D17.3050000@oracle.com>
 <20130702101539.GC14996@dastard>
 <51D2E33B.1080402@oracle.com>
 <6B93E4A6-D1C9-4170-8E1C-B94D24F601BB@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6B93E4A6-D1C9-4170-8E1C-B94D24F601BB@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 02, 2013 at 11:51:21AM -0400, Eric Sandeen wrote:
> On Jul 2, 2013, at 10:28 AM, Koen De Wit <koen.de.wit@oracle.com>
> wrote:
> 
> > Dave,
> > 
> > Thanks for the review. I will clean up the commit message and do
> > a full mail-to-myself-and-test-patch round trip to avoid errors
> > like the wrong test numbers in the golden output. I'm sorry for
> > this.
> > 
> > About cutting out file names from the output. I did this in the
> > first version of the patch:
> > 
> >       md5sum $TESTDIR1/$F | $AWK_PROG 'END {print $1}'
> > 
> > but Eric Sandeen suggested to include them in order to provide
> > more context in the output. (See
> > http://oss.sgi.com/archives/xfs/2013-03/msg00231.html and
> > http://oss.sgi.com/archives/xfs/2013-03/msg00220.html) That
> > sounds like a good idea to me, it makes debugging failures
> > easier. Whose opinion should I follow?
> > 
> Heh sorry.  IMHO maybe a middle ground; not bare md5sum but show
> only the base name?  In the end up to you; it seems Dave and I
> have different opinions on this.  :)

I was just going by current xfstests convention. i.e, in common/rc:

# Prints the md5 checksum of a given file
_md5_checksum()
{
        md5sum $1 | cut -d ' ' -f1
}

Which is used by all the hole punch tests and generic/311.

Make of that what you will, but I'd prefer to see consistency of
implementation across tests... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
