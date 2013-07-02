Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:15574 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755046Ab3GBKPq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jul 2013 06:15:46 -0400
Date: Tue, 2 Jul 2013 20:15:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Koen De Wit <koen.de.wit@oracle.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] xfstests: btrfs/316: cross-subvolume sparse copy
Message-ID: <20130702101539.GC14996@dastard>
References: <51D29D17.3050000@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51D29D17.3050000@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 02, 2013 at 11:27:51AM +0200, Koen De Wit wrote:
> This testscript creates reflinks to files on different subvolumes, overwrites the original files and reflinks, and moves reflinked files between subvolumes.
> 
> Originally submitted as testcase 302, changes are made based on comments from Eric: http://oss.sgi.com/archives/xfs/2013-03/msg00231.html
> Two new common/rc functions used in this script (_require_cp_reflink and _verify_reflink) have been submitted recently: http://oss.sgi.com/archives/xfs/2013-05/msg00745.html
> Thanks to Eric Sandeen and Dave Chinner for the reviews.
> 
> Version 3: fixing wrapped patch.

Needs a proper commit message - wrap it at 72 columns,  change log
should be placed below the --- devider, not be part of hte commit
message.

Test numbers do not need to be unique across all test directories,
just unique within the tests/btrfs directory.

> +
> +_checksum_files() {
> +    for F in file1 file2 file3
> +    do
> +        for D in $TESTDIR1 $SCRATCH_MNT $SUBVOL2
> +        do
> +            md5sum $D/$F | _filter_test_dir | _filter_scratch

Just cut the file name out. No need for filtering at that point...

> +        done
> +    done
> +}
> +
> +TESTDIR1=$TEST_DIR/test-$seq-1
> +TESTDIR2=$TEST_DIR/test-$seq-2
> +SUBVOL1=$TEST_DIR/subvol-$seq-1
> +SUBVOL2=$TEST_DIR/subvol-$seq-2

....-316-.....

> +Verify the file contents:
> +e09c80c42fda55f9d992e59ca6b3307d  TEST_DIR/test-302-1/file1

which means the golden output is broken, despite the filtering

You should test your patches before posting ;)

FWIW, this is why you should simply cut the filename completely out
like we do elsewhere....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
