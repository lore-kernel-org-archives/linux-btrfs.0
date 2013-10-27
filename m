Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:52828 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab3J0Vxt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Oct 2013 17:53:49 -0400
Received: by mail-ee0-f45.google.com with SMTP id c50so3953403eek.32
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Oct 2013 14:53:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEezp7u4-iYN01oXcoodzqsy8_nJPYWL-i0rjFsOc=3C0eSz-g@mail.gmail.com>
References: <20131027100022.4c76e1e7@virtall.com>
	<CAEezp7u4-iYN01oXcoodzqsy8_nJPYWL-i0rjFsOc=3C0eSz-g@mail.gmail.com>
Date: Sun, 27 Oct 2013 22:53:47 +0100
Message-ID: <CAEezp7txuxchURr1DFhFWeFjCG6_07SX78vZCeDz3sxrgz6SVw@mail.gmail.com>
Subject: Re: No space left on device, problem
From: Igor M <igork20@gmail.com>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I made some more tests. Disk is 3TB, first cca 225GB is copied without errors.
Then errors 'No space left on device' begins.
Now if I use rsync with '--bwlimit' option no error occurs or if I
choose 'Retry' in Midnight Commander then continues
and after a while another error occurs and again 'Retry' and so on.

I also noticed something else. Just before this error occurs, write()
call takes a lot longer, I also see that progress stops.
If I do 'btrfs fi df ..' at this moment:

Data: total=114.01GB, used=112.00GB
System, DUP: total=8.00MB, used=20.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=452.93MB
Metadata: total=8.00MB, used=0.00

then error is reported, again 'btrfs fi df ..'

Data: total=114.01GB, used=113.00GB
System, DUP: total=8.00MB, used=20.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=456.98MB
Metadata: total=8.00MB, used=0.00

and then 'Retry' and it goes on, until another error.
Always before error, copying stops and used Data and Metadata changes.
Maybe it's something with allocating metadata. I don't know.

This goes on for cca 25G-30G and from now on no errors anymore.
After this 1.3TB was copied without errors. But some of data was on
rather slow disk, so maybe that's why no more errors.

On Sun, Oct 27, 2013 at 9:50 AM, Igor M <igork20@gmail.com> wrote:
> On Sun, Oct 27, 2013 at 2:00 AM, Tomasz Chmielewski <tch@virtall.com> wrote:
>>> Still no messages. Parameter seems to be active as
>>> /sys/module/printk/parameters/ignore_loglevel is Y, but there are no
>>> messages in log files or dmesg. Maybe I need to turn on some kernel
>>> debugging option and recompile kernel ?
>>> Also I should mention that cca 230G+ data was copied before this error
>>> started to occur.
>>
>> I think I saw a similar issue before.
>>
>> Can you try using rsync with "--bwlimit XY" option to copy the files?
>>
>> The option will limit the speed, in kB, at which the file is being
>> copied; it will work even when source and destination files are on a
>> local machine.
>>
>
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
