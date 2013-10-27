Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw6a.wadns.net ([196.220.39.48]:25720 "EHLO fw6a.wadns.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab3J0I4X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Oct 2013 04:56:23 -0400
Message-ID: <526CD523.4090403@swiftspirit.co.za>
Date: Sun, 27 Oct 2013 10:56:03 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Igor M <igork20@gmail.com>, Tomasz Chmielewski <tch@virtall.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device, problem
References: <20131027100022.4c76e1e7@virtall.com> <CAEezp7u4-iYN01oXcoodzqsy8_nJPYWL-i0rjFsOc=3C0eSz-g@mail.gmail.com>
In-Reply-To: <CAEezp7u4-iYN01oXcoodzqsy8_nJPYWL-i0rjFsOc=3C0eSz-g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/10/27 10:50 AM, Igor M wrote:
> On Sun, Oct 27, 2013 at 2:00 AM, Tomasz Chmielewski <tch@virtall.com> wrote:
>>> Still no messages. Parameter seems to be active as
>>> /sys/module/printk/parameters/ignore_loglevel is Y, but there are no
>>> messages in log files or dmesg. Maybe I need to turn on some kernel
>>> debugging option and recompile kernel ?
>>> Also I should mention that cca 230G+ data was copied before this error
>>> started to occur.
>> I think I saw a similar issue before.
>>
>> Can you try using rsync with "--bwlimit XY" option to copy the files?
>>
>> The option will limit the speed, in kB, at which the file is being
>> copied; it will work even when source and destination files are on a
>> local machine.
>>
> Also I run strace cp -a ..
> ...
> read(3, "350348f07$0$24520$c3e8da3$fb4835"..., 65536) = 65536
> write(4, "350348f07$0$24520$c3e8da3$fb4835"..., 65536) = 65536
> read(3, "62.76C52BF412E849CB86D4FF3898B94"..., 65536) = 65536
> write(4, "62.76C52BF412E849CB86D4FF3898B94"..., 65536) = -1 ENOSPC (No
> space left on device)
>
> Last two write calls take a lot more time, and then last one returns
> ENOSPC. But if this write is retryed, then it succeeds.
> I tried with midnight commander and when error occurs, if I Retry
> operation then it finishes copying this file until error occurs again
> at next file.
>
> With --bwlimit it seems to be better, lower the speed later the error
> occurs, and if it's slow enough copy is successfull.
> But now I'm not sure anymore. I copied a few files with bwlimit, and
> now sudenly error doesn't occur anymore, even with no bwlimit.
> I'll do some more tests.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
This sounds to me like the problem is related to read performance 
causing a bork. This would explain why bwlimit helps, as well as why cp 
works the second time around (since it is cached).

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

