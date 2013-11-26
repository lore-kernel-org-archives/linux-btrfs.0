Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:29393 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754442Ab3KZHAn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 02:00:43 -0500
Message-ID: <5294475A.3000703@cn.fujitsu.com>
Date: Tue, 26 Nov 2013 15:01:46 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] xfstests,btrfs: add wrong compress type regression
 test
References: <20131125210055.GG8803@dastard> <1385445677-27762-1-git-send-email-miaox@cn.fujitsu.com> <20131126064107.GN8803@dastard>
In-Reply-To: <20131126064107.GN8803@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 26 Nov 2013 17:41:07 +1100, Dave Chinner wrote:
> On Tue, Nov 26, 2013 at 02:01:17PM +0800, Miao Xie wrote:
>> Btrfs would crash when the users wrote some data into a file with compress
>> flag but the compression of the fs was disabled. This test case is to check
>> this bug still happen or not.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>> Changlog v1 -> v2:
>> - address the commit from Dave Chinner.
> 
> Testing every change before posting them for review is a good habit
> to develop. This:
> 
>> +	$XFS_IO_PROG -f -c "pwrite 0 1M" -c sync $work_file | _filter_xfs_io
> 
> will dump this:
> 
> wrote 1048576/1048576 bytes at offset 0
> XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> command "sync" not found
> 
> into the output file and hence the test will fail as the golden
> image file in the patch was not updated to match the new test output.
> 
> It also points out that "-c sync" command is invalid - the
> command to fsync a file is "-c fsync".

Sorry for my miss, please review the 3th one.

Thanks
Miao

> 
> Cheers,
> 
> Dave.
> 

