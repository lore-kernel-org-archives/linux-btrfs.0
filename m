Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21929 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbcEZQN2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 12:13:28 -0400
Date: Thu, 26 May 2016 09:12:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 6/7] xfs: test rmap behavior when multiple bmbt records
 map to a single rmapbt record
Message-ID: <20160526161257.GB16512@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
 <146424226290.6278.15051221437554845000.stgit@birch.djwong.org>
 <20160526080424.GA8469@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160526080424.GA8469@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 26, 2016 at 01:04:24AM -0700, Christoph Hellwig wrote:
> > --- a/src/t_immutable.c
> > +++ b/src/t_immutable.c
> > @@ -38,10 +38,10 @@
> >  #include <libgen.h>
> >  #include <sys/acl.h>
> >  #include <attr/xattr.h>
> > +#include <linux/fs.h>
> >  #include <xfs/xfs.h>
> >  #include <xfs/handle.h>
> >  #include <xfs/jdm.h>
> > -#include <linux/fs.h>
> >  #include <linux/magic.h>
> >  
> >  #ifndef XFS_SUPER_MAGIC
> 
> How does this belong into the patch?

It doesn't, this somehow jumped patches when I rebased. :/

> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index f0ca410..0e34f9a 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -288,3 +288,4 @@
> >  853 auto quick clone
> >  854 auto quick clone
> >  855 auto clone
> > +856 auto clone rmap reflink
> 
> This is the only test in the reflink group, how is this group different
> from the clone one?

I'm just gonna say 'thinko' and respin. :)

/me pours a larger cup of coffee...

(Thx for the review!)

--D
