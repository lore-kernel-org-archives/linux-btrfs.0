Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:50451 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046Ab3KZGlL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 01:41:11 -0500
Date: Tue, 26 Nov 2013 17:41:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] xfstests,btrfs: add wrong compress type regression
 test
Message-ID: <20131126064107.GN8803@dastard>
References: <20131125210055.GG8803@dastard>
 <1385445677-27762-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1385445677-27762-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 26, 2013 at 02:01:17PM +0800, Miao Xie wrote:
> Btrfs would crash when the users wrote some data into a file with compress
> flag but the compression of the fs was disabled. This test case is to check
> this bug still happen or not.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> Changlog v1 -> v2:
> - address the commit from Dave Chinner.

Testing every change before posting them for review is a good habit
to develop. This:

> +	$XFS_IO_PROG -f -c "pwrite 0 1M" -c sync $work_file | _filter_xfs_io

will dump this:

wrote 1048576/1048576 bytes at offset 0
XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
command "sync" not found

into the output file and hence the test will fail as the golden
image file in the patch was not updated to match the new test output.

It also points out that "-c sync" command is invalid - the
command to fsync a file is "-c fsync".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
