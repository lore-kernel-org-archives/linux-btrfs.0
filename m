Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57365 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3J0Iui (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Oct 2013 04:50:38 -0400
Received: by mail-ea0-f174.google.com with SMTP id z15so1579690ead.33
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Oct 2013 01:50:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131027100022.4c76e1e7@virtall.com>
References: <20131027100022.4c76e1e7@virtall.com>
Date: Sun, 27 Oct 2013 09:50:37 +0100
Message-ID: <CAEezp7u4-iYN01oXcoodzqsy8_nJPYWL-i0rjFsOc=3C0eSz-g@mail.gmail.com>
Subject: Re: No space left on device, problem
From: Igor M <igork20@gmail.com>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 27, 2013 at 2:00 AM, Tomasz Chmielewski <tch@virtall.com> wrote:
>> Still no messages. Parameter seems to be active as
>> /sys/module/printk/parameters/ignore_loglevel is Y, but there are no
>> messages in log files or dmesg. Maybe I need to turn on some kernel
>> debugging option and recompile kernel ?
>> Also I should mention that cca 230G+ data was copied before this error
>> started to occur.
>
> I think I saw a similar issue before.
>
> Can you try using rsync with "--bwlimit XY" option to copy the files?
>
> The option will limit the speed, in kB, at which the file is being
> copied; it will work even when source and destination files are on a
> local machine.
>

Also I run strace cp -a ..
...
read(3, "350348f07$0$24520$c3e8da3$fb4835"..., 65536) = 65536
write(4, "350348f07$0$24520$c3e8da3$fb4835"..., 65536) = 65536
read(3, "62.76C52BF412E849CB86D4FF3898B94"..., 65536) = 65536
write(4, "62.76C52BF412E849CB86D4FF3898B94"..., 65536) = -1 ENOSPC (No
space left on device)

Last two write calls take a lot more time, and then last one returns
ENOSPC. But if this write is retryed, then it succeeds.
I tried with midnight commander and when error occurs, if I Retry
operation then it finishes copying this file until error occurs again
at next file.

With --bwlimit it seems to be better, lower the speed later the error
occurs, and if it's slow enough copy is successfull.
But now I'm not sure anymore. I copied a few files with bwlimit, and
now sudenly error doesn't occur anymore, even with no bwlimit.
I'll do some more tests.
