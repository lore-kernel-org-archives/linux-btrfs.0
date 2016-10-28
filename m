Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41922 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934542AbcJ1HQb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 03:16:31 -0400
Date: Fri, 28 Oct 2016 15:16:28 +0800
From: Eryu Guan <eguan@redhat.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] generic: make 17[1-4] work well when btrfs
 compression is enabled
Message-ID: <20161028071628.GG27776@eguan.usersys.redhat.com>
References: <20161026095211.30091-1-wangxg.fnst@cn.fujitsu.com>
 <20161027171321.GA5251@birch.djwong.org>
 <5812F78D.9020802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5812F78D.9020802@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 28, 2016 at 03:00:29PM +0800, Wang Xiaoguang wrote:
> hi,
> 
> On 10/28/2016 01:13 AM, Darrick J. Wong wrote:
> > On Wed, Oct 26, 2016 at 05:52:11PM +0800, Wang Xiaoguang wrote:
> > > When enabling btrfs compression, original codes can not fill fs
> > > correctly, here we introduce _fill_fs() in common/rc, which'll keep
> > > creating and writing files until enospc error occurs. Note _fill_fs
> > > is copied from tests/generic/256, but with some minor modifications.
> > > 
> > > Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> > > ---
> > > V2: In common/, I did't find an existing function suitable for
> > >      these 4 test cases to fill fs, so I still use _pwrite_byte() with
> > >      a big enough file length fo fill fs. Note, for btrfs, metadata space
> > >      still is not full, only data space is full, but it's OK for these
> > >      4 test cases.
> > > 
> > >      All these 4 cases pass in xfs and btrfs(without compression), if
> > >      btrfs has compression enabled, these 4 cases will fail for false
> > >      enospc error, I have sent kernel patches to fix this bug.
> > > 
> > > V3: Introduce  _fill_fs in common/rc to fill fs.
> > > ---
> > >   common/rc         | 50 ++++++++++++++++++++++++++++++++++++++++++
> > >   tests/generic/171 |  4 +---
> > >   tests/generic/172 |  4 ++--
> > >   tests/generic/173 |  4 +---
> > >   tests/generic/174 |  4 +---
> > >   tests/generic/256 | 65 +++++--------------------------------------------------
> > >   6 files changed, 60 insertions(+), 71 deletions(-)
> > > 
> > > diff --git a/common/rc b/common/rc
> > > index 7a9fc90..0e1ac5d 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > Would you mind moving this to common/populate, where I've been (slowly)
> > collecting all the "create stuff inside the filesystem" routines?
> OK, sure.
> > 
> > (It's part of a slow-moving effort to declutter common/rc.)
> > 
> > > @@ -4003,6 +4003,56 @@ _require_xfs_mkfs_without_validation()
> > >   	fi
> > >   }
> > > +# Fill a file system by repeatedly creating files in the given folder
> > > +# starting with the given file size.  Files are reduced in size when
> > > +# they can no longer fit until no more files can be created.
> > > +_fill_fs()
> > > +{
> > > +	local file_size=$1
> > > +	local dir=$2
> > > +	local block_size=$3
> > > +	local switch_user=$4
> > > +	local file_count=1
> > > +	local bytes_written=0
> > > +
> > > +	if [ $# -ne 4 ]; then
> > > +		echo "Usage: _fill_fs filesize dir blocksize"
> > > +		exit 1
> > > +	fi
> > > +
> > > +	if [ $switch_user -eq 0 ]; then
> > > +		mkdir -p $dir
> > > +	else
> > > +		_user_do "mkdir -p $dir"
> > > +	fi
> > > +
> > > +	if [ $file_size -lt $block_size ]; then
> > > +		$file_size = $block_size
> > > +	fi
> > > +
> > > +	while [ $file_size -ge $block_size ]; do
> > > +		bytes_written=0
> > > +		if [ $switch_user -eq 0 ]; then
> > > +			$XFS_IO_PROG -f -c "pwrite 0 $file_size" \
> > > +				$dir/$file_count > /dev/null
> > If you want to speed this up some more you could pass "-b 8388608" in
> > the pwrite string so that xfs_io will allocate an 8MB memory buffer
> > internally when writing out data.
> > 
> > $XFS_IO_PROG -f -c "pwrite -b 8388608 0 $file_size" $dir/$file_count
> Thanks for this info, I'll use it.
> > 
> > > +		else
> > > +			_user_do "$XFS_IO_PROG -f -c \"pwrite 0 $file_size\" \
> > > +				$dir/$file_count > /dev/null"
> > Also, why redirect to /dev/null?  I think helper functions generally let
> > the individual test decide where the stdout & stderr output ultimately
> > end up.  Most tests seem to dump to $seqres.full or /dev/null, but we
> > should let the test decide where potentially useful diagnostic
> > information ends up.
> Agree :)
> 
> > /me also wonders if falloc would be a faster way to consume disk blocks
> > than pwrite, but ... <shrug>
> Oh, it is. Falloc is not affected by compression.

One problem with falloc is that not all filesystems support it, e.g.
ext3 and ext2. So you have to fall back to pwrite if falloc is not
supported.

Thanks,
Eryu
