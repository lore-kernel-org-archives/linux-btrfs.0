Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:41490 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbbBYAG3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 19:06:29 -0500
Date: Wed, 25 Feb 2015 11:06:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Filipe Manana <fdmanana@suse.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] fstests: generic test for directory fsync after
 adding hard links
Message-ID: <20150225000625.GB18360@dastard>
References: <1424370551-18884-1-git-send-email-fdmanana@suse.com>
 <1424820589-3593-1-git-send-email-fdmanana@suse.com>
 <54ED0BD5.3040504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54ED0BD5.3040504@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 24, 2015 at 05:40:05PM -0600, Eric Sandeen wrote:
> On 2/24/15 5:29 PM, Filipe Manana wrote:
....
> > diff --git a/tests/generic/060 b/tests/generic/060
> > new file mode 100755
> > index 0000000..0d459fa
> > --- /dev/null
> > +++ b/tests/generic/060
> > @@ -0,0 +1,175 @@
> > +#! /bin/bash
> > +# FS QA Test No. 060
> > +#
> > +# This test is motivated by an fsync issue discovered in btrfs.
> > +# The issue was that after adding a new hard link to an existing file (one that
> > +# was created in a past transaction) and fsync'ing the parent directory of the
> > +# new hard link, after the fsync log replay the file's inode link count did not
> > +# get its link count incremented, while the new directory entry was visible.
> > +# Also, unlike xfs and ext4, new files under the directory we fsync were not
> > +# being written to the fsync log, nor were any child directories and new files
> > +# and links under the children directories. So this test verifies too that
> > +# btrfs has the same behaviour as xfs and ext3/4.
> > +#
> > +# The btrfs issue was fixed by the following linux kernel patch:
> > +#
> > +#  Btrfs: fix metadata inconsistencies after directory fsync
> 
> 
> I still would like to know *what this test does* - not some narrative about
> btrfs's troubled past.  ;)

Right, the description in the test is supposed to be a consise
description of what the test does.  It is parsed by lsqa.pl to
inform the reader of what the test exercises and that's why we
actually care about the quality of the description.

> Could you please add that line or two, and feel free to keep all the detail about
> the btrfs-specific bug later?  We're getting a lot of these tests, and a
> short description of what a test does is just How We Do It(tm).  It saves having to 
> read a lot of bash code just to get some idea of what is under test.
> 
> i.e. like this, or whatever is accurate:
> 
> # Test that link counts remain correct after fsyncing a parent directory
> # containing hardlinks, and subsequent log recovery
#
> # <insert fascinating btrfs story here>

The fascinating btrfs story belongs in the commit message, not
the test itself.  If people need to know what btrfs commit the test
exercises, the history, motivations and commentary on the code, then
they can look it up in the git history.

> Please just do this; it'll save people time, down the line, if/when
> this test fails in the future, or needs to be maintained by someone
> else.

Precisely.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
