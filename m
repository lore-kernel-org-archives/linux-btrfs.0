Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:64307 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106AbbLIUcs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Dec 2015 15:32:48 -0500
Date: Thu, 10 Dec 2015 07:32:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: Fix generic/102 fail for btrfs
Message-ID: <20151209203244.GG26718@dastard>
References: <56d7fca5e2f5dadceb4a3ec3d4589fec54da8d3b.1449137276.git.zhaolei@cn.fujitsu.com>
 <20151207221207.GF26718@dastard>
 <039801d13189$c8e29c70$5aa7d550$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <039801d13189$c8e29c70$5aa7d550$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 08, 2015 at 03:26:41PM +0800, Zhao Lei wrote:
> Hi, Dave Chinner
> 
> > -----Original Message-----
> > From: Dave Chinner [mailto:david@fromorbit.com]
> > Sent: Tuesday, December 08, 2015 6:12 AM
> > To: Zhaolei <zhaolei@cn.fujitsu.com>
> > Cc: fstests@vger.kernel.org; linux-btrfs@vger.kernel.org
> > Subject: Re: [PATCH] fstests: Fix generic/102 fail for btrfs
> > 
> > On Thu, Dec 03, 2015 at 06:08:36PM +0800, Zhaolei wrote:
> > > From: Zhao Lei <zhaolei@cn.fujitsu.com>
> > >
> > > generic/102 sometimes fails in newest btrfs toolchain, because it use
> > > non-mixed mode in default, which request more space for metadata, and
> > > no space for data writing.
> > >
> > > This patch force mixed mode for btrfs in generic/102.
> > >
> > > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > > ---
> > >  tests/generic/102 | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/tests/generic/102 b/tests/generic/102 index
> > > abc3994..8c01fb5 100755
> > > --- a/tests/generic/102
> > > +++ b/tests/generic/102
> > > @@ -48,6 +48,8 @@ _require_scratch
> > >
> > >  rm -f $seqres.full
> > >
> > > +[[ "$FSTYP" = "btrfs" ]] && MKFS_OPTIONS+=" --mixed"
> > > +
> > >  dev_size=$((512 * 1024 * 1024))     # 512MB filesystem
> > >  _scratch_mkfs_sized $dev_size >>$seqres.full 2>&1
> > 
> > This sort of filesystem size specific mkfs requirement belongs in the filesystem
> > specific section of _scratch_mkfs_sized().
> > 
> Thanks for review.
> 
> Agree with you in generic, but for this case, if we changes to use
> --mixed mode in _scratch_mkfs_sized() for all btrfs, xfstests will not able to check
> non-mixed mode of btrfs, which is more popular for real-world users.

Then, as I've said before, mkfs.btrfs needs to be fixed to select
the correct mode based on the size the user is asking for.

> So we only use --mixed mode for btrfs in generic/102 will be a better choice.
> And similar way also exist in some tests of current xfstests:
>   generic/204:[ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=7m -i maxpct=50"

This one is special - the test was once an XFS specific test and
then made generic. For it to continue to be useful for XFS, it needs
to use *every single free space block* and hence the filesystem
needs to be made with those options.  For other filesystems, just
using a 106MB filesystem is sufficient to *exercise* ENOSPC flushing
behaviour. Different historical context.


>   generic/040:if [ "$FSTYP" = "btrfs" ]; then
>             _scratch_mkfs "-O extref" >> $seqres.full 2>&1
>   generic/041:if [ "$FSTYP" = "btrfs" ]; then
>             _scratch_mkfs "-O extref" >> $seqres.full 2>&1

These, however, are exactly sort of thing needs to go away. It's a
nasty hack to handle changing defaults of the filesystem, when in
fact what should happen is either:

	a) the test shoul dnotrun because the filesystem does not
	have the correct feature enabled; or
	b) _scratch_mkfs_btrfs should set the necessary options by
	default and scrub duplicate/conflicting mkfs options.


Have you noticed just how complex _scratch_mkfs_xfs and
_scratch_mkfs_ext4 are? They handle situations where there are
conflicting/bad/missing options passed to _scratch_mkfs, and they
only fail is there's really an unfixable problem.

That's what is neeed for btrfs, not hand hacking stuff into random
tests...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
