Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45356 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932815AbbLHH1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 02:27:32 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Dave Chinner'" <david@fromorbit.com>
CC: <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
References: <56d7fca5e2f5dadceb4a3ec3d4589fec54da8d3b.1449137276.git.zhaolei@cn.fujitsu.com> <20151207221207.GF26718@dastard>
In-Reply-To: <20151207221207.GF26718@dastard>
Subject: RE: [PATCH] fstests: Fix generic/102 fail for btrfs
Date: Tue, 8 Dec 2015 15:26:41 +0800
Message-ID: <039801d13189$c8e29c70$5aa7d550$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Dave Chinner

> -----Original Message-----
> From: Dave Chinner [mailto:david@fromorbit.com]
> Sent: Tuesday, December 08, 2015 6:12 AM
> To: Zhaolei <zhaolei@cn.fujitsu.com>
> Cc: fstests@vger.kernel.org; linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] fstests: Fix generic/102 fail for btrfs
> 
> On Thu, Dec 03, 2015 at 06:08:36PM +0800, Zhaolei wrote:
> > From: Zhao Lei <zhaolei@cn.fujitsu.com>
> >
> > generic/102 sometimes fails in newest btrfs toolchain, because it use
> > non-mixed mode in default, which request more space for metadata, and
> > no space for data writing.
> >
> > This patch force mixed mode for btrfs in generic/102.
> >
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > ---
> >  tests/generic/102 | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/tests/generic/102 b/tests/generic/102 index
> > abc3994..8c01fb5 100755
> > --- a/tests/generic/102
> > +++ b/tests/generic/102
> > @@ -48,6 +48,8 @@ _require_scratch
> >
> >  rm -f $seqres.full
> >
> > +[[ "$FSTYP" = "btrfs" ]] && MKFS_OPTIONS+=" --mixed"
> > +
> >  dev_size=$((512 * 1024 * 1024))     # 512MB filesystem
> >  _scratch_mkfs_sized $dev_size >>$seqres.full 2>&1
> 
> This sort of filesystem size specific mkfs requirement belongs in the filesystem
> specific section of _scratch_mkfs_sized().
> 
Thanks for review.

Agree with you in generic, but for this case, if we changes to use
--mixed mode in _scratch_mkfs_sized() for all btrfs, xfstests will not able to check
non-mixed mode of btrfs, which is more popular for real-world users.

So we only use --mixed mode for btrfs in generic/102 will be a better choice.
And similar way also exist in some tests of current xfstests:
  generic/204:[ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=7m -i maxpct=50"
  generic/040:if [ "$FSTYP" = "btrfs" ]; then
            _scratch_mkfs "-O extref" >> $seqres.full 2>&1
  generic/041:if [ "$FSTYP" = "btrfs" ]; then
            _scratch_mkfs "-O extref" >> $seqres.full 2>&1
  ...

Thanks
Zhaolei

> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com




