Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30596 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbcBIVv5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 16:51:57 -0500
Date: Tue, 9 Feb 2016 13:51:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 21/23] xfs: aio cow tests
Message-ID: <20160209215149.GD6350@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
 <20160209011401.23099.38.stgit@birch.djwong.org>
 <20160209083215.GP19486@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160209083215.GP19486@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 09, 2016 at 07:32:15PM +1100, Dave Chinner wrote:
> On Mon, Feb 08, 2016 at 05:14:01PM -0800, Darrick J. Wong wrote:
> .,,,
> > +
> > +echo "Check for damage"
> > +_dmerror_unmount
> > +_dmerror_cleanup
> > +_repair_scratch_fs >> "$seqres.full" 2>&1
> 
> Are you testing repair here? If so, why doesn't failure matter.
> If not, why do it? Or is _require_scratch_nocheck all that is needed
> here?

Uggghhh.... so xfs_repair dumps its regular output to stderr, so the "2>&1"
pushes the output to $seqres.full.

The return codes from xfs_repair seem to be:
0: fs is ok now
1: fs is probably broken
2: log needs to be replayed

The return codes from fsck seem to be:
0: no errors found
1: errors fixed
2: errors fixed, reboot required
(etc)

So I guess the way out is to provide a better wrapper to the repair tools
so that _repair_scratch_fs always returns 0 for "fs should be ok now" and
nonzero otherwise:

_repair_scratch_fs()
{
    case $FSTYP in
    xfs)
        _scratch_xfs_repair "$@" 2>&1
	res=$?
	if [ "$res" -eq 2 ]; then
		echo "xfs_repair returns $res; replay log?"
		_scratch_mount
		res=$?
		if [ "$res" -gt 0 ]; then
			echo "mount returns $res; zap log?"
			_scratch_xfs_repair -L 2>&1
			echo "log zap returns $?"
		else
			umount "$SCRATCH_MNT"
		fi
		_scratch_xfs_repair "$@" 2>&1
		res=$?
	fi
	test $res -ne 0 && >&2 echo "xfs_repair failed, err=$res"
	return $res
        ;;
    *)
        # Let's hope fsck -y suffices...
        fsck -t $FSTYP -y $SCRATCH_DEV 2>&1
	res=$?
	case $res in
	0|1|2)
		res=0
		;;
	*)
		>&2 echo "fsck.$FSTYP failed, err=$res"
		;;
	esac
	return $res
        ;;
    esac
}

> > +echo "CoW and unmount"
> > +"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz * bsz)) 1" "$testdir/file2" >> "$seqres.full"
> > +"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$TEST_DIR/moo" >> "$seqres.full"
> 
> offset = block size times block size?
> 
> I think some better names might be needed...

Yes.  Is now "bufnr" and bufsize=$((blksz * bufnr)).

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
