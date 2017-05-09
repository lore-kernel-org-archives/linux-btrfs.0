Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39339 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753562AbdEIS4q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 May 2017 14:56:46 -0400
Date: Tue, 9 May 2017 11:55:10 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@gmail.com>
Subject: Re: [PATCH v3] fstests: regression test for btrfs dio read repair
Message-ID: <20170509185510.GA17312@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1493400352-5845-1-git-send-email-bo.li.liu@oracle.com>
 <20170503100836.GF7250@eguan.usersys.redhat.com>
 <20170508195040.GD20619@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170508195040.GD20619@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 08, 2017 at 12:50:40PM -0700, Liu Bo wrote:
> On Wed, May 03, 2017 at 06:08:36PM +0800, Eryu Guan wrote:
> > On Fri, Apr 28, 2017 at 11:25:52AM -0600, Liu Bo wrote:
> > > This case tests whether dio read can repair the bad copy if we have
> > > a good copy.
> > > 
> > > Commit 2dabb3248453 ("Btrfs: Direct I/O read: Work on sectorsized blocks")
> > > introduced the regression.
> > > 
> > > The upstream fix is
> > > 	Btrfs: fix invalid dereference in btrfs_retry_endio
> > > 
> > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > 
> > Sorry for the late review, and many thanks to Filipe's reviews! I agreed
> > with Filipe that the common helpers can be placed in common/btrfs and/or
> > common/rc files.
> > 
> > Some thoughts inline.
> > 
> > > ---
> > > v2: - Add regression commit and the fix to the description
> > >     - Use btrfs inspect-internal dump-tree to get rid of the dependence btrfs-map-logical
> > >     - Add comments in several places
> > > 
> > > v3: - Add 'mkfs -b 1G' to limit filesystem size to 2G in raid1 profile so that
> > >       we get a consistent output.
> > > 
> > >  tests/btrfs/140     | 167 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/btrfs/140.out |  39 ++++++++++++
> > >  tests/btrfs/group   |   1 +
> > >  3 files changed, 207 insertions(+)
> > >  create mode 100755 tests/btrfs/140
> > >  create mode 100644 tests/btrfs/140.out
> > > 
> > > diff --git a/tests/btrfs/140 b/tests/btrfs/140
> > > new file mode 100755
> > > index 0000000..dcd8807
> > > --- /dev/null
> > > +++ b/tests/btrfs/140
> > > @@ -0,0 +1,167 @@
> > > +#! /bin/bash
> > > +# FS QA Test 140
> > > +#
> > > +# Regression test for btrfs DIO read's repair during read.
> > > +#
> > > +# Commit 2dabb3248453 ("Btrfs: Direct I/O read: Work on sectorsized blocks")
> > > +# introduced the regression.
> > > +# The upstream fix is
> > > +# 	Btrfs: fix invalid dereference in btrfs_retry_endio
> > > +#
> > > +#-----------------------------------------------------------------------
> > > +# Copyright (c) 2017 Liu Bo.  All Rights Reserved.
> > > +#
> > > +# This program is free software; you can redistribute it and/or
> > > +# modify it under the terms of the GNU General Public License as
> > > +# published by the Free Software Foundation.
> > > +#
> > > +# This program is distributed in the hope that it would be useful,
> > > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > +# GNU General Public License for more details.
> > > +#
> > > +# You should have received a copy of the GNU General Public License
> > > +# along with this program; if not, write the Free Software Foundation,
> > > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > > +#-----------------------------------------------------------------------
> > > +#
> > > +
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1	# failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +
> > > +# remove previous $seqres.full before test
> > > +rm -f $seqres.full
> > > +
> > > +# real QA test starts here
> > > +
> > > +# Modify as appropriate.
> > > +_supported_fs btrfs
> > > +_supported_os Linux
> > > +_require_scratch_dev_pool 2
> > > +
> > > +_require_btrfs_command inspect-internal dump-tree
> > > +_require_command "$FILEFRAG_PROG" filefrag
> > > +_require_odirect
> > > +
> > > +# helpe to convert 'file offset' to btrfs logical offset
> > > +FILEFRAG_FILTER='
> > > +	if (/blocks? of (\d+) bytes/) {
> > > +		$blocksize = $1;
> > > +		next
> > > +	}
> > > +	($ext, $logical, $physical, $length) =
> > > +		(/^\s*(\d+):\s+(\d+)..\s+\d+:\s+(\d+)..\s+\d+:\s+(\d+):/)
> > > +	or next;
> > > +	($flags) = /.*:\s*(\S*)$/;
> > > +	print $physical * $blocksize, "#",
> > > +	      $length * $blocksize, "#",
> > > +	      $logical * $blocksize, "#",
> > > +	      $flags, " "'
> >                       ^^^ "\n" so one extent per line?
> > 
> > This can be embedded in the filter function, like what _filter_mkfs
> > does.
> >
> 
> OK.
> 
> > > +
> > > +# this makes filefrag output script readable by using a perl helper.
> > > +# output is one extent per line, with three numbers separated by '#'
> > > +# the numbers are: physical, length, logical (all in bytes)
> > > +# sample output: "1234#10#5678" -> physical 1234, length 10, logical 5678
> > > +_filter_extents()
> > 
> > Global functions start with underscore, local functions don't.
> > 
> 
> OK.
> 
> > > +{
> > > +	tee -a $seqres.full | $PERL_PROG -ne "$FILEFRAG_FILTER"
> > 
> > I don't think this tee belongs here, see below.
> > 
> > > +}
> > > +
> > > +_check_file_extents()
> > > +{
> > > +	cmd="filefrag -v $1"
> > 
> > $FILEFRAG_PROG
> > 
> > > +	echo "# $cmd" >> $seqres.full
> > 
> > Just call filefrag -v again to dump the filefrag output to $seqres.full
> > 
> 
> Make sense.
> 
> > > +	out=`$cmd | _filter_extents`
> > > +	if [ -z "$out" ]; then
> > > +		return 1
> > > +	fi
> > > +	echo "after filter: $out" >> $seqres.full
> > > +	echo $out
> > > +	return 0
> > > +}
> > 
> > Hmm, seems that all you want from all these filters is the logical byte
> > of the first extent in the file. How about converting
> > _check_file_extents to _filter_filefrag and put it in common/filter?
> > And _get_physical can also be converted to _btrfs_get_physical and
> > placed in common/btrfs
> > e.g.
> > 
> > common/filter:
> > # <comments>
> > _filter_filefrag()
> > {
> > 	perl -ne '
> > 	<all the perl filter code here>
> > 	<like what _filter_mkfs does>
> > 	'
> > }
> > 
> > then
> > 
> > logical_in_btrfs=`$FILEFRAG -v $SCRATCH_MNT/foobar | _filter_filefrag | cut -d '#' -f 1`
> > physical_on_scratch=`_btrfs_get_physical $logical_in_btrfs`
> >
> 
> Sounds good.

_btrfs_get_physical in this testcase assumes that the test data has been written
to a fixed position (the start position of the only data chunk), so it's not for
generic use, I'd leave it for now instead of creating a new helper in
common/btrfs.  After we have stable btrfs-map-block output format, we can build
that helper on top of it.

Thanks,

liubo
