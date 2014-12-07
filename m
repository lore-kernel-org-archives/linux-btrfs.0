Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:47374 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbaLGTU6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 14:20:58 -0500
Received: by mail-yk0-f175.google.com with SMTP id 200so1698623ykr.20
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Dec 2014 11:20:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAuLxcZJ1VDTrvRtaaXgqUo91sBcBkLYUUTe-_CNLm1zMEZp7g@mail.gmail.com>
References: <m5imaf$s9b$1@ger.gmane.org>
	<CAAuLxcZJ1VDTrvRtaaXgqUo91sBcBkLYUUTe-_CNLm1zMEZp7g@mail.gmail.com>
Date: Sun, 7 Dec 2014 12:20:57 -0700
Message-ID: <CAJCQCtR98rCHHmZ9zjB93znfwEEitGxbnrMzDqRn1wV0sxvi=w@mail.gmail.com>
Subject: Re: Kernel lockup: "fs/btrfs/delayed-inoce.c:1410 btrfs_assert_delayed_root_empty"
From: Chris Murphy <lists@colorremedies.com>
To: andrew.j.wade@gmail.com
Cc: Bernardo Donadio <bcdonadio@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 6, 2014 at 7:45 PM, Andrew Wade <andrew.j.wade@gmail.com> wrote:
> I've had repeated lockups as well; I can trigger them by attempting to
> copy files off of a damaged DVD.
>
> I saw the btrfs_assert_delayed_root_empty warning as well, but not
> during the lockup; instead I saw it on a boot after a lockup.
>
> During the lockup I sometimes get a different message:
>
> Dec  6 19:41:11 pluto kernel: [347280.104032] INFO: task init:1228
> blocked for more than 120 seconds.
> Dec  6 19:41:11 pluto kernel: [347280.104038]       Tainted: G
>    E  3.18.0-rc7-ajw #78
> Dec  6 19:41:11 pluto kernel: [347280.104039] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Dec  6 19:41:11 pluto kernel: [347280.104041] init            D
> ffff88011fc13640     0  1228   1215 0x00000000

Typically a dev will want to see the result of sysrq+w to show details
on the blocked tasks. I suggest reproducing the conditions, then issue
sysrq+w, then recapture dmesg. And also you might look at your own
previous post in the archives and see if it formats legibly because
the result I've got in gmail (above) is wrapping poorly and makes it
hard to read. If you can't figure that out, then it's easier to just
file a bug at bugzilla.kernel.org, and attach the dmesg output as a
text file, then cite the bug URL in this thread.

https://www.kernel.org/doc/Documentation/sysrq.txt


-- 
Chris Murphy
