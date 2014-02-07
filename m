Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34344 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaBGKsy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 05:48:54 -0500
Received: by mail-pd0-f172.google.com with SMTP id p10so2987791pdj.17
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 02:48:53 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v3] Btrfs: add regression test for running snapshot and send concurrently
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20140207044153.GF13647@dastard>
Date: Fri, 7 Feb 2014 18:48:47 +0800
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, jbacik@fb.com
Message-Id: <DE88907C-C829-4555-919E-6B3FB4D9A787@gmail.com>
References: <1391703008-2322-1-git-send-email-wangshilong1991@gmail.com> <20140206224337.GB13647@dastard> <D32F9438-DA80-41AF-9247-A81E6EC90497@gmail.com> <20140207044153.GF13647@dastard>
To: Dave Chinner <david@fromorbit.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Dave,

> On Fri, Feb 07, 2014 at 12:18:31PM +0800, Wang Shilong wrote:
>> 
>> Hi Dave,
>> 
>>> On Fri, Feb 07, 2014 at 12:10:08AM +0800, Wang Shilong wrote:
>>>> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
>>>> +	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1
>>>> +
>>>> +do_snapshots &
>>>> +snapshots_pid=$!
>>>> +
>>>> +$BTRFS_UTIL_PROG send $SCRATCH_MNT/snap_1 > /dev/null 2>&1 || echo "btrfs send failed"
>>> 
>>> Let's stop this anti-pattern before it takes hold.
>>> 
>>> If there's output from the send command it should be
>>> filtered and captured in the golden image. Hence any deviation
>>> caused by errors is automatically flagged as an error.
>>> 
>>> That's the whole point of using golden images for capturing errors -
>>> you don't need to capture return values from binaries and it
>>> guarantees that users are informed about failures through error
>>> messages. IOWs:
>>> 
>>> $BTRFS_UTIL_PROG send $SCRATCH_MNT/snap_1 | _btrfs_send_filter
>>> 
>>> is what you should be doing here.
>> 
>> I knew what you mean here, in fact, i did this on purpose.
> 
> Ok, then you need to explain why you did it on purpose with a comment.
> It's just as important to explain the reason for doing something in
> test code as it is in the kernel code. i.e. so when we are looking
> at the test in 5 years time we know the reason for it being that
> way.
> 
>> for this test failure, btrfs-prog did not output failure
>> information from the beginning. 
> 
> I have nothing good to say about that state of affairs, but...
> 
>> So to make older progs can also
>> detect the test failure, i dropped into this way.
> 
> .. it's going to have to stay like it. Please insert an
> appropriately sarcastic comment about the usefulness of a silent
> send command here, because if I write it I'm going to offend lots of
> people. :/

Sorry, my miss, when i was going to give a patch for btrfs-progs, i noticed
the issue has been fixed in latest btrfs-progs(3.12 which has released for a long time).

So let's drop the way you have said before.

Thanks,
Wang
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

