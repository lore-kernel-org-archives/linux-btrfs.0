Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25262 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaLSI37 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 03:29:59 -0500
Date: Fri, 19 Dec 2014 16:29:49 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] xfstests: btrfs: add test case for qgroup account on
 shared extents
Message-ID: <20141219082948.GB10451@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1418723004-30543-1-git-send-email-bo.li.liu@oracle.com>
 <1418805047-24636-1-git-send-email-bo.li.liu@oracle.com>
 <20141218000530.GE15665@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141218000530.GE15665@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 18, 2014 at 11:05:30AM +1100, Dave Chinner wrote:
> On Wed, Dec 17, 2014 at 04:30:47PM +0800, Liu Bo wrote:
> > This is a regression test of
> > 'commit fcebe4562dec ("Btrfs: rework qgroup accounting")'
> > 
> > It can produce qgroup related warnings.
> > 
> > The fix is https://patchwork.kernel.org/patch/5499981/
> > "Btrfs: fix a warning of qgroup account on shared extents"
> ....
> > +#! /bin/bash
> > +# FS QA Test No. 017
> > +#
> > +# Regression of 'commit fcebe4562dec ("Btrfs: rework qgroup accounting")',
> > +# this will throw a warning into dmesg.
> > +#
> > +# For more details, the fix is https://patchwork.kernel.org/patch/5499981/
> > +# "Btrfs: fix a warning of qgroup account on shared extents"
> 
> Please describe the test directly.
> 
> > +
> > +_need_to_be_root
> > +_supported_fs btrfs
> > +_supported_os Linux
> > +_require_scratch
> > +_require_cloner
> > +
> > +run_check _scratch_mkfs "--nodesize 4096"
> > +run_check _scratch_mount
> 
> No, please don't use run_check like this.
> 
> Errors will end up in the output file, and that will cause the test
> to fail.
> 
> > +run_check $XFS_IO_PROG -f -d -c "pwrite 0 8K" $SCRATCH_MNT/foo
> 
> Same - filter the output, and errors will be verbose and cause a
> failure.
> 
> > +
> > +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap
> > +
> > +run_check $CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo-reflink
> > +run_check $CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink
> > +run_check $CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink2
> 
> Filter the output, not "run_check".
> 
> If CLONER_PROG is silent when it fails, then it is broken and needs
> fixing because users need to know that something failed and they
> don't check exit codes.
> 
> > +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> > +_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
> > +
> > +rm -fr $SCRATCH_MNT/* >/dev/null 2>&1
> 
> Don't redirect the output. If an unlink fails, we want to know about
> it.
> 
> > +_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
> 
> What's wrong with "sync"?
> 
> > +$BTRFS_UTIL_PROG qgroup show $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' | $AWK_PROG '{print $2" "$3}'
> 
> You can do regex matches with awk.

Thanks for reviewing this.

Thanks,

-liubo

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
