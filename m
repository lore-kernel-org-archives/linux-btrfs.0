Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:10305 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757436Ab3BWBIV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 20:08:21 -0500
Date: Sat, 23 Feb 2013 12:08:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: Hemanth Kumar <hemanthkumar51@gmail.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, chethan.casey@gmail.com,
        sandeen@redhat.com, sensille@gmx.net, ganeshkumar14@gmail.com,
        praneethu.u@gmail.com, hugo@carfax.org.uk, bo.li.liu@oracle.com,
        skjmca51@gmail.com, kirantpatil@gmail.com
Subject: Re: [Tests] xfs test[298]: Btrfs Quota testing
Message-ID: <20130223010817.GE26081@dastard>
References: <1361512444-3451-1-git-send-email-hemanthkumar51@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1361512444-3451-1-git-send-email-hemanthkumar51@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 22, 2013 at 11:24:04AM +0530, Hemanth Kumar wrote:
> 
> Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>

Description?

> ---
>  298     | 37 +++++++++++++++++++++++++++++++++++++
>  298.out | 12 ++++++++++++
>  2 files changed, 49 insertions(+)
>  create mode 100644 298
>  create mode 100644 298.out

You didn't actaully run this in the xfstests, harness, did you? i.e.

$ ./check 298

because it won't run as there is no entry in the group file for this
test....

> 
> diff --git a/298 b/298
> new file mode 100644
> index 0000000..d699fb7
> --- /dev/null
> +++ b/298
> @@ -0,0 +1,37 @@
> +
> +#! /bin/bash
> +# FS QA Test No. 298

Newline at top of patch.

> +#
> +# Test btrfs's quotas
> +#
> +#------------------------------------------------------------------
> +#
> +# creator
> +#owner=hemanthkumar51@gmail.com

Copyright statement?

> +
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1        # failure is the default!
> +
> +_cleanup()
> +{
> +    rm -rf $tmp.*
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +#Enabeling btrfs qutas

Where are all the usual _require....() statements?

> +btrfs quota enable $TEST_DIR
> +echo "quota enabled on $TEST_DEV"

That won't work - you're not allowed to output actual device names
into the golden output. We always filter then the to
TEST_DEV/TEST_DIR or SCRATCH_DEV/SCRATCH_MNT

> +btrfs subvolume create $TEST_DIR/vol1
> +echo "vol1 created"
> +btrfs qgroup show $TEST_DIR

That output will change for different filesystem configurations.
needs filtering, or dropping.

> +btrfs qgroup limit 2m $TEST_DIR/vol1
> +echo "qgroup limited to 2mb"
> +dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=3M count=1

You need to filter the output of dd to remove all variable data.
However, it is preferable to use xfs_io for doing IO. i.e:

$XFS_IO_PROG -f -c "pwrite 0 3m" $TEST_DIR/vol1/file1 | filter_io

> +echo "tried to write 3m worth data"
> +exit

You never set status=0, so the test will always fail.

Also, you don't undo any of the modifications you made to the
TEST_DEV, which means that it will affect all subsequent tests. If
you are doing specific configuration tests, your should be using the
SCRATCH_DEV/SCRATCH_MNT....

> diff --git a/298.out b/298.out
> new file mode 100644
> index 0000000..344ab7f
> --- /dev/null
> +++ b/298.out
> @@ -0,0 +1,12 @@
> +QA output created by 298
> +quota enabled on /dev/sdb5
> +Create subvolume '/test/vol1'
> +vol1 created
> +0/257 4096 4096
> +qgroup limited to 2mb
> +dd: writing ‘/test/vol1/file1’: Disk quota exceeded

You've got environment specific characters in your output.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
