Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32957 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbcGDTLr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jul 2016 15:11:47 -0400
Date: Mon, 4 Jul 2016 12:11:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Eryu Guan <eguan@redhat.com>
Cc: david@fromorbit.com, linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 16/20] reflink: test cross-mountpoint reflink and dedupe
Message-ID: <20160704191135.GA5215@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
 <146612806287.25024.6626531953151914169.stgit@birch.djwong.org>
 <20160704065137.GW23649@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160704065137.GW23649@eguan.usersys.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 04, 2016 at 02:51:37PM +0800, Eryu Guan wrote:
> On Thu, Jun 16, 2016 at 06:47:42PM -0700, Darrick J. Wong wrote:
> > Test sharing blocks via reflink and dedupe between two different
> > mountpoints of the same filesystem.  This shouldn't work, since
> > we don't allow cross-mountpoint functions.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/reflink        |    2 +
> >  tests/generic/927     |   88 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/927.out |    9 +++++
> >  tests/generic/928     |   86 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/928.out |   10 ++++++
> >  tests/generic/group   |    2 +
> >  6 files changed, 196 insertions(+), 1 deletion(-)
> >  create mode 100755 tests/generic/927
> >  create mode 100644 tests/generic/927.out
> >  create mode 100755 tests/generic/928
> >  create mode 100644 tests/generic/928.out
> > 
> > 
> > diff --git a/common/reflink b/common/reflink
> > index 4ec390d..1363971 100644
> > --- a/common/reflink
> > +++ b/common/reflink
> > @@ -107,7 +107,7 @@ _require_scratch_dedupe()
> >  	_scratch_mount
> >  	"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 65536" "$SCRATCH_MNT/file1" > /dev/null
> >  	"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 65536" "$SCRATCH_MNT/file2" > /dev/null
> > -	testio="$("$XFS_IO_PROG" -f -c "dedupe $TEST_DIR/file1 0 0 65536" "$TEST_DIR/file2" 2>&1)"
> > +	testio="$("$XFS_IO_PROG" -f -c "dedupe $SCRATCH_MNT/file1 0 0 65536" "$SCRATCH_MNT/file2" 2>&1)"
> >  	echo $testio | grep -q "Operation not supported" && \
> >  		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
> >  	echo $testio | grep -q "Inappropriate ioctl for device" && \
> 
> I think this hunk belongs to a seperate patch.

Ok, will do.

--D

> 
> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
