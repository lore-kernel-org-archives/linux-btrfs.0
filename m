Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:63331 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923AbaGJAne (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Jul 2014 20:43:34 -0400
Date: Thu, 10 Jul 2014 10:43:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] xfstests/btrfs: add test for quota groups and drop
 snapshot
Message-ID: <20140710004330.GG4453@dastard>
References: <20140709224150.GA5484@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140709224150.GA5484@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 09, 2014 at 03:41:50PM -0700, Mark Fasheh wrote:
> Test btrfs quota group consistency operations during snapshot delete.  Btrfs
> has had long standing issues with drop snapshot failing to properly account
> for quota groups. This test crafts a snapshot tree with shared and exclusive
> elements. The tree is removed and then quota group consistency is checked.
> 
> This issue is fixed by the linux kernel btrfs patch series:
>    [PATCH 0/3] btrfs: qgroup fixes for btrfs_drop_snapshot
>    [PATCH 1/3] btrfs: add trace for qgroup accounting
>    [PATCH 2/3] btrfs: qgroup: account shared subtrees during snapshot delete
>    [PATCH 3/3] Btrfs: __btrfs_mod_ref should always use no_quota
> 
> The following btrfsprogs patch set is needed for the actual check of qgroup
> consistency:
>    [PATCH 1/5] btrfs-progs: print qgroup excl as unsigned
>    [PATCH 2/5] btrfs-progs: import ulist
>    [PATCH 3/5] btrfs-progs: add quota group verify code
>    [PATCH 4/5] btrfs-progs: show extent state for a subvolume
>    [PATCH 5/5] btrfs-progs: ignore orphaned qgroups by default
> 
> The btrfsprogs patches can be found in the following repo:
> 
> https://github.com/markfasheh/btrfs-progs-patches/tree/qgroup-verify
> 
> This patch to xfstests can be found in the following repo:
> 
> https://github.com/markfasheh/xfstests-patches/tree/qgroup-drop-snapshot
> 
....
> +rm -f $seqres.full
> +
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +# This always reproduces level 1 trees
> +maxfiles=100
> +
> +echo "create file set"
> +
> +# Make a bunch of small files in a directory. This is designed to expand
> +# the filesystem tree to something more than zero levels.
> +mkdir $SCRATCH_MNT/files
> +for i in `seq -w 0 $maxfiles`;
> +do
> +    dd status=none if=/dev/zero of=$SCRATCH_MNT/files/file$i bs=4096 count=4
> +done

	$XFS_IO_PROG -f -c "pwrite 0 16384" $SCRATCH_MNT/files/file$i > /dev/null

> +
> +# create a snapshot of what we just did
> +$BTRFS_UTIL_PROG fi sy $SCRATCH_MNT
> +$BTRFS_UTIL_PROG su sna $SCRATCH_MNT $SCRATCH_MNT/snap1
> +mv $SCRATCH_MNT/snap1/files $SCRATCH_MNT/snap1/old

You need to filter the output. i.e. _filter_scratch

> +# same thing as before but on the snapshot. this way we can generate
> +# some exclusively owned tree nodes.
> +echo "create file set on snapshot"
> +mkdir $SCRATCH_MNT/snap1/files
> +for i in `seq -w 0 $maxfiles`;
> +do
> +    dd status=none if=/dev/zero of=$SCRATCH_MNT/snap1/files/file$i bs=4096 count=4
> +done

Same again.

> +
> +# Enable qgroups now that we have our filesystem prepared. This
> +# will kick off a scan which we will have to wait for below.
> +$BTRFS_UTIL_PROG qu en $SCRATCH_MNT
> +sleep 30

That seems rather arbitrary. The sleeps you are adding add well over
a minute to the runtime, and a quota scan of a filesystem with 200
files should be almost instantenous.

> +_scratch_unmount
> +_scratch_mount

What is the purpose of this?

> +# Ok, delete the snapshot we made previously. Since btrfs drop
> +# snapshot is a delayed action with no way to force it, we have to
> +# impose another sleep here.
> +$BTRFS_UTIL_PROG su de $SCRATCH_MNT/snap1
> +sleep 45

That's indicative of a bug, yes?

> +_scratch_unmount
> +
> +# generate a qgroup report and look for inconsistent groups
> +$BTRFS_UTIL_PROG check --qgroup-report $SCRATCH_DEV | grep -q "Counts for qgroup.*different"
> +RETVAL=$?
> +if [ $RETVAL -eq 0 ]; then
> +    status=1
> +fi

RETVAL! Get your RETVAL here! RETVAL!

No need to shout ;)

> new file mode 100644
> index 0000000..b8a146c
> --- /dev/null
> +++ b/tests/btrfs/057.out
> @@ -0,0 +1,7 @@
> +QA output created by 057
> +create file set
> +FSSync '/xfstest2'
> +Create a snapshot of '/xfstest2' in '/xfstest2/snap1'
> +create file set on snapshot
> +Transaction commit: none (default)
> +Delete subvolume '/xfstest2/snap1'

The scratch mountpoint output is what requires filtering - it's
different for everyone, and so needs to anonymised to SCRATCH_MNT....

> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 2da7127..ebc38c5 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -59,3 +59,4 @@
>  054 auto quick
>  055 auto quick
>  056 auto quick
> +057 auto quick

"quick" means the test takes less than a few seconds to execute.
This test takes a couple of minutes, so it should not be in the quick
group.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
