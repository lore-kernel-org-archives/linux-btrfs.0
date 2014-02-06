Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59678 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363AbaBFNMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2014 08:12:55 -0500
Received: by mail-pa0-f46.google.com with SMTP id rd3so1652164pab.5
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2014 05:12:55 -0800 (PST)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs: add regression test for running snapshot and send concurrently
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20140203234212.GW13997@dastard>
Date: Thu, 6 Feb 2014 21:12:51 +0800
Cc: xfs@oss.sgi.com, jbacik@fb.com, linux-btrfs@vger.kernel.org
Message-Id: <9BC2AB41-F187-4A1A-89D6-743C72446293@gmail.com>
References: <1391440956-31924-1-git-send-email-wangshilong1991@gmail.com> <20140203234212.GW13997@dastard>
To: Dave Chinner <david@fromorbit.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dave,

> On Mon, Feb 03, 2014 at 11:22:36PM +0800, Wang Shilong wrote:
>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> 
>> Btrfs would fail to send if snapshot run concurrently, this test is to make
>> sure we have fixed the bug.
>> 
> Couple of comments below.
> 
>> +_scratch_mkfs > /dev/null 2>&1
>> +_scratch_mount
>> +
>> +
>> +touch $SCRATCH_MNT/foo
>> +
>> +# get file with fragments by using backwards writes.
>> +for i in `seq 10240 -1 1`; do
>> +	$XFS_IO_PROG -f -d -c "pwrite $(($i * 4096)) 4096" \
>> +	$SCRATCH_MNT/foo > /dev/null | _filter_xfs_io
> 
> Indentation.
> 
>> +done
>> +
>> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
>> +	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1
>> +
>> +$BTRFS_UTIL_PROG send -f $SCRATCH_MNT/send_file \
>> +	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1 &
>> +
>> +pid=$!
>> +
>> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT/snap_1 \
>> +	$SCRATCH_MNT/snap_2 >> $seqres.full 2>&1
>> +
>> +wait $pid || echo "Failed to send, see dmesg"
> 
> This seems kind of racy. It assumes that the send command
> doesn't complete before the wait $pid call is made. If $pid doesn't
> exist at this time because it has completed, wait will return 127
> and the test will fail¡­.

Sorry for delay reply!

Maybe a better idea for this will be:

Opposite to previous way, we do snapshots background while at the
same time we do sending.

And btrfs-progs should output meaningful information on send failure, i will
make a tiny patch to address this issue. but to make this test more friendly, i
think we can still do something like:

btrfs send <..>  || echo "Failed to send"

What do you think of this way?  Feel free to tell me if there are better ideas^_^.

Thanks,
Wang
> Also, why would a failure to send result in meaingful information in
> dmesg? Shouldn't the userspace command output information to tell
> you why there was a failure into $seqres.full?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

