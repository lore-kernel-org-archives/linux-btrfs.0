Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37458 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3GYBKB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jul 2013 21:10:01 -0400
Date: Thu, 25 Jul 2013 09:09:49 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Ben Myers <bpm@sgi.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] Xfstests/btrfs/308: add snapshot-aware defrag for
 partial extents testcases
Message-ID: <20130725010949.GA5202@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1372844780-31845-1-git-send-email-bo.li.liu@oracle.com>
 <20130724232949.GX3111@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130724232949.GX3111@sgi.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 24, 2013 at 06:29:49PM -0500, Ben Myers wrote:
> On Wed, Jul 03, 2013 at 05:46:20PM +0800, Liu Bo wrote:
> > This is to test whether snapshot-aware defrag can work well on partial extents.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  tests/btrfs/308     |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/308.out |    2 +
> >  tests/btrfs/group   |    1 +
> >  3 files changed, 96 insertions(+), 0 deletions(-)
> >  create mode 100755 tests/btrfs/308
> >  create mode 100644 tests/btrfs/308.out
> > 
> > diff --git a/tests/btrfs/308 b/tests/btrfs/308
> > new file mode 100755
> > index 0000000..b3dd39c
> > --- /dev/null
> > +++ b/tests/btrfs/308
> > @@ -0,0 +1,93 @@
> > +#! /bin/bash
> > +# BTRFS QA Test No. 308
> > +#
> > +# Test if snapshot-aware defrag can work well on partial extents, ie.
> > +# extent_offset is not zero.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2013 Oracle.  All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +#
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +    cd /
> > +    rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> 
> _supported_fs btrfs
> 
> Since this is btrfs specific, I think _supported_fs should be btrfs.
> 
> I didn't see anything obviously wrong with the rest of this, but I'd rather see
> a review from a btrfs expert.
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>

Oh yeah, it's right, I'll update it and resend, thanks.

-liubo
